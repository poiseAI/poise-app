Continue with completing the poiseAI app implementation based on the reference plan below

# Poise AI — Final Implementation Plan (Refined)

## Context

The Flutter app at `C:\dev\poise-ai` and Go backend at `C:\dev\strategy-lock` are partly built. `flutter analyze` is clean and most screens render, but a deep audit reveals:

1. **Backend AI endpoints do not exist.** The Flutter `AiChatApi` POSTs `/ai/chat` but the Go server has zero `/ai/*` routes registered, no LLM SDK in `go.mod`, and no AI handler/service files. The "Poise AI" hero feature is a dead client.
2. **Several Flutter feature dirs are empty shells:** `features/orders/` is missing entirely; `features/positions/providers/`, `features/risk/providers/`, `features/strategies/data/models|providers/`, `features/profile/data|screens/` are all empty. Memory falsely marked these complete.
3. **Asset pipeline is bare.** `pubspec.yaml` declares the Inter font in 4 weights, but `assets/fonts/` is empty — Inter never loads, so `FontFeature.tabularFigures()` (the entire reason Inter was chosen) silently does nothing. `assets/animations/` is empty so all Lottie callouts in the plan (#11, #21, #43, #49, #51, #52, #63) cannot fire.
4. **UI consistency leaks.** ~5 hardcoded `BorderRadius.circular(N)` and a handful of inline `EdgeInsets` numbers bypass `AppRadius` / `AppSpacing` tokens (chat bubbles, onboarding cards, position card menu, WS banner). Tokens themselves are well-built and used ~90% of the time.
5. **Library decisions to make.** Three candidates in pubspec are unused (`reactive_forms`, `lottie`, `syncfusion_flutter_charts`). Syncfusion is commercial-licensed with revenue caps that are risky for a fintech.

This plan closes those gaps using **researched library choices** (avoid reinventing) and a **single-source design system** (avoid UI regression).

---

## Decisions locked in

| Concern | Choice | Reason |
|---|---|---|
| LLM provider abstraction | `sashabaranov/go-openai` v1.41.2 (Apache-2.0, 10.6k★) behind a thin `LLMProvider` interface | DeepSeek is OpenAI-compatible — one-line `BaseURL` override. Exposes raw `Delta.ToolCalls[]` for SSE streaming. langchaingo/eino/genkit hide tool-call deltas. |
| Default provider | DeepSeek primary, OpenAI fallback | Cheaper inference, same SDK, env-switchable. |
| Anthropic Claude | Add `anthropics/anthropic-sdk-go` later behind same `LLMProvider` interface | Future-proof without extra wiring now. |
| SSE wire format | Hand-rolled (`event:`/`data:`/blank line + `Flusher.Flush()`) | 6 lines of code; no dep needed for 5 event types. |
| Toast lib | `toastification: ^3.2.0` | 1.25k likes, active. PToast becomes a wrapper for API stability. |
| Skeleton lib | `skeletonizer: ^2.1.3` | 2.29k likes. Auto skeletons from real layout — eliminates layout-shift bugs in PPositionCardShimmer. |
| Bottom sheet lib | `smooth_sheets: ^0.17.0` (user-specified) | Multi-page + draggable sheets. Replaces raw `showModalBottomSheet`. |
| Charts | Swap `syncfusion_flutter_charts` → `fl_chart: ^1.2.0` (MIT) | Removes commercial license risk for fintech. No charts wired yet so swap is cheap. |
| Dark mode | Deferred. Tokens stay; no screen-level rewrite this pass. | Scope control — ship light, audit later. |
| Forms | Keep `reactive_forms: ^17.0.1` (already in pubspec) for Trade Entry only | Manual controllers fine elsewhere; reactive_forms earns its keep on multi-field validation. |
| SSE on Flutter side | Keep current manual `LineSplitter` over Dio | `flutter_client_sse` is stale (20 months); `dio_sse_converter` does not exist on pub.dev. |
| Radial position-card menu | Hand-roll with `Stack` + `flutter_animate` | `flutter_radial_menu` is 8-year-old Dart-1 abandonware. |

---

## Critical files to create or modify

### Backend (`C:\dev\strategy-lock`)

| Path | Action | Purpose |
|---|---|---|
| `go.mod` | add deps | `github.com/sashabaranov/go-openai v1.41.2` |
| `internal/config/config.go` | extend | `LLM` struct: `Provider`, `APIKey`, `BaseURL`, `Model`, `FallbackProvider`, `FallbackAPIKey`, `FallbackBaseURL`, `FallbackModel` |
| `config.yaml` | extend | `llm:` block with sane defaults; secrets via env (`LLM_API_KEY`, `LLM_FALLBACK_API_KEY`) |
| `internal/service/llm/provider.go` | new | `LLMProvider` interface: `StreamChat(ctx, messages, tools) <-chan LLMEvent`. Unifies OpenAI + DeepSeek + (future) Anthropic deltas. |
| `internal/service/llm/openai_adapter.go` | new | Wraps `go-openai` client; works for both OpenAI + DeepSeek by switching `BaseURL`. |
| `internal/service/llm/types.go` | new | Sealed `LLMEvent`: `TextDelta`, `ToolCallDelta`, `Done`, `Error` |
| `internal/service/ai_chat_service.go` | new | Session orchestration. Loop: call LLM → stream deltas → if `requires_confirmation` tool, pause and wait for confirm endpoint → on confirm, execute tool via existing services → feed result back to LLM → continue. |
| `internal/service/ai_tools.go` | new | 12 tool definitions wrapping existing services: `get_positions`, `get_orders`, `get_portfolio_risk`, `get_token_risk`, `search_symbols`, `get_pnl_summary`, `place_order`, `close_position`, `set_tpsl`, `request_exit`, `lock_position`, `get_strategy`. **Always inject userID from JWT context — never trust LLM-supplied user identity.** |
| `internal/service/ai_tools_registry.go` | new | Maps tool name → executor func + flag `requiresConfirmation bool`. Destructive: `place_order`, `close_position`, `request_exit`, `set_tpsl`, `lock_position`. |
| `internal/repository/ai_session_repo.go` | new | CRUD for `ai_sessions`, `ai_messages`, `ai_pending_confirmations` tables |
| `migrations/0XX_ai_chat.sql` | new | 3 tables + indexes on `(user_id, created_at)` |
| `internal/handlers/ai_handler.go` | new | `POST /ai/chat` SSE handler. Sets `Content-Type: text/event-stream`, `Cache-Control: no-cache`, `X-Accel-Buffering: no`, uses `c.Writer.Flush()` per event. `POST /ai/chat/confirm`. `GET /ai/sessions`. `GET /ai/sessions/:id`. `DELETE /ai/sessions/:id`. |
| `cmd/server/main.go` | edit | Wire `LLMProvider`, `AIChatService`, `AIChatHandler`. Register routes under `authorized` group. |

### Flutter (`C:\dev\poise-ai`)

| Path | Action | Purpose |
|---|---|---|
| `pubspec.yaml` | edit | Remove `syncfusion_flutter_charts`. Add `fl_chart: ^1.2.0`, `toastification: ^3.2.0`, `skeletonizer: ^2.1.3`, `smooth_sheets: ^0.17.0`. |
| `assets/fonts/Inter-{Regular,Medium,SemiBold,Bold}.ttf` | new files | Drop OFL Inter from Google Fonts. Without this, tabular figures silently fail. |
| `assets/animations/{padlock_open,success_check,empty_inbox,confetti,pull_refresh}.json` | new files | LottieFiles. Wired into existing screens that already reference them (#21, #43, #49, #51, #52, #63). |
| `assets/images/poise_logo.svg` | new | Welcome screen logo |
| `lib/core/theme/app_radius.dart` | edit | Add `bubbleRadius`, `menuRadius` semantic tokens to retire hardcoded `circular(4)`/`circular(16)` in chat bubbles + position card menu. |
| `lib/features/ai_chat/screens/widgets/chat_bubbles.dart` | edit | Replace hardcoded `Radius.circular(4)`/`circular(16)` with `AppRadius.bubbleRadius`. |
| `lib/features/onboarding/screens/set_risk_appetite_screen.dart` | edit | Replace inline `BorderRadius.all(Radius.circular(8))` (lines 154, 162) with `AppRadius.md`. |
| `lib/features/home/screens/widgets/position_card.dart` | edit | Replace hardcoded `vertical: 4` and `circular(16)` with tokens. |
| `lib/core/widgets/feedback/p_toast.dart` | edit | Rewrite as wrapper around `toastification`. Public API unchanged so callers don't move. |
| `lib/core/widgets/feedback/p_loading_shimmer.dart` | edit | Replace `PPositionCardShimmer` body with `Skeletonizer(enabled: true, child: PositionCard(...))`. Keep generic `PShimmerBox` for one-off cases. |
| `lib/core/widgets/p_bottom_sheet.dart` | new | Wrapper over `smooth_sheets` SheetRoute with PoiseAI defaults (drag handle, BackdropFilter blur, `AppRadius.sheetRadius` top corners). |
| `lib/core/widgets/buttons/p_secondary_button.dart` | new | Outlined variant with same state machine as PPrimaryButton. |
| `lib/core/widgets/buttons/p_destructive_button.dart` | new | Red variant with pulse-on-tap (#13). |
| `lib/core/widgets/cards/position_card.dart` | new | Promote `features/home/screens/widgets/position_card.dart` to shared, dedupe. |
| `lib/core/widgets/cards/order_card.dart` | new | Used by Orders feature (created below). |
| `lib/core/widgets/feedback/p_empty_state.dart` | new | Lottie + title + sub + optional CTA. Used by HomeState.empty, NotificationsScreen empty, AiChatScreen empty. |
| `lib/core/widgets/feedback/p_error_state.dart` | new | Icon + message + retry CTA. Used by HomeState.error. |
| `lib/core/widgets/p_app_bar.dart` | new | Standard app bar wrapper using tokens. |
| `lib/core/widgets/p_badge.dart` | new | Status pill (Open / Pending / Filled / Locked). |
| `lib/core/widgets/p_percentage_chip.dart` | new | Green/red ±N% chip with tabular figures. |
| `lib/core/widgets/inputs/p_dropdown.dart` | new | Bottom-sheet-backed dropdown. |
| `lib/core/widgets/charts/sparkline_chart.dart` | new | `fl_chart` `LineChart` with no axes, smoothed. |
| `lib/core/widgets/charts/pnl_bar_chart.dart` | new | `fl_chart` `BarChart`, green/red bars by sign. |
| `lib/core/widgets/charts/candlestick_chart.dart` | new | `fl_chart` `CandlestickChartData` (added in 1.0). |
| `lib/features/orders/data/models/order.dart` | new | freezed model matching Go `Order` struct. |
| `lib/features/orders/data/orders_api.dart` | new | `placeOrder`, `getOrders` (cursor-paginated), `cancelOrder`. |
| `lib/features/orders/providers/orders_provider.dart` | new | Cursor-paginated `Notifier`. `loadMore()` at 80% scroll. |
| `lib/features/orders/providers/place_order_provider.dart` | new | Handles submit + optimistic local insert + rollback on error. |
| `lib/features/positions/providers/positions_provider.dart` | new | `StreamNotifier`. Seeds from HTTP, merges `PositionUpdateMessage` from `WsService`. Refactor `home_provider.dart` to consume this. |
| `lib/features/risk/providers/token_risk_provider.dart` | new | `AsyncNotifier.family(symbol)`. |
| `lib/features/risk/providers/portfolio_risk_provider.dart` | new | Polled + WS refresh. |
| `lib/features/strategies/data/models/strategy.dart` | new | freezed. Mirror `domain.Strategy`. |
| `lib/features/strategies/data/strategies_api.dart` | new | CRUD + `activate`/`deactivate`. |
| `lib/features/strategies/providers/strategies_provider.dart` | new | List + active strategy lookup. |
| `lib/features/onboarding/screens/set_risk_appetite_screen.dart` | edit | Wire submit to `strategies_provider.create()` + `activate()`. Set `hasActiveStrategy = true` in AuthState. |
| `lib/features/auth/providers/auth_provider.dart` | edit | After `_persistAndActivate`, fetch `/strategies/active` and set `hasActiveStrategy` real (currently hardcoded `false`). |
| `lib/features/profile/data/profile_api.dart` | new | `GET /profile`, `PUT /profile`, `PUT /password`, `POST /2fa/setup`. |
| `lib/features/profile/data/exchange_connections_api.dart` | new | CRUD for `/exchange-connections`. |
| `lib/features/profile/screens/profile_screen.dart` | new | Profile + 2FA + exchange connections section. |
| `lib/features/notifications/data/models/notification.dart` | new | freezed sealed: `OrderUpdate`, `PositionUpdate`, `RiskAlert`. |
| `lib/features/ai_chat/data/ai_chat_api.dart` | edit | Add `getSessions()`, `getSession(id)`, `deleteSession(id)`. |
| `lib/core/router/app_router.dart` | edit | Add routes: `/app/orders`, `/app/profile`, `/app/orders/:id`. |

### Tests

| Path | Action |
|---|---|
| `test/core/network/auth_interceptor_test.dart` | new — verify 401 increments `authInvalidatedProvider` and triggers logout |
| `test/features/auth/auth_provider_test.dart` | new |
| `test/features/home/home_provider_test.dart` | new — verifies state machine transitions A→F |
| `test/features/positions/positions_provider_test.dart` | new — HTTP seed + WS merge |

---

## Reused functions / utilities (do not reinvent)

- **`Result<S, E>`** at `lib/core/utils/result.dart` — every new API method must return this, never raw throw. See existing `PositionsApi.getOpenPositions()` as the template.
- **`AppError` sealed hierarchy** at `lib/core/errors/app_error.dart` — wrap DioException once in `ErrorInterceptor`; downstream code matches on the sealed types.
- **`authInvalidatedProvider`** counter pattern (memory-documented) — already wired. New providers must `ref.watch(authInvalidatedProvider)` in `build()` if they hold auth-dependent state.
- **`WsService` broadcast stream** at `lib/core/websocket/ws_service.dart` — new providers subscribe via `.stream.where((m) => m is XxxMessage)`. No second WS connection.
- **`LocalCache.getList/putList(boxName, key, fromJson/toJson)`** — use for stale-while-revalidate on cold start (already used by HomeProvider).
- **`PPrimaryButton` state machine** (idle/loading/success/error) — `PSecondary` and `PDestructive` reuse the same state enum and AnimationController pattern. Do not invent new state types.
- **Backend services already wired** in [main.go](C:/dev/strategy-lock/cmd/server/main.go:53-87) — AI tool executors call these directly, not through HTTP, to avoid round-tripping: `orderService.PlaceOrder`, `positionService.ClosePosition`, `tokenMonitoringService.GetPortfolioRisk`, `exitRequestService.Create`, etc.
- **`riverpod_annotation` `@riverpod`** — every new provider uses this. Do not write manual Provider classes.
- **`freezed` `sealed class`** for state and event types — Flutter `switch` exhaustiveness is the only acceptable handling.

---

## Implementation order (parallelizable lanes)

### Lane 1 — Backend AI (can start immediately)
1. Migrations + repo layer (1 day)
2. `LLMProvider` interface + OpenAI/DeepSeek adapter (1 day)
3. `AIChatService` + tool registry + 12 tool executors (2 days)
4. `AIChatHandler` SSE endpoint + confirmation endpoint (1 day)
5. Wire in `main.go`, smoke-test with curl (0.5 day)

### Lane 2 — Asset + token cleanup (independent of Lane 1)
6. Drop Inter fonts + Lottie JSONs + Poise logo
7. Replace 5 hardcoded radii / paddings with tokens
8. Add `bubbleRadius`, `menuRadius` to `AppRadius`
9. `flutter pub get`, verify font loads on device

### Lane 3 — Library swaps (independent)
10. Remove syncfusion, add fl_chart + toastification + skeletonizer + smooth_sheets
11. Rewrite `PToast` as toastification wrapper (API unchanged)
12. Rewrite `PPositionCardShimmer` as `Skeletonizer` wrapper
13. Build `PBottomSheet` wrapper over `smooth_sheets`
14. Migrate `OrderPreviewSheet` + position context menu to `PBottomSheet`

### Lane 4 — Missing features (after Lanes 2 + 3 complete)
15. `features/strategies/` full stack → wire SetRiskAppetiteScreen
16. `features/positions/providers/positions_provider.dart` → refactor `home_provider.dart`
17. `features/risk/providers/` + `features/orders/` full stack
18. `features/profile/` + exchange connections UI
19. Real `hasActiveStrategy` in AuthState
20. Add missing core widgets (PSecondaryButton, PDestructiveButton, PEmptyState, PErrorState, PAppBar, PBadge, PPercentageChip, PDropdown)

### Lane 5 — Polish (after Lane 1 + 4)
21. Wire AI chat tool-call cards to real backend
22. Add radial long-press menu to PositionCard (#25)
23. Add custom pull-to-refresh indicator (#23)
24. Audit remaining 75 micro-interactions on physical device
25. Write 4 test files

---

## Verification

End-to-end test pass — must all succeed:

```bash
# Backend
cd C:/dev/strategy-lock
go mod tidy && go build ./... && go run ./cmd/server/main.go

# In another shell — health
curl http://localhost:8080/health

# AI smoke (after login → grab JWT)
curl -N -H "Authorization: Bearer $JWT" -H "Content-Type: application/json" \
     -d '{"message":"show my positions"}' \
     http://localhost:8080/api/v1/ai/chat
# Expected: SSE stream with text/tool_call/tool_result/done events

# Confirmation flow
curl -N -H "Authorization: Bearer $JWT" -H "Content-Type: application/json" \
     -d '{"message":"place a market buy 0.001 BTC"}' \
     http://localhost:8080/api/v1/ai/chat
# Expected: requires_confirmation event then stream pauses

curl -X POST -H "Authorization: Bearer $JWT" -H "Content-Type: application/json" \
     -d '{"session_id":"...","tool_call_id":"...","confirmed":true}' \
     http://localhost:8080/api/v1/ai/chat/confirm
# Expected: original stream resumes with tool_result + done
```

```bash
# Flutter
cd C:/dev/poise-ai
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter analyze       # must be 0 issues
flutter test          # 4 new tests + existing
flutter run -d <real-device>   # haptics require physical device
```

Manual checks on device:
1. Cold start → Inter font visibly loads (numeric columns are tabular)
2. Register → verify email → create password → SetRiskAppetite picks an option → submits → lands on Home
3. Home shows positions or appropriate empty state (PEmptyState renders Lottie)
4. Place market order via Trade Entry → appears in Orders list
5. Disconnect WiFi → WsStatusBanner slides down → reconnect → flashes green and slides up
6. AI chat: "show my positions" → tool call card spins → result card expands
7. AI chat: "place a market buy 0.001 BTC" → ConfirmationCard appears with amber pulse → confirm → success card → order in list
8. Long-press position card → radial menu (#25)
9. Swipe left on position card → padlock reveal → release past threshold → locks
10. Toast triggers (success/error/info) appear via toastification
11. Pull-to-refresh on Home → custom "P" indicator
12. Switch DeepSeek↔OpenAI in `config.yaml`, restart backend, AI chat still works

---

## Out of scope (this pass)

- Dark mode screen-level rewrite (deferred per user)
- Anthropic Claude provider implementation (interface ready; adapter later)
- Widgetbook + custom_lint enforcement (user did not select; can add Phase 9)
- Production deployment, secrets vault, observability dashboards
- App store assets, privacy policy, App Tracking Transparency prompts

---

## Risk register

- **DeepSeek SSE buffering** — some reverse proxies buffer until newline. Force `Transfer-Encoding: chunked` and set `X-Accel-Buffering: no`; test against actual `api.deepseek.com` not a localhost mock.
- **AI tool authority leak** — never read `user_id` from LLM tool input. Always inject from JWT context inside the tool executor. This is the highest-severity bug we could introduce; lock it in code review.
- **AI confirmation replay** — `POST /ai/chat/confirm` needs idempotency on `(session_id, tool_call_id)` to prevent double-execution if the client retries.
- **Inter font license** — OFL is fine for embedding; verify the file matches `https://github.com/rsms/inter` releases (not a fork).
- **fl_chart 1.x candlestick API** — the candlestick widget shipped in 1.0; confirm it covers our needs before deleting the syncfusion fallback. Worst case: keep `fl_chart` for sparkline + bars and revisit candlesticks later.
- **smooth_sheets 0.17.0 is pre-1.0** — pin the version; `.lock` it. Watch for breaking changes; the wrapper at `PBottomSheet` insulates callers.
- **Memory drift** — current memory file claims many features are complete that are not. Update `project_poise_ai.md` after this pass with truthful status.