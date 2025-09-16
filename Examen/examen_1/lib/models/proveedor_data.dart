enum EstadoCompra { completada, anulada }

class ProveedorData {
  final String nombre;
  final double subtotal;
  final EstadoCompra estado;

  ProveedorData({
    required this.nombre,
    required this.subtotal,
    required this.estado,
  });
}