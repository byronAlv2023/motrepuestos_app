import 'package:flutter/material.dart';
import '../../domain/entities/producto.dart';
import '../../data/repositories/producto_repository_impl.dart';
import '../../data/datasources/producto_local_datasource.dart';

class CatalogoViewModel extends ChangeNotifier {
  final ProductoRepositoryImpl _repository;

  List<Producto> _productos = [];
  List<Producto> _productosFiltrados = [];
  bool _isLoading = false;
  String? _errorMessage;

  String? _marcaSeleccionada;
  String? _modeloSeleccionado;
  String? _categoriaSeleccionada;
  String _textoBusqueda = '';

  List<String> _marcasDisponibles = [];
  List<String> _modelosDisponibles = [];
  final List<String> _categorias = [
    'Aceites',
    'Frenos',
    'Transmisión',
    'Filtros',
    'Encendido',
    'Suspensión',
    'Eléctrico',
    'Motor',
  ];

  CatalogoViewModel()
    : _repository = ProductoRepositoryImpl(
        localDataSource: ProductoLocalDataSource(),
      ) {
    _cargarDatosIniciales();
  }

  List<Producto> get productos => _productosFiltrados;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get marcaSeleccionada => _marcaSeleccionada;
  String? get modeloSeleccionado => _modeloSeleccionado;
  String? get categoriaSeleccionada => _categoriaSeleccionada;
  String get textoBusqueda => _textoBusqueda;
  List<String> get marcasDisponibles => _marcasDisponibles;
  List<String> get modelosDisponibles => _modelosDisponibles;
  List<String> get categorias => _categorias;

  Future<void> _cargarDatosIniciales() async {
    await cargarProductos();
    await cargarMarcas();
  }

  Future<void> cargarProductos() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _productos = await _repository.obtenerTodosLosProductos();
      _aplicarFiltros();
    } catch (e) {
      _errorMessage = 'Error al cargar productos: $e';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> cargarMarcas() async {
    try {
      _marcasDisponibles = await _repository.obtenerMarcasDisponibles();
    } catch (e) {
      print('Error al cargar marcas: $e');
    }
  }

  Future<void> cargarModelosPorMarca(String marcaId) async {
    try {
      _modelosDisponibles = await _repository.obtenerModelosPorMarca(marcaId);
    } catch (e) {
      print('Error al cargar modelos: $e');
    }
    notifyListeners();
  }

  void setMarcaSeleccionada(String? marcaId) {
    _marcaSeleccionada = marcaId;
    if (marcaId != null) {
      cargarModelosPorMarca(marcaId);
    }
    _modeloSeleccionado = null;
    _aplicarFiltros();
  }

  void setModeloSeleccionado(String? modeloId) {
    _modeloSeleccionado = modeloId;
    _aplicarFiltros();
  }

  void setCategoriaSeleccionada(String? categoria) {
    _categoriaSeleccionada = categoria;
    _aplicarFiltros();
  }

  void setTextoBusqueda(String texto) {
    _textoBusqueda = texto;
    _aplicarFiltros();
  }

  void _aplicarFiltros() {
    _productosFiltrados = _productos;

    if (_marcaSeleccionada != null && _marcaSeleccionada!.isNotEmpty) {
      _productosFiltrados = _productosFiltrados
          .where((p) => p.marcaId == _marcaSeleccionada)
          .toList();
    }

    if (_modeloSeleccionado != null && _modeloSeleccionado!.isNotEmpty) {
      _productosFiltrados = _productosFiltrados
          .where((p) => p.modelosCompatibles.contains(_modeloSeleccionado))
          .toList();
    }

    if (_categoriaSeleccionada != null && _categoriaSeleccionada!.isNotEmpty) {
      _productosFiltrados = _productosFiltrados
          .where((p) => p.categoria == _categoriaSeleccionada)
          .toList();
    }

    if (_textoBusqueda.isNotEmpty) {
      _productosFiltrados = _productosFiltrados
          .where(
            (p) =>
                p.nombre.toLowerCase().contains(_textoBusqueda.toLowerCase()) ||
                p.descripcion.toLowerCase().contains(
                  _textoBusqueda.toLowerCase(),
                ),
          )
          .toList();
    }

    notifyListeners();
  }

  void limpiarFiltros() {
    _marcaSeleccionada = null;
    _modeloSeleccionado = null;
    _categoriaSeleccionada = null;
    _textoBusqueda = '';
    _productosFiltrados = _productos;
    notifyListeners();
  }
}
