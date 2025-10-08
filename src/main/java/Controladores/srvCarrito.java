package Controladores;

import Modelo.Carrito;
import Modelo.ProductoClienteDAO;

import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet(name = "srvCarrito", urlPatterns = {"/srvCarrito"})
public class srvCarrito extends HttpServlet {

    private final ProductoClienteDAO carritoDAO = new ProductoClienteDAO();

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String accion = request.getParameter("accion");
        if (accion == null) {
            accion = "listar";
        }

        try {
            switch (accion) {
                case "listar":
                    listar(request, response);
                    break;
                case "agregar":
                    agregar(request, response);
                    break;
                case "actualizar":
                    actualizar(request, response);
                    break;
                case "eliminar":
                    eliminar(request, response);
                    break;
                case "vaciar":
                    vaciar(request, response);
                    break;
                default:
                    listar(request, response);
                    break;
            }
        } catch (Exception e) {
            throw new ServletException("Error en carrito", e);
        }
    }

    private void listar(HttpServletRequest request, HttpServletResponse response) throws Exception {
        HttpSession session = request.getSession();
        int idCliente = (int) session.getAttribute("idCliente"); // asegúrate de guardar el idCliente en sesión al loguear

        List<Carrito> items = carritoDAO.obtenerCarrito(idCliente);
        double total = carritoDAO.calcularTotal(idCliente);

        request.setAttribute("itemsCarrito", items);
        request.setAttribute("totalCarrito", total);

        request.getRequestDispatcher("/vistas/cliente/carrito.jsp").forward(request, response);
    }

    private void agregar(HttpServletRequest request, HttpServletResponse response) throws Exception {
        HttpSession session = request.getSession();
        int idCliente = (int) session.getAttribute("idCliente");

        int idInventario = Integer.parseInt(request.getParameter("idInventario"));
        int cantidad = Integer.parseInt(request.getParameter("cantidad"));

        carritoDAO.agregar(idCliente, idInventario, cantidad);

        response.sendRedirect("srvCarrito?accion=listar");
    }

    private void actualizar(HttpServletRequest request, HttpServletResponse response) throws Exception {
        int idCarrito = Integer.parseInt(request.getParameter("idCarrito"));
        int cantidad = Integer.parseInt(request.getParameter("cantidad"));

        carritoDAO.actualizarCantidad(idCarrito, cantidad);

        response.sendRedirect("srvCarrito?accion=listar");
    }

    private void eliminar(HttpServletRequest request, HttpServletResponse response) throws Exception {
        int idCarrito = Integer.parseInt(request.getParameter("idCarrito"));
        carritoDAO.eliminar(idCarrito);

        response.sendRedirect("srvCarrito?accion=listar");
    }

    private void vaciar(HttpServletRequest request, HttpServletResponse response) throws Exception {
        HttpSession session = request.getSession();
        int idCliente = (int) session.getAttribute("idCliente");

        carritoDAO.vaciar(idCliente);

        response.sendRedirect("srvCarrito?accion=listar");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }
}
