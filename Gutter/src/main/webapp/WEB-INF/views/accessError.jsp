<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>접근 권한 없음</title>
<style type="text/css">
	.masthead {
		background: url("/resources/img/main.jpg")
	}
</style>
<%@ include file="./includes/menu.jsp" %>
<style type="text/css">
	.menu-toggle {
		background: #000;
	}
</style>
</head>
<body>
        <header class="masthead d-flex align-items-center">
               <div class="container px-4 px-lg-5 text-center">
                <div class="row gx-4 gx-lg-5 h-100 align-items-center justify-content-center text-center">
                    <div class="col-lg-8 align-self-end">
                    	<br><br><br><br><br><br><br><br><br>
                      	<hr class="divider" />
                        <h3 class="text-white font-weight-bold">접근 권한이 없는 찍찍이 적발!</h3>
                    </div>
                    <div class="col-lg-8 align-self-baseline">
                        <h5 class="text-white mb-2">접근 권한이 있는 계정으로 로그인해 주세요.</h5>
                        <br>
                        <h6 class="text-white mb-1">메인으로 이동! <img class="mb-4" src="/resources/img/joinus.PNG" alt="" width="72" height="72"></h6>
                        <a class="btn btn-primary btn-xl" href="/">Gutter</a>
                    </div>
                </div>
            </div>
        </header>
</body>
</html>