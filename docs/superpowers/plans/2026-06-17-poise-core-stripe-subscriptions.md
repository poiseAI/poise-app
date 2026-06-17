# Poise Core Stripe Subscriptions Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add test-mode Stripe Checkout subscriptions for Poise Core at `$79/month` with a card-required 14-day trial, backend entitlement state, and Flutter upgrade/manage billing surfaces.

**Architecture:** The Go API owns Stripe secret-key calls, webhooks, local billing state, and Core entitlement decisions. Flutter reads that state through `/billing/subscription`, opens hosted Checkout/Portal URLs, and gates Ask Poise and custom Core prompts with the same backend entitlement contract. UI changes follow only the clearly-Figma captures in `pending-tasks/new-screen-updates-16-6-2026`.

**Tech Stack:** Go 1.21, Gin, MariaDB migrations, stripe-go, Flutter, Riverpod, Dio, url_launcher, widget tests.

---

### Task 1: Backend Billing Model And Config

**Files:**
- Create: `C:/dev/strategy-lock/migrations/013_user_billing.sql`
- Modify: `C:/dev/strategy-lock/internal/database/database.go`
- Modify: `C:/dev/strategy-lock/internal/config/config.go`
- Create: `C:/dev/strategy-lock/internal/domain/billing.go`
- Create: `C:/dev/strategy-lock/internal/repository/billing.go`
- Test: `C:/dev/strategy-lock/internal/repository/billing_test.go`

- [ ] **Step 1: Write failing repository tests**

Create `internal/repository/billing_test.go` with a `sqlmock`-backed test for `GetByUserID` empty state and `Upsert` round-trip.

- [ ] **Step 2: Run test to verify it fails**

Run: `go test ./internal/repository -run Billing -v`
Expected: FAIL because the billing repository and dependency are missing.

- [ ] **Step 3: Implement minimal domain, migration, config, and repository**

Add `BillingConfig`, `BillingSubscription`, `BillingStatus`, `CoreEntitled`, migration `013_user_billing.sql`, migration registration, and repository methods `GetByUserID`, `GetByStripeCustomerID`, `GetByStripeSubscriptionID`, `Upsert`, and `EnsureCustomerID`.

- [ ] **Step 4: Run test to verify it passes**

Run: `go test ./internal/repository -run Billing -v`
Expected: PASS.

### Task 2: Backend Stripe Billing Service

**Files:**
- Create: `C:/dev/strategy-lock/internal/service/billing.go`
- Create: `C:/dev/strategy-lock/internal/service/billing_test.go`
- Modify: `C:/dev/strategy-lock/go.mod`
- Modify: `C:/dev/strategy-lock/go.sum`
- Create: `C:/dev/strategy-lock/scripts/create-stripe-core-price.sh`

- [ ] **Step 1: Write failing service tests**

Create service tests with a fake Stripe gateway that verifies checkout uses configured price, customer ID, success/cancel URLs, and `TrialPeriodDays=14`; portal requires an existing customer; entitlement is true for `trialing` and `active`.

- [ ] **Step 2: Run test to verify it fails**

Run: `go test ./internal/service -run Billing -v`
Expected: FAIL because the billing service does not exist.

- [ ] **Step 3: Add stripe-go and implement service**

Run: `go get github.com/stripe/stripe-go/v82`.
Implement a `BillingService` with injected repository and `StripeGateway` interface. Runtime gateway uses Stripe Checkout Sessions, Billing Portal Sessions, Customers, and webhook signature verification.

- [ ] **Step 4: Run test to verify it passes**

Run: `go test ./internal/service -run Billing -v`
Expected: PASS.

### Task 3: Backend Billing Handler And Entitlement Gate

**Files:**
- Create: `C:/dev/strategy-lock/internal/handlers/billing.go`
- Create: `C:/dev/strategy-lock/internal/middleware/entitlement.go`
- Modify: `C:/dev/strategy-lock/internal/handlers/user.go`
- Modify: `C:/dev/strategy-lock/cmd/server/main.go`
- Test: `C:/dev/strategy-lock/internal/handlers/billing_test.go`
- Test: `C:/dev/strategy-lock/internal/handlers/user_test.go`

- [ ] **Step 1: Write failing handler tests**

Test `GET /billing/subscription` empty state, `POST /billing/checkout`, `POST /billing/portal`, webhook invalid signature rejection, and `userResponse` subscription object shape.

- [ ] **Step 2: Run test to verify it fails**

Run: `go test ./internal/handlers -run 'Billing|UserResponse' -v`
Expected: FAIL because handler and response enrichment are missing.

