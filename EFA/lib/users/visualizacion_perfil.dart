import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:efa/colors.dart';
import 'package:http/http.dart' as http;
import '../Models/Persona.dart'; // Importa el archivo que contiene el modelo Persona

class VisualizacionPerfil extends StatefulWidget {
  final Persona persona; // Recibe una instancia de Persona como parámetro

  VisualizacionPerfil({required this.persona});

  @override
  _VisualizacionPerfilState createState() => _VisualizacionPerfilState();
}

class _VisualizacionPerfilState extends State<VisualizacionPerfil> {
  Future<void> _cerrarSesion() async {
    String idpersona = widget.persona.idpersona;
    print("Cerrando sesión para persona con ID: $idpersona");

    try {
      final response = await http.get(
        Uri.parse('http://dtai.uteq.edu.mx/~corjua228/awos/androidServices/cierra.php?idpersona=$idpersona'),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        Map<String, dynamic> responseBody = jsonDecode(response.body);
        bool resultado = responseBody['resultado'];

        if (resultado) {
          // Si el cierre de sesión fue exitoso, navega fuera de la pantalla
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Sesión cerrada exitosamente.')),
          );
          Navigator.pushNamed(context, 'public/home');
        } else {
          // Muestra un error si la respuesta no es exitosa
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error al cerrar la sesión.')),
          );
        }
      } else {
        throw Exception('Error al cerrar sesión: ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      print('Error al cerrar sesión: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error de conexión al cerrar sesión.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.azul,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 40),
            Text(
              'Tu información',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: Image.asset(
                'assets/traslucentblacklogo.png',
                height: 100,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Usuario',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('*Nombre completo: ${widget.persona.nombre}', style: TextStyle(fontSize: 16)),
                  SizedBox(height: 10),
                  Text('*Apellidos: ${widget.persona.apellidos}', style: TextStyle(fontSize: 16)),
                  SizedBox(height: 10),
                  Text('Correo: ${widget.persona.correo}', style: TextStyle(fontSize: 16)),
                ],
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // Llama al método para cerrar la sesión cuando se presiona el botón
                await _cerrarSesion();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, // Color rojo para el botón
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              child: Text(
                'Cerrar sesión',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
