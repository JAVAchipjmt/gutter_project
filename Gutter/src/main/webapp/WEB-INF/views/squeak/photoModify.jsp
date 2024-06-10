<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Photo Modify</title>
<%@ include file="../includes/menu.jsp" %>
<style type="text/css">
	.masthead {
		background: url("/resources/img/dropdown.jpg");
	}
	.menu-toggle {
		background: #000;
	}
	label, .panel-heading {
		color: #fff;
	}
	
	.uploadResult {
		width: 100%;
		background-color: lightblue;
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
		align-content: center;
		text-align: center
	}
	
	.uploadResult ul li img {
		width: 100px;
	}
	
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
		background: rgba(255, 255, 255, 0.5);
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
				<div class="panel-heading"><h5>Photo 수정하기</h5></div>
				<div class="panel-body">
				<br>
		<div class="panel-body">
			<form role="form" action="/squeak/photoModify" method="post">
	     		<!-- 보안 관련 추가 -->					
				<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
				<div class="form-group">
					<input type="text" id="title" name="title" class="form-control" name="title"
					 value='<c:out value="${photo.title}"/>'>
				</div>
				<br>
				<div class="form-group">
					<input type="text" name="content" id="content" name="content" class="form-control"
					 value='<c:out value="${photo.content}"/>'>
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
								value='<c:out value="${photo.writer}"/>' readonly="readonly">
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
								value='<c:out value="${photo.bno}"/>' readonly="readonly">	
				</div>
				</div>
				</div> 
				</div>
				</div>
				<br>
						<sec:authentication property="principal" var="pinfo"/>
						<!-- 본인이 작성한 게시물의 경우 수정,삭제버튼을 보여준다 -->
						<sec:authorize access="isAuthenticated()">
							<c:if test="${pinfo.username eq photo.writer}">
								<button type="submit"
								        data-oper="modify"
								        class="btn btn-primary">
									수정
								</button>
								<button type="submit"
								        data-oper="remove"
								        class="btn btn-danger">
									삭제
								</button>							
							</c:if>
						</sec:authorize>
						<button type="submit"
						        data-oper="list" 
						        class="btn btn-warning">
							목록
						</button>
						<!-- 현재 페이지 번호와 행수를 CScenterController에 전달 -->
						<input type="hidden" name="pageNum" value='<c:out value="${cri.pageNum}"/>'>
						<input type="hidden" name="amount" value='<c:out value="${cri.amount}"/>'>
						<!-- 검색 조건과 검색 문자열 추가 -->
						<input type="hidden" name="type" value='<c:out value="${cri.type}"/>'>
						<input type="hidden" name="keyword" value='<c:out value="${cri.keyword}"/>'>
			</form> 
			<br>
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
							첨부 파일
						</div>
						<div class="panel-body">
								<div class="form-group uploadDiv">
									<input type="file" name="uploadFile" multiple style= "color:#fff">
								</div>
								<br>
							<div class="uploadResult">
								<ul></ul>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	</div>
	</div>
	</div>	
	</div>
