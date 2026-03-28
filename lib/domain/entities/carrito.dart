import 'item_carrito.dart';

class Carrito {
  final String id;
  final String usuarioId;
  final List<ItemCarrito> items;
  final DateTime fechaCreacion;
  DateTime fechaActualizacion;

  Carrito({
    required this.id,
    required this.usuarioId,
    required this.items,
    DateTime? fechaCreacion,
    DateTime? fechaActualizacion,
  }) : fechaCreacion = fechaCreacion ?? DateTime.now(),
       fechaActualizacion = fechaActualizacion ?? DateTime.now();

  double get total {
    return items.fold(0, (sum, item) => sum + item.subtotal);
  }

  int get cantidadTotal {
    return items.fold(0, (sum, item) => sum + item.cantidad);
  }

  void agregarOActualizarItem(ItemCarrito item) {
    final index = items.indexWhere((i) => i.producto.id == item.producto.id);
    if (index >= 0) {
      items[index].actualizarCantidad(items[index].cantidad + item.cantidad);
    } else {
      items.add(item);
    }
    fechaActualizacion = DateTime.now();
  }

  void quitarItem(String productId) {
    items.removeWhere((item) => item.producto.id == productId);
    fechaActualizacion = DateTime.now();
  }

  void actualizarCantidad(String productId, int cantidad) {
    final index = items.indexWhere((item) => item.producto.id == productId);
    if (index >= 0) {
      if (cantidad > 0) {
        items[index].actualizarCantidad(cantidad);
      } else {
        items.removeAt(index);
      }
      fechaActualizacion = DateTime.now();
    }
  }

  void limpiar() {
    items.clear();
    fechaActualizacion = DateTime.now();
  }
}
