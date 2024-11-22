import 'package:flutter/material.dart';

// Importaciones para secciones de la aplicación
import 'package:efa/admin/home.dart' as HomeAdmin;
import 'package:efa/admin/productos/altas.dart';
import 'package:efa/admin/productos/bajas.dart';
import 'package:efa/admin/productos/cambios.dart';
import 'package:efa/admin/usuarios/altas.dart' as AdminUsuariosAltas;
import 'package:efa/admin/usuarios/bajas.dart' as AdminUsuariosBajas;
import 'package:efa/admin/usuarios/cambios.dart' as AdminUsuariosCambios;

import 'package:efa/public/catalogo_componentes.dart';
import 'package:efa/public/catalogo_laptop.dart';
import 'package:efa/public/catalogo_pc.dart';
import 'package:efa/public/home.dart' as PublicHome;
import 'package:efa/public/visualizacion_producto.dart' as PublicProducto;

import 'package:efa/users/catalogo_componentes.dart' as UserComponentes;
import 'package:efa/users/catalogo_laptop.dart' as UserLaptop;
import 'package:efa/users/catalogo_pc.dart' as UserPC;
import 'package:efa/users/confirmacion_compra.dart';
import 'package:efa/users/home.dart' as UserHome;
import 'package:efa/users/registro_domicilio.dart';
import 'package:efa/users/registro_facturacion.dart' as Facturacion;
import 'package:efa/users/carrito.dart' as Carrito;
import 'package:efa/users/visualizacion_perfil.dart' as Perfil;
import 'package:efa/users/visualizacion_producto.dart' as UserProducto;
import 'package:efa/users/wishlist.dart' as Wishlist;
import 'package:efa/users/miscompras.dart' as MisCompras;
import 'package:efa/users/thanks.dart' as Thanks;

import 'package:efa/inicio_sesion.dart';
import 'package:efa/registro.dart';
import 'package:efa/Models/Producto.dart';
import 'package:efa/Models/Persona.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'efa',
      initialRoute: 'public/home',
      routes: {
        // Rutas para la sección pública
        'public/home': (context) => PublicHome.Home(),
        'public/visualizacion_producto': (context) => PublicProducto.visualizacion_producto(
          producto: ModalRoute.of(context)!.settings.arguments as Producto,
        ),

        // Rutas para usuarios
        'users/home': (context) => UserHome.Home(),
        'users/visualizacion_perfil': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
          return Perfil.VisualizacionPerfil(
            persona: args['persona'],
          );
        },
        'users/visualizacion_producto': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
          return UserProducto.VisualizacionProducto(
            producto: args['producto'],
            persona: args['persona'],
          );
        },
        'users/carrito': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
          return Carrito.VisualizarCarrito(
            persona: args['persona'],
          );
        },
        'users/wishlist': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
          return Wishlist.VisualizarWishlist(
            persona: args['persona'],
          );
        },
        'users/miscompras': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
          return MisCompras.VisualizarCompras(
            persona: args['persona'],
          );
        },
        'users/registro_facturacion': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
          return Facturacion.RegistroFactura(
            persona: args['persona'],
            idventa: args['idventa']
          );
        },
        'users/thanks': (context) => Thanks.Thanks(),

        // Rutas para la sección de administrador - productos
        'admin/home': (context) => HomeAdmin.Home(),
        // Rutas para la sección de administrador - usuarios
        // Puedes descomentar las rutas para usuarios y productos si las necesitas
        // 'admin/usuarios/home': (context) => AdminUsuariosHome.HomePage(),
        // 'admin/usuarios/altas': (context) => AdminUsuariosAltas.AltasUsuariosPage(),
        // 'admin/usuarios/bajas': (context) => AdminUsuariosBajas.BajasUsuariosPage(),
        // 'admin/usuarios/cambios': (context) => AdminUsuariosCambios.CambiosUsuariosPage(),

        // Rutas para el inicio de sesión y registro
        '/inicio_sesion': (context) => InicioSesion(),
        '/registro': (context) => Registro(),
      },
    );
  }
}
