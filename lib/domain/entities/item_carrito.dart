import 'producto.dart';

class ItemCarrito {
  final String id;
  final Producto producto;
  int cantidad;

  ItemCarrito({required this.id, required this.producto, this.cantidad = 1});

  double get subtotal {
    return producto.precioFinal * cantidad;
  }

  void actualizarCantidad(int nuevaCantidad) {
    if (nuevaCantidad > 0) {
      cantidad = nuevaCantidad;
    }
  }
}
