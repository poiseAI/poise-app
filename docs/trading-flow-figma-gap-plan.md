# Trading Flow and Discipline Settings Figma Gap Plan

Date inspected: 2026-05-30

Figma source: https://www.figma.com/design/QAc0yS2GkBPj6wsBw0SgSU/Poise

## Scope

This plan covers the new Dev Handoff designs for:

- Trade entry and the home-to-trade launch path
- Trade validation, submit confirmation, success, and contextual Poise AI help
- Trades list and trade detail/insight surfaces
- Discipline settings / Risk Appetite in onboarding and profile settings
- Exchange connection screens that gate trading readiness

Out of scope: the existing Paste Signal import flow. The repo feature that matches this is `Paste signal` in `lib/features/trade_entry/screens/trade_entry_screen.dart`. Keep it functional and compatible with the new entry/review state, but do not redesign it as part of this change unless product explicitly says otherwise.

## Implementation Status After First Refactor Pass

Completed in code on 2026-05-30:

- Moved Trade Entry and Trade Validation outside the bottom-navigation shell so both match the full-screen Figma flow.
- Rebuilt Trade Entry as the compact `Open a new trade` experience with balance, pair, risk status, execution mode, margin mode, leverage, TP/SL, long/short, and a sticky review CTA.
- Preserved the existing Paste Signal import UI/flow and kept it feeding the same trade form state.
- Rebuilt Trade Validation around Figma's summary grid, guardrail cards, contextual Poise AI sheet, acknowledgement path, submit confirmation, and `Trade Submitted Successfully` state.
- Added preflight-aware leverage clamping so the entry screen respects both symbol leverage and discipline settings.
- Updated trades list/detail language, active/history tabs, insight labels, and Poise AI follow-up actions.
- Polished Risk Appetite preset selection without changing backend preset values.
- Polished exchange/API connection copy and navigation because this is now a first-class validation blocker.

Second fidelity pass on 2026-05-30:

- Adjusted trade-entry text fields to match Figma's label-above-field layout.
- Updated segmented controls to pill styling with blue active labels.
- Reworked margin/leverage sliders to show visible dot stops like the handoff.
- Simplified the trading-pair sheet to the Figma list pattern instead of a search-first picker.
- Added absolute/percent change formatting in the pair price row.
- Removed the extra validation-page acknowledgement button; acknowledgement now happens through the Poise AI path shown in Figma.
- Replaced the trade submitted success icon with the repo's `success_bag.png` asset, matching the Figma success visual.
- Simplified active-trade cards and added history grouping labels (`Today`, `Yesterday`, date) to better match the Trades handoff.
- Reverted Risk Appetite option cards to Figma's selected-only description pattern.
- Re-aligned exchange connection copy to the Figma wording (`Connect your exchange`, `Link your trading accounts`, `Use desktop instead`).

Third fidelity pass on 2026-05-30:

- Added an explicit source-of-truth rule: not every frame in the Figma file is current. Only clearly named new handoff groups are implementation sources.
- Reworked Home to follow the `Trade Entry Iteration FINAL` home frames: no old balance strip, inline `New Trade`, no old recent-activity position list, and an `Explore more insights` section.
- Rebuilt the no-exchange Home state around the rocket illustration and `Connect Your Exchange` CTA from the final home frame.
- Added the `Choose an exchange` launch sheet from the final trade-entry group and wired the selected exchange through the trade-entry preflight/symbol-loading path.
- Split validation cards into `Risk guardrails check` and `Behavioural Analysis` sections so behavioral warnings no longer render as generic red risk cards.
- Updated the clean validation copy and final confirmation copy to match the new validation frames more closely.
- Moved `Partial`/TP-taken trade statuses into History, matching the new Trades frame where Active Trades shows open rows and History shows partial/closed rows.

Still intentionally deferred:

- Backend-supported contextual AI draft patches beyond the current local `Adjust to $500 margin and proceed` mitigation.
- Product decision on whether Figma preset values replace current strategy defaults.
- Full visual QA on physical devices against every Figma frame.

## Figma Material Inspected

I inspected the Dev Handoff page directly in Figma and captured these local reference screenshots:

