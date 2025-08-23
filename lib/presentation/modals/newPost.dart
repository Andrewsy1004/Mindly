import 'dart:io';
import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';

class NuevaPublicacionModal extends StatefulWidget {
  const NuevaPublicacionModal({super.key});

  @override
  State<NuevaPublicacionModal> createState() => _NuevaPublicacionModalState();
}

class _NuevaPublicacionModalState extends State<NuevaPublicacionModal> {
  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _contenidoController = TextEditingController();
  final TextEditingController _palabrasClaveController =
      TextEditingController();

  File? _imagenSeleccionada;
  String? _categoriaSeleccionada;
  // final ImagePicker _picker = ImagePicker();

  final List<String> categorias = [
    'Tecnología',
    'Deportes',
    'Entretenimiento',
    // 'Noticias',
    // 'Educación',
    // 'Salud',
    // 'Viajes',
    // 'Comida',
  ];

  @override
  void dispose() {
    _tituloController.dispose();
    _contenidoController.dispose();
    _palabrasClaveController.dispose();
    super.dispose();
  }

  Future<void> _seleccionarImagen() async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 150,
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Text(
                'Seleccionar imagen',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () async {
                      Navigator.pop(context);
                      // final XFile? image = await _picker.pickImage(
                      //   source: ImageSource.camera,
                      // );
                      // if (image != null) {
                      //   setState(() {
                      //     _imagenSeleccionada = File(image.path);
                      //   });
                      // }
                    },
                    child: Column(
                      children: [
                        Icon(Icons.camera_alt, size: 40),
                        Text('Cámara'),
                      ],
                    ),
                  ),
                  GestureDetector(
                    // onTap: () async {
                    //   Navigator.pop(context);
                    //   final XFile? image = await _picker.pickImage(
                    //     source: ImageSource.gallery,
                    //   );
                    //   if (image != null) {
                    //     setState(() {
                    //       _imagenSeleccionada = File(image.path);
                    //     });
                    //   }
                    // },
                    child: Column(
                      children: [
                        Icon(Icons.photo_library, size: 40),
                        Text('Galería'),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _publicar() {
    // Aquí implementarías la lógica para publicar
    // Por ahora solo mostramos un mensaje
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Publicación creada exitosamente'),
        backgroundColor: Colors.green,
      ),
    );
    Navigator.of(context).pop(); // Cierra el modal
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;

    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      width: MediaQuery.of(context).size.width * 0.9,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // Header del modal
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Icon(Icons.close, size: 24),
                  ),
                  Text(
                    'Nueva publicación',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 24), // Para balancear el diseño
                ],
              ),
            ),

            // Contenido del modal
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Campo Título
                    Text(
                      'Título',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    SizedBox(height: 8),
                    TextField(
                      controller: _tituloController,
                      decoration: InputDecoration(
                        hintText: 'Escribe el título...',
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),

                    SizedBox(height: 20),

                    // Campo Contenido
                    Text(
                      'Contenido',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    SizedBox(height: 8),
                    TextField(
                      controller: _contenidoController,
                      maxLines: 5,
                      decoration: InputDecoration(
                        hintText: 'Escribe el contenido...',
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),

                    SizedBox(height: 20),

                    // Imagen destacada
                    Text(
                      'Imagen destacada',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    SizedBox(height: 8),

                    GestureDetector(
                      onTap: _seleccionarImagen,
                      child: Container(
                        height: 120,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.grey.shade300,
                            style: BorderStyle.solid,
                          ),
                        ),
                        child: _imagenSeleccionada != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.file(
                                  _imagenSeleccionada!,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.add_photo_alternate_outlined,
                                    size: 40,
                                    color: Colors.grey.shade600,
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Añadir imagen',
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    'Selecciona una imagen para la publicación',
                                    style: TextStyle(
                                      color: Colors.grey.shade500,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),

                    if (_imagenSeleccionada != null) ...[
                      SizedBox(height: 8),
                      Center(
                        child: TextButton(
                          onPressed: _seleccionarImagen,
                          child: Text('Seleccionar imagen'),
                        ),
                      ),
                    ],

                    SizedBox(height: 20),

                    // Categoría
                    Text(
                      'Categoría',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    SizedBox(height: 8),

                    GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return Container(
                              padding: EdgeInsets.all(20),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Seleccionar categoría',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  ...categorias.map((categoria) {
                                    return ListTile(
                                      title: Text(categoria),
                                      onTap: () {
                                        setState(() {
                                          _categoriaSeleccionada = categoria;
                                        });
                                        Navigator.pop(context);
                                      },
                                    );
                                  }).toList(),
                                ],
                              ),
                            );
                          },
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _categoriaSeleccionada ?? 'Seleccionar categoría',
                              style: TextStyle(
                                color: _categoriaSeleccionada != null
                                    ? Colors.black
                                    : Colors.grey.shade600,
                              ),
                            ),
                            Icon(Icons.arrow_drop_down),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 20),

                    // Palabras clave
                    Text(
                      'Palabras clave',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    SizedBox(height: 8),
                    TextField(
                      controller: _palabrasClaveController,
                      decoration: InputDecoration(
                        hintText: 'Añadir palabras clave',
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Botón Publicar
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: _publicar,
                style: ElevatedButton.styleFrom(
                  backgroundColor: color,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Publicar',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
