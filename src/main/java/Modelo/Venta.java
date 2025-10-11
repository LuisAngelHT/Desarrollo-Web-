package Modelo;

import java.sql.Timestamp;
import java.util.List;

public class Venta {
    private int idVenta;
    private Timestamp fechaVenta;
    private double totalFinal;
    private boolean estado;
    private int idCliente;
    private Integer idVendedor;
    private List<ItemVenta> productos;
    
    // Atributos auxiliares para el PDF
    private String nombreCliente;
    private String emailCliente;
    private String telefonoCliente;
    private String direccionCliente;
    
    public Venta() {
    }

    public Venta(int idVenta, Timestamp fechaVenta, double totalFinal, boolean estado, int idCliente, Integer idVendedor) {
        this.idVenta = idVenta;
        this.fechaVenta = fechaVenta;
        this.totalFinal = totalFinal;
        this.estado = estado;
        this.idCliente = idCliente;
        this.idVendedor = idVendedor;
    }

    public int getIdVenta() {
        return idVenta;
    }

    public void setIdVenta(int idVenta) {
        this.idVenta = idVenta;
    }

    public Timestamp getFechaVenta() {
        return fechaVenta;
    }

    public void setFechaVenta(Timestamp fechaVenta) {
        this.fechaVenta = fechaVenta;
    }

    public double getTotalFinal() {
        return totalFinal;
    }

    public void setTotalFinal(double totalFinal) {
        this.totalFinal = totalFinal;
    }

    public boolean isEstado() {
        return estado;
    }

    public void setEstado(boolean estado) {
        this.estado = estado;
    }

    public int getIdCliente() {
        return idCliente;
    }

    public void setIdCliente(int idCliente) {
        this.idCliente = idCliente;
    }

    public Integer getIdVendedor() {
        return idVendedor;
    }

    public void setIdVendedor(Integer idVendedor) {
        this.idVendedor = idVendedor;
    }

    public List<ItemVenta> getProductos() {
        return productos;
    }

    public void setProductos(List<ItemVenta> productos) {
        this.productos = productos;
    }

    public String getNombreCliente() {
        return nombreCliente;
    }

    public void setNombreCliente(String nombreCliente) {
        this.nombreCliente = nombreCliente;
    }

    public String getEmailCliente() {
        return emailCliente;
    }

    public void setEmailCliente(String emailCliente) {
        this.emailCliente = emailCliente;
    }

    public String getTelefonoCliente() {
        return telefonoCliente;
    }

    public void setTelefonoCliente(String telefonoCliente) {
        this.telefonoCliente = telefonoCliente;
    }

    public String getDireccionCliente() {
        return direccionCliente;
    }

    public void setDireccionCliente(String direccionCliente) {
        this.direccionCliente = direccionCliente;
    }

}
