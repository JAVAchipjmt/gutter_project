<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Join Gutter</title>
<%@ include file="../includes/menu.jsp" %>
<style type="text/css">
	.masthead {
		background: url("/resources/img/alley.jpg");
	}
	.idOk {
		display: none;
	}
	.idAlready {
		display: none;
	}
</style>
</head>
<body>
      	<header class="masthead d-flex align-items-center">
            <div class="container px-4 px-lg-7 text-center">
                 <main class="form-signin w-100 m-auto">
                  <form action="/member/joinus" id="joinus_form" method="post">
                    <img class="mb-4" src="/resources/img/diveintogutter.PNG" alt="" width="120" height="120">
                    <h4 class="h3 mb-3 fw-normal" style="color: #000080">Dive into the gutter</h4>

                    <div class="form-floating">
                      <input type="text" class="form-control" id="id" name="id" placeholder="ID" onchange="checkId()">
                      <label for="id">ID</label>
                      <!-- ajax로 id 중복 체크 -->
                      <span class="idOk">사용 가능한 아이디입니다.</span>
                      <span class="idAlready">중복 아이디입니다.</span>
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
                      <input type="text" class="form-control" id="name" name="name" placeholder="Name">
                      <label for="name">Name</label>
                    </div>
                    <div class="form-floating">
                      <input type="text" class="form-control" id="phone" name="phone" placeholder="Phone"
                      style="border-top-left-radius: 0;  border-top-right-radius: 0; border-bottom-left-radius: 4px; border-bottom-right-radius: 4px">
                      <label for="phone">Phone</label>
                    </div>
                    <br>
                    <div class="form-floating">
                      <input type="text" class="form-control" id="emailName" name="emailName" placeholder="Email">
                      <label for="emailName">Email</label>
                    </div>
                    <div class="form-floating">
                     <select class="form-select" id="emailDomain" name="emailDomain"
                     style="border-top-left-radius: 0;  border-top-right-radius: 0; border-top: 0px">
						  <option selected value="naver.com">@naver.com</option>
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
                    <input type="button" class="btn w-100 py-2" style="background-color: #000080; color: white" value="Join Us">
                  </form>
                </main>
            </div>
        </header>
</body>
<script>
$(document).ready(function() {
	/* 아이디 중복 검사 */
	checkId = function(){
		
		var csrfHeaderName = "${_csrf.headerName}";
		var csrfTokenValue = "${_csrf.token}"; 
		
		
		var id = $("#id").val();
		$.ajax({
			url: '/member/idCheck',
			type: 'post',
			data: {id : id}, 
			dataType: 'json',
			 contentType : 'application/x-www-form-urlencoded; charset=utf-8',
 			//processData : false,
			//contentType : false,
 			beforeSend: function(xhr){
				xhr.setRequestHeader(csrfHeaderName,csrfTokenValue);
	     	},
			success:function(result) {

				if(result == 0) {
					$('.idOk').css("display","inline-block");
					$('.idAlready').css("display","none");
				} else {
					$('.idOk').css("display","none");
					$('.idAlready').css("display","inline-block");
					alert("아이디를 다시 입력해 주세요.");
					$('#id').val('');
				}
			},
			error:function(request, status, error) {
				alert("에러입니다." + error);
			}
		});
	};
	
	// 회원가입 버튼
	$(".py-2").click(function() {
		// 이메일 도메인 결합
		var email_id = $("#emailName").val();
		var email_domain = $("#emailDomain").val();
		
		var mail = email_id+"@"+email_domain;
		
		// 유효성 검사 조건
		let checkID = RegExp(/^[a-z0-9]{4,20}$/);
		let checkPW = RegExp(/^(?=.*[a-zA-Z])(?=.*[!@#$%^*+=-])(?=.*[0-9]).{8,25}$/);
		let checkName = RegExp(/^[가-힣]|[A-Z]|[a-z]$/);
		let checkPhone = RegExp(/^(01[016789]{1})-[0-9]{3,4}-[0-9]{4}$/);        
		let checkEmail = RegExp(/^[a-z0-9]{2,30}$/);
		
		// 유효성 검사
		if($("#id").val() == "") {
            alert("아이디를 입력해 주세요.");               
            return false;
		}
		else if(!checkID.test($("#id").val())) {
			alert("아이디는 영문과 숫자를 이용하여 4~20 자로 설정해 주세요.");
			return false;
		}
		else if($("#password").val() == "") {
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
		$("#joinus_form").attr("action", "/member/joinus");
		$("#joinus_form").submit();
        
	});
});
</script>
</html>