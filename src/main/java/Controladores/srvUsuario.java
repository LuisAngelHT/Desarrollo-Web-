package Controladores;

import Modelo.Carrito;
import Modelo.CarritoDAO;
import Modelo.UsuarioDAO;
import Modelo.Usuarios;
import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet(name = "srvUsuario", urlPatterns = {"/srvUsuario"})
@MultipartConfig  // ✅ IMPORTANTE: Para subir archivos
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
                    case "cambiarFoto":  // ✅ NUEVO CASE
                        cambiarFotoPerfil(request, response);
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
            HttpSession sesion = request.getSession(false);
            if (sesion != null) {
                sesion.setAttribute("error", "Error interno en el sistema: " + e.getMessage());
            }
            response.sendRedirect("identificar.jsp");
        }
    }

    private void verificar(HttpServletRequest request, HttpServletResponse response) throws Exception {
        UsuarioDAO dao = new UsuarioDAO();
        Usuarios usuario = obtenerUsuario(request);

        usuario = dao.identificar(usuario);

        if (usuario != null && usuario.getRol() != null) {
            String rol = usuario.getRol().getNombreRol();

            // Asignar fecha y hora actual como último acceso
            String fechaAcceso = LocalDateTime.now().format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm"));
            usuario.setUltimoAcceso(fechaAcceso);

            HttpSession sesion = request.getSession(true);
            sesion.setAttribute("usuario", usuario);
            sesion.setAttribute("idCliente", usuario.getIdUsuario());

            // Cargar carrito si es cliente
            if (rol.equalsIgnoreCase("Cliente")) {
                CarritoDAO carritoDAO = new CarritoDAO();
                List<Carrito> itemsCarrito = carritoDAO.obtenerCarritoCliente(usuario.getIdUsuario());
                int totalItems = carritoDAO.contarItemsCarrito(usuario.getIdUsuario());
                double total = carritoDAO.calcularTotalCarrito(usuario.getIdUsuario());

                sesion.setAttribute("itemsCarrito", itemsCarrito);
                sesion.setAttribute("totalItems", totalItems);
                sesion.setAttribute("totalCarrito", total);
            }

            // Redireccionar según rol
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
        } else {
            request.setAttribute("error", "Credenciales incorrectas");
            request.getRequestDispatcher("identificar.jsp").forward(request, response);
        }
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

        if (sesion == null) {
            response.sendRedirect("identificar.jsp");
            return;
        }

        Usuarios usuario = (Usuarios) sesion.getAttribute("usuario");

        if (usuario == null) {
            response.sendRedirect("identificar.jsp");
            return;
        }

        request.setAttribute("usuario", usuario);
        response.sendRedirect("perfil.jsp");
        //request.getRequestDispatcher("perfil.jsp").forward(request, response);
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
            sesion.setAttribute("usuario", usuario);
            sesion.setAttribute("exito", "Datos actualizados correctamente");  // ✅ CAMBIO A SESSION
        } else {
            sesion.setAttribute("error", "Error al actualizar los datos");
        }

        response.sendRedirect("srvUsuario?accion=verPerfil");  // ✅ REDIRECT EN LUGAR DE FORWARD
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
            sesion.setAttribute("error", "Las contraseñas nuevas no coinciden");
            response.sendRedirect("srvUsuario?accion=verPerfil");
            return;
        }

        if (passwordNueva.length() < 6) {
            sesion.setAttribute("error", "La contraseña debe tener al menos 6 caracteres");
            response.sendRedirect("srvUsuario?accion=verPerfil");
            return;
        }

        // Cambiar contraseña en la base de datos
        UsuarioDAO dao = new UsuarioDAO();
        boolean cambiado = dao.cambiarPassword(usuario.getCorreo(), passwordActual, passwordNueva);

        if (cambiado) {
            sesion.setAttribute("exito", "Contraseña actualizada correctamente");
        } else {
            sesion.setAttribute("error", "La contraseña actual es incorrecta");
        }

        response.sendRedirect("srvUsuario?accion=verPerfil");  // ✅ REDIRECT
    }

    // ✅ MÉTODO NUEVO PARA CAMBIAR FOTO DE PERFIL
    private void cambiarFotoPerfil(HttpServletRequest request, HttpServletResponse response) throws Exception {
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

        try {
            // Obtener el archivo de imagen
            Part archivo = request.getPart("fotoPerfil");

            if (archivo == null || archivo.getSize() == 0) {
                sesion.setAttribute("error", "Debe seleccionar una imagen");
                response.sendRedirect("srvUsuario?accion=verPerfil");
                return;
            }

            String nombreArchivo = Paths.get(archivo.getSubmittedFileName()).getFileName().toString();

            // Validar que sea una imagen
            if (!nombreArchivo.toLowerCase().matches(".*\\.(jpg|jpeg|png|gif)$")) {
                sesion.setAttribute("error", "Solo se permiten imágenes (JPG, PNG, GIF)");
                response.sendRedirect("srvUsuario?accion=verPerfil");
                return;
            }

            // Validar tamaño máximo (2MB)
            if (archivo.getSize() > 2 * 1024 * 1024) {
                sesion.setAttribute("error", "La imagen no debe superar los 2MB");
                response.sendRedirect("srvUsuario?accion=verPerfil");
                return;
            }

            // Crear carpeta si no existe
            String rutaServidor = getServletContext().getRealPath("/uploads/perfiles");
            File carpeta = new File(rutaServidor);
            if (!carpeta.exists()) {
                carpeta.mkdirs();
            }

            // Eliminar foto anterior si existe
            if (usuario.getFotoPerfil() != null && !usuario.getFotoPerfil().isEmpty()) {
                String fotoAnterior = getServletContext().getRealPath("/" + usuario.getFotoPerfil());
                File archivoAnterior = new File(fotoAnterior);
                if (archivoAnterior.exists() && !usuario.getFotoPerfil().contains("user2-160x160")) {
                    archivoAnterior.delete();
                }
            }

            // Generar nombre único para evitar conflictos
            String extension = nombreArchivo.substring(nombreArchivo.lastIndexOf("."));
            String nombreUnico = "perfil_" + usuario.getIdUsuario() + "_" + System.currentTimeMillis() + extension;

            String rutaFinal = rutaServidor + File.separator + nombreUnico;
            archivo.write(rutaFinal);

            // Guardar ruta relativa en BD
            String rutaRelativa = "uploads/perfiles/" + nombreUnico;

            // Actualizar en la base de datos
            UsuarioDAO dao = new UsuarioDAO();
            boolean actualizado = dao.actualizarFotoPerfil(usuario.getIdUsuario(), rutaRelativa);

            if (actualizado) {
                // Actualizar el objeto en sesión
                usuario.setFotoPerfil(rutaRelativa);
                sesion.setAttribute("usuario", usuario);
                sesion.setAttribute("exito", "Foto de perfil actualizada correctamente");
            } else {
                sesion.setAttribute("error", "Error al actualizar la foto de perfil");
            }

        } catch (Exception e) {
            e.printStackTrace();
            sesion.setAttribute("error", "Error al procesar la imagen: " + e.getMessage());
        }

        response.sendRedirect("srvUsuario?accion=verPerfil");
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
