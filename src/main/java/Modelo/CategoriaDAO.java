package Modelo;

import Config.conexion;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CategoriaDAO {

    public List<Categoria> listar() throws Exception {
        List<Categoria> lista = new ArrayList<>();
        String sql = "SELECT id_categoria, nombre_categoria, descripcion FROM Categoria ORDER BY nombre_categoria ASC";

        Connection cn = conexion.getConnection();
        PreparedStatement ps = cn.prepareStatement(sql);
        ResultSet rs = ps.executeQuery();

        while (rs.next()) {
            Categoria c = new Categoria();
            c.setIdCategoria(rs.getInt("id_categoria"));
            c.setNombreCategoria(rs.getString("nombre_categoria"));
            c.setDescripcion(rs.getString("descripcion")); // ✅ agregado
            lista.add(c);
        }

        rs.close();
        ps.close();
        cn.close();
        return lista;
    }

    public void guardar(Categoria c) throws Exception {
        String sql = "INSERT INTO Categoria(nombre_categoria, descripcion) VALUES (?, ?)";
        Connection cn = conexion.getConnection();
        PreparedStatement ps = cn.prepareStatement(sql);
        ps.setString(1, c.getNombreCategoria());
        ps.setString(2, c.getDescripcion());
        ps.executeUpdate();
        ps.close();
        cn.close();
    }

    public void eliminar(int id) throws Exception {
        String sql = "DELETE FROM Categoria WHERE id_categoria = ?";
        Connection cn = conexion.getConnection();
        PreparedStatement ps = cn.prepareStatement(sql);
        ps.setInt(1, id);
        ps.executeUpdate();
        ps.close();
        cn.close();
    }

    public Categoria obtenerPorId(int id) throws Exception {
        String sql = "SELECT id_categoria, nombre_categoria, descripcion FROM Categoria WHERE id_categoria = ?";
        Connection cn = conexion.getConnection();
        PreparedStatement ps = cn.prepareStatement(sql);
        ps.setInt(1, id);
        ResultSet rs = ps.executeQuery();
        Categoria c = null;
        if (rs.next()) {
            c = new Categoria();
            c.setIdCategoria(rs.getInt("id_categoria"));
            c.setNombreCategoria(rs.getString("nombre_categoria"));
            c.setDescripcion(rs.getString("descripcion"));
        }
        rs.close();
        ps.close();
        cn.close();
        return c;
    }

    public void actualizar(Categoria c) throws Exception {
        String sql = "UPDATE Categoria SET nombre_categoria = ?, descripcion = ? WHERE id_categoria = ?";
        Connection cn = conexion.getConnection();
        PreparedStatement ps = cn.prepareStatement(sql);
        ps.setString(1, c.getNombreCategoria());
        ps.setString(2, c.getDescripcion());
        ps.setInt(3, c.getIdCategoria());
        ps.executeUpdate();
        ps.close();
        cn.close();
    }

    public boolean tieneProductos(int idCategoria) throws Exception {
        String sql = "SELECT COUNT(*) FROM producto WHERE id_categoria = ?";
        Connection cn = conexion.getConnection();
        PreparedStatement ps = cn.prepareStatement(sql);
        ps.setInt(1, idCategoria);
        ResultSet rs = ps.executeQuery();
        boolean tiene = false;
        if (rs.next()) {
            tiene = rs.getInt(1) > 0;
        }
        rs.close();
        ps.close();
        cn.close();
        return tiene;
    }

    public boolean existe(String nombre) {
        String sql = "SELECT COUNT(*) FROM Categoria WHERE LOWER(nombre_categoria) = LOWER(?)";
        try (Connection con = conexion.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, nombre.trim());
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

}
