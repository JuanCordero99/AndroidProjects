import 'package:efa/colors.dart';
import 'package:flutter/material.dart';

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

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[300],
        title: Text(
          'Bienvenido admin',
          style: TextStyle(color: Colors.black),
        ),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(Icons.menu, color: Colors.black),
              onPressed: () {
                Scaffold.of(context).openDrawer(); // Cambiado a un Builder
              },
            );
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle, color: Colors.black),
            onPressed: () {
              // Acción del botón de perfil
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: Container(
          color: AppColors.gris, // Color gris para el fondo del menú
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: AppColors.gris,
                ),
                child: Text(
                  'Menu',
                  style: TextStyle(fontSize: 24, color: Colors.black),
                ),
              ),
              ExpansionTile(
                title: Text('Categorías',
                    style: TextStyle(fontSize:24, fontWeight: FontWeight.bold)),
                children: <Widget>[
                  ExpansionTile(
                    title: Text('Usuarios',
                        style: TextStyle(fontWeight: FontWeight.bold)), //MENU DE USUARIOS
                    children: <Widget>[
                      ListTile(
                        title: Text('Altas'),
                        onTap: () {
                          // Acción al seleccionar "Altas"
                        },
                      ),
                      ListTile(
                        title: Text('Bajas'),
                        onTap: () {
                          // Acción al seleccionar "Bajas"
                        },
                      ),
                      ListTile(
                        title: Text('Cambios'),
                        onTap: () {
                          // Acción al seleccionar "Cambios"
                        },
                      ),
                    ],
                  ),
                  ExpansionTile(
                    title: Text(
                        'Productos',
                        style: TextStyle(fontWeight: FontWeight.bold)), //MENU DE PRODUCTOS
                    children: <Widget>[
                      ListTile(
                        title: Text('Altas'),
                        onTap: () {
                          // Acción al seleccionar "Altas"
                        },
                      ),
                      ListTile(
                        title: Text('Bajas'),
                        onTap: () {
                          // Acción al seleccionar "Bajas"
                        },
                      ),
                      ListTile(
                        title: Text('Cambios'),
                        onTap: () {
                          // Acción al seleccionar "Cambios"
                        },
                      ),
                    ],
                  ),
                  ExpansionTile(
                    title: Text(
                        'Reportes',
                        style: TextStyle(fontWeight: FontWeight.bold)), //MENU DE PRODUCTOS
                    children: <Widget>[
                      ListTile(
                        title: Text('Mayor Compra'),
                        onTap: () {
                          // Acción al seleccionar "Altas"
                        },
                      ),
                      ExpansionTile(
                        title: Text('Ventas'),
                        children: <Widget>[
                          ListTile(
                            title:Text(
                                'Productos',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal)),
                            onTap: (){

                            }
                          ),
                          ListTile(
                              title:Text(
                                  'Fechas',
                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal)),
                              onTap: (){

                              }
                          ),
                        ],
                      ),
                      ListTile(
                        title: Text('Frecuentes'),
                        onTap: () {
                          // Acción al seleccionar "Cambios"
                        },
                      ),
                    ],
                  ),

                  ExpansionTile(
                      title: Text(
                          'Mensajeria',
                          style: TextStyle(fontWeight: FontWeight.bold)), //MENU DE Mensajeria
                      children: <Widget>[
                        ListTile(
                          title: Text('Descuentos'),
                          onTap: () {
                            // Acción al seleccionar "Altas"
                          },
                        ),
                        ListTile(
                          title: Text('Promociones'),
                          onTap: () {
                            // Acción al seleccionar "Bajas"
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Bienvenido admin',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Image.asset(
              'assets/traslucentblacklogo.png', // Reemplaza con la ubicación de tu logo
              height: 100,
            ),
          ],
        ),
      ),
    );
  }
}
