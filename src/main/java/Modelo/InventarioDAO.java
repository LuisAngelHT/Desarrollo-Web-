package Modelo;

import Config.conexion;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class InventarioDAO {

    public List<Inventario> listarPorProducto(int idProducto) throws Exception {
        List<Inventario> lista = new ArrayList<>();
        String sql = "SELECT * FROM Inventario WHERE id_producto = ?";

        Connection cn = conexion.getConnection();
        PreparedStatement ps = cn.prepareStatement(sql);
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
        ps.close();
        cn.close();
        return lista;
    }

    public void insertar(Inventario inv) throws Exception {
        String sql = "INSERT INTO Inventario (id_producto, talla, color, stock, estado) VALUES (?, ?, ?, ?, ?)";
        Connection cn = conexion.getConnection();
        PreparedStatement ps = cn.prepareStatement(sql);
        ps.setInt(1, inv.getIdProducto());
        ps.setString(2, inv.getTalla());
        ps.setString(3, inv.getColor());
        ps.setInt(4, inv.getStock());
        ps.setString(5, inv.getEstado());
        ps.executeUpdate();
        ps.close();
        cn.close();
    }

    public void actualizar(Inventario inv) throws Exception {
        String sql = "UPDATE Inventario SET talla=?, color=?, stock=?, estado=? WHERE id_inventario=?";
        Connection cn = conexion.getConnection();
        PreparedStatement ps = cn.prepareStatement(sql);
        ps.setString(1, inv.getTalla());
        ps.setString(2, inv.getColor());
        ps.setInt(3, inv.getStock());
        ps.setString(4, inv.getEstado());
        ps.setInt(5, inv.getIdInventario());
        ps.executeUpdate();
        ps.close();
        cn.close();
    }

    public void eliminar(int idInventario) throws Exception {
        String sql = "DELETE FROM Inventario WHERE id_inventario=?";
        Connection cn = conexion.getConnection();
        PreparedStatement ps = cn.prepareStatement(sql);
        ps.setInt(1, idInventario);
        ps.executeUpdate();
        ps.close();
        cn.close();
    }
}
