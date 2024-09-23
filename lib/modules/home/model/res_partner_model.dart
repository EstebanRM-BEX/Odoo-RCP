class Partner {
  final int id;
  final String name;
  final String? email; // Puede ser nulo
  final dynamic? imageSize; // Tamaño de la imagen

  Partner({
    required this.id,
    required this.name,
    this.email,
    this.imageSize,
  });

  // Método para crear una instancia de Partner desde un JSON
  factory Partner.fromJson(Map<String, dynamic> json) {
    return Partner(
      id: json['id'],
      name: json['name'].toString(), // Convertir a String
      email: json['email'] != null && json['email'] != false ? json['email'] : null, // Manejar el caso de email
      imageSize: json['image_128'] is String ? json['image_128'] : null, // Manejar el caso de imagen
    );
  }

  // Método para convertir la instancia a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'image_128': imageSize,
    };
  }

  // Método para crear una instancia de Partner desde un Map
  factory Partner.fromMap(Map<String, dynamic> map) {
    return Partner(
      id: map['id'],
      name: map['name'].toString(), // Convertir a String
      email: map['email'] != null && map['email'] != false ? map['email'] : null, // Manejar el caso de email
      imageSize: map['image_128'] is String ? map['image_128'] : null, // Manejar el caso de imagen
    );
  }
}
