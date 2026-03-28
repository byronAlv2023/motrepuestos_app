import 'package:flutter/material.dart';
import '../../domain/entities/carrito.dart';
import '../../domain/entities/item_carrito.dart';
import '../../domain/entities/producto.dart';
import '../../data/repositories/carrito_repository_impl.dart';
import '../../data/datasources/carrito_local_datasource.dart';

class CarritoViewModel extends ChangeNotifier {
  final CarritoRepositoryImpl _repository;
  final String _usuarioId;

  Carrito? _carrito;
  bool _isLoading = false;
  String? _errorMessage;

  CarritoViewModel({String? usuarioId})
    : _usuarioId = usuarioId ?? 'usuario_demo',
      _repository = CarritoRepositoryImpl(
        localDataSource: CarritoLocalDataSource(),
      ) {
    _cargarCarrito();
  }

  Carrito? get carrito => _carrito;
  List<ItemCarrito> get items => _carrito?.items ?? [];
  double get total => _carrito?.total ?? 0.0;
  int get cantidadTotal => _carrito?.cantidadTotal ?? 0;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> _cargarCarrito() async {
    _isLoading = true;
    notifyListeners();

    try {
      _carrito = await _repository.obtenerCarrito(_usuarioId);
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Error al cargar carrito: $e';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> agregarProducto(Producto producto, int cantidad) async {
    _isLoading = true;
    notifyListeners();

    try {
      final item = ItemCarrito(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        producto: producto,
        cantidad: cantidad,
      );
      await _repository.agregarOActualizarItem(_usuarioId, item);
      await _cargarCarrito();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Error al agregar producto: $e';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> actualizarCantidad(String productId, int cantidad) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _repository.actualizarCantidad(_usuarioId, productId, cantidad);
      await _cargarCarrito();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Error al actualizar cantidad: $e';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> quitarProducto(String productId) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _repository.quitarItem(_usuarioId, productId);
      await _cargarCarrito();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Error al quitar producto: $e';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> limpiarCarrito() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _repository.limpiarCarrito(_usuarioId);
      await _cargarCarrito();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Error al limpiar carrito: $e';
    }

    _isLoading = false;
    notifyListeners();
  }
}
