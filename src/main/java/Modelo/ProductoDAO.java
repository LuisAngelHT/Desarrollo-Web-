package Modelo;

import Config.conexion;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import Modelo.*;

public class ProductoDAO {

    public List<Producto> listar() throws Exception {
        List<Producto> lista = new ArrayList<>();
        String sql = "SELECT p.id_producto, p.nombre, p.descripcion, p.precio, p.imagen_url, p.id_categoria, c.nombre_categoria "
                + "FROM Producto p INNER JOIN Categoria c ON p.id_categoria = c.id_categoria ORDER BY c.nombre_categoria, p.precio DESC";

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

    public List<Producto> filtrar(String nombre, Integer idCategoria) throws Exception {
        List<Producto> lista = new ArrayList<>();

        StringBuilder sql = new StringBuilder(
                "SELECT p.*, c.nombre_categoria FROM Producto p "
                + "JOIN Categoria c ON p.id_categoria = c.id_categoria WHERE 1=1"
        );

        if (nombre != null && !nombre.trim().isEmpty()) {
            sql.append(" AND p.nombre LIKE ?");
        }
        if (idCategoria != null) {
            sql.append(" AND p.id_categoria = ?");
        }

        sql.append(" ORDER BY c.nombre_categoria ASC");

        Connection cn = conexion.getConnection();
        PreparedStatement ps = cn.prepareStatement(sql.toString());

        int index = 1;
        if (nombre != null && !nombre.trim().isEmpty()) {
            ps.setString(index++, "%" + nombre.trim() + "%");
        }
        if (idCategoria != null) {
            ps.setInt(index++, idCategoria);
        }

        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            Producto p = new Producto();
            p.setIdProducto(rs.getInt("id_producto"));
            p.setNombre(rs.getString("nombre"));
            p.setDescripcion(rs.getString("descripcion"));
            p.setPrecio(rs.getDouble("precio"));
            p.setImagenUrl(rs.getString("imagen_url"));
            p.setIdCategoria(rs.getInt("id_categoria"));
            p.setNombreCategoria(rs.getString("nombre_categoria")); // Asegúrate de tener este campo en tu modelo
            lista.add(p);
        }

        rs.close();
        ps.close();
        cn.close();

        return lista;

    }

    // Método para listar con paginación
    public List<Producto> listarPaginado(int pagina, int registrosPorPagina) throws Exception {
        List<Producto> lista = new ArrayList<>();
        int offset = (pagina - 1) * registrosPorPagina;

        String sql = "SELECT p.id_producto, p.nombre, p.descripcion, p.precio, p.imagen_url, p.id_categoria, c.nombre_categoria "
                + "FROM Producto p INNER JOIN Categoria c ON p.id_categoria = c.id_categoria "
                + "ORDER BY c.nombre_categoria, p.precio DESC "
                + "LIMIT ? OFFSET ?";

        Connection cn = conexion.getConnection();
        PreparedStatement ps = cn.prepareStatement(sql);
        ps.setInt(1, registrosPorPagina);
        ps.setInt(2, offset);
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

// Método para contar total de productos
    public int contarTotal() throws Exception {
        String sql = "SELECT COUNT(*) FROM Producto";
        Connection cn = conexion.getConnection();
        PreparedStatement ps = cn.prepareStatement(sql);
        ResultSet rs = ps.executeQuery();

        int total = 0;
        if (rs.next()) {
            total = rs.getInt(1);
        }

        rs.close();
        ps.close();
        cn.close();
        return total;
    }

// Método para filtrar con paginación
    public List<Producto> filtrarPaginado(String nombre, Integer idCategoria, int pagina, int registrosPorPagina) throws Exception {
        List<Producto> lista = new ArrayList<>();
        int offset = (pagina - 1) * registrosPorPagina;

        StringBuilder sql = new StringBuilder(
                "SELECT p.*, c.nombre_categoria FROM Producto p "
                + "JOIN Categoria c ON p.id_categoria = c.id_categoria WHERE 1=1"
        );

        if (nombre != null && !nombre.trim().isEmpty()) {
            sql.append(" AND p.nombre LIKE ?");
        }
        if (idCategoria != null) {
            sql.append(" AND p.id_categoria = ?");
        }

        sql.append(" ORDER BY c.nombre_categoria ASC LIMIT ? OFFSET ?");

        Connection cn = conexion.getConnection();
        PreparedStatement ps = cn.prepareStatement(sql.toString());

        int index = 1;
        if (nombre != null && !nombre.trim().isEmpty()) {
            ps.setString(index++, "%" + nombre.trim() + "%");
        }
        if (idCategoria != null) {
            ps.setInt(index++, idCategoria);
        }
        ps.setInt(index++, registrosPorPagina);
        ps.setInt(index++, offset);

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

// Método para contar productos filtrados
    public int contarFiltrados(String nombre, Integer idCategoria) throws Exception {
        StringBuilder sql = new StringBuilder(
                "SELECT COUNT(*) FROM Producto p WHERE 1=1"
        );

        if (nombre != null && !nombre.trim().isEmpty()) {
            sql.append(" AND p.nombre LIKE ?");
        }
        if (idCategoria != null) {
            sql.append(" AND p.id_categoria = ?");
        }

        Connection cn = conexion.getConnection();
        PreparedStatement ps = cn.prepareStatement(sql.toString());

        int index = 1;
        if (nombre != null && !nombre.trim().isEmpty()) {
            ps.setString(index++, "%" + nombre.trim() + "%");
        }
        if (idCategoria != null) {
            ps.setInt(index++, idCategoria);
        }

        ResultSet rs = ps.executeQuery();
        int total = 0;
        if (rs.next()) {
            total = rs.getInt(1);
        }

        rs.close();
        ps.close();
        cn.close();
        return total;
    }

}
