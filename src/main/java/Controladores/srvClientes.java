package Controladores;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet(name = "srvClientes", urlPatterns = {"/srvClientes"})
public class srvClientes extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String accion = request.getParameter("accion");

        if ("listar".equals(accion)) {
            request.getRequestDispatcher("/vistas/vendedor/clientes.jsp").forward(request, response);
        } else {
            response.sendRedirect("srvDashboardVendedor?accion=dashboard");
        }
    }

    @Override protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override public String getServletInfo() {
        return "Controlador para vista de clientes del vendedor";
    }
}