- [ ] **Step 3: Implement handlers and route wiring**

Wire `GET /billing/subscription`, `POST /billing/checkout`, `POST /billing/portal`, and public `POST /api/v1/stripe/webhook`. Enrich `/me`, `/profile`, and auth `user` responses with the `subscription` object.

- [ ] **Step 4: Gate Core-only API routes**

Apply entitlement middleware to AI chat/session routes and reject non-entitled users with HTTP `402` and `code: "core_required"`.

- [ ] **Step 5: Run test to verify it passes**

Run: `go test ./internal/handlers -run 'Billing|UserResponse' -v`
Expected: PASS.

### Task 4: Flutter Billing Client And Auth State

**Files:**
- Create: `C:/dev/poise-ai/lib/features/billing/data/billing_api.dart`
- Create: `C:/dev/poise-ai/lib/features/billing/providers/billing_provider.dart`
- Modify: `C:/dev/poise-ai/lib/features/auth/data/models/auth_response.dart`
- Modify: `C:/dev/poise-ai/lib/features/auth/providers/auth_state.dart`
- Modify: `C:/dev/poise-ai/lib/features/auth/providers/auth_provider.dart`
- Modify: `C:/dev/poise-ai/pubspec.yaml`
- Test: `C:/dev/poise-ai/test/billing_api_test.dart`
- Test: `C:/dev/poise-ai/test/auth_subscription_test.dart`

- [ ] **Step 1: Write failing Flutter data tests**

Test subscription JSON parsing, `/billing/subscription`, checkout URL parsing, portal URL parsing, and `AuthState` subscription propagation.

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/billing_api_test.dart test/auth_subscription_test.dart`
Expected: FAIL because billing client and auth subscription fields are missing.

- [ ] **Step 3: Implement billing data/provider and auth fields**

Add `url_launcher` dependency. Implement `BillingSubscription`, `BillingApi`, `BillingController`, and auth parsing of the backend `subscription` object.

- [ ] **Step 4: Generate code and verify tests**

Run: `dart run build_runner build --delete-conflicting-outputs`
Run: `flutter test test/billing_api_test.dart test/auth_subscription_test.dart`
Expected: PASS.

### Task 5: Flutter Profile, Ask Poise, And Core Upgrade UI

**Files:**
- Modify: `C:/dev/poise-ai/lib/features/profile/screens/profile_screen.dart`
- Modify: `C:/dev/poise-ai/lib/features/ai_chat/screens/ai_chat_screen.dart`
- Modify: `C:/dev/poise-ai/lib/features/ai_chat/data/ai_chat_api.dart`
- Modify: `C:/dev/poise-ai/lib/features/onboarding/screens/set_risk_appetite_screen.dart`
- Test: `C:/dev/poise-ai/test/profile_billing_test.dart`
- Test: `C:/dev/poise-ai/test/ai_chat_core_gate_test.dart`
- Test: `C:/dev/poise-ai/test/set_risk_appetite_screen_test.dart`

- [ ] **Step 1: Write failing widget tests**

Test Profile free/trialing/active billing states, Start trial and Manage billing actions, Ask Poise non-Core upgrade CTA, and Core upgrade sheet starting checkout instead of the old toast.

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/profile_billing_test.dart test/ai_chat_core_gate_test.dart test/set_risk_appetite_screen_test.dart`
Expected: FAIL because the UI does not use billing state yet.

- [ ] **Step 3: Implement UI changes**

Add a compact Profile billing section, Ask Poise Core gate, `core_required` handling, and checkout start from the risk appetite Core sheet. Keep styling aligned to the authoritative Figma captures in `pending-tasks/new-screen-updates-16-6-2026`.

- [ ] **Step 4: Run tests to verify they pass**

Run: `flutter test test/profile_billing_test.dart test/ai_chat_core_gate_test.dart test/set_risk_appetite_screen_test.dart`
Expected: PASS.

### Task 6: Final Verification

**Files:**
- All changed backend and Flutter files.

- [ ] **Step 1: Backend verification**

Run: `go test ./...` in `C:/dev/strategy-lock`.
Expected: PASS.

- [ ] **Step 2: Flutter verification**

Run: `flutter test` in `C:/dev/poise-ai`.
Expected: PASS.

- [ ] **Step 3: Static checks**

Run: `flutter analyze` in `C:/dev/poise-ai`.
Expected: no new errors.

- [ ] **Step 4: Summarize deploy requirements**

Report required env vars, Stripe dashboard webhook path `/api/v1/stripe/webhook`, and Stripe test-card flow.
