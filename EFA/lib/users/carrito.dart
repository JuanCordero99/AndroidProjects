import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:efa/colors.dart'; // Color azul ya declarado
import 'package:http/http.dart' as http;
import 'package:flutter_paypal/flutter_paypal.dart';
import 'package:intl/intl.dart'; // Importar intl
import '../Models/Persona.dart';

class VisualizarCarrito extends StatefulWidget {
  final Persona persona;

  VisualizarCarrito({required this.persona});

  @override
  _VisualizarCarritoState createState() => _VisualizarCarritoState();
}

class _VisualizarCarritoState extends State<VisualizarCarrito> {
  List<dynamic> productos = [];
  bool isLoading = true;
  bool resultado = false;
  String message = '';

  @override
  void initState() {
    super.initState();
    _fetchProductos();
  }

  Future<void> _fetchProductos() async {
    String idpersona = widget.persona.idpersona;
    try {
      final response = await http.get(
        Uri.parse('http://dtai.uteq.edu.mx/~corjua228/awos/androidServices/muestra_carrito.php?idpersona=$idpersona'),
      );

      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(response.body);
        setState(() {
          this.productos = body;
          isLoading = false;
        });
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

  double _calcularTotal() {
    double total = 0.0;
    for (var producto in productos) {
      total += producto['subtotal'];
    }
    return total;
  }

  String _formatCurrency(double amount) {
    final formatter = NumberFormat.currency(locale: 'es_MX', symbol: '\$', decimalDigits: 2);
    return formatter.format(amount);
  }

  void _incrementarCantidad(int index) {
    setState(() {
      int cantidadActual = int.parse(productos[index]['cantidad'].toString());
      double precioProducto = double.parse(productos[index]['precio'].toString());

      cantidadActual += 1;

      // Convertimos `productos[index]['cantidad']` a un entero para la comparación
      int stockDisponible = int.parse(productos[index]['stock'].toString());

      if (cantidadActual > stockDisponible) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No puedes añadir más piezas.\nStock Disponible: $stockDisponible')),
        );
      } else {
        productos[index]['cantidad'] = cantidadActual;
        productos[index]['subtotal'] = cantidadActual * precioProducto;
      }
    });
  }


  void _disminuirCantidad(int index) {
    setState(() {
      int cantidadActual = int.parse(productos[index]['cantidad'].toString());
      double precioProducto = double.parse(productos[index]['precio'].toString());

      if (cantidadActual > 1) {
        cantidadActual -= 1;
        productos[index]['cantidad'] = cantidadActual;
        productos[index]['subtotal'] = cantidadActual * precioProducto;
      }
    });
  }

