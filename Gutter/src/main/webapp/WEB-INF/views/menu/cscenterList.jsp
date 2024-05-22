<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>CS Center</title>
<%@ include file="../includes/menu.jsp" %>
<style type="text/css">
	.masthead {
		background: url("/resources/img/cscenter.jpeg");
		background-position: center;
 		background-repeat: no-repeat;
  		background-size: cover;
	}
	.list-group-item {
		background: #BCD4E6;
	}
	.list-group-item:hover {
		background: #89CFF0;
	}
</style>
</head>
<body>
<header class="masthead d-flex align-items-center">
	<div class="container w-50 px-4 px-lg-5 text-center">
	<h4 style="color: #fff">CS Center</h4>
	<br>
	<!-- 로그인했을 시 작성하기 버튼 출력 -->
    <sec:authorize access="isAuthenticated()">
		<div class="d-grid gap-2 d-md-flex justify-content-md-end">
		<input type="button" class="btn btn-primary py-2" id="regBtn" value="작성하기">
		</div>
	</sec:authorize>
	<br>
		<div class="list-group text-center">
		<c:forEach var="cscenterBoard" items="${list}">
		    <a href='/menu/cscenterGet?bno=${cscenterBoard.bno}&writer=${cscenterBoard.writer}' class="list-group-item list-group-item-action d-flex gap-3 py-3 move" aria-current="true">
		      <img src="/resources/img/wrench-solid.svg" alt="twbs" width="28" height="28">
		      <div class="d-flex gap-2 w-100 justify-content-between">
		        <div>
		          <h6 class="mb-0"><c:out value="${cscenterBoard.title}"/>&nbsp;
		          <span class="badge bg-primary rounded-pill"><c:out value="${cscenterBoard.replyCnt }" /></span>&nbsp;&nbsp;
		          <span><c:out value="${cscenterBoard.writer}"/></span>
		          <input type="hidden" value='<c:out value="${cscenterBoard.writer}"/>' id="writer">
		          </h6>
		        </div>
		        <small class="opacity-50 text-nowrap"><fmt:formatDate value="${cscenterBoard.regdate}" pattern="yyyy-MM-dd"/></small>
		      </div>
		    </a>
		   </c:forEach>
		  </div>
		<br>
		 <!-- 게시물 검색조건 & 검색 문자열 추가 시작 -->
		<div class="d-grid gap-2 d-md-flex justify-content-md-start">
        <form id="searchForm" action="/menu/cscenterList" method="get">
             <select name="type">
                  <option value="" <c:out value="${pageMaker.cri.type == null ? 'selected' : ''}"/>>선택하기</option>
                  <option value="T" <c:out value="${pageMaker.cri.type eq 'T' ? 'selected' : ''}"/>>제목</option>
                  <option value="C" <c:out value="${pageMaker.cri.type eq 'C' ? 'selected' : ''}"/>>내용</option>
                  <option value="W" <c:out value="${pageMaker.cri.type eq 'W' ? 'selected' : ''}"/>>작성자</option>
                  <option value="TC" <c:out value="${pageMaker.cri.type eq 'TC' ? 'selected' : ''}"/>>제목, 내용</option>
                  <option value="TW" <c:out value="${pageMaker.cri.type eq 'TW' ? 'selected' : ''}"/>>제목, 작성자</option>
                  <option value="TWC" <c:out value="${pageMaker.cri.type eq 'TWC' ? 'selected' : ''}"/>>제목, 내용, 작성자</option>
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
             <form id="actionForm" action="/menu/cscenterList" method="get">
				   <!-- 보안 관련 추가 -->					
				   <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                   <input type="hidden" name="pageNum" value="${pageMaker.cri.pageNum}">
                   <input type="hidden" name="amount" value="${pageMaker.cri.amount}">
                    <!-- 검색조건,검색문자열을 hidden선언 -->
                   <input type="hidden" name="type" value="${pageMaker.cri.type}">
                   <input type="hidden" name="keyword" value="${pageMaker.cri.keyword}">
             </form>
      </div>                    
	 </div>
</header>
</body>
<script>
$(document).ready(function(){
	var result = '<c:out value="${result}"/>';
	//밑에 선언한 함수를 호출
	//호이스팅(함수호출을 먼저해도 된다)
/* 	checkModal(result); */
	
	/* 게시물 등록 버튼 처리 */
	$("#regBtn").on("click",function(){
		self.location = "/menu/cscenterRegister";
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
	
	// 제목을 클릭한 경우 게시물 상세보기 화면으로 이동
/* 	$(".move").on("click",function(e){
		e.preventDefault();
		actionForm.append("<input type='hidden' name='bno' value='"+ $(this).attr("href") + "'>");
		var list = new Array();
		$("input[id=writer]").each(function(index,item){
			list.push($(item).val());
			var writer = $(item[index]).text();
		});
		console.log(list);
		alert(writer);
		actionForm.append("<input type='hidden' name='writer' value='"+ writer + "'>");
		actionForm.attr("action","/menu/cscenterGet");
		actionForm.submit();
	});
	 */
	// 검색 버튼의 모든 정보를 변수에 대입
	var searchForm = $("#searchForm");
	
	$("#searchForm button").on("click",function(e){
		
		if(!searchForm.find("option:selected").val()){
			alert("검색 조건을 선택하세요!");
			return false;
		}
		
		//검색 문자열을 입력안한 경우
		if(!searchForm.find("input[name='keyword']").val()){
			alert("키워드를 입력하세요!");
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