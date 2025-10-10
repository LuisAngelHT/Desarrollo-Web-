package Modelo;

import Config.conexion;
import Modelo.Producto;
import Modelo.Categoria;
import Modelo.Inventario;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ProductoClienteDAO {

    private Connection conn;

    public ProductoClienteDAO() {
        conexion conexion = new conexion(); 
        this.conn = conexion.getConnection();
    }

    public boolean agregar(int idCliente, int idInventario, int cantidad) {
        // Verificar si ya existe
        String sqlCheck = "SELECT id_carrito, cantidad FROM Carrito "
                + "WHERE id_cliente = ? AND id_inventario = ?";

        try {
            PreparedStatement psCheck = conn.prepareStatement(sqlCheck);
            psCheck.setInt(1, idCliente);
            psCheck.setInt(2, idInventario);
            ResultSet rs = psCheck.executeQuery();

            if (rs.next()) {
                // Ya existe, actualizar cantidad
                int idCarrito = rs.getInt("id_carrito");
                int cantidadActual = rs.getInt("cantidad");
                return actualizarCantidad(idCarrito, cantidadActual + cantidad);
            } else {
                // Insertar nuevo
                String sqlInsert = "INSERT INTO Carrito (id_cliente, id_inventario, cantidad) "
                        + "VALUES (?, ?, ?)";
                PreparedStatement psInsert = conn.prepareStatement(sqlInsert);
                psInsert.setInt(1, idCliente);
                psInsert.setInt(2, idInventario);
                psInsert.setInt(3, cantidad);
                return psInsert.executeUpdate() > 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Obtiene el carrito completo del cliente
     */
    public List<Carrito> obtenerCarrito(int idCliente) {
        List<Carrito> items = new ArrayList<>();
        String sql = "SELECT c.id_carrito, c.id_cliente, c.id_inventario, c.cantidad, "
                + "c.fecha_agregado, p.nombre, p.precio, p.imagen_url, "
                + "i.talla, i.color, i.stock "
                + "FROM Carrito c "
                + "INNER JOIN Inventario i ON c.id_inventario = i.id_inventario "
                + "INNER JOIN Producto p ON i.id_producto = p.id_producto "
                + "WHERE c.id_cliente = ? AND i.estado = 'activo' "
                + "ORDER BY c.fecha_agregado DESC";

        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, idCliente);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Carrito item = new Carrito();
                item.setIdCarrito(rs.getInt("id_carrito"));
                item.setIdCliente(rs.getInt("id_cliente"));
                item.setIdInventario(rs.getInt("id_inventario"));
                item.setCantidad(rs.getInt("cantidad"));
                item.setFechaAgregado(rs.getTimestamp("fecha_agregado"));
                item.setNombreProducto(rs.getString("nombre"));
                item.setPrecioUnitario(rs.getDouble("precio"));
                item.setImagenUrl(rs.getString("imagen_url"));
                item.setTalla(rs.getString("talla"));
                item.setColor(rs.getString("color"));
                item.setStockDisponible(rs.getInt("stock"));
                items.add(item);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return items;
    }

    /**
     * Actualiza la cantidad de un item
     */
    public boolean actualizarCantidad(int idCarrito, int cantidad) {
        if (cantidad < 1) {
            return eliminar(idCarrito);
        }

        String sql = "UPDATE Carrito SET cantidad = ? WHERE id_carrito = ?";
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, cantidad);
            ps.setInt(2, idCarrito);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Elimina un item del carrito
     */
    public boolean eliminar(int idCarrito) {
        String sql = "DELETE FROM Carrito WHERE id_carrito = ?";
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, idCarrito);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Vacía todo el carrito del cliente
     */
    public boolean vaciar(int idCliente) {
        String sql = "DELETE FROM Carrito WHERE id_cliente = ?";
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, idCliente);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Cuenta items en el carrito
     */
    public int contarItems(int idCliente) {
        String sql = "SELECT COUNT(*) FROM Carrito WHERE id_cliente = ?";
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, idCliente);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * Calcula el total del carrito
     */
    public double calcularTotal(int idCliente) {
        String sql = "SELECT SUM(c.cantidad * p.precio) as total "
                + "FROM Carrito c "
                + "INNER JOIN Inventario i ON c.id_inventario = i.id_inventario "
                + "INNER JOIN Producto p ON i.id_producto = p.id_producto "
                + "WHERE c.id_cliente = ?";
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, idCliente);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getDouble("total");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0.0;
    }

    /**
     * Verifica si hay stock disponible antes de procesar el carrito
     */
    public boolean verificarStock(int idCliente) {
        String sql = "SELECT c.cantidad, i.stock "
                + "FROM Carrito c "
                + "INNER JOIN Inventario i ON c.id_inventario = i.id_inventario "
                + "WHERE c.id_cliente = ?";
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, idCliente);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                int cantidad = rs.getInt("cantidad");
                int stock = rs.getInt("stock");
                if (cantidad > stock) {
                    return false; // No hay suficiente stock
                }
            }
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}
