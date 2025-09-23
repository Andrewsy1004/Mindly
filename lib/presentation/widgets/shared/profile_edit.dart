import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mindly/domain/entities/user.dart';

import 'package:mindly/presentation/presentation.dart';
import 'package:mindly/shared/shared.dart';

class ProfileEdit extends ConsumerStatefulWidget {
  static const name = 'profile-edit';

  const ProfileEdit({super.key});

  @override
  ConsumerState<ProfileEdit> createState() => _ProfileEditState();
}

class _ProfileEditState extends ConsumerState<ProfileEdit> {
  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _professionController = TextEditingController();
  final _bioController = TextEditingController();
  final _emailController = TextEditingController();

  // Variable para controlar si hay cambios sin guardar
  bool _hasUnsavedChanges = false;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeFields();
    });
  }

  void _initializeFields() {
    final authState = ref.read(authProvider);

    if (authState.user != null && !_isInitialized) {
      final user = authState.user!;

      _nameController.text = user.nombre;
      _usernameController.text = user.roles.join(', ');
      _professionController.text = user.profesion;
      _bioController.text = user.biografia;
      _emailController.text = user.correo;

      _isInitialized = true;

      _nameController.addListener(() => _setUnsavedChanges(true));
      _professionController.addListener(() => _setUnsavedChanges(true));
      _bioController.addListener(() => _setUnsavedChanges(true));
      _emailController.addListener(() => _setUnsavedChanges(true));
    }
  }

  void _setUnsavedChanges(bool hasChanges) {
    if (_hasUnsavedChanges != hasChanges) {
      setState(() {
        _hasUnsavedChanges = hasChanges;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _professionController.dispose();
    _bioController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    if (authState.user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // Inicializar campos si aún no se ha hecho
    if (!_isInitialized) {
      _initializeFields();
    }

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Editar perfil'),
        centerTitle: true,
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
                  // Avatar circular con iniciales del usuario
                  _buildUserAvatar(authState.user!),

                  const SizedBox(height: 20),

                  // Lista de campos editables con iconos
                  _buildEditableProfileItem(
                    icon: Icons.person_outline,
                    label: 'Nombre',
                    controller: _nameController,
                    maxLines: 1,
                  ),
                  // _buildEditableProfileItem(
                  //   icon: Icons.group_outlined,
                  //   label: 'Roles',
                  //   controller: _usernameController,
                  //   maxLines: 1,
                  //   isReadOnly: true,
                  // ),
                  _buildEditableProfileItem(
                    icon: Icons.work_outline,
                    label: 'Profesión',
                    controller: _professionController,
                    maxLines: 1,
                  ),
                  _buildEditableProfileItem(
                    icon: Icons.description_outlined,
                    label: 'Biografía',
                    controller: _bioController,
                    maxLines: 3,
                  ),
                  _buildEditableProfileItem(
                    icon: Icons.email_outlined,
                    label: 'Correo electrónico',
                    controller: _emailController,
                    maxLines: 1,
                    keyboardType: TextInputType.emailAddress,
                  ),

                  const SizedBox(height: 16),

                  // Theme Changer integrado
                  const ThemeChangerExpansionView(),

                  const SizedBox(height: 20),

                  // Botón Guardar Cambios
                  if (_hasUnsavedChanges)
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 16),
                      child: ElevatedButton(
                        onPressed: _saveChanges,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                        ),
                        child: const Text(
                          'Guardar Cambios',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
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

  Widget _buildUserAvatar(User user) {
    final color = Theme.of(context).colorScheme.primary;

    // Obtener iniciales del nombre
    String getInitials() {
      if (user.nombre.isEmpty) {
        return user.correo.substring(0, 1).toUpperCase();
      }

      final names = user.nombre.split(' ');
      if (names.length >= 2) {
        return '${names[0][0]}${names[1][0]}'.toUpperCase();
      } else {
        return names[0].substring(0, 1).toUpperCase();
      }
    }

    return Stack(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: color,
          child: user.fotoPerfil.isNotEmpty
              ? ClipOval(
                  child: Image.network(
                    user.fotoPerfil,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Text(
                        getInitials(),
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      );
                    },
                  ),
                )
              : Text(
                  getInitials(),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: GestureDetector(
            onTap: _changeAvatar,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Icon(Icons.camera_alt, size: 16, color: Colors.grey[600]),
            ),
          ),
        ),
      ],
    );
  }

  void _changeAvatar() {
    // TODO: Implementar cambio de avatar con Cloudinary
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Funcionalidad de cambio de avatar próximamente'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Widget _buildEditableProfileItem({
    required IconData icon,
    required String label,
    required TextEditingController controller,
    int maxLines = 1,
    TextInputType? keyboardType,
    bool isReadOnly = false,
  }) {
    final color = Theme.of(context).colorScheme.primary;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header con icono y label
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, size: 20, color: color),
                ),
                const SizedBox(width: 12),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (isReadOnly)
                  Container(
                    margin: const EdgeInsets.only(left: 8),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'Solo lectura',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.orange[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 12),

            // Campo de texto editable
            TextFormField(
              controller: controller,
              maxLines: maxLines,
              keyboardType: keyboardType,
              readOnly: isReadOnly,
              style: TextStyle(
                fontSize: 16,
                color: isReadOnly ? Colors.grey[600] : Colors.black87,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: color, width: 2),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade200),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
                filled: true,
                fillColor: isReadOnly ? Colors.grey[100] : Colors.grey[50],
                hintText: isReadOnly
                    ? null
                    : (label == 'Biografía'
                          ? 'Cuéntanos un poco sobre ti...'
                          : 'Ingresa tu $label'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _saveChanges() async {
    try {
      final authNotifier = ref.read(authProvider.notifier);
      final authState = ref.read(authProvider);

      final token = await authNotifier.keyValueStorageService.getToken();

      // Validar que los campos no esten vacios
      if (_nameController.text.isEmpty ||
          _usernameController.text.isEmpty ||
          _professionController.text.isEmpty ||
          _bioController.text.isEmpty ||
          _emailController.text.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Todos los campos son obligatorios'),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          );
        }
        return;
      }

      // Guardar los cambios en la base de datos
      final updatedUser = User(
        nombre: _nameController.text,
        correo: _emailController.text,
        roles: _usernameController.text.split(', '),
        profesion: _professionController.text,
        biografia: _bioController.text,
        fotoPerfil: authState.user!.fotoPerfil,
        uid: authState.user!.uid,
        token: authState.user!.token,
      );

      await authNotifier.updateUser(authState.user!.token, updatedUser);

      // Mostrar mensaje de éxito
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Perfil actualizado correctamente'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );

        // Resetear el estado de cambios no guardados
        setState(() {
          _hasUnsavedChanges = false;
        });

        Future.delayed(const Duration(milliseconds: 800), () {
          if (mounted) {
            context.pop(true);
          }
        });
      }
    } catch (e) {
      print('Error al guardar: ${e.toString()}');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al guardar: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      }
    }
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Consumer(
          builder: (context, ref, child) {
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
                      await ref.read(authProvider.notifier).logout();

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
            "Color actual: ${colors[selectedColor].toARGB32().toRadixString(16).toUpperCase()}",
            style: TextStyle(fontSize: 13, color: Colors.grey[600]),
          ),
          children: [
            for (int index = 0; index < colors.length; index++)
              RadioListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                title: Text(
                  colors[index].toARGB32().toRadixString(16).toUpperCase(),
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
}