- `.artefacts/figma-dev-overview-no-ui.png`
- `.artefacts/figma-trade-entry-final-section.png`
- `.artefacts/figma-trade-entry-frame-main.png`
- `.artefacts/figma-trade-validation-section.png`
- `.artefacts/figma-trade-validation-frame.png`
- `.artefacts/figma-trade-details-section.png`
- `.artefacts/figma-risk-appetite-section.png`
- `.artefacts/figma-set-risk-appetite-section.png`
- `.artefacts/figma-api-connection-section.png`

Source-of-truth rule for implementation:

- Authoritative for this pass: `.artefacts/figma-trade-entry-final-section.png`, `.artefacts/figma-trade-entry-frame-main.png`, `.artefacts/figma-trade-validation-section.png`, `.artefacts/figma-trade-validation-frame.png`, `.artefacts/figma-trade-details-section.png`, `.artefacts/figma-risk-appetite-section.png`, `.artefacts/figma-set-risk-appetite-section.png`, and `.artefacts/figma-api-connection-section.png`.
- Reference-only / do not implement from without product confirmation: generic exported folders such as `.artefacts/screens`, `.artefacts/moreScreens`, and any unlabeled/duplicate frame in Figma that does not sit inside the new handoff groups. These may include older screens.

Key Figma nodes selected during inspection:

- Dev Handoff page: `2:190`
- Trade Entry Iteration FINAL: `2094:20119`
- Trade entry main frame: `2094:23790`
- Trade Validation section: `2094:26861`
- Trade validation main frame: `2094:27113`
- Trade details section: `2094:35582`
- Risk Appetite section: `2094:34947`
- Set Risk Appetite section: `2094:19845`
- API connection section: `2094:32943`

## Current Implementation Map

Trade entry was implemented as a progressive multi-card form before this pass. It has now been migrated toward the compact Figma single-screen flow:

- `lib/features/trade_entry/screens/trade_entry_screen.dart`
  - New full-screen app bar/title and sticky review bar
  - Balance, pair, risk status, execution, margin, leverage, TP/SL, and direction panels
  - Paste Signal sheet and parser UI preserved in the same file

Trade state and API contract:

- `lib/features/trade_entry/providers/trade_form_provider.dart`
  - Enums/state: lines 16-68
  - Preflight and setters: lines 77-207
  - Validation, draft payload, submit: lines 405-554
- `lib/features/trade_entry/data/trade_api.dart`
  - `/trade/preflight`, `/exchange/balance`, `/trade/validate`, `/trade/submit`: lines 18-68
  - `TradePreflight` and `TradeValidationResult`: lines 79-324

Trade validation has been rebuilt from a generic review/execute screen into the Figma-style validation flow:

- `lib/features/trade_entry/screens/trade_validation_screen.dart`
  - Summary metric grid
  - Guardrail cards with `Ask Poise AI`
  - Contextual Poise AI mitigation sheet
  - Submit confirmation and submitted success state

Navigation:

- `lib/core/router/app_router.dart`
  - `Routes.trade` and `Routes.tradeValidation` now sit outside the shell route so they do not render bottom navigation.

Trades:

- `lib/features/orders/screens/orders_screen.dart`
  - Trades list and tabs: start of file through `_OrdersHeader`
  - Order detail `Trade Info` and `Insights` tabs: `_OrderDetailsScreen`, `_TradeInfoTab`, `_TradeInsightsTab`, `_InsightsContent`
- `lib/features/orders/data/models/order.dart`
- `lib/features/orders/data/orders_api.dart`

Discipline settings:

- `lib/features/onboarding/screens/set_risk_appetite_screen.dart`
  - Preset definitions: lines 37-176
  - Settings summary: lines 236-286
  - Select flow: lines 288-363
  - Confirm/customize flow: lines 365-431
  - Custom fields: lines 733-897
- `lib/features/strategies/data/models/strategy.dart`

Profile/exchange:

- `lib/features/profile/screens/profile_screen.dart`
  - Profile list and settings links: lines 63-151
  - Exchange connections: lines 757-1228
  - Security, Notifications, Data & Privacy later in same file

## Figma Observations

### 1. Trade Entry Is Now A Compact Single-Screen Flow

The Figma target screen title is `Open a new trade`, not `New Trade`.

The visible order is:

1. Back arrow and title.
2. Available balance row: `Available balance:` with `43,250 USD`.
3. Trading pair selector row:
   - Orange BTC icon
   - `BTC/USDT`
   - `Futures`
   - Current price `68.08`
   - Positive change `+2.899/+7.98%`
