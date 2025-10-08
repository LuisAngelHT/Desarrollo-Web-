
<aside class="main-sidebar">
    <section class="sidebar">
        <ul class="sidebar-menu" data-widget="tree">
            <li class="header">MENÚ CLIENTE</li>

            <%-- ENLACE PRINCIPAL: TIENDA/CATÁLOGO --%>
            <li class="${pageActive == 'tienda' ? 'active' : ''}">
                <a href="${pageContext.request.contextPath}/srvCatalogo?accion=catalogo">
                    <i class="fa fa-shopping-basket"></i> <span>Tienda / Catálogo</span>
                </a>
            </li>
            
            <%-- NUEVO ENLACE: MIS PEDIDOS --%>
            <li class="${pageActive == 'pedidos' ? 'active' : ''}">
                <a href="${pageContext.request.contextPath}/srvVentasCliente?accion=listarPedidos">
                    <i class="fa fa-list-alt"></i> <span>Mis Pedidos</span>
                </a>
            </li>
        </ul>
    </section>
</aside>