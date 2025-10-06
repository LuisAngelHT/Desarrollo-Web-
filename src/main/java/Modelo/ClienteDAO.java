package Modelo;

import Config.conexion;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ClienteDAO {

    public List<Cliente> listarClientes() throws Exception {
        List<Cliente> lista = new ArrayList<>();
        String sql = "SELECT id_usuario, nombre, apellido, email, telefono, direccion, estado, id_rol "
                + "FROM usuario WHERE id_rol = 3 ORDER BY id_usuario DESC";

        try (Connection cn = conexion.getConnection(); PreparedStatement ps = cn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Cliente c = new Cliente();
                c.setIdUsuario(rs.getInt("id_usuario"));
                c.setNombre(rs.getString("nombre"));
                c.setApellido(rs.getString("apellido"));
                c.setEmail(rs.getString("email"));
                c.setTelefono(rs.getString("telefono"));
                c.setDireccion(rs.getString("direccion"));
                c.setEstado(rs.getBoolean("estado"));
                c.setIdRol(rs.getInt("id_rol"));
                lista.add(c);
            }
        }
        return lista;
    }

    public Cliente obtenerPorId(int idUsuario) throws Exception {
        String sql = "SELECT id_usuario, nombre, apellido, email, telefono, direccion, estado, id_rol "
                + "FROM usuario WHERE id_usuario = ?";

        try (Connection cn = conexion.getConnection(); PreparedStatement ps = cn.prepareStatement(sql)) {

            ps.setInt(1, idUsuario);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                Cliente c = new Cliente();
                c.setIdUsuario(rs.getInt("id_usuario"));
                c.setNombre(rs.getString("nombre"));
                c.setApellido(rs.getString("apellido"));
                c.setEmail(rs.getString("email"));
                c.setTelefono(rs.getString("telefono"));
                c.setDireccion(rs.getString("direccion"));
                c.setEstado(rs.getBoolean("estado"));
                c.setIdRol(rs.getInt("id_rol"));
                return c;
            }
        }
        return null;
    }

    public int contarClientes() throws Exception {
        String sql = "SELECT COUNT(*) FROM usuario WHERE id_rol = 3";

        try (Connection cn = conexion.getConnection(); PreparedStatement ps = cn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }

    public List<Venta> obtenerHistorialCompras(int idCliente) throws Exception {
        List<Venta> historial = new ArrayList<>();
        String sql = "SELECT id_venta, fecha_venta, total_final, estado "
                + "FROM venta WHERE id_cliente = ? ORDER BY fecha_venta DESC";

        try (Connection cn = conexion.getConnection(); PreparedStatement ps = cn.prepareStatement(sql)) {

            ps.setInt(1, idCliente);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Venta venta = new Venta();
                venta.setIdVenta(rs.getInt("id_venta"));
                venta.setFechaVenta(rs.getTimestamp("fecha_venta"));
                venta.setTotalFinal(rs.getDouble("total_final"));
                venta.setEstado(rs.getBoolean("estado"));

                // Obtener productos de esta venta
                venta.setProductos(obtenerDetalleVenta(venta.getIdVenta()));

                historial.add(venta);
            }
        }
        return historial;
    }

    private List<ItemVenta> obtenerDetalleVenta(int idVenta) throws Exception {
        List<ItemVenta> items = new ArrayList<>();
        String sql = "SELECT dv.cantidad, dv.precio_unitario_venta, p.nombre AS nombreProducto "
                + "FROM detalle_venta dv "
                + "JOIN inventario i ON dv.id_inventario = i.id_inventario "
                + "JOIN producto p ON i.id_producto = p.id_producto "
                + "WHERE dv.id_venta = ?";

        try (Connection cn = conexion.getConnection(); PreparedStatement ps = cn.prepareStatement(sql)) {

            ps.setInt(1, idVenta);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                ItemVenta item = new ItemVenta();
                item.setNombreProducto(rs.getString("nombreProducto"));
                item.setCantidad(rs.getInt("cantidad"));
                item.setPrecioUnitario(rs.getDouble("precio_unitario_venta"));
                items.add(item);
            }
        }
        return items;
    }

    public double obtenerTotalGastado(int idCliente) throws Exception {
        String sql = "SELECT COALESCE(SUM(total_final), 0) AS total "
                + "FROM venta WHERE id_cliente = ? AND estado = 1";

        try (Connection cn = conexion.getConnection(); PreparedStatement ps = cn.prepareStatement(sql)) {

            ps.setInt(1, idCliente);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getDouble("total");
            }
        }
        return 0.0;
    }
}
