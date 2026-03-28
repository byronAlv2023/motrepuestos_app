class Producto {
  final String id;
  final String nombre;
  final String descripcion;
  final double precio;
  final String marcaId;
  final String marcaNombre;
  final List<String> modelosCompatibles;
  final String categoria;
  final String imageUrl;
  final int stock;
  final bool disponible;
  final double? descuento;

  Producto({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.precio,
    required this.marcaId,
    required this.marcaNombre,
    required this.modelosCompatibles,
    required this.categoria,
    required this.imageUrl,
    required this.stock,
    required this.disponible,
    this.descuento,
  });

  double get precioFinal {
    if (descuento != null && descuento! > 0) {
      return precio * (1 - descuento! / 100);
    }
    return precio;
  }

  bool get hayStock => stock > 0;
}
