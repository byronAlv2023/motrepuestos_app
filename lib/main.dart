import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'presentation/screens/login_screen.dart';
import 'presentation/screens/catalogo_screen.dart';
import 'presentation/screens/carrito_screen.dart';
import 'presentation/viewmodels/carrito_viewmodel.dart';

void main() {
  runApp(const MotoRepuestosApp());
}

class MotoRepuestosApp extends StatelessWidget {
  const MotoRepuestosApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => CarritoViewModel())],
      child: MaterialApp(
        title: 'MotoRepuestos ECU',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue[900]!,
            brightness: Brightness.light,
          ),
          appBarTheme: const AppBarTheme(centerTitle: true, elevation: 0),
          useMaterial3: true,
        ),
        home: const LoginScreen(),
        routes: {
          '/login': (context) => const LoginScreen(),
          '/catalogo': (context) => const CatalogoScreen(),
          '/carrito': (context) => const CarritoScreen(),
        },
      ),
    );
  }
}
