package Modelo;

import java.sql.Date; // para SQL
import Config.conexion;
import java.sql.*;
import java.time.LocalDate;
import java.util.*;

public class DashboardDAO {

    public int getTotalProductos() throws Exception {
        String sql = "SELECT COUNT(*) FROM producto";
        Connection cn = conexion.getConnection();
        PreparedStatement ps = cn.prepareStatement(sql);
        ResultSet rs = ps.executeQuery();
        int total = rs.next() ? rs.getInt(1) : 0;
        rs.close(); ps.close(); cn.close();
        return total;
    }

    public int getVentasHoy() throws Exception {
        String sql = "SELECT COUNT(*) FROM venta WHERE DATE(fecha_venta) = CURDATE()";
        Connection cn = conexion.getConnection();
        PreparedStatement ps = cn.prepareStatement(sql);
        ResultSet rs = ps.executeQuery();
        int total = rs.next() ? rs.getInt(1) : 0;
        rs.close(); ps.close(); cn.close();
        return total;
    }

    public double getIngresosHoy() throws Exception {
        String sql = "SELECT SUM(total_final) FROM venta WHERE DATE(fecha_venta) = CURDATE()";
        Connection cn = conexion.getConnection();
        PreparedStatement ps = cn.prepareStatement(sql);
        ResultSet rs = ps.executeQuery();
        double total = rs.next() ? rs.getDouble(1) : 0.0;
        rs.close(); ps.close(); cn.close();
        return total;
    }

    public int getTotalClientes() throws Exception {
        String sql = "SELECT COUNT(*) FROM usuario WHERE id_rol = 3"; // rol cliente
        Connection cn = conexion.getConnection();
        PreparedStatement ps = cn.prepareStatement(sql);
        ResultSet rs = ps.executeQuery();
        int total = rs.next() ? rs.getInt(1) : 0;
        rs.close(); ps.close(); cn.close();
        return total;
    }

    public int getInventarioBajo() throws Exception {
        String sql = "SELECT COUNT(*) FROM inventario WHERE stock <= 5 AND estado = TRUE";
        Connection cn = conexion.getConnection();
        PreparedStatement ps = cn.prepareStatement(sql);
        ResultSet rs = ps.executeQuery();
        int total = rs.next() ? rs.getInt(1) : 0;
        rs.close(); ps.close(); cn.close();
        return total;
    }

