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

    // AGREGAR ESTOS MÉTODOS A TU CLASE UsuarioDAO
    /**
     * Actualiza los datos personales de un usuario (nombre, apellido, teléfono,
     * dirección)
     *
     * @param usuario Usuario con los datos actualizados
     * @return true si se actualizó correctamente, false en caso contrario
     */
    public boolean actualizarDatos(Usuarios usuario) throws Exception {
        String sql = "UPDATE Usuario SET nombre=?, apellido=?, telefono=?, direccion=? WHERE email=?";

        try (Connection cn = getConnection(); PreparedStatement ps = cn.prepareStatement(sql)) {

            ps.setString(1, usuario.getNombre());
            ps.setString(2, usuario.getApellido());
            ps.setString(3, usuario.getTelefono());
            ps.setString(4, usuario.getDireccion());
            ps.setString(5, usuario.getCorreo());

            int filasAfectadas = ps.executeUpdate();
            return filasAfectadas > 0;

        } catch (Exception e) {
            System.err.println("Error al actualizar datos del usuario: " + e.getMessage());
            throw e;
        }
    }

    /**
     * Cambia la contraseña de un usuario
     *
     * @param email Email del usuario
     * @param passwordActual Contraseña actual (para verificar)
     * @param passwordNueva Nueva contraseña
     * @return true si se cambió correctamente, false si la contraseña actual es
     * incorrecta
     */
    public boolean cambiarPassword(String email, String passwordActual, String passwordNueva) throws Exception {
        // Primero verificar que la contraseña actual sea correcta
        String sqlVerificar = "SELECT id_usuario FROM Usuario WHERE email=? AND clave=?";
        String sqlActualizar = "UPDATE Usuario SET clave=? WHERE email=?";

        try (Connection cn = getConnection()) {

            // Verificar contraseña actual
            try (PreparedStatement psVerificar = cn.prepareStatement(sqlVerificar)) {
                psVerificar.setString(1, email);
                psVerificar.setString(2, passwordActual);

                try (ResultSet rs = psVerificar.executeQuery()) {
                    if (!rs.next()) {
                        // La contraseña actual es incorrecta
                        return false;
                    }
                }
            }

            // Si llegamos aquí, la contraseña actual es correcta, procedemos a actualizar
            try (PreparedStatement psActualizar = cn.prepareStatement(sqlActualizar)) {
                psActualizar.setString(1, passwordNueva);
                psActualizar.setString(2, email);

                int filasAfectadas = psActualizar.executeUpdate();
                return filasAfectadas > 0;
            }

        } catch (Exception e) {
            System.err.println("Error al cambiar contraseña: " + e.getMessage());
            throw e;
        }
    }

}
