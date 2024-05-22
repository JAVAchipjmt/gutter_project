<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>My Page</title>
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
		<h4 style="color: #fff"><c:out value="${pinfo.username}" /> 찍찍이 MY PAGE</h4>
		<br>
		<div class="d-grid gap-2 d-md-flex justify-content-center">  
			<button type="button" class="btn btn-warning py-2" onclick="location.href='/member/updateMember?id=${pinfo.username}'" >회원 수정</button>
			<button type="button" class="btn btn-info py-2" onclick="location.href='/member/checkPost?id=${pinfo.username}'" >내가 쓴 글</button>
		</div>
	</div>
</header>
</body>
</html>