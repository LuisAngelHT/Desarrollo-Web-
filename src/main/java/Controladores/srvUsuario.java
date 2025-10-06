package Controladores;

import Modelo.UsuarioDAO;
import Modelo.Usuarios;
import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet(name = "srvUsuario", urlPatterns = {"/srvUsuario"})
public class srvUsuario extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html;charset=UTF-8");
        String accion = request.getParameter("accion");

        try {
            if (accion != null) {
                switch (accion) {
                    case "verificar":
                        verificar(request, response);
                        break;
                    case "cerrar":
                        cerrarSesion(request, response);
                        break;
                    default:
                        response.sendRedirect("identificar.jsp");
                        break;
                }
            } else {
                response.sendRedirect("identificar.jsp");
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error interno en el sistema");
            request.getRequestDispatcher("/mensaje.jsp").forward(request, response);
        }
    }

    private void verificar(HttpServletRequest request, HttpServletResponse response) throws Exception {
        HttpSession sesion;
        UsuarioDAO dao = new UsuarioDAO();
        Usuarios usuario = obtenerUsuario(request);

        usuario = dao.identificar(usuario);

        if (usuario != null && usuario.getRol() != null) {
            String rol = usuario.getRol().getNombreRol();

            // Asignar fecha y hora actual como último acceso
            String fechaAcceso = LocalDateTime.now().format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm"));
            usuario.setUltimoAcceso(fechaAcceso);

            sesion = request.getSession();
            sesion.setAttribute("usuario", usuario);

            if (rol.equalsIgnoreCase("Administrador")) {
                response.sendRedirect("srvDashboardAdmin?accion=dashboard");
            } else if (rol.equalsIgnoreCase("Vendedor")) {
                response.sendRedirect("srvDashboardVendedor?accion=dashboard");
            } else if (rol.equalsIgnoreCase("Cliente")) {
                response.sendRedirect("srvDashboardCliente?accion=dashboard");
            }
            else {
                sesion.invalidate();
                request.setAttribute("error", "Rol no autorizado");
                request.getRequestDispatcher("identificar.jsp").forward(request, response);
            }
        } else {
            request.setAttribute("error", "Credenciales incorrectas");
            request.getRequestDispatcher("identificar.jsp").forward(request, response);
        }
    }

    private void cerrarSesion(HttpServletRequest request, HttpServletResponse response) throws Exception {
        HttpSession sesion = request.getSession();
        sesion.invalidate();
        response.sendRedirect("identificar.jsp");
    }

    private Usuarios obtenerUsuario(HttpServletRequest request) {
        Usuarios u = new Usuarios();
        u.setCorreo(request.getParameter("txtCorreo"));
        u.setContrasena(request.getParameter("txtPass"));
        return u;
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
        return "Controlador de autenticación para Administrador y Vendedor";
    }
}
