import 'package:flutter/material.dart';
import 'package:mindly/presentation/presentation.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        const SliverAppBar(
          floating: true,
          flexibleSpace: FlexibleSpaceBar(
            titlePadding: EdgeInsets.all(0),
            title: CustomAppbar(),
          ),
        ),

        // Topics
        SliverToBoxAdapter(child: PostTopicsSlideshow()),

        const SliverToBoxAdapter(child: SizedBox(height: 5)),

        // Profiles
        SliverToBoxAdapter(child: UserProfilesSlideshow()),

        const SliverToBoxAdapter(child: SizedBox(height: 5)),

        // Posts con scroll infinito
        PostScrollVerticalSliver(),
      ],
    );
  }
}
