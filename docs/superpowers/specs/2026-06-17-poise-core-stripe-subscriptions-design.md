# Poise Core Stripe Subscriptions Design

## Context

The Flutter app currently has profile, Ask Poise AI, onboarding/risk appetite, and notification settings surfaces, but no live subscription or billing source of truth. The Go API exposes authenticated profile and AI chat endpoints, but it does not store Stripe customers, subscriptions, trial state, payment status, or entitlement state. Ask Poise AI is JWT-gated only.

Only visual captures in `pending-tasks/new-screen-updates-16-6-2026` that are clearly Figma captures are authoritative for UI decisions. Other screenshots in `pending-tasks` may be stale or mis-captured and must not drive layout or visual styling.

Poise Core costs `$79/month`. A user who chooses to subscribe starts a 14-day free trial, but must enter a card through Stripe Checkout before the trial begins.

## Goals

- Add Stripe-backed Poise Core subscriptions in test mode.
- Let users start a card-required 14-day trial through Stripe-hosted Checkout.
- Store subscription state in the backend and expose it to Flutter through profile/auth/billing APIs.
- Gate Core-only behavior server-side, especially Ask Poise AI and custom guardrails.
- Add a smooth Billing/Core status surface in Profile and replace placeholder upgrade toasts with real subscription entry points.
- Keep secrets out of source code. Stripe secret keys, webhook secrets, and price IDs live in environment/config only.

## Current Gaps

- No `subscriptions`, `billing`, `plans`, Stripe customer IDs, or entitlement tables exist in the API schema.
- `/me`, `/profile`, registration/login responses, and Flutter `AuthState` do not include subscription status.
- `/ai/chat`, `/ai/chat/confirm`, and AI session history endpoints do not check Core entitlement.
- The Poise Core upgrade sheet in risk appetite currently ends at `Poise Core upgrades are coming soon`.
- Profile has no Billing/Core status row, checkout action, trial state, renewal date, cancellation state, or manage billing action.
- Register copy mentions a 14-day free trial but registration itself does not create or start a trial. That is acceptable after this design: account creation stays free, trial starts only after the user intentionally subscribes.

## Approach

Use Stripe-hosted Checkout for subscription start, Stripe webhooks for durable state, and Stripe Customer Portal for self-service billing.

Backend creates a Checkout Session in `mode=subscription` with one Poise Core price at `$79/month` and `subscription_data.trial_period_days=14`. Because the trial is card-required, Checkout collects payment details before creating the trialing subscription. Flutter opens the returned Checkout URL with the system browser via `url_launcher`, then refreshes billing/profile state after the user returns to the configured app/web success URL.

Backend stores enough local state to make entitlement decisions without calling Stripe on every request. Stripe webhooks update local state for checkout completion, subscription updates, cancellations, trial transitions, failed payments, and deletion.

## Backend Design

### Configuration

Add billing configuration to the Go API:

- `STRIPE_SECRET_KEY` / `SL_STRIPE_SECRET_KEY`
- `STRIPE_WEBHOOK_SECRET` / `SL_STRIPE_WEBHOOK_SECRET`
- `STRIPE_CORE_PRICE_ID` / `SL_STRIPE_CORE_PRICE_ID`
- `STRIPE_SUCCESS_URL` / `SL_STRIPE_SUCCESS_URL`
- `STRIPE_CANCEL_URL` / `SL_STRIPE_CANCEL_URL`
- `STRIPE_BILLING_PORTAL_RETURN_URL` / `SL_STRIPE_BILLING_PORTAL_RETURN_URL`

The supplied test secret and publishable keys are deployment/test environment values, not source-code constants. The backend only needs the secret key. Flutter does not need the publishable key when using hosted Checkout URLs.

If `STRIPE_CORE_PRICE_ID` is not already configured in the Stripe dashboard, add a local setup script that uses the test secret key to create a Poise Core product and recurring monthly price for `7900` cents USD, then prints the price ID for deployment configuration. Runtime code must require the configured price ID rather than creating products or prices on app startup.

### Data Model

Create a `user_billing` table keyed by `user_id`:

- `user_id`
- `stripe_customer_id`
- `stripe_subscription_id`
- `stripe_price_id`
- `plan`: `core`
- `status`: `none`, `incomplete`, `trialing`, `active`, `past_due`, `canceled`, `unpaid`
- `current_period_start`
- `current_period_end`
- `trial_start`
- `trial_end`
- `cancel_at_period_end`
- `checkout_session_id`
- `created_at`
- `updated_at`

Entitlement rule:

- Core access is true when status is `trialing` or `active`.
- Core access remains true for `cancel_at_period_end=true` until `current_period_end` if Stripe still reports `active` or `trialing`.
- Core access is false for `none`, `incomplete`, `past_due`, `canceled`, and `unpaid`.

### API Endpoints

Protected routes:

- `GET /billing/subscription`
  Returns local billing status and entitlement.

