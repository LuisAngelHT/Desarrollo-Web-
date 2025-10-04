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
                case "generarCombinaciones":
                    generarCombinaciones(request, response);
                    break;
                case "eliminarTodas":  // CORREGIDO: era "eliminarTodo"
                    eliminarTodas(request, response);
                    break;
                default:
                    listar(request, response);
                    break;
            }
        } catch (Exception e) {
            HttpSession session = request.getSession();
            session.setAttribute("error", "Error: " + e.getMessage());
            response.sendRedirect("srvProductos?accion=listar");
        }
    }

    private void listar(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String idStr = request.getParameter("idProducto");
        if (idStr == null || idStr.trim().isEmpty()) {
            throw new ServletException("Producto no especificado");
        }
        
        int idProducto = Integer.parseInt(idStr);

        List<Inventario> listaInventario = inventarioDAO.listarPorProducto(idProducto);
        Producto producto = productoDAO.listar().stream()
                .filter(p -> p.getIdProducto() == idProducto)
                .findFirst().orElse(null);

        if (producto == null) {
            throw new ServletException("Producto no encontrado");
        }

        request.setAttribute("producto", producto);
        request.setAttribute("listaInventario", listaInventario);
        request.getRequestDispatcher("/vistas/vendedor/inventario.jsp").forward(request, response);
    }

    private void guardar(HttpServletRequest request, HttpServletResponse response) throws Exception {
        Inventario inv = obtenerInventario(request);
        HttpSession session = request.getSession();

        // Validar datos
        if (inv.getTalla().trim().isEmpty() || inv.getColor().trim().isEmpty()) {
            session.setAttribute("error", "La talla y el color no pueden estar vacíos.");
            response.sendRedirect("srvInventario?accion=listar&idProducto=" + inv.getIdProducto());
            return;
        }

        if (inventarioDAO.existeCombinacion(inv.getIdProducto(), inv.getTalla(), inv.getColor())) {
            session.setAttribute("error", "La combinación ya existe: " + inv.getTalla() + " / " + inv.getColor());
        } else {
            inventarioDAO.insertar(inv);
            session.setAttribute("exito", "Combinación agregada correctamente.");
        }

        response.sendRedirect("srvInventario?accion=listar&idProducto=" + inv.getIdProducto());
    }

    private void actualizar(HttpServletRequest request, HttpServletResponse response) throws Exception {
        Inventario inv = obtenerInventario(request);
        int idInventario = Integer.parseInt(request.getParameter("idInventario"));
        inv.setIdInventario(idInventario);

        HttpSession session = request.getSession();

        // Validar datos
        if (inv.getTalla().trim().isEmpty() || inv.getColor().trim().isEmpty()) {
            session.setAttribute("error", "La talla y el color no pueden estar vacíos.");
            response.sendRedirect("srvInventario?accion=listar&idProducto=" + inv.getIdProducto());
            return;
        }

        boolean duplicado = inventarioDAO.existeCombinacionDuplicada(
                inv.getIdProducto(), inv.getTalla(), inv.getColor(), idInventario
        );

        if (duplicado) {
            session.setAttribute("error", "Ya existe otra combinación con talla " + inv.getTalla()
                    + " y color " + inv.getColor() + " para este producto.");
        } else {
            inventarioDAO.actualizar(inv);
            session.setAttribute("exito", "Combinación actualizada correctamente.");
        }

        response.sendRedirect("srvInventario?accion=listar&idProducto=" + inv.getIdProducto());
    }

    private void eliminar(HttpServletRequest request, HttpServletResponse response) throws Exception {
        int idInventario = Integer.parseInt(request.getParameter("idInventario"));
        int idProducto = Integer.parseInt(request.getParameter("idProducto"));

        inventarioDAO.eliminar(idInventario);

        HttpSession session = request.getSession();
        session.setAttribute("exito", "Combinación eliminada correctamente.");
        response.sendRedirect("srvInventario?accion=listar&idProducto=" + idProducto);
    }

    private Inventario obtenerInventario(HttpServletRequest request) {
        Inventario inv = new Inventario();
        inv.setIdProducto(Integer.parseInt(request.getParameter("idProducto")));
        inv.setTalla(request.getParameter("talla").trim());
        inv.setColor(request.getParameter("color").trim());
        inv.setStock(Integer.parseInt(request.getParameter("stock")));
        inv.setEstado(request.getParameter("estado"));
        return inv;
    }

    private void generarCombinaciones(HttpServletRequest request, HttpServletResponse response) throws Exception {
        int idProducto = Integer.parseInt(request.getParameter("idProducto"));
        String[] tallas = request.getParameterValues("talla[]");
        String[] colores = request.getParameterValues("color[]");
        
        HttpSession session = request.getSession();

        // Validar que los arrays no sean nulos o vacíos
        if (tallas == null || tallas.length == 0 || colores == null || colores.length == 0) {
            session.setAttribute("error", "Debe ingresar al menos una talla y un color.");
            response.sendRedirect("srvInventario?accion=listar&idProducto=" + idProducto);
            return;
        }

        int stock = Integer.parseInt(request.getParameter("stock"));
        String estado = request.getParameter("estado");

        int creadas = 0;
        int duplicadas = 0;

        for (String talla : tallas) {
            talla = talla.trim();
            if (talla.isEmpty()) continue; // Saltar tallas vacías

            for (String color : colores) {
                color = color.trim();
                if (color.isEmpty()) continue; // Saltar colores vacíos

                if (inventarioDAO.existeCombinacion(idProducto, talla, color)) {
                    duplicadas++;
                    continue;
                }

                Inventario inv = new Inventario();
                inv.setIdProducto(idProducto);
                inv.setTalla(talla);
                inv.setColor(color);
                inv.setStock(stock);
                inv.setEstado(estado);
                inventarioDAO.insertar(inv);
                creadas++;
            }
        }

        if (creadas == 0 && duplicadas == 0) {
            session.setAttribute("error", "No se pudo generar ninguna combinación. Verifica los datos ingresados.");
        } else {
            session.setAttribute("exito", "Se generaron " + creadas + " combinación(es)."
                    + (duplicadas > 0 ? " " + duplicadas + " ya existían." : ""));
        }

        response.sendRedirect("srvInventario?accion=listar&idProducto=" + idProducto);
    }

    private void eliminarTodas(HttpServletRequest request, HttpServletResponse response) throws Exception {
        int idProducto = Integer.parseInt(request.getParameter("idProducto"));
        int eliminadas = inventarioDAO.eliminarPorProducto(idProducto);

        HttpSession session = request.getSession();
        if (eliminadas > 0) {
            session.setAttribute("exito", "Se eliminaron " + eliminadas + " combinación(es).");
        } else {
            session.setAttribute("info", "No había combinaciones para eliminar.");
        }
        
        response.sendRedirect("srvInventario?accion=listar&idProducto=" + idProducto);
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