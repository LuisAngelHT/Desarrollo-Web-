package Modelo;

public class DetalleVenta {

     private int idDetalle;
    private int idVenta;
    private int idInventario;
    private int cantidad;
    private double precioUnitarioVenta;
    private String nombreProducto;

    // Constructores
    public DetalleVenta() {
    }

    public DetalleVenta(int idDetalle, int idVenta, int idInventario, int cantidad, double precioUnitarioVenta) {
        this.idDetalle = idDetalle;
        this.idVenta = idVenta;
        this.idInventario = idInventario;
        this.cantidad = cantidad;
        this.precioUnitarioVenta = precioUnitarioVenta;
    }

    public int getIdDetalle() {
        return idDetalle;
    }

    public void setIdDetalle(int idDetalle) {
        this.idDetalle = idDetalle;
    }

    public int getIdVenta() {
        return idVenta;
    }

    public void setIdVenta(int idVenta) {
        this.idVenta = idVenta;
    }

    public int getIdInventario() {
        return idInventario;
    }

    public void setIdInventario(int idInventario) {
        this.idInventario = idInventario;
    }

    public int getCantidad() {
        return cantidad;
    }

    public void setCantidad(int cantidad) {
        this.cantidad = cantidad;
    }

    public double getPrecioUnitarioVenta() {
        return precioUnitarioVenta;
    }

    public void setPrecioUnitarioVenta(double precioUnitarioVenta) {
        this.precioUnitarioVenta = precioUnitarioVenta;
    }

    public String getNombreProducto() {
        return nombreProducto;
    }

    public void setNombreProducto(String nombreProducto) {
        this.nombreProducto = nombreProducto;
    }
}
