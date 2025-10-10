<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
    <head>
        <%@ include file="/vistas/includes/head-resources.jsp" %>
    </head>
    <body class="hold-transition skin-blue sidebar-mini">
        <!-- DEBUG: Eliminar después de probar -->
        <div style="background: yellow; padding: 10px; margin: 10px;">
            <strong>DEBUG - Sesión:</strong><br>
            idCliente: ${sessionScope.idCliente}<br>
            Items en carrito: ${sessionScope.itemsCarrito.size()}<br>
            Total items: ${sessionScope.totalItems}<br>
            Total: ${sessionScope.totalCarrito}
        </div>
        <div class="wrapper">

            <!-- Header y Sidebar -->
            <jsp:include page="/vistas/includes/header-cliente.jsp"/>
            <jsp:include page="/vistas/includes/sidebar-cliente.jsp"/>

            <!-- Contenido principal -->
            <div class="content-wrapper">
                <section class="content-header">
                    <h1>Catálogo de Productos</h1>
                </section>

                <section class="content">
                    <div class="row">
                        <c:choose>
                            <c:when test="${not empty listaProductos}">
                                <c:forEach var="p" items="${listaProductos}">
                                    <div class="col-md-3 col-sm-6 col-xs-12">
                                        <div class="box box-primary">
                                            <div class="box-body box-profile text-center">

                                                <!-- Imagen de referencia -->
                                                <c:choose>
                                                    <c:when test="${not empty p.imagenUrl}">
                                                        <img class="img-responsive"
                                                             src="${pageContext.request.contextPath}/${p.imagenUrl}"
                                                             alt="${p.nombre}" style="height:180px; margin:0 auto;">
                                                    </c:when>
                                                    <c:otherwise>
                                                        <i class="fa fa-camera fa-4x text-muted" style="margin:40px 0;"></i>
                                                    </c:otherwise>
                                                </c:choose>

                                                <!-- Nombre y categoría -->
                                                <h3 class="profile-username text-center">${p.nombre}</h3>
                                                <p class="text-muted text-center">${p.nombreCategoria}</p>

                                                <!-- Precio -->
                                                <h4 class="text-red">S/. <c:out value="${p.precio}"/></h4>

                                                <!-- Stock total -->
                                                <c:set var="totalStock" value="0"/>
                                                <c:forEach var="inv" items="${inventariosPorProducto[p.idProducto]}">
                                                    <c:set var="totalStock" value="${totalStock + inv.stock}"/>
                                                </c:forEach>

                                                <c:choose>
                                                    <c:when test="${totalStock > 5}">
                                                        <span class="label label-success">
                                                            <i class="fa fa-check"></i> En stock (${totalStock})
                                                        </span>
                                                    </c:when>
                                                    <c:when test="${totalStock > 0}">
                                                        <span class="label label-warning">
                                                            <i class="fa fa-exclamation-triangle"></i> Últimas unidades (${totalStock})
                                                        </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="label label-danger">
                                                            <i class="fa fa-times"></i> Agotado
                                                        </span>
                                                    </c:otherwise>
                                                </c:choose>

                                                <hr>

                                                <!-- Formulario agregar al carrito -->
                                                <form action="${pageContext.request.contextPath}/srvCarrito" method="post">
                                                    <input type="hidden" name="accion" value="agregar">

                                                    <!-- Selector de inventario -->
                                                    <div class="form-group">
                                                        <label for="inv-${p.idProducto}">
                                                            <i class="fa fa-tag"></i> Color y Talla:
                                                        </label>
                                                        <select id="inv-${p.idProducto}" name="idInventario" class="form-control" required>
                                                            <option value="">-- Selecciona --</option>
                                                            <c:forEach var="inv" items="${inventariosPorProducto[p.idProducto]}">
                                                                <option value="${inv.idInventario}"
                                                                        data-stock="${inv.stock}"
                                                                        <c:if test="${inv.stock == 0}">disabled</c:if>>
                                                                    ${inv.color} - ${inv.talla} (Stock: ${inv.stock})
                                                                </option>
                                                            </c:forEach>
                                                        </select>
                                                    </div>

                                                    <!-- Selector de cantidad -->
                                                    <div class="form-group">
                                                        <label for="cant-${p.idProducto}">
                                                            <i class="fa fa-shopping-basket"></i> Cantidad:
                                                        </label>
                                                        <div class="input-group">
                                                            <span class="input-group-btn">
                                                                <button class="btn btn-default btn-sm" type="button" 
                                                                        onclick="decrementarCantidad('cant-${p.idProducto}')">
                                                                    <i class="fa fa-minus"></i>
                                                                </button>
                                                            </span>
                                                            <input type="number" 
                                                                   id="cant-${p.idProducto}" 
                                                                   name="cantidad" 
                                                                   class="form-control text-center" 
                                                                   value="1" 
                                                                   min="1" 
                                                                   max="${totalStock}"
                                                                   required>
                                                            <span class="input-group-btn">
                                                                <button class="btn btn-default btn-sm" type="button" 
                                                                        onclick="incrementarCantidad('cant-${p.idProducto}', ${totalStock})">
                                                                    <i class="fa fa-plus"></i>
                                                                </button>
                                                            </span>
                                                        </div>
                                                        <small class="text-muted">Máximo: ${totalStock} unidades</small>
                                                    </div>

                                                    <!-- Botón -->
                                                    <button type="submit" class="btn btn-success btn-block"
                                                            <c:if test="${totalStock == 0}">disabled</c:if>>
                                                                <i class="fa fa-cart-plus"></i> Agregar al Carrito
                                                            </button>
                                                    </form>
                                                </div>
                                            </div>
                                        </div>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <div class="col-xs-12">
                                    <div class="alert alert-info">
                                        No hay productos disponibles en este momento.
                                    </div>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </section>
            </div>
            <!-- Footer -->
            <jsp:include page="/vistas/includes/footer.jsp"/>
        </div>
        <script>
