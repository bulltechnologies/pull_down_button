import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_down_button/pull_down_button.dart';

import 'example_scaffold.dart';

@immutable
class Item extends StatelessWidget {
  const Item({super.key});

  @override
  Widget build(BuildContext context) => CupertinoPageScaffold(
        navigationBar: ExampleScaffoldNavigationBar(
          title: 'PullDownMenuItem',
        ),
        child: ListView(
          children: const [
            LabeledExample(
              label: 'PullDownMenuItem',
              items: [
                PullDownMenuItem(
                  onTap: noAction,
                  title: 'Title',
                ),
              ],
            ),
            LabeledExample(
              label: 'PullDownMenuItem + subtitle + custom gap',
              items: [
                PullDownMenuItem(
                  onTap: noAction,
                  title: 'Title',
                  subtitle: 'Subtitle with custom gap',
                  titleSubtitleGap: 4,
                ),
              ],
            ),
            LabeledExample(
              label: 'PullDownMenuItem + leading icon with background & radius',
              items: [
                PullDownMenuItem(
                  onTap: noAction,
                  title: 'Bookmarks',
                  icon: CupertinoIcons.bookmark_fill,
                  iconAlignment: PullDownMenuItemIconAlignment.leading,
                  iconBackgroundColor: Color(0x20007AFF),
                  iconBorderRadius: BorderRadius.all(Radius.circular(6)),
                  iconPadding: EdgeInsets.all(4),
                ),
              ],
            ),
            LabeledExample(
              label: 'PullDownMenuItem + highlighted container pill & margin',
              items: [
                PullDownMenuItem(
                  onTap: noAction,
                  title: 'Follow',
                  icon: CupertinoIcons.person_badge_plus,
                  iconAlignment: PullDownMenuItemIconAlignment.leading,
                  backgroundColor: Color(0x2500C853),
                  itemBorderRadius: BorderRadius.all(Radius.circular(10)),
                  margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                ),
              ],
            ),
            LabeledExample(
              label: 'PullDownMenuItem + icon',
              items: [
                PullDownMenuItem(
                  onTap: noAction,
                  title: 'Title',
                  icon: CupertinoIcons.square,
                ),
              ],
            ),
            LabeledExample(
              label: 'PullDownMenuItem + icon + iconColor',
              items: [
                PullDownMenuItem(
                  onTap: noAction,
                  title: 'Title',
                  icon: CupertinoIcons.square,
                  iconColor: CupertinoColors.systemCyan,
                ),
              ],
            ),
            LabeledExample(
              label: 'PullDownMenuItem + iconWidget',
              items: [
                PullDownMenuItem(
                  onTap: noAction,
                  title: 'Title',
                  iconWidget: CircleAvatar(
                    backgroundColor: CupertinoColors.systemCyan,
                    foregroundColor: CupertinoColors.systemBackground,
                    child: Text('A', style: TextStyle(fontSize: 13)),
                  ),
                ),
              ],
            ),
            LabeledExample(
              label: 'PullDownMenuItem + trailing shortcut',
              items: [
                PullDownMenuItem(
                  onTap: noAction,
                  title: 'Copy',
                  icon: CupertinoIcons.doc_on_doc,
                  trailing: Text('⌘C'),
                ),
              ],
            ),
            LabeledExample(
              label: 'PullDownMenuItem + leading custom widget',
              items: [
                PullDownMenuItem(
                  onTap: noAction,
                  title: 'Profile',
                  leading: Icon(
                    CupertinoIcons.person_crop_circle,
                    size: 20,
                  ),
                  trailing: Icon(
                    CupertinoIcons.chevron_forward,
                    size: 14,
                  ),
                ),
              ],
            ),
            LabeledExample(
              label: 'PullDownMenuItem.custom',
              items: [
                PullDownMenuItem.custom(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Volume'),
                      Icon(CupertinoIcons.speaker_2_fill, size: 18),
                    ],
                  ),
                ),
              ],
            ),
            LabeledExample(
              label: 'PullDownMenuItem + subtitle + icon',
              items: [
                PullDownMenuItem(
                  onTap: noAction,
                  title: 'Title',
                  subtitle: 'Subtitle',
                  icon: CupertinoIcons.square,
                ),
              ],
            ),
            Divider(),
            LabeledExample(
              label: 'PullDownMenuItem.selectable',
              items: [
                PullDownMenuItem.selectable(
                  selected: true,
                  onTap: noAction,
                  title: 'Title',
                ),
              ],
            ),
            LabeledExample(
              label: 'PullDownMenuItem.selectable + subtitle',
              items: [
                PullDownMenuItem.selectable(
                  selected: true,
                  onTap: noAction,
                  title: 'Title',
                  subtitle: 'Subtitle',
                ),
              ],
            ),
            LabeledExample(
              label: 'PullDownMenuItem.selectable + icon',
              items: [
                PullDownMenuItem.selectable(
                  selected: true,
                  onTap: noAction,
                  title: 'Title',
                  icon: CupertinoIcons.square,
                ),
              ],
            ),
            LabeledExample(
              label: 'PullDownMenuItem.selectable + icon + iconColor',
              items: [
                PullDownMenuItem.selectable(
                  selected: true,
                  onTap: noAction,
                  title: 'Title',
                  icon: CupertinoIcons.square,
                  iconColor: CupertinoColors.systemCyan,
                ),
              ],
            ),
            LabeledExample(
              label: 'PullDownMenuItem.selectable + iconWidget',
              items: [
                PullDownMenuItem.selectable(
                  selected: true,
                  onTap: noAction,
                  title: 'Title',
                  iconWidget: CircleAvatar(
                    backgroundColor: CupertinoColors.systemCyan,
                    foregroundColor: CupertinoColors.systemBackground,
                    child: Text('A', style: TextStyle(fontSize: 13)),
                  ),
                ),
              ],
            ),
            LabeledExample(
              label: 'PullDownMenuItem.selectable + subtitle + icon',
              items: [
                PullDownMenuItem.selectable(
                  selected: true,
                  onTap: noAction,
                  title: 'Title',
                  subtitle: 'Subtitle',
                  icon: CupertinoIcons.square,
                ),
              ],
            ),
            Divider(),
            LabeledExample(
              label: 'Destructive PullDownMenuItem',
              items: [
                PullDownMenuItem(
                  isDestructive: true,
                  onTap: noAction,
                  title: 'Title',
                  icon: CupertinoIcons.square,
                ),
              ],
            ),
            LabeledExample(
              label: 'Disabled PullDownMenuItem',
              items: [
                PullDownMenuItem(
                  enabled: false,
                  onTap: noAction,
                  subtitle: 'Subtitle',
                  title: 'Title',
                  icon: CupertinoIcons.square,
                ),
              ],
            ),
            LabeledExample(
              label: 'Disabled PullDownMenuItem.selectable',
              items: [
                PullDownMenuItem.selectable(
                  selected: true,
                  enabled: false,
                  onTap: noAction,
                  subtitle: 'Subtitle',
                  title: 'Title',
                  icon: CupertinoIcons.square,
                ),
              ],
            ),
          ],
        ),
      );
}
