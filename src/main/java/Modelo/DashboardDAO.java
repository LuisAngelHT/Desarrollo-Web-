package Modelo;

import Config.conexion;
import java.sql.*;
import java.util.*;

public class DashboardDAO {

    public int getTotalProductos() throws Exception {
        String sql = "SELECT COUNT(*) FROM producto";
        try (Connection cn = conexion.getConnection(); PreparedStatement ps = cn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            return rs.next() ? rs.getInt(1) : 0;
        }
    }

    public int getVentasHoy() throws Exception {
        String sql = "SELECT COUNT(*) FROM venta WHERE DATE(fecha) = CURDATE()";
        try (Connection cn = conexion.getConnection(); PreparedStatement ps = cn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            return rs.next() ? rs.getInt(1) : 0;
        }
    }

    public int getTotalClientes() throws Exception {
        String sql = "SELECT COUNT(*) FROM cliente";
        try (Connection cn = conexion.getConnection(); PreparedStatement ps = cn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            return rs.next() ? rs.getInt(1) : 0;
        }
    }

    public int getInventarioBajo() throws Exception {
        String sql = "SELECT COUNT(*) FROM inventario WHERE stock <= 5";
        try (Connection cn = conexion.getConnection(); PreparedStatement ps = cn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            return rs.next() ? rs.getInt(1) : 0;
        }
    }

    public List<Integer> getVentasPorDiaSemana() throws Exception {
        String sql = "SELECT DAYOFWEEK(fecha) AS dia, COUNT(*) AS total FROM venta "
                + "WHERE fecha >= DATE_SUB(CURDATE(), INTERVAL 7 DAY) GROUP BY dia";
        List<Integer> ventas = Arrays.asList(0, 0, 0, 0, 0, 0, 0); // Dom a Sáb
        try (Connection cn = conexion.getConnection(); PreparedStatement ps = cn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                int dia = rs.getInt("dia") - 1; // DAYOFWEEK: 1=Dom, 2=Lun...
                int total = rs.getInt("total");
                ventas.set(dia, total);
            }
        }
        return ventas;
    }
}
