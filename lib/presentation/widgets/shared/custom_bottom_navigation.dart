import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../presentation.dart';

class CustomBottomNavigation extends StatelessWidget {
  final int currentIndex;

  const CustomBottomNavigation({super.key, required this.currentIndex});

  void mostrarModalNuevaPublicacion(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => NuevaPublicacionModal(),
    );
  }

  void onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/home/0');
        break;
      case 1:
        mostrarModalNuevaPublicacion(context);
        break;
      case 2:
        context.go('/home/2');
        break;
      case 3:
        context.go('/home/3');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;

    return Container(
      height: 60, // Reducido de 80 a 60
      // decoration: BoxDecoration(
      //   // color: Colors.white,
      //   // boxShadow: [
      //   //   BoxShadow(
      //   //     color: Colors.black.withOpacity(0.1),
      //   //     blurRadius: 8,
      //   //     offset: Offset(0, -2),
      //   //   ),
      //   // ],
      // ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 12.0,
            vertical: 4.0,
          ), // Padding reducido
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                context: context,
                index: 0,
                icon: Icons.home_outlined,
                activeIcon: Icons.home,
                label: 'Inicio',
                isSelected: currentIndex == 0,
                color: color,
              ),
              _buildNavItem(
                context: context,
                index: 1,
                icon: Icons.add_box_outlined,
                activeIcon: Icons.add_box_outlined,
                label: 'Agregar Publicación',
                isSelected: currentIndex == 1,
                color: color,
              ),
              _buildNavItem(
                context: context,
                index: 2,
                icon: Icons.bookmark_outlined,
                activeIcon: Icons.bookmark,
                label: 'Favoritos',
                isSelected: currentIndex == 2,
                color: color,
              ),
              _buildNavItem(
                context: context,
                index: 3,
                icon: Icons.person_outlined,
                activeIcon: Icons.person,
                label: 'Perfil',
                isSelected: currentIndex == 3,
                color: color,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required int index,
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required bool isSelected,
    required Color color,
  }) {
    return GestureDetector(
      onTap: () => onItemTapped(context, index),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(
          horizontal: isSelected ? 12 : 8, // Padding reducido
          vertical: 6, // Padding vertical reducido
        ),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.transparent,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedSwitcher(
              duration: Duration(milliseconds: 200),
              child: Icon(
                isSelected ? activeIcon : icon,
                key: ValueKey(isSelected),
                color: isSelected ? Colors.white : Colors.grey,
                size: 20, // Íconos más pequeños
              ),
            ),
            AnimatedSize(
              duration: Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: isSelected
                  ? Padding(
                      padding: const EdgeInsets.only(
                        left: 6.0,
                      ), // Espacio reducido
                      child: AnimatedOpacity(
                        duration: Duration(milliseconds: 400),
                        opacity: isSelected ? 1.0 : 0.0,
                        child: Text(
                          label,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 12, // Texto más pequeño
                          ),
                        ),
                      ),
                    )
                  : SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}
