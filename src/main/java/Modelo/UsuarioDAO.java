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

        try (Connection cn = getConnection(); PreparedStatement ps = cn.prepareStatement(sql)) {

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

        try (Connection cn = getConnection(); PreparedStatement ps = cn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

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

    public boolean registrarCliente(Usuarios cliente) throws Exception {
        String sql = "INSERT INTO Usuario (nombre, apellido, email, clave, telefono, direccion, estado, id_rol) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection cn = getConnection(); PreparedStatement ps = cn.prepareStatement(sql)) {

            ps.setString(1, cliente.getNombre());
            ps.setString(2, cliente.getApellido());
            ps.setString(3, cliente.getCorreo());
            ps.setString(4, cliente.getContrasena()); // En producción, cifra esto con BCrypt
            ps.setString(5, cliente.getTelefono());
            ps.setString(6, cliente.getDireccion());
            ps.setBoolean(7, true); // Estado activo por defecto
            ps.setInt(8, cliente.getRol().getIdRol()); // Debe ser el ID del rol "Cliente"

            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.err.println("Error al registrar cliente: " + e.getMessage());
            throw e;
        }
    }

    /**
     * Verifica si un email ya está registrado en la base de datos
     *
     * @param email Email a verificar
     * @return true si el email existe, false en caso contrario
     */
    public boolean existeCorreo(String email) throws Exception {
        String sql = "SELECT COUNT(*) FROM Usuario WHERE email = ?";

        try (Connection cn = getConnection(); PreparedStatement ps = cn.prepareStatement(sql)) {

            ps.setString(1, email.trim().toLowerCase());

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (Exception e) {
            System.err.println("Error al verificar email: " + e.getMessage());
            throw e;
        }

        return false;
    }

    /**
     * Obtiene un usuario por su email (útil para validaciones)
     *
     * @param email Email del usuario
     * @return Usuario encontrado o null
     */
    public Usuarios obtenerPorEmail(String email) throws Exception {
        String sql = "SELECT U.id_usuario, U.nombre, U.apellido, U.email, U.telefono, U.direccion, U.estado, "
                + "R.id_rol, R.nombre_rol "
                + "FROM Usuario U "
                + "INNER JOIN Rol R ON U.id_rol = R.id_rol "
                + "WHERE U.email = ?";

        try (Connection cn = getConnection(); PreparedStatement ps = cn.prepareStatement(sql)) {

            ps.setString(1, email.trim().toLowerCase());

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
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

                    return usu;
                }
            }
        } catch (Exception e) {
            System.err.println("Error al obtener usuario por email: " + e.getMessage());
            throw e;
        }

        return null;
    }

}
