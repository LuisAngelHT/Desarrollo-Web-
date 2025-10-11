<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<header class="main-header">
    <a href="${pageContext.request.contextPath}/srvDashboardCliente" class="logo">
        <span class="logo-mini"><b>S</b>CM</span>
        <span class="logo-lg"><b>ECOMMERCE</b></span>
    </a>

    <nav class="navbar navbar-static-top" role="navigation">
        <a href="#" class="sidebar-toggle" data-toggle="push-menu" role="button">
            <span class="sr-only">Toggle navigation</span>
        </a>

        <div class="navbar-custom-menu">
            <ul class="nav navbar-nav">

                <li>
                    <a href="#" data-toggle="modal" data-target="#modalCarrito" title="Ver Carrito de Compras">
                        <i class="fa fa-shopping-cart"></i>
                        <span class="label label-success">
                            ${not empty totalItems ? totalItems : 0}
                        </span>
                    </a>
                </li>

                <li class="dropdown user user-menu">
                    <a href="#" class="dropdown-toggle" data-toggle="dropdown">
                        <!-- ? FOTO DIN�MICA EN NAVBAR -->
                        <img src="${pageContext.request.contextPath}/${not empty usuario.fotoPerfil ? usuario.fotoPerfil : 'dist/img/user2-160x160.jpg'}" 
                             class="user-image" 
                             alt="User Image"
                             style="object-fit: cover;">
                        <span class="hidden-xs">${usuario.nombre} ${usuario.apellido}</span>
                    </a>
                    <ul class="dropdown-menu">
                        <li class="user-header">
                            <!-- ? FOTO DIN�MICA EN DROPDOWN -->
                            <img src="${pageContext.request.contextPath}/${not empty usuario.fotoPerfil ? usuario.fotoPerfil : 'dist/img/user2-160x160.jpg'}" 
                                 class="img-circle" 
                                 alt="User Image"
                                 style="object-fit: cover;">
                            <p>
                                ${usuario.nombre} ${usuario.apellido}
                                <small>${usuario.rol.nombreRol}</small>
                            </p>
                        </li>
                        <li class="user-footer">
                            <div class="pull-left">
                                <a href="${pageContext.request.contextPath}/srvUsuario?accion=verPerfil" class="btn btn-default btn-flat">Perfil</a>
                            </div>
                            <div class="pull-right">
                                <a href="${pageContext.request.contextPath}/srvUsuario?accion=cerrar" class="btn btn-default btn-flat">Cerrar Sesi�n</a>
                            </div>
                        </li>
                    </ul>
                </li>
            </ul>
        </div>
    </nav>
</header>