  void _eliminarProducto(int index) async {
    String idcarrito = productos[index]['idcarrito']; // ID del producto en el carrito

    try {
      final response = await http.delete(
        Uri.parse('http://dtai.uteq.edu.mx/~corjua228/awos/androidServices/borra_producto_carrito.php?idcarrito=$idcarrito'),
      );

      if (response.statusCode == 200) {
        bool resultado = jsonDecode(response.body);
        if (resultado) {
          setState(() {
            productos.removeAt(index);
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Producto eliminado del carrito')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error al eliminar el producto')),
          );
        }
      } else {
        throw Exception('Error en el servidor: ${response.statusCode}');
      }
    } catch (e) {
      print('Error al eliminar el producto: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al eliminar el producto')),
      );
    }
  }


  String _crearJsonCompra() {
    // Calcular el total de la compra
    double totalCompra = _calcularTotal();

    // Crear los items del carrito
    List<Map<String, dynamic>> items = productos.map((producto) {
      return {
        "idproducto": producto['idproducto'],
        "cantidad": producto['cantidad'],
        "subtotal": producto['subtotal'],
      };
    }).toList();

    // Crear el JSON de la compra, incluyendo el total
    Map<String, dynamic> compraJson = {
      "idpersona": widget.persona.idpersona,
      "items": items,
      "total": totalCompra
    };

    String compraJsonStr = jsonEncode(compraJson);
    print("JSON de compra: $compraJsonStr");
    return compraJsonStr;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Carrito de Compras"),
      ),
      body: Container(
        color: AppColors.azul,
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
                ? Center(child: Text('El carrito está vacío', style: TextStyle(color: Colors.black)))
                : Expanded(
              child: ListView.builder(
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
                          Text('Cantidad: ${producto['cantidad']}'),
                          Text("Subtotal: ${_formatCurrency(producto['subtotal'].toDouble())}"),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.remove),
                            onPressed: () => _disminuirCantidad(index),
                          ),
                          IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () => _incrementarCantidad(index),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _eliminarProducto(index),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Total a pagar:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      Text(_formatCurrency(_calcularTotal()), style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: ElevatedButton(
                onPressed: () {
                  String? direccion = widget.persona.direccion;
                  if (direccion == null) {
                    //REALIZAR EL FORMULARIO DE REGISTRO DE ENVIO
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Registra tu direccion de envio primero')),
                    );
                  } else {
                    _hacerPago();
                  }
                },
                child: Text('Pagar'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.yellow),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _hacerPago() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => UsePaypal(
          sandboxMode: true,
          clientId: "AW1TdvpSGbIM5iP4HJNI5TyTmwpY9Gv9dYw8_8yW5lYIbCqf326vrkrp0ce9TAqjEGMHiV3OqJM_aRT0",
          secretKey: "EHHtTDjnmTZATYBPiGzZC_AZUfMpMAzj2VZUeqlFUrRJA_C0pQNCxDccB5qoRQSEdcOnnKQhycuOWdP9",
          returnURL: "https://samplesite.com/return",
          cancelURL: "https://samplesite.com/cancel",
          transactions: [
            {
              "amount": {
                "total": _calcularTotal().toStringAsFixed(2),
                "currency": "MXN",
                "details": {
                  "subtotal": _calcularTotal().toStringAsFixed(2),
                  "shipping": '0.00',
                  "shipping_discount": '0.00'
                }
              },
              "description": "Pago por productos en el carrito.",
              "item_list": {
                "items": productos.map((producto) {
                  return {
                    "name": producto['nombre'],
                    "quantity": producto['cantidad'].toString(),
                    "price": producto['precio'].toStringAsFixed(2),
                    "currency": "MXN"
                  };
                }).toList(),
                "shipping_address": {
                  "recipient_name": widget.persona.nombre,
                  "line1": widget.persona.direccion,
                  "city": "Tu Ciudad",
                  "country_code": "MX",
                  "postal_code": "12345",
                  "state": "Tu Estado",
                },
              }
            }
          ],
          note: "Contáctanos para cualquier pregunta sobre tu pedido.",
          onSuccess: (Map params) async {
            print("onSuccess: $params");
            String compraJsonStr = _crearJsonCompra(); // Generar el JSON de compra
            await _registrarVentaEnBackend(compraJsonStr); // Enviar al backend
            // Navegar a la pantalla principal (home) después de registrar la compra

          },
          onError: (error) {
            print("onError: $error");
          },
          onCancel: (params) {
            print('cancelled: $params');
          },
        ),
      ),
    );
  }

  Future<void> _registrarVentaEnBackend(String compraJsonStr) async {
    print("Enviando datos al backend: $compraJsonStr");

    try {
      final response = await http.post(
        Uri.parse('http://dtai.uteq.edu.mx/~corjua228/awos/androidServices/compra.php'),
        headers: {"Content-Type": "application/json"},
        body: compraJsonStr,
      );

      print("Respuesta del servidor: ${response.statusCode}");
      print("Cuerpo de la respuesta: ${response.body}");

      if (response.statusCode == 200) {
        // Decodificar la respuesta JSON
        var data = json.decode(response.body);

        // Aquí se decodifica el JSON y se asegura de que 'result' y 'message' existan
        resultado = data['resultado'];
        message = data['mensaje'];

        if (resultado) {
          print('Compra registrada exitosamente: $message');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Compra existosa!')),
          );
          print("\nCambio de pantalla a carrito");
          Navigator.pop(context);
          print("\nCambio de pantalla a home");
          Navigator.pop(context);
          /*print("\nCambio de pantalla -> PANTALLA THANKS");
          Navigator.pushNamed(context, 'users/thanks');*/
        } else {
          print('Error al registrar la compra: $message');
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('$message')),
          );
        }
      } else {
        print('Error en el servidor: ${response.statusCode}');
      }
    } catch (e) {
      print("Error en la solicitud: $e");
    }
  }

}
