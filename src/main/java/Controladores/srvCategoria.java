package Controladores;

import Modelo.Categoria;
import Modelo.CategoriaDAO;

import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet(name = "srvCategoria", urlPatterns = {"/srvCategoria"})
public class srvCategoria extends HttpServlet {

    private final CategoriaDAO categoriaDAO = new CategoriaDAO();

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
                case "eliminar":
                    eliminar(request, response);
                    break;
                case "actualizar":
                    actualizar(request, response);
                    break;
                default:
                    listar(request, response);
                    break;
            }
        } catch (Exception e) {
            throw new ServletException("Error en categorías", e);
        }
    }

    private void listar(HttpServletRequest request, HttpServletResponse response) throws Exception {
        List<Categoria> listaCategorias = categoriaDAO.listar();
        request.setAttribute("listaCategorias", listaCategorias);
        request.getRequestDispatcher("/vistas/vendedor/categorias.jsp").forward(request, response);
    }

    private void guardar(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String nombre = request.getParameter("nombre").trim();
        String descripcion = request.getParameter("descripcion");

        HttpSession session = request.getSession();

        if (categoriaDAO.existe(nombre)) {
            session.setAttribute("error", "Ya existe una categoría con ese nombre.");
            response.sendRedirect("srvCategoria?accion=listar");
            return;
        }

        Categoria c = new Categoria();
        c.setNombreCategoria(nombre);
        c.setDescripcion(descripcion);

        categoriaDAO.guardar(c);
        session.setAttribute("exito", "Categoría guardada correctamente.");
        response.sendRedirect("srvCategoria?accion=listar");
    }

    private void actualizar(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String idStr = request.getParameter("idCategoria");
        if (idStr == null || idStr.isEmpty()) {
            throw new ServletException("ID de categoría no proporcionado");
        }

        int idCategoria = Integer.parseInt(idStr);
        String nombre = request.getParameter("nombre").trim();
        String descripcion = request.getParameter("descripcion");

        HttpSession session = request.getSession();

        Categoria actual = categoriaDAO.obtenerPorId(idCategoria);
        if (actual == null) {
            session.setAttribute("error", "La categoría no existe.");
            response.sendRedirect("srvCategoria?accion=listar");
            return;
        }

        if (categoriaDAO.existe(nombre) && !actual.getNombreCategoria().equalsIgnoreCase(nombre)) {
            session.setAttribute("error", "Ya existe otra categoría con ese nombre.");
            response.sendRedirect("srvCategoria?accion=listar");
            return;
        }

        Categoria c = new Categoria();
        c.setIdCategoria(idCategoria);
        c.setNombreCategoria(nombre);
        c.setDescripcion(descripcion);

        categoriaDAO.actualizar(c);
        session.setAttribute("exito", "Categoría actualizada correctamente.");
        response.sendRedirect("srvCategoria?accion=listar");
    }

    private void eliminar(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String idStr = request.getParameter("idCategoria");
        if (idStr == null || idStr.isEmpty()) {
            throw new ServletException("ID de categoría no proporcionado");
        }

        int idCategoria = Integer.parseInt(idStr);

        HttpSession session = request.getSession();
        if (categoriaDAO.tieneProductos(idCategoria)) {
            session.setAttribute("error", "No se puede eliminar la categoría porque está asociada a productos.");
            response.sendRedirect("srvCategoria?accion=listar");
            return;
        }

        categoriaDAO.eliminar(idCategoria);
        session.setAttribute("exito", "Categoría eliminada correctamente.");
        response.sendRedirect("srvCategoria?accion=listar");
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
