import 'package:flutter/material.dart';
import 'package:efa/colors.dart';  // Color azul ya declarado
import '../Models/Producto.dart';  // Modelo del producto importado

class visualizacion_producto extends StatefulWidget {
  final Producto producto;

  // Constructor para recibir el producto seleccionado
  visualizacion_producto({required this.producto});

  @override
  _visualizacion_productoState createState() => _visualizacion_productoState();
}

class _visualizacion_productoState extends State<visualizacion_producto> {
  int cantidad = 1; // Variable para almacenar la cantidad

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Buscar",
                    filled: true,
                    fillColor: Colors.grey[200],
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
                // Acción para el carrito de compras
              },
            ),
          ],
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
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
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
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        SizedBox(height: 16),
                        // Descripción del producto
                        Text(
                          'Descripción:',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        SizedBox(height: 8),
                        Text(
                          widget.producto.descripcion ?? 'No disponible.',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 16),
                        // Botones de añadir al carrito y confirmar
                        Row(
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.black,
                                backgroundColor: Colors.yellow[600], // Color del texto
                              ),
                              onPressed: () {
                                // Acción para añadir al carrito
                                Navigator.pushNamed(context, '/inicio_sesion');
                              },
                              child: Text('Añadir al carrito'),
                            ),
                          ],
                        ),
                        SizedBox(width: 10), // Espacio entre los botones
                        IconButton(
                          icon: Icon(Icons.favorite, color: Colors.black,),
                          onPressed: () {
                            Navigator.pushNamed(context, '/inicio_sesion');
                          },
                        ),
                        SizedBox(height: 16),
                        // Cantidad
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Cantidad',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
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
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 8, horizontal: 8),
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
                        widget.producto.fichaTec ??
                            'Especificaciones no disponibles.',
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
