package Modelo;

import Config.conexion;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class VentaDAO {

    private Connection connection;

    public VentaDAO() {
        this.connection = conexion.getConnection();
    }

    /**
     * Registra una venta completa (venta + detalles)
     */
    public int registrarVenta(int idCliente, List<Carrito> items, double total) {
        String sqlVenta = "INSERT INTO Venta (id_cliente, total_final, estado, fecha_venta) VALUES (?, ?, ?, NOW())";
        String sqlDetalle = "INSERT INTO Detalle_Venta (id_venta, id_inventario, cantidad, precio_unitario_venta) "
                + "VALUES (?, ?, ?, ?)";

        try {
            connection.setAutoCommit(false);

            PreparedStatement psVenta = connection.prepareStatement(sqlVenta, Statement.RETURN_GENERATED_KEYS);
            psVenta.setInt(1, idCliente);
            psVenta.setDouble(2, total);
            psVenta.setBoolean(3, true);
            psVenta.executeUpdate();

            ResultSet rs = psVenta.getGeneratedKeys();
            int idVenta = 0;
            if (rs.next()) {
                idVenta = rs.getInt(1);
            }

            System.out.println("Venta registrada con ID: " + idVenta);

            PreparedStatement psDetalle = connection.prepareStatement(sqlDetalle);
            for (Carrito item : items) {
                psDetalle.setInt(1, idVenta);
                psDetalle.setInt(2, item.getIdInventario());
                psDetalle.setInt(3, item.getCantidad());
                psDetalle.setDouble(4, item.getPrecioUnitario());
                psDetalle.addBatch();

                System.out.println("Detalle agregado: Inventario " + item.getIdInventario() + " - Cantidad " + item.getCantidad());
            }
            psDetalle.executeBatch();

            connection.commit();
            connection.setAutoCommit(true);

            System.out.println("Venta completada correctamente");
            return idVenta;

        } catch (SQLException e) {
            try {
                connection.rollback();
                connection.setAutoCommit(true);
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            System.err.println("Error al registrar venta:");
            e.printStackTrace();
            return 0;
        }
    }

    /**
     * Obtiene una venta completa con sus detalles
     */
    public Venta obtenerVentaCompleta(int idVenta) {
        Venta venta = null;

        String sqlVenta = "SELECT v.*, u.nombre, u.apellido, u.email, u.telefono, u.direccion "
                + "FROM Venta v "
                + "INNER JOIN Usuario u ON v.id_cliente = u.id_usuario "
                + "WHERE v.id_venta = ?";

        // ✅ AGREGAR i.color, i.talla
        String sqlDetalles = "SELECT dv.*, p.nombre as nombre_producto, i.color, i.talla "
                + "FROM Detalle_Venta dv "
                + "INNER JOIN Inventario i ON dv.id_inventario = i.id_inventario "
                + "INNER JOIN Producto p ON i.id_producto = p.id_producto "
                + "WHERE dv.id_venta = ?";

        try {
            PreparedStatement psVenta = connection.prepareStatement(sqlVenta);
            psVenta.setInt(1, idVenta);
            ResultSet rsVenta = psVenta.executeQuery();

            if (rsVenta.next()) {
                venta = new Venta();
                venta.setIdVenta(rsVenta.getInt("id_venta"));
                venta.setIdCliente(rsVenta.getInt("id_cliente"));
                venta.setFechaVenta(rsVenta.getTimestamp("fecha_venta"));
                venta.setTotalFinal(rsVenta.getDouble("total_final"));
                venta.setEstado(rsVenta.getBoolean("estado"));
                venta.setIdVendedor(rsVenta.getObject("id_vendedor") != null ? rsVenta.getInt("id_vendedor") : null);

                String nombreCompleto = rsVenta.getString("nombre") + " " + rsVenta.getString("apellido");
                String email = rsVenta.getString("email");
                String telefono = rsVenta.getString("telefono");
                String direccion = rsVenta.getString("direccion");

                venta.setNombreCliente(nombreCompleto);
                venta.setEmailCliente(email);
                venta.setTelefonoCliente(telefono);
                venta.setDireccionCliente(direccion);

                System.out.println("Venta encontrada: ID " + idVenta);
                System.out.println("Cliente: " + nombreCompleto);

                PreparedStatement psDetalles = connection.prepareStatement(sqlDetalles);
                psDetalles.setInt(1, idVenta);
                ResultSet rsDetalles = psDetalles.executeQuery();

                List<ItemVenta> productos = new ArrayList<>();
                while (rsDetalles.next()) {
                    ItemVenta item = new ItemVenta();
                    item.setIdDetalleVenta(rsDetalles.getInt("id_detalle"));
                    item.setNombreProducto(rsDetalles.getString("nombre_producto"));
                    item.setCantidad(rsDetalles.getInt("cantidad"));
                    item.setPrecioUnitario(rsDetalles.getDouble("precio_unitario_venta"));
                    item.setSubtotal(rsDetalles.getDouble("precio_unitario_venta") * rsDetalles.getInt("cantidad"));
                    // ✅ GUARDAR COLOR Y TALLA DIRECTAMENTE
                    item.setColor(rsDetalles.getString("color"));
                    item.setTalla(rsDetalles.getString("talla"));

                    productos.add(item);
                    System.out.println("Detalle: " + item.getNombreProducto() + " - " + item.getColor() + " - " + item.getTalla());
                }

                venta.setProductos(productos);
                System.out.println("Total detalles: " + productos.size());

                rsDetalles.close();
                psDetalles.close();
            } else {
                System.err.println("No se encontró la venta con ID: " + idVenta);
            }

            rsVenta.close();
            psVenta.close();

        } catch (SQLException e) {
            System.err.println("ERROR en obtenerVentaCompleta:");
            e.printStackTrace();
        }

        return venta;
    }
}
