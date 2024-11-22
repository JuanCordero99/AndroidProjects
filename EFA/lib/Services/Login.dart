import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Models/Persona.dart';  // Importa el modelo Persona

class AuthService {
  final String apiUrl = 'http://dtai.uteq.edu.mx/~corjua228/awos/androidServices/autorizaAndroid.php';  // URL de tu API

  // Método para autenticar un usuario
  Future<Persona?> authenticateUser(String usuario, String contrasenia) async {
    try {
      // Construir el cuerpo de la petición
      Map<String, String> body = {
        'usuario': usuario,
        'contra': contrasenia,
      };

      // Realizar la petición POST al servidor
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: body,
      );

      // Verificar si la respuesta fue exitosa
      if (response.statusCode == 200) {
        // Decodificar la respuesta en formato JSON
        Map<String, dynamic> jsonResponse = jsonDecode(response.body);

        // Verificar si el resultado fue exitoso
        if (jsonResponse['resultado'] == true) {
          // Crear y devolver una instancia de Persona con los datos recibidos
          return Persona.fromJson(jsonResponse);
        } else {
          print(jsonResponse['mensaje']);  // Mostrar mensaje de error
          return null;
        }
      } else {
        throw Exception('Error en la autenticación. Código de estado: ${response.statusCode}');
      }
    } catch (e) {
      print('Error al autenticar el usuario: $e');
      return null;
    }
  }
}
