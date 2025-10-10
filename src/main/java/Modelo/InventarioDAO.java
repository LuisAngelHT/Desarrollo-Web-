package Modelo;

import Config.conexion;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class InventarioDAO {

    public List<Inventario> listarPorProducto(int idProducto) throws Exception {
        List<Inventario> lista = new ArrayList<>();
        String sql = "SELECT * FROM Inventario WHERE id_producto = ? ORDER BY id_inventario DESC";

        try (Connection cn = conexion.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            
            ps.setInt(1, idProducto);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Inventario inv = new Inventario();
                inv.setIdInventario(rs.getInt("id_inventario"));
                inv.setIdProducto(rs.getInt("id_producto"));
                inv.setTalla(rs.getString("talla"));
                inv.setColor(rs.getString("color"));
                inv.setStock(rs.getInt("stock"));
                inv.setEstado(rs.getString("estado"));
                lista.add(inv);
            }
            rs.close();
        }
        return lista;
    }
    
    public void insertar(Inventario inv) throws Exception {
        String sql = "INSERT INTO Inventario (id_producto, talla, color, stock, estado) VALUES (?, ?, ?, ?, ?)";
        
        try (Connection cn = conexion.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            
            ps.setInt(1, inv.getIdProducto());
            ps.setString(2, inv.getTalla());
            ps.setString(3, inv.getColor());
            ps.setInt(4, inv.getStock());
            ps.setString(5, inv.getEstado());
            ps.executeUpdate();
        }
    }

    public void actualizar(Inventario inv) throws Exception {
        String sql = "UPDATE Inventario SET talla=?, color=?, stock=?, estado=? WHERE id_inventario=?";
        
        try (Connection cn = conexion.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            
            ps.setString(1, inv.getTalla());
            ps.setString(2, inv.getColor());
            ps.setInt(3, inv.getStock());
            ps.setString(4, inv.getEstado());
            ps.setInt(5, inv.getIdInventario());
            ps.executeUpdate();
        }
    }

    public void eliminar(int idInventario) throws Exception {
        String sql = "DELETE FROM Inventario WHERE id_inventario=?";
        
        try (Connection cn = conexion.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            
            ps.setInt(1, idInventario);
            ps.executeUpdate();
        }
    }

    public boolean existeCombinacion(int idProducto, String talla, String color) {
        String sql = "SELECT COUNT(*) FROM Inventario WHERE id_producto = ? AND talla = ? AND color = ?";
        
        try (Connection con = conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, idProducto);
            ps.setString(2, talla.trim());
            ps.setString(3, color.trim());
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean existeCombinacionDuplicada(int idProducto, String talla, String color, int idInventarioActual) {
        String sql = "SELECT COUNT(*) FROM Inventario WHERE id_producto = ? AND talla = ? AND color = ? AND id_inventario != ?";
        
        try (Connection con = conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, idProducto);
            ps.setString(2, talla.trim());
            ps.setString(3, color.trim());
            ps.setInt(4, idInventarioActual);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Elimina todas las combinaciones de un producto
     * @param idProducto ID del producto
     * @return Cantidad de registros eliminados
     */
    public int eliminarPorProducto(int idProducto) throws Exception {
        String sql = "DELETE FROM Inventario WHERE id_producto = ?";
        
        try (Connection cn = conexion.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            
            ps.setInt(1, idProducto);
            return ps.executeUpdate(); // RETORNA cantidad de filas afectadas
        }
    }

    /**
     * Obtiene la última combinación registrada de un producto
     * @param idProducto ID del producto
     * @return Inventario o null si no existe
     */
    public Inventario obtenerUltimaPorProducto(int idProducto) throws Exception {
        String sql = "SELECT * FROM Inventario WHERE id_producto = ? ORDER BY id_inventario DESC LIMIT 1";
        
        try (Connection cn = conexion.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            
            ps.setInt(1, idProducto);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                Inventario inv = new Inventario();
                inv.setIdInventario(rs.getInt("id_inventario"));
                inv.setIdProducto(rs.getInt("id_producto"));
                inv.setTalla(rs.getString("talla"));
                inv.setColor(rs.getString("color"));
                inv.setStock(rs.getInt("stock"));
                inv.setEstado(rs.getString("estado"));
                return inv;
            }
        }
        return null;
    }

    /**
     * Cuenta el total de combinaciones de un producto
     * @param idProducto ID del producto
     * @return Cantidad total de combinaciones
     */
    public int contarPorProducto(int idProducto) throws Exception {
        String sql = "SELECT COUNT(*) FROM Inventario WHERE id_producto = ?";
        
        try (Connection cn = conexion.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            
            ps.setInt(1, idProducto);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }
    
    /**
     * Obtiene un inventario por ID
     */
    public Inventario obtenerPorId(int idInventario) {
        String sql = "SELECT * FROM Inventario WHERE id_inventario = ?";
        
        try (Connection cn = conexion.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, idInventario);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                Inventario inv = new Inventario();
                inv.setIdInventario(rs.getInt("id_inventario"));
                inv.setIdProducto(rs.getInt("id_producto"));
                inv.setTalla(rs.getString("talla"));
                inv.setColor(rs.getString("color"));
                inv.setStock(rs.getInt("stock"));
                inv.setEstado(rs.getString("estado"));
                return inv;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    /**
     * Reduce el stock de un inventario
     */
    public boolean reducirStock(int idInventario, int cantidad) {
        String sql = "UPDATE Inventario SET stock = stock - ? WHERE id_inventario = ? AND stock >= ?";
        
        try (Connection cn = conexion.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, cantidad);
            ps.setInt(2, idInventario);
            ps.setInt(3, cantidad);
            
            int filasActualizadas = ps.executeUpdate();
            return filasActualizadas > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Aumenta el stock de un inventario (para cuando se elimine del carrito)
     */
    public boolean aumentarStock(int idInventario, int cantidad) {
        String sql = "UPDATE Inventario SET stock = stock + ? WHERE id_inventario = ?";
        
        try (Connection cn = conexion.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, cantidad);
            ps.setInt(2, idInventario);
            
            return ps.executeUpdate() > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}