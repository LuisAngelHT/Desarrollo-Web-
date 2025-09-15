<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
    if (session.getAttribute("usuario") != null) {
%>
<html>
    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <title>Sistema Bodega| Inicio</title>
        <!-- Tell the browser to be responsive to screen width -->
        <meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport">
        <link rel="stylesheet" href="bower_components/bootstrap/dist/css/bootstrap.min.css">
        <!-- Font Awesome -->
        <link rel="stylesheet" href="bower_components/font-awesome/css/font-awesome.min.css">
        <!-- Ionicons -->
        <link rel="stylesheet" href="bower_components/Ionicons/css/ionicons.min.css">
        <!-- Theme style -->
        <link href="dist/css/AdminLTE.min.css" rel="stylesheet" type="text/css"/>

        <!-- AdminLTE Skins. We have chosen the skin-blue for this starter
              page. However, you can choose any other skin. Make sure you
              apply the skin class to the body tag so the changes take effect. -->
        <link rel="stylesheet" href="dist/css/skins/skin-blue.min.css">
        <link rel="stylesheet"
              href="https://fonts.googleapis.com/css?family=Source+Sans+Pro:300,400,600,700,300italic,400italic,600italic">
    </head>

    <body class="hold-transition skin-blue sidebar-mini">
        <div class="wrapper">

            <!-- Main Header -->
            <header class="main-header">
                <a href="#" class="logo">
                    <!-- mini logo for sidebar mini 50x50 pixels -->
                    <span class="logo-mini"><b>S</b>BL</span>
                    <!-- logo for regular state and mobile devices -->
                    <span class="logo-lg"><b>Urban Store</b></span>
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
                                <!-- Menu Toggle Button -->
                                <a href="#" class="dropdown-toggle" data-toggle="dropdown">
                                    <!-- The user image in the navbar-->
                                    <img src="dist/img/user2-160x160.jpg" class="user-image" alt="User Image">
                                    <!-- hidden-xs hides the username on small devices so only the image appears. -->
                                    <span class="hidden-xs"> ${usuario.nombreUsuario}</span>
                                </a>
                                <ul class="dropdown-menu">
                                    <!-- The user image in the menu -->
                                    <li class="user-header">
                                        <img src="dist/img/user2-160x160.jpg" class="img-circle" alt="User Image">

                                        <p>                    
                                            Bienvenido - ${usuario.nombreUsuario}
                                            <small>Usted es,${usuario.cargo.nombreCargo} </small>
                                        </p>
                                    </li>
                                    <!-- Menu Footer-->
                                    <li class="user-footer">
                                        <div class="pull-right">
                                            <a href="srvUsuario?accion=cerrar" class="btn btn-default btn-flat">Cerrar Session</a>
                                        </div>
                                    </li>
                                </ul>
                            </li>
                        </ul>
                    </div>
                </nav>
            </header>
            <!-- Left side column. contains the logo and sidebar -->
            <aside class="main-sidebar">

                <!-- sidebar: style can be found in sidebar.less -->
                <section class="sidebar">

                    <!-- Sidebar user panel (optional) -->
                    <div class="user-panel">
                        <div class="pull-left image">
                            <img src="dist/img/user2-160x160.jpg" class="img-circle" alt="User Image">
                        </div>
                        <div class="pull-left info">
                            <p>Bienvenido,  ${usuario.nombreUsuario} </p>
                            <!-- Status -->
                            <a href="#"><i class="fa fa-circle text-success"></i> Online</a>
                        </div>
                    </div>

                    <!-- search form (Optional) -->
                    <form action="#" method="get" class="sidebar-form">
                        <div class="input-group">
                            <input type="text" name="q" class="form-control" placeholder="Search...">
                            <span class="input-group-btn">
                                <button type="submit" name="search" id="search-btn" class="btn btn-flat"><i class="fa fa-search"></i>
                                </button>
                            </span>
                        </div>
                    </form>
                    <!-- /.search form -->

                    <!-- Sidebar Menu -->
                    <ul class="sidebar-menu" data-widget="tree">
                        <li class="header">INICIO</li>

                        <!-- Inicio -->
                        <li >
                            <a href="${pageContext.request.contextPath}/ControladorEmpleado?menu=index">
                                <i class="fa fa-home"></i> <span>Panel Administrativo</span>
                            </a>
                        </li>

                        <!-- Productos -->
                        <li>
                            <a href="${pageContext.request.contextPath}/ControladorEmpleado?menu=listar">
                                <i class="glyphicon glyphicon-th-large"></i> <span>Empleados</span>
                            </a>
                        </li>

                        <!-- Ventas -->
                        <li>
                            <a href="">
                                <i class="fa fa-cart-arrow-down"></i> <span>Productos</span>
                            </a>
                        </li>

                        <!-- Reportes -->
                        <li>
                            <a href="">
                                <i class="fa fa-area-chart"></i> <span>Reportes</span>
                            </a>
                        </li>
                    </ul>

                    <!-- /.sidebar-menu -->
                </section>
                <!-- /.sidebar -->
            </aside>

            <!-- Content Wrapper. Contains page content -->
            <div class="content-wrapper">


                <section class="content">
                    <div class="container mt-3">
                        <div class="card">
                            <div class="card-body">
                                <h3>GESTOR DE PRODUCTOS</h3>
                                <hr>
                                <button type="button" class="btn btn-primary" data-toggle="modal" data-target="#modalFormulario">
                                    <i class="fa-solid fa-plus"></i>Nuevo
                                </button>
                                <table class="table table-bordered table-striped mt-2">
                                    <thead>
                                        <tr>
                                            <th>ID PRODUCTO</th>
                                            <th>NOMBRE</th>
                                            <th>PRECIO</th>
                                            <th>TALLA</th>
                                            <th>CATEGORIA</th>
                                            <th>STOCK</th>
                                            <th>ACCIONES</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach items="${empleados}" var="item">
                                            <tr>
                                                <td>${item.id}</td>
                                                <td>${item.nombres}</td>
                                                <td>${item.apellidos}</td>
                                                <td>${item.sexo}</td>
                                                <td>${item.telefono}</td>
                                                <td>${item.fechanac}</td>
                                                <td>${item.tipodoc}</td>
                                                <td>${item.nrodoc}</td>
                                                <td>${item.idusuario}</td>
                                                <td>
                                                    <a href="" class="btn-info btn-sm"> 
                                                        <i class="fa fa-edit"></i>
                                                    </a>
                                                    <a href="" class="btn btn-danger btn-sm"> 
                                                        <i class="fa fa-trash"></i>
                                                    </a>
                                                </td>
                                            </tr>
                                        </c:forEach>

                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>

                </section>
                <!-- /.content -->
            </div>
            <!-- /.content-wrapper -->

            <!-- Main Footer -->
            <footer class="main-footer">
                <!-- To the right -->
                <div class="pull-right hidden-xs">
                    Anything you want
                </div>
                <!-- Default to the left -->
                <strong>Copyright &copy; 2020 <a href="#">IDAT</a>.</strong> Todos los derechos reservados.
            </footer>

            <div class="control-sidebar-bg"></div>
        </div>
        <!-- modal agregar nuevo empleado -->
        <div class="modal fade" id="modalFormulario" tabindex="-1" role="dialog" aria-labelledby="modalLabel" aria-hidden="true">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h3 class="modal-title" id="modalLabel">Nuevo Empleado</h3>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <div class="modal-body">
                        <form action="Controlador" method="post">
                            <div class="form-group">
                                <label>Nombres</label>
                                <input name="nombres" type="text" class="form-control" maxlength="50" required="">
                            </div>
                            <div class="form-group">
                                <label>Apellidos</label>
                                <input name="apellidos" type="text" class="form-control" maxlength="50" required="">
                            </div>
                            <div class="form-group">
                                <label>Fecha ingreso</label>
                                <input name="fechaIngreso" type="date" class="form-control" required="">
                            </div>
                            <div class="form-group">
                                <label>Sueldo</label>
                                <input name="sueldo" type="number" class="form-control" maxlength="50" required="">
                            </div>
                            <div class="form-group">
                                <input type="hidden" name="accion" value="guardar">
                                <button class="btn btn-primary btn-sm">Registrar</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>

        <!-- ./wrapper -->

        <!-- REQUIRED JS SCRIPTS -->

        <!-- jQuery 3 -->
        <script src="bower_components/jquery/dist/jquery.min.js"></script>
        <!-- Bootstrap 3.3.7 -->
        <script src="bower_components/bootstrap/dist/js/bootstrap.min.js"></script>
        <!-- AdminLTE App -->
        <script src="dist/js/adminlte.min.js"></script>

        <!-- Optionally, you can add Slimscroll and FastClick plugins.
             Both of these plugins are recommended to enhance the
             user experience. -->
    </body>
</html>
<%
    } else {
        response.sendRedirect("identificar.jsp");
    }
%>


