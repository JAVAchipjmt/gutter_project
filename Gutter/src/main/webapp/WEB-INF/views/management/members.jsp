<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<style type="text/css">
	.masthead {
		background: url("/resources/img/citynight.jpeg");
	}
</style>
<%@ include file="../includes/menu.jsp" %>
</head>
<body>
<header class="masthead d-flex align-items-center">
      <div class="container px-4 px-lg-5 text-center">
      <form role="form" id="memberForm" action="/management/quitMember" method="post"> 
       <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
       <input type="hidden" name="id" value="<c:out value='${member.id}'/>" />
		<table class="table">
		  <thead>
		    <tr>
		      <th scope="col">ID</th>
		      <th scope="col">NAME</th>
		      <th scope="col">PHONE</th>
		      <th scope="col">EMAIL</th>
		      <th scope="col">REGDATE</th>
		      <th scope="col">MANAGEMENT</th>
		    </tr>
		  </thead>
		  
		  <c:forEach var="member" items="${list}">
		  <tbody>
		    <tr>
		      <td scope="row">
				<c:out value="${member.id}"/>
		      </td>
		      <td><c:out value="${member.name}"/></td>
		      <td><c:out value="${member.phone}"/></td>
		      <td><c:out value="${member.email}"/></td>
		      <td><fmt:formatDate value="${member.regDate}" pattern="yyyy-MM-dd" /></td>
		      <td><button type="submit" data-oper="remove" class="btn btn-danger">강제 탈퇴</button></td>
		    </tr>
		  </tbody>
		  </c:forEach>
		</table>
	 </form>
	 
		 <!-- 게시물 검색조건 & 검색 문자열 추가 시작 -->
		<div class="d-grid gap-2 d-md-flex justify-content-md-start">
        <form id="searchForm" action="/management/members" method="get">
             <select name="type">
                  <option value="i" selected <c:out value="${pageMaker.cri.type eq 'i' ? 'selected' : ''}"/>>ID</option>
              </select>
                  <!-- 검색 문자열을 입력 -->
                  <input type="text" name="keyword" value='<c:out value="${pageMaker.cri.keyword}"/>'>
                  <input type="hidden" name="pageNum" value='<c:out value="${pageMaker.cri.pageNum}"/>'>
                  <input type="hidden" name="amount" value='<c:out value="${pageMaker.cri.amount}"/>'>
                  <button class="btn btn-primary">검색</button>
        </form>
        </div>
        
		<br>
         <!-- 화면 하단에 페이징 처리 시작 -->
         <div class="d-flex justify-content-center">
        	 <nav aria-label="Page navigation example">
                <ul class="pagination">
                      <c:if test="${pageMaker.prev}">
                           <li class="page-item">
                                <a class="page-link" href="${pageMaker.startPage - 1}" aria-label="Previous">
        						<span aria-hidden="true">&laquo;</span>
     							</a>
                           </li>
                       </c:if>
                        <c:forEach var="num" begin="${pageMaker.startPage}" end="${pageMaker.endPage}">
                         <li class="page-item ${pageMaker.cri.pageNum == num ? 'active':''}">
                         	<a class="page-link" href="${num}">${num}</a>
                         </li>
                         </c:forEach>
                         <c:if test="${pageMaker.next}">
                         <li class="page-item">
      						<a class="page-link" href="${pageMaker.endPage + 1}" aria-label="Next">
        					<span aria-hidden="true">&raquo;</span>
      						</a>
  						</li>
                        </c:if>
                  </ul>
               </nav>
            </div>
                            
            <!-- 화면 하단에 페이징 처리 종료 -->
             <form id="actionForm" action="/management/members" method="get">
           		   <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                   <input type="hidden" name="pageNum" value="${pageMaker.cri.pageNum}">
                   <input type="hidden" name="amount" value="${pageMaker.cri.amount}">
                    <!-- 검색조건,검색문자열을 hidden선언 -->
                   <input type="hidden" name="type" value="${pageMaker.cri.type}">
                   <input type="hidden" name="keyword" value="${pageMaker.cri.keyword}">
             </form>
      </div>             
</header>
</body>
<script>
$(document).ready(function(){
	
	var result = '<c:out value="${result}"/>';
	
	var formObj = $("form[role='form']");
	
	// 버튼을 클릭하면 이벤트 정보가 매개변수 e 대입
	$("#memberForm button").on("click",function(e){
		e.preventDefault();
		
		var operation = $(this).data("oper");
		
        	var str = ""
            var tdArr = new Array();    // 배열 선언
            var checkBtn = $(this);
            
            var tr = checkBtn.parent().parent();
            var td = tr.children();

            var userid = td.eq(0).text().trim();
            
            var msg = userid + " 찍찍이를 정말 쫓아내시겠습니까?";
            
		// 강제 탈퇴 버튼을 클릭 시 처리
		if(operation === "remove"){
			if(confirm(msg)) {
				formObj.attr("action","/management/quitMember");
				formObj.attr("method","post");
				formObj.submit();
				alert("쫓아내기 완료!");
			}  else {
				alert("쫓아내기 취소!");
			}
		}
	});

	
	var actionForm = $("#actionForm");
	
	/* 페이지 번호 처리 */
	$(".page-item a").on("click",function(e){
		
		// 태그의 원래 기능을 막는다
		e.preventDefault();
		
		// 클릭한 페이지 번호를 pageNum input태그에 
		// 값을 대입한 후 submit을 하면 해당 페이지로 이동
		actionForm.find("input[name='pageNum']")
		          .val($(this).attr("href"));
		actionForm.submit();
		
	});
	
	// 검색 버튼의 모든 정보를 변수에 대입
	var searchForm = $("#searchForm");
	
	$("#searchForm button").on("click",function(e){
		
		if(!searchForm.find("option:selected").val()){
			alert("검색 조건을 선택하세요!");
			return false;
		}
		
		//검색 문자열을 입력안한 경우
		if(!searchForm.find("input[name='keyword']").val()){
			alert("아이디를 입력하세요!");
			return false;
		}
		
		//검색한 후 1 페이지로 이동
		searchForm.find("input[name='pageNum']").val("1");
		e.preventDefault();
		
		//검색에서 입력받는 데이터를 서버로 전송
		searchForm.submit();
		
	});
});
</script>
</html>