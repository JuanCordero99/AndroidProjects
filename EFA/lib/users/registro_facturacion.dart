import 'dart:io';
import 'package:efa/Models/Persona.dart';
import 'package:efa/colors.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:pdf/widgets.dart' as pw; // Paquete para crear el PDF
import 'package:open_file/open_file.dart'; // Paquete para abrir archivos

class RegistroFactura extends StatefulWidget {
  final Persona persona;
  final int idventa;

  RegistroFactura({required this.persona, required this.idventa});

  @override
  _RegistroFacturaState createState() => _RegistroFacturaState();
}

class _RegistroFacturaState extends State<RegistroFactura> {
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController direccionController = TextEditingController();
  final TextEditingController rfcController = TextEditingController();

  @override
  void initState() {
    super.initState();
    print("ID de venta: ${widget.idventa}");
  }

  Future<void> registrarUsuario() async {
    String nombre = nombreController.text;
    String direccion = direccionController.text;
    String rfc = rfcController.text;

    if (nombre.isEmpty || direccion.isEmpty || rfc.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor, complete todos los campos obligatorios')),
      );
      return;
    }

    Map<String, dynamic> userData = {
      "nombre": nombre,
      "direccion": direccion,
      "rfc": rfc,
      "idventa": widget.idventa.toString()
    };

    String jsonData = json.encode(userData);

    try {
      final response = await http.post(
        Uri.parse('http://dtai.uteq.edu.mx/~corjua228/awos/androidServices/registro_factura.php'),
        body: jsonData,
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);

        print("${response.body}");

        bool resultado = data['resultado'];
        String mensaje = data['mensaje'];

        if (resultado) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(mensaje)),
          );
          // Generar PDF con los datos
          List<dynamic> pdfData = data['pdfData'];
          if (pdfData.isNotEmpty) {
            await generarPDF(pdfData);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('No se encontraron datos para el PDF')),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(mensaje)),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error en la respuesta del servidor')),
        );
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> generarPDF(List<dynamic> pdfData) async {
    // Crear el documento PDF
    final pdf = pw.Document();

    // Agregar una página al PDF con los datos proporcionados
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                "FACTURA DE COMPRA",
                style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 10), // Espaciado entre el título y el contenido
              ...pdfData.map((data) {
                return pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text("ID Venta: ${data['idventa']}"),
                    pw.Text("Nombre: ${data['nombre']}"),
                    pw.Text("Dirección: ${data['direccion']}"),
                    pw.Text("Correo: ${data['correo']}"),
                    pw.Text("Subtotal: \$${data['subtotal']}"),
                    pw.Text("Total: \$${data['total']}"),
                    pw.Text("RFC: ${data['RFC']}"),
                    pw.Text("Razón Social: ${data['razon_s']}"),
                    pw.Text("Fecha Factura: ${data['fecha_fac']}"),
                    pw.Text("Producto: ${data['nomprod']} - \$${data['precio']}"),
                    pw.SizedBox(height: 15), // Espaciado entre facturas
                  ],
                );
              }).toList(),
            ],
          );
        },
      ),
    );


    // Guardar el archivo en el almacenamiento temporal
    final directory = await getTemporaryDirectory();
    final file = File('${directory.path}/factura.pdf');
    await file.writeAsBytes(await pdf.save());

    // Abrir el PDF con la aplicación predeterminada del sistema
    await OpenFile.open(file.path);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mis Compras"),
      ),
      body: Container(
        color: AppColors.azul, // Mantengo tu color azul de fondo
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            SizedBox(height: 20),
            Text('Nombre o razón social', style: TextStyle(fontSize: 16)),
            TextFormField(
              controller: nombreController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            Text('Dirección', style: TextStyle(fontSize: 16)),
            TextFormField(
              controller: direccionController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            Text('RFC', style: TextStyle(fontSize: 16)),
            TextFormField(
              controller: rfcController,
              obscureText: false,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: registrarUsuario,
                child: Text('Generar factura'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.amarillo, // Color amarillo
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
