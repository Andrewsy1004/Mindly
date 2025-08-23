import 'package:flutter/material.dart';
import 'package:mindly/presentation/delegates/search_post.dart';

class CustomAppbar extends StatelessWidget {
  const CustomAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    final tittleStyle = Theme.of(context).textTheme.titleMedium!;

    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: SizedBox(
          width: double.infinity,
          height: kToolbarHeight,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Center(child: Text('Mindly', style: tittleStyle)),
              Positioned(
                right: 0,
                child: IconButton(
                  onPressed: () {
                    showSearch(
                      context: context,
                      delegate: SearchMovieDelegate(),
                    );
                  },
                  icon: Icon(Icons.search, color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
