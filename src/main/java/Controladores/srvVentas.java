package Controladores;

import Modelo.Venta;
import Modelo.ItemVenta;
import Modelo.Carrito;
import Modelo.CarritoDAO;
import Modelo.VentaDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;

import com.itextpdf.text.*;
import com.itextpdf.text.pdf.*;

@WebServlet(name = "srvVentas", urlPatterns = {"/srvVentas"})
public class srvVentas extends HttpServlet {

    private final VentaDAO ventaDAO = new VentaDAO();
    private final CarritoDAO carritoDAO = new CarritoDAO();

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String accion = request.getParameter("accion");

        try {
            if ("generarBoleta".equals(accion)) {
                generarBoleta(request, response);
            } else if ("listar".equals(accion)) {
                listarVentas(request, response);
            } else if ("buscar".equals(accion)) {
                buscarVentas(request, response);
            } else if ("filtrar".equals(accion)) {
                filtrarPorEstado(request, response);
            } else if ("ver".equals(accion)) {
                verDetalle(request, response);
            } else if ("descargarBoleta".equals(accion)) {
                descargarBoleta(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/srvCatalogo");
            }
        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException("Error en ventas", e);
        }
    }

    private void generarBoleta(HttpServletRequest request, HttpServletResponse response) throws Exception {
        HttpSession session = request.getSession();
        Integer idCliente = (Integer) session.getAttribute("idCliente");

        System.out.println("=== INICIANDO GENERACIÓN DE BOLETA ===");
        System.out.println("idCliente: " + idCliente);

        if (idCliente == null) {
            System.out.println("ERROR: Cliente no autenticado");
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        List<Carrito> items = carritoDAO.obtenerCarritoCliente(idCliente);
        System.out.println("Items en carrito: " + items.size());

        if (items.isEmpty()) {
            System.out.println("ERROR: Carrito vacío");
            session.setAttribute("tipoMensaje", "warning");
            session.setAttribute("mensaje", "El carrito está vacío");
            response.sendRedirect(request.getContextPath() + "/srvCatalogo");
            return;
        }

        double total = carritoDAO.calcularTotalCarrito(idCliente);
        System.out.println("Total de la venta: " + total);

        System.out.println("Registrando venta en BD...");
        int idVenta = ventaDAO.registrarVenta(idCliente, items, total);
        System.out.println("ID Venta generado: " + idVenta);

        if (idVenta > 0) {
            System.out.println("Vaciando carrito...");
            carritoDAO.vaciarCarrito(idCliente);

            // ✅ LIMPIAR SESIÓN COMPLETAMENTE
            session.setAttribute("itemsCarrito", new ArrayList<>());
            session.setAttribute("totalItems", 0);
            session.setAttribute("totalCarrito", 0.0);

            System.out.println("Carrito limpiado de sesión");

            System.out.println("Generando PDF...");
            try {
                generarPDF(idVenta, response);
                System.out.println("PDF generado y enviado exitosamente");
            } catch (Exception e) {
                System.err.println("ERROR al generar PDF:");
                e.printStackTrace();
                session.setAttribute("tipoMensaje", "error");
                session.setAttribute("mensaje", "Boleta generada pero error al crear PDF: " + e.getMessage());
                response.sendRedirect(request.getContextPath() + "/srvCatalogo");
            }
        } else {
            System.out.println("ERROR: No se pudo registrar la venta");
            session.setAttribute("tipoMensaje", "error");
            session.setAttribute("mensaje", "Error al procesar la venta");
            response.sendRedirect(request.getContextPath() + "/srvCatalogo");
        }
    }

    private void generarPDF(int idVenta, HttpServletResponse response) throws Exception {
        System.out.println("Obteniendo datos de venta ID: " + idVenta);

        Venta venta = ventaDAO.obtenerVentaCompleta(idVenta);

        if (venta == null) {
            throw new Exception("No se pudieron obtener los datos de la venta");
        }

        System.out.println("Datos de venta obtenidos correctamente");

        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition", "inline; filename=Boleta_B" + String.format("%06d", venta.getIdVenta()) + ".pdf");

        Document document = new Document(PageSize.A4);

        try {
            PdfWriter.getInstance(document, response.getOutputStream());
            document.open();

            System.out.println("Documento PDF abierto");

            Font fontTitulo = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 18);
            Font fontSubtitulo = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 12);
            Font fontNormal = FontFactory.getFont(FontFactory.HELVETICA, 10);

            Paragraph titulo = new Paragraph("BOLETA DE VENTA ELECTRONICA", fontTitulo);
            titulo.setAlignment(Element.ALIGN_CENTER);
            document.add(titulo);

            document.add(new Paragraph(" "));

            Paragraph empresa = new Paragraph("ECOMMERCE - URBAN STORE", fontSubtitulo);
            empresa.setAlignment(Element.ALIGN_CENTER);
            document.add(empresa);

            Paragraph ruc = new Paragraph("RUC: 20123456789", fontNormal);
            ruc.setAlignment(Element.ALIGN_CENTER);
            document.add(ruc);

            document.add(new Paragraph(" "));

            Paragraph numeroBoleta = new Paragraph("N° BOLETA: B" + String.format("%06d", venta.getIdVenta()), fontSubtitulo);
            numeroBoleta.setAlignment(Element.ALIGN_CENTER);
            document.add(numeroBoleta);

            SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
            Paragraph fecha = new Paragraph("Fecha: " + sdf.format(venta.getFechaVenta()), fontNormal);
            fecha.setAlignment(Element.ALIGN_CENTER);
            document.add(fecha);

            document.add(new Paragraph(" "));

            // ✅ DATOS DEL CLIENTE ACTUALIZADO
            document.add(new Paragraph("DATOS DEL CLIENTE", fontSubtitulo));
            document.add(new Paragraph("Nombre Completo: " + (venta.getNombreCliente() != null ? venta.getNombreCliente() : "N/A"), fontNormal));
            document.add(new Paragraph("Email: " + (venta.getEmailCliente() != null ? venta.getEmailCliente() : "N/A"), fontNormal));
            document.add(new Paragraph("Teléfono: " + (venta.getTelefonoCliente() != null ? venta.getTelefonoCliente() : "N/A"), fontNormal));
            document.add(new Paragraph("Dirección: " + (venta.getDireccionCliente() != null ? venta.getDireccionCliente() : "N/A"), fontNormal));

            document.add(new Paragraph(" "));

            document.add(new Paragraph("DETALLE DE LA COMPRA", fontSubtitulo));
            document.add(new Paragraph(" "));

            PdfPTable tabla = new PdfPTable(6);  // ✅ CAMBIAR DE 4 A 6 COLUMNAS
            tabla.setWidthPercentage(100);
            tabla.setWidths(new float[]{2.5f, 1.2f, 0.8f, 0.8f, 1.2f, 1.5f});  // ✅ AJUSTAR ANCHOS

            agregarCeldaEncabezado(tabla, "Producto", fontSubtitulo);
            agregarCeldaEncabezado(tabla, "Color", fontSubtitulo);          // ✅ AGREGAR
            agregarCeldaEncabezado(tabla, "Talla", fontSubtitulo);          // ✅ AGREGAR
            agregarCeldaEncabezado(tabla, "Cant.", fontSubtitulo);
            agregarCeldaEncabezado(tabla, "P. Unit.", fontSubtitulo);
            agregarCeldaEncabezado(tabla, "Subtotal", fontSubtitulo);

            List<ItemVenta> productos = venta.getProductos();

            if (productos != null && !productos.isEmpty()) {
                for (ItemVenta item : productos) {
                    tabla.addCell(new Phrase(item.getNombreProducto(), fontNormal));

                    // ✅ AGREGAR COLOR
                    tabla.addCell(new Phrase(item.getColor() != null ? item.getColor() : "-", fontNormal));

                    // ✅ AGREGAR TALLA
                    tabla.addCell(new Phrase(item.getTalla() != null ? item.getTalla() : "-", fontNormal));

                    PdfPCell cellCantidad = new PdfPCell(new Phrase(String.valueOf(item.getCantidad()), fontNormal));
                    cellCantidad.setHorizontalAlignment(Element.ALIGN_CENTER);
                    tabla.addCell(cellCantidad);

                    PdfPCell cellPrecio = new PdfPCell(new Phrase("S/. " + String.format("%.2f", item.getPrecioUnitario()), fontNormal));
                    cellPrecio.setHorizontalAlignment(Element.ALIGN_RIGHT);
                    tabla.addCell(cellPrecio);

                    PdfPCell cellSubtotal = new PdfPCell(new Phrase("S/. " + String.format("%.2f", item.getSubtotal()), fontNormal));
                    cellSubtotal.setHorizontalAlignment(Element.ALIGN_RIGHT);
                    tabla.addCell(cellSubtotal);
                }
            }

            document.add(tabla);
            document.add(new Paragraph(" "));

            Paragraph total = new Paragraph("TOTAL: S/. " + String.format("%.2f", venta.getTotalFinal()), fontTitulo);
            total.setAlignment(Element.ALIGN_RIGHT);
            document.add(total);

            document.add(new Paragraph(" "));
            document.add(new Paragraph(" "));

            Paragraph gracias = new Paragraph("¡Gracias por su compra!", fontSubtitulo);
            gracias.setAlignment(Element.ALIGN_CENTER);
            document.add(gracias);

            System.out.println("Contenido del PDF agregado");

        } catch (DocumentException e) {
            System.err.println("ERROR al crear documento PDF:");
            e.printStackTrace();
            throw new Exception("Error al generar PDF: " + e.getMessage());
        } finally {
            if (document != null && document.isOpen()) {
                document.close();
                System.out.println("Documento PDF cerrado");
            }
        }
    }

    private void agregarCeldaEncabezado(PdfPTable tabla, String texto, Font font) {
        PdfPCell cell = new PdfPCell(new Phrase(texto, font));
        cell.setBackgroundColor(BaseColor.LIGHT_GRAY);
        cell.setHorizontalAlignment(Element.ALIGN_CENTER);
        cell.setPadding(5);
        tabla.addCell(cell);
    }

    // ========================================
