package Modelo;

import java.sql.Timestamp;

public class Carrito {
    private int idCarrito;
    private int idCliente;
    private int idInventario;
    private int cantidad;
    private Timestamp fechaAgregado;
    
    // Campos auxiliares para mostrar en la vista
    private String nombreProducto;
    private String imagenUrl;
    private double precioUnitario;
    private String talla;
    private String color;
    private int stockDisponible;
    
    // Constructor vacío
    public Carrito() {}
    
    // Constructor con parámetros básicos
    public Carrito(int idCliente, int idInventario, int cantidad) {
        this.idCliente = idCliente;
        this.idInventario = idInventario;
        this.cantidad = cantidad;
    }
    
    // Getters y Setters
    public int getIdCarrito() {
        return idCarrito;
    }
    
    public void setIdCarrito(int idCarrito) {
        this.idCarrito = idCarrito;
    }
    
    public int getIdCliente() {
        return idCliente;
    }
    
    public void setIdCliente(int idCliente) {
        this.idCliente = idCliente;
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
    
    public Timestamp getFechaAgregado() {
        return fechaAgregado;
    }
    
    public void setFechaAgregado(Timestamp fechaAgregado) {
        this.fechaAgregado = fechaAgregado;
    }
    
    public String getNombreProducto() {
        return nombreProducto;
    }
    
    public void setNombreProducto(String nombreProducto) {
        this.nombreProducto = nombreProducto;
    }
    
    public String getImagenUrl() {
        return imagenUrl;
    }
    
    public void setImagenUrl(String imagenUrl) {
        this.imagenUrl = imagenUrl;
    }
    
    public double getPrecioUnitario() {
        return precioUnitario;
    }
    
    public void setPrecioUnitario(double precioUnitario) {
        this.precioUnitario = precioUnitario;
    }
    
    public String getTalla() {
        return talla;
    }
    
    public void setTalla(String talla) {
        this.talla = talla;
    }
    
    public String getColor() {
        return color;
    }
    
    public void setColor(String color) {
        this.color = color;
    }
    
    public int getStockDisponible() {
        return stockDisponible;
    }
    
    public void setStockDisponible(int stockDisponible) {
        this.stockDisponible = stockDisponible;
    }
    
    // Método auxiliar para calcular el subtotal
    public double getSubtotal() {
        return precioUnitario * cantidad;
    }
    
    // Método para obtener descripción de la variante
    public String getVarianteDescripcion() {
        StringBuilder desc = new StringBuilder();
        if (talla != null && !talla.isEmpty()) {
            desc.append("Talla: ").append(talla);
        }
        if (color != null && !color.isEmpty()) {
            if (desc.length() > 0) desc.append(" - ");
            desc.append("Color: ").append(color);
        }
        return desc.toString();
    }
}