package Controladores;

import Modelo.Carrito;
import Modelo.CarritoDAO;
import Modelo.ProductoClienteDAO;
import Modelo.UsuarioDAO;
import Modelo.Usuarios;
import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
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
                    case "verPerfil":
                        verPerfil(request, response);
                        break;
                    case "actualizarDatos":
                        actualizarDatos(request, response);
                        break;
                    case "cambiarPassword":
                        cambiarPassword(request, response);
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
            request.setAttribute("error", "Error interno en el sistema: " + e.getMessage());
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

            sesion = request.getSession(true);
            sesion.setAttribute("usuario", usuario);
            sesion.setAttribute("idCliente", usuario.getIdUsuario());
            if (rol.equalsIgnoreCase("Administrador")) {
                response.sendRedirect("srvDashboardAdmin?accion=dashboard");
            } else if (rol.equalsIgnoreCase("Vendedor")) {
                response.sendRedirect("srvDashboardVendedor?accion=dashboard");
            } else if (rol.equalsIgnoreCase("Cliente")) {
                response.sendRedirect("srvCatalogo?accion=catalogo");
            } else {
                sesion.invalidate();
                request.setAttribute("error", "Rol no autorizado");
                request.getRequestDispatcher("identificar.jsp").forward(request, response);
            }
            // ✅ AGREGAR ESTO: Cargar carrito inicial
CarritoDAO carritoDAO = new CarritoDAO();
List<Carrito> itemsCarrito = carritoDAO.obtenerCarritoCliente(usuario.getIdUsuario());
int totalItems = carritoDAO.contarItemsCarrito(usuario.getIdUsuario());
double total = carritoDAO.calcularTotalCarrito(usuario.getIdUsuario());

sesion.setAttribute("itemsCarrito", itemsCarrito);
sesion.setAttribute("totalItems", totalItems);
sesion.setAttribute("totalCarrito", total);
System.out.println("=== LOGIN: Carrito cargado ===");
System.out.println("Items: " + itemsCarrito.size());
        } else {
            request.setAttribute("error", "Credenciales incorrectas");
            request.getRequestDispatcher("identificar.jsp").forward(request, response);
        }
        // En tu servlet de login, después de validar credenciales
        
    }

    private void cerrarSesion(HttpServletRequest request, HttpServletResponse response) throws Exception {
        HttpSession sesion = request.getSession(false);
        if (sesion != null) {
            sesion.invalidate();
        }
        response.sendRedirect("identificar.jsp");
    }

    private Usuarios obtenerUsuario(HttpServletRequest request) {
        Usuarios u = new Usuarios();
        u.setCorreo(request.getParameter("txtCorreo"));
        u.setContrasena(request.getParameter("txtPass"));
        return u;
    }

    private void verPerfil(HttpServletRequest request, HttpServletResponse response) throws Exception {
        HttpSession sesion = request.getSession(false);

        // Verificar que existe la sesión
        if (sesion == null) {
            response.sendRedirect("identificar.jsp");
            return;
        }

        Usuarios usuario = (Usuarios) sesion.getAttribute("usuario");

        // Verificar que el usuario existe en la sesión
        if (usuario == null) {
            response.sendRedirect("identificar.jsp");
            return;
        }

        // No es necesario volver a establecer el usuario en el request
        // porque ya está disponible en la sesión con ${usuario}
        // Pero si lo necesitas, puedes dejarlo
        request.setAttribute("usuario", usuario);

        // Forward a la página de perfil
        request.getRequestDispatcher("perfil.jsp").forward(request, response);
    }

    private void actualizarDatos(HttpServletRequest request, HttpServletResponse response) throws Exception {
        HttpSession sesion = request.getSession(false);

        if (sesion == null) {
            response.sendRedirect("identificar.jsp");
            return;
        }

        Usuarios usuario = (Usuarios) sesion.getAttribute("usuario");

        if (usuario == null) {
            response.sendRedirect("identificar.jsp");
            return;
        }

        // Obtener nuevos datos del formulario
        usuario.setNombre(request.getParameter("txtNombre"));
        usuario.setApellido(request.getParameter("txtApellido"));
        usuario.setTelefono(request.getParameter("txtTelefono"));
        usuario.setDireccion(request.getParameter("txtDireccion"));

        // Actualizar en la base de datos
        UsuarioDAO dao = new UsuarioDAO();
        boolean actualizado = dao.actualizarDatos(usuario);

        if (actualizado) {
            // Actualizar la sesión con los nuevos datos
            sesion.setAttribute("usuario", usuario);
            request.setAttribute("success", "Datos actualizados correctamente");
        } else {
            request.setAttribute("error", "Error al actualizar los datos");
        }

        request.getRequestDispatcher("perfil.jsp").forward(request, response);
    }

    private void cambiarPassword(HttpServletRequest request, HttpServletResponse response) throws Exception {
        HttpSession sesion = request.getSession(false);

        if (sesion == null) {
            response.sendRedirect("identificar.jsp");
            return;
        }

        Usuarios usuario = (Usuarios) sesion.getAttribute("usuario");

        if (usuario == null) {
            response.sendRedirect("identificar.jsp");
            return;
        }

        String passwordActual = request.getParameter("txtPasswordActual");
        String passwordNueva = request.getParameter("txtPasswordNueva");
        String passwordConfirmar = request.getParameter("txtPasswordConfirmar");

        // Validaciones
        if (!passwordNueva.equals(passwordConfirmar)) {
            request.setAttribute("error", "Las contraseñas nuevas no coinciden");
            request.getRequestDispatcher("perfil.jsp").forward(request, response);
            return;
        }

        if (passwordNueva.length() < 6) {
            request.setAttribute("error", "La contraseña debe tener al menos 6 caracteres");
            request.getRequestDispatcher("perfil.jsp").forward(request, response);
            return;
        }

        // Cambiar contraseña en la base de datos
        UsuarioDAO dao = new UsuarioDAO();
        boolean cambiado = dao.cambiarPassword(usuario.getCorreo(), passwordActual, passwordNueva);

        if (cambiado) {
            request.setAttribute("success", "Contraseña actualizada correctamente");
        } else {
            request.setAttribute("error", "La contraseña actual es incorrecta");
        }

        request.getRequestDispatcher("perfil.jsp").forward(request, response);
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
        return "Controlador de autenticación para Administrador, Vendedor y Cliente";
    }
}
