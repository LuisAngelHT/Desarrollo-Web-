package Modelo;

/**
 * Clase para representar los productos más comprados por un cliente
 */
public class ProductoComprado {
    private int idProducto;
    private String nombreProducto;
    private String categoria;
    private int cantidadComprada;
    private double totalGastado;

    // Constructor vacío
    public ProductoComprado() {
    }

    // Constructor completo
    public ProductoComprado(int idProducto, String nombreProducto, String categoria, 
                           int cantidadComprada, double totalGastado) {
        this.idProducto = idProducto;
        this.nombreProducto = nombreProducto;
        this.categoria = categoria;
        this.cantidadComprada = cantidadComprada;
        this.totalGastado = totalGastado;
    }

    // Getters y Setters
    public int getIdProducto() {
        return idProducto;
    }

    public void setIdProducto(int idProducto) {
        this.idProducto = idProducto;
    }

    public String getNombreProducto() {
        return nombreProducto;
    }

    public void setNombreProducto(String nombreProducto) {
        this.nombreProducto = nombreProducto;
    }

    public String getCategoria() {
        return categoria;
    }

    public void setCategoria(String categoria) {
        this.categoria = categoria;
    }

    public int getCantidadComprada() {
        return cantidadComprada;
    }

    public void setCantidadComprada(int cantidadComprada) {
        this.cantidadComprada = cantidadComprada;
    }

    public double getTotalGastado() {
        return totalGastado;
    }

    public void setTotalGastado(double totalGastado) {
        this.totalGastado = totalGastado;
    }

    @Override
    public String toString() {
        return "ProductoComprado{" +
                "idProducto=" + idProducto +
                ", nombreProducto='" + nombreProducto + '\'' +
                ", categoria='" + categoria + '\'' +
                ", cantidadComprada=" + cantidadComprada +
                ", totalGastado=" + totalGastado +
                '}';
    }
}