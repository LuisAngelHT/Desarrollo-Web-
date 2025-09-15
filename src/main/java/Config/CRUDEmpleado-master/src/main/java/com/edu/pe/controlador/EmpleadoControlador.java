package com.edu.pe.controlador;

import com.edu.pe.modelo.Empleado;
import com.edu.pe.modelo.dao.EmpleadoDAO;
import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class EmpleadoControlador extends HttpServlet {
    
    private EmpleadoDAO empDao = new EmpleadoDAO();
    private final String pagListar = "/vista/listar.jsp";
    private final String pagNuevo = "/vista/nuevo.jsp";
    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        
        String accion = request.getParameter("accion");
        
        switch (accion) {
            case "listar":
                listar(request, response);
                break;
            case "nuevo":
                nuevo(request, response);
                break;
            case "guardar":
                guardar(request, response);
                break;
            case "editar":
                editar(request, response);
                break;
            case "eliminar":
                eliminar(request, response);
                break;
            default:
                throw new AssertionError();
        }
    }
    
    private void eliminar(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        
        int result = empDao.eliminar(id);
        
        if (result > 0) {
            request.getSession().setAttribute("success", "Empleado con id " + id + " eliminado!");
        } else {
            request.getSession().setAttribute("error", "No se pudo eliminar empleado");
        }
        response.sendRedirect("EmpleadoControlador?accion=listar");
    }
    
    private void editar(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        
        Empleado obj = empDao.buscarPorId(id);
        
        if (obj != null) {
            request.setAttribute("empleado", obj);
            request.getRequestDispatcher(pagNuevo).forward(request, response);
        } else {
            request.getSession().setAttribute("error", "No se encontro empleado con ID " + id);
            response.sendRedirect("EmpleadoControlador?accion=listar");
        }
    }
    
    private void guardar(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Empleado obj = new Empleado();
        obj.setId(Integer.parseInt(request.getParameter("id")));
        obj.setNombres(request.getParameter("nombres"));
        obj.setApellidos(request.getParameter("apellidos"));
        obj.setFechaIngreso(request.getParameter("fechaIngreso"));
        obj.setSueldo(Double.parseDouble(request.getParameter("sueldo")));
        
        int result;
        
        if (obj.getId() == 0) {
            result = empDao.registrar(obj);
        } else {
            result = empDao.editar(obj);
        }
        
        if (result > 0) {
            request.getSession().setAttribute("success", "Datos guardados!");
            response.sendRedirect("EmpleadoControlador?accion=listar");
        } else {
            request.getSession().setAttribute("error", "No se pudo guardar datos.");
            request.setAttribute("empleado", obj);
            request.getRequestDispatcher(pagNuevo).forward(request, response);
        }
    }
    
    private void nuevo(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setAttribute("empleado", new Empleado());
        request.getRequestDispatcher(pagNuevo).forward(request, response);
    }
    
    protected void listar(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        
        request.setAttribute("empleados", empDao.ListarTodos());
        request.getRequestDispatcher(pagListar).forward(request, response);
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
