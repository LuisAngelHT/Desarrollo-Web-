<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<aside class="main-sidebar">
    <section class="sidebar">
        <ul class="sidebar-menu" data-widget="tree">
            <li class="header">MENÚ ADMINISTRADOR</li>

            <li class="${pageActive == 'dashboard' ? 'active' : ''}">
                <a href="${pageContext.request.contextPath}/srvDashboardAdmin?accion=dashboard">
                    <i class="fa fa-dashboard"></i> <span>Reportes</span>
                </a>
            </li>
            <li class="${pageActive == 'dashboard' ? 'active' : ''}">
                <a href="${pageContext.request.contextPath}/srvDashboardAdmin?accion=dashboard">
                    <i class="fa fa-dashboard"></i> <span>Vendedores</span>
                </a>
            </li>
            <li class="${pageActive == 'dashboard' ? 'active' : ''}">
                <a href="${pageContext.request.contextPath}/srvDashboardAdmin?accion=dashboard">
                    <i class="fa fa-dashboard"></i> <span>Clientes</span>
                </a>
            </li>
            <li class="${pageActive == 'dashboard' ? 'active' : ''}">
                <a href="${pageContext.request.contextPath}/srvDashboardAdmin?accion=dashboard">
                    <i class="fa fa-dashboard"></i> <span>ventas</span>
                </a>
            </li>
        </ul>
    </section>
</aside>