4. `Risk status` card:
   - `Risk per trade: 2%`
   - `Max leverage: 10x`
   - `Trades today: 2 / 5`
5. `Execution mode` segmented control:
   - `Market execution`
   - `Price limit`
6. Limit price field shown when price limit is selected.
7. `Margin` segmented control:
   - `Percentage`
   - `Fixed amount`
8. Margin percentage slider with dot steps and labels, or fixed amount field.
9. Leverage slider with dot steps and current value label.
10. TP/SL panel:
    - `Stop Loss`
    - `Take Profit`
    - `Add TP?` / `Remove TP?` state for TP2
    - `Automatic Stop Loss progression` toggle
11. Two side buttons:
    - Green `Buy/Long`
    - Red `Sell/Short`
12. Bottom `Review trade` button, disabled until required fields are valid.

The trading pair selector is a modal/bottom-sheet style list titled `Select trading pair`, with repeated `BTC/USDT` rows in the mock and a close icon.

Notably absent from the new trade-entry design:

- No visible Isolated/Cross collateral mode choice.
- No quantity amount mode.
- No card-by-card progressive reveal.
- No visible Paste Signal action in the main entry screen.

### 2. Home Launch And Exchange Gating Are Part Of The New Flow

The Trade Entry Iteration section includes home states:

- A no-exchange home state with a rocket image and CTA `Connect Exchange`.
- A home dashboard with `Today`, `Weekly`, `Custom` tabs, adherence score, PnL, `New Trade`, costly mistake, opportunity cost, adherence breakdown, guardrail status, and insight cards.
- A `Choose an exchange` modal with `Bybit` and `Binance` before trading if the preferred exchange has not been chosen/connected.

This means the trading flow should not start in isolation. It needs clear behavior for:

- No exchange connected
- Exchange connected but multiple exchanges available
- Exchange selected, balance/preflight ready

### 3. Trade Validation Is Now A Guardrail Resolution Flow

The Figma validation title is `Trade validation`.

The main layout is:

1. Summary section with a grid:
   - `Risk` -> `2.50%`
   - `Position Size` -> `$50.00`
   - `Risk-to-Reward Ratio` -> `1:3:5`
   - `Possible Loss` -> `-$125.00`
   - Full-width `Possible Profit` -> `+$437.50`
2. `Risk guardrails check`
3. Guardrail cards, each with:
   - Warning icon
   - Title such as `Correlated Asset Exposure`
   - Message such as `High correlation detected with existing positions`
   - CTA `Ask Poise AI`
4. `Behavioural Analysis` / `Behavioral Analysis` cards in later validation states.
5. Bottom `Submit trade` button.

There are multiple states:

- Initial validation with blocking or warning cards and disabled `Submit trade`.
- Contextual `Poise AI` bottom sheet launched from `Ask Poise AI`.
- AI messages explain why the trade is risky.
- Suggestion chips/buttons appear, for example `Suggest a lower risk size.` and `Adjust to $500 margin and proceed`.
- After a user accepts a mitigation/adjustment, `Submit trade` becomes enabled.
- A final confirmation modal asks the user to confirm use of remaining daily loss limit, with `Go back` and `Submit trade`.
- Success state says `Trade Submitted Successfully` and uses a padlock/bag illustration with CTA `View trade`.
- A clean pass state exists with `No guardrails triggered` and `Submit trade` enabled.

Current code only has a static guardrail review card plus a generic `Continue anyway?` dialog. It does not model per-guardrail AI actions, adjusted trade state, or final daily-limit confirmation as separate UI states.

### 4. Trades List And Trade Detail Have Been Tightened

Figma target for list:

- Page title `Trades`.
- Segmented tabs: `Active Trades` and `History`.
- Active section label: `Active positions`.
- Each row shows side, symbol, PnL, status pill, and chevron.
- Sticky/floating `+ New Trade` CTA.
- Bottom nav labels: `Home`, `Poise AI`, `Trades`, `Profile`.

Figma target for details:

