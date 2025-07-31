<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<nav class="main-header navbar navbar-expand navbar-white navbar-light">
    <ul class="navbar-nav">
        <li class="nav-item">
            <a class="nav-link" data-widget="pushmenu" href="#" role="button"><i class="fas fa-bars"></i></a>
        </li>
        <li class="nav-item d-none d-sm-inline-block">
            <a href="${pageContext.request.contextPath}/dashboard" class="nav-link">Home</a>
        </li>
    </ul>
    <ul class="navbar-nav ml-auto">
        <c:if test="${sessionScope.user != null}">
            <li class="nav-item">
                <span class="nav-link">${sessionScope.user.role}</span>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="${pageContext.request.contextPath}/logout"><i class="fas fa-sign-out-alt"></i> Logout</a>
            </li>
        </c:if>
        <c:if test="${sessionScope.user == null}">
            <li class="nav-item">
                <a class="nav-link" href="${pageContext.request.contextPath}/login.jsp"><i class="fas fa-sign-in-alt"></i> Login</a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="${pageContext.request.contextPath}/register.jsp"><i class="fas fa-user-plus"></i> Register</a>
            </li>
        </c:if>
    </ul>
</nav>