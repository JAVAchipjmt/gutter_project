<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>문의</title>
<%@ include file="../includes/menu.jsp" %>
<style type="text/css">
	.masthead {
		background: url("/resources/img/cscenter.jpeg");
		background-position: center;
 		background-repeat: no-repeat;
  		background-size: cover;
	}
	label, .panel-heading {
		color: #fff;
	}
	.uploadResult {
		width: 100%;
		background-color: #fff;
	}
	
	.uploadResult ul {
		display: flex;
		flex-flow: row;
		justify-content: center;
		align-items: center;
	}
	
	.uploadResult ul li {
		list-style: none;
		padding: 10px;
		/* p543 */
		align-content: center;
		text-align: center
	}
	
	.uploadResult ul li img {
		width: 100px;
	}
	
	/* p543 */	
	.uploadResult ul li span {
		color: white;		
	}
	
	.bigPictureWrapper {
		position: absolute;
		display: none;
		justify-content: center;
		align-items: center;
		top: 0%;
		width: 100%;
		height: 100%;
		background-color: lightblue;
		z-index: 100;
		background: rgba(255,255,255,0.5);
	}
	
	.bigPicture {
		position: relative;
		display: flex;
		justify-content: center;
		align-items: center;
	}
	
	.bigPicture img {
		width: 600px;
	}
