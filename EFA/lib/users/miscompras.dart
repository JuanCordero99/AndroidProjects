import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:efa/colors.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_paypal/flutter_paypal.dart';
import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../Models/Persona.dart';

class VisualizarCompras extends StatefulWidget {
  final Persona persona;

  VisualizarCompras({required this.persona});

  @override
  _VisualizarComprasState createState() => _VisualizarComprasState();
}

class _VisualizarComprasState extends State<VisualizarCompras> {
  List<dynamic> productos = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchProductos();
  }

  Future<void> _fetchProductos() async {
    String idpersona = widget.persona.idpersona;
    try {
      final response = await http.get(
        Uri.parse('http://dtai.uteq.edu.mx/~corjua228/awos/androidServices/miscompras.php?idpersona=$idpersona'),
      );

      if (response.statusCode == 200) {
        final decodedResponse = jsonDecode(response.body);

        if (decodedResponse is List) {
          setState(() {
            this.productos = decodedResponse;
            isLoading = false;
          });
        } else if (decodedResponse is Map && decodedResponse.containsKey('productos')) {
          setState(() {
            this.productos = decodedResponse['productos'];
            isLoading = false;
          });
        } else {
          throw Exception("Formato de respuesta inesperado");
        }
      } else {
        throw Exception('Error al cargar productos: ${response.statusCode}');
      }
    } catch (e) {
      print('Error al cargar productos: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  String _formatCurrency(double amount) {
    final formatter = NumberFormat.currency(locale: 'es_MX', symbol: '\$', decimalDigits: 2);
    return formatter.format(amount);
  }

  Future<void> _generarTicketPDF(Map<String, dynamic> producto) async {
    print("Presionaste el boton de ticket");
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                "TICKET DE COMPRA",
                style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 20),
              pw.Text("Subtotal: ${_formatCurrency(producto['subtotal'].toDouble())}"),
              pw.Text("Cantidad: ${producto['cantidad']}"),
              pw.Text("Precio del Producto: ${_formatCurrency(producto['precio'].toDouble())}"),
              pw.Text("Total de la compra: ${_formatCurrency(producto['total'].toDouble())}"),
              pw.Text("N°Venta: ${producto['idventa']}"),
            ],
          );
        },
      ),
    );

    final directory = await getTemporaryDirectory();
    final file = File('${directory.path}/ticket_${producto['idventa']}.pdf');
    await file.writeAsBytes(await pdf.save());

    await OpenFile.open(file.path);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mis Compras"),
      ),
      body: Container(
        color: AppColors.azul,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  'Bienvenido, ${widget.persona.nombre} ${widget.persona.apellidos}',
                  style: TextStyle(fontSize: 18, color: Colors.black),
                ),
              ),
              isLoading
                  ? Center(child: CircularProgressIndicator())
                  : productos.isEmpty
                  ? Center(child: Text('La lista está vacía', style: TextStyle(color: Colors.black)))
                  : ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: productos.length,
                itemBuilder: (context, index) {
                  final producto = productos[index];
                  return Card(
                    margin: EdgeInsets.all(8.0),
                    child: ListTile(
                      leading: Image.network(
                        "http://dtai.uteq.edu.mx/~corjua228/awos/androidServices/images/${producto['imagen']}",
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(Icons.error);
                        },
                      ),
                      title: Text(producto['nombre']),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              "Subtotal: ${_formatCurrency(producto['subtotal'].toDouble())}"
                                  "\nCantidad: ${producto['cantidad']}"
                                  "\nPrecio del Producto: ${_formatCurrency(producto['precio'].toDouble())}"
                                  "\nTotal de la compra: ${_formatCurrency(producto['total'].toDouble())}"
                                  "\nN°Venta: ${producto['idventa']}"
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                "Factura",
                                style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold ,color: Colors.black),
                              ),
                              IconButton(
                                icon: Icon(FontAwesomeIcons.filePdf, color: Colors.red),
                                onPressed: () {
                                  Navigator.pushNamed(
                                    context,
                                    'users/registro_facturacion',
                                    arguments: {
                                      'persona': widget.persona,
                                      'idventa': producto['idventa']
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                "Ticket",
                                style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold ,color: Colors.black),
                              ),
                              IconButton(
                                icon: Icon(FontAwesomeIcons.filePdf, color: Colors.red),
                                onPressed: ( ) => _generarTicketPDF(producto),
                              ),
                            ],
                          ),
                        ],
                      ),
                      trailing: Column(
                        children: [

                        ],
                      ),
                    ),
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, 'users/home', arguments: widget.persona);
                  },
                  child: Text('Regresar'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.yellow),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
