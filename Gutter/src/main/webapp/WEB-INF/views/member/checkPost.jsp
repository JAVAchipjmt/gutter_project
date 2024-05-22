<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<style type="text/css">
	.masthead {
		background: url("/resources/img/mypage.jpg")
	}
</style>
<%@ include file="../includes/menu.jsp" %>
</head>
<body>
<header class="masthead d-flex align-items-center">
	<div class="container px-4 px-lg-5 text-center">
	<sec:authentication property="principal" var="pinfo"/>    
		<h4 style="color: #fff"><c:out value="${pinfo.username}" /> 찍찍이가 쓴 글</h4>
		<br>
		<div class="d-grid gap-2 d-md-flex justify-content-center">
		 <sec:authentication property="principal" var="pinfo"/>
			<button type="button" class="btn btn-dark py-2" onclick="location.href='/member/myPhoto?id=${pinfo.username}'" >Photo 게시판</button>
			<button type="button" class="btn btn-light py-2" onclick="location.href='/member/myCS?id=${pinfo.username}'" >CS center 게시판</button>
		</div>
	<br>
	</div>
</header>
</body>
</html>