- Page title `Trade details`.
- Tabs: `Trade Info` and `Insights`.
- Trade Info:
  - Header with side/symbol/status and `Realized PnL +$420.76`.
  - Data rows for source, exchange, execution mode, margin used, position size, entry price, exit price, stop loss price, take profit price, open time, close time.
  - `Behavioural Analysis` cards such as `Correlated Asset Exposure`.
- Insights:
  - `Adherence Score` with score `45 of 100`.
  - AI Summary card with actions `Chat with Poise AI` and `Explain better`.
  - `Opportunity cost` card, e.g. `Stop Loss Violation`, `-$85`, `Added loss`.
  - `Today's adherence` donut with discipline metrics.
- Contextual Poise AI detail flow mirrors the validation chat pattern and can suggest trade adjustments.

The current orders implementation has a similar shell, but the content hierarchy, labels, row grouping, and contextual AI actions do not match the Figma target.

### 5. Risk Appetite / Discipline Settings Are Mostly Present But Need Exact Layout And Copy

The Figma target appears in both onboarding and profile settings.

Profile settings flow:

- Profile page has settings rows:
  - `Exchange Connections`
  - `Risk Appetite`
  - `Security`
  - `Notification`
  - `Data & Privacy`
  - `Log out`
  - `Delete Account`
- `Risk Appetite` summary screen:
  - Copy: `Your Risk Appetite determines the trading rules (Conservative, Balanced, Aggressive, or Custom) that Poise enforces to align every trade with your chosen tolerance.`
  - Summary card for current risk profile.
  - `Edit risk settings` inside the card.
  - Bottom `Change risk appetite` button.
- `Change risk appetite` screen:
  - Copy: `Each risk appetite has specific trading rules that dictate how Poise enforces limits and guardrails.`
  - Options: `Conservative`, `Balanced`, `Aggressive`, `Customizable`
  - Continue disabled until selection.
- `Confirm configuration` for presets:
  - Selected preset name highlighted in copy.
  - Blue-outline card with rows.
  - CTA `Confirm and save` in settings, `Confirm` in onboarding.
- Custom flow:
  - Title `Customize risk settings`.
  - Copy: `Fine-tune your risk settings to align with your investment preferences and trading style.`
  - Fields:
    - Percentage risk per trade
    - Max leverage per asset
    - Max trades per day
    - Daily maximum loss
    - Weekly Maximum loss
    - Maximum concurrent open positions
    - Maximum consecutive losses in a day
  - Help icons beside fields.
  - Sticky confirm button.

Important discrepancy: visible Figma preset values differ from the current hardcoded request values in `set_risk_appetite_screen.dart`. For example, the Figma Aggressive preset visibly shows `Percentage risk per trade` as `10%` and `Daily maximum loss` as `$5,000`, while current code uses `2%` risk per trade and `5% of balance` daily loss for Aggressive. This should be treated as a product/API decision before changing business defaults.

### 6. Exchange Connection Flow Is Close But Needs Visual/Copy Alignment

The Figma API connection flow contains:

- Title `Connect exchange`
- Subtitle `Link your trading accounts`
- `Skip`
- Desktop setup card:
  - `Prefer using a computer?`
  - `Connect exchange securely on desktop`
  - `Use desktop instead`
- Exchange accordion rows for Bybit and Binance.
- Connected pills.
- Inline API key / Secret key fields.
- Help sheet: `Get API from Bybit` / `Get API from Binance` with numbered steps and `I understand`.
- Disconnect confirmation sheets with `No` and `Disconnect`.

Current implementation already has most of these behaviors, so this should be a polish/alignment pass rather than a rewrite.

## Main Gaps And Required Changes

