<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
    <head>
        <%@ include file="/vistas/includes/head-resources.jsp" %>
    </head>
    <body class="hold-transition skin-blue sidebar-mini">
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
                                                    <input type="hidden" name="cantidad" value="1">

                                                    <!-- Selector de inventario -->
                                                    <div class="form-group">
                                                        <label for="inv-${p.idProducto}">Selecciona color/talla:</label>
                                                        <select id="inv-${p.idProducto}" name="idInventario" class="form-control">
                                                            <c:forEach var="inv" items="${inventariosPorProducto[p.idProducto]}">
                                                                <option value="${inv.idInventario}"
                                                                        <c:if test="${inv.stock == 0}">disabled</c:if>>
                                                                    ${inv.color} - ${inv.talla} (Stock: ${inv.stock})
                                                                </option>
                                                            </c:forEach>
                                                        </select>
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



    </body>
</html>
