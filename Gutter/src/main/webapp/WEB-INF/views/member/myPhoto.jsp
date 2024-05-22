<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>My Photo</title>
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
	<h4 style="color: #fff">My Photo</h4>
	<br>
	<br>
		<div class="row row-cols-1 row-cols-md-3 g-4">
	<c:forEach var="photoBoard" items="${list}">
	<div class="col">
	  <div class="card border-info mb-3" style="max-width: 18rem;">
		    <a href='<c:out value="${photoBoard.bno}"/>' class="move">
		    	<div class="card-header"><c:out value="${photoBoard.title}"/></div>
		    </a>
		    <div class="card-body">
		      <p class="card-title"><img src="/resources/img/cheese.PNG" alt="cheese" width="70">&nbsp;&nbsp;<span class="badge bg-primary rounded-pill">댓글: <c:out value="${photoBoard.replyCnt }" /></span></p>
		      <p class="card-text"><c:out value="${photoBoard.writer}"/> / <fmt:formatDate value="${photoBoard.regdate}" pattern="yyyy-MM-dd"/></p>
		    </div>
		</div>
	</div>
	</c:forEach>
	</div>
		<br>
		<img class="mb-4" src="/resources/img/joinus.PNG" alt="" width="120" height="120">
	<br>
	         <!-- 화면 하단에 페이징 처리 시작 -->
         <!-- 페이징 처리를 화면 오른쪽에 표시 -->
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
             <form id="actionForm" action="/squeak/photoList" method="get">
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
	$(".move").on("click",function(e){
		
		e.preventDefault();
		
		actionForm.append("<input type='hidden' name='bno' value='"+ $(this).attr("href") + "'>");
		actionForm.attr("action","/squeak/photoGet");
		actionForm.submit();
	});	
});
</script>
</html>