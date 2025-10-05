package Controladores;

import Modelo.ClienteDAO;
import Modelo.Venta;
import Modelo.Usuarios;
import java.io.IOException;
import java.util.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet(name = "srvClientes", urlPatterns = {"/srvClientes"})
public class srvClientes extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String accion = request.getParameter("accion");
        HttpSession sesion = request.getSession();
        Usuarios vendedor = (Usuarios) sesion.getAttribute("usuario");

        if (vendedor == null || vendedor.getRol().getNombreRol().equalsIgnoreCase("Administrador")) {
            response.sendRedirect("srvDashboardVendedor?accion=dashboard");
            return;
        }

        ClienteDAO dao = new ClienteDAO();

        try {
            switch (accion) {
                case "listar":
                    List<Usuarios> lista = dao.listarPorVendedor(vendedor.getIdUsuario());
                    request.setAttribute("listaClientes", lista);
                    request.getRequestDispatcher("/vistas/vendedor/clientes.jsp").forward(request, response);
                    break;

                case "guardar":
                    Usuarios nuevo = new Usuarios();
                    nuevo.setNombre(request.getParameter("nombre"));
                    nuevo.setApellido(request.getParameter("apellido"));
                    nuevo.setCorreo(request.getParameter("email"));
                    nuevo.setTelefono(request.getParameter("telefono"));
                    nuevo.setDireccion(request.getParameter("direccion"));
                    nuevo.setContrasena("123456"); // clave por defecto

                    dao.guardar(nuevo);
                    response.sendRedirect("srvClientes?accion=listar");
                    break;

                case "actualizar":
                    Usuarios actualizado = new Usuarios();
                    actualizado.setIdUsuario(Integer.parseInt(request.getParameter("idCliente")));
                    actualizado.setNombre(request.getParameter("nombre"));
                    actualizado.setApellido(request.getParameter("apellido"));
                    actualizado.setCorreo(request.getParameter("email"));
                    actualizado.setTelefono(request.getParameter("telefono"));
                    actualizado.setDireccion(request.getParameter("direccion"));

                    dao.actualizar(actualizado);
                    response.sendRedirect("srvClientes?accion=listar");
                    break;

                case "eliminar":
                    int idEliminar = Integer.parseInt(request.getParameter("idCliente"));
                    dao.eliminar(idEliminar);
                    response.sendRedirect("srvClientes?accion=listar");
                    break;

                case "ver":
                    int idVer = Integer.parseInt(request.getParameter("id"));
                    Usuarios cliente = dao.obtenerPorId(idVer);

                    // Validación opcional si quieres asegurar que el cliente pertenece al vendedor
                    // Esto depende de cómo manejes la relación vendedor-cliente
                    // Puedes omitir esta parte si no tienes esa lógica

                    List<Venta> historial = dao.obtenerHistorialCompras(idVer);
                    double totalGastado = dao.obtenerTotalGastado(idVer);

                    request.setAttribute("cliente", cliente);
                    request.setAttribute("historialCompras", historial);
                    request.setAttribute("totalGastado", totalGastado);
                    request.getRequestDispatcher("/vistas/vendedor/cliente-detalle.jsp").forward(request, response);
                    break;

                default:
                    response.sendRedirect("srvDashboardVendedor?accion=dashboard");
                    break;
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("srvDashboardVendedor?accion=dashboard");
        }
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

    @Override
    public String getServletInfo() {
        return "Controlador para gestión de clientes del vendedor";
    }
}
