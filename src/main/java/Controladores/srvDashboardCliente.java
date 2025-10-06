package Controladores;
import java.io.IOException;
import java.util.List;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

// Importaciones de tus Modelos y DAOs (Ajustar a tus nombres reales)
// import com.modelo.Producto;
// import com.dao.ProductoDAO;
// import com.modelo.Inventario;
// import com.dao.InventarioDAO;

@WebServlet(name = "srvDashboardCliente", urlPatterns = {"/srvDashboardCliente"})
public class srvDashboardCliente extends HttpServlet {

    // Simulación de DAOs y Modelos (REEMPLAZAR con tu lógica real de base de datos)
    // ProductoDAO productoDAO = new ProductoDAO();
    // InventarioDAO inventarioDAO = new InventarioDAO();

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("text/html;charset=UTF-8");
        String accion = request.getParameter("accion");

        try {
            if (accion == null || accion.equals("dashboard")) {
                mostrarCatalogo(request, response);
            } 
            // Aquí puedes agregar otras acciones si el cliente navega a "Mis Pedidos", etc.
            
        } catch (Exception e) {
            e.printStackTrace();
            // Manejo de errores
            request.setAttribute("error", "Error al cargar la tienda: " + e.getMessage());
            request.getRequestDispatcher("/mensaje.jsp").forward(request, response);
        }
    }

    private void mostrarCatalogo(HttpServletRequest request, HttpServletResponse response) throws Exception {
        // --- 1. Obtener la lista de productos ---
        // List<Producto> listaProductos = productoDAO.listarTodosLosProductosActivos(); 
        
        // --- SIMULACIÓN DE DATOS (REEMPLAZAR CON TU DAO REAL) ---
        List<Map<String, Object>> listaProductos = List.of(
            Map.of("idProducto", 1, "nombre", "Camiseta Deportiva", "nombreCategoria", "Ropa", "precio", 25.50, "imagenUrl", "dist/img/prod1.jpg"),
            Map.of("idProducto", 2, "nombre", "Zapatillas Urbanas", "nombreCategoria", "Calzado", "precio", 89.90, "imagenUrl", "dist/img/prod2.jpg"),
            Map.of("idProducto", 3, "nombre", "Gorra Negra Casual", "nombreCategoria", "Accesorios", "precio", 15.00, "imagenUrl", "dist/img/prod3.jpg"),
            Map.of("idProducto", 4, "nombre", "Pantalón Denim Slim", "nombreCategoria", "Ropa", "precio", 55.00, "imagenUrl", "dist/img/prod4.jpg")
        );
        
        // --- 2. Obtener los inventarios por producto (para el stock) ---
        // Map<Integer, List<Inventario>> inventariosPorProducto = inventarioDAO.obtenerInventarioPorProducto(listaProductos);
        
        // --- SIMULACIÓN DE INVENTARIO (REEMPLAZAR CON TU DAO REAL) ---
        Map<Integer, List<Map<String, Object>>> inventariosPorProducto = Map.of(
            1, List.of(Map.of("talla", "M", "color", "Rojo", "stock", 10, "estado", "Activo"), Map.of("talla", "L", "color", "Rojo", "stock", 0, "estado", "Activo")), // Stock total: 10
            2, List.of(Map.of("talla", "40", "color", "Blanco", "stock", 5, "estado", "Activo")), // Stock total: 5
            3, List.of(Map.of("talla", "Única", "color", "Negro", "stock", 2, "estado", "Activo")), // Stock total: 2
            4, List.of(Map.of("talla", "32", "color", "Azul", "stock", 0, "estado", "Activo")) // Stock total: 0 (Agotado)
        );

        // 3. Enviar al JSP
        request.setAttribute("listaProductos", listaProductos);
        request.setAttribute("inventariosPorProducto", inventariosPorProducto);
        
        // El JSP de la tienda es el dashboard del cliente
        request.setAttribute("pageActive", "tienda"); // Para activar el menú en el sidebar
        request.getRequestDispatcher("/vistas/cliente/dashboard.jsp").forward(request, response);
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