| Area | Figma target | Current code | Required change |
| --- | --- | --- | --- |
| Trade entry layout | One compact screen with all primary controls visible | Progressive cards revealed by touched state | Replace screen structure with single scroll view matching Figma order |
| App title | `Open a new trade` | `New Trade` | Rename and adjust app bar spacing |
| Pair selector | Dedicated row plus bottom sheet | `SymbolPicker` inside first card | Restyle `SymbolPicker` or create `TradePairSelector` matching row and sheet |
| Risk status | Inline preflight card near top | Preflight data mostly hidden in validation/status | Add `RiskStatusCard` using `TradePreflight` |
| Execution mode | `Market execution` / `Price limit` segmented pill | `Market` / `Limit` choice cards | Replace choice cards with segmented control and copy |
| Margin | Percentage / Fixed amount only | `$ Margin` / `% Balance` / `Quantity` | Hide quantity from normal UI; keep internally for Paste Signal compatibility if needed |
| Collateral | Not visible | Isolated/Cross cards | Remove from main visible form or move to advanced/default configuration |
| Leverage | Slider with dot stops | Dropdown | Build/reuse slider component with stops and max from preflight/symbol |
| TP/SL | Stop Loss first, Take Profit, Add/Remove TP2, automatic SL progression | TP first, profit trailing, stop loss last | Reorder and relabel |
| Direction | Bottom green/red pill buttons | Separate direction choice card section | Move to bottom of form before review CTA |
| Review CTA | `Review trade` | `Review setup` | Rename and match enabled/disabled states |
| Validation title | `Trade validation` | `Review & Execute` | Rename |
| Validation summary | 2-column summary grid plus full-width profit | Hero card + separate outcome cards | Replace with summary grid |
| Guardrails | Per-item cards with `Ask Poise AI` | Aggregated guardrail block | Render guardrail list with item actions |
| AI flow | Contextual bottom sheet with suggestions and actions | Full Poise AI screen only | Add reusable contextual AI sheet/session surface |
| Warning override | Final confirmation modal with concrete daily-limit copy | Generic `Continue anyway?` alert | Replace with specific confirmation using validation summary data |
| Success | `Trade Submitted Successfully`, `View trade` | `Trade Executed`, `View in Orders`, `New Trade` | Replace success copy/layout/CTA |
| Trade validation route | Full-screen, no bottom nav | Currently inside `ShellRoute` | Move route outside shell or use parent navigator to hide nav |
| Trades tabs | `Active Trades` / `History` | `Open` / `History` | Rename and regroup list |
| Trade details | Figma row hierarchy and AI actions | Similar but not exact | Update cards, insight sections, and contextual AI entry points |
| Risk appetite | Same flow but exact copy/cards/field behavior | Similar flow with different copy and presets | Align layout/copy; confirm preset values |
| Exchange connection | Mostly same but exact polish | Mostly implemented | Align card copy, accordions, help sheet, connected/disconnect states |

## Implementation Plan

### Phase 1 - Navigation And Shared UI Primitives

1. Move `Routes.tradeValidation` out of the shell route in `lib/core/router/app_router.dart` so the validation screens do not show bottom navigation.
2. Add shared UI components rather than reimplementing controls inside each screen:
   - `PillSegmentedControl`
   - `SteppedSlider`
   - `RiskStatusCard`
   - `TradeMetricTile`
   - `TradeSummaryGrid`
   - `GuardrailActionCard`
   - `ContextualPoiseSheet`
   - `RiskRuleSummaryCard`
   - `RiskSettingsInput`
3. Keep radii at the existing 8px card standard unless Figma clearly uses pill/full radius for buttons and segmented controls.
4. Keep `AppColors.primary` and existing token names, but audit spacing and typography against the Figma screens. The code already has the right brand blue family and Inter typography.

### Phase 2 - Trade Entry Rebuild

Target files:

- `lib/features/trade_entry/screens/trade_entry_screen.dart`
- `lib/features/trade_entry/screens/widgets/symbol_picker.dart`
- `lib/features/trade_entry/providers/trade_form_provider.dart`

Steps:

1. Replace the current progressive `_FormBlock` list with a single ordered form matching the Figma screen.
2. Preserve existing provider fields where possible:
   - `symbol`
   - `orderType`
   - `limitPrice`
   - `marginMode`
   - `marginValue`
   - `leverage`
   - `takeProfit1`
   - `takeProfit2`
   - `slPrice`
   - `autoStopLossProgression`
   - `side`
3. Keep `AmountInputMode.quantity` in state for Paste Signal compatibility, but remove it from the normal visible trade-entry control unless product asks for an advanced option.
4. Default `collateralMode` to isolated and hide Isolated/Cross from the main UI unless the API still requires visible selection.
5. Replace `_LeverageDropdown` with `SteppedSlider`.
6. Replace amount section with Figma `Percentage` / `Fixed amount` segmented control.
7. Reorder TP/SL to Stop Loss, Take Profit, optional TP2, automatic stop loss progression.
8. Move `Buy/Long` and `Sell/Short` near the bottom and make them compact pill buttons with check states.
9. Rename the CTA to `Review trade`.
10. Keep `_openSignalImporter`, `_SignalImporterSheet`, and parser logic. After parsing, mapped values should populate the new form and route to the same validation screen.

