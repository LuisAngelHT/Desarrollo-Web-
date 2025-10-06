package Controladores;

import Modelo.UsuarioDAO;
import Modelo.Usuarios;
import Modelo.Rol;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet(name = "srvClienteRegistro", urlPatterns = {"/srvClienteRegistro"})
public class srvClienteRegistro extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");
        String accion = request.getParameter("accion");

        try {
            if (accion != null) {
                switch (accion) {
                    case "registrar":
                        registrarCliente(request, response);
                        break;
                    default:
                        response.sendRedirect("registro.jsp");
                        break;
                }
            } else {
                response.sendRedirect("registro.jsp");
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error interno en el sistema. Por favor intente nuevamente.");
            request.getRequestDispatcher("registro.jsp").forward(request, response);
        }
    }

    private void registrarCliente(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        UsuarioDAO dao = new UsuarioDAO();
        
        try {
            // Obtener datos del formulario
            Usuarios cliente = obtenerDatosCliente(request);
            
            // Validaciones del lado del servidor
            String errorValidacion = validarDatosCliente(cliente, request);
            if (errorValidacion != null) {
                request.setAttribute("error", errorValidacion);
                request.getRequestDispatcher("registro.jsp").forward(request, response);
                return;
            }
            
            // Verificar si el correo ya existe
            if (existeCorreo(cliente.getCorreo())) {
                request.setAttribute("error", "El correo electrónico ya está registrado");
                request.getRequestDispatcher("registro.jsp").forward(request, response);
                return;
            }
            
            // Registrar cliente en la base de datos
            boolean registrado = dao.registrarCliente(cliente);
            
            if (registrado) {
                // Registro exitoso
                request.setAttribute("mensaje", "¡Registro exitoso! Ya puedes iniciar sesión.");
                request.getRequestDispatcher("identificar.jsp").forward(request, response);
            } else {
                // Error al registrar
                request.setAttribute("error", "No se pudo completar el registro. Intente nuevamente.");
                request.getRequestDispatcher("registro.jsp").forward(request, response);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error al procesar el registro: " + e.getMessage());
            request.getRequestDispatcher("registro.jsp").forward(request, response);
        }
    }
    
    private Usuarios obtenerDatosCliente(HttpServletRequest request) {
        Usuarios cliente = new Usuarios();
        
        // Nombre y apellido vienen en campos separados
        cliente.setNombre(request.getParameter("nombre"));
        cliente.setApellido(request.getParameter("apellido"));
        cliente.setCorreo(request.getParameter("correo"));
        cliente.setContrasena(request.getParameter("contrasena")); // Campo 'clave' en BD
        cliente.setTelefono(request.getParameter("telefono"));
        cliente.setDireccion(request.getParameter("direccion"));
        cliente.setEstado(true); // Activo por defecto
        
        // Asignar rol de Cliente (id_rol = 3)
        Rol rol = new Rol();
        rol.setIdRol(3); // 3 = Cliente
        rol.setNombreRol("Cliente");
        cliente.setRol(rol);
        
        return cliente;
    }
    
    private String validarDatosCliente(Usuarios cliente, HttpServletRequest request) {
        // Validar nombre
        if (cliente.getNombre() == null || cliente.getNombre().trim().isEmpty()) {
            return "El nombre es requerido";
        }
        if (cliente.getNombre().trim().length() < 2) {
            return "El nombre debe tener al menos 2 caracteres";
        }
        
        // Validar apellido
        if (cliente.getApellido() == null || cliente.getApellido().trim().isEmpty()) {
            return "El nombre completo debe incluir apellido";
        }
        
        // Validar email
        if (cliente.getCorreo() == null || cliente.getCorreo().trim().isEmpty()) {
            return "El correo electrónico es requerido";
        }
        if (!cliente.getCorreo().matches("^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$")) {
            return "El formato del correo electrónico no es válido";
        }
        
        // Validar contraseña
        String contrasena = cliente.getContrasena();
        if (contrasena == null || contrasena.isEmpty()) {
            return "La contraseña es requerida";
        }
        if (contrasena.length() < 6) {
            return "La contraseña debe tener al menos 6 caracteres";
        }
        
        // Validar confirmación de contraseña
        String confirmarContrasena = request.getParameter("confirmarContrasena");
        if (confirmarContrasena != null && !contrasena.equals(confirmarContrasena)) {
            return "Las contraseñas no coinciden";
        }
        
        // Validar teléfono
        if (cliente.getTelefono() == null || cliente.getTelefono().trim().isEmpty()) {
            return "El teléfono es requerido";
        }
        if (!cliente.getTelefono().matches("^[0-9]{9}$")) {
            return "El teléfono debe tener exactamente 9 dígitos";
        }
        
        return null; // Todas las validaciones pasaron
    }
    
    /**
     * Verifica si un correo ya está registrado en la base de datos
     * @param correo Email a verificar
     * @return true si existe, false si no existe
     */
    private boolean existeCorreo(String correo) {
        try {
            UsuarioDAO dao = new UsuarioDAO();
            return dao.existeCorreo(correo);
        } catch (Exception e) {
            System.err.println("Error al verificar correo: " + e.getMessage());
            return false;
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
        return "Controlador de registro de clientes";
    }
}