// MÉTODOS PARA GESTIÓN DE VENTAS (VENDEDOR)
// ========================================
    /**
     * Lista todas las ventas con paginación
     */
    private void listarVentas(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println("=== LISTANDO VENTAS ===");

        // Paginación
        int pagina = 1;
        String paramPagina = request.getParameter("pagina");
        if (paramPagina != null && !paramPagina.isEmpty()) {
            try {
                pagina = Integer.parseInt(paramPagina);
            } catch (NumberFormatException e) {
                pagina = 1;
            }
        }

        int registrosPorPagina = 10;

        // Obtener lista de ventas
        List<Venta> listaVentas = ventaDAO.listarVentas(pagina, registrosPorPagina);
        int totalVentas = ventaDAO.contarVentas();
        int totalPaginas = (int) Math.ceil((double) totalVentas / registrosPorPagina);

        // Calcular estadísticas
        double montoTotal = ventaDAO.calcularTotalVentas();

        System.out.println("Ventas encontradas: " + listaVentas.size());
        System.out.println("Total ventas: " + totalVentas);
        System.out.println("Monto total: " + montoTotal);

        // Enviar datos al JSP
        request.setAttribute("listaVentas", listaVentas);
        request.setAttribute("totalVentas", totalVentas);
        request.setAttribute("montoTotal", montoTotal);
        request.setAttribute("paginaActual", pagina);
        request.setAttribute("totalPaginas", totalPaginas);

        request.getRequestDispatcher("/vistas/vendedor/listar-ventas.jsp").forward(request, response);
    }

    /**
     * Busca ventas por cliente o número de orden
     */
    private void buscarVentas(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String termino = request.getParameter("termino");
        System.out.println("=== BUSCANDO VENTAS: " + termino + " ===");

        if (termino == null || termino.trim().isEmpty()) {
            listarVentas(request, response);
            return;
        }

        // Paginación
        int pagina = 1;
        String paramPagina = request.getParameter("pagina");
        if (paramPagina != null && !paramPagina.isEmpty()) {
            try {
                pagina = Integer.parseInt(paramPagina);
            } catch (NumberFormatException e) {
                pagina = 1;
            }
        }

        int registrosPorPagina = 10;

        // Buscar ventas
        List<Venta> listaVentas = ventaDAO.buscarVentas(termino, pagina, registrosPorPagina);
        int totalVentas = ventaDAO.contarVentasBusqueda(termino);
        int totalPaginas = (int) Math.ceil((double) totalVentas / registrosPorPagina);

        System.out.println("Resultados encontrados: " + listaVentas.size());

        // Enviar datos al JSP
        request.setAttribute("listaVentas", listaVentas);
        request.setAttribute("totalVentas", totalVentas);
        request.setAttribute("terminoBusqueda", termino);
        request.setAttribute("paginaActual", pagina);
        request.setAttribute("totalPaginas", totalPaginas);

        request.getRequestDispatcher("/vistas/vendedor/listar-ventas.jsp").forward(request, response);
    }

    /**
     * Filtra ventas por estado
     */
    private void filtrarPorEstado(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String paramEstado = request.getParameter("estado");
        boolean estado = "true".equals(paramEstado) || "1".equals(paramEstado);

        System.out.println("=== FILTRANDO VENTAS POR ESTADO: " + (estado ? "Activas" : "Canceladas") + " ===");

        // Paginación
        int pagina = 1;
        String paramPagina = request.getParameter("pagina");
        if (paramPagina != null && !paramPagina.isEmpty()) {
            try {
                pagina = Integer.parseInt(paramPagina);
            } catch (NumberFormatException e) {
                pagina = 1;
            }
        }

        int registrosPorPagina = 10;

        // Filtrar ventas
        List<Venta> listaVentas = ventaDAO.filtrarPorEstado(estado, pagina, registrosPorPagina);
        int totalVentas = ventaDAO.contarVentasPorEstado(estado);
        int totalPaginas = (int) Math.ceil((double) totalVentas / registrosPorPagina);

        System.out.println("Ventas filtradas: " + listaVentas.size());

        // Enviar datos al JSP
        request.setAttribute("listaVentas", listaVentas);
        request.setAttribute("totalVentas", totalVentas);
        request.setAttribute("estadoFiltro", estado);
        request.setAttribute("paginaActual", pagina);
        request.setAttribute("totalPaginas", totalPaginas);

        request.getRequestDispatcher("/vistas/vendedor/listar-ventas.jsp").forward(request, response);
    }

    /**
     * Ver detalle de una venta específica
     */
    private void verDetalle(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String paramId = request.getParameter("id");
        System.out.println("=== VER DETALLE DE VENTA: " + paramId + " ===");

        if (paramId == null || paramId.trim().isEmpty()) {
            HttpSession session = request.getSession();
            session.setAttribute("tipoMensaje", "error");
            session.setAttribute("mensaje", "ID de venta no válido");
            response.sendRedirect(request.getContextPath() + "/srvVentas?accion=listar");
            return;
        }

        try {
            int idVenta = Integer.parseInt(paramId);
            Venta venta = ventaDAO.obtenerVentaCompleta(idVenta);

            if (venta != null) {
                request.setAttribute("venta", venta);
                request.getRequestDispatcher("/vistas/vendedor/detalle-venta.jsp").forward(request, response);
            } else {
                HttpSession session = request.getSession();
                session.setAttribute("tipoMensaje", "warning");
                session.setAttribute("mensaje", "No se encontró la venta solicitada");
                response.sendRedirect(request.getContextPath() + "/srvVentas?accion=listar");
            }

        } catch (NumberFormatException e) {
            HttpSession session = request.getSession();
            session.setAttribute("tipoMensaje", "error");
            session.setAttribute("mensaje", "ID de venta no válido");
            response.sendRedirect(request.getContextPath() + "/srvVentas?accion=listar");
        }
    }

    /**
     * Regenera PDF de una venta existente
     */
    private void descargarBoleta(HttpServletRequest request, HttpServletResponse response)
            throws Exception {

        String paramId = request.getParameter("id");
        System.out.println("=== DESCARGANDO BOLETA: " + paramId + " ===");

        if (paramId != null && !paramId.trim().isEmpty()) {
            try {
                int idVenta = Integer.parseInt(paramId);
                generarPDF(idVenta, response);
            } catch (NumberFormatException e) {
                HttpSession session = request.getSession();
                session.setAttribute("tipoMensaje", "error");
                session.setAttribute("mensaje", "ID de venta no válido");
                response.sendRedirect(request.getContextPath() + "/srvVentas?accion=listar");
            }
        } else {
            HttpSession session = request.getSession();
            session.setAttribute("tipoMensaje", "error");
            session.setAttribute("mensaje", "ID de venta no especificado");
            response.sendRedirect(request.getContextPath() + "/srvVentas?accion=listar");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            processRequest(request, response);
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            processRequest(request, response);
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