</header>
</body>
<script>
$(document).ready(function(){
	
	//즉시실행함수
	(function(){
		var bno = '<c:out value="${photo.bno}"/>';
		
		//데이터는 json 형태로 리턴 
		//특정 게시물에 대한 첨부파일 목록을 가져온다.
		
			$.getJSON("/squeak/photoGet/getAttachList",{bno: bno},function(arr){
			
			var str = "";
			
			//반복문으로 첨부목록을 조회한다.
			$(arr).each(function(i, obj) {
									//업로드한 파일이 일반파일인 경우 아이콘을 출력
									if (!obj.fileType) {
										// 업로드 파일 경로
										var fileCallPath = encodeURIComponent(obj.uploadPath
												+ "/"
												+ obj.uuid
												+ "_"
												+ obj.fileName);
	
										//일반파일인 경우 a태그를 클릭시 다운로드 처리
										str += "<li ";
										str += "data-path='"+obj.uploadPath+"' data-uuid='"+obj.uuid+"' data-filename='"+obj.fileName+"' data-type='"+obj.fileType+"' ><div>"; 
										str += "<span>" + obj.fileName + "</span>";
										str += "&nbsp;<button type='button' data-file=\'"+fileCallPath+"\' data-type='file' class='btn btn-warning btn-circle'><i class='fa fa-times'></i></button><br>";
										str += "<img src='/resources/img/attach.png'>";
										str += "</div></li>";
									} else { //업로드한 파일이 이미지인 경우
										//encodeURIComponent ?
										//컴퓨터가 인식할 수 있도록 문자열을 바이트배열로 변환
										//업로드한 파일이 이미지인 경우 썸네일 파일을 보여준다.
										var fileCallPath = encodeURIComponent(obj.uploadPath
												+ "/s_"
												+ obj.uuid
												+ "_"
												+ obj.fileName);
	
										//업로드 파일이 있는 절대경로
										var originPath = obj.uploadPath + "\\" + obj.uuid + "_" + obj.fileName;
	
										originPath = originPath.replace(new RegExp(
												/\\/g), "/");
	
										//a 태그를 클릭하면 원본 이미지를 출력
										str += "<li ";
										str += "data-path='"+obj.uploadPath+"' data-uuid='"+obj.uuid+"' data-filename='"+obj.fileName+"' data-type='"+obj.fileType+"'><div>"; 
										str += "<span>" + obj.fileName + "</span>";
										str += "&nbsp;<button type='button' data-file=\'"+fileCallPath+"\' data-type='image' class='btn btn-warning btn-circle'><i class='fa fa-times'></i></button><br>";
										str += "<img src='/squeak/photoGet/display?fileName="
												+ fileCallPath + "'>";
										str += "</div>";
										str += "</li>";
									}
								});		
			
			//첨부파일 영역에 출력
			$(".uploadResult ul").html(str);
		});
		
	})();//즉시실행 함수 종료
	
	var regex = new RegExp("(.*?)\.(exe|sh|zip|alz)$");
	var maxSize = 5242880;//5M

	function checkExtension(fileName, fileSize) {

		if (fileSize >= maxSize) {
			alert("파일 크기 초과!");
			return false;
		}

		//정규표현식을 적용해서 true 되면 업로드 처리 불가
		if (regex.test(fileName)) {
			alert("해당 파일은 업로드할 수 없습니다!");
			return false;
		}

		return true;
	}

	
	var csrfHeaderName = "${_csrf.headerName}";
	var csrfTokenValue = "${_csrf.token}";
	
	$("input[type='file']").change(function(e) {

		var formData = new FormData();
		var inputFile = $("input[name='uploadFile']");
		var files = inputFile[0].files;

		for (var i = 0; i < files.length; i++) {

			if (!checkExtension(files[i].name, files[i].size)) {
				return false;
			}

			formData.append("uploadFile", files[i]);
		}

		$.ajax({
			url : "/squeak/photoRegister/uploadAjaxAction",
			type : "post",
			//클라이언트가 서버에서 전송받는 데이터 타입
			//을 선언
			dataType : "json",
			//ajax를 사용하여 업로드 처리를 하는 경우
			//밑에 있는 두개의 속성을 false로 지정해야 한다.
			processData : false,
			contentType : false,
			beforeSend: function(xhr){
				xhr.setRequestHeader(csrfHeaderName,csrfTokenValue);
			},
			//서버로 전송하는 데이터
			data : formData,
			success : function(result) {
				showUploadResult(result);
			}
		});
	});
	
	var uploadResult = $(".uploadResult ul");

	function showUploadResult(uploadResultArr) {

		//매개변수 값이 없으면 처리
		if (!uploadResultArr || uploadResultArr.length == 0) {
			return;
		}

		var str = "";

		//반복문을 사용해서 업로드한 파일명을 출력 
		$(uploadResultArr).each(function(i, obj) {
							//업로드한 파일이 일반파일인 경우 아이콘을 출력
							if (!obj.image) {
								// 업로드 파일 경로
								var fileCallPath = encodeURIComponent(
										obj.uploadPath + "/" +
										obj.uuid + "_" +
										obj.fileName);

								//일반파일인 경우 a태그를 클릭시 다운로드 처리
								str += "<li ";
								str += "data-path='"+obj.uploadPath+"' data-uuid='"+obj.uuid+"' data-filename='"+obj.fileName+"' data-type='"+obj.image+"' ><div>"; 
								str += "<span>" + obj.fileName + "</span>";
								str += "&nbsp;<button type='button' data-file=\'"+fileCallPath+"\' data-type='file' class='btn btn-warning btn-circle'><i class='fa fa-times'></i></button><br>";
								str += "<img src='/resources/img/attach.png'>";
								str += "</div></li>";
							} else { //업로드한 파일이 이미지인 경우
								//encodeURIComponent ?
								//컴퓨터가 인식할 수 있도록 문자열을 바이트배열로 변환
								//업로드한 파일이 이미지인 경우 썸네일 파일을 보여준다.
								var fileCallPath = encodeURIComponent(
										obj.uploadPath +
										"/s_" +
										obj.uuid + "_" +
										obj.fileName);

								//업로드 파일이 있는 절대경로
								var originPath = obj.uploadPath + "\\" + obj.uuid + "_" + obj.fileName;

								originPath = originPath.replace(new RegExp(/\\/g), "/");

								//a 태그를 클릭하면 원본 이미지를 출력
								str += "<li ";
								str += "data-path='"+obj.uploadPath+"' data-uuid='"+obj.uuid+"' data-filename='"+obj.fileName+"' data-type='"+obj.image+"'><div>"; 
								str += "<span>" + obj.fileName + "</span>";
								str += "&nbsp;<button type='button' data-file=\'"+fileCallPath+"\' data-type='image' class='btn btn-warning btn-circle'><i class='fa fa-times'></i></button><br>";
								str += "<img src='/squeak/photoGet/display?fileName="
										+ fileCallPath + "'>";
								str += "</div>";
								str += "</li>";
							}
						});

		//ul영역에 업로드한 파일내역이 추가
		uploadResult.append(str);
	}//		
	
	
	
	
	//form의 모든 정보를 변수에 대입
	var formObj = $("form[role='form']");
	
	//버튼을 클릭하면 이벤트정보가 매개변수 e 대입
	$("button").on("click",function(e){
		
		//원래 태그의 기능을 막는다.
		e.preventDefault();
		
		var operation = $(this).data("oper");
		
		//삭제 버튼을 클릭시 처리
		if(operation === "remove"){
			formObj.attr("action","/squeak/photoRemove");
			formObj.submit();
		}else if(operation === "modify"){
							
			// 첨부파일을 테이블에 저장하도록 데이터값을 전송
			var str = "";
			
			//업로드한 파일 내역을 반복문을 사용하여 문자열을 생성
			$(".uploadResult ul li").each(function(i,obj){
									//data-filename,data-uuid,data-path,data-type
				var jobj = $(obj);
				
				str += "<input type='hidden' name='attachList[" + i + "].fileName' value='"+jobj.data("filename")+"'>";
				str += "<input type='hidden' name='attachList[" + i + "].uuid' value='"+jobj.data("uuid")+"'>";
				str += "<input type='hidden' name='attachList[" + i + "].uploadPath' value='"+jobj.data("path")+"'>";
				str += "<input type='hidden' name='attachList[" + i + "].fileType' value='"+jobj.data("type")+"'>";
			});	
			formObj.append(str).submit();
			
		} else if(operation === "list") {
			//목록 버튼을 클릭한 경우 처리
			//empty() ? 태그는 그대로 두고 값만 삭제
			//remove() ? 태그,값도 모두 삭제		
			formObj.attr("action","/squeak/photoList")
			       .attr("method","get");
			
			var pageNumTag = $("input[name='pageNum']").clone();
			var amountTag = $("input[name='amount']").clone();
			
			var keywordTag = $("input[name='keyword']").clone();
			var typeTag = $("input[name='type']").clone();
			
			formObj.empty();
			
			formObj.append(pageNumTag);
			formObj.append(amountTag);
			
			formObj.append(keywordTag);
			formObj.append(typeTag);
			
			formObj.submit();
		}
		
		//수정 버튼을 클릭한 경우 처리
		//formObj.submit();
		
	});
	
	// 수정 화면에서 삭제 버튼 클릭 시 처리
	$(".uploadResult").on("click","button",function(e){

		if(confirm("삭제하시겠습니까?")){
			
			var targetLi = $(this).closest("li");
			
			targetLi.remove();
		}
	});
	
});//
</script>
</html>