<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Photo Register</title>
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
				<div class="panel-heading"><h5>사진 공유</h5></div>
				<div class="panel-body">
				<br>
		<div class="panel-body">
			<form role="form" action="/squeak/photoRegister" method="post">
				<!-- 보안 관련 추가 -->					
				<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
	     		
				<div class="form-group">
					<input type="text" id="title" class="form-control" name="title" placeholder="제목">
				</div>
				<br>
				<div class="form-group">
					<textarea name="content" id="content" class="form-control"
								    rows="3" cols="50" placeholder="내용"></textarea>
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
							    class="form-control" 
								name="writer"
								value='<sec:authentication property="principal.username"/>'
								readonly="readonly">	
				</div> 
				</div>
				</div>
				<br>
				<input type="button" class="btn btn-primary" value="등록">
				<button type="reset" class="btn btn-danger">취소</button>
			</form>
			<br>
				<div class="row">
					<div class="col-lg-12">
						<div class="panel panel-info">
							<div class="panel-heading">이미지 첨부</div>
							<div class="panel-body">
								<div class="form-group uploadDiv">
									<input type="file" name="uploadFile" multiple style= "color:#fff">
								</div>
								<br>
								<!-- 첨부파일 표시 영역 -->
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
	
	var formObj = $("form[role='form']");

	$("input[type='button']").on("click", function(e) {
		
		e.preventDefault();
		
		//p564 첨부파일을 테이블에 저장하도록 데이터값을 전송
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
	});
	
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
	/* Ajax에 보안 적용 */
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
			// 보안관련 값을 헤더에 보내줘야 한다.
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
	
	// X 삭제표시 클릭시 처리
	$(".uploadResult").on("click","button",function(e){
		
		//span 태그(X:삭제)를 클릭했을때 data-file 속성값을
		//변수에 대입
		var targetFile = $(this).data("file");
		//span 태그(X:삭제)를 클릭했을때 data-type 속성값을
		//변수에 대입
		var type = $(this).data("type");
		
		$.ajax({
			url: "/squeak/photoRegister/deleteFile",
			type: "post",
			//URL의 매개변수를 지정하는 속성
			//http://localhost:8080/deleteFile?fileName=test.jpg&type=image
			data: {fileName: targetFile, type: type},
			beforeSend: function(xhr){
				xhr.setRequestHeader(csrfHeaderName,csrfTokenValue);
			},
			dataType: "text",
			success: function(result){
				alert(result);
			}
		});//
		
		//파일 삭제 버튼을 클릭시 화면에서도 삭제
		//span X 삭제표시를 클릭하면 span을 포함하고 있는
		//li 태그정보를 삭제한다
		var deleteLi = $(this).closest("li");
		deleteLi.remove();
		
	});			
	
}); // ready

	var uploadResult = $(".uploadResult ul");
	
	function showUploadResult(uploadResultArr) {
	
		// 매개변수 값이 없으면 처리
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
</script>
</html>