import 'package:flutter/material.dart';
import 'package:efa/colors.dart'; // Colores personalizados

class Thanks extends StatefulWidget {
  @override
  _OpcionesFacturaTicketState createState() => _OpcionesFacturaTicketState();
}

class _OpcionesFacturaTicketState extends State<Thanks> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.azul, // Fondo azul personalizado
      appBar: AppBar(
        title: Text('Opciones de Documento', style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.azul,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Vuelve a la pantalla de inicio
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.amarillo, // Color amarillo personalizado
              ),
              child: Text('Volver a Inicio'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.amarillo,
              ),
              child: Text('Generar Factura'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {

              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.amarillo,
              ),
              child: Text('Generar Ticket'),
            ),
          ],
        ),
      ),
    );
  }
}
