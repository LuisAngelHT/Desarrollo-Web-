<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<aside class="main-sidebar">
    <section class="sidebar">
        <!-- Menú de navegación -->
        <ul class="sidebar-menu" data-widget="tree">
            <li class="header">MENÚ VENDEDOR</li>

            <!-- Dashboard -->
            <li class="${pageActive == 'dashboard' ? 'active' : ''}">
                <a href="${pageContext.request.contextPath}/srvDashboardVendedor">
                    <i class="fa fa-dashboard"></i> <span>Dashboard</span>
                </a>
            </li>

            <!-- Productos -->
            <li class="${pageActive == 'productos' ? 'active' : ''}">
                <a href="${pageContext.request.contextPath}/srvProductos?accion=listar">
                    <i class="fa fa-cubes"></i> <span>Productos</span>
                </a>
            </li>

            <!-- Ventas -->
            <li class="${pageActive == 'ventas' ? 'active' : ''}">
                <a href="${pageContext.request.contextPath}/srvVentas?accion=listar">
                    <i class="fa fa-shopping-cart"></i> <span>Ventas</span>
                </a>
            </li>

            <!-- Clientes -->
            <li class="${pageActive == 'clientes' ? 'active' : ''}">
                <a href="${pageContext.request.contextPath}/srvClientes?accion=listar">
                    <i class="fa fa-users"></i> <span>Mis Clientes</span>
                </a>
            </li>
        </ul>
    </section>
</aside>
