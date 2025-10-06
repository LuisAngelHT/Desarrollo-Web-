package Controladores;

import Modelo.Cliente;
import Modelo.ClienteDAO;
import Modelo.Usuarios;
import Modelo.Venta;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet(name = "srvClientes", urlPatterns = {"/srvClientes"})
public class srvClientes extends HttpServlet {

    private final ClienteDAO clienteDAO = new ClienteDAO();

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

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String accion = request.getParameter("accion");
        if (accion == null || accion.trim().isEmpty()) {
            accion = "listar";
        }

        HttpSession sesion = request.getSession();
        Usuarios usuario = (Usuarios) sesion.getAttribute("usuario");

        if (usuario == null || usuario.getRol() == null
                || !usuario.getRol().getNombreRol().equalsIgnoreCase("Vendedor")) {
            response.sendRedirect("identificar.jsp");
            return;
        }

        try {
            switch (accion) {
                case "listar":
                    listarClientes(request, response);
                    break;
                case "ver":
                    verDetalle(request, response);
                    break;
                default:
                    listarClientes(request, response);
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error al procesar clientes: " + e.getMessage());
            request.getRequestDispatcher("/vistas/vendedor/clientes.jsp").forward(request, response);
        }
    }

    private void listarClientes(HttpServletRequest request, HttpServletResponse response) throws Exception {
        List<Cliente> lista = clienteDAO.listarClientes();
        int total = clienteDAO.contarClientes();

        request.setAttribute("listaClientes", lista);
        request.setAttribute("totalClientes", total);
        request.getRequestDispatcher("/vistas/vendedor/clientes.jsp").forward(request, response);
    }

    private void verDetalle(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String idStr = request.getParameter("id");
        if (idStr == null || idStr.trim().isEmpty()) {
            HttpSession sesion = request.getSession();
            sesion.setAttribute("error", "ID de cliente no especificado.");
            response.sendRedirect("srvClientes?accion=listar");
            return;
        }

        int idCliente = Integer.parseInt(idStr);
        Cliente cliente = clienteDAO.obtenerPorId(idCliente);

        if (cliente == null) {
            HttpSession sesion = request.getSession();
            sesion.setAttribute("error", "Cliente no encontrado.");
            response.sendRedirect("srvClientes?accion=listar");
            return;
        }

        // Obtener historial de compras
        List<Venta> historial = clienteDAO.obtenerHistorialCompras(idCliente);
        double totalGastado = clienteDAO.obtenerTotalGastado(idCliente);

        request.setAttribute("cliente", cliente);
        request.setAttribute("historialCompras", historial);
        request.setAttribute("totalGastado", totalGastado);
        request.getRequestDispatcher("/vistas/vendedor/cliente-detalle.jsp").forward(request, response);
    }
}
