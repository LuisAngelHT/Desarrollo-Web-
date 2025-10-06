<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%-- Incluye recursos (CSS, Librerías, etc.) --%>
<jsp:include page="/vistas/includes/head-resources.jsp" />

<!DOCTYPE html>
<html lang="es">
    <head>
        <title>Tienda | Catálogo de Productos</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/custom/css/custom.css">
        <%-- Incluye Toastr para mensajes de éxito más elegantes (opcional, pero recomendado) --%>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/plugins/toastr/toastr.min.css">

        <style>
            .product-card {
                border: 1px solid #e0e0e0;
                border-radius: 8px;
                box-shadow: 0 4px 8px rgba(0,0,0,.05);
                transition: transform .2s;
                height: 100%;
                display: flex;
                flex-direction: column;
                justify-content: space-between;
                /* Fondo blanco para que destaque */
                background: #fff; 
            }
            .product-card:hover {
                transform: translateY(-5px);
                box-shadow: 0 8px 16px rgba(0,0,0,.1);
            }
            .product-card img {
                height: 180px; /* Un poco más pequeña que 200px */
                object-fit: cover;
                border-top-left-radius: 8px;
                border-top-right-radius: 8px;
                width: 100%; /* Asegura que la imagen ocupe todo el ancho */
            }
            .stock-info {
                font-size: 0.85em;
            }
            .card-body {
                flex-grow: 1; /* Permite que el cuerpo crezca */
            }
            .card-footer {
                padding-top: 0;
            }
        </style>
    </head>
    <body class="hold-transition skin-blue sidebar-mini">
        <div class="wrapper">
            <%-- ASEGÚRATE DE QUE ESTE ARCHIVO ES LA VERSIÓN CON EL MODAL DEL CARRITO --%>
            <jsp:include page="/vistas/includes/header-cliente.jsp" />
            <jsp:include page="/vistas/includes/sidebar-cliente.jsp" />

            <div class="content-wrapper">
                <section class="content-header">
                    <h1>Catálogo de Productos</h1>
                </section>

                <section class="content">
                    <div class="row">
                        <c:choose>
                            <c:when test="${not empty listaProductos}">
                                <c:forEach var="p" items="${listaProductos}">
                                    <%-- CLAVE: REDUCCIÓN DE TAMAÑO DE LA COLUMNA --%>
                                    <div class="col-lg-3 col-md-4 col-sm-6 mb-4"> 
                                        <div class="card product-card">
                                            
                                            <c:choose>
                                                <c:when test="${not empty p.imagenUrl}">
                                                    <img src="${pageContext.request.contextPath}/${p.imagenUrl}" alt="${p.nombre}" class="card-img-top">
                                                </c:when>
                                                <c:otherwise>
                                                    <div class="bg-light d-flex align-items-center justify-content-center" style="height: 180px; border-top-left-radius: 8px; border-top-right-radius: 8px;">
                                                        <i class="fas fa-camera fa-4x text-muted"></i>
                                                    </div>
                                                </c:otherwise>
                                            </c:choose>

                                            <div class="card-body">
                                                <h5 class="card-title text-primary">${p.nombre}</h5>
                                                <p class="card-text">
                                                    <strong>Categoría:</strong> ${p.nombreCategoria}
                                                </p>
                                                <h4 class="text-danger font-weight-bold">
                                                    S/. <c:out value="${p.precio}"/>
                                                </h4>

                                                <div class="stock-info mt-2">
                                                    <c:set var="totalStock" value="0"/>
                                                    <c:forEach var="inv" items="${inventariosPorProducto[p.idProducto]}">
                                                        <c:set var="totalStock" value="${totalStock + inv.stock}"/>
                                                    </c:forEach>
                                                    <c:choose>
                                                        <c:when test="${totalStock > 5}">
                                                            <span class="text-success"><i class="fas fa-check-circle"></i> En stock (${totalStock} unidades)</span>
                                                        </c:when>
                                                        <c:when test="${totalStock > 0}">
                                                            <span class="text-warning"><i class="fas fa-exclamation-triangle"></i> Últimas unidades (${totalStock})</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="text-danger"><i class="fas fa-times-circle"></i> Agotado</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                            </div>

                                            <div class="card-footer bg-white border-0">
                                                <button class="btn btn-block btn-success btn-add-to-cart" 
                                                        data-id="${p.idProducto}"
                                                        data-nombre="${p.nombre}"
                                                        data-precio="${p.precio}"
                                                        <c:if test="${totalStock == 0}">disabled</c:if>>
                                                    <i class="fas fa-cart-plus"></i> Agregar al Carrito
                                                </button>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <div class="col-12">
                                    <div class="alert alert-info mt-4">No hay productos disponibles en este momento.</div>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </section>
                
            </div>
        </div>
        <%-- Footer y Scripts --%>
        <jsp:include page="/vistas/includes/footer.jsp" />
        <%-- CLAVE: Incluir Toastr.js para los mensajes de éxito --%>
        <script src="${pageContext.request.contextPath}/plugins/toastr/toastr.min.js"></script>

