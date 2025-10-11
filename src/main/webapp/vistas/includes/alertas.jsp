<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!-- Alerta de éxito -->
<c:if test="${not empty sessionScope.exito}">
    <div class="alert alert-success alert-dismissible">
        <button type="button" class="close" data-dismiss="alert" aria-label="Cerrar">
            <span aria-hidden="true">&times;</span>
        </button>
        <i class="fa fa-check-circle"></i> ${sessionScope.exito}
    </div>
    <c:remove var="exito" scope="session"/>
</c:if>

<!-- Alerta de error -->
<c:if test="${not empty sessionScope.error}">
    <div class="alert alert-danger alert-dismissible">
        <button type="button" class="close" data-dismiss="alert" aria-label="Cerrar">
            <span aria-hidden="true">&times;</span>
        </button>
        <i class="fa fa-exclamation-triangle"></i> ${sessionScope.error}
    </div>
    <c:remove var="error" scope="session"/>
</c:if>