</style>
</head>
<body>
<header class="masthead d-flex align-items-center">
	<div class="container w-50 px-4 px-lg-5 text-center">
	<div class="row">
		<div class="col-lg-12">
			<div class="panel panel-danger">
				<div class="panel-heading"><h5>문의하기</h5></div>
				<div class="panel-body">
				<br>
		<div class="panel-body">
			<form id="form_cscenterRegister" method="post">
	     		<!-- 보안 관련 추가 -->					
				<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
				<div class="form-group">
					<input type="text" id="title" name="title" class="form-control" name="title"
					 value='<c:out value="${cscenter.title}"/>' readonly="readonly">
				</div>
				<br>
				<div class="form-group">
					<input type="text" name="content" id="content" name="content" class="form-control"
					 value='<c:out value="${cscenter.content}"/>' readonly="readonly">
				</div>
				<br>
				<div class="form-group">
				<div class="row g-3 align-items-center">
				<div class="col-auto">	
					<label for="writer" class="col-form-label">작성자</label>
				</div>
				<div class="col-auto">
					<input type="text" 
								id="writer"
								name="writer"
							    class="form-control" 
								value='<c:out value="${cscenter.writer}"/>' readonly="readonly">
				</div>
				<div class="form-group">
				<div class="row g-3 align-items-center">
				<div class="col-auto">
					<label for="bno" class="col-form-label">글 번호</label>
				</div>
				<div class="col-auto">
					<input type="text" 
								id="bno"
								class="form-control"
								name="bno"
								value='<c:out value="${cscenter.bno}"/>' readonly="readonly">	
				</div>
				</div>
				</div> 
				</div>
				</div>
				</form>
				</div>
				</div>
				</div>
			</div>
		</div>
		<br>
						<!-- 수정 버튼에 보안적용 -->
						<sec:authentication property="principal" 
						                    var="pinfo"/>
						
							<!-- 로그인한 사용자와 테이블의 게시물 사용자가 같으면
							즉 자기가 작성한 게시물의 경우 수정 버튼을 보여준다 -->
						<sec:authorize access="isAuthenticated()">
							<c:if test="${pinfo.username eq cscenter.writer}">
								<button data-oper="modify" 
					       				class="btn btn-primary">
									수정
								</button>		
							</c:if>
						</sec:authorize>

						<button data-oper="list" 
						        class="btn btn-danger">
							목록
						</button>
						<form id="operForm" action="/menu/cscenterModify" method="get">
							<input type="hidden" id="bno" name="bno" value='<c:out value="${cscenter.bno}"/>'>
							<input type="hidden" name="pageNum" value='<c:out value="${cri.pageNum}"/>'>
							<input type="hidden" name="amount" value='<c:out value="${cri.amount}"/>'>
							<input type="hidden" name="keyword" value='<c:out value="${cri.keyword}"/>'>
							<input type="hidden" name="writer" value='<c:out value="${cscenter.writer}"/>' >
							<input type="hidden" name="type" value='<c:out value="${cri.type}"/>'>
						</form>
						
	<!-- 이미지를 클릭했을 때 원본 이미지를 보여 주는 영역-->	
	<div class="bigPictureWrapper">
		<div class="bigPicture">
		</div>
	</div>
	<br>
	<div class="row">
		<div class="col-lg-12">
			<div class="panel panel-danger">
				<div class="panel-heading">
					첨부파일
				</div>
				<div class="panel-body">
					<div class="uploadResult rounded-pill">
						<ul></ul>
					</div>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 댓글 목록 시작 -->
	<div class="row rounded" style='background: #0d6efd; color: #fff; text-align: left'>
		<div class="col-lg-12">
			<div class="panel panel-danger">
				<div class="panel-heading">
					<i class="fa fa-comments fa-fw"></i>
					댓글
						<button id="addReplyBtn" class="btn btn-outline-light btn-sm pull-right m-2">
							등록
						</button>
				</div>
				<div class="panel-body">
					<ul class="chat">
						<li class="left clearfix" data-rno="12">
							<div class="header">
							</div>
						</li>
					</ul>
				</div>
				
				<!-- 댓글 페이징 화면 구현 -->
				<div class="panel-footer">
				</div>
				
			</div>
		</div>
	</div>
	<!-- 댓글 목록 종료 -->
	<!-- 댓글 등록 모달창 시작 -->
	<div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal" aria-hidden="true">
						&times;
					</button>
					<h4 class="modal-title" id="myModalLabel">댓글 등록</h4>
				</div>
				<div class="modal-body">
					<div class="form-group">
						<label>댓글 내용</label>
						<input class="form-control" name="reply" placeholder="신규 댓글 내용">
					</div>
					<div class="form-group">
						<label>댓글 작성자</label>
						<input class="form-control" name="replyer" placeholder="댓글 작성자">
					</div>
					<div class="form-group">
						<label>댓글 등록 일자</label>
						<input class="form-control" name="replyDate" value="">
					</div>
				</div>
				<div class="modal-footer">
					<button id="modalModBtn" type="button" class="btn btn-warning">수정</button>
					<button id="modalRemoveBtn" type="button" class="btn btn-danger">삭제</button>
					<button id="modalRegisterBtn" type="button" class="btn btn-success">등록</button>
					<button id="modalCloseBtn" type="button" class="btn btn-info">닫기</button>
				</div>
			</div>
		</div>
	</div>
	<!-- 댓글 등록 모달창 종료 -->
	</div>
