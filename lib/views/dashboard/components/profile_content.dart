import 'package:flutter/material.dart';
import '../../../models/user.dart';

class ProfileContent extends StatelessWidget {
  final User user;

  const ProfileContent({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Avatar placeholder
          CircleAvatar(
            radius: 55,
            backgroundColor: Colors.orange.shade100,
            child: const Icon(Icons.person, size: 60, color: Colors.orange),
          ),

          const SizedBox(height: 20),

          Text(
            "${user.nombre ?? ''} ${user.apellido ?? ''}",
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 8),

          Text(
            user.correo ?? 'Correo no disponible',
            style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
          ),

          const SizedBox(height: 30),

          Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.person, color: Colors.orange.shade700),
                      const SizedBox(width: 10),
                      const Text(
                        "Apellido",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    user.apellido ?? '',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                  Row(
                    children: [
                      Icon(Icons.email, color: Colors.orange.shade700),
                      const SizedBox(width: 10),
                      const Text(
                        "Correo",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    user.correo ?? 'Correo no disponible',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
