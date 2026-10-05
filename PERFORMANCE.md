# Performance review and verification

Reviewed on 2026-10-05 against commit
`d38b2e58c9195368b99deb5c7558debd863c13aa` using Flutter 3.47.5
(framework `6a19cca564`) and Dart 3.13.4.

## Result

The public widget constructors, customization options, navigation and selection
flow, layout, clipping, blur, shadows, animation curves, durations, double fade,
and scale overshoot remain intact. The changes remove recurring rebuilds,
theme allocations, repeated scale resolution, and unnecessary placement work.
Blur-filter retention is bounded.

The largest measured improvement is **840 action rebuilds reduced to 1** in a
40-action menu over 21 frames selecting and moving within the same action:
**99.88% fewer action rebuilds**. Crossing into another action requires two
action rebuilds instead of forty. Hit-position checks still visit the enabled
actions; these figures describe build work, not a frame-rate multiplier.

Strict comparison against the original snapshot found **zero changed RGBA
channels across 136 full-screen captures**, with identical item geometry and
animation values. This proves equality for the exercised states under the same
test engine and font environment, rather than every possible custom widget or
device renderer.

## Review coverage and implementation

| Area | Findings and changes |
| --- | --- |
| Public entry points | Reviewed `PullDownButton`, which measures the button and opens a popup, `showPullDownMenu`, which opens a popup at an explicit rectangle, and `PullDownMenu`, which embeds a menu without a route. Item-builder timing, anchor resolution, item ordering, callbacks, navigator selection, and the button animation remain unchanged. |
| Swipe selection | `SwipeRegion` tracks pointer position. Previously its inherited notifier invalidated every action on every frame. A single frame-coalesced `_SwipeNotifier` now publishes the latest state, and a stable `_SwipeNotifierScope` lets each `MenuActionButton` subscribe directly. Only an actual pressed-state change schedules an action rebuild. Existing inherited-state consumers remain reactive. |
| Action lifecycle | `MenuActionButton` owns press/hover state and gesture handling. It reconnects when moved to another swipe region, removes listeners on disposal, ignores render objects awaiting layout, uses one render-object lookup per hit check, and skips redundant state clearing. Its enabled state now follows the current widget rather than an initial cached value. |
| Route composition | `PullDownMenuRoute` owns navigation and transitions. `_MenuRouteLayout` retains swipe, padding, positioning, and captured-theme wrappers until inherited inputs or the route change. A leaf `ValueListenableBuilder` updates Flutter's framework-provided child on each required frame. The wrapper cache remains outside the original page repaint boundary and pointer-ignore widget, preserving compositing coordinates and interaction placement. |
| Layout | `_PopupMenuRouteLayout` positions and constrains the popup. Ordinary screens skip foldable sub-screen generation. Foldable screen selection makes one pass, computes each squared distance once, and preserves first-screen ties. Offset changes are now included in layout invalidation. |
| Icons | `IconBox` and `IconActionBox` size menu and header icons. They resolve the inherited text scale once for both box and glyph dimensions, eliminating a redundant dependent widget. Five default/custom variants reduced scale resolution from two calls to one, with matching geometry at normal and accessibility sizes. |
| Theme resolution | `PullDownButtonTheme.ambientOf` combines ambient customization with defaults. Default colors and text styles are now resolved into a stable snapshot once per configuration. Descendants share styles, old configurations retain their values, and resolved themes no longer retain the resolving context. Custom-theme precedence remains unchanged. |
| Configuration updates | `MenuConfig` supplies leading-column, theme, and text-size settings. It now checks every aspect a child registered, notifying when any relevant value changes. Unrelated aspect changes continue to avoid rebuilds. |
| Blur | `BlurUtils` preserves the same platform-specific filters and saturation matrices. Native and web filters use a 16-entry least-recently-used cache. Animated or varied sigma values no longer retain an unbounded collection for the app's lifetime. |
| Menu content | Reviewed scroll/controller ownership, separators, actions rows, headers, titles, selected/destructive/disabled items, custom widgets/builders, semantics, and theme interpolation. No extra content paint boundaries or public layout changes were retained. |

## Behavior preserved and update fixes

The open/close flow remains: build items on demand, measure the anchor, push the
popup, animate scale/fade/size/shadow, select or dismiss, restore button state,
and invoke the existing action or cancellation callback. Swipe selection still
uses the latest frame-coalesced position, gives a selection haptic on entering
an action, and activates the last rendered selection on release. Hover and
press colors, custom-builder state, disabled actions, and hit-region edge
inclusion retain their behavior.

No loading, error, success, offline, copy, navigation, or confirmation flows were
introduced. Empty-item behavior and existing semantics remain intact. Text
scaling, RTL, safe areas, foldable placement, scrolling, and size-change
animations are covered by targeted tests. Device screen-reader and physical
touch/haptic testing remain separate from widget-test verification.

Three pre-existing update defects were corrected while making updates leaner:
mounted actions now honor enabled changes; default colors update in an open menu
when brightness changes; and configuration subscribers see changes to any of
their registered aspects. The route layout also responds when its menu offset
changes. These restore the intended live customization behavior; they do not
change static styles or transition timing.

## Alternatives and tradeoffs

