import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../viewmodels/auth/register_viewmodel.dart';
import 'custom_text_field.dart';

class RegisterForm extends StatelessWidget {
  final TextEditingController nombreController;
  final TextEditingController apellidoController;
  final TextEditingController correoController;
  final TextEditingController passwordController;

  const RegisterForm({
    super.key,
    required this.nombreController,
    required this.apellidoController,
    required this.correoController,
    required this.passwordController,
  });

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<RegisterViewModel>(context);

    return Column(
      children: [
        // Nombre
        CustomTextField(
          controller: nombreController,
          labelText: 'Nombre',
          prefixIcon: Icons.person_outline,
          errorText: viewModel.nombreError,
          onChanged: (value) => viewModel.clearNombreError(),
        ),
        const SizedBox(height: 16),

        // Apellido
        CustomTextField(
          controller: apellidoController,
          labelText: 'Apellido',
          prefixIcon: Icons.person_outline,
          errorText: viewModel.apellidoError,
          onChanged: (value) => viewModel.clearApellidoError(),
        ),
        const SizedBox(height: 16),

        // Correo
        CustomTextField(
          controller: correoController,
          labelText: 'Correo electrónico',
          prefixIcon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
          errorText: viewModel.correoError,
          onChanged: (value) => viewModel.clearCorreoError(),
        ),
        const SizedBox(height: 16),

        // Contraseña
        CustomTextField(
          controller: passwordController,
          labelText: 'Contraseña',
          prefixIcon: Icons.lock_outline,
          obscureText: true,
          errorText: viewModel.passwordError,
          onChanged: (value) => viewModel.clearPasswordError(),
        ),
      ],
    );
  }
}
