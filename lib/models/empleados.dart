import 'dart:convert';

class Empleados {
  Empleados({
    required this.empCedula,
    required this.empNombres,
    required this.empApellidos,
    required this.empCorreo,
    this.empFechaNacimiento,
    this.empDireccionDomicilio,
    this.empCelular,
    this.empVacunacion,
    this.empTipoVacuna,
    this.empFechaVacunacion,
    this.empNumeroDosis,
    required this.empActivo,
  });

  String empCedula;
  String empNombres;
  String empApellidos;
  String empCorreo;
  DateTime? empFechaNacimiento;
  String? empDireccionDomicilio;
  String? empCelular;
  String? empVacunacion;
  String? empTipoVacuna;
  DateTime? empFechaVacunacion;
  int? empNumeroDosis;
  bool empActivo;

  factory Empleados.fromJson(String str) => Empleados.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Empleados.fromMap(Map<String, dynamic> json) => Empleados(
        empCedula: json["emp_cedula"],
        empNombres: json["emp_nombres"],
        empApellidos: json["emp_apellidos"],
        empCorreo: json["emp_correo"],
        empFechaNacimiento: json["emp_fecha_nacimiento"],
        empDireccionDomicilio: json["emp_direccion_domicilio"],
        empCelular: json["emp_celular"],
        empVacunacion: json["emp_vacunacion"],
        empTipoVacuna: json["emp_tipo_vacuna"],
        empFechaVacunacion: json["emp_fecha_vacunacion"],
        empNumeroDosis: json["emp_numero_dosis"],
        empActivo: json["emp_activo"],
      );

  Map<String, dynamic> toMap() => {
        "emp_cedula": empCedula,
        "emp_nombres": empNombres,
        "emp_apellidos": empApellidos,
        "emp_correo": empCorreo,
        "emp_fecha_nacimiento": empFechaNacimiento,
        "emp_direccion_domicilio": empDireccionDomicilio,
        "emp_celular": empCelular,
        "emp_vacunacion": empVacunacion,
        "emp_tipo_vacuna": empTipoVacuna,
        "emp_fecha_vacunacion": empFechaVacunacion,
        "emp_numero_dosis": empNumeroDosis,
        "emp_activo": empActivo,
      };
}
