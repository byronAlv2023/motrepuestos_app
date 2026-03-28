import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/catalogo_viewmodel.dart';
import 'producto_detalle_screen.dart';
import 'carrito_screen.dart';

class CatalogoScreen extends StatelessWidget {
  const CatalogoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CatalogoViewModel(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Catálogo de Repuestos'),
          actions: [
            Consumer<CatalogoViewModel>(
              builder: (context, viewModel, child) {
                return Stack(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.shopping_cart),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CarritoScreen(),
                          ),
                        );
                      },
                    ),
                    if (viewModel.productos.isNotEmpty)
                      Positioned(
                        right: 8,
                        top: 8,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 16,
                            minHeight: 16,
                          ),
                          child: Text(
                            '${viewModel.productos.length}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ],
        ),
        body: Consumer<CatalogoViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            return Column(
              children: [
                // Barra de búsqueda
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    onChanged: viewModel.setTextoBusqueda,
                    decoration: InputDecoration(
                      hintText: 'Buscar repuestos...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                    ),
                  ),
                ),

                // Filtros
                Container(
                  height: 60,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      // Filtro por categoría
                      DropdownButton<String>(
                        value: viewModel.categoriaSeleccionada,
                        hint: const Text('Categoría'),
                        items: viewModel.categorias.map((categoria) {
                          return DropdownMenuItem(
                            value: categoria,
                            child: Text(categoria),
                          );
                        }).toList(),
                        onChanged: (value) {
                          viewModel.setCategoriaSeleccionada(value);
                        },
                      ),
                      const SizedBox(width: 10),

                      // Filtro por marca
                      if (viewModel.marcasDisponibles.isNotEmpty)
                        DropdownButton<String>(
                          value: viewModel.marcaSeleccionada,
                          hint: const Text('Marca'),
                          items: viewModel.marcasDisponibles.map((marca) {
                            return DropdownMenuItem(
                              value: marca,
                              child: Text(marca),
                            );
                          }).toList(),
                          onChanged: (value) {
                            viewModel.setMarcaSeleccionada(value);
                          },
                        ),
                      const SizedBox(width: 10),

                      // Botón limpiar filtros
                      if (viewModel.marcaSeleccionada != null ||
                          viewModel.categoriaSeleccionada != null)
                        ElevatedButton.icon(
                          onPressed: viewModel.limpiarFiltros,
                          icon: const Icon(Icons.clear),
                          label: const Text('Limpiar'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[300],
                          ),
                        ),
                    ],
                  ),
                ),

                const Divider(),

                // Lista de productos
                Expanded(
                  child: viewModel.productos.isEmpty
                      ? const Center(
                          child: Text(
                            'No se encontraron productos',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        )
                      : GridView.builder(
                          padding: const EdgeInsets.all(16),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 0.75,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                              ),
                          itemCount: viewModel.productos.length,
                          itemBuilder: (context, index) {
                            final producto = viewModel.productos[index];
                            return _ProductoCard(producto: producto);
                          },
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _ProductoCard extends StatelessWidget {
  final dynamic producto;

  const _ProductoCard({required this.producto});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductoDetalleScreen(producto: producto),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen del producto
            Expanded(
              child: Container(
                width: double.infinity,
                color: Colors.grey[200],
                child: producto.imageUrl.isNotEmpty
                    ? Image.network(
                        producto.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.two_wheeler,
                            size: 50,
                            color: Colors.grey,
                          );
                        },
                      )
                    : const Icon(
                        Icons.two_wheeler,
                        size: 50,
                        color: Colors.grey,
                      ),
              ),
            ),

            // Información del producto
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    producto.nombre,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    producto.marcaNombre,
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$${producto.precioFinal.toStringAsFixed(2)}',
                        style: const TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      if (producto.descuento != null && producto.descuento! > 0)
                        Text(
                          '\$${producto.precio.toStringAsFixed(2)}',
                          style: TextStyle(
                            color: Colors.grey[400],
                            decoration: TextDecoration.lineThrough,
                            fontSize: 12,
                          ),
                        ),
                    ],
                  ),
                  if (!producto.hayStock)
                    const Text(
                      'Sin stock',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
