<%@page contentType="text/html" pageEncoding="UTF-8"%>
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
                        <span class="label label-success">${carrito.items.size() > 0 ? carrito.items.size() : 0}</span>
                    </a>
                </li>

                <li class="dropdown user user-menu">
                    <a href="#" class="dropdown-toggle" data-toggle="dropdown">
                        <img src="${pageContext.request.contextPath}/dist/img/user2-160x160.jpg" class="user-image" alt="User Image">
                        <span class="hidden-xs">${usuario.nombre} ${usuario.apellido}</span>
                    </a>
                    <ul class="dropdown-menu">
                        <li class="user-header">
                            <img src="${pageContext.request.contextPath}/dist/img/user2-160x160.jpg" class="img-circle" alt="User Image">
                            <p>
                                ${usuario.nombre} ${usuario.apellido}
                                <small>${usuario.rol.nombreRol}</small>
                            </p>
                        </li>
                        <li class="user-footer">
                            <div class="pull-left">
                                <a href="#" class="btn btn-default btn-flat">Perfil</a>
                            </div>
                            <div class="pull-right">
                                <a href="${pageContext.request.contextPath}/srvUsuario?accion=cerrar" class="btn btn-default btn-flat">Cerrar Sesión</a>
                            </div>
                        </li>
                    </ul>
                </li>
            </ul>
        </div>
    </nav>
</header>


<div class="modal fade" id="modalCarrito" tabindex="-1" role="dialog" aria-labelledby="modalCarritoLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" id="modalCarritoLabel"><i class="fa fa-shopping-cart"></i> Tu Carrito de Compras</h4>
            </div>

            <div class="modal-body">
                <%-- YA NO USES JSTL DENTRO DEL BODY DEL MODAL, ELIMÍNALO Y DEJA LA ESTRUCTURA HTML VACÍA --%>

                <ul id="cart-list-modal" class="list-group list-group-flush">
                </ul>

                <div class="box box-solid box-primary mt-3">
                    <div class="box-header with-border">
                        <h3 class="box-title">Resumen del Pedido</h3>
                    </div>
                    <div class="box-body">
                        <div class="row">
                            <div class="col-xs-6">
                                <h4>Total:</h4>
                            </div>
                            <div class="col-xs-6 text-right">
                                <h4 id="cart-total-modal" class="text-success">S/. 0.00</h4> 
                            </div>
                        </div>
                    </div>
                    <div class="box-footer">
                        <button id="checkout-btn-modal" onclick="generarBoleta()" class="btn btn-success btn-block btn-lg" disabled>
                            <i class="fa fa-check-circle"></i> Generar Compra y Boleta PDF
                        </button>
                    </div>
                </div>
            </div>

            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">Seguir Comprando</button>
            </div>


            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">Seguir Comprando</button>
            </div>
        </div>
    </div>
</div>