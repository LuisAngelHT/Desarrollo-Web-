
package Controladores;

import Modelo.DAOUSUARIO;
import Modelo.Empleado;
import Modelo.EmpleadoDAO;
import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "ControladorUsuario", urlPatterns = {"/ControladorUsuario"})
public class ControladorUsuario extends HttpServlet {
    private EmpleadoDAO empDao = new EmpleadoDAO();
    private DAOUSUARIO Daousu = new DAOUSUARIO();
    private final String pagListarUsuarios = "/vistas/listarUsuarios.jsp";
    private final String pagProductos = "/vistas/productos.jsp";
    private final String pagPrincipal = "/vistas/index.jsp";
    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
                String menu= request.getParameter("menu");
                

    switch (menu) {
        case "index":
            request.getRequestDispatcher(pagPrincipal).forward(request, response);
            break;
        case "listarUsuarios":
            listarUsuarios(request, response);
            break;
        default:
            request.getRequestDispatcher(pagPrincipal).forward(request, response);
            break;
    }
    }
    
    protected void productos(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        request.getRequestDispatcher(pagProductos).forward(request, response);
    }
     private void listarUsuarios(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setAttribute("usuarios", Daousu.listarUsuarios());
        request.getRequestDispatcher(pagListarUsuarios).forward(request, response);
        
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
