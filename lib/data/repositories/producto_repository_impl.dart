import '../../domain/entities/producto.dart';
import '../../domain/repositories/producto_repository.dart';
import '../datasources/producto_local_datasource.dart';

class ProductoRepositoryImpl implements ProductoRepository {
  final ProductoLocalDataSource localDataSource;

  ProductoRepositoryImpl({required this.localDataSource});

  @override
  Future<List<Producto>> obtenerTodosLosProductos() async {
    return await localDataSource.obtenerProductos();
  }

  @override
  Future<List<Producto>> buscarPorMarcaYModelo({
    String? marcaId,
    String? modeloId,
    String? categoria,
  }) async {
    var productos = await localDataSource.obtenerProductos();

    if (marcaId != null && marcaId.isNotEmpty) {
      productos = productos.where((p) => p.marcaId == marcaId).toList();
    }

    if (modeloId != null && modeloId.isNotEmpty) {
      productos = productos
          .where((p) => p.modelosCompatibles.contains(modeloId))
          .toList();
    }

    if (categoria != null && categoria.isNotEmpty) {
      productos = productos.where((p) => p.categoria == categoria).toList();
    }

    return productos;
  }

  @override
  Future<List<Producto>> buscarPorTexto(String texto) async {
    var productos = await localDataSource.obtenerProductos();
    return productos
        .where(
          (p) =>
              p.nombre.toLowerCase().contains(texto.toLowerCase()) ||
              p.descripcion.toLowerCase().contains(texto.toLowerCase()),
        )
        .toList();
  }

  @override
  Future<Producto?> obtenerProductoPorId(String id) async {
    var productos = await localDataSource.obtenerProductos();
    try {
      return productos.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<String>> obtenerMarcasDisponibles() async {
    var productos = await localDataSource.obtenerProductos();
    var marcas = productos.map((p) => p.marcaNombre).toSet().toList();
    return marcas;
  }

  @override
  Future<List<String>> obtenerModelosPorMarca(String marcaId) async {
    var productos = await localDataSource.obtenerProductos();
    var modelos = <String>{};

    for (var producto in productos) {
      if (producto.marcaId == marcaId) {
        modelos.addAll(producto.modelosCompatibles);
      }
    }

    return modelos.toList();
  }
}
