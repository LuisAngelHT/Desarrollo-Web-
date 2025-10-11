package Modelo;

public class ItemVenta {
    private int idDetalleVenta;
    private String nombreProducto;
    private int cantidad;
    private double precioUnitario;
    private double subtotal;
    private String color;      // ✅ AGREGAR
    private String talla;      // ✅ AGREGAR

    public ItemVenta() {
    }

    public ItemVenta(String nombreProducto, int cantidad, double precioUnitario) {
        this.nombreProducto = nombreProducto;
        this.cantidad = cantidad;
        this.precioUnitario = precioUnitario;
        this.subtotal = cantidad * precioUnitario;
    }

    public int getIdDetalleVenta() {
        return idDetalleVenta;
    }

    public void setIdDetalleVenta(int idDetalleVenta) {
        this.idDetalleVenta = idDetalleVenta;
    }

    public String getNombreProducto() {
        return nombreProducto;
    }

    public void setNombreProducto(String nombreProducto) {
        this.nombreProducto = nombreProducto;
    }

    public int getCantidad() {
        return cantidad;
    }

    public void setCantidad(int cantidad) {
        this.cantidad = cantidad;
        this.subtotal = cantidad * precioUnitario;
    }

    public double getPrecioUnitario() {
        return precioUnitario;
    }

    public void setPrecioUnitario(double precioUnitario) {
        this.precioUnitario = precioUnitario;
        this.subtotal = cantidad * precioUnitario;
    }

    public double getSubtotal() {
        return subtotal;
    }

    public void setSubtotal(double subtotal) {
        this.subtotal = subtotal;
    }

    public String getColor() {  // ✅ AGREGAR
        return color;
    }

    public void setColor(String color) {  // ✅ AGREGAR
        this.color = color;
    }

    public String getTalla() {  // ✅ AGREGAR
        return talla;
    }

    public void setTalla(String talla) {  // ✅ AGREGAR
        this.talla = talla;
    }
}