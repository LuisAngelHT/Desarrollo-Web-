package com.edu.pe.modelo.dao;

import com.edu.pe.config.Conexion;
import com.edu.pe.modelo.Empleado;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

public class EmpleadoDAO {
    
    private Connection cn = null;
    private PreparedStatement ps = null;
    private ResultSet rs = null;
    
    public ArrayList<Empleado> ListarTodos() {
        ArrayList<Empleado> lista = new ArrayList<>();
        
        try {
            cn = Conexion.getConnection();
            String sql = "select * from empleado";
            ps = cn.prepareStatement(sql);
            rs = ps.executeQuery();
            
            while (rs.next()) {
                Empleado obj = new Empleado();
                obj.setId(rs.getInt("id"));
                obj.setNombres(rs.getString("nombres"));
                obj.setApellidos(rs.getString("apellidos"));
                obj.setFechaIngreso(rs.getString("fecha_ingreso"));
                obj.setSueldo(rs.getDouble("sueldo"));
                lista.add(obj);
            }
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            try {
                if (cn != null) {
                    cn.close();
                }
                if (rs != null) {
                    rs.close();
                }
                if (ps != null) {
                    ps.close();
                }
            } catch (Exception ex) {
                
            }
        }
        
        return lista;
    }
    
    public int registrar(Empleado obj) {
        int result = 0;
        
        try {
            cn = Conexion.getConnection();
            String sql = "INSERT INTO empleado(nombres,apellidos,fecha_ingreso,sueldo) "
                    + "VALUES (?,?,?,?)";
            ps = cn.prepareStatement(sql);
            ps.setString(1, obj.getNombres());
            ps.setString(2, obj.getApellidos());
            ps.setString(3, obj.getFechaIngreso());
            ps.setDouble(4, obj.getSueldo());
            
            result = ps.executeUpdate();
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            try {
                if (cn != null) {
                    cn.close();
                }
                if (ps != null) {
                    ps.close();
                }
            } catch (Exception ex) {
                
            }
        }
        
        return result;
    }
    
    public int editar(Empleado obj) {
        int result = 0;
        
        try {
            cn = Conexion.getConnection();
            String sql = "UPDATE empleado SET nombres=?, apellidos=?,fecha_ingreso=?,sueldo=?"
                    + " WHERE id=?";
            ps = cn.prepareStatement(sql);
            ps.setString(1, obj.getNombres());
            ps.setString(2, obj.getApellidos());
            ps.setString(3, obj.getFechaIngreso());
            ps.setDouble(4, obj.getSueldo());
            ps.setInt(5, obj.getId());
            result = ps.executeUpdate();
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            try {
                if (cn != null) {
                    cn.close();
                }
                if (ps != null) {
                    ps.close();
                }
            } catch (Exception ex) {
                
            }
        }
        
        return result;
    }
    
    public int eliminar(int id) {
        int result = 0;
        
        try {
            cn = Conexion.getConnection();
            String sql = "DELETE FROM empleado WHERE id = ?";
            ps = cn.prepareStatement(sql);
            ps.setInt(1, id);
            result = ps.executeUpdate();
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            try {
                if (cn != null) {
                    cn.close();
                }
                if (ps != null) {
                    ps.close();
                }
            } catch (Exception ex) {
                
            }
        }
        
        return result;
    }
    
    public Empleado buscarPorId(int id) {
        Empleado obj = null;
        
        try {
            cn = Conexion.getConnection();
            String sql = "select * from empleado where id = ?";
            ps = cn.prepareStatement(sql);
            ps.setInt(1, id);
            rs = ps.executeQuery();
            
            if (rs.next()) {
                obj = new Empleado();
                obj.setId(rs.getInt("id"));
                obj.setNombres(rs.getString("nombres"));
                obj.setApellidos(rs.getString("apellidos"));
                obj.setFechaIngreso(rs.getString("fecha_ingreso"));
                obj.setSueldo(rs.getDouble("sueldo"));
            }
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            try {
                if (cn != null) {
                    cn.close();
                }
                if (rs != null) {
                    rs.close();
                }
                if (ps != null) {
                    ps.close();
                }
            } catch (Exception ex) {
                
            }
        }
        
        return obj;
    }
    
}