### Phase 3 - Trade Validation And Contextual AI

Target files:

- `lib/features/trade_entry/screens/trade_validation_screen.dart`
- `lib/features/trade_entry/data/trade_api.dart`
- `lib/features/trade_entry/providers/trade_form_provider.dart`
- `lib/features/ai_chat/*` for reusable chat pieces

Steps:

1. Replace `_ReviewHero`, `_OutcomeReview`, and `_GuardrailReview` with Figma sections:
   - `Summary`
   - `Risk guardrails check`
   - `Behavioral Analysis`
2. Extend or adapt `TradeValidationResult` to preserve enough structure for per-card rendering:
   - stable guardrail id
   - title
   - message
   - severity
   - category (`risk_guardrail`, `behavioral_analysis`, etc.)
   - `ai_prompt`
   - resolved/acknowledged/adjusted state
   - optional proposed action label and patch
3. Reuse `GuardrailResult.aiPrompt`, but do not rely on title/message parsing for behavior.
4. Add `ContextualPoiseSheet` launched by each `Ask Poise AI`.
5. Connect AI suggestions to draft mutations:
   - `Adjust to $500 margin and proceed` should update `marginValue` and re-run validation.
   - `Suggest a lower risk size` should ask AI for an action, not merely open generic chat.
6. Replace generic `_confirmGuardrailOverride` with a confirmation modal that uses validation facts, e.g. daily loss limit percentage/remaining budget.
7. Rename submit CTA to `Submit trade`.
8. Replace success screen copy and CTA:
   - `Trade Submitted Successfully`
   - `Your trade order has been successfully submitted. Tap below to check the trade status.`
   - `View trade`

Backend/API work likely needed:

- `/trade/validate` should return card-ready guardrails and behavioral analysis.
- `/trade/submit` should support submitting an adjusted draft after validation.
- AI endpoint should be able to start a contextual session tied to guardrail/trade draft and return actionable suggestions.

### Phase 4 - Trades List And Details

Target files:

- `lib/features/orders/screens/orders_screen.dart`
- `lib/features/orders/data/models/order.dart`
- `lib/features/orders/data/orders_api.dart`

Steps:

1. Rename list tabs to `Active Trades` and `History`.
2. Group history by date buckets: `Today`, `Yesterday`, and explicit dates.
3. Restyle cards to match Figma:
   - side label
   - symbol
   - PnL
   - status pill
   - chevron
4. Keep floating `+ New Trade`, but match Figma height, color, and placement.
5. Update details:
   - `Trade Info` tab exact rows and card grouping.
   - Behavioral Analysis cards.
   - `Insights` tab with score, AI Summary, opportunity cost, adherence donut, and discipline metric cards.
6. Add contextual AI entry points from details:
   - `Chat with Poise AI`
   - `Explain better`
7. Extend `OrderInsights` if the backend can return:
   - `discipline_breakdown`
   - `opportunity_cost.label/value/status`
   - `ai_summary`
   - behavioral analysis cards
   - suggested prompts/actions

### Phase 5 - Risk Appetite / Discipline Settings

Target files:

- `lib/features/onboarding/screens/set_risk_appetite_screen.dart`
- `lib/features/strategies/data/models/strategy.dart`
- `lib/features/profile/screens/profile_screen.dart`

Steps:

1. Keep the existing mode split: onboarding vs settings.
2. Align copy and layout to the Figma screens.
3. Align summary and confirm cards:
   - Blue outline on selected card.
   - `Edit risk settings` inside summary.
   - Bottom `Change risk appetite`.
4. Use the exact option labels:
   - `Conservative`
   - `Balanced`
   - `Aggressive`
   - `Customizable`
   - Summary display can remain `Custom` for the custom profile if desired, matching Figma.
5. Keep and polish the custom fields already present.
6. Add/keep help icons for each editable risk setting.
7. Disable confirmation until all required numeric fields are valid.
8. Product decision needed before changing preset business values. Figma-visible values do not match current hardcoded values.

### Phase 6 - Exchange Connection Polish

Target files:

