import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Registro(),
    );
  }
}

class Registro extends StatefulWidget {
  @override
  _RegistroState createState() => _RegistroState();
}

class _RegistroState extends State<Registro> {
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController apellidosController = TextEditingController();
  final TextEditingController correoController = TextEditingController();
  final TextEditingController contraController = TextEditingController();

  Future<void> registrarUsuario() async {
    final nombre = nombreController.text;
    final apellidos = apellidosController.text;
    final correo = correoController.text;
    final contra = contraController.text;

    // Validar campos obligatorios
    if (nombre.isEmpty || correo.isEmpty || contra.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor, complete todos los campos obligatorios')),
      );
      return;
    }

    // Expresión regular para validar la contraseña
    final regex = RegExp(r'^(?=.*[A-Z])(?=.*[0-9]).{8,}$');
    if (!regex.hasMatch(contra)) {
      print("Contraseña no válida: $contra"); // Diagnóstico
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('La contraseña debe tener al menos 8 caracteres, incluir mayúsculas y números')),
      );
      return;
    }

    final url = Uri.parse('http://dtai.uteq.edu.mx/~corjua228/awos/androidServices/nuevo.php');
    final response = await http.post(
      url,
      body: {
        'nombre': nombre,
        'apellidos': apellidos,
        'correo': correo,
        'contra': contra,
      },
    );

    final respuesta = json.decode(response.body);

    if (respuesta['resultado']) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registro Exitoso')),
      );
      Navigator.pushNamed(context, '/inicio_sesion');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ocurrió un error, inténtalo de nuevo')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Regístrate',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Text('*Nombre', style: TextStyle(fontSize: 16)),
            TextFormField(
              controller: nombreController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            Text('*Apellidos', style: TextStyle(fontSize: 16)),
            TextFormField(
              controller: apellidosController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            Text('*Correo electrónico', style: TextStyle(fontSize: 16)),
            TextFormField(
              controller: correoController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            Text('*Contraseña', style: TextStyle(fontSize: 16)),
            TextFormField(
              controller: contraController,
              obscureText: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: registrarUsuario,
                child: Text('Registrarse'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