- **Additional repaint boundaries were rejected.** Flutter's single-child
  scroll viewport already retains content painting. Default, opaque, and
  no-blur route probes each painted eight static items once on opening and zero
  times on closing, both before and after the work. An inline menu also retained
  each item while its ancestor repainted twenty times. Adding another layer
  showed no benefit.
- **Moving positioning into the cached route page was rejected.** It changed
  only one or two anti-aliased edge pixels during scale overshoot, but that still
  violated visual equivalence. The retained wrapper cache preserves the original
  render-tree placement and passes exact comparison.
- **Fade consolidation, reduced blur, reduced clipping, changed shadows, or
  shorter animations were rejected.** Each would change visible behavior.
  The two nested fades affect content differently from the menu background.
- **Lazy-list conversion was not selected.** The popup needs content height to
  determine placement and its size transition; arbitrary widgets and variable
  heights make an equivalent lazy implementation substantially more involved.
  Long menus still build their complete content.
- **Persistent hit-rectangle caching was not selected.** Animation, scrolling,
  resizing, and reparenting can change coordinates. Fresh geometry preserves
  selection correctness. Swipe hit checks remain O(number of enabled actions),
  while action rebuilds follow the changed highlights.
- **More global caches were not added.** Element-size tables and one-time widget
  construction are small costs. Theme snapshots and the bounded filter cache
  address repeated work without retaining arbitrary widgets or contexts.

The route cache adds two small stateful elements and one notifier per mounted
route to eliminate repeated wrapper construction and theme/delegate resolution.
The blur cache may recreate a filter after eviction; its rendered result is
identical. There are no new dependencies, public API changes, data collection,
permissions, or storage of user content.

## Verification

All **48 tests pass**. The regression suite includes:

- Existing superellipse clipping, border, and shadow tests.
- Ten interaction tests covering rebuild counts, real public-menu drag
  selection, custom builder state, action/cancellation timing, hover/press
  colors, disabled updates, haptics, mounting during drag, reparenting, and
  pending-notification disposal.
- Nine layout tests covering five icon/header variants at 1x, 1.5x, and
  approximately 3.12x text scale, live scale updates, safe areas, above/below/over
  placement, foldables, ties, and menu-offset invalidation.
- Six theme/configuration tests covering shared styles, stable old theme values,
  brightness changes, multiple dependencies, unrelated updates, captured local
  themes, and padding removal.
- Two route-cache tests covering independence from animation frames, updated
  framework children, and changing safe-area placement.
- Two blur tests covering reuse, brightness/sigma separation, and eviction with
  equivalent filter recreation.
- Thirteen rendering/paint tests. The 136 strict reference captures cover
  light/dark, RTL, accessibility scale 1.5, customized inherited styling,
  customized RTL, upward automatic ordering, over/start anchoring, long menus,
  scrolling, and fixed opening/closing animation times.

Library analysis against the same original snapshot reported no new diagnostics
(38 existing informational findings versus 42 before). New test files analyze
cleanly. The repository-wide analyzer still reports existing example/native
comparison lints and conflicting rules in its external lint configuration;
those unrelated files and dependencies were not changed.

### Repeat the checks

```sh
flutter test --no-pub
flutter analyze --no-pub lib
```

For exact before/after rendering, copy
`test/route_visual_compatibility_test.dart` into an unchanged baseline checkout,
resolve its dependencies, and capture with the same Flutter engine:

```sh
flutter test --no-pub test/route_visual_compatibility_test.dart \
  --dart-define=VISUAL_CAPTURE_DIR=/absolute/reference/path \
  --dart-define=VISUAL_METRIC_PATH=/absolute/reference/path/paint-metrics.json
```

Then run in the candidate checkout:

```sh
flutter test --no-pub test/route_visual_compatibility_test.dart \
  --dart-define=VISUAL_BASELINE_DIR=/absolute/reference/path \
  --dart-define=VISUAL_CAPTURE_DIR=/absolute/candidate/path \
  --dart-define=VISUAL_METRIC_PATH=/absolute/candidate/path/paint-metrics.json
```

Without those definitions, rendering tests exercise the transitions and
scrolling but do not compare against stored reference pixels. Reference images
were temporary verification artifacts, not checked-in engine-specific goldens.

## Remaining performance limits and integration

Deterministic work counters establish the reductions above. They do not establish
device frame times, GPU cost, power consumption, or a universal smoothness gain.
Profile the example or consuming application on representative 60 Hz and 120 Hz
physical devices using Flutter DevTools. Compare build/raster frame distributions
for open/close, drag selection, long-menu scrolling, and live theme/text-scale
changes. Keep screen size, background content, item count, and custom styles
identical between baseline and candidate.

Backdrop filtering and shadows remain real rendering costs because preserving
their appearance was a requirement. Long menus still have an eager initial
build, and arbitrary custom children can introduce their own build, layout,
paint, or asynchronous costs.

The adjacent `ui_kit` repository currently consumes this package through its Git
dependency on `main`, locked to the reviewed baseline commit. These local
changes must be published and that dependency refreshed, or used through a
local development override, before the consuming application includes them.

The review follows Flutter's guidance to reduce repeated build work and retain
stable children while treating opacity, clipping, and layout costs carefully:
[Flutter performance best practices](https://docs.flutter.dev/perf/best-practices).
