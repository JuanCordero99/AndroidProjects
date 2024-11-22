class Producto {
  final String id;
  final String nombre;
  final double precio;
  final String stock;
  final String descripcion;
  final String fichaTec;
  final String imagen;
  final String catalogo;

  Producto({
    required this.id,
    required this.nombre,
    required this.precio,
    required this.stock,
    required this.descripcion,
    required this.fichaTec,
    required this.imagen,
    required this.catalogo,
  });

  factory Producto.fromJson(Map<String, dynamic> json) {
    return Producto(
      id: json['id'],
      nombre: json['nombre'],
      precio: json['precio'],
      stock: json['stock'],
      descripcion: json['descripcion'],
      fichaTec: json['ficha_tec'],
      imagen: json['imagen'] ?? '',
      catalogo: json['catalogo'],
    );
  }
}
