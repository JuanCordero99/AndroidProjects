import 'package:flutter/material.dart';
import 'package:efa/colors.dart'; // Color azul ya declarado
import '../Models/Producto.dart'; // Modelo del producto importado
import 'package:http/http.dart' as http; // Importa el paquete para realizar solicitudes HTTP
import 'dart:convert'; // Para manejar JSON
import "../Models/Persona.dart";

class VisualizacionProducto extends StatelessWidget {
  final Producto producto; // Declarar el parámetro 'producto'
  final Persona persona;   // Declarar el parámetro 'persona'

  // Constructor para recibir el producto y la persona
  VisualizacionProducto({required this.producto, required this.persona});

  @override
  Widget build(BuildContext context) {
    return _VisualizacionProductoState(producto: producto, persona: persona);
  }
}

class _VisualizacionProductoState extends StatefulWidget {
  final Producto producto;
  final Persona persona; // Agregar Persona como parámetro

  // Constructor para recibir el producto y la persona
  _VisualizacionProductoState({required this.producto, required this.persona});

  @override
  __VisualizacionProductoState createState() => __VisualizacionProductoState();
}

class __VisualizacionProductoState extends State<_VisualizacionProductoState> {
  int cantidad = 1; // Variable para almacenar la cantidad
  bool _enWishlist = false; // Declaración de la variable de estado

  Future<void> _anadirAlCarrito() async {
    String url = 'http://dtai.uteq.edu.mx/~corjua228/awos/androidServices/pre_carrito.php';

    // Crear el objeto JSON a enviar
    var body = jsonEncode(<String, dynamic>{
      "idproducto": widget.producto.id.toString(),
      "cantidad": cantidad,
      "idpersona": widget.persona.idpersona.toString(),
    });

    print(body);

    // Realizar la petición POST
    final response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: body,
    );

    final data = jsonDecode(response.body);

    // Verificar si la respuesta es exitosa y validar la cantidad
    if (response.statusCode == 200) {
      if (data["mensaje"] == false) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al añadir al carrito. Solo hay : ${data['cantidadDisponible']} piezas'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Producto añadido al carrito.')),
        );
        Navigator.pushNamed(
          context,
          'users/carrito',
          arguments: {
            'persona': widget.persona, // Pasa la persona
          },
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al añadir al carrito.')),
      );
    }
  }

  Future<void> _anadirAWishlist() async {
    String url = 'http://dtai.uteq.edu.mx/~corjua228/awos/androidServices/wishlist.php';

    // Crear el objeto JSON a enviar
    var body = json.encode(<String, dynamic>{
      "idproducto": widget.producto.id,
      "idpersona": widget.persona.idpersona
    });

    // Realizar la petición POST
    final response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: body,
    );

    print("Cuerpo del JSON: ${body.toString()}\n Estatus: ${response.statusCode}\nCuerpo de la respuesta: ${response.body}");

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data["Estatus"] == true) {
        setState(() {
          _enWishlist = true; // Actualiza el estado a true si se añade a la wishlist
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Producto añadido a la wishlist.')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al añadir a la wishlist.')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al añadir a la wishlist.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        title: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Buscar",
                    filled: true,
                    fillColor: AppColors.gris,
                    prefixIcon: Icon(Icons.search, color: Colors.black),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.shopping_cart, color: Colors.black),
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  'users/carrito',
                  arguments: {
                    'persona': widget.persona, // Pasa la persona
                  }, // Pasa el producto y la persona como argumentos separados
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.favorite),
              onPressed: () {
                // Navegar a la ruta de carrito como wishlist temporalmente
                Navigator.pushNamed(
                  context,
                  'users/wishlist',
                  arguments: {
                    'persona': widget.persona, // Pasa la persona
                  }, // Pasa el producto y la persona como argumentos separados
                );
              },
            ),
          ],
        ),
      ),
      drawer: Drawer(
        child: Container(
          color: Colors.white,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    Image.asset(
                      'assets/traslucentblacklogo.png',
                      height: 80,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Center(
                child: Text(
                  'Categorías',
                  style: TextStyle(fontSize: 24, color: Colors.black),
                ),
              ),
              ExpansionTile(
                title: Text(
                  'PC',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                children: <Widget>[
                  ListTile(title: Text('Ejemplo')),
                ],
              ),
              ExpansionTile(
                title: Text(
                  'Laptops',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                children: <Widget>[
                  ListTile(title: Text('Ejemplo')),
                ],
              ),
              ExpansionTile(
                title: Text(
                  'Componentes',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                children: <Widget>[
                  ListTile(title: Text('Ejemplo')),
                ],
              ),
              ListTile(
                leading: Icon(Icons.person),
                title: Text('Mi perfil'),
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    'users/visualizacion_perfil',
                    arguments: {
                      'persona': widget.persona, // Pasa la persona
                    }, // Pasa el producto y la persona como argumentos separados
                  );
                },
              ),
            ],
          ),
        ),
      ),
      body: Container(
        color: AppColors.azul, // Fondo azul
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Contenedor para el nombre del producto
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Nombre del producto: ${widget.producto.nombre}',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        SizedBox(height: 8),
                        // Imagen del producto
                        Center(
                          child: Image.network(
                            "http://dtai.uteq.edu.mx/~corjua228/awos/androidServices/images/${widget.producto.imagen}",
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(Icons.error, size: 80);
                            },
                          ),
                        ),
                        SizedBox(height: 16),
                        // Precio
                        Text(
                          'Precio: \$${widget.producto.precio}',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        SizedBox(height: 16),
                        // Descripción del producto
                        Text(
                          'Descripción:',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        SizedBox(height: 8),
                        Text(
                          widget.producto.descripcion ?? 'No disponible.',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 16),
                        // Botones de añadir al carrito y wishlist
                        Row(
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.black,
                                backgroundColor: Colors.yellow[600], // Color del texto
                              ),
                              onPressed: _anadirAlCarrito, // Llama a la función para añadir al carrito
                              child: Text('Añadir al carrito'),
                            ),
                            SizedBox(width: 16),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _enWishlist ? Colors.green : Colors.redAccent, // Cambia el color según el estado
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50), // Hacerlo redondeado
                                ),
                                padding: EdgeInsets.all(10),
                              ),
                              onPressed: _anadirAWishlist,
                              child: Icon(
                                _enWishlist ? Icons.favorite : Icons.favorite_border, // Cambia el ícono de corazón vacío a lleno
                                color: Colors.white, // Color del ícono
                                size: 30, // Tamaño del ícono
                              ),
                            ),

                          ],
                        ),
                        // Cantidad
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Cantidad',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            Row(
                              children: [
                                IconButton(
                                  icon: Icon(Icons.remove),
                                  onPressed: () {
                                    setState(() {
                                      if (cantidad > 1) {
                                        cantidad--;
                                      }
                                    });
                                  },
                                ),
                                Container(
                                  width: 50,
                                  child: TextField(
                                    textAlign: TextAlign.center,
                                    decoration: InputDecoration(
                                      hintText: '$cantidad',
                                      contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    keyboardType: TextInputType.number,
                                    readOnly: true, // Hacer que el campo sea solo lectura
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.add),
                                  onPressed: () {
                                    setState(() {
                                      cantidad++;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16),
                // Especificaciones técnicas
                ExpansionTile(
                  title: Text(
                    'Especificaciones Técnicas',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        widget.producto.fichaTec ?? 'Especificaciones no disponibles.',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
