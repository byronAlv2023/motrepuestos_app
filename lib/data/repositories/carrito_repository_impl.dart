import '../../domain/entities/carrito.dart';
import '../../domain/entities/item_carrito.dart';
import '../../domain/repositories/carrito_repository.dart';
import '../datasources/carrito_local_datasource.dart';

class CarritoRepositoryImpl implements CarritoRepository {
  final CarritoLocalDataSource localDataSource;

  CarritoRepositoryImpl({required this.localDataSource});

  @override
  Future<Carrito> obtenerCarrito(String usuarioId) async {
    return await localDataSource.obtenerCarrito(usuarioId);
  }

  @override
  Future<void> agregarOActualizarItem(
    String usuarioId,
    ItemCarrito item,
  ) async {
    await localDataSource.agregarOActualizarItem(usuarioId, item);
  }

  @override
  Future<void> actualizarCantidad(
    String usuarioId,
    String productId,
    int cantidad,
  ) async {
    await localDataSource.actualizarCantidad(usuarioId, productId, cantidad);
  }

  @override
  Future<void> quitarItem(String usuarioId, String productId) async {
    await localDataSource.quitarItem(usuarioId, productId);
  }

  @override
  Future<void> limpiarCarrito(String usuarioId) async {
    await localDataSource.limpiarCarrito(usuarioId);
  }

  @override
  Future<int> obtenerCantidadTotal(String usuarioId) async {
    final carrito = await localDataSource.obtenerCarrito(usuarioId);
    return carrito.cantidadTotal;
  }
}
