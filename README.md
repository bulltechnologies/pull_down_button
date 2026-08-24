# Pull-Down Button from iOS 14-18 for Flutter

[![Dart SDK Version](https://badgen.net/pub/sdk-version/pull_down_button)](https://pub.dev/packages/pull_down_button)
[![Pub Version](https://img.shields.io/pub/v/pull_down_button)](https://pub.dev/packages/pull_down_button)
[![Pub Likes](https://img.shields.io/pub/likes/pull_down_button)](https://pub.dev/packages/pull_down_button)
[![Common Changelog](https://common-changelog.org/badge.svg)](https://common-changelog.org)

**pull_down_button** is an attempt to bring
[Pop-Up](https://developer.apple.com/design/human-interface-guidelines/components/menus-and-actions/pop-up-buttons) and
[Pull-Down](https://developer.apple.com/design/human-interface-guidelines/components/menus-and-actions/pull-down-buttons)
Buttons from iOS 14-18 to Flutter with extensive customization options.

##### This package only tries to visually replicate the native counterpart, some parts might be somewhat different.

---

> [!IMPORTANT]
> This package is no longer actively maintained and will most likely be deprecated and unlisted some time after Flutter finally supports iOS menus out of the box to give some time for migration. You can follow the progress here - [#60298](https://github.com/flutter/flutter/issues/60298).
>
> One of the core features of this package is an extensive customizability, which, most likely, will not be present in Flutter's pull-down menus. If there won't be any plans to add customizability to Flutter's menus, but there will be a big interest in it, this package might migrate most of the code to use Flutter's more advanced implementation with customisation options present right now. You can post your feedback on this topic [here](https://github.com/notDmDrl/pull_down_button/issues/38).

---

### Contents:

-   [PullDownButton](#pulldownbutton)
    -   [PullDownMenuItem](#pulldownmenuitem)
    -   [PullDownMenuItem.selectable](#pulldownmenuitemselectable)
    -   [PullDownMenuItem.custom](#pulldownmenuitemcustom)
    -   [PullDownMenuItem.builder](#pulldownmenuitembuilder)
    -   [PullDownMenuActionsRow](#pulldownmenuactionsrow)
    -   [PullDownMenuDivider](#pulldownmenudivider)
    -   [PullDownMenuTitle](#pulldownmenutitle)
    -   [PullDownMenuHeader](#pulldownmenuheader)
-   [showPullDownMenu](#showpulldownmenu)
-   [PullDownMenu](#pulldownmenu)
-   [Theming](#theming)
    -   [PullDownButtonTheme](#pulldownbuttontheme)
    -   [PullDownMenuRouteTheme](#pulldownmenuroutetheme)
    -   [PullDownMenuItemTheme](#pulldownmenuitemtheme)
    -   [PullDownMenuDividerTheme](#pulldownmenudividertheme)
    -   [PullDownMenuTitleTheme](#pulldownmenutitletheme)
    -   [PullDownButtonInheritedTheme](#pulldownbuttoninheritedtheme)
-   [Contributions](#contributions)

---

## PullDownButton

![PullDownButton example](https://raw.githubusercontent.com/notDmDrl/pull_down_button/main/readme_content/usage.png)

`PullDownButton` is a widget used to show the pull-down menu.

While the pull-down menu is opened, the button from where this menu was called will have lower opacity.

```dart
PullDownButton(
  itemBuilder: (context) => [
    PullDownMenuItem(
      title: 'Menu item',
      onTap: () {},
    ),
    const PullDownMenuDivider(),
    PullDownMenuItem(
      title: 'Menu item 2',
      onTap: () {},
    ),
  ],
  buttonBuilder: (context, showMenu) => CupertinoButton(
    onPressed: showMenu,
    padding: EdgeInsets.zero,
    child: const Icon(CupertinoIcons.ellipsis_circle),
  ),
);
```

<details><summary>Properties table</summary>

| Properties                 | Description                                                                                              |
| -------------------------- | -------------------------------------------------------------------------------------------------------- |
| itemBuilder                | Called when the button is pressed to create the items to show in the menu.                               |
| buttonBuilder              | Builder that provides `BuildContext` as well as `showMenu` function to pass to any custom button widget. |
| onCanceled                 | Called when the user dismisses the pull-down menu.                                                       |
| position                   | Whether the pull-down menu is positioned above, over, or under the pull-down menu button.                |
| itemsOrder                 | Whether the pull-down menu orders its items from `itemBuilder` in downward or upwards way.               |
| buttonAnchor               | Whether the pull-down menu is anchored to the center, left, or right side of `buttonBuilder`.            |
| menuOffset                 | Additional offset for the pull-down menu if the menu's desired position.                                 |
| scrollController           | A custom menu scroll controller.                                                                         |
| animationBuilder           | Custom animation for `buttonBuilder` when the pull-down menu is opening or closing.                      |
| routeTheme                 | The theme of the pull-down menu box.                                                                     |
| animationAlignmentOverride | Custom animation alignment used to override default one.                                                 |
| useRootNavigator           | Whether to use the root navigator to show the pull-down menu.                                            |
| routeSettings              | Optional route settings for the pull-down menu.                                                          |

</details>

---

### PullDownMenuItem

![PullDownMenuItem example](https://raw.githubusercontent.com/notDmDrl/pull_down_button/main/readme_content/item.png)

`PullDownMenuItem` is a widget used to create a cupertino-style pull-down menu item.

```dart
PullDownMenuItem(
  onTap: () {},
  title: 'Pin',
  icon: CupertinoIcons.pin,
),
PullDownMenuItem(
  title: 'Forward',
  subtitle: 'Share in different channel',
  onTap: () {},
  icon: CupertinoIcons.arrowshape_turn_up_right,
),
PullDownMenuItem(
  onTap: () {},
  title: 'Copy',
  icon: CupertinoIcons.doc_on_doc,
  trailing: Text('⌘C'),
),
PullDownMenuItem(
  onTap: () {},
  title: 'Delete',
  isDestructive: true,
  icon: CupertinoIcons.delete,
),
```

<details><summary>Properties table</summary>

| Properties          | Description                                                                     |
| ------------------- | ------------------------------------------------------------------------------- |
| onTap               | The action this item represents.                                                |
| tapHandler          | Handler to resolve how `onTap` callback is used.                                |
| enabled             | Whether the user is permitted to tap this item.                                 |
| title               | Title string of this `PullDownMenuItem`.                                        |
| titleWidget         | Custom title widget (overrides `title` text).                                   |
| subtitle            | Subtitle string of this `PullDownMenuItem`.                                     |
| subtitleWidget      | Custom subtitle widget (overrides `subtitle` text).                             |
| icon                | Icon data of this `PullDownMenuItem`.                                           |
| iconColor           | Color of the icon widget.                                                       |
| iconWidget          | Custom icon widget.                                                             |
| iconSize            | Custom icon size.                                                               |
| iconAlignment       | Alignment of the icon (`PullDownMenuItemIconAlignment.trailing` or `leading`).   |
| iconBackgroundColor | Optional background color for the icon's container plate.                       |
| iconBorderRadius    | Optional border radius for the icon's container plate.                          |
| iconPadding         | Optional padding inside the icon's container plate.                             |
| trailing            | Optional trailing widget (e.g., keyboard shortcut hint, badge, chevron icon).  |
| leading             | Optional custom leading widget.                                                 |
| isDestructive       | Whether this item represents a destructive action.                              |
| backgroundColor     | Idle background color for this item container.                                  |
| margin              | Outer margin surrounding this item inside the menu body.                        |
| border              | Optional border around the item container.                                      |
| padding             | Custom padding for this menu item.                                              |
| itemBorderRadius    | Custom border radius for this item's tap/hover highlight.                       |
| mouseCursor         | Custom mouse cursor for this menu item.                                         |
| alignment           | Alignment of the item body.                                                     |
| titleSubtitleGap    | Vertical gap between title and subtitle.                                        |
| showLeading         | Whether to reserve and display the leading checkmark column.                    |
| itemTheme           | Per-item theme override (`PullDownMenuItemTheme`).                              |

</details>

---

### PullDownMenuItem.selectable

![PullDownMenuItem.selectable example](https://raw.githubusercontent.com/notDmDrl/pull_down_button/main/readme_content/selectable_item.png)

`PullDownMenuItem.selectable` is a widget used to create a cupertino-style pull-down menu item with a selection checkmark state.

```dart
PullDownMenuItem.selectable(
  onTap: () {},
  selected: true,
  title: 'Green',
  icon: CupertinoIcons.circle_fill,
  iconColor: CupertinoColors.systemGreen.resolveFrom(context),
),
PullDownMenuItem.selectable(
  onTap: () {},
  selected: false,
  title: 'Orange',
  icon: CupertinoIcons.circle_fill,
  iconColor: CupertinoColors.systemOrange.resolveFrom(context),
),
```

<details><summary>Properties table</summary>

`PullDownMenuItem.selectable` supports all `PullDownMenuItem` properties plus:

| Properties | Description                                                  |
| ---------- | ------------------------------------------------------------ |
| selected   | Whether the item is selected and displays a checkmark icon. |

</details>

---

### PullDownMenuItem.custom

`PullDownMenuItem.custom` creates a custom pull-down menu item wrapping an arbitrary `child` widget while retaining tap handling, padding, hover/pressed state highlights, and border radius.

```dart
PullDownMenuItem.custom(
  onTap: () {},
  child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: const [
      Text('Volume'),
      Icon(CupertinoIcons.speaker_2_fill, size: 18),
    ],
  ),
)
```

---

### PullDownMenuItem.builder

`PullDownMenuItem.builder` builds a dynamic menu item based on interactive state (`PullDownMenuItemState`: `isHovered`, `isPressed`, `enabled`, `selected`, `onTap`).

```dart
PullDownMenuItem.builder(
  onTap: () {},
  builder: (context, state) => Row(
    children: [
      Icon(state.isPressed ? CupertinoIcons.star_fill : CupertinoIcons.star),
      const SizedBox(width: 8),
      Text(state.isHovered ? 'Hovered Star' : 'Star'),
    ],
  ),
)
```

---

### PullDownMenuActionsRow

![PullDownMenuActionsRow example](https://raw.githubusercontent.com/notDmDrl/pull_down_button/main/readme_content/actions_row.png)

`PullDownMenuActionsRow` is a widget used to create a cupertino-style row of actions
([small or medium size](https://developer.apple.com/documentation/uikit/uimenu/4013313-preferredelementsize)).

```dart
PullDownMenuActionsRow.medium(
  items: [
    PullDownMenuItem(
      onTap: () {},
      title: 'Reply',
      icon: CupertinoIcons.arrowshape_turn_up_left,
    ),
    PullDownMenuItem(
      onTap: () {},
      title: 'Copy',
      icon: CupertinoIcons.doc_on_doc,
    ),
    PullDownMenuItem(
      onTap: () {},
      title: 'Edit',
      icon: CupertinoIcons.pencil,
    ),
  ],
),
```

| Properties | Description                 |
| ---------- | --------------------------- |
| items      | List of `PullDownMenuItem`. |

---

### PullDownMenuDivider

![PullDownMenuDivider example](https://raw.githubusercontent.com/notDmDrl/pull_down_button/main/readme_content/dividers.png)

`PullDownMenuDivider` is a widget used to create large horizontal dividers for pull-down menus. Thin separators between items are inserted automatically!

```dart
const PullDownMenuDivider(
  thickness: 2,
  indent: 16,
  endIndent: 16,
)
```

To create a divider with arbitrary content (e.g. section headers, chips, custom widgets):

```dart
PullDownMenuDivider.custom(
  child: Center(
    child: Text('Section Break', style: TextStyle(fontSize: 11)),
  ),
)
```

<details><summary>Properties table</summary>

| Properties   | Description                                            |
| ------------ | ------------------------------------------------------ |
| color        | Color of the divider.                                  |
| height       | Height of the divider widget.                          |
| thickness    | Thickness of the divider line.                         |
| indent       | Leading spacing for the divider.                       |
| endIndent    | Trailing spacing for the divider.                      |
| margin       | Outer margin surrounding the divider.                  |
| child        | Optional custom child widget (`.custom` constructor).  |
| dividerTheme | Per-divider theme override (`PullDownMenuDividerTheme`).|

</details>

---

### PullDownMenuTitle

![PullDownMenuTitle example](https://raw.githubusercontent.com/notDmDrl/pull_down_button/main/readme_content/title.png)

`PullDownMenuTitle` is a widget used to create a cupertino-style menu title or section label.

```dart
const PullDownMenuTitle(
  title: Text('Menu title'),
  subtitle: Text('Optional subtitle description'),
  titleSubtitleGap: 4,
),
```

<details><summary>Properties table</summary>

| Properties       | Description                                                |
| ---------------- | ---------------------------------------------------------- |
| title            | Title widget.                                              |
| subtitle         | Optional subtitle widget.                                  |
| leading          | Optional leading widget.                                   |
| trailing         | Optional trailing widget.                                  |
| alignment        | Alignment of the title (`start` or `center`).              |
| titleStyle       | Title text style.                                          |
| subtitleStyle    | Subtitle text style.                                       |
| padding          | Custom padding.                                            |
| margin           | Custom margin.                                             |
| titleSubtitleGap | Gap between title and subtitle.                            |
| titleTheme       | Per-title theme override (`PullDownMenuTitleTheme`).       |

</details>

---

### PullDownMenuHeader

![PullDownMenuHeader example](https://raw.githubusercontent.com/notDmDrl/pull_down_button/main/readme_content/header.png)

`PullDownMenuHeader` is a widget used to create a cupertino-style menu document header (usually at the top of the menu).

```dart
PullDownMenuHeader(
  leading: ColoredBox(
    color: CupertinoColors.systemBlue.resolveFrom(context),
  ),
  title: 'Profile',
  subtitle: 'Tap to open',
  onTap: () {},
  icon: CupertinoIcons.profile_circled,
),
```

<details><summary>Properties table</summary>

| Properties       | Description                                      |
| ---------------- | ------------------------------------------------ |
| onTap            | The action this header represents.               |
| tapHandler       | Handler to resolve how `onTap` callback is used. |
| leading          | Leading widget of this header.                   |
| leadingBuilder   | Custom leading widget builder with constraints.  |
| title            | Title string of this header.                     |
| titleWidget      | Optional custom title widget.                    |
| subtitle         | Subtitle string of this header.                  |
| subtitleWidget   | Optional custom subtitle widget.                 |
| trailing         | Optional trailing widget.                        |
| icon             | Trailing action icon data.                       |
| iconWidget       | Custom trailing action icon widget.              |
| iconColor        | Color of the trailing icon.                      |
| iconSize         | Custom size of the trailing icon.                |
| backgroundColor  | Idle background color of the header container.   |
| margin           | Outer margin around the header.                  |
| border           | Border around the header container.              |
| padding          | Custom padding for this header item.             |
| itemBorderRadius | Border radius for tap/hover highlights.          |
| mouseCursor      | Custom mouse cursor.                             |
| titleSubtitleGap | Gap between title and subtitle.                  |
| itemTheme        | The theme of the header item.                    |

</details>

---

### showPullDownMenu

An alternative way of displaying pull-down menu via a function call.

```dart
onPressed: () async {
  /* get tap position and / or do something before opening menu */

  await showPullDownMenu(
    context: context,
    items: [
      PullDownMenuItem(
        title: 'Action 1',
        onTap: () {},
      ),
      PullDownMenuItem(
        title: 'Action 2',
        onTap: () {},
      ),
    ],
    position: position,
  );
}
```

<details><summary>Properties table</summary>

| Properties       | Description                                                                                   |
| ---------------- | --------------------------------------------------------------------------------------------- |
| context          | For looking up `Navigator` for the menu.                                                      |
| items            | List of widgets to show in the menu.                                                          |
| position         | The `Rect` used to align the top of the menu with the top of the **position** rectangle.     |
| itemsOrder       | Whether the menu orders its items from `itemBuilder` in a downward or upwards way.            |
| menuOffset       | Additional offset for the pull-down menu from the desired position.                           |
| scrollController | A custom menu scroll controller.                                                              |
| onCanceled       | Called when the user dismisses the pull-down menu.                                            |
| routeTheme       | The theme of the pull-down menu box.                                                          |
| useRootNavigator | Whether to use the root navigator to show the pull-down menu.                                 |
| routeSettings    | Optional route settings for the pull-down menu.                                               |

</details>

---

### PullDownMenu

Another alternative way of displaying the pull-down menu as a standalone widget, with no animations or route navigation.

```dart
PullDownMenu(
  items: [
    PullDownMenuItem(
      title: 'Menu item',
      onTap: () {},
    ),
    const PullDownMenuDivider(),
    PullDownMenuItem(
      title: 'Menu item 2',
      onTap: () {},
    ),
  ],
),
```

<details><summary>Properties table</summary>

| Properties       | Description                          |
| ---------------- | ------------------------------------ |
| items            | List of widgets to show in the menu. |
| scrollController | A custom menu scroll controller.     |
| routeTheme       | The theme of pull-down menu box.     |

</details>

---

## Theming

This package provides comprehensive customization. By default, iOS 18 style defaults are used. All properties can be overridden via widget properties or globally via the `PullDownButtonTheme` theme extension.

| Light Theme                                                                                                               | Dark Theme                                                                                                                    |
| ------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------- |
| ![light default theme example](https://raw.githubusercontent.com/notDmDrl/pull_down_button/main/readme_content/usage.png) | ![dark default theme example](https://raw.githubusercontent.com/notDmDrl/pull_down_button/main/readme_content/usage_dark.png) |

### PullDownButtonTheme

To configure `PullDownButtonTheme` globally, add it to your `ThemeData.extensions`:

```dart
ThemeData(
  extensions: [
    PullDownButtonTheme(
      routeTheme: PullDownMenuRouteTheme(
        backgroundColor: Colors.white.withValues(alpha: 0.8),
        borderRadius: const BorderRadius.all(Radius.circular(16)),
        padding: const EdgeInsets.all(4),
      ),
      itemTheme: PullDownMenuItemTheme(
        itemBorderRadius: const BorderRadius.all(Radius.circular(10)),
        iconAlignment: PullDownMenuItemIconAlignment.leading,
      ),
      dividerTheme: const PullDownMenuDividerTheme(
        indent: 12,
        endIndent: 12,
      ),
    ),
  ],
),
```

<details><summary>PullDownButtonTheme sub-themes</summary>

| Properties   | Description                                               |
| ------------ | --------------------------------------------------------- |
| routeTheme   | Menu container theme (`PullDownMenuRouteTheme`).          |
| itemTheme    | `PullDownMenuItem` theme (`PullDownMenuItemTheme`).       |
| dividerTheme | `PullDownMenuDivider` theme (`PullDownMenuDividerTheme`). |
| titleTheme   | `PullDownMenuTitle` theme (`PullDownMenuTitleTheme`).     |

</details>

---

### PullDownMenuRouteTheme

Controls the visual appearance, constraints, animations, and container wrapping of the menu.

<details><summary>PullDownMenuRouteTheme properties</summary>

| Properties         | Description                                                                                     |
| ------------------ | ----------------------------------------------------------------------------------------------- |
| backgroundColor    | Background color of the pull-down menu.                                                         |
| borderRadius       | Border radius of the pull-down menu container.                                                  |
| borderClipper      | Custom border clipper function (`ClipRSuperellipse`, `ClipRRect`, etc.).                        |
| shadow             | Single box shadow cast by the container.                                                        |
| boxShadow          | List of box shadows cast by the container (overrides `shadow`).                                 |
| border             | Box border drawn around the container.                                                          |
| width              | Default width of the menu.                                                                      |
| accessibilityWidth | Width when system text scale factor is in accessibility mode.                                   |
| minWidth           | Minimum width constraint for the container.                                                     |
| maxWidth           | Maximum width constraint for the container.                                                     |
| maxHeight          | Maximum height constraint for the container.                                                    |
| constraints        | Direct `BoxConstraints` for the menu container.                                                 |
| padding            | Inner padding inside the menu container surrounding items.                                      |
| margin             | Outer margin around the menu container.                                                         |
| clipBehavior       | Clipping behavior for the menu container.                                                       |
| containerBuilder   | Custom builder function (`(context, child) => ...`) to morph or wrap the menu container widget. |
| barrierColor       | Background barrier color behind the modal menu.                                                 |
| barrierDismissible | Whether tapping outside dismisses the menu.                                                     |
| barrierLabel       | Accessibility label for the barrier.                                                            |
| backdropBlurSigma  | Blur strength (sigma) for the backdrop filter on translucent backgrounds.                       |
| showBackdropFilter | Whether to enable backdrop blur filter.                                                         |
| openDuration       | Duration of the menu open animation.                                                            |
| closeDuration      | Duration of the menu close animation.                                                           |
| sizeChangeDuration | Duration of layout / size change animations.                                                    |
| openCurve          | Animation curve for opening.                                                                    |
| closeCurve         | Animation curve for closing.                                                                    |
| menuScreenPadding  | Minimum horizontal screen edge padding when positioning the menu.                               |

</details>

---

### PullDownMenuItemTheme

Controls visual styles, typography, icon styling, spacing, and interaction states for menu items.

<details><summary>PullDownMenuItemTheme properties</summary>

| Properties               | Description                                                                     |
| ------------------------ | ------------------------------------------------------------------------------- |
| destructiveColor         | Text and icon color for destructive items.                                      |
| checkmark                | IconData for selection checkmarks.                                              |
| textStyle                | Text style for item titles.                                                     |
| subtitleStyle            | Text style for item subtitles.                                                  |
| iconActionTextStyle      | Text style for items inside `PullDownMenuActionsRow`.                           |
| trailingTextStyle        | Text style for trailing shortcuts and badges.                                   |
| trailingColor            | Color merged into `trailingTextStyle`.                                          |
| backgroundColor          | Default idle background color for item containers.                              |
| onHoverBackgroundColor   | Background highlight color on hover.                                            |
| onPressedBackgroundColor | Background highlight color when pressed.                                        |
| onHoverTextColor         | Text and icon color on hover.                                                   |
| onPressedTextColor       | Text and icon color when pressed.                                               |
| titleColor               | Color merged into `textStyle`.                                                  |
| subtitleColor            | Color merged into `subtitleStyle`.                                              |
| iconColor                | Default icon color.                                                             |
| iconBackgroundColor      | Background color for the icon's container plate.                                |
| iconBorderRadius         | Border radius for the icon's container plate.                                   |
| iconPadding              | Padding for the icon's container plate.                                         |
| iconSize                 | Default icon size.                                                              |
| iconAlignment            | Default icon placement (`PullDownMenuItemIconAlignment.trailing` or `leading`). |
| disabledOpacity          | Opacity applied to disabled items.                                              |
| itemBorderRadius         | Border radius for item tap/hover highlights.                                    |
| border                   | Border drawn around individual items.                                           |
| margin                   | Outer margin surrounding individual items inside the menu body.                 |
| padding                  | Padding for large items and selectable items.                                   |
| headerPadding            | Padding for `PullDownMenuHeader`.                                               |
| actionsRowPadding        | Padding for items inside `PullDownMenuActionsRow`.                              |
| titleSubtitleGap         | Vertical gap between title and subtitle.                                        |
| iconSpacing              | Horizontal gap between icon and title.                                          |
| leadingWidth             | Width of the leading checkmark column.                                          |
| leadingSpacing           | Spacing after the leading checkmark column.                                     |
| checkmarkSize            | Size of the selection checkmark icon.                                           |
| showLeading              | Whether to show/reserve leading checkmark space.                                |
| mouseCursor              | Mouse cursor for interactive items.                                             |
| minHeight                | Minimum height constraint for menu items.                                       |

</details>

---

### PullDownMenuDividerTheme

Controls appearance of large dividers and small automatic item separators.

<details><summary>PullDownMenuDividerTheme properties</summary>

| Properties         | Description                                       |
| ------------------ | ------------------------------------------------- |
| dividerColor       | Color for thin item separators.                   |
| largeDividerColor  | Default color for large `PullDownMenuDivider`.    |
| color              | General color override for dividers & separators. |
| separatorThickness | Line thickness of automatic item separators.      |
| dividerThickness   | Thickness (height) of `PullDownMenuDivider`.      |
| separatorHeight    | Layout height of automatic item separators.       |
| dividerHeight      | Layout height of `PullDownMenuDivider`.           |
| indent             | Leading indent spacing for dividers.              |
| endIndent          | Trailing indent spacing for dividers.             |
| margin             | Outer margin around dividers.                     |

</details>

---

### PullDownMenuTitleTheme

Controls visual appearance of `PullDownMenuTitle`.

<details><summary>PullDownMenuTitleTheme properties</summary>

| Properties              | Description                                        |
| ----------------------- | -------------------------------------------------- |
| style                   | Text style for title labels.                       |
| color                   | Color merged into `style`.                         |
| padding                 | Padding around the title.                          |
| margin                  | Outer margin around the title.                     |
| startPaddingWithLeading | Start padding when menu has leading items.         |
| startPadding            | Start padding when menu has no leading items.      |
| verticalPadding         | Top and bottom padding for the title.              |
| endPadding              | End padding for the title.                         |
| titleSubtitleGap        | Gap between title and subtitle when present.       |

</details>

---

### PullDownButtonInheritedTheme

If defining `PullDownButtonTheme` in `ThemeData` is not possible (e.g. while using `CupertinoApp`), use `PullDownButtonInheritedTheme`:

```dart
CupertinoApp(
  builder: (context, child) => PullDownButtonInheritedTheme(
    data: const PullDownButtonTheme(
      // your themes here
    ),
    child: child!,
  ),
  home: const MyHomePage(),
)
```

---

#### Custom theming example

Here is an [example](https://github.com/notDmDrl/pull_down_button/blob/main/example/lib/src/theming_custom.dart) of using `PullDownButtonTheme` with Material 3 color scheme colors
(generated from `CupertinoColors.systemBlue` with `ColorScheme.fromSeed`) from [Material 3 Menu specs](https://m3.material.io/components/menus/specs).

| Custom Material 3 light theme                                                                                           | Custom Material 3 dark theme                                                                                          |
| ----------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------- |
| ![light theme example](https://raw.githubusercontent.com/notDmDrl/pull_down_button/main/readme_content/theme_light.png) | ![dark theme example](https://raw.githubusercontent.com/notDmDrl/pull_down_button/main/readme_content/theme_dark.png) |

---

### Contributions

Feel free to contribute to this project.

Please file feature requests and bugs at the [issue tracker](https://github.com/notDmDrl/pull_down_button).

If you fixed a bug or implemented a feature by yourself, feel free to send a [pull request](https://github.com/notDmDrl/pull_down_button/pulls).
