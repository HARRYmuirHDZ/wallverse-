import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class FirebaseStorageService {
  Future<String?> subirImagen() async {
    // 1. Seleccionar imagen del dispositivo
    final picker = ImagePicker();
    final XFile? imagen = await picker.pickImage(source: ImageSource.gallery);

    if (imagen == null) return null;

    // 2. Crear referencia en Storage
    final storageRef = FirebaseStorage.instance
        .ref()
        .child('imagenes/${DateTime.now().millisecondsSinceEpoch}.jpg');

    // 3. Subir el archivo
    final uploadTask = await storageRef.putFile(File(imagen.path));

    // 4. Obtener la URL pública
    final url = await uploadTask.ref.getDownloadURL();

    return url; // Esta URL la puedes guardar en Firestore o donde quieras
  }
}
