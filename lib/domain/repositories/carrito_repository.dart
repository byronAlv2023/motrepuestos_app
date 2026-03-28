import '../entities/carrito.dart';
import '../entities/item_carrito.dart';

abstract class CarritoRepository {
  // Obtener el carrito actual del usuario
  Future<Carrito> obtenerCarrito(String usuarioId);

  // Agregar o actualizar un item en el carrito
  Future<void> agregarOActualizarItem(String usuarioId, ItemCarrito item);

  // Actualizar cantidad de un producto
  Future<void> actualizarCantidad(
    String usuarioId,
    String productId,
    int cantidad,
  );

  // Quitar un producto del carrito
  Future<void> quitarItem(String usuarioId, String productId);

  // Limpiar todo el carrito
  Future<void> limpiarCarrito(String usuarioId);

  // Obtener cantidad total de items
  Future<int> obtenerCantidadTotal(String usuarioId);
}
