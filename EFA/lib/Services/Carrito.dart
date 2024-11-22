import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Models/Producto.dart'; // Importa el modelo

class Carrito {
  Future<List<Producto>> fetchProductos(String idpersona) async {
    final response = await http.post(
      Uri.parse('http://dtai.uteq.edu.mx/~corjua228/awos/androidServices/muestra_carrito.php'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'idpersona': idpersona}),
    );

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);

      // Validación simple
      if (body is List) {
        List<Producto> productos = body.map((dynamic item) {
          if (item is Map<String, dynamic>) {
            return Producto.fromJson(item);
          } else {
            throw Exception('Invalid product format');
          }
        }).toList();
        return productos;
      } else {
        throw Exception('Expected a list of products');
      }
    } else {
      throw Exception('Failed to load products: ${response.statusCode} ${response.body}');
    }
  }
}
