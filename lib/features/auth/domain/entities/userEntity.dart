import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String email;
  final String? name;

  const User({required this.id, required this.email, this.name});

  @override
  // TODO: implement props
  List<Object?> get props {
    return [id, email, name];
  }
}
