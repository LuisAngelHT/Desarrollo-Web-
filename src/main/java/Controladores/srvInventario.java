package Controladores;

import Modelo.Inventario;
import Modelo.InventarioDAO;
import Modelo.Producto;
import Modelo.ProductoDAO;

import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet(name = "srvInventario", urlPatterns = {"/srvInventario"})
public class srvInventario extends HttpServlet {

    private final InventarioDAO inventarioDAO = new InventarioDAO();
    private final ProductoDAO productoDAO = new ProductoDAO();

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
                case "guardar":
                    guardar(request, response);
                    break;
                case "actualizar":
                    actualizar(request, response);
                    break;
                case "eliminar":
                    eliminar(request, response);
                    break;
                default:
                    listar(request, response);
                    break;
            }
        } catch (Exception e) {
            throw new ServletException("Error en inventario", e);
        }
    }

    private void listar(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String idStr = request.getParameter("idProducto");
        if (idStr == null) {
            throw new ServletException("Producto no especificado");
        }
        int idProducto = Integer.parseInt(idStr);

        List<Inventario> listaInventario = inventarioDAO.listarPorProducto(idProducto);
        Producto producto = productoDAO.listar().stream()
                .filter(p -> p.getIdProducto() == idProducto)
                .findFirst().orElse(null);

        request.setAttribute("producto", producto);
        request.setAttribute("listaInventario", listaInventario);
        request.getRequestDispatcher("/vistas/vendedor/inventario.jsp").forward(request, response);
    }

    private void guardar(HttpServletRequest request, HttpServletResponse response) throws Exception {
        Inventario inv = obtenerInventario(request);
        inventarioDAO.insertar(inv);
        response.sendRedirect("srvInventario?accion=listar&idProducto=" + inv.getIdProducto());
    }

    private void actualizar(HttpServletRequest request, HttpServletResponse response) throws Exception {
        Inventario inv = obtenerInventario(request);
        inv.setIdInventario(Integer.parseInt(request.getParameter("idInventario")));
        inventarioDAO.actualizar(inv);
        response.sendRedirect("srvInventario?accion=listar&idProducto=" + inv.getIdProducto());
    }

    private void eliminar(HttpServletRequest request, HttpServletResponse response) throws Exception {
        int idInventario = Integer.parseInt(request.getParameter("idInventario"));
        int idProducto = Integer.parseInt(request.getParameter("idProducto"));
        inventarioDAO.eliminar(idInventario);
        response.sendRedirect("srvInventario?accion=listar&idProducto=" + idProducto);
    }

    private Inventario obtenerInventario(HttpServletRequest request) {
        Inventario inv = new Inventario();
        inv.setIdProducto(Integer.parseInt(request.getParameter("idProducto")));
        inv.setTalla(request.getParameter("talla"));
        inv.setColor(request.getParameter("color"));
        inv.setStock(Integer.parseInt(request.getParameter("stock")));
        inv.setEstado(request.getParameter("estado"));
        return inv;
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
