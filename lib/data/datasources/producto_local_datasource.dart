import '../../domain/entities/producto.dart';

class ProductoLocalDataSource {
  Future<List<Producto>> obtenerProductos() async {
    // Datos de prueba - luego vendrán de una API o base de datos
    await Future.delayed(const Duration(milliseconds: 500));

    return [
      Producto(
        id: '1',
        nombre: 'Aceite Motul 7100 4T 10W40',
        descripcion:
            'Aceite 100% sintético para motocicletas de alta performance',
        precio: 18.50,
        marcaId: '1',
        marcaNombre: 'Motul',
        modelosCompatibles: ['1', '2', '3'],
        categoria: 'Aceites',
        imageUrl: 'https://via.placeholder.com/300x300?text=Aceite+Motul',
        stock: 25,
        disponible: true,
        descuento: 10,
      ),
      Producto(
        id: '2',
        nombre: 'Pastillas de Freno Delantero Brembo',
        descripcion:
            'Pastillas de freno de alto rendimiento para disco delantero',
        precio: 35.00,
        marcaId: '2',
        marcaNombre: 'Brembo',
        modelosCompatibles: ['1', '3'],
        categoria: 'Frenos',
        imageUrl: 'https://via.placeholder.com/300x300?text=Pastillas+Brembo',
        stock: 15,
        disponible: true,
      ),
      Producto(
        id: '3',
        nombre: 'Cadena de Transmisión DID',
        descripcion: 'Cadena reforzada 520VX3 con eslabones 110',
        precio: 45.00,
        marcaId: '3',
        marcaNombre: 'DID',
        modelosCompatibles: ['2', '4'],
        categoria: 'Transmisión',
        imageUrl: 'https://via.placeholder.com/300x300?text=Cadena+DID',
        stock: 8,
        disponible: true,
        descuento: 5,
      ),
      Producto(
        id: '4',
        nombre: 'Filtro de Aire K&N',
        descripcion: 'Filtro de aire lavable y reutilizable de alto flujo',
        precio: 28.00,
        marcaId: '4',
        marcaNombre: 'K&N',
        modelosCompatibles: ['1', '2', '3', '4'],
        categoria: 'Filtros',
        imageUrl: 'https://via.placeholder.com/300x300?text=Filtro+KN',
        stock: 20,
        disponible: true,
      ),
      Producto(
        id: '5',
        nombre: 'Bujía NGK Iridium',
        descripcion: 'Bujía de iridium para mejor encendido y rendimiento',
        precio: 12.00,
        marcaId: '5',
        marcaNombre: 'NGK',
        modelosCompatibles: ['1', '2'],
        categoria: 'Encendido',
        imageUrl: 'https://via.placeholder.com/300x300?text=Bujia+NGK',
        stock: 50,
        disponible: true,
      ),
      Producto(
        id: '6',
        nombre: 'Amortiguador Trasero YSS',
        descripcion: 'Amortiguador trasero regulable con depósito de gas',
        precio: 85.00,
        marcaId: '6',
        marcaNombre: 'YSS',
        modelosCompatibles: ['3', '4'],
        categoria: 'Suspensión',
        imageUrl: 'https://via.placeholder.com/300x300?text=Amortiguador+YSS',
        stock: 5,
        disponible: true,
        descuento: 15,
      ),
    ];
  }
}
