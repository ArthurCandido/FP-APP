class User {
  final String cpf;
  final String nome;
  final String tipo;
  final String email;

  User({
    required this.cpf,
    required this.nome,
    required this.tipo,
    required this.email,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      cpf: json['cpf'] as String,
      nome: json['nome'] as String,
      tipo: json['tipo'] as String,
      email: json['email'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cpf': cpf,
      'nome': nome,
      'tipo': tipo,
      'email': email,
    };
  }
}
