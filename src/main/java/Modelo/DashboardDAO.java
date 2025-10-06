package Modelo;

import Config.conexion;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Date;  // ← ESPECÍFICO para SQL
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class DashboardDAO {

    // Total de productos activos
    public int getTotalProductos() throws Exception {
        String sql = "SELECT COUNT(DISTINCT p.id_producto) "
                + "FROM producto p "
                + "JOIN inventario i ON p.id_producto = i.id_producto "
                + "WHERE i.estado = 'Activo'";

        try (Connection cn = conexion.getConnection(); PreparedStatement ps = cn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            return rs.next() ? rs.getInt(1) : 0;
        }
    }

    // Ventas de hoy
    public int getVentasHoy() throws Exception {
        String sql = "SELECT COUNT(*) FROM venta WHERE DATE(fecha_venta) = CURDATE()";

        try (Connection cn = conexion.getConnection(); PreparedStatement ps = cn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            return rs.next() ? rs.getInt(1) : 0;
        }
    }

    // Ingresos de hoy
    public double getIngresosHoy() throws Exception {
        String sql = "SELECT COALESCE(SUM(total_final), 0) FROM venta "
                + "WHERE DATE(fecha_venta) = CURDATE() AND estado = 1";

        try (Connection cn = conexion.getConnection(); PreparedStatement ps = cn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            return rs.next() ? rs.getDouble(1) : 0.0;
        }
    }

    // Total de clientes (rol 3)
    public int getTotalClientes() throws Exception {
        String sql = "SELECT COUNT(*) FROM usuario WHERE id_rol = 3";

        try (Connection cn = conexion.getConnection(); PreparedStatement ps = cn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            return rs.next() ? rs.getInt(1) : 0;
        }
    }

    // Inventario con stock bajo (<=5)
    public int getInventarioBajo() throws Exception {
        String sql = "SELECT COUNT(*) FROM inventario WHERE stock <= 5 AND estado = 'Activo'";

        try (Connection cn = conexion.getConnection(); PreparedStatement ps = cn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            return rs.next() ? rs.getInt(1) : 0;
        }
    }

    // Ventas por día de la semana (últimos 7 días)
    public List<Integer> getVentasPorDiaSemana() throws Exception {
        String sql = "SELECT DAYOFWEEK(fecha_venta) AS dia, COUNT(*) AS total "
                + "FROM venta "
                + "WHERE fecha_venta >= DATE_SUB(CURDATE(), INTERVAL 7 DAY) "
                + "GROUP BY DAYOFWEEK(fecha_venta) "
                + "ORDER BY dia";

        int[] dias = new int[7]; // Domingo=0, Lunes=1, ..., Sábado=6

        try (Connection cn = conexion.getConnection(); PreparedStatement ps = cn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                int dia = rs.getInt("dia") - 1; // MySQL: 1=Domingo, convertir a 0=Domingo
                dias[dia] = rs.getInt("total");
            }
        }

        List<Integer> resultado = new ArrayList<>();
        for (int total : dias) {
            resultado.add(total);
        }
        return resultado;
    }

    // Últimas ventas
    public List<Map<String, Object>> getUltimasVentas(int limite) throws Exception {
        String sql = "SELECT v.id_venta, v.fecha_venta, "
                + "CONCAT(u.nombre, ' ', u.apellido) AS nombreCliente, "
                + "p.nombre AS nombreProducto, "
                + "v.estado "
                + "FROM venta v "
                + "JOIN usuario u ON v.id_cliente = u.id_usuario "
                + "LEFT JOIN detalle_venta dv ON v.id_venta = dv.id_venta "
                + "LEFT JOIN inventario i ON dv.id_inventario = i.id_inventario "
                + "LEFT JOIN producto p ON i.id_producto = p.id_producto "
                + "ORDER BY v.fecha_venta DESC LIMIT ?";

        List<Map<String, Object>> lista = new ArrayList<>();

        try (Connection cn = conexion.getConnection(); PreparedStatement ps = cn.prepareStatement(sql)) {

            ps.setInt(1, limite);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Map<String, Object> fila = new HashMap<>();
                fila.put("fecha", rs.getTimestamp("fecha_venta"));
                fila.put("nombreCliente", rs.getString("nombreCliente"));
                fila.put("nombreProducto", rs.getString("nombreProducto") != null
                        ? rs.getString("nombreProducto") : "Sin productos");
                fila.put("estado", rs.getBoolean("estado") ? "Confirmada" : "Pendiente");
                lista.add(fila);
            }
        }
        return lista;
    }

    public List<Map<String, Object>> getClientesRecientes(int limite) throws Exception {
        String sql = "SELECT nombre, apellido, email, estado "
                + "FROM usuario WHERE id_rol = 3 "
                + "ORDER BY id_usuario DESC LIMIT ?";

        List<Map<String, Object>> lista = new ArrayList<>();

        try (Connection cn = conexion.getConnection(); PreparedStatement ps = cn.prepareStatement(sql)) {

            ps.setInt(1, limite);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Map<String, Object> fila = new HashMap<>();
                fila.put("nombre", rs.getString("nombre"));
                fila.put("apellido", rs.getString("apellido"));
                fila.put("email", rs.getString("email"));
                fila.put("estado", rs.getBoolean("estado") ? "Activo" : "Inactivo");
                lista.add(fila);
            }
        }
        return lista;
    }
}
