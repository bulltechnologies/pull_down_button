import 'package:flutter/cupertino.dart';
import 'package:pull_down_button/pull_down_button.dart';

import 'example_scaffold.dart';

@immutable
class Divider extends StatelessWidget {
  const Divider({super.key});

  @override
  Widget build(BuildContext context) => CupertinoPageScaffold(
        navigationBar: ExampleScaffoldNavigationBar(
          title: 'PullDownMenuDivider',
        ),
        child: ListView(
          children: const [
            LabeledExample(
              label: 'PullDownMenuDivider (default separator)',
              items: [
                PullDownMenuItem(
                  onTap: noAction,
                  title: 'First Item',
                  icon: CupertinoIcons.square,
                ),
                PullDownMenuItem(
                  onTap: noAction,
                  title: 'Second Item',
                  icon: CupertinoIcons.square,
                ),
              ],
            ),
            LabeledExample(
              label: 'PullDownMenuDivider (large)',
              items: [
                PullDownMenuItem(
                  onTap: noAction,
                  title: 'Section 1',
                  icon: CupertinoIcons.folder,
                ),
                PullDownMenuDivider(),
                PullDownMenuItem(
                  onTap: noAction,
                  title: 'Section 2',
                  icon: CupertinoIcons.gear,
                ),
              ],
            ),
            LabeledExample(
              label: 'PullDownMenuDivider with custom indents',
              items: [
                PullDownMenuItem(
                  onTap: noAction,
                  title: 'Option A',
                  icon: CupertinoIcons.star,
                ),
                PullDownMenuDivider(
                  indent: 16,
                  endIndent: 16,
                ),
                PullDownMenuItem(
                  onTap: noAction,
                  title: 'Option B',
                  icon: CupertinoIcons.heart,
                ),
              ],
            ),
          ],
        ),
      );
}
