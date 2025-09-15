/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Modelo;

import Modelo.Empleado;
import Config.conexion;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

/**
 *
 * @author user
 */
public class EmpleadoDAO {
    private Connection cn=null;
    private PreparedStatement ps=null;
    private ResultSet rs=null;
    
    public ArrayList<Empleado> listarTodos(){
        ArrayList<Empleado> lista=new ArrayList<>();
        try {
            cn = conexion.getConnection();
            String sql = "select * from empleado";
            ps = cn.prepareStatement(sql);
            rs = ps.executeQuery();
            while(rs.next()){
                Empleado obj = new Empleado();
                obj.setId(rs.getInt("IDEMPLEADO"));
                obj.setNombres(rs.getString("NOMBRE"));
                obj.setApellidos(rs.getString("APELLIDOS"));
                obj.setSexo(rs.getString("SEXO"));
                obj.setTelefono(rs.getString("TELEFONO"));
                obj.setFechanac(rs.getString("FECHANACIMIENTO"));
                obj.setTipodoc(rs.getString("TIPODOCUMENTO"));
                obj.setNrodoc(rs.getString("NUMERODOCUMENTO"));
                obj.setIdusuario(rs.getInt("IDUSUARIO"));
                lista.add(obj);
            }
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally{
            try{
                if(cn!=null){
                    cn.close();
                }
                if(rs!=null){
                    rs.close();
                }
                if(ps!=null){
                    ps.close();
                }
            }catch(Exception ex){
                
            }
        }
        return lista;
    }
            
}
