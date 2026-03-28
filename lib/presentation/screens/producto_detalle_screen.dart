import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/carrito_viewmodel.dart';
import '../../domain/entities/item_carrito.dart';

class ProductoDetalleScreen extends StatelessWidget {
  final dynamic producto;

  const ProductoDetalleScreen({super.key, required this.producto});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle del Producto'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.pushNamed(context, '/carrito');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen del producto
            Container(
              height: 300,
              width: double.infinity,
              color: Colors.grey[200],
              child: producto.imageUrl.isNotEmpty
                  ? Image.network(
                      producto.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(
                          child: Icon(
                            Icons.two_wheeler,
                            size: 100,
                            color: Colors.grey,
                          ),
                        );
                      },
                    )
                  : const Center(
                      child: Icon(
                        Icons.two_wheeler,
                        size: 100,
                        color: Colors.grey,
                      ),
                    ),
            ),

            // Información del producto
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nombre
                  Text(
                    producto.nombre,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Marca
                  Row(
                    children: [
                      const Icon(Icons.business, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        producto.marcaNombre,
                        style: TextStyle(color: Colors.grey[700], fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Categoría
                  Row(
                    children: [
                      const Icon(Icons.category, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        producto.categoria,
                        style: TextStyle(color: Colors.grey[700], fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Precio
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Precio:',
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                          Text(
                            '\$${producto.precioFinal.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                      if (producto.descuento != null && producto.descuento! > 0)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text(
                                'OFERTA',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '\$${producto.precio.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey[400],
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                            Text(
                              '${producto.descuento}% OFF',
                              style: const TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Descripción
                  const Text(
                    'Descripción:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    producto.descripcion,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Disponibilidad
                  Row(
                    children: [
                      Icon(
                        producto.hayStock ? Icons.check_circle : Icons.cancel,
                        color: producto.hayStock ? Colors.green : Colors.red,
                        size: 24,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        producto.hayStock
                            ? 'Disponible (${producto.stock} unidades)'
                            : 'Sin stock',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: producto.hayStock ? Colors.green : Colors.red,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Modelos compatibles
                  const Text(
                    'Compatible con:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: producto.modelosCompatibles
                        .map<Widget>(
                          (modelo) => Chip(
                            label: Text(modelo),
                            backgroundColor: Colors.blue[50],
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton.icon(
          onPressed: producto.hayStock
              ? () async {
                  // Mostrar diálogo de cantidad
                  int cantidad = 1;

                  await showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Cantidad'),
                      content: StatefulBuilder(
                        builder: (context, setState) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    onPressed: cantidad > 1
                                        ? () => setState(() => cantidad--)
                                        : null,
                                    icon: const Icon(Icons.remove),
                                  ),
                                  Text(
                                    '$cantidad',
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () => setState(() => cantidad++),
                                    icon: const Icon(Icons.add),
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancelar'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);

                            // Agregar al carrito
                            final item = ItemCarrito(
                              id: DateTime.now().millisecondsSinceEpoch
                                  .toString(),
                              producto: producto,
                              cantidad: cantidad,
                            );

                            // Usar el ViewModel del carrito
                            final carritoViewModel =
                                Provider.of<CarritoViewModel>(
                                  context,
                                  listen: false,
                                );
                            carritoViewModel.agregarProducto(
                              producto,
                              cantidad,
                            );

                            // Mostrar mensaje de éxito
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  '$cantidad producto(s) agregado(s) al carrito',
                                ),
                                backgroundColor: Colors.green,
                                action: SnackBarAction(
                                  label: 'Ver Carrito',
                                  textColor: Colors.white,
                                  onPressed: () {
                                    Navigator.pushNamed(context, '/carrito');
                                  },
                                ),
                              ),
                            );
                          },
                          child: const Text('Agregar'),
                        ),
                      ],
                    ),
                  );
                }
              : null,
          icon: const Icon(Icons.add_shopping_cart),
          label: const Text(
            'Agregar al Carrito',
            style: TextStyle(fontSize: 16),
          ),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
    );
  }
}
