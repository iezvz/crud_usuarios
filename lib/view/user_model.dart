import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));
String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  String nombre;
  int edad;
  String email;
  UserModel({required this.nombre, required this.edad, required this.email});

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
      nombre: json['nombre'], edad: json['edad'], email: json['email']);
  Map<String, dynamic> toJson() => {
        'nombre': nombre,
        'edad': edad,
        'email': email,
      };
}
