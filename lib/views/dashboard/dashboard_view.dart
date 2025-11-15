import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/dashboard_viewmodel.dart';
import '../../viewmodels/auth/auth_viewmodel.dart';
import 'components/sidebar.dart';
import 'components/home_content.dart';
import 'components/profile_content.dart';
import 'components/favorites_content.dart';
import '../../models/user.dart';

class DashboardView extends StatefulWidget {
  final User user;

  const DashboardView({super.key, required this.user});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DashboardViewModel(),
      child: Consumer<DashboardViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            key: _scaffoldKey,
            backgroundColor: Colors.grey.shade50,
            appBar: _buildAppBar(context),
            drawer: Sidebar(user: widget.user),
            body: AnimatedSwitcher(
              duration: const Duration(milliseconds: 350),
              switchInCurve: Curves.easeOutQuart,
              switchOutCurve: Curves.easeInQuart,
              child: _getContent(viewModel.selectedIndex),
            ),
          );
        },
      ),
    );
  }

  // APPBAR
  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0.6,
      shadowColor: Colors.black12,
      surfaceTintColor: Colors.transparent,
      centerTitle: true,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Bienvenido, ${widget.user.nombre ?? ''}!',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          Text(
            'RecetasApp',
            style: TextStyle(fontSize: 12, color: Colors.orange.shade700),
          ),
        ],
      ),
      leading: IconButton(
        icon: const Icon(Icons.menu_rounded, color: Colors.black87),
        onPressed: () => _scaffoldKey.currentState?.openDrawer(),
      ),
    );
  }

  // CONTENIDOS
  Widget _getContent(int index) {
    switch (index) {
      case 0:
        return HomeContent(key: const ValueKey('home'), user: widget.user);
      case 1:
        return ProfileContent(
          key: const ValueKey('profile'),
          user: widget.user,
        );
      case 2:
        return const FavoritesContent(key: ValueKey('favorites'));
      default:
        return HomeContent(
          key: const ValueKey('home-default'),
          user: widget.user,
        );
    }
  }
}
