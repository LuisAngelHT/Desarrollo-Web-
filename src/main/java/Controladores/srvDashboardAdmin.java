package Controladores;

import Modelo.Usuarios;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet(name = "srvDashboardAdmin", urlPatterns = {"/srvDashboardAdmin"})
public class srvDashboardAdmin extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession sesion = request.getSession(false);
        Usuarios usuario = (Usuarios) sesion.getAttribute("usuario");

        if (usuario == null || !usuario.getRol().getNombreRol().equalsIgnoreCase("Administrador")) {
            response.sendRedirect("identificar.jsp");
            return;
        }

        request.setAttribute("nombre", usuario.getNombre());
        request.getRequestDispatcher("/vistas/administrador/dashboard.jsp").forward(request, response);
    }

    @Override protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException { processRequest(request, response); }

    @Override protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException { processRequest(request, response); }
}
