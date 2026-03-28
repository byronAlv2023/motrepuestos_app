import '../entities/producto.dart';

abstract class ProductoRepository {
  Future<List<Producto>> obtenerTodosLosProductos();

  Future<List<Producto>> buscarPorMarcaYModelo({
    String? marcaId,
    String? modeloId,
    String? categoria,
  });

  Future<List<Producto>> buscarPorTexto(String texto);

  Future<Producto?> obtenerProductoPorId(String id);

  Future<List<String>> obtenerMarcasDisponibles();

  Future<List<String>> obtenerModelosPorMarca(String marcaId);
}
