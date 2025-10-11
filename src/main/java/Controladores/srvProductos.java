package Controladores;

import Modelo.Producto;
import Modelo.ProductoDAO;
import Modelo.Categoria;
import Modelo.CategoriaDAO;
import Modelo.Inventario;
import Modelo.InventarioDAO;

import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet(name = "srvProductos", urlPatterns = {"/srvProductos"})
@MultipartConfig
public class srvProductos extends HttpServlet {

    private final ProductoDAO productoDAO = new ProductoDAO();
    private final CategoriaDAO categoriaDAO = new CategoriaDAO();
    private final InventarioDAO inventarioDAO = new InventarioDAO();

    private static final int REGISTROS_POR_PAGINA = 8;

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
                case "filtrar":
                    filtrar(request, response);
                    break;
                default:
                    listar(request, response);
                    break;
            }
        } catch (Exception e) {
            throw new ServletException("Error en productos", e);
        }
    }

    private void listar(HttpServletRequest request, HttpServletResponse response) throws Exception {
        // Obtener número de página
        String paginaParam = request.getParameter("pagina");
        int paginaActual = (paginaParam != null) ? Integer.parseInt(paginaParam) : 1;

        // Obtener productos paginados
        List<Producto> listaProductos = productoDAO.listarPaginado(paginaActual, REGISTROS_POR_PAGINA);
        List<Categoria> listaCategorias = categoriaDAO.listar();

        // Cargar inventarios
        Map<Integer, List<Inventario>> inventariosPorProducto = new HashMap<>();
        for (Producto p : listaProductos) {
            List<Inventario> inventarios = inventarioDAO.listarPorProducto(p.getIdProducto());
            inventariosPorProducto.put(p.getIdProducto(), inventarios);
        }

        // Calcular paginación
        int totalProductos = productoDAO.contarTotal();
        int totalPaginas = (int) Math.ceil((double) totalProductos / REGISTROS_POR_PAGINA);

        // Enviar atributos
        request.setAttribute("listaProductos", listaProductos);
        request.setAttribute("listaCategorias", listaCategorias);
        request.setAttribute("inventariosPorProducto", inventariosPorProducto);
        request.setAttribute("paginaActual", paginaActual);
        request.setAttribute("totalPaginas", totalPaginas);
        request.setAttribute("totalProductos", totalProductos);

        request.getRequestDispatcher("/vistas/vendedor/productos.jsp").forward(request, response);
    }

    private void guardar(HttpServletRequest request, HttpServletResponse response) throws Exception {
        HttpSession session = request.getSession();
        try {
            Producto p = obtenerProducto(request);
            productoDAO.insertar(p);
            session.setAttribute("exito", "Producto guardado correctamente.");
        } catch (Exception e) {
            session.setAttribute("error", "Error al guardar el producto.");
            e.printStackTrace(); // Opcional: para depuración
        }
        response.sendRedirect("srvProductos?accion=listar");
    }

    private void actualizar(HttpServletRequest request, HttpServletResponse response) throws Exception {
        HttpSession session = request.getSession();
        try {
            Producto p = obtenerProducto(request);
            String idStr = request.getParameter("id");
            if (idStr == null || idStr.isEmpty()) {
                session.setAttribute("error", "ID de producto no proporcionado.");
                response.sendRedirect("srvProductos?accion=listar");
                return;
            }
            p.setIdProducto(Integer.parseInt(idStr));
            productoDAO.actualizar(p);
            session.setAttribute("exito", "Producto actualizado correctamente.");
        } catch (Exception e) {
            session.setAttribute("error", "Error al actualizar el producto.");
            e.printStackTrace();
        }
        response.sendRedirect("srvProductos?accion=listar");
    }

    private void eliminar(HttpServletRequest request, HttpServletResponse response) throws Exception {
        HttpSession session = request.getSession();
        try {
            String idStr = request.getParameter("id");
            if (idStr == null || idStr.isEmpty()) {
                session.setAttribute("error", "ID de producto no proporcionado.");
                response.sendRedirect("srvProductos?accion=listar");
                return;
            }
            int id = Integer.parseInt(idStr);
            productoDAO.eliminar(id);
            session.setAttribute("exito", "Producto eliminado correctamente.");
        } catch (Exception e) {
            session.setAttribute("error", "Error al eliminar el producto.");
            e.printStackTrace();
        }
        response.sendRedirect("srvProductos?accion=listar");
    }

    private Producto obtenerProducto(HttpServletRequest request) throws Exception {
        Producto p = new Producto();

        p.setNombre(request.getParameter("nombre"));
        p.setDescripcion(request.getParameter("descripcion"));

        String precioStr = request.getParameter("precio");
        if (precioStr == null || precioStr.isEmpty()) {
            throw new ServletException("Precio no proporcionado");
        }
        p.setPrecio(Double.parseDouble(precioStr));

        String idCatStr = request.getParameter("idCategoria");
        if (idCatStr == null || idCatStr.isEmpty()) {
            throw new ServletException("Categoría no proporcionada");
        }
        p.setIdCategoria(Integer.parseInt(idCatStr));

        // Manejo de imagen
        Part archivo = request.getPart("imagen");
        String nombreArchivo = Paths.get(archivo.getSubmittedFileName()).getFileName().toString();

        if (!nombreArchivo.isEmpty()) {
            String rutaServidor = getServletContext().getRealPath("/imagenes");
            File carpeta = new File(rutaServidor);
            if (!carpeta.exists()) {
                carpeta.mkdirs();
            }

            String rutaFinal = rutaServidor + File.separator + nombreArchivo;
            archivo.write(rutaFinal);

            p.setImagenUrl("imagenes/" + nombreArchivo);
        } else {
            // Si no se sube imagen nueva, conservar la actual si viene desde edición
            String imagenActual = request.getParameter("imagenUrl");
            p.setImagenUrl(imagenActual != null ? imagenActual : "");
        }

        return p;
    }

    private void filtrar(HttpServletRequest request, HttpServletResponse response) throws Exception {
        HttpSession session = request.getSession();
        try {
            String nombre = request.getParameter("nombre");
            String idCatStr = request.getParameter("idCategoria");
            String paginaParam = request.getParameter("pagina");

            int paginaActual = (paginaParam != null) ? Integer.parseInt(paginaParam) : 1;

            Integer idCategoria = null;
            if (idCatStr != null && !idCatStr.isEmpty()) {
                idCategoria = Integer.parseInt(idCatStr);
            }

            // Obtener productos filtrados con paginación
            List<Producto> productosFiltrados = productoDAO.filtrarPaginado(nombre, idCategoria, paginaActual, REGISTROS_POR_PAGINA);

            // Cargar inventarios
            Map<Integer, List<Inventario>> inventariosPorProducto = new HashMap<>();
            for (Producto p : productosFiltrados) {
                List<Inventario> inventarios = inventarioDAO.listarPorProducto(p.getIdProducto());
                inventariosPorProducto.put(p.getIdProducto(), inventarios);
            }

            // Calcular paginación para filtros
            int totalProductos = productoDAO.contarFiltrados(nombre, idCategoria);
            int totalPaginas = (int) Math.ceil((double) totalProductos / REGISTROS_POR_PAGINA);

            if (productosFiltrados.isEmpty()) {
                session.setAttribute("warning", "No se encontraron productos.");
            }

            request.setAttribute("listaProductos", productosFiltrados);
            request.setAttribute("listaCategorias", categoriaDAO.listar());
            request.setAttribute("inventariosPorProducto", inventariosPorProducto);
            request.setAttribute("paginaActual", paginaActual);
            request.setAttribute("totalPaginas", totalPaginas);
            request.setAttribute("totalProductos", totalProductos);

            // Mantener parámetros de filtro para la paginación
            request.setAttribute("filtroNombre", nombre);
            request.setAttribute("filtroCategoria", idCategoria);

            request.getRequestDispatcher("/vistas/vendedor/productos.jsp").forward(request, response);

        } catch (Exception e) {
            session.setAttribute("error", "Error al aplicar el filtro.");
            response.sendRedirect("srvProductos?accion=listar");
            e.printStackTrace();
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
        return "Servlet para gestión de productos con imagen e inventario";
    }
}
