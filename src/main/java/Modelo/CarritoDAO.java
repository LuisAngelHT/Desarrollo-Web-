// ========================================
// CARRITO DAO - SIMPLIFICADO
// ========================================
package Modelo;

import Config.conexion;
import Modelo.Carrito;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CarritoDAO {

    private Connection connection;

    public CarritoDAO() {
        this.connection = conexion.getConnection();
    }

    /**
     * Agrega producto al carrito
     */
    public boolean agregarAlCarrito(int idCliente, int idInventario, int cantidad) {
        // Verificar si ya existe
        String sqlCheck = "SELECT id_carrito, cantidad FROM Carrito "
                + "WHERE id_cliente = ? AND id_inventario = ?";

        try (PreparedStatement psCheck = connection.prepareStatement(sqlCheck)) {
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
                try (PreparedStatement psInsert = connection.prepareStatement(sqlInsert)) {
                    psInsert.setInt(1, idCliente);
                    psInsert.setInt(2, idInventario);
                    psInsert.setInt(3, cantidad);
                    return psInsert.executeUpdate() > 0;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Obtiene el carrito del cliente con toda la info del producto
     */
    public List<Carrito> obtenerCarritoCliente(int idCliente) {
        List<Carrito> items = new ArrayList<>();
        String sql = "SELECT c.id_carrito, c.id_cliente, c.id_inventario, c.cantidad, "
                + "c.fecha_agregado, p.nombre, p.precio, p.imagen_url, "
                + "i.talla, i.color, i.stock "
                + "FROM Carrito c "
                + "INNER JOIN Inventario i ON c.id_inventario = i.id_inventario "
                + "INNER JOIN Producto p ON i.id_producto = p.id_producto "
                + "WHERE c.id_cliente = ? AND i.estado = 'activo' "
                + "ORDER BY c.fecha_agregado DESC";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, idCliente);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Carrito item = new Carrito();
                item.setIdCarrito(rs.getInt("id_carrito"));
                item.setIdCliente(rs.getInt("id_cliente"));
                item.setIdInventario(rs.getInt("id_inventario"));
                item.setCantidad(rs.getInt("cantidad"));
                item.setFechaAgregado(rs.getTimestamp("fecha_agregado"));

                // Info del producto
                item.setNombreProducto(rs.getString("nombre"));
                item.setPrecioUnitario(rs.getDouble("precio"));
                item.setImagenUrl(rs.getString("imagen_url"));
                item.setTalla(rs.getString("talla"));
                item.setColor(rs.getString("color"));
                item.setStockDisponible(rs.getInt("stock"));

                items.add(item);

                // DEBUG: Imprimir cada item encontrado
                System.out.println("Item encontrado: " + item.getNombreProducto() + " - Cantidad: " + item.getCantidad());
            }

            System.out.println("Total items recuperados: " + items.size());

        } catch (SQLException e) {
            System.err.println("❌ ERROR en obtenerCarritoCliente:");
            e.printStackTrace();
        }

        return items;
    }

    /**
     * Actualiza cantidad de un item
     */
    public boolean actualizarCantidad(int idCarrito, int nuevaCantidad) {
        if (nuevaCantidad < 1) {
            return eliminarItem(idCarrito);
        }

        String sql = "UPDATE Carrito SET cantidad = ? WHERE id_carrito = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, nuevaCantidad);
            ps.setInt(2, idCarrito);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Elimina un item del carrito
     */
    public boolean eliminarItem(int idCarrito) {
        String sql = "DELETE FROM Carrito WHERE id_carrito = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, idCarrito);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Vacía el carrito de un cliente
     */
    public boolean vaciarCarrito(int idCliente) {
        String sql = "DELETE FROM Carrito WHERE id_cliente = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, idCliente);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Cuenta items en el carrito
     */
    public int contarItemsCarrito(int idCliente) {
        String sql = "SELECT COUNT(*) FROM Carrito WHERE id_cliente = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, idCliente);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return 0;
    }

    /**
     * Calcula el total del carrito
     */
    public double calcularTotalCarrito(int idCliente) {
        String sql = "SELECT SUM(c.cantidad * p.precio) as total "
                + "FROM Carrito c "
                + "INNER JOIN Inventario i ON c.id_inventario = i.id_inventario "
                + "INNER JOIN Producto p ON i.id_producto = p.id_producto "
                + "WHERE c.id_cliente = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, idCliente);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getDouble("total");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return 0.0;
    }
    public Carrito obtenerItemPorId(int idCarrito) {
    String sql = "SELECT * FROM Carrito WHERE id_carrito = ?";
    
    try (PreparedStatement ps = connection.prepareStatement(sql)) {
        ps.setInt(1, idCarrito);
        ResultSet rs = ps.executeQuery();
        
        if (rs.next()) {
            Carrito item = new Carrito();
            item.setIdCarrito(rs.getInt("id_carrito"));
            item.setIdCliente(rs.getInt("id_cliente"));
            item.setIdInventario(rs.getInt("id_inventario"));
            item.setCantidad(rs.getInt("cantidad"));
            return item;
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return null;
}
}
