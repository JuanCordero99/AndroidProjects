class Persona {
  final String idpersona;
  final String? nombre;
  final String? apellidos;
  final String correo;
  final String? contrasenia;
  final String token;
  final String perfil;
  final String estatus;
  final String sesion;
  final String? idmpio;
  final String? direccion;

  Persona({
    required this.idpersona,
    this.nombre,
    this.apellidos,
    required this.correo,
    this.contrasenia,
    required this.token,
    required this.perfil,
    required this.idmpio,
    required this.estatus,
    required this.sesion,
    required this.direccion,
  });

  // Método para crear una instancia de Persona a partir de un JSON
  factory Persona.fromJson(Map<String, dynamic> json) {
    return Persona(
      idpersona: json['idpersona'],
      nombre: json['nombre'],
      apellidos: json['apellidos'],
      correo: json['correo'],
      contrasenia: json['contrasenia'],
      token: json['token'],
      perfil: json['perfil'],
      estatus: json['estatus'],
      sesion: json['sesion'],
      direccion: json['direccion'],
      idmpio: json['idmpio'],
    );
  }

  // Método para convertir la instancia de Persona a un JSON
  Map<String, dynamic> toJson() {
    return {
      'idpersona': idpersona,
      'nombre': nombre,
      'apellidos': apellidos,
      'correo': correo,
      'contrasenia': contrasenia,
      'token': token,
      'perfil': perfil,
      'estatus': estatus,
      'sesion': sesion,
      'direccion': direccion,
      'idmpio': idmpio,
    };
  }
}