// Función para incrementar cantidad
            function incrementarCantidad(inputId, maxStock) {
                var input = document.getElementById(inputId);
                var valor = parseInt(input.value);
                if (valor < maxStock) {
                    input.value = valor + 1;
                } else {
                    toastr.warning('Stock máximo alcanzado: ' + maxStock + ' unidades', 'Límite de stock');
                }
            }

// Función para decrementar cantidad
            function decrementarCantidad(inputId) {
                var input = document.getElementById(inputId);
                var valor = parseInt(input.value);
                if (valor > 1) {
                    input.value = valor - 1;
                } else {
                    toastr.info('La cantidad mínima es 1', 'Cantidad mínima');
                }
            }

// Validar stock al seleccionar inventario
            $(document).ready(function () {
                // Configurar Toastr
                toastr.options = {
                    "closeButton": true,
                    "progressBar": true,
                    "positionClass": "toast-top-right",
                    "timeOut": "3000"
                };

                // Validar stock al cambiar inventario
                $('select[name="idInventario"]').on('change', function () {
                    var stock = $(this).find(':selected').data('stock');
                    var cantidadInput = $(this).closest('form').find('input[name="cantidad"]');

                    if (stock) {
                        cantidadInput.attr('max', stock);
                        if (parseInt(cantidadInput.val()) > stock) {
                            cantidadInput.val(stock);
                        }

                        // Deshabilitar botón si no hay stock
                        var btnAgregar = $(this).closest('form').find('button[type="submit"]');
                        if (stock === 0) {
                            btnAgregar.prop('disabled', true);
                            toastr.error('Este producto está agotado', 'Sin stock');
                        } else {
                            btnAgregar.prop('disabled', false);
                        }
                    }
                });

                // Validar cantidad antes de enviar el formulario
                $('form[action*="srvCarrito"]').on('submit', function (e) {
                    var cantidad = parseInt($(this).find('input[name="cantidad"]').val());
                    var maxStock = parseInt($(this).find('input[name="cantidad"]').attr('max'));

                    if (cantidad > maxStock) {
                        e.preventDefault();
                        toastr.error('La cantidad solicitada (' + cantidad + ') supera el stock disponible (' + maxStock + ')', 'Stock insuficiente');
                        return false;
                    }

                    if (cantidad < 1) {
                        e.preventDefault();
                        toastr.warning('La cantidad debe ser al menos 1', 'Cantidad inválida');
                        return false;
                    }
                });

                // Mostrar mensajes de la sesión
            <c:if test="${not empty sessionScope.mensaje}">
                var tipoMensaje = '${sessionScope.tipoMensaje}';
                var mensaje = '${sessionScope.mensaje}';

                if (tipoMensaje === 'success') {
                    toastr.success(mensaje, '¡Éxito!');
                } else if (tipoMensaje === 'error') {
                    toastr.error(mensaje, 'Error');
                } else if (tipoMensaje === 'warning') {
                    toastr.warning(mensaje, 'Atención');
                } else {
                    toastr.info(mensaje, 'Información');
                }

                <%
            session.removeAttribute("mensaje");
            session.removeAttribute("tipoMensaje");
                %>
            </c:if>
            });
        </script>
    </body>
</html>
