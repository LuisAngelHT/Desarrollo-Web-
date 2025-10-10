package Modelo;

import Config.conexion;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CatalogoProductoDAO {

    private Connection connection;

    public CatalogoProductoDAO() {
        this.connection = conexion.getConnection();
    }

    /**
     * Lista todos los productos con su categoría y stock total Solo considera
     * inventarios activos
     */
    public List<Producto> listarProductos() {
        List<Producto> lista = new ArrayList<>();

        // ✅ QUERY SIMPLIFICADA SIN FILTROS (solo para probar)
        String sql = "SELECT p.id_producto, p.nombre, p.descripcion, p.precio, p.imagen_url, "
                + "c.id_categoria, c.nombre_categoria "
                + "FROM Producto p "
                + "INNER JOIN Categoria c ON p.id_categoria = c.id_categoria "
                + "ORDER BY p.nombre ASC";

        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            System.out.println("=== EJECUTANDO QUERY DE PRODUCTOS ===");

            while (rs.next()) {
                Producto p = new Producto();
                p.setIdProducto(rs.getInt("id_producto"));
                p.setNombre(rs.getString("nombre"));
                p.setDescripcion(rs.getString("descripcion"));
                p.setPrecio(rs.getDouble("precio"));
                p.setImagenUrl(rs.getString("imagen_url"));
                p.setIdCategoria(rs.getInt("id_categoria"));
                p.setNombreCategoria(rs.getString("nombre_categoria"));
                p.setStock(0); // Temporal

                lista.add(p);

                System.out.println("Producto encontrado: " + p.getNombre());
            }

            System.out.println("✅ Total productos: " + lista.size());

        } catch (SQLException e) {
            System.err.println("❌ ERROR en listarProductos:");
            e.printStackTrace();
        }
        return lista;
    }

    /**
     * Buscar productos por nombre o categoría
     */
    public List<Producto> buscarProductos(String criterio) {
        List<Producto> lista = new ArrayList<>();
        String sql = "SELECT p.id_producto, p.nombre, p.descripcion, p.precio, p.imagen_url, "
                + "c.id_categoria, c.nombre_categoria, "
                + "COALESCE(SUM(CASE WHEN i.estado = 'activo' THEN i.stock ELSE 0 END), 0) AS stock_total "
                + "FROM Producto p "
                + "INNER JOIN Categoria c ON p.id_categoria = c.id_categoria "
                + "LEFT JOIN Inventario i ON p.id_producto = i.id_producto "
                + "WHERE p.estado = 1 "
                + "AND (p.nombre LIKE ? OR c.nombre_categoria LIKE ?) "
                + "GROUP BY p.id_producto, p.nombre, p.descripcion, p.precio, p.imagen_url, "
                + "c.id_categoria, c.nombre_categoria "
                + "ORDER BY p.nombre ASC";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, "%" + criterio + "%");
            ps.setString(2, "%" + criterio + "%");
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
                p.setStock(rs.getInt("stock_total"));

                lista.add(p);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }

    /**
     * Obtener un producto por ID
     */
    public Producto obtenerPorId(int idProducto) {
        String sql = "SELECT p.id_producto, p.nombre, p.descripcion, p.precio, p.imagen_url, "
                + "c.id_categoria, c.nombre_categoria, "
                + "COALESCE(SUM(CASE WHEN i.estado = 'activo' THEN i.stock ELSE 0 END), 0) AS stock_total "
                + "FROM Producto p "
                + "INNER JOIN Categoria c ON p.id_categoria = c.id_categoria "
                + "LEFT JOIN Inventario i ON p.id_producto = i.id_producto "
                + "WHERE p.id_producto = ? AND p.estado = 1 "
                + "GROUP BY p.id_producto, p.nombre, p.descripcion, p.precio, p.imagen_url, "
                + "c.id_categoria, c.nombre_categoria";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, idProducto);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                Producto p = new Producto();
                p.setIdProducto(rs.getInt("id_producto"));
                p.setNombre(rs.getString("nombre"));
                p.setDescripcion(rs.getString("descripcion"));
                p.setPrecio(rs.getDouble("precio"));
                p.setImagenUrl(rs.getString("imagen_url"));
                p.setIdCategoria(rs.getInt("id_categoria"));
                p.setNombreCategoria(rs.getString("nombre_categoria"));
                p.setStock(rs.getInt("stock_total"));

                return p;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Obtiene los inventarios (variantes) de un producto Solo inventarios
     * activos
     */
    public List<Inventario> obtenerInventariosPorProducto(int idProducto) {
        List<Inventario> inventarios = new ArrayList<>();
        String sql = "SELECT id_inventario, id_producto, talla, color, stock, estado "
                + "FROM Inventario "
                + "WHERE id_producto = ? AND estado = 'activo' "
                + "ORDER BY color, talla";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, idProducto);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Inventario inv = new Inventario();
                inv.setIdInventario(rs.getInt("id_inventario"));
                inv.setIdProducto(rs.getInt("id_producto"));
                inv.setTalla(rs.getString("talla"));
                inv.setColor(rs.getString("color"));
                inv.setStock(rs.getInt("stock"));
                inv.setEstado(rs.getString("estado")); // ✅ VARCHAR

                inventarios.add(inv);
            }

            System.out.println("Inventarios encontrados para producto " + idProducto + ": " + inventarios.size());

        } catch (SQLException e) {
            System.err.println("❌ ERROR en obtenerInventariosPorProducto:");
            e.printStackTrace();
        }
        return inventarios;
    }
}
