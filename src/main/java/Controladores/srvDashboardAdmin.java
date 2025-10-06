package Controladores;

import Modelo.Usuarios;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet(name = "srvDashboardAdmin", urlPatterns = {"/srvDashboardAdmin"})
public class srvDashboardAdmin extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession sesion = request.getSession(false);
    Usuarios usuario = (Usuarios) sesion.getAttribute("usuario");

    if (usuario == null || !usuario.getRol().getNombreRol().equalsIgnoreCase("Administrador")) {
        response.sendRedirect("identificar.jsp");
        return;
    }
    
    String accion = request.getParameter("accion");
    
    try {
        if (accion.equalsIgnoreCase("dashboard")) {
            // Lógica para cargar datos del Administrador
            // Ejemplo de carga de datos (debes implementar estos métodos en tu DAO)
            // Esto es solo un ejemplo, los datos deben venir de tu BD.
            int totalUsuarios = 150; // Reemplazar por dao.contarUsuarios()
            double ventasMes = 15432.50; // Reemplazar por dao.calcularVentasMes()
            int productosAgotados = 5; // Reemplazar por dao.contarProductosAgotados()

            // Asumiendo que tienes un método que retorna una lista de Productos más vendidos para el gráfico.
            // List<ProductoMasVendido> productosVendidos = new VentaDAO().obtenerProductosMasVendidos();
            
            // Coloca los datos en el request para que el JSP los use
            request.setAttribute("totalUsuarios", totalUsuarios);
            request.setAttribute("ventasMes", ventasMes);
            request.setAttribute("productosAgotados", productosAgotados);
            // request.setAttribute("productosVendidos", productosVendidos); // Para el gráfico

            request.setAttribute("nombre", usuario.getNombre());
            request.getRequestDispatcher("/vistas/admin/dashboard.jsp").forward(request, response);
            
        } else {
            // Si hay otras acciones
        }
    } catch (Exception e) {
        // Manejo de errores
        e.printStackTrace();
        request.setAttribute("error", "Error al cargar dashboard: " + e.getMessage());
        request.getRequestDispatcher("/mensaje.jsp").forward(request, response);
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
}
