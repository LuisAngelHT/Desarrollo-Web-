package Modelo;

import Config.conexion;
import java.sql.*;
import java.util.*;
import java.sql.Date; // para SQL

public class ClienteDAO {

    private final conexion conexion = new conexion();

    // Listar clientes atendidos por un vendedor
    public List<Usuarios> listarPorVendedor(int idVendedor) throws Exception {
        String sql = "SELECT DISTINCT u.* FROM Usuario u "
                + "JOIN Venta v ON u.id_usuario = v.id_cliente "
                + "WHERE v.id_vendedor = ? AND u.id_rol = 3";
        Connection cn = conexion.getConnection();
        PreparedStatement ps = cn.prepareStatement(sql);
        ps.setInt(1, idVendedor);
        ResultSet rs = ps.executeQuery();

        List<Usuarios> lista = new ArrayList<>();
        while (rs.next()) {
            lista.add(mapearUsuario(rs));
        }

        rs.close();
        ps.close();
        cn.close();
        return lista;
    }

    // Guardar nuevo cliente
    public void guardar(Usuarios u) throws Exception {
        String sql = "INSERT INTO Usuario (nombre, apellido, email, clave, telefono, direccion, estado, id_rol, fecha_registro) "
                + "VALUES (?, ?, ?, ?, ?, ?, TRUE, 3, CURDATE())";
        Connection cn = conexion.getConnection();
        PreparedStatement ps = cn.prepareStatement(sql);
        ps.setString(1, u.getNombre());
        ps.setString(2, u.getApellido());
        ps.setString(3, u.getCorreo());
        ps.setString(4, u.getContrasena() != null ? u.getContrasena() : "123456");
        ps.setString(5, u.getTelefono());
        ps.setString(6, u.getDireccion());
        ps.executeUpdate();
        ps.close();
        cn.close();
    }

    // Actualizar cliente
    public void actualizar(Usuarios u) throws Exception {
        String sql = "UPDATE Usuario SET nombre = ?, apellido = ?, email = ?, telefono = ?, direccion = ? WHERE id_usuario = ?";
        Connection cn = conexion.getConnection();
        PreparedStatement ps = cn.prepareStatement(sql);
        ps.setString(1, u.getNombre());
        ps.setString(2, u.getApellido());
        ps.setString(3, u.getCorreo());
        ps.setString(4, u.getTelefono());
        ps.setString(5, u.getDireccion());
        ps.setInt(6, u.getIdUsuario());
        ps.executeUpdate();
        ps.close();
        cn.close();
    }

    // Eliminar cliente
    public void eliminar(int idCliente) throws Exception {
        String sql = "DELETE FROM Usuario WHERE id_usuario = ? AND id_rol = 3";
        Connection cn = conexion.getConnection();
        PreparedStatement ps = cn.prepareStatement(sql);
        ps.setInt(1, idCliente);
        ps.executeUpdate();
        ps.close();
        cn.close();
    }

    // Obtener cliente por ID
    public Usuarios obtenerPorId(int idCliente) throws Exception {
        String sql = "SELECT * FROM Usuario WHERE id_usuario = ? AND id_rol = 3";
        Connection cn = conexion.getConnection();
        PreparedStatement ps = cn.prepareStatement(sql);
        ps.setInt(1, idCliente);
        ResultSet rs = ps.executeQuery();

        Usuarios u = null;
        if (rs.next()) {
            u = mapearUsuario(rs);
        }

        rs.close();
        ps.close();
        cn.close();
        return u;
    }

    // Obtener historial de compras
    public List<Venta> obtenerHistorialCompras(int idCliente) throws Exception {
        String sql = "SELECT * FROM Venta WHERE id_cliente = ? ORDER BY fecha_venta DESC";
        Connection cn = conexion.getConnection();
        PreparedStatement ps = cn.prepareStatement(sql);
        ps.setInt(1, idCliente);
        ResultSet rs = ps.executeQuery();

        List<Venta> lista = new ArrayList<>();
        while (rs.next()) {
            Venta v = new Venta();
            v.setIdVenta(rs.getInt("id_venta"));
            v.setFechaVenta(rs.getTimestamp("fecha_venta"));
            v.setTotalFinal(rs.getDouble("total_final"));
            v.setEstado(rs.getBoolean("estado"));
            v.setIdCliente(rs.getInt("id_cliente"));
            v.setIdVendedor(rs.getObject("id_vendedor") != null ? rs.getInt("id_vendedor") : null);
            v.setProductos(obtenerProductosPorVenta(v.getIdVenta()));
            lista.add(v);
        }

        rs.close();
        ps.close();
        cn.close();
        return lista;
    }

    // Obtener productos por venta
    private List<ItemVenta> obtenerProductosPorVenta(int idVenta) throws Exception {
        String sql = "SELECT p.nombre AS nombreProducto, dv.cantidad, dv.precio_unitario_venta "
                + "FROM Detalle_Venta dv "
                + "JOIN Inventario i ON dv.id_inventario = i.id_inventario "
                + "JOIN Producto p ON i.id_producto = p.id_producto "
                + "WHERE dv.id_venta = ?";
        Connection cn = conexion.getConnection();
        PreparedStatement ps = cn.prepareStatement(sql);
        ps.setInt(1, idVenta);
        ResultSet rs = ps.executeQuery();

        List<ItemVenta> productos = new ArrayList<>();
        while (rs.next()) {
            ItemVenta item = new ItemVenta();
            item.setNombreProducto(rs.getString("nombreProducto"));
            item.setCantidad(rs.getInt("cantidad"));
            item.setPrecioUnitario(rs.getDouble("precio_unitario_venta"));
            productos.add(item);
        }

        rs.close();
        ps.close();
        cn.close();
        return productos;
    }

    // Obtener total gastado por cliente
    public double obtenerTotalGastado(int idCliente) throws Exception {
        String sql = "SELECT SUM(total_final) FROM Venta WHERE id_cliente = ?";
        Connection cn = conexion.getConnection();
        PreparedStatement ps = cn.prepareStatement(sql);
        ps.setInt(1, idCliente);
        ResultSet rs = ps.executeQuery();
        double total = rs.next() ? rs.getDouble(1) : 0.0;
        rs.close();
        ps.close();
        cn.close();
        return total;
    }

    // Mapear usuario desde ResultSet
    private Usuarios mapearUsuario(ResultSet rs) throws Exception {
        Usuarios u = new Usuarios();
        u.setIdUsuario(rs.getInt("id_usuario"));
        u.setNombre(rs.getString("nombre"));
        u.setApellido(rs.getString("apellido"));
        u.setCorreo(rs.getString("email"));
        u.setTelefono(rs.getString("telefono"));
        u.setDireccion(rs.getString("direccion"));
        u.setEstado(rs.getBoolean("estado"));
        try {
            u.setFechaRegistro(rs.getDate("fecha_registro"));
        } catch (SQLException e) {
            u.setFechaRegistro(null);
        }
        Rol rol = new Rol();
        rol.setIdRol(3);
        rol.setNombreRol("Cliente");
        u.setRol(rol);
        return u;
    }
}
