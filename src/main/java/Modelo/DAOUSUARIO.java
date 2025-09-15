package Modelo;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

import Config.conexion;

public class DAOUSUARIO extends conexion {

    public usuario identificar(usuario user) throws Exception {
        usuario usu = null;
        String sql = "SELECT U.IDUSUARIO, C.NOMBRECARGO FROM USUARIO U "
                + "INNER JOIN CARGO C ON U.IDCARGO = C.IDCARGO "
                + "WHERE U.ESTADO = 1 AND U.NOMBREUSUARIO = ? AND U.CLAVE = ?";

        try (Connection cn = conexion.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {

            ps.setString(1, user.getNombreUsuario());
            ps.setString(2, user.getClave());
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    usu = new usuario();
                    usu.setId_usuario(rs.getInt("IDUSUARIO"));
                    usu.setNombreUsuario(user.getNombreUsuario());
                    usu.setCargo(new cargo());
                    usu.getCargo().setNombreCargo(rs.getString("NOMBRECARGO"));
                    usu.setEstado(true);
                }
            }
        } catch (Exception e) {
            // No imprimas el stack trace completo al usuario, solo en el log
            System.err.println("Error en la identificación del usuario: " + e.getMessage());
            throw e; // Lanza la excepción para que el servlet la maneje
        }
        return usu;
    }

    public ArrayList<usuario> listarUsuarios() {
        ArrayList<usuario> lista = new ArrayList<>();
        String sql = "SELECT U.IDUSUARIO, U.NOMBREUSUARIO, U.ESTADO, C.NOMBRECARGO "
                + "FROM usuario U INNER JOIN cargo C "
                + "ON C.IDCARGO = U.IDCARGO "
                + "ORDER BY u.idusuario";

        try (Connection cn = conexion.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                usuario usu = new usuario();
                usu.setId_usuario(rs.getInt("IDUSUARIO"));
                usu.setNombreUsuario(rs.getString("NOMBREUSUARIO"));
                usu.setEstado(rs.getBoolean("ESTADO"));
                usu.setCargo(new cargo());
                usu.getCargo().setNombreCargo(rs.getString("NOMBRECARGO"));
                lista.add(usu);
            }
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return lista;
    }
}