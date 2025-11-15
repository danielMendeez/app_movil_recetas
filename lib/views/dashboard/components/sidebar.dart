import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../viewmodels/dashboard_viewmodel.dart';
import '../../../models/user.dart';
import '../../../services/auth/secure_storage_service.dart';

class Sidebar extends StatelessWidget {
  final User user;
  const Sidebar({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<DashboardViewModel>(context);
    final selectedIndex = viewModel.selectedIndex;

    return Drawer(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(right: Radius.circular(28)),
      ),
      child: Column(
        children: [
          _buildHeader(context),
          const SizedBox(height: 8),
          _buildMenuItem(
            icon: Icons.home_rounded,
            label: "Inicio",
            isSelected: selectedIndex == 0,
            onTap: () {
              viewModel.changeTab(0);
              context.pop();
            },
          ),
          _buildMenuItem(
            icon: Icons.person_rounded,
            label: "Perfil",
            isSelected: selectedIndex == 1,
            onTap: () {
              viewModel.changeTab(1);
              context.pop();
            },
          ),
          _buildMenuItem(
            icon: Icons.favorite_rounded,
            label: "Favoritos",
            isSelected: selectedIndex == 2,
            onTap: () {
              viewModel.changeTab(2);
              context.pop();
            },
          ),
          const Spacer(),
          const Divider(height: 1),
          _buildLogoutButton(context),
        ],
      ),
    );
  }

  // HEADER
  Widget _buildHeader(BuildContext context) {
    return UserAccountsDrawerHeader(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xF8FF9900), Color(0xF4FFE600)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      accountName: Text(
        "${user.nombre ?? ''} ${user.apellido ?? ''}",
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      accountEmail: Text(user.correo ?? ''),
      currentAccountPicture: CircleAvatar(
        radius: 34,
        backgroundColor: Colors.white,
        child: Icon(Icons.person_rounded, size: 40, color: Colors.black87),
      ),
    );
  }

  // ITEMS DE MENÚ
  Widget _buildMenuItem({
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Material(
        color: isSelected
            ? Colors.orange.withOpacity(0.15)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        child: ListTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          leading: Icon(
            icon,
            color: isSelected ? Colors.orange : Colors.grey.shade700,
          ),
          title: Text(
            label,
            style: TextStyle(
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? Colors.orange.shade700 : Colors.grey.shade800,
            ),
          ),
          onTap: onTap,
        ),
      ),
    );
  }

  // LOGOUT
  Widget _buildLogoutButton(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.logout_rounded, color: Colors.red),
      title: const Text(
        "Cerrar sesión",
        style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
      ),
      onTap: () async => await _logout(context),
    );
  }

  Future<void> _logout(BuildContext context) async {
    await SecureStorageService.deleteAll();
    context.go("/login");
  }
}
