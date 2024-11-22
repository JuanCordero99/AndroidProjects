import 'package:efa/colors.dart';  // Color azul ya declarado
import 'package:flutter/material.dart';
import 'package:efa/Services/Catalogo.dart';  // Servicio importado

import '../Models/Producto.dart';  // Modelo del producto importado

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Future<List<Producto>> futureProductos;

  @override
  void initState() {
    super.initState();
    futureProductos = Catalogo().fetchProductos() as Future<List<Producto>>;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white, // Fondo blanco para la barra superior
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black), // Color del ícono de menú
        title: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Buscar",
                    filled: true,
                    fillColor: AppColors.gris, // Color gris para el campo de búsqueda
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
                      'assets/traslucentblacklogo.png', // Reemplaza con tu imagen
                      height: 80,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Center(
                child:Text(
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
                  Navigator.pushNamed(context, '/inicio_sesion');
                },
              ),
            ],
          ),
        ),
      ),
      body: Container(
        color: AppColors.azul, // Fondo azul para la pantalla
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                "Laptops",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
              ),
            ),
            Expanded(
              child: FutureBuilder<List<Producto>>(
                future: futureProductos,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No hay productos disponibles.', style: TextStyle(color: Colors.white)));
                  } else {
                    List<Producto> productos = snapshot.data!;
                    return ListView.builder(
                      itemCount: productos.length,
                      itemBuilder: (context, index) {
                        Producto producto = productos[index];
                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 3,
                          child: ListTile(
                            leading: Image.network(
                              "http://dtai.uteq.edu.mx/~corjua228/awos/androidServices/images/${producto.imagen}",
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(Icons.error);
                              },
                            ),
                            title: Text(producto.nombre),
                            subtitle: Text('Precio: \$${producto.precio}'),
                            trailing: Icon(Icons.arrow_forward_ios), // Icono de flecha
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                'public/visualizacion_producto',
                                arguments: producto,  // Aquí 'producto' es la instancia del modelo Producto recibida desde el JSON.
                              );
                            },
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