- `POST /billing/checkout`
  Creates or reuses a Stripe customer for the authenticated user and returns `{ checkout_url, session_id }`.

- `POST /billing/portal`
  Creates a short-lived Stripe Customer Portal session and returns `{ portal_url }`. If the user has no Stripe customer, return `409` with an upgrade-friendly error.

Public route:

- `POST /api/v1/stripe/webhook`
  Implemented as `api.POST("/stripe/webhook", ...)` in the existing Gin route group. Verifies the Stripe signature and updates local subscription state.

Existing routes to enrich:

- `/me`
- `/profile`
- auth response `user`

Add this `subscription` object:

```json
{
  "subscription": {
    "plan": "core",
    "status": "trialing",
    "entitled": true,
    "trial_end": "2026-07-01T12:00:00Z",
    "current_period_end": "2026-07-01T12:00:00Z",
    "cancel_at_period_end": false
  }
}
```

For users without billing state, return `plan: "none"`, `status: "none"`, `entitled: false`, and null date fields.

### Webhook Events

Handle at minimum:

- `checkout.session.completed`
- `customer.subscription.created`
- `customer.subscription.updated`
- `customer.subscription.deleted`
- `invoice.payment_succeeded`
- `invoice.payment_failed`

Webhook processing must be idempotent and safe to receive events out of order. Subscription events are the primary source for status and period dates.

### Server-Side Gates

Gate these endpoints or actions with Core entitlement:

- `POST /ai/chat`
- `POST /ai/chat/confirm`
- `GET /ai/sessions`
- `GET /ai/sessions/:id`
- `DELETE /ai/sessions/:id`
- custom risk appetite / custom guardrail creation or activation

For blocked Core access, return `402 Payment Required` with:

```json
{
  "error": "Poise Core required",
  "code": "core_required",
  "message": "Start your 14-day Poise Core trial to use this feature."
}
```

## Flutter Design

### Billing Client

Add a billing API/client/provider that can:

- load subscription status
- start Checkout
- open/manage Billing Portal
- refresh state after returning from Stripe

Use the existing Dio, Riverpod, `Result`, and toast patterns.

### Profile Screen

Add a Billing/Core row or compact section aligned to the current Figma capture style:

- Free/no subscription: `Poise Core`, `$79/month`, `14-day trial`, action `Start trial`
- Trialing: `Poise Core trial`, trial end date, action `Manage billing`
- Active: `Poise Core`, renewal date, action `Manage billing`
- Canceling: access until period end, action `Manage billing`
- Past due/unpaid: payment issue copy, action `Manage billing`

The section must follow the existing profile settings density, typography, radius, and restrained white/blue visual language from the authoritative captures.

### Ask Poise AI

If the user is not Core-entitled, the Ask Poise tab shows the existing empty-state style but replaces chat input with a Core upgrade CTA:

- headline stays in the Figma-aligned tone
- short copy: `Start your 14-day Poise Core trial to chat with Poise AI about your trading.`
- primary action opens Checkout

If the user is entitled, chat behaves as today. If the API still returns `core_required`, show the same upgrade CTA rather than a raw error.

### Risk Appetite / Custom Guardrails

Replace the placeholder upgrade toast in the `Custom guardrails need Poise Core` sheet with real checkout start. The sheet remains visually aligned with the `poise-coreupgrade.png` Figma capture in the authoritative folder.

### Return Flow

After Checkout or Portal returns to the configured app/web URL, Flutter refreshes:

- billing provider
- auth provider or `/me` state
- relevant screen state

If the webhook has not arrived yet, the UI can show a short `Activating your trial...` state and retry refresh briefly.

## Security And Operations

- Never commit Stripe or OpenAI secrets.
- Do not log full webhook payloads, secret keys, card details, or bearer tokens.
- Verify webhook signatures before parsing business state.
- Do not rely on client-side state for entitlement.
- Use test keys and Stripe test cards in development.
- Production deployment must set Stripe env vars and configure the webhook endpoint at `/api/v1/stripe/webhook`.

## Testing

Backend tests:

- checkout session creation uses authenticated user, configured price, and 14-day trial
- webhook signature verification rejects invalid signatures
- subscription webhook updates local entitlement to trialing/active/canceled
- `/ai/chat` returns `402 core_required` for non-entitled users
- `/ai/chat` permits trialing/active users
- `/billing/subscription` returns stable empty state for users with no billing row

Flutter tests:

- Profile shows free, trialing, active, canceling, and past-due billing states
- tapping `Start trial` calls checkout endpoint and opens returned URL
- tapping `Manage billing` calls portal endpoint and opens returned URL
- Ask Poise blocks non-Core users with upgrade CTA
- Ask Poise permits Core users to send messages
- Core upgrade sheet starts checkout instead of showing the old placeholder toast

## Out Of Scope

- In-app native PaymentSheet integration.
- Annual pricing, coupons, teams, seats, taxes, or usage-based billing.
- Live Stripe deployment. This design targets test-mode integration first.
- Apple/Google in-app purchase support.
