import 'package:efa/colors.dart'; // Color azul ya declarado
import 'package:flutter/material.dart';
import 'package:efa/Services/Catalogo.dart'; // Servicio importado

import '../Models/Producto.dart'; // Modelo del producto importado
import '../Models/Persona.dart'; // Modelo de la persona importado

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Future<List<Producto>> futureProductos;
  late Persona persona; // Cambiamos a Persona para almacenar todos los datos.

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Obtenemos los argumentos pasados
    final args = ModalRoute.of(context)!.settings.arguments as Persona;
    persona = args; // Almacenamos el objeto Persona

    // Imprimir los datos de la persona en la terminal
    print('ID Persona: ${persona.idpersona}');
    print('Nombre: ${persona.nombre}');
    print('Apellidos: ${persona.apellidos}');
    print('Correo: ${persona.correo}');
    print('Token: ${persona.token}');
    print('Perfil: ${persona.perfil}');
    print('Estatus: ${persona.estatus}');
    print('Sesion: ${persona.sesion}');
    print('ID Municipio: ${persona.idmpio}');
    print('Direccion: ${persona.direccion}');

    futureProductos = Catalogo().fetchProductos() as Future<List<Producto>>;
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
                    'persona': persona, // Pasa la persona
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
                    'persona': persona, // Pasa la persona
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
                leading: Icon(Icons.shop),
                title: Text('Mis compras'),
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    'users/miscompras',
                    arguments: {
                      'persona': persona, // Pasa la persona
                    }, // Pasa el producto y la persona como argumentos separados
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.person),
                title: Text('Mi perfil'),
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    'users/visualizacion_perfil',
                    arguments: {
                      'persona': persona, // Pasa la persona
                    }, // Pasa el producto y la persona como argumentos separados
                  );
                },
              ),
            ],
          ),
        ),
      ),
      body: Container(
        color: AppColors.azul,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                "Laptops",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
              ),
            ),
            // Mostrar los detalles de la persona
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                'Bienvenido, ${persona.nombre} ${persona.apellidos}', // Muestra el nombre y apellidos de la persona
                style: TextStyle(fontSize: 18, color: Colors.black),
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
                                'users/visualizacion_producto',
                                arguments: {
                                  'producto': producto, // Pasa el producto
                                  'persona': persona, // Pasa la persona
                                }, // Pasa el producto y la persona como argumentos separados
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