<script>
    // Configuración de Toastr (mensajes de notificación)
    toastr.options = {
        "closeButton": true,
        "positionClass": "toast-top-right",
        "timeOut": "2000"
    }

    // La variable global 'cart' que almacena los productos
    let cart = []; 

    // Función para actualizar el contador del carrito en el header y el contenido del modal
    function updateCartUI() {
        // 1. Actualizar el contador del carrito en el header
        const cartCount = document.querySelector('.main-header .navbar-custom-menu .label-success');
        if (cartCount) {
            cartCount.textContent = cart.length > 0 ? cart.length : 0;
        }

        // 2. Renderizar el contenido dentro del Modal
        const list = document.getElementById('cart-list-modal');
        const totalElement = document.getElementById('cart-total-modal');
        const checkoutBtn = document.getElementById('checkout-btn-modal');
        const emptyMessage = document.getElementById('empty-cart-message-modal');
        
        // El modal debe tener estos IDs para que esta función funcione correctamente.
        // Asegúrate de modificar el header-cliente.jsp con estos IDs:
        // ul -> id="cart-list-modal"
        // li -> id="empty-cart-message-modal"
        // h5 -> id="cart-total-modal"
        // button -> id="checkout-btn-modal"
        
        if (!list || !totalElement || !checkoutBtn) return; // Salir si el modal no se encuentra (aún no se abrió)

        list.innerHTML = '';
        let total = 0;

        if (cart.length === 0) {
            list.innerHTML = `<li class="list-group-item text-muted" id="empty-cart-message-modal">El carrito está vacío.</li>`;
            totalElement.textContent = 'S/. 0.00';
            checkoutBtn.disabled = true;
            return;
        }

        cart.forEach((item, index) => {
            const li = document.createElement('li');
            li.className = 'list-group-item d-flex justify-content-between align-items-center';
            li.innerHTML = `
                ${item.nombre} (x${item.cantidad})
                <span>
                    S/. ${(item.precio * item.cantidad).toFixed(2)}
                    <button class="btn btn-xs btn-danger ml-2" onclick="removeFromCart('${item.id}')">
                        <i class="fas fa-trash"></i>
                    </button>
                </span>
            `;
            list.appendChild(li);
            total += item.precio * item.cantidad;
        });

        totalElement.textContent = `S/. ${total.toFixed(2)}`;
        checkoutBtn.disabled = false;
    }

    // ******************************************************
    // LÓGICA DE MANEJO DEL CARRITO
    // ******************************************************
    
    // Función para añadir productos al carrito
    function addToCart(id, nombre, precio) {
        const existingItem = cart.find(item => item.id === id);

        if (existingItem) {
            existingItem.cantidad += 1;
        } else {
            cart.push({id, nombre, precio: parseFloat(precio), cantidad: 1});
        }
        
        updateCartUI(); 
        
        // CLAVE: MENSAJE DE CONFIRMACIÓN
        toastr.success(`¡${nombre} agregado al carrito!`, 'Producto Añadido');
    }

    // Función para eliminar un producto del carrito
    function removeFromCart(id) {
        const initialLength = cart.length;
        cart = cart.filter(item => item.id !== id);
        
        if (cart.length < initialLength) {
             updateCartUI();
             toastr.warning('Producto eliminado del carrito.', 'Eliminado');
        } else {
             updateCartUI();
        }
    }

    // Asignar el evento a los botones de "Agregar al Carrito"
    document.querySelectorAll('.btn-add-to-cart').forEach(button => {
        button.addEventListener('click', () => {
            const id = button.getAttribute('data-id');
            const nombre = button.getAttribute('data-nombre');
            const precio = button.getAttribute('data-precio');
            addToCart(id, nombre, precio);
        });
    });

    // ******************************************************
    // LÓGICA DE COMPRA Y GENERACIÓN DE BOLETA (Mantenida aquí)
    // ******************************************************
    function generarBoleta() {
        // Lógica de generación de boleta (enviar al Servlet, etc.)
        if (cart.length === 0) {
            toastr.error("El carrito está vacío.", "Error de Compra");
            return;
        }
        
        // ... (Tu lógica de AJAX o redirección al Servlet srvVenta va aquí) ...

        const total = cart.reduce((sum, item) => sum + (item.precio * item.cantidad), 0);
        generarSimulacionPDF({productos: cart, total: `S/. ${total.toFixed(2)}`});
        
        // Limpiar carrito y cerrar modal
        cart = [];
        updateCartUI();
        $('#modalCarrito').modal('hide'); // Cierra el modal de Bootstrap
    }

    function generarSimulacionPDF(datos) {
         toastr.success(`Total: ${datos.total}`, "¡Compra Exitosa! Boleta Generada (Simulación)");
    }
    
    // Asignar la función a la ventana global para que el modal del header pueda llamarla
    window.generarBoleta = generarBoleta;
    window.removeFromCart = removeFromCart;
    
    // Inicializar la interfaz del carrito al cargar
    document.addEventListener('DOMContentLoaded', updateCartUI);
    
    // Evento para actualizar el contenido del modal CADA VEZ que se abre
    // (Esto evita que el modal muestre datos desactualizados)
    $('#modalCarrito').on('show.bs.modal', function (e) {
        updateCartUI();
    });
</script>

</body>
</html>