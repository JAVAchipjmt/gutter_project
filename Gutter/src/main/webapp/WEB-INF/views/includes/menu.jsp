<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
 <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
 <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
  <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
  <%@ taglib  prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html>
<head>
<!-- 부트스트랩 -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<!-- 부트스트랩 아이콘 -->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.6.0/font/bootstrap-icons.css" />
<!--  폰트어썸 -->
<script src="https://use.fontawesome.com/releases/v6.3.0/js/all.js" crossorigin="anonymous"></script>
<!-- jQuery 선언 -->
<script src="http://code.jquery.com/jquery-latest.min.js"></script>
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta charset="UTF-8">
<link href="/resources/dist/css/styles.css" rel="stylesheet" />
<title>Gutter</title>
</head>
<body id="page-top" style="background-color: #000">
<a class="menu-toggle rounded" href="#"><i class="fa-solid fa-rocket"></i></a>
        <nav id="sidebar-wrapper" style="background: url('/resources/img/dropdown.jpg')">
            <ul class="sidebar-nav">
                <li class="sidebar-brand"><a href="/">GUTTER</a></li>
                <li class="sidebar-nav-item"><a href="/menu/about">About</a></li>
                <li class="sidebar-nav-item dropdown">
                   <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown" aria-expanded="false">Squeak</a>
                      <ul class="dropdown-menu">
                        <li><a class="dropdown-item" href="/squeak/photoList">Photo</a></li>
                      </ul>
                </li>
                <li class="sidebar-nav-item"><a href="/menu/cscenterList">CS Center</a></li>
                <!-- 로그인하지 않은 상태 -->
                <sec:authorize access="isAnonymous()">
	                <li class="sidebar-nav-item"><a href="/member/login">LOGIN</a></li>
	                <li class="sidebar-nav-item"><a href="/member/joinus">JOIN US</a></li>
	            </sec:authorize>
	            <sec:authentication property="principal" var="pinfo"/>                  
                <!-- 일반 회원이 로그인한 상태 -->
                <sec:authorize access="hasRole('ROLE_USER')">
	                <li class="sidebar-nav-item mypage"><a href="/member/mypage?id=${pinfo.username}">MY PAGE</a></li>
	                <li class="sidebar-nav-item"><a href="/member/logout">LOG OUT</a></li>
	            </sec:authorize>
	            <!-- 관리자 계정이 로그인한 상태 -->
                <sec:authorize access="hasRole('ROLE_ADMIN')">
	                <li class="sidebar-nav-item"><a href="/management/office">MANAGEMENT</a></li>
	                <li class="sidebar-nav-item"><a href="/member/logout">LOG OUT</a></li>
	            </sec:authorize>
            </ul>
        </nav>
<!--  자바 스크립트 선언  -->
 <script src="/resources/dist/js/scripts.js"></script>
</body>
</html>