</header>
</body>
<script src="/resources/dist/js/reply.js"></script>
<script>
$(document).ready(function(){

	// 즉시 실행함수
	(function(){
		var bno = '<c:out value="${cscenter.bno}"/>';
		
		// 데이터는 json 형태로 리턴 
		// 특정 게시물에 대한 첨부 파일 목록을 가져온다.
		
			$.getJSON("/menu/cscenterGet/getAttachList",{bno: bno},function(arr){
			
				var str = "";
				
				// 반복문으로 첨부 목록을 조회한다.
				$(arr).each(function(i,attach){
					
					
					// 첨부 파일이 이미지이면 처리
					if(attach.fileType){
						var fileCallPath = encodeURIComponent(attach.uploadPath + "/s_" + attach.uuid + "_" + attach.fileName);
						str += "<li data-path='"+attach.uploadPath+"' data-uuid='"+attach.uuid+"' data-filename='"+attach.fileName+"' data-type='"+attach.fileType+"'><div>";
						str += "<img src='/menu/cscenterGet/display?fileName="+fileCallPath+"'>";
						str += "</div>";
						str += "</li>";
					}else{ //첨부 파일이 일반파일이면 처리
						str += "<li data-path='"+attach.uploadPath+"' data-uuid='"+attach.uuid+"' data-filename='"+attach.fileName+"' data-type='"+attach.fileType+"' ><div>";
						str += "<span> " + attach.fileName + "</span><br/>";
						str += "<img src='/resources/img/attach.png'>";
						str += "</div>";
						str += "</li>";
					}
				});
				
				//첨부파일 영역에 출력
				$(".uploadResult ul").html(str);
			});
			
		})();
	
	// 첨부 파일 다운로드 처리 & 원본 이미지 출력
	$(".uploadResult").on("click","li",function(e){

		//li태그의 모든 정보를 변수에 대입
		var liObj = $(this);
		
		var path = encodeURIComponent(liObj.data("path") + "/" + liObj.data("uuid") + "_" + liObj.data("filename"));
		
		//이미지인 경우 처리
		if(liObj.data("type")){
			showImage(path.replace(new RegExp(/\\/g),"/"));
		}else{
			self.location = "/menu/cscenterGet/download?fileName=" + path;
		}
	});//
	
	//썸네일 파일을 클릭하면 원본 파일을 출력한다.
	function showImage(fileCallPath){
		
		//bigPictureWrapper : 원본 이미지를 보여주는 영역
		$(".bigPictureWrapper").css("display","flex").show();
		
		//원본이미지를 가로,세로 1초동안 서서히 100%로 보여준다.
		$(".bigPicture").html("<img src='/menu/cscenterGet/display?fileName=" + fileCallPath + "'>")
		                .animate({width:'100%',height: '100%'},1000);
	}//
	
	//p544 원본이미지 클릭시 숨기기
	$(".bigPictureWrapper").on("click",function(e){
		
		//원본 이미지를 클릭하면 1초동안 숨기기 선언
		$(".bigPicture").animate({width: '0%',height: '0%'},1000);
		
		setTimeout(() => {
			$(this).hide(); //원본이미지 숨기기
		},1000);
	});
	
	var operForm = $("#operForm");
	
	//수정 버튼을 클릭한 경우 처리
	$("button[data-oper='modify']").on("click",function(e){
		operForm.attr("action","/menu/cscenterModify")
		        .submit();
	});
	
	//목록 버튼을 클릭시 처리
	$("button[data-oper='list']").on("click",function(e){
		operForm.attr("action","/menu/cscenterList")
		        .submit();
	});
	
	//특정 게시물 번호를 변수에 대입
	var bnoValue = '<c:out value="${cscenter.bno}"/>';
	
	//댓글영역을 변수에 대입
	var replyUL = $(".chat");
	
	showList(1);
	
	//특정 게시물 번호에 대한 댓글을 조회하는 함수
	function showList(page){
		
		//list: 댓글목록을 가지는 변수
		replyService.getList({
			bno: bnoValue,page: page || 1
		},function(replyCnt,list){
			
			var str = "";
			
			if(list == null || list.length == 0){
				replyUL.html("");
				
				return;
			}
			
			//댓글이 존재하면
			for(var i=0;i<list.length;i++){
				
				str += "<li class='left clearfix' data-rno='"+list[i].rno+"'>";
				str += "<div><div class='header'><strong class='primary-font'>" + list[i].replyer + "</strong>&nbsp;";
				str += "<small class='pull-right'>" + list[i].replyDate + "</small></div>";
				str += "<p>" + list[i].reply + "</p></div></li>";
			}
			
			//댓글영역에 댓글목록을 출력
			replyUL.html(str);
			
			//추가
			showReplyPage(replyCnt);
		}); 
	}//
	
	//댓글 등록 모달창 버튼 처리
	//모달창 div 영역의 값을 변수에 대입
	var modal = $(".modal");
	
	//입력한 댓글내용을 변수에 대입
	var modalInputReply = modal.find("input[name='reply']");
	//입력한 댓글작성자를 변수에 대입
	var modalInputReplyer = modal.find("input[name='replyer']");
	//댓글 작성일을 변수에 대입
	var modalInputReplyDate = modal.find("input[name='replyDate']");
	
	//수정버튼의 모든 정보를 변수에 대입
	var modalModBtn = $("#modalModBtn");
	//삭제버튼의 모든 정보를 변수에 대입
	var modalRemoveBtn = $("#modalRemoveBtn");
	//등록버튼의 모든 정보를 변수에 대입
	var modalRegisterBtn = $("#modalRegisterBtn");
	//닫기버튼의 모든 정보를 변수에 대입		
	var modalCloseBtn = $("#modalCloseBtn");
	
	var replyer = null;
	
	/* 로그인한 사용자의 아이디를 변수에 대입 */
	<sec:authorize access="isAuthenticated()">
		replyer = '<sec:authentication property="principal.username"/>';
	</sec:authorize>
	
	var csrfHeaderName = "${_csrf.headerName}";
	var csrfTokenValue = "${_csrf.token}";
	
	
	//댓글등록 버튼을 클릭했을때 처리
	$("#addReplyBtn").on("click",function(e){
		
		//입력창을 클리어
		modal.find("input").val("");
		
		//모달창에 있는 작성자 input태그에 출력
		modal.find("input[name='replyer']").val(replyer);
		
		//댓글 등록일자 div영역을 숨기기
		modalInputReplyDate.closest("div").hide();
		modal.find("button[id != 'modalCloseBtn']").hide();
		
		//댓글등록 버튼을 보여주기
		modalRegisterBtn.show();
		
		//모달창 보여주기
		$(".modal").modal("show");
		
	});
	
	/* ajax가 선언된 곳에 beforeSend가 적용되는 효과 */
	$(document).ajaxSend(function(e,xhr,options){
		xhr.setRequestHeader(csrfHeaderName,csrfTokenValue);
	});
	
	//모달창 등록버튼 처리
	modalRegisterBtn.on("click",function(e){
		
		//객체형태
		var reply = {
			//모달창에서 입력한 댓글내용	
			reply: modalInputReply.val(),
			//모달창의 댓글작성자
			replyer: modalInputReplyer.val(),
			//댓글을 달려는 특정 게시물번호
			bno: bnoValue
		};
		
		//reply.js에 댓글등록 처리
		replyService.add(reply,function(result){
				
			//댓글등록후 화면 클리어
			modal.find("input").val("");
			//모달창 닫기
			modal.modal("hide");
			
			//1페이지 새로고침
			showList(1);
		});
		
	});//
	
	//댓글 목록에서 특정 댓글 클릭시 상세보기 모달창 구현
	$(".chat").on("click","li",function(e){
					
		//현재 클릭한 댓글번호를 변수에 대입
		var rno = $(this).data("rno");
		
		//reply:특정 댓글내역을 가지고 있는 변수
		replyService.get(rno,function(reply){
			
			//리턴된 댓글내용을 모달창에 표시
			modalInputReply.val(reply.reply);
			//리턴된 댓글작성자를 모달창에 표시
			modalInputReplyer.val(reply.replyer)
			                 .attr("readonly","readonly");
			//리턴된 댓글 작성일자를 모달창에 표시
			modalInputReplyDate.val(reply.replyDate)
			                   .attr("readonly","readonly");
			
			//모달창의 data-rno 속성에 리턴된 댓글번호를 대입
			modal.data("rno",reply.rno);
			
			modal.find("button[id != 'modalCloseBtn']").hide();
			
			//댓글 수정 & 삭제 버튼을 보이기
			modalModBtn.show();
			modalRemoveBtn.show();
			
			//모달창 보이기
			$(".modal").modal("show");
			
		});
		
	});
	
	// 모달창 수정버튼 클릭 처리
	modalModBtn.on("click",function(e){
		
		//모달창 작성자를 변수에 대입
		var originalReplyer = modalInputReplyer.val();
		
		//댓글 객체를 생성
		var reply = {
			rno: modal.data("rno"),
			reply: modalInputReply.val(),
			replyer: originalReplyer
		};
		
		if(!replyer){
			
			alert("로그인 후 수정이 가능합니다.");
			modal.modal("hide");
			return;
		}
		
		if(replyer != originalReplyer){
			
			alert("자신이 작성한 댓글만 수정 가능합니다.");
			modal.modal("hide");
			return;	
		}

		replyService.update(reply,function(result){
			
			//정상적으로 댓글 수정후 모달창 닫기 & 화면 새로고침
			//alert(result);
			
			modal.modal("hide");
			
			showList(pageNum);
		});
		
	});
	
	// 모달창 삭제버튼 클릭 처리
	modalRemoveBtn.on("click",function(e){
		
		//삭제하려는 댓글번호를 변수에 대입
		var rno = modal.data("rno");
		
		if(!replyer){
			
			alert("로그인 후 삭제 가능합니다.");
			modal.modal("hide");
			return;
		}
		
		var originalReplyer = modalInputReplyer.val();
		
		//모달창의 작성자와 로그인한 사용자를 비교
		if(replyer != originalReplyer){
			
			alert("자신이 작성한 댓글만 삭제가 가능합니다.");
			modal.modal("hide");
			return;	
		}
		
		replyService.remove(rno,originalReplyer,function(result){
			
			alert("댓글 삭제 성공!");
			
			modal.modal("hide");
			
			showList(pageNum);
		});
	
	});
	
	//모달 닫기 버튼 클릭 처리
	modalCloseBtn.on("click",function(e){
		
		$(".modal").modal("hide");
	});
	
	// 댓글 페이징 처리
	
	var pageNum = 1;
	
	//페이징 처리 영역의 정보를 변수에 대입
	var replyPageFooter = $(".panel-footer");
	
	function  showReplyPage(replyCnt){
		
		//화면 하단의 종료 페이지번호
		var endNum = Math.ceil(pageNum /10.0) * 10;
		//화면 하단의 시작 페이지번호
		var startNum = endNum - 9;
		
		//이전페이지 여부 체크
		var prev = startNum != 1;
		//다음페이지 존재여부
		var next = false;
		
		//종료페이지 계산 처리
		if(endNum * 10 >= replyCnt){
			endNum = Math.ceil(replyCnt / 10.0);
		}
		
		//다음페이지 존재 지정
		if(endNum * 10 < replyCnt) {
			next = true;
		}
		
		var str = "<ul class='pagination pull-right'>";
		
		/* 이전페이지 표시 여부 */
		if(prev){
			str += "<li class='page-item'><a class='page-link' href='"+(startNum-1)+"'>이전</a></li>";
		}
		
		for(var i=startNum;i<=endNum;i++){
			
			//현재 작업중인 페이지 인경우 active 상태로 변경
			var active = pageNum == i ? "active" : "";
			
			str += "<li class='page-item " + active + "'><a class='page-link' href='"+i+"'>" + i + "</a></li>"; 
		}			
		
		/* 다음 페이지 처리 */
		if(next){
			str += "<li class='page-item'><a class='page-link' href='"+(endNum+1)+"'>다음</a></li>";
		}
		
		str += "</ul></div>";
		
		//댓글 페이징 처리 화면에 반영
		replyPageFooter.html(str);
			
	}
	
	replyPageFooter.on("click","li a",function(e){
		
		e.preventDefault();
		
		var targetPageNum = $(this).attr("href");
		
		pageNum = targetPageNum;
		
		showList(pageNum);
		
	});
});//ready
</script>
</html>