    public List<Integer> getVentasPorDiaSemana() throws Exception {
        String sql = "SELECT DAYOFWEEK(fecha_venta) AS dia, COUNT(*) AS total " +
                     "FROM venta WHERE fecha_venta >= DATE_SUB(CURDATE(), INTERVAL 7 DAY) GROUP BY dia";
        int[] dias = new int[7]; // Domingo = 1, Sábado = 7
        Connection cn = conexion.getConnection();
        PreparedStatement ps = cn.prepareStatement(sql);
        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            int dia = rs.getInt("dia") - 1;
            dias[dia] = rs.getInt("total");
        }
        rs.close(); ps.close(); cn.close();
        List<Integer> resultado = new ArrayList<>();
        for (int total : dias) resultado.add(total);
        return resultado;
    }

    public int getVentasEntreFechas(LocalDate desde, LocalDate hasta) throws Exception {
        String sql = "SELECT COUNT(*) FROM venta WHERE DATE(fecha_venta) BETWEEN ? AND ?";
        Connection cn = conexion.getConnection();
        PreparedStatement ps = cn.prepareStatement(sql);
        ps.setDate(1, Date.valueOf(desde));
        ps.setDate(2, Date.valueOf(hasta));
        ResultSet rs = ps.executeQuery();
        int total = rs.next() ? rs.getInt(1) : 0;
        rs.close(); ps.close(); cn.close();
        return total;
    }

    public double getIngresosEntreFechas(LocalDate desde, LocalDate hasta) throws Exception {
        String sql = "SELECT SUM(total_final) FROM venta WHERE DATE(fecha_venta) BETWEEN ? AND ?";
        Connection cn = conexion.getConnection();
        PreparedStatement ps = cn.prepareStatement(sql);
        ps.setDate(1, Date.valueOf(desde));
        ps.setDate(2, Date.valueOf(hasta));
        ResultSet rs = ps.executeQuery();
        double total = rs.next() ? rs.getDouble(1) : 0.0;
        rs.close(); ps.close(); cn.close();
        return total;
    }

    public List<Map<String, Object>> getProductosMasVendidosEntreFechas(LocalDate desde, LocalDate hasta) throws Exception {
        String sql = "SELECT p.nombre, SUM(dv.cantidad) AS cantidad " +
                     "FROM detalle_venta dv " +
                     "JOIN inventario i ON dv.id_inventario = i.id_inventario " +
                     "JOIN producto p ON i.id_producto = p.id_producto " +
                     "JOIN venta v ON dv.id_venta = v.id_venta " +
                     "WHERE DATE(v.fecha_venta) BETWEEN ? AND ? " +
                     "GROUP BY p.nombre ORDER BY cantidad DESC LIMIT 5";
        List<Map<String, Object>> lista = new ArrayList<>();
        Connection cn = conexion.getConnection();
        PreparedStatement ps = cn.prepareStatement(sql);
        ps.setDate(1, Date.valueOf(desde));
        ps.setDate(2, Date.valueOf(hasta));
        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            Map<String, Object> fila = new HashMap<>();
            fila.put("nombre", rs.getString("nombre"));
            fila.put("cantidad", rs.getInt("cantidad"));
            lista.add(fila);
        }
        rs.close(); ps.close(); cn.close();
        return lista;
    }

    public List<Map<String, Object>> getClientesNuevosEntreFechas(LocalDate desde, LocalDate hasta) throws Exception {
        String sql = "SELECT nombre, apellido, email, estado FROM usuario " +
                     "WHERE id_rol = 2 AND DATE(fecha_registro) BETWEEN ? AND ?";
        List<Map<String, Object>> lista = new ArrayList<>();
        Connection cn = conexion.getConnection();
        PreparedStatement ps = cn.prepareStatement(sql);
        ps.setDate(1, Date.valueOf(desde));
        ps.setDate(2, Date.valueOf(hasta));
        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            Map<String, Object> fila = new HashMap<>();
            fila.put("nombre", rs.getString("nombre"));
            fila.put("apellido", rs.getString("apellido"));
            fila.put("email", rs.getString("email"));
            fila.put("estado", rs.getBoolean("estado") ? "Activo" : "Inactivo");
            lista.add(fila);
        }
        rs.close(); ps.close(); cn.close();
        return lista;
    }

    public List<Map<String, Object>> getUltimasVentas(int limite) throws Exception {
        String sql = "SELECT v.fecha_venta, u.nombre AS nombreCliente, p.nombre AS nombreProducto, " +
                     "CASE WHEN v.estado THEN 'Confirmada' ELSE 'Pendiente' END AS estado " +
                     "FROM venta v " +
                     "JOIN usuario u ON v.id_cliente = u.id_usuario " +
                     "JOIN detalle_venta dv ON v.id_venta = dv.id_venta " +
                     "JOIN inventario i ON dv.id_inventario = i.id_inventario " +
                     "JOIN producto p ON i.id_producto = p.id_producto " +
                     "ORDER BY v.fecha_venta DESC LIMIT ?";
        List<Map<String, Object>> lista = new ArrayList<>();
        Connection cn = conexion.getConnection();
        PreparedStatement ps = cn.prepareStatement(sql);
        ps.setInt(1, limite);
        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            Map<String, Object> fila = new HashMap<>();
            fila.put("fecha", rs.getTimestamp("fecha_venta"));
            fila.put("nombreCliente", rs.getString("nombreCliente"));
            fila.put("nombreProducto", rs.getString("nombreProducto"));
            fila.put("estado", rs.getString("estado"));
            lista.add(fila);
        }
        rs.close(); ps.close(); cn.close();
        return lista;
    }
}
