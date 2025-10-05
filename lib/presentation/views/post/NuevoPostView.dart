import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Nuevopostview extends StatefulWidget {
  static const name = 'nueva-publicacion';

  const Nuevopostview({super.key});

  @override
  State<Nuevopostview> createState() => _NuevaPublicacionScreenState();
}

class _NuevaPublicacionScreenState extends State<Nuevopostview> {
  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();
  final TextEditingController _categoriaController = TextEditingController();
  final List<String> _tags = [];
  final TextEditingController _tagController = TextEditingController();

  File? _imagenSeleccionada;
  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _tituloController.dispose();
    _descripcionController.dispose();
    _categoriaController.dispose();
    _tagController.dispose();
    super.dispose();
  }

  void _agregarTag() {
    if (_tagController.text.trim().isNotEmpty) {
      setState(() {
        _tags.add(_tagController.text.trim().toLowerCase());
        _tagController.clear();
      });
    }
  }

  void _eliminarTag(int index) {
    setState(() {
      _tags.removeAt(index);
    });
  }

  Future<void> _seleccionarImagen() async {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Seleccionar imagen',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildImageSourceButton(
                    icon: Icons.camera_alt,
                    label: 'Cámara',
                    onTap: () async {
                      Navigator.pop(context);
                      final XFile? image = await _picker.pickImage(
                        source: ImageSource.camera,
                        maxWidth: 1920,
                        maxHeight: 1080,
                        imageQuality: 85,
                      );
                      if (image != null) {
                        setState(() {
                          _imagenSeleccionada = File(image.path);
                        });
                      }
                    },
                  ),
                  _buildImageSourceButton(
                    icon: Icons.photo_library,
                    label: 'Galería',
                    onTap: () async {
                      Navigator.pop(context);
                      final XFile? image = await _picker.pickImage(
                        source: ImageSource.gallery,
                        maxWidth: 1920,
                        maxHeight: 1080,
                        imageQuality: 85,
                      );
                      if (image != null) {
                        setState(() {
                          _imagenSeleccionada = File(image.path);
                        });
                      }
                    },
                  ),
                ],
              ),
              SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildImageSourceButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    final color = Theme.of(context).colorScheme.primary;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, size: 40, color: color),
            SizedBox(height: 8),
            Text(label, style: TextStyle(fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }

  void _publicar() {
    // Validación básica
    if (_tituloController.text.isEmpty ||
        _descripcionController.text.isEmpty ||
        _imagenSeleccionada == null ||
        _categoriaController.text.isEmpty ||
        _tags.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Por favor completa todos los campos'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    // Crear el objeto con los datos del post
    final postData = {
      "titulo": _tituloController.text,
      "descripcion": _descripcionController.text,
      "imagen": _imagenSeleccionada!.path, // Path local de la imagen
      "categoria": _categoriaController.text,
      "tags": _tags,
    };

    print('Datos del post: $postData');

    // TODO: Aquí subirías la imagen a Cloudinary primero

    // TODO: Luego harías el POST a tu API

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Publicación creada exitosamente'),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text('Nueva publicación'),
        centerTitle: true,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Campo Título
            _buildLabel('Título'),
            SizedBox(height: 8),
            TextField(
              controller: _tituloController,
              decoration: InputDecoration(
                hintText: 'Escribe el título del post...',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: color, width: 2),
                ),
              ),
            ),

            SizedBox(height: 20),

            // Campo Descripción
            _buildLabel('Descripción'),
            SizedBox(height: 8),
            TextField(
              controller: _descripcionController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Escribe la descripción del post...',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: color, width: 2),
                ),
              ),
            ),

            SizedBox(height: 20),

            // Imagen del dispositivo
            _buildLabel('Imagen'),
            SizedBox(height: 8),
            GestureDetector(
              onTap: _seleccionarImagen,
              child: Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.grey.shade300,
                    width: 2,
                    style: BorderStyle.solid,
                  ),
                ),
                child: _imagenSeleccionada != null
                    ? Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.file(
                              _imagenSeleccionada!,
                              width: double.infinity,
                              height: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _imagenSeleccionada = null;
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.close,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add_photo_alternate_outlined,
                            size: 50,
                            color: Colors.grey.shade400,
                          ),
                          SizedBox(height: 12),
                          Text(
                            'Seleccionar imagen',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Toca para elegir de galería o cámara',
                            style: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
              ),
            ),

            SizedBox(height: 20),

            // Categoría (campo de texto editable)
            _buildLabel('Categoría'),
            SizedBox(height: 8),
            TextField(
              controller: _categoriaController,
              decoration: InputDecoration(
                hintText: 'Escribe la categoría (ej: Programación)',
                filled: true,
                fillColor: Colors.white,
                prefixIcon: Icon(Icons.category_outlined, color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: color, width: 2),
                ),
              ),
            ),

            SizedBox(height: 20),

            // Tags
            _buildLabel('Tags'),
            SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _tagController,
                    onSubmitted: (_) => _agregarTag(),
                    decoration: InputDecoration(
                      hintText: 'Escribe un tag y presiona Enter',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: color, width: 2),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                IconButton(
                  onPressed: _agregarTag,
                  icon: Icon(Icons.add_circle, color: color, size: 32),
                ),
              ],
            ),

            SizedBox(height: 12),

            // Lista de tags agregados
            if (_tags.isNotEmpty)
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _tags.asMap().entries.map((entry) {
                  return Chip(
                    label: Text(entry.value),
                    deleteIcon: Icon(Icons.close, size: 18),
                    onDeleted: () => _eliminarTag(entry.key),
                    backgroundColor: color.withOpacity(0.1),
                    labelStyle: TextStyle(color: color),
                  );
                }).toList(),
              ),

            SizedBox(height: 40),

            // Botón Publicar
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _publicar,
                style: ElevatedButton.styleFrom(
                  backgroundColor: color,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                child: Text(
                  'Publicar',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),

            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 15,
        color: Colors.grey.shade700,
      ),
    );
  }
}
