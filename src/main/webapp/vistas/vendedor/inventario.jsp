<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="/vistas/includes/head-resources.jsp" %>

<!DOCTYPE html>
<html lang="es">
    <head>
        <title>Inventario de ${producto.nombre}</title>
    </head>
    <body class="hold-transition skin-blue sidebar-mini">
        <%@ include file="/vistas/includes/header-vendedor.jsp" %>
        <%@ include file="/vistas/includes/sidebar-vendedor.jsp" %>

        <div class="content-wrapper">
            <section class="content-header">
                <h1>Inventario de <strong>${producto.nombre}</strong></h1>
                <small>Gestión por talla y color</small>
                <ol class="breadcrumb">
                    <li><a href="srvDashboardVendedor?accion=listar"><i class="fa fa-dashboard"></i> Dashboard</a></li>
                    <li><a href="srvProductos?accion=listar"> Productos</a></li>
                    <li class="active"> Inventario</li>
                </ol>
            </section>

            <section class="content">
                <%@ include file="/vistas/includes/alertas.jsp" %>

                <!-- Listado -->
                <div class="box box-primary">
                    <div class="box-header with-border">
                        <h3 class="box-title">Combinaciones registradas</h3>
                        <div class="box-tools pull-right">
                            <button type="button" class="btn btn-primary btn-sm" data-toggle="modal" data-target="#modalAvanzado">
                                <i class="fa fa-magic"></i> Modo avanzado
                            </button>
                            <button type="button" class="btn btn-info btn-sm" onclick="copiarUltimaCombinacion()">
                                <i class="fa fa-copy"></i> Copiar última
                            </button>
                            <button type="button" class="btn btn-danger btn-sm" data-toggle="modal" data-target="#modalEliminarTodas">
                                <i class="fa fa-trash"></i> Eliminar todas
                            </button>
                        </div>
                    </div>
                    <div class="box-body">
                        <c:choose>
                            <c:when test="${empty listaInventario}">
                                <div class="alert alert-info">
                                    <i class="fa fa-info-circle"></i> No hay combinaciones registradas. Usa el formulario inferior o el modo avanzado para agregar.
                                </div>
                            </c:when>
                            <c:otherwise>
                                <table class="table table-bordered table-hover">
                                    <thead>
                                        <tr>
                                            <th>Talla</th>
                                            <th>Color</th>
                                            <th>Stock</th>
                                            <th>Estado</th>
                                            <th>Acciones</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="inv" items="${listaInventario}">
                                            <tr>
                                                <td>${inv.talla}</td>
                                                <td>${inv.color}</td>
                                                <td>${inv.stock}</td>
                                                <td>
                                                    <span class="label ${inv.estado == 'Activo' ? 'label-success' : 'label-default'}">${inv.estado}</span>
                                                </td>
                                                <td>
                                                    <button class="btn btn-sm btn-warning" style="margin-right: 5px;" data-toggle="modal" data-target="#modalEditar${inv.idInventario}">
                                                        <i class="fa fa-pencil"></i>
                                                    </button>
                                                    <button class="btn btn-sm btn-danger" data-toggle="modal" data-target="#modalEliminar${inv.idInventario}">
                                                        <i class="fa fa-trash"></i>
                                                    </button>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </c:otherwise>
                        </c:choose>

                        <!-- Modales de edición -->
                        <c:forEach var="inv" items="${listaInventario}">
                            <div class="modal fade" id="modalEditar${inv.idInventario}" tabindex="-1">
                                <div class="modal-dialog">
                                    <form action="srvInventario?accion=actualizar" method="post">
                                        <div class="modal-content">
                                            <div class="modal-header bg-warning text-white">
                                                <h4 class="modal-title">Editar combinación</h4>
                                                <button type="button" class="close" data-dismiss="modal">&times;</button>
                                            </div>
                                            <div class="modal-body">
                                                <input type="hidden" name="idInventario" value="${inv.idInventario}">
                                                <input type="hidden" name="idProducto" value="${producto.idProducto}">
                                                <div class="form-group">
                                                    <label>Talla</label>
                                                    <input type="text" name="talla" class="form-control" value="${inv.talla}" required autocomplete="off">
                                                </div>
                                                <div class="form-group">
                                                    <label>Color</label>
                                                    <input type="text" name="color" class="form-control" value="${inv.color}" required autocomplete="off">
                                                </div>
                                                <div class="form-group">
                                                    <label>Stock</label>
                                                    <input type="number" name="stock" class="form-control" value="${inv.stock}" required min="0">
                                                </div>
                                                <div class="form-group">
                                                    <label>Estado</label>
                                                    <select name="estado" class="form-control" required>
                                                        <option value="Activo" ${inv.estado == 'Activo' ? 'selected' : ''}>Activo</option>
                                                        <option value="Inactivo" ${inv.estado == 'Inactivo' ? 'selected' : ''}>Inactivo</option>
                                                    </select>
                                                </div>
                                            </div>
                                            <div class="modal-footer">
                                                <button type="submit" class="btn btn-warning">Guardar cambios</button>
                                                <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancelar</button>
                                            </div>
                                        </div>
                                    </form>
                                </div>
                            </div>
                        </c:forEach>

                        <!-- Modales de eliminación -->
                        <c:forEach var="inv" items="${listaInventario}">
                            <div class="modal fade" id="modalEliminar${inv.idInventario}" tabindex="-1">
                                <div class="modal-dialog">
                                    <form action="srvInventario?accion=eliminar" method="post">
                                        <div class="modal-content">
                                            <div class="modal-header bg-danger text-white">
                                                <h4 class="modal-title">Eliminar combinación</h4>
                                                <button type="button" class="close" data-dismiss="modal">&times;</button>
                                            </div>
                                            <div class="modal-body">
                                                ¿Estás seguro de que deseas eliminar la combinación <strong>${inv.talla} / ${inv.color}</strong>?
                                                <input type="hidden" name="idInventario" value="${inv.idInventario}">
                                                <input type="hidden" name="idProducto" value="${producto.idProducto}">
                                            </div>
                                            <div class="modal-footer">
                                                <button type="submit" class="btn btn-danger">Eliminar</button>
                                                <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancelar</button>
                                            </div>
                                        </div>
                                    </form>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </div>

                <!-- Modal para eliminar todas las combinaciones -->
                <div class="modal fade" id="modalEliminarTodas" tabindex="-1">
                    <div class="modal-dialog">
                        <form action="srvInventario?accion=eliminarTodas" method="post">
                            <div class="modal-content">
                                <div class="modal-header bg-danger text-white">
                                    <h4 class="modal-title">Eliminar todas las combinaciones</h4>
                                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                                </div>
                                <div class="modal-body">
                                    <p><strong>¡ADVERTENCIA!</strong> Esta acción eliminará <strong>todas</strong> las combinaciones de talla y color del producto <strong>${producto.nombre}</strong>.</p>
                                    <p>¿Estás seguro de continuar?</p>
                                    <input type="hidden" name="idProducto" value="${producto.idProducto}">
                                </div>
                                <div class="modal-footer">
                                    <button type="submit" class="btn btn-danger">Sí, eliminar todas</button>
                                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancelar</button>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>

                <!-- Modal avanzado para generar combinaciones -->
                <div class="modal fade" id="modalAvanzado" tabindex="-1">
                    <div class="modal-dialog modal-lg">
                        <form action="srvInventario?accion=generarCombinaciones" method="post" onsubmit="return validarFormularioAvanzado()">
                            <div class="modal-content">
                                <div class="modal-header bg-info text-white">
                                    <h4 class="modal-title">Generar combinaciones automáticas</h4>
                                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                                </div>
                                <div class="modal-body">
                                    <input type="hidden" name="idProducto" value="${producto.idProducto}">

                                    <div class="alert alert-info">
                                        <i class="fa fa-lightbulb-o"></i> Ingresa la cantidad de tallas y colores, luego completa los campos. Se generarán todas las combinaciones posibles.
                                    </div>

                                    <div class="row">
                                        <div class="col-md-6">
                                            <div class="form-group">
                                                <label>Cantidad de tallas</label>
                                                <input type="number" id="cantidadTallas" class="form-control" min="1" max="10" placeholder="Ej: 4" required>
                                            </div>
                                            <div class="form-group">
                                                <label>Tallas</label>
                                                <div id="contenedorTallas"></div>
                                            </div>
                                        </div>

                                        <div class="col-md-6">
                                            <div class="form-group">
                                                <label>Cantidad de colores</label>
                                                <input type="number" id="cantidadColores" class="form-control" min="1" max="10" placeholder="Ej: 3" required>
                                            </div>
                                            <div class="form-group">
                                                <label>Colores</label>
                                                <div id="contenedorColores"></div>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="form-group">
                                        <label>Stock para todas las combinaciones</label>
                                        <input type="number" name="stock" class="form-control" value="0" min="0" required>
                                    </div>

                                    <div class="form-group">
                                        <label>Estado</label>
                                        <select name="estado" class="form-control" required>
                                            <option value="Activo">Activo</option>
                                            <option value="Inactivo">Inactivo</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="modal-footer">
                                    <button type="submit" class="btn btn-primary">Generar combinaciones</button>
                                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancelar</button>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>

                <!-- Formulario para agregar inventario individual -->
                <div class="box box-success">
                    <div class="box-header with-border">
                        <h3 class="box-title">Agregar combinación individual</h3>
                    </div>
                    <div class="box-body">
                        <form action="srvInventario?accion=guardar" method="post">
                            <input type="hidden" name="idProducto" value="${producto.idProducto}">
                            <div class="row">
                                <div class="col-md-3">
                                    <div class="form-group">
                                        <label>Talla</label>
                                        <input type="text" name="talla" class="form-control" required autocomplete="off" placeholder="Ej. M, L, XL">
                                    </div>
                                </div>
                                <div class="col-md-3">
                                    <div class="form-group">
                                        <label>Color</label>
                                        <input type="text" name="color" class="form-control" required autocomplete="off" placeholder="Ej. Rojo, Azul">
                                    </div>
                                </div>
                                <div class="col-md-2">
                                    <div class="form-group">
                                        <label>Stock</label>
                                        <input type="number" name="stock" class="form-control" required min="0" placeholder="0">
                                    </div>
                                </div>
                                <div class="col-md-2">
                                    <div class="form-group">
                                        <label>Estado</label>
                                        <select name="estado" class="form-control" required>
                                            <option value="Activo">Activo</option>
                                            <option value="Inactivo">Inactivo</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="col-md-2">
                                    <div class="form-group">
                                        <label>&nbsp;</label>
                                        <button type="submit" class="btn btn-success btn-block">
                                            <i class="fa fa-plus"></i> Agregar
                                        </button>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group">
                                <a href="srvProductos?accion=listar" class="btn btn-default">
                                    <i class="fa fa-arrow-left"></i> Volver a productos
                                </a>
                            </div>
                        </form>
                    </div>
                </div>
            </section>
        </div>

        <%@ include file="/vistas/includes/footer.jsp" %>

        <script>
            function generarInputs(tipo, cantidad) {
                const contenedorId = tipo === 'talla' ? 'contenedorTallas' : 'contenedorColores';
                const contenedor = document.getElementById(contenedorId);
                contenedor.innerHTML = "";

                for (let i = 0; i < cantidad; i++) {
                    const input = document.createElement("input");
                    input.type = "text";
                    input.name = tipo + "[]";
                    input.className = "form-control mb-2";
                    input.placeholder = tipo.charAt(0).toUpperCase() + tipo.slice(1) + " " + (i + 1);
                    input.required = true;
                    input.style.marginBottom = "5px";
                    contenedor.appendChild(input);
                }
            }

            // Event listeners para generar inputs dinámicamente
            document.getElementById('cantidadTallas').addEventListener('input', function () {
                const cantidad = parseInt(this.value) || 0;
                if (cantidad > 0 && cantidad <= 10) {
                    generarInputs('talla', cantidad);
                } else {
                    document.getElementById('contenedorTallas').innerHTML = "";
                }
            });

            document.getElementById('cantidadColores').addEventListener('input', function () {
                const cantidad = parseInt(this.value) || 0;
                if (cantidad > 0 && cantidad <= 10) {
                    generarInputs('color', cantidad);
                } else {
                    document.getElementById('contenedorColores').innerHTML = "";
                }
            });

            // Validar formulario avanzado antes de enviar
            function validarFormularioAvanzado() {
                const cantTallas = parseInt(document.getElementById('cantidadTallas').value) || 0;
                const cantColores = parseInt(document.getElementById('cantidadColores').value) || 0;

                if (cantTallas === 0 || cantColores === 0) {
                    alert('Debes ingresar al menos 1 talla y 1 color.');
                    return false;
                }

                const inputsTallas = document.querySelectorAll('input[name="talla[]"]');
                const inputsColores = document.querySelectorAll('input[name="color[]"]');

                for (let input of inputsTallas) {
                    if (input.value.trim() === '') {
                        alert('Por favor completa todas las tallas.');
                        input.focus();
                        return false;
                    }
                }

                for (let input of inputsColores) {
                    if (input.value.trim() === '') {
                        alert('Por favor completa todos los colores.');
                        input.focus();
                        return false;
                    }
                }

                return true;
            }

            // Función para copiar la última combinación registrada
            function copiarUltimaCombinacion() {
                const tabla = document.querySelector('.table tbody');

                if (!tabla) {
                    alert('No hay combinaciones registradas para copiar.');
                    return;
                }

                const filas = tabla.querySelectorAll('tr');

                if (filas.length === 0) {
                    alert('No hay combinaciones registradas para copiar.');
                    return;
                }

                // La primera fila es la más reciente (ORDER BY DESC en el DAO)
                const primeraFila = filas[0];
                const talla = primeraFila.cells[0].textContent.trim();
                const color = primeraFila.cells[1].textContent.trim();
                const stock = primeraFila.cells[2].textContent.trim();

                // Rellenar el formulario de agregar combinación
                document.querySelector('form[action*="accion=guardar"] input[name="talla"]').value = talla;
                document.querySelector('form[action*="accion=guardar"] input[name="color"]').value = color;
                document.querySelector('form[action*="accion=guardar"] input[name="stock"]').value = stock;

                // Scroll hacia el formulario
                document.querySelector('.box-success').scrollIntoView({behavior: 'smooth', block: 'center'});

            }
        </script>
    </body>
</html>