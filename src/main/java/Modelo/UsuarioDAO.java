package Modelo;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import Config.conexion;

public class UsuarioDAO extends conexion {

    // MÉTODO LOGIN / IDENTIFICAR USUARIO
    public Usuarios identificar(Usuarios user) throws Exception {
        Usuarios usu = null;
        String sql = "SELECT U.id_usuario, U.nombre, U.apellido, U.email, U.telefono, U.direccion, U.estado, "
                   + "R.id_rol, R.nombre_rol "
                   + "FROM Usuario U "
                   + "INNER JOIN Rol R ON U.id_rol = R.id_rol "
                   + "WHERE U.email = ? AND U.clave = ?";

        try (Connection cn = getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {

            ps.setString(1, user.getCorreo());
            ps.setString(2, user.getContrasena());

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    usu = new Usuarios();
                    usu.setIdUsuario(rs.getInt("id_usuario"));
                    usu.setNombre(rs.getString("nombre"));
                    usu.setApellido(rs.getString("apellido"));
                    usu.setCorreo(rs.getString("email"));
                    usu.setTelefono(rs.getString("telefono"));
                    usu.setDireccion(rs.getString("direccion"));
                    usu.setEstado(rs.getBoolean("estado"));

                    Rol rol = new Rol();
                    rol.setIdRol(rs.getInt("id_rol"));
                    rol.setNombreRol(rs.getString("nombre_rol"));
                    usu.setRol(rol);
                }
            }
        } catch (Exception e) {
            System.err.println("Error en identificar usuario: " + e.getMessage());
            throw e;
        }
        return usu;
    }

    // LISTAR TODOS LOS USUARIOS
    public ArrayList<Usuarios> listarUsuarios() {
        ArrayList<Usuarios> lista = new ArrayList<>();
        String sql = "SELECT U.id_usuario, U.nombre, U.apellido, U.email, U.telefono, U.direccion, U.estado, "
                   + "R.id_rol, R.nombre_rol "
                   + "FROM Usuario U "
                   + "INNER JOIN Rol R ON U.id_rol = R.id_rol "
                   + "ORDER BY U.id_usuario";

        try (Connection cn = getConnection();
             PreparedStatement ps = cn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Usuarios usu = new Usuarios();
                usu.setIdUsuario(rs.getInt("id_usuario"));
                usu.setNombre(rs.getString("nombre"));
                usu.setApellido(rs.getString("apellido"));
                usu.setCorreo(rs.getString("email"));
                usu.setTelefono(rs.getString("telefono"));
                usu.setDireccion(rs.getString("direccion"));
                usu.setEstado(rs.getBoolean("estado"));

                Rol rol = new Rol();
                rol.setIdRol(rs.getInt("id_rol"));
                rol.setNombreRol(rs.getString("nombre_rol"));
                usu.setRol(rol);

                lista.add(usu);
            }
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return lista;
    }
}
