package Controladores;

import Modelo.Carrito;
import Modelo.CarritoDAO;
import Modelo.Inventario;
import Modelo.InventarioDAO;
import Modelo.ProductoClienteDAO;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet(name = "srvCarrito", urlPatterns = {"/srvCarrito"})
public class srvCarrito extends HttpServlet {

    // ✅ USA SOLO CarritoDAO
    private final CarritoDAO carritoDAO = new CarritoDAO();

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String accion = request.getParameter("accion");
        if (accion == null) {
            accion = "listar";
        }

        try {
            switch (accion) {
                case "agregar":
                    agregar(request, response);
                    break;
                case "actualizar":
                    actualizar(request, response);
                    break;
                case "eliminar":
                    eliminar(request, response);
                    break;
                case "vaciar":
                    vaciar(request, response);
                    break;

            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/error.jsp");
        }
    }

    private void agregar(HttpServletRequest request, HttpServletResponse response) throws Exception {
        HttpSession session = request.getSession();

        Integer idCliente = (Integer) session.getAttribute("idCliente");

        if (idCliente == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        try {
            int idInventario = Integer.parseInt(request.getParameter("idInventario"));
            int cantidadSolicitada = Integer.parseInt(request.getParameter("cantidad"));

            // ✅ NUEVO: Verificar stock disponible ANTES de agregar
            InventarioDAO inventarioDAO = new InventarioDAO();
            Inventario inventario = inventarioDAO.obtenerPorId(idInventario);

            if (inventario == null) {
                session.setAttribute("tipoMensaje", "error");
                session.setAttribute("mensaje", "El producto seleccionado no existe");
                response.sendRedirect(request.getHeader("Referer"));
                return;
            }

            if (inventario.getStock() < cantidadSolicitada) {
                session.setAttribute("tipoMensaje", "warning");
                session.setAttribute("mensaje", "Stock insuficiente. Solo hay " + inventario.getStock() + " unidades disponibles");
                response.sendRedirect(request.getHeader("Referer"));
                return;
            }

            // ✅ Agregar al carrito en BD
            CarritoDAO carritoDAO = new CarritoDAO();
            boolean agregado = carritoDAO.agregarAlCarrito(idCliente, idInventario, cantidadSolicitada);

            if (agregado) {
                // ✅ NUEVO: Reducir el stock del inventario
                boolean stockActualizado = inventarioDAO.reducirStock(idInventario, cantidadSolicitada);

                if (!stockActualizado) {
                    session.setAttribute("tipoMensaje", "error");
                    session.setAttribute("mensaje", "Error al actualizar el stock");
                    response.sendRedirect(request.getHeader("Referer"));
                    return;
                }

                // Actualizar sesión
                List<Carrito> itemsCarrito = carritoDAO.obtenerCarritoCliente(idCliente);
                int totalItems = carritoDAO.contarItemsCarrito(idCliente);
                double total = carritoDAO.calcularTotalCarrito(idCliente);

                session.setAttribute("itemsCarrito", itemsCarrito);
                session.setAttribute("totalItems", totalItems);
                session.setAttribute("totalCarrito", total);

                // ✅ Mensaje de éxito
                session.setAttribute("tipoMensaje", "success");
                session.setAttribute("mensaje", "¡Producto agregado al carrito exitosamente!");

            } else {
                session.setAttribute("tipoMensaje", "error");
                session.setAttribute("mensaje", "Error al agregar producto al carrito");
            }

        } catch (NumberFormatException e) {
            e.printStackTrace();
            session.setAttribute("tipoMensaje", "error");
            session.setAttribute("mensaje", "Datos inválidos. Por favor intenta nuevamente");
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("tipoMensaje", "error");
            session.setAttribute("mensaje", "Error: " + e.getMessage());
        }

        String referer = request.getHeader("Referer");
        response.sendRedirect(referer != null ? referer : request.getContextPath() + "/srvCatalogo");

    }

    private void actualizar(HttpServletRequest request, HttpServletResponse response) throws Exception {
        int idCarrito = Integer.parseInt(request.getParameter("idCarrito"));
        int nuevaCantidad = Integer.parseInt(request.getParameter("cantidad"));

        HttpSession session = request.getSession();

        // Obtener el item actual
        CarritoDAO carritoDAO = new CarritoDAO();
        Carrito itemActual = carritoDAO.obtenerItemPorId(idCarrito);

        if (itemActual != null) {
            int cantidadAnterior = itemActual.getCantidad();
            int diferencia = nuevaCantidad - cantidadAnterior;

            // Verificar stock disponible
            InventarioDAO inventarioDAO = new InventarioDAO();
            Inventario inventario = inventarioDAO.obtenerPorId(itemActual.getIdInventario());

            if (diferencia > 0) {
                // Aumentar cantidad - verificar si hay stock
                if (inventario.getStock() < diferencia) {
                    session.setAttribute("tipoMensaje", "warning");
                    session.setAttribute("mensaje", "Stock insuficiente. Solo quedan " + inventario.getStock() + " unidades");
                    response.sendRedirect(request.getHeader("Referer"));
                    return;
                }
                // Reducir stock
                inventarioDAO.reducirStock(itemActual.getIdInventario(), diferencia);
            } else if (diferencia < 0) {
                // Disminuir cantidad - devolver stock
                inventarioDAO.aumentarStock(itemActual.getIdInventario(), Math.abs(diferencia));
            }

            // Actualizar cantidad en carrito
            carritoDAO.actualizarCantidad(idCarrito, nuevaCantidad);

            session.setAttribute("tipoMensaje", "success");
            session.setAttribute("mensaje", "Cantidad actualizada correctamente");
        }

        // Actualizar sesión
        Integer idCliente = (Integer) session.getAttribute("idCliente");
        if (idCliente != null) {
            List<Carrito> itemsCarrito = carritoDAO.obtenerCarritoCliente(idCliente);
            session.setAttribute("itemsCarrito", itemsCarrito);
            session.setAttribute("totalItems", carritoDAO.contarItemsCarrito(idCliente));
            session.setAttribute("totalCarrito", carritoDAO.calcularTotalCarrito(idCliente));
        }

        String referer = request.getHeader("Referer");
        response.sendRedirect(referer != null ? referer : request.getContextPath() + "/srvCatalogo?accion=catalogo");
    }

    private void eliminar(HttpServletRequest request, HttpServletResponse response) throws Exception {
        int idCarrito = Integer.parseInt(request.getParameter("idCarrito"));
        // Obtener los datos del item ANTES de eliminarlo
        CarritoDAO carritoDAO = new CarritoDAO();
        Carrito item = carritoDAO.obtenerItemPorId(idCarrito);

        if (item != null) {
            // Eliminar del carrito
            boolean eliminado = carritoDAO.eliminarItem(idCarrito);

            if (eliminado) {
                // Devolver el stock al inventario
                InventarioDAO inventarioDAO = new InventarioDAO();
                inventarioDAO.aumentarStock(item.getIdInventario(), item.getCantidad());

                // Mensaje de éxito
                HttpSession session = request.getSession();
                session.setAttribute("tipoMensaje", "info");
                session.setAttribute("mensaje", "Producto eliminado del carrito y stock actualizado");
            }
        }

        // Actualizar sesión
        HttpSession session = request.getSession();
        Integer idCliente = (Integer) session.getAttribute("idCliente");
        if (idCliente != null) {
            List<Carrito> itemsCarrito = carritoDAO.obtenerCarritoCliente(idCliente);
            session.setAttribute("itemsCarrito", itemsCarrito);
            session.setAttribute("totalItems", carritoDAO.contarItemsCarrito(idCliente));
            session.setAttribute("totalCarrito", carritoDAO.calcularTotalCarrito(idCliente));
        }

        // ✅ Redirigir al catálogo si el carrito queda vacío
        String referer = request.getHeader("Referer");
        if (referer != null && !referer.isEmpty()) {
            response.sendRedirect(referer);
        } else {
            response.sendRedirect(request.getContextPath() + "/srvCatalogo?accion=catalogo");
        }

    }

    private void vaciar(HttpServletRequest request, HttpServletResponse response) throws Exception {
        HttpSession session = request.getSession();
        Integer idCliente = (Integer) session.getAttribute("idCliente");

        if (idCliente != null) {
            // ✅ NUEVO: Obtener todos los items ANTES de vaciar para devolver el stock
            CarritoDAO carritoDAO = new CarritoDAO();
            List<Carrito> itemsAEliminar = carritoDAO.obtenerCarritoCliente(idCliente);

            // Devolver el stock de cada item al inventario
            InventarioDAO inventarioDAO = new InventarioDAO();
            for (Carrito item : itemsAEliminar) {
                inventarioDAO.aumentarStock(item.getIdInventario(), item.getCantidad());
            }

            // Vaciar el carrito
            carritoDAO.vaciarCarrito(idCliente);

            // Limpiar sesión
            session.setAttribute("itemsCarrito", new ArrayList<>());
            session.setAttribute("totalItems", 0);
            session.setAttribute("totalCarrito", 0.0);

            // ✅ Mensaje de confirmación
            session.setAttribute("tipoMensaje", "success");
            session.setAttribute("mensaje", "Carrito vaciado exitosamente");
        }

        // ✅ REDIRIGIR AL CATÁLOGO en lugar de a la página de carrito
        response.sendRedirect(request.getContextPath() + "/srvCatalogo?accion=catalogo");
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
