import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart'; // ← Agrega esta línea
import '../../domain/entities/carrito.dart';
import '../../domain/entities/item_carrito.dart';
import '../../domain/entities/producto.dart';

class CarritoLocalDataSource {
  static const String _carritoKey = 'carrito_';

  Future<Carrito> obtenerCarrito(String usuarioId) async {
    final prefs = await SharedPreferences.getInstance();
    final carritoJson = prefs.getString('$_carritoKey$usuarioId');

    if (carritoJson == null || carritoJson.isEmpty) {
      return Carrito(id: usuarioId, usuarioId: usuarioId, items: []);
    }

    final data = jsonDecode(carritoJson) as Map<String, dynamic>;
    final itemsJson = data['items'] as List;

    final items = itemsJson.map((itemJson) {
      final productoJson = itemJson['producto'] as Map<String, dynamic>;
      return ItemCarrito(
        id: itemJson['id'],
        producto: Producto(
          id: productoJson['id'],
          nombre: productoJson['nombre'],
          descripcion: productoJson['descripcion'],
          precio: productoJson['precio'].toDouble(),
          marcaId: productoJson['marcaId'],
          marcaNombre: productoJson['marcaNombre'],
          modelosCompatibles: List<String>.from(
            productoJson['modelosCompatibles'],
          ),
          categoria: productoJson['categoria'],
          imageUrl: productoJson['imageUrl'],
          stock: productoJson['stock'],
          disponible: productoJson['disponible'],
          descuento: productoJson['descuento']?.toDouble(),
        ),
        cantidad: itemJson['cantidad'],
      );
    }).toList();

    return Carrito(
      id: data['id'],
      usuarioId: data['usuarioId'],
      items: items,
      fechaCreacion: DateTime.parse(data['fechaCreacion']),
      fechaActualizacion: DateTime.parse(data['fechaActualizacion']),
    );
  }

  Future<void> agregarOActualizarItem(
    String usuarioId,
    ItemCarrito item,
  ) async {
    final carrito = await obtenerCarrito(usuarioId);
    carrito.agregarOActualizarItem(item);
    await _guardarCarrito(usuarioId, carrito);
  }

  Future<void> actualizarCantidad(
    String usuarioId,
    String productId,
    int cantidad,
  ) async {
    final carrito = await obtenerCarrito(usuarioId);
    carrito.actualizarCantidad(productId, cantidad);
    await _guardarCarrito(usuarioId, carrito);
  }

  Future<void> quitarItem(String usuarioId, String productId) async {
    final carrito = await obtenerCarrito(usuarioId);
    carrito.quitarItem(productId);
    await _guardarCarrito(usuarioId, carrito);
  }

  Future<void> limpiarCarrito(String usuarioId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('$_carritoKey$usuarioId');
  }

  Future<void> _guardarCarrito(String usuarioId, Carrito carrito) async {
    final prefs = await SharedPreferences.getInstance();

    final itemsJson = carrito.items.map((item) {
      return {
        'id': item.id,
        'cantidad': item.cantidad,
        'producto': {
          'id': item.producto.id,
          'nombre': item.producto.nombre,
          'descripcion': item.producto.descripcion,
          'precio': item.producto.precio,
          'marcaId': item.producto.marcaId,
          'marcaNombre': item.producto.marcaNombre,
          'modelosCompatibles': item.producto.modelosCompatibles,
          'categoria': item.producto.categoria,
          'imageUrl': item.producto.imageUrl,
          'stock': item.producto.stock,
          'disponible': item.producto.disponible,
          'descuento': item.producto.descuento,
        },
      };
    }).toList();

    final carritoJson = jsonEncode({
      'id': carrito.id,
      'usuarioId': carrito.usuarioId,
      'items': itemsJson,
      'fechaCreacion': carrito.fechaCreacion.toIso8601String(),
      'fechaActualizacion': carrito.fechaActualizacion.toIso8601String(),
    });

    await prefs.setString('$_carritoKey$usuarioId', carritoJson);
  }
}