<!-- Modal del Carrito (sin cambios) -->
<div class="modal fade" id="modalCarrito" tabindex="-1" role="dialog" aria-labelledby="modalCarritoLabel">
    <div class="modal-dialog modal-lg" role="document">
        <div class="modal-content">
            <div class="modal-header bg-primary">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
                <h4 class="modal-title" id="modalCarritoLabel">
                    <i class="fa fa-shopping-cart"></i> Tu Carrito de Compras
                </h4>
            </div>

            <div class="modal-body">
                <c:choose>
                    <c:when test="${not empty sessionScope.itemsCarrito}">
                        <!-- Lista de productos -->
                        <div class="table-responsive">
                            <table class="table table-hover">
                                <thead>
                                    <tr>
                                        <th width="80">Imagen</th>
                                        <th>Producto</th>
                                        <th width="100" class="text-center">Cantidad</th>
                                        <th width="100" class="text-right">Precio</th>
                                        <th width="100" class="text-right">Subtotal</th>
                                        <th width="60" class="text-center">Acci�n</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="item" items="${sessionScope.itemsCarrito}">
                                        <tr>
                                            <!-- Imagen -->
                                            <td>
                                                <c:choose>
                                                    <c:when test="${not empty item.imagenUrl}">
                                                        <img src="${pageContext.request.contextPath}/${item.imagenUrl}" 
                                                             class="img-responsive img-thumbnail" 
                                                             style="max-height: 60px; max-width: 60px; object-fit: cover;">
                                                    </c:when>
                                                    <c:otherwise>
                                                        <i class="fa fa-image fa-3x text-muted"></i>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>

                                            <!-- Nombre y detalles -->
                                            <td>
                                                <strong>${item.nombreProducto}</strong><br>
                                                <small class="text-muted">
                                                    <i class="fa fa-tag"></i> ${item.color} - ${item.talla}
                                                </small><br>
                                                <small class="text-info">
                                                    <i class="fa fa-cube"></i> Stock disponible: ${item.stockDisponible}
                                                </small>
                                            </td>

                                            <!-- Cantidad con botones -->
                                            <td class="text-center">
                                                <div class="input-group input-group-sm" style="width: 110px;">
                                                    <span class="input-group-btn">
                                                        <button class="btn btn-default btn-sm" type="button" 
                                                                onclick="actualizarCantidad(${item.idCarrito}, ${item.cantidad - 1})">
                                                            <i class="fa fa-minus"></i>
                                                        </button>
                                                    </span>
                                                    <input type="text" class="form-control text-center" 
                                                           value="${item.cantidad}" readonly>
                                                    <span class="input-group-btn">
                                                        <button class="btn btn-default btn-sm" type="button" 
                                                                onclick="actualizarCantidad(${item.idCarrito}, ${item.cantidad + 1})"
                                                                ${item.cantidad >= item.stockDisponible ? 'disabled' : ''}>
                                                            <i class="fa fa-plus"></i>
                                                        </button>
                                                    </span>
                                                </div>
                                            </td>

                                            <!-- Precio unitario -->
                                            <td class="text-right">
                                                <strong>S/. <fmt:formatNumber value="${item.precioUnitario}" pattern="#,##0.00"/></strong>
                                            </td>

                                            <!-- Subtotal -->
                                            <td class="text-right">
                                                <strong class="text-success">
                                                    S/. <fmt:formatNumber value="${item.precioUnitario * item.cantidad}" pattern="#,##0.00"/>
                                                </strong>
                                            </td>

                                            <!-- Bot�n eliminar -->
                                            <td class="text-center">
                                                <button class="btn btn-danger btn-xs" 
                                                        onclick="eliminarItem(${item.idCarrito})"
                                                        title="Eliminar del carrito">
                                                    <i class="fa fa-trash"></i>
                                                </button>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>

                        <hr>

                        <!-- Resumen del pedido -->
                        <div class="box box-solid box-success">
                            <div class="box-header with-border">
                                <h3 class="box-title"><i class="fa fa-calculator"></i> Resumen del Pedido</h3>
                            </div>
                            <div class="box-body">
                                <div class="row">
                                    <div class="col-xs-6">
                                        <p><strong>Total de Items:</strong></p>
                                    </div>
                                    <div class="col-xs-6 text-right">
                                        <p>${totalItems}</p>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-xs-6">
                                        <h4><strong>Total a Pagar:</strong></h4>
                                    </div>
                                    <div class="col-xs-6 text-right">
                                        <h3 class="text-success">
                                            <strong>S/. <fmt:formatNumber value="${totalCarrito}" pattern="#,##0.00"/></strong>
                                        </h3>
                                    </div>
                                </div>
                            </div>
                            <div class="box-footer">
                                <button onclick="generarBoleta()" class="btn btn-success btn-block btn-lg">
                                    <i class="fa fa-check-circle"></i> Proceder al Pago y Generar Boleta
                                </button>
                            </div>
                        </div>

                    </c:when>
                    <c:otherwise>
                        <!-- Carrito vac�o -->
                        <div class="text-center" style="padding: 40px 0;">
                            <i class="fa fa-shopping-cart fa-5x text-muted"></i>
                            <h3 class="text-muted">Tu carrito est� vac�o</h3>
                            <p class="text-muted">Agrega productos desde nuestro cat�logo</p>
                            <button type="button" class="btn btn-primary" data-dismiss="modal">
                                <i class="fa fa-shopping-bag"></i> Ir a Comprar
                            </button>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">
                    <i class="fa fa-arrow-left"></i> Seguir Comprando
                </button>
                <c:if test="${not empty itemsCarrito}">
                    <button type="button" class="btn btn-warning" onclick="vaciarCarrito()">
                        <i class="fa fa-trash"></i> Vaciar Carrito
                    </button>
                </c:if>
            </div>
        </div>
    </div>
</div>

<!-- JavaScript para las funciones del carrito -->
<script>
    function actualizarCantidad(idCarrito, nuevaCantidad) {
        if (nuevaCantidad < 1) {
            if (confirm('�Deseas eliminar este producto del carrito?')) {
                window.location.href = '${pageContext.request.contextPath}/srvCarrito?accion=eliminar&idCarrito=' + idCarrito;
            }
        } else {
            window.location.href = '${pageContext.request.contextPath}/srvCarrito?accion=actualizar&idCarrito=' + idCarrito + '&cantidad=' + nuevaCantidad;
        }
    }

    function eliminarItem(idCarrito) {
        if (confirm('�Est�s seguro de eliminar este producto del carrito?')) {
            window.location.href = '${pageContext.request.contextPath}/srvCarrito?accion=eliminar&idCarrito=' + idCarrito;
        }
    }

    function vaciarCarrito() {
        if (confirm('�Est�s seguro de vaciar todo el carrito? Se devolver� el stock de todos los productos.')) {
            $('#modalCarrito').modal('hide');
            setTimeout(function () {
                window.location.href = '${pageContext.request.contextPath}/srvCarrito?accion=vaciar';
            }, 300);
        }
    }

    function generarBoleta() {
        alert('Funci�n de generar boleta en desarrollo...');
    }
</script>