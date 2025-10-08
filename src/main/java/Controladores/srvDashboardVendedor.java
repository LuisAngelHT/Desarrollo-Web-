package Controladores;

import Modelo.DashboardDAO;
import Modelo.Usuarios;
import com.google.gson.Gson;

import java.io.IOException;
import java.util.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet(name = "srvDashboardVendedor", urlPatterns = {"/srvDashboardVendedor"})
public class srvDashboardVendedor extends HttpServlet {

    private final DashboardDAO dao = new DashboardDAO();

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession sesion = request.getSession(false);
        Usuarios usuario = (Usuarios) sesion.getAttribute("usuario");

        if (usuario == null || usuario.getRol() == null
                || !usuario.getRol().getNombreRol().equalsIgnoreCase("Vendedor")) {
            response.sendRedirect("identificar.jsp");
            return;
        }

        try {
            // Métricas generales
            int productos = dao.getTotalProductos();
            int ventasHoy = dao.getVentasHoy();
            int clientes = dao.getTotalClientes();
            int stockBajo = dao.getInventarioBajo();
            double ingresosHoy = dao.getIngresosHoy();

            // Clientes recientes
            List<Map<String, Object>> clientesRecientes = dao.getClientesRecientes(3);

            // Cajas resumen dinámicas
            List<Map<String, String>> resumenBoxes = new ArrayList<>();
            resumenBoxes.add(Map.of("valor", String.valueOf(productos), "texto", "Productos disponibles", "icono", "fa-cube", "color", "aqua", "link", "srvProductos?accion=listar"));
            resumenBoxes.add(Map.of("valor", String.valueOf(ventasHoy), "texto", "Ventas hoy", "icono", "fa-shopping-cart", "color", "green", "link", "srvVentas?accion=listar"));
            resumenBoxes.add(Map.of("valor", String.valueOf(clientes), "texto", "Clientes registrados", "icono", "fa-users", "color", "yellow", "link", "srvClientes?accion=listar"));
            resumenBoxes.add(Map.of("valor", String.format("%.2f", ingresosHoy), "texto", "Ingresos hoy (S/)", "icono", "fa-money", "color", "purple", "link", "srvVentas?accion=listar"));

            // Gráfico de ventas semanales
            String ventasJson = new Gson().toJson(dao.getVentasPorDiaSemana());

            // Últimas ventas
            List<Map<String, Object>> ventasRecientes = dao.getUltimasVentas(5);

            // Enviar datos al JSP
            request.setAttribute("nombre", usuario.getNombre());
            request.setAttribute("resumenBoxes", resumenBoxes);
            request.setAttribute("ventasPorDiaSemanaJson", ventasJson);
            request.setAttribute("ventasRecientes", ventasRecientes);
            request.setAttribute("clientesRecientes", clientesRecientes);
            request.setAttribute("clientesSemana", clientesRecientes.size());

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error al cargar datos del dashboard: " + e.getMessage());
        }

        request.getRequestDispatcher("/vistas/vendedor/dashboard.jsp").forward(request, response);
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
