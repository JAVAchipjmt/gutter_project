<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Gutter LogIn</title>
<%@ include file="../includes/menu.jsp" %>
<style type="text/css">
	.masthead {
		background: url("/resources/img/dropdown.jpg");
	}
	.menu-toggle {
		background: #000;
	}
</style>
</head>
<body>
      	<header class="masthead d-flex align-items-center">
            <div class="container px-4 px-lg-5 text-center">
                 <main class="form-signin w-100 m-auto">
                  <form id="login_form" action="/login" method="post">
                    <img class="mb-4" src="/resources/img/letsgo.PNG" alt="" width="120" height="120">
                    <h4 class="h3 mb-3 fw-normal">Swim in the gutter</h4>

                    <div class="form-floating">
                      <input type="text" class="form-control" id="id" name="username" placeholder="ID">
                      <label for="floatingInput">ID</label>
                    </div>
                    <div class="form-floating">
                      <input type="password" class="form-control" id="password" name="password" placeholder="Password">
                      <label for="floatingPassword">Password</label>
                    </div>
                    <br>
                    <input type="hidden" name="${_csrf.parameterName }" value="${_csrf.token }" />
                    <input type="button" class="btn btn-primary w-100 py-2" value="Log in">
                   
                  </form>
                </main>
            </div>
        </header>
</body>
<script>
$(document).ready(function(){
	$(".py-2").click(function(){
		// 유효성 검사
		if($("#id").val() == "") {
            alert("아이디를 입력해 주세요.");               
            return false;
		}
		if($("#password").val() == "") {
			alert("비밀번호를 입력해 주세요.");
			return false;
		}
		
		$("#login_form").submit();
	});
});
</script>
</html>