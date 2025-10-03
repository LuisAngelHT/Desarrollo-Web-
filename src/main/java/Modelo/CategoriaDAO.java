package Modelo;

import Config.conexion;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CategoriaDAO {

    public List<Categoria> listar() throws Exception {
        List<Categoria> lista = new ArrayList<>();
        String sql = "SELECT id_categoria, nombre_categoria FROM Categoria ORDER BY nombre_categoria ASC";

        Connection cn = conexion.getConnection();
        PreparedStatement ps = cn.prepareStatement(sql);
        ResultSet rs = ps.executeQuery();

        while (rs.next()) {
            Categoria c = new Categoria();
            c.setIdCategoria(rs.getInt("id_categoria"));
            c.setNombreCategoria(rs.getString("nombre_categoria"));
            lista.add(c);
        }

        rs.close();
        ps.close();
        cn.close();
        return lista;
    }
}
