<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원 수정</title>
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
    <main class="form-signin w-100 m-auto">
    <form role="form" action="/member/member" method="post">
		<img class="mb-4" src="/resources/img/diveintogutter.PNG" alt="" width="120" height="120">
		<h4 style="color: #fff">찍찍이 정보 수정</h4>
              <div class="form-floating">
                   <input type="text" class="form-control" id="id" name="id" placeholder="ID" value='<c:out value="${member.id}"/>' >
                      <label for="id">ID</label>
               </div>
               <div class="form-floating">
                      <input type="password" class="form-control" id="password" name="password" placeholder="Password"
                      style="border-bottom-left-radius: 0;  border-bottom-right-radius: 0; margin-bottom: -1px; border-bottom: 0px">
                      <label for="floatingPassword">Password</label>
                </div>
                <div class="form-floating">
                      <input type="password" class="form-control" id="passwordConfirm" name="passwordConfirm"  placeholder="Password Confirm">
                      <label for="floatingPasswordConfirm">Password Confirm</label>
                </div>
                    <br>
                <div class="form-floating">
                      <input type="text" class="form-control" id="name" name="name" placeholder="Name" value='<c:out value="${member.name}"/>'>
                      <label for="name">Name</label>
                </div>
                <div class="form-floating">
                      <input type="text" class="form-control" id="phone" name="phone" placeholder="Phone" value='<c:out value="${member.phone}"/>'
                      style="border-top-left-radius: 0;  border-top-right-radius: 0; border-bottom-left-radius: 4px; border-bottom-right-radius: 4px">
                      <label for="phone">Phone</label>
                </div>
                    <br>
                <div class="form-floating">
                	<c:set var="email" value="${fn:split(member.email, '@')}" />
                      <input type="text" class="form-control" id="emailName" name="emailName" placeholder="Email" value='<c:out value="${email[0] }"/>'>
                      <label for="emailName">Email</label>
                </div>
                <div class="form-floating">
                     <select class="form-select" id="emailDomain" name="emailDomain"
                     style="border-top-left-radius: 0;  border-top-right-radius: 0; border-top: 0px">
                     	  <option selected value='<c:out value="${email[1] }"/>'>@<c:out value="${email[1] }"/></option>
						  <option value="naver.com">@naver.com</option>
						  <option value="gmail.com">@gmail.com</option>
						  <option value="hanmail.net">@hanmail.net</option>
						  <option value="paran.com">@paran.com</option>
						  <option value="icloud.com">@icloud.com</option>
                     </select>
                     <label for="emailDomain">Email Domain</label>
                </div>
                    <br>
                    <input type="hidden" name="email" id="email">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                    <button type="submit" data-oper="modify" class="btn btn-primary">정보 수정</button>
                    <button type="submit" data-oper="remove" class="btn btn-danger">회원 탈퇴</button>
    </form>
    </main>
	</div>
</header>
</body>
<script>
$(document).ready(function(){
	
	var formObj = $("form[role='form']");
	
	//버튼을 클릭하면 이벤트정보가 매개변수 e 대입
	$("button").on("click",function(e){
		//원래 태그의 기능을 막는다.
		e.preventDefault();
		
		var operation = $(this).data("oper");
		
		//삭제 버튼을 클릭시 처리
		if(operation === "remove"){
			
			if(confirm("정말로 회원 탈퇴를 진행하시겠습니까?")) {
				alert("정상적으로 탈퇴되었습니다.");
				formObj.attr("action","/member/removeMember");
				formObj.attr("method","post");
				formObj.submit();
			}  else {
				alert("탈퇴 취소!");
			}
		}
		else if(operation === "modify"){
			// 이메일 도메인 결합
			var email_id = $("#emailName").val();
			var email_domain = $("#emailDomain").val();
			
			var mail = email_id+"@"+email_domain;
			
			// 유효성 검사 조건
			let checkPW = RegExp(/^(?=.*[a-zA-Z])(?=.*[!@#$%^*+=-])(?=.*[0-9]).{8,25}$/);
			let checkName = RegExp(/^[가-힣]|[A-Z]|[a-z]$/);
			let checkPhone = RegExp(/^(01[016789]{1})-[0-9]{3,4}-[0-9]{4}$/);        
			let checkEmail = RegExp(/^[a-z0-9]{2,30}$/);
			
			// 유효성 검사
			if($("#password").val() == "") {
	            alert("비밀번호를 입력해 주세요.");               
	            return false;
			}
			else if(!checkPW.test($("#password").val())) {
				alert("비밀번호는 영문, 숫자, 특수 문자를 조합하여 8~25 자로 설정해 주세요.");
				return false;
			}
			else if($("#passwordConfirm").val() == "") {
	            alert("비밀번호 확인을 입력해 주세요.");               
	            return false;
			}
			else if ($("#password").val() != $("#passwordConfirm").val()) {
	            alert("비밀번호와 비밀번호 확인 입력값이 서로 일치하지 않습니다.");
	            return false;
	        }
			else if($("#name").val() == "") {
	            alert("이름을 입력해 주세요.");               
	            return false;
			}
			else if(!checkName.test($("#name").val())) {
				alert("이름은 한글 또는 영문으로 입력해 주세요.");
				return false;
			}
			else if($("#phone").val() == "") {
	            alert("휴대 전화 번호를 입력해 주세요.");               
	            return false;
			}
			else if(!checkPhone.test($("#phone").val())) {
				alert("휴대 전화 번호는 000-0000-0000 형식으로 입력해 주세요.");
				return false;
			}
			else if($("#emailName").val() == "") {
	            alert("이메일을 입력해 주세요.");               
	            return false;
			}
			else if(!checkEmail.test($("#emailName").val())) {
				alert("이메일은 영문, 숫자 조합만 가능합니다.");
				return false;
			}
			$("#email").val(mail);
			formObj.attr("action", "/member/updateMember");
			formObj.attr("method","post");
			formObj.submit();
		}
	});
});
</script>
</html>