<!-- Main Header -->
<header class="main-header">
    <!-- Logo -->
    <a href="${pageContext.request.contextPath}/srvDashboardVendedor" class="logo">
        <span class="logo-mini"><b>U</b>S</span>
        <span class="logo-lg"><b>URBAN STORE</b></span>
    </a>
    <!-- Header Navbar -->
    <nav class="navbar navbar-static-top" role="navigation">
        <!-- Sidebar toggle button-->
        <a href="#" class="sidebar-toggle" data-toggle="push-menu" role="button">
            <span class="sr-only">Toggle navigation</span>
        </a>
        <!-- Navbar Right Menu -->
        <div class="navbar-custom-menu">
            <ul class="nav navbar-nav">
                <!-- User Account Menu -->
                <li class="dropdown user user-menu">
                    <a href="#" class="dropdown-toggle" data-toggle="dropdown">
                        <!-- ? CAMBIO 1: Foto dinámica en el navbar -->
                        <img src="${pageContext.request.contextPath}/${not empty usuario.fotoPerfil ? usuario.fotoPerfil : 'dist/img/user2-160x160.jpg'}" 
                             class="user-image" 
                             alt="User Image"
                             style="object-fit: cover;">
                        <span class="hidden-xs">${usuario.nombre} ${usuario.apellido}</span>
                    </a>
                    <ul class="dropdown-menu">
                        <!-- User image -->
                        <li class="user-header">
                            <!-- ? CAMBIO 2: Foto dinámica en el dropdown -->
                            <img src="${pageContext.request.contextPath}/${not empty usuario.fotoPerfil ? usuario.fotoPerfil : 'dist/img/user2-160x160.jpg'}" 
                                 class="img-circle" 
                                 alt="User Image"
                                 style="object-fit: cover;">
                            <p>
                                ${usuario.nombre} ${usuario.apellido}
                                <small>Rol: ${usuario.rol.nombreRol}</small>
                            </p>
                        </li>
                        <!-- Menu Footer-->
                        <li class="user-footer">
                            <div class="pull-left">
                                <a href="${pageContext.request.contextPath}/srvUsuario?accion=verPerfil" class="btn btn-default btn-flat">Perfil</a>
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