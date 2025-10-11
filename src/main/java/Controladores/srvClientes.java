package Controladores;

import Modelo.Cliente;
import Modelo.ClienteDAO;
import Modelo.ProductoComprado;
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
    private static final int REGISTROS_POR_PAGINA = 10;

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
                case "buscar":
                    buscarClientes(request, response);
                    break;
                case "ver":
                    verDetalle(request, response);
                    break;
                case "historial":
                    verHistorial(request, response);
                    break;
                case "cambiarEstado":
                    cambiarEstado(request, response);
                    break;
                default:
                    listarClientes(request, response);
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            sesion.setAttribute("error", "Error al procesar clientes: " + e.getMessage());
            response.sendRedirect("srvClientes?accion=listar");
        }
    }

    private void listarClientes(HttpServletRequest request, HttpServletResponse response) throws Exception {
        // Obtener número de página
        String paginaParam = request.getParameter("pagina");
        int paginaActual = (paginaParam != null) ? Integer.parseInt(paginaParam) : 1;

        // Obtener clientes paginados
        List<Cliente> lista = clienteDAO.listarClientesPaginado(paginaActual, REGISTROS_POR_PAGINA);

        // Calcular paginación
        int totalClientes = clienteDAO.contarClientes();
        int totalPaginas = (int) Math.ceil((double) totalClientes / REGISTROS_POR_PAGINA);

        // Enviar atributos
        request.setAttribute("listaClientes", lista);
        request.setAttribute("totalClientes", totalClientes);
        request.setAttribute("paginaActual", paginaActual);
        request.setAttribute("totalPaginas", totalPaginas);

        request.getRequestDispatcher("/vistas/vendedor/clientes.jsp").forward(request, response);
    }

    private void buscarClientes(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String termino = request.getParameter("termino");
        String paginaParam = request.getParameter("pagina");
        int paginaActual = (paginaParam != null) ? Integer.parseInt(paginaParam) : 1;

        List<Cliente> lista;
        int totalClientes;

        if (termino == null || termino.trim().isEmpty()) {
            // Si no hay término de búsqueda, mostrar todos
            lista = clienteDAO.listarClientesPaginado(paginaActual, REGISTROS_POR_PAGINA);
            totalClientes = clienteDAO.contarClientes();
        } else {
            // Buscar con el término
            lista = clienteDAO.buscarClientesPaginado(termino, paginaActual, REGISTROS_POR_PAGINA);
            totalClientes = clienteDAO.contarClientesBusqueda(termino);
        }

        // Calcular paginación
        int totalPaginas = (int) Math.ceil((double) totalClientes / REGISTROS_POR_PAGINA);

        // Enviar atributos
        request.setAttribute("listaClientes", lista);
        request.setAttribute("totalClientes", totalClientes);
        request.setAttribute("paginaActual", paginaActual);
        request.setAttribute("totalPaginas", totalPaginas);
        request.setAttribute("terminoBusqueda", termino);

        request.getRequestDispatcher("/vistas/vendedor/clientes.jsp").forward(request, response);
    }

    /**
     * Muestra el detalle completo de un cliente con estadísticas
     */
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

        // Obtener estadísticas del cliente
        int totalCompras = clienteDAO.contarComprasCliente(idCliente);
        double montoTotalGastado = clienteDAO.obtenerTotalGastado(idCliente);
        Venta ultimaCompra = clienteDAO.obtenerUltimaCompra(idCliente);
        
        // Obtener top 5 productos más comprados
        List<ProductoComprado> topProductos = clienteDAO.obtenerTopProductos(idCliente, 5);

        // Enviar atributos al JSP
        request.setAttribute("cliente", cliente);
        request.setAttribute("totalCompras", totalCompras);
        request.setAttribute("montoTotalGastado", montoTotalGastado);
        request.setAttribute("ultimaCompra", ultimaCompra);
        request.setAttribute("topProductos", topProductos);

        request.getRequestDispatcher("/vistas/vendedor/cliente-detalle.jsp").forward(request, response);
    }

    /**
     * Muestra el historial completo de compras del cliente
     */
    private void verHistorial(HttpServletRequest request, HttpServletResponse response) throws Exception {
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

        request.getRequestDispatcher("/vistas/vendedor/cliente-historial.jsp").forward(request, response);
    }

    /**
     * Cambia el estado de un cliente (activo/inactivo)
     */
    private void cambiarEstado(HttpServletRequest request, HttpServletResponse response) throws Exception {
        HttpSession sesion = request.getSession();
        
        String idStr = request.getParameter("id");
        String estadoStr = request.getParameter("estado");

        if (idStr == null || estadoStr == null) {
            sesion.setAttribute("error", "Parámetros inválidos.");
            response.sendRedirect("srvClientes?accion=listar");
            return;
        }

        int idCliente = Integer.parseInt(idStr);
        boolean nuevoEstado = Boolean.parseBoolean(estadoStr);

        boolean resultado = clienteDAO.cambiarEstado(idCliente, nuevoEstado);

        if (resultado) {
            String mensaje = nuevoEstado ? 
                "Cliente activado correctamente." : 
                "Cliente desactivado correctamente.";
            sesion.setAttribute("success", mensaje);
        } else {
            sesion.setAttribute("error", "No se pudo cambiar el estado del cliente.");
        }

        // Redirigir de vuelta al detalle del cliente
        response.sendRedirect("srvClientes?accion=ver&id=" + idCliente);
    }
}