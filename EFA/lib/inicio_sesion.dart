import 'package:efa/colors.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:efa/assets/colors.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'Models/Persona.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EFA',
      home: InicioSesion(),
    );
  }
}

class InicioSesion extends StatefulWidget {
  @override
  _InicioSesionState createState() => _InicioSesionState();
}

class _InicioSesionState extends State<InicioSesion> {
  final TextEditingController _correoController = TextEditingController();
  final TextEditingController _contrasenaController = TextEditingController();

  Persona? persona;

  Future<void> iniciarSesion() async {
    String correo = _correoController.text;
    String contrasena = _contrasenaController.text;

    if (correo.isEmpty || contrasena.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor, llena todos los campos')),
      );
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('http://dtai.uteq.edu.mx/~corjua228/awos/androidServices/autorizaAndroid.php'),
        body: {
          'usuario': correo,
          'contra': contrasena,
        },
      );

      if (response.statusCode == 200) {
        print('Respuesta del servidor: ${response.body}'); // Agregar esta línea
        var data = json.decode(response.body);

        // Cambiar tipo a bool para resultado
        bool resultado = data['resultado'] ; // Asignar un valor por defecto si es nulo
        String mensaje = data['mensaje'] ; // Asignar un valor por defecto si es nulo
        String perfil = data['perfil']; // Asignar un valor por defecto si es nulo
        String sesion = data['sesion'] ; // Convertir a String y asignar un valor por defecto si es nulo

        if (resultado) {
          // Almacenar los datos de la persona en la variable `persona`
          persona = Persona.fromJson(data);
          print('ID de persona: ${persona?.idpersona}'); // Para verificar que se esté guardando correctamente

          if (sesion == "0" || sesion == "1") { // Verificar que sesion es un entero
            if (perfil == "1") {
              Navigator.pushNamed(context, 'users/home', arguments: persona);
            } else{
              Navigator.pushNamed(context, 'admin/home', arguments: persona);
            }
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Bienvenido')),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('El usuario ya tiene dos sesiones abiertas')),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(mensaje)),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error en el servidor')),
        );
    }
    } catch (e) {
      print (e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error en la conexión: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        color: AppColors.azul,
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 20),
                Image.asset(
                  'assets/traslucentblacklogo.png', // Reemplaza con la ubicación de tu logo
                  height: 100,
                ),
                SizedBox(height: 20),
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Inicia Sesión',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 20),
                        TextField(
                          controller: _correoController,
                          decoration: InputDecoration(
                            labelText: 'Correo electrónico',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        SizedBox(height: 20),
                        TextField(
                          controller: _contrasenaController,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: 'Contraseña',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: iniciarSesion,
                          child: Text('Iniciar sesión'),
                        ),
                        SizedBox(height: 10),
                        RichText(
                          text: TextSpan(
                            text: '¿No tienes cuenta? ',
                            style: TextStyle(color: Colors.black),
                            children: <TextSpan>[
                              TextSpan(
                                text: 'Regístrate',
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                ),
                                recognizer: TapGestureRecognizer()..onTap = () {
                                  // Navegar a la página de registro
                                  Navigator.pushNamed(context, '/registro'); // Ruta a la página de registro
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
