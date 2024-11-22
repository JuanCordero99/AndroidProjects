import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Models/Producto.dart';  // Importa el modelo

class Catalogo {
  Future<List<Producto>> fetchProductos() async {
    final response = await http.get(Uri.parse('http://dtai.uteq.edu.mx/~corjua228/awos/androidServices/muestra.php'));

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      List<Producto> productos = body.map((dynamic item) => Producto.fromJson(item)).toList();
      return productos;
    } else {
      throw Exception('Failed to load products');
    }
  }
}
