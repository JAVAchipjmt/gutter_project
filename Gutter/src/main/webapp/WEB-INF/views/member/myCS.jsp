<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>My CS</title>
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
	<div class="container px-4 px-lg-5 text-center">
	<h4 style="color: #fff">My CS</h4>
	<br>
	<br>
		<div class="list-group text-center">
		<c:forEach var="cscenterBoard" items="${list}">
		    <a href='<c:out value="${cscenterBoard.bno}"/>' class="list-group-item list-group-item-action d-flex gap-3 py-3 move" aria-current="true">
		      <img src="/resources/img/wrench-solid.svg" alt="twbs" width="28" height="28">
		      <div class="d-flex gap-2 w-100 justify-content-between">
		        <div>
		          <h6 class="mb-0"><c:out value="${cscenterBoard.title}"/>&nbsp;
		          <span class="badge bg-primary rounded-pill"><c:out value="${cscenterBoard.replyCnt }" /></span>&nbsp;&nbsp;
		          <c:out value="${cscenterBoard.writer}"/>
		          </h6>
		        </div>
		        <small class="opacity-50 text-nowrap"><fmt:formatDate value="${cscenterBoard.regdate}" pattern="yyyy-MM-dd"/></small>
		      </div>
		    </a>
		   </c:forEach>
		  </div>
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
             <form id="actionForm" action="/menu/cscenterList" method="get">
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
		actionForm.attr("action","/menu/cscenterGet");
		actionForm.submit();
	});	
});
</script>
</html>