package Controladores;

import Modelo.CatalogoProductoDAO;
import Modelo.Producto;
import Modelo.Inventario;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet(name = "srvCatalogo", urlPatterns = {"/srvCatalogo"})
public class srvCatalogo extends HttpServlet {

    private final CatalogoProductoDAO catalogoDAO = new CatalogoProductoDAO();

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String accion = request.getParameter("accion");
        if (accion == null) {
            accion = "listar";
        }

        try {
            switch (accion) {
                case "listar":
                    listar(request, response);
                    break;
                case "buscar":
                    buscar(request, response);
                    break;
                default:
                    listar(request, response);
                    break;
            }
        } catch (Exception e) {
            throw new ServletException("Error en catálogo de productos", e);
        }
    }

    private void listar(HttpServletRequest request, HttpServletResponse response) throws Exception {
        // Obtener todos los productos
        List<Producto> listaProductos = catalogoDAO.listarProductos();

        // Map para inventarios por producto
        Map<Integer, List<Inventario>> inventariosPorProducto = new HashMap<>();
        for (Producto p : listaProductos) {
            inventariosPorProducto.put(p.getIdProducto(),
                    catalogoDAO.obtenerInventariosPorProducto(p.getIdProducto()));
        }

        request.setAttribute("listaProductos", listaProductos);
        request.setAttribute("inventariosPorProducto", inventariosPorProducto);

        request.getRequestDispatcher("/vistas/cliente/catalogoProductos.jsp").forward(request, response);
    }

    private void buscar(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String criterio = request.getParameter("criterio");
        if (criterio == null) criterio = "";

        List<Producto> listaProductos = catalogoDAO.buscarProductos(criterio);

        Map<Integer, List<Inventario>> inventariosPorProducto = new HashMap<>();
        for (Producto p : listaProductos) {
            inventariosPorProducto.put(p.getIdProducto(),
                    catalogoDAO.obtenerInventariosPorProducto(p.getIdProducto()));
        }

        request.setAttribute("listaProductos", listaProductos);
        request.setAttribute("inventariosPorProducto", inventariosPorProducto);
        request.setAttribute("criterio", criterio);

        request.getRequestDispatcher("/vistas/cliente/catalogoProductos.jsp").forward(request, response);
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
