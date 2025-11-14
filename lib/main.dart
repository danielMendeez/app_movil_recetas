import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'app_router.dart';
import 'package:provider/provider.dart';
import 'package:app_movil_recetas/views/splash_view.dart';
import 'viewmodels/auth/login_viewmodel.dart';
import 'viewmodels/dashboard_viewmodel.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Cargar variables de entorno
  await dotenv.load(fileName: ".env");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginViewModel()),
        ChangeNotifierProvider(create: (_) => DashboardViewModel()),
      ],
      child: MaterialApp.router(
        title: 'Aplicación de Recetas',
        theme: ThemeData(
          primarySwatch: Colors.orange,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        routerConfig: AppRouter.router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
