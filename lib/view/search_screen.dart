import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:first_snow/provider/card_select_provider.dart';
import 'package:first_snow/component/user_card.dart';

class SearchScreen extends StatelessWidget {
  SearchScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<CardSelectProvider>(
      builder: (context, cardSelectProvider, child) {
        void _onTap(int index) {
          cardSelectProvider.updateIndex(index);
        }

        return GestureDetector(
          onTap: () => _onTap(-1),
          child: CustomScrollView(
            slivers: [
              SliverPadding(
                padding: EdgeInsets.all(10),
                sliver: SliverGrid.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 5,
                  childAspectRatio: 0.75,
                  children: [
                    UserCard(
                      index: 1,
                      selectedIndex: cardSelectProvider.selectedIndex,
                      onTap: _onTap,
                    ),
                    UserCard(
                      index: 2,
                      selectedIndex: cardSelectProvider.selectedIndex,
                      onTap: _onTap,
                    ),
                    UserCard(
                      index: 3,
                      selectedIndex: cardSelectProvider.selectedIndex,
                      onTap: _onTap,
                    ),
                    UserCard(
                      index: 4,
                      selectedIndex: cardSelectProvider.selectedIndex,
                      onTap: _onTap,
                    ),
                    UserCard(
                      index: 5,
                      selectedIndex: cardSelectProvider.selectedIndex,
                      onTap: _onTap,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Padding(
  //     padding: EdgeInsets.all(10),
  //     child: GridView(
  //       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
  //         crossAxisCount: 2,
  //         crossAxisSpacing: 5,
  //         mainAxisSpacing: 5,
  //         childAspectRatio: 0.75,
  //       ),
  //       children: [
  //         UserCard(index: 1),
  //         UserCard(index: 2),
  //         UserCard(index: 3),
  //         UserCard(index: 4),
  //         UserCard(index: 5),
  //       ],
  //     ),
  //   );
  // }
}
