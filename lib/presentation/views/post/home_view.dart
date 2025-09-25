import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindly/presentation/presentation.dart';

class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersState = ref.watch(usersSliderProvider).users;
    final color = Theme.of(context).colorScheme.primary;

    if (usersState.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

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
        SliverToBoxAdapter(child: UserProfilesSlideshow(users: usersState)),

        const SliverToBoxAdapter(child: SizedBox(height: 5)),

        // Posts con scroll infinito
        PostScrollVerticalSliver(),
      ],
    );
  }
}
