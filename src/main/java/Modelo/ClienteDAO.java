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
                rs.close();
                return c;
            }
            rs.close();
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
            rs.close();
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
            rs.close();
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
                double total = rs.getDouble("total");
                rs.close();
                return total;
            }
            rs.close();
        }
        return 0.0;
    }

    public List<Cliente> listarClientesPaginado(int pagina, int registrosPorPagina) throws Exception {
        List<Cliente> lista = new ArrayList<>();
        int offset = (pagina - 1) * registrosPorPagina;

        String sql = "SELECT id_usuario, nombre, apellido, email, telefono, direccion, estado, id_rol "
                + "FROM usuario WHERE id_rol = 3 ORDER BY id_usuario DESC "
                + "LIMIT ? OFFSET ?";

        try (Connection cn = conexion.getConnection(); PreparedStatement ps = cn.prepareStatement(sql)) {

            ps.setInt(1, registrosPorPagina);
            ps.setInt(2, offset);
            ResultSet rs = ps.executeQuery();

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
            rs.close();
        }
        return lista;
    }

    public List<Cliente> buscarClientesPaginado(String termino, int pagina, int registrosPorPagina) throws Exception {
        List<Cliente> lista = new ArrayList<>();
        int offset = (pagina - 1) * registrosPorPagina;

        String sql = "SELECT id_usuario, nombre, apellido, email, telefono, direccion, estado, id_rol "
                + "FROM usuario WHERE id_rol = 3 "
                + "AND (LOWER(nombre) LIKE LOWER(?) OR LOWER(apellido) LIKE LOWER(?) OR LOWER(email) LIKE LOWER(?)) "
                + "ORDER BY id_usuario DESC "
                + "LIMIT ? OFFSET ?";

        try (Connection cn = conexion.getConnection(); PreparedStatement ps = cn.prepareStatement(sql)) {

            String patron = "%" + termino + "%";
            ps.setString(1, patron);
            ps.setString(2, patron);
            ps.setString(3, patron);
            ps.setInt(4, registrosPorPagina);
            ps.setInt(5, offset);

            ResultSet rs = ps.executeQuery();

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
            rs.close();
        }
        return lista;
    }

    public int contarClientesBusqueda(String termino) throws Exception {
        String sql = "SELECT COUNT(*) FROM usuario WHERE id_rol = 3 "
                + "AND (LOWER(nombre) LIKE LOWER(?) OR LOWER(apellido) LIKE LOWER(?) OR LOWER(email) LIKE LOWER(?))";

        try (Connection cn = conexion.getConnection(); PreparedStatement ps = cn.prepareStatement(sql)) {

            String patron = "%" + termino + "%";
            ps.setString(1, patron);
            ps.setString(2, patron);
            ps.setString(3, patron);

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
            rs.close();
        }
        return 0;
    }

    // AGREGAR ESTOS MÉTODOS A TU ClienteDAO EXISTENTE
    /**
     * Cuenta el total de compras realizadas por un cliente
     */
    public int contarComprasCliente(int idCliente) throws Exception {
        String sql = "SELECT COUNT(*) FROM venta WHERE id_cliente = ? AND estado = 1";

        try (Connection cn = conexion.getConnection(); PreparedStatement ps = cn.prepareStatement(sql)) {

            ps.setInt(1, idCliente);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                int total = rs.getInt(1);
                rs.close();
                return total;
            }
            rs.close();
        }
        return 0;
    }

    /**
     * Obtiene la última compra realizada por un cliente
     */
    public Venta obtenerUltimaCompra(int idCliente) throws Exception {
        String sql = "SELECT id_venta, fecha_venta, total_final, estado, id_cliente, id_vendedor "
                + "FROM venta WHERE id_cliente = ? AND estado = 1 "
                + "ORDER BY fecha_venta DESC LIMIT 1";

        try (Connection cn = conexion.getConnection(); PreparedStatement ps = cn.prepareStatement(sql)) {

            ps.setInt(1, idCliente);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                Venta venta = new Venta();
                venta.setIdVenta(rs.getInt("id_venta"));
                venta.setFechaVenta(rs.getTimestamp("fecha_venta"));
                venta.setTotalFinal(rs.getDouble("total_final"));
                venta.setEstado(rs.getBoolean("estado"));
                venta.setIdCliente(rs.getInt("id_cliente"));

                // Manejar id_vendedor que puede ser null
                Integer idVendedor = rs.getObject("id_vendedor", Integer.class);
                venta.setIdVendedor(idVendedor);

                rs.close();
                return venta;
            }
            rs.close();
        }
        return null;
    }

    /**
     * Obtiene los productos más comprados por un cliente
     *
     * @param idCliente ID del cliente
     * @param limite Cantidad de productos a retornar
     */
    public List<ProductoComprado> obtenerTopProductos(int idCliente, int limite) throws Exception {
        List<ProductoComprado> lista = new ArrayList<>();

        String sql = "SELECT "
                + "  p.id_producto, "
                + "  p.nombre AS nombre_producto, "
                + "  COALESCE(c.nombre_categoria, 'Sin categoría') AS categoria_nombre, "
                + "  SUM(dv.cantidad) AS cantidad_total, "
                + "  SUM(dv.cantidad * dv.precio_unitario_venta) AS total_gastado "
                + "FROM detalle_venta dv "
                + "INNER JOIN inventario i ON dv.id_inventario = i.id_inventario "
                + "INNER JOIN producto p ON i.id_producto = p.id_producto "
                + "LEFT JOIN categoria c ON p.id_categoria = c.id_categoria "
                + "INNER JOIN venta v ON dv.id_venta = v.id_venta "
                + "WHERE v.id_cliente = ? AND v.estado = 1 "
                + "GROUP BY p.id_producto, p.nombre, c.nombre_categoria "
                + "ORDER BY cantidad_total DESC "
                + "LIMIT ?";

        try (Connection cn = conexion.getConnection(); PreparedStatement ps = cn.prepareStatement(sql)) {

            ps.setInt(1, idCliente);
            ps.setInt(2, limite);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                ProductoComprado pc = new ProductoComprado();
                pc.setIdProducto(rs.getInt("id_producto"));
                pc.setNombreProducto(rs.getString("nombre_producto"));
                pc.setCategoria(rs.getString("categoria_nombre"));
                pc.setCantidadComprada(rs.getInt("cantidad_total"));
                pc.setTotalGastado(rs.getDouble("total_gastado"));

                lista.add(pc);
            }
            rs.close();
        } catch (Exception e) {
            System.err.println("Error en obtenerTopProductos: " + e.getMessage());
            e.printStackTrace();
        }

        return lista;
    }

    /**
     * Cambia el estado de un cliente (activo/inactivo)
     */
    public boolean cambiarEstado(int idCliente, boolean nuevoEstado) throws Exception {
        String sql = "UPDATE usuario SET estado = ? WHERE id_usuario = ? AND id_rol = 3";

        try (Connection cn = conexion.getConnection(); PreparedStatement ps = cn.prepareStatement(sql)) {

            ps.setBoolean(1, nuevoEstado);
            ps.setInt(2, idCliente);

            int filasAfectadas = ps.executeUpdate();
            return filasAfectadas > 0;
        }
    }

}
