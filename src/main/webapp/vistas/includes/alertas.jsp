<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<c:if test="${not empty sessionScope.exito}">
    <div class="alert alert-success">
        ${sessionScope.exito}
        <button type="button" class="close" data-dismiss="alert">&times;</button>
    </div>
    <c:remove var="exito" scope="session"/>
</c:if>

<c:if test="${not empty sessionScope.error}">
    <div class="alert alert-danger">
        ${sessionScope.error}
        <button type="button" class="close" data-dismiss="alert">&times;</button>
    </div>
    <c:remove var="error" scope="session"/>
</c:if>
