import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:mindly/presentation/presentation.dart';
import 'package:mindly/shared/shared.dart';

class ProfileEdit extends ConsumerWidget {
  static const name = 'profile-edit';

  const ProfileEdit({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Editar perfil'),
        centerTitle: true,
        // backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                children: [
                  // Avatar circular más compacto
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.teal,
                        child: Icon(
                          Icons.person,
                          size: 45,
                          color: Colors.white,
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Icon(
                            Icons.camera_alt,
                            size: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Lista de campos con iconos
                  _buildProfileItem(
                    icon: Icons.person_outline,
                    label: 'Nombre',
                    value: 'Ethan Carter',
                    context: context,
                    ref: ref,
                  ),
                  _buildProfileItem(
                    icon: Icons.alternate_email,
                    label: 'Username',
                    value: '@ethan_c',
                    context: context,
                    ref: ref,
                  ),
                  _buildProfileItem(
                    icon: Icons.work_outline,
                    label: 'Profesión',
                    value: 'Científico de datos',
                    context: context,
                    ref: ref,
                  ),
                  _buildProfileItem(
                    icon: Icons.description_outlined,
                    label: 'Biografía',
                    value: 'Soy un científico...',
                    context: context,
                    ref: ref,
                  ),
                  _buildProfileItem(
                    icon: Icons.email_outlined,
                    label: 'Correo',
                    value: 'Ethan@gmail.com',
                    context: context,
                    ref: ref,
                  ),

                  const SizedBox(height: 16),

                  // Theme Changer integrado
                  const ThemeChangerExpansionView(),
                ],
              ),
            ),
          ),

          // Botón Cerrar Sesión
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  _showLogoutDialog(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Cerrar Sesión',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileItem({
    required IconData icon,
    required String label,
    required String value,
    required BuildContext context,
    required WidgetRef ref,
  }) {
    final color = Theme.of(context).colorScheme.primary;
    final int selectedColor = ref.watch(appThemeProvider).selectedColor;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 20, color: color),
        ),
        title: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey[600],
            fontWeight: FontWeight.w400,
          ),
        ),
        subtitle: Text(
          value,
          style: const TextStyle(
            fontSize: 15,
            color: Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: Icon(Icons.chevron_right, color: color, size: 20),
        onTap: () {
          _navigateToEditField(label, value);
        },
      ),
    );
  }

  void _navigateToEditField(String field, String currentValue) {
    print('Editando: $field con valor: $currentValue');
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Cerrar Sesión',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          content: const Text(
            '¿Estás seguro de que quieres cerrar sesión?',
            style: TextStyle(fontSize: 15),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancelar',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
            TextButton(
              onPressed: () async {
                try {
                  await KeyValueStorageServices().logout();

                  if (context.mounted) {
                    context.go('/signup');
                  }
                } catch (e) {
                  print("Error al cerrar sesion: $e");
                }
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text(
                'Cerrar Sesión',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        );
      },
    );
  }
}

class ThemeChangerExpansionView extends ConsumerWidget {
  const ThemeChangerExpansionView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<Color> colors = ref.watch(colorListProvider);
    final int selectedColor = ref.watch(appThemeProvider).selectedColor;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: colors[selectedColor].withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          childrenPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: colors[selectedColor].withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.palette_outlined,
              size: 20,
              color: colors[selectedColor],
            ),
          ),
          title: const Text(
            "Seleccionar color del tema",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          ),
          subtitle: Text(
            // "Color actual: ${_getColorName(selectedColor)}",
            "Color actual: ${colors[selectedColor].toARGB32().toRadixString(16).toUpperCase()}",
            style: TextStyle(fontSize: 13, color: Colors.grey[600]),
          ),
          children: [
            for (int index = 0; index < colors.length; index++)
              RadioListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                title: Text(
                  colors[index].toARGB32().toRadixString(16).toUpperCase(),
                  // _getColorName(index),
                  style: TextStyle(
                    color: colors[index],
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                subtitle: Text(
                  colors[index].toARGB32().toRadixString(16).toUpperCase(),
                  style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                ),
                activeColor: colors[index],
                value: index,
                groupValue: selectedColor,
                onChanged: (value) {
                  if (value != null) {
                    ref.read(appThemeProvider.notifier).changeColor(value);
                  }
                },
              ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  //   String _getColorName(int index) {
  //     const colorNames = [
  //       'Azul',
  //       'Verde azulado',
  //       'Verde',
  //       'Rojo',
  //       'Morado',
  //       'Naranja',
  //       'Rosa',
  //       'Índigo',
  //     ];

  //     if (index >= 0 && index < colorNames.length) {
  //       return colorNames[index];
  //     }
  //     return 'Color $index';
  //   }
  // }
}
