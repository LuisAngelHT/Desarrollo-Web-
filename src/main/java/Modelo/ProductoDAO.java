package Modelo;

import Config.conexion;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ProductoDAO {

    public List<Producto> listar() throws Exception {
        List<Producto> lista = new ArrayList<>();
        String sql = "SELECT p.id_producto, p.nombre, p.descripcion, p.precio, p.imagen_url, p.id_categoria, c.nombre_categoria "
                   + "FROM Producto p INNER JOIN Categoria c ON p.id_categoria = c.id_categoria";

        Connection cn = conexion.getConnection();
        PreparedStatement ps = cn.prepareStatement(sql);
        ResultSet rs = ps.executeQuery();

        while (rs.next()) {
            Producto p = new Producto();
            p.setIdProducto(rs.getInt("id_producto"));
            p.setNombre(rs.getString("nombre"));
            p.setDescripcion(rs.getString("descripcion"));
            p.setPrecio(rs.getDouble("precio"));
            p.setImagenUrl(rs.getString("imagen_url"));
            p.setIdCategoria(rs.getInt("id_categoria"));
            p.setNombreCategoria(rs.getString("nombre_categoria"));
            lista.add(p);
        }

        rs.close();
        ps.close();
        cn.close();
        return lista;
    }

    public void insertar(Producto p) throws Exception {
        String sql = "INSERT INTO Producto (nombre, descripcion, precio, imagen_url, id_categoria) VALUES (?, ?, ?, ?, ?)";
        Connection cn = conexion.getConnection();
        PreparedStatement ps = cn.prepareStatement(sql);
        ps.setString(1, p.getNombre());
        ps.setString(2, p.getDescripcion());
        ps.setDouble(3, p.getPrecio());
        ps.setString(4, p.getImagenUrl());
        ps.setInt(5, p.getIdCategoria());
        ps.executeUpdate();
        ps.close();
        cn.close();
    }

    public void actualizar(Producto p) throws Exception {
        String sql = "UPDATE Producto SET nombre=?, descripcion=?, precio=?, imagen_url=?, id_categoria=? WHERE id_producto=?";
        Connection cn = conexion.getConnection();
        PreparedStatement ps = cn.prepareStatement(sql);
        ps.setString(1, p.getNombre());
        ps.setString(2, p.getDescripcion());
        ps.setDouble(3, p.getPrecio());
        ps.setString(4, p.getImagenUrl());
        ps.setInt(5, p.getIdCategoria());
        ps.setInt(6, p.getIdProducto());
        ps.executeUpdate();
        ps.close();
        cn.close();
    }

    public void eliminar(int idProducto) throws Exception {
        String sql = "DELETE FROM Producto WHERE id_producto=?";
        Connection cn = conexion.getConnection();
        PreparedStatement ps = cn.prepareStatement(sql);
        ps.setInt(1, idProducto);
        ps.executeUpdate();
        ps.close();
        cn.close();
    }
}