- `lib/features/profile/screens/profile_screen.dart`
- `lib/features/profile/widgets/exchange_setup_sheet.dart`
- `lib/features/profile/data/profile_api.dart`

Steps:

1. Align title/subtitle/copy exactly:
   - `Connect exchange`
   - `Link your trading accounts`
   - `Prefer using a computer?`
   - `Connect exchange securely on desktop`
2. Keep Bybit/Binance accordion behavior.
3. Match connected state pills and collapsed/expanded layout.
4. Match API help sheets for Bybit/Binance.
5. Match disconnect sheet wording and buttons.
6. Ensure onboarding `Continue` remains available after skip/connection according to product policy.

## Data And API Contract Notes

These are the specific data gaps surfaced by the Figma designs:

1. Trade preflight must provide all values used in the entry top card:
   - available balance and currency
   - risk per trade percent
   - max leverage
   - trades today
   - max trades per day
   - preferred/connected exchange state
2. Symbol search must support the trading pair sheet and price row:
   - symbol display name
   - base/quote
   - market type (`Futures`)
   - last price
   - absolute and percent change
3. Validation must return a UI-ready summary:
   - risk percent
   - position size
   - risk-to-reward ratio
   - possible loss
   - possible profit
4. Validation must return per-card guardrails:
   - id
   - title
   - message
   - severity
   - category
   - `ask_ai_prompt`
   - blocking/resolved state
5. Contextual AI must support draft actions:
   - explain issue
   - suggest mitigation
   - apply mitigation to trade draft
   - revalidate after action
6. Orders/insights must support Figma details:
   - adherence score and label
   - AI summary
   - opportunity cost
   - discipline metric breakdown
   - behavioral analysis cards

## Testing And QA Plan

Recommended tests:

- Widget test for trade entry initial state and disabled `Review trade`.
- Widget test for percentage vs fixed amount margin states.
- Widget test for TP2 add/remove.
- Provider test for `draftJson` after Figma-normal trade entry inputs.
- Provider test for Paste Signal still populating the new form.
- Widget test for validation with no guardrails, warning guardrails, blocking guardrails, and adjusted AI state.
- Router test proving trade validation has no bottom nav.
- Widget test for risk appetite preset selection and custom field validation.
- Model tests for any new validation/insight JSON fields.

Manual QA matrix:

- No exchange connected -> home/connect exchange path.
- Exchange connected -> trade entry preflight loads.
- Market execution -> no limit field required.
- Price limit -> limit field required.
- Percentage margin -> amount derived from balance.
- Fixed amount -> raw amount submitted.
- Long/short validation changes SL/TP direction rules.
- Guardrail warning -> Ask Poise AI -> suggestion -> adjusted draft -> submit enabled.
- Final submit confirmation -> success -> View trade.
- Paste Signal import -> review path still works.
- Risk Appetite onboarding -> confirm -> success -> exchange connection.
- Risk Appetite profile settings -> summary -> change -> confirm/save.

## Open Product Decisions

1. Does "past signal UI/flow" mean the existing Paste Signal import flow? I treated it as out of scope and to be preserved.
2. Should collateral mode be hidden entirely, fixed to isolated, or moved behind an advanced setting? Figma does not expose Isolated/Cross.
3. Should quantity-based sizing remain available anywhere besides Paste Signal parsing? Figma only shows Percentage and Fixed amount.
4. Which preset risk values are authoritative? Current code and Figma differ.
5. Should validation warnings block submit until AI is consulted, until acknowledged, or only when a mitigation is accepted? Figma shows disabled submit in warning states and enabled submit after an AI/acknowledgement path.
6. What exact API response should power `Adjust to $500 margin and proceed`? This should be a typed draft patch, not free-text parsing.
7. Should `Trade Submitted Successfully` mean exchange order accepted, Poise submitted but pending, or local validation complete? The current copy says executed; Figma says submitted.

## Suggested Build Order

1. Move validation route outside bottom nav and add shared primitives.
2. Rebuild trade entry UI while preserving current provider/API behavior.
3. Update validation UI using current `TradeValidationResult`.
4. Add enhanced guardrail/AI data contract once backend support exists.
5. Update success screen and trades list/details.
6. Align Risk Appetite settings and onboarding.
7. Polish Exchange Connection screens.
8. Run tests and mobile visual QA against the Figma screenshots.
