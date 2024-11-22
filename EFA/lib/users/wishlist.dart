import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:efa/colors.dart'; // Color azul ya declarado
import 'package:http/http.dart' as http;
import 'package:flutter_paypal/flutter_paypal.dart';
import 'package:intl/intl.dart'; // Importar intl
import '../Models/Persona.dart';

class VisualizarWishlist extends StatefulWidget {
  final Persona persona;

  VisualizarWishlist({required this.persona});

  @override
  _VisualizarWishlistState createState() => _VisualizarWishlistState();
}

class _VisualizarWishlistState extends State<VisualizarWishlist> {
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
        Uri.parse('http://dtai.uteq.edu.mx/~corjua228/awos/androidServices/muestra_wish.php?idpersona=$idpersona'),
      );

      if (response.statusCode == 200) {
        final decodedResponse = jsonDecode(response.body);

        // Verificar si el JSON es una lista o un mapa
        if (decodedResponse is List) {
          setState(() {
            this.productos = decodedResponse; // Asigna directamente si es una lista
            isLoading = false;
          });
        } else if (decodedResponse is Map && decodedResponse.containsKey('productos')) {
          setState(() {
            this.productos = decodedResponse['productos']; // Extrae la lista si está dentro de un mapa
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

  void _eliminarProducto(int index) async {
    String idwish = productos[index]['idwish']; // ID del producto en el carrito

    try {
      final response = await http.delete(
        Uri.parse('http://dtai.uteq.edu.mx/~corjua228/awos/androidServices/borra_producto_wish.php?idwish=$idwish'),
      );

      if (response.statusCode == 200) {
        bool resultado = jsonDecode(response.body);
        if (resultado) {
          setState(() {
            productos.removeAt(index);
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Producto eliminado de la lista')),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("WishList"),
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
                ? Center(child: Text('La lista está vacía', style: TextStyle(color: Colors.black)))
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
                          Text("Subtotal: ${_formatCurrency(producto['precio'].toDouble())}"),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
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
    );
  }

}
