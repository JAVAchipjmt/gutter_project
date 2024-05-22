package org.gutter.controller;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.nio.file.Files;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.UUID;

import org.gutter.domain.AttachFileDTO;
import org.springframework.core.io.FileSystemResource;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import lombok.extern.log4j.Log4j;
import net.coobird.thumbnailator.Thumbnailator;

@RequestMapping("/menu/*")
@Controller
@Log4j
public class CScenterUploadController {
	
	
	// ajax를 활용하여 업로드 처리
	@PreAuthorize("isAuthenticated()")
	@PostMapping(value="/cscenterRegister/uploadAjaxAction",
			     //서버가 클라이턴트에게 응답처리시
			     //데이터를 JSON형태로 보내준다는 선언
			     produces=MediaType.APPLICATION_JSON_UTF8_VALUE)
	
	//자바 클래스 형태를 http 요청의 Body에 매핑하여 클라이
	//언트로 전송하는 역할을 하는 어노테이션
	@ResponseBody
	//ResponseEntity : 데이터를 클라이언트에게 전송하고
	//HttpStatus값을 지정
	public ResponseEntity<List<AttachFileDTO>> uploadAjaxPost(MultipartFile[] uploadFile) {
		
		System.out.println("uploadAjaxPost=======>");
		
		//첨부파일을 담기위해 ArrayList를 선언
		List<AttachFileDTO> list = new ArrayList<>();
		
		//업로드 폴더 선언
		String uploadFolder = "/Users/hykim/Documents/SpringStudy/Gutter/src/main/webapp/resources/images";
		
		//517
		String uploadFolderPath = getFolder();
		
		//2024/03/27 리턴
		File uploadPath = new File(uploadFolder,uploadFolderPath);
		
		//업로드 폴더가 존재하지 않으면 처리
		if(uploadPath.exists() == false) {
			
//			upload 폴더
//			2024 폴더
//			03 폴더
//			27 폴더
			uploadPath.mkdirs();
		}
		
		//반복문을 사용하여 업로드 파일내역을 출력
		for(MultipartFile multipartFile : uploadFile) {
			
			//p518
			//ArrayList에 담을 AttachFileDTO 인스턴스 생성
			AttachFileDTO attachDTO = new AttachFileDTO();

			String uploadFileName = multipartFile.getOriginalFilename();

			uploadFileName = uploadFileName.substring(uploadFileName.lastIndexOf("/")+1);
			
			//p518 (1)
			attachDTO.setFileName(uploadFileName);			
			
			//p511 UUID를 적용해서 파일 생성
			//32자리의 UUID를 랜덤하게 생성
			UUID uuid = UUID.randomUUID();
			
			uploadFileName = 
				uuid.toString() + "_" + uploadFileName;
			
			try {
				
				File saveFile = new File(uploadPath,uploadFileName);
				
				//업로드한 원본파일이름으로 upload 폴더에 전송
				multipartFile.transferTo(saveFile);
				
				//518 2-3
				attachDTO.setUuid(uuid.toString());
				attachDTO.setUploadPath(uploadFolderPath);
				
				//p514
				//만약 업로드한 파일이 이미지 이면 처리
				if(checkImageType(saveFile)) {
					
					//p518 4
					attachDTO.setImage(true);
					
					//썸네일 파일 생성
					FileOutputStream thumbnail = new FileOutputStream(new File(uploadPath,"s_" + uploadFileName));
					
					//메서드가 static으로 선언
					//가로 100,세로 100 크기의 썸네일 파일 생성
					Thumbnailator.createThumbnail(multipartFile.getInputStream(),thumbnail,100,100);
					thumbnail.close();
				}
				
				//첨부파일 내역을 ArrayList에 추가
				list.add(attachDTO);
				
			}catch(Exception e) {
				log.error(e.getMessage());
			}
		}
		
		return new ResponseEntity<>(list,HttpStatus.OK);
	}
	//업로드를 실행시 upload 폴더에
	//오늘일자의 폴더를 자동으로 생성
	private String getFolder() {
		
		//원하는 패턴으로 날짜를 지정하는 클래스
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		
		Date date = new Date();
		
		//현재 일시를 원하는 패턴으로 변환
		String str = sdf.format(date);
		
		return str.replace("-",File.separator);
	}//
	
	private boolean checkImageType(File file) {
		
		try {
			
			//매개변수로 전달된 파일의 MIME 값을 가져와 변수에 대입
			//image/jpg,image/gif,image/jpeg
			String contentType = Files.probeContentType(file.toPath());
			
			//MIME이 image로 시작되면 true 아니면 false 리턴
			return contentType.startsWith("image");
			
		}catch(IOException e) {
			e.printStackTrace();
		}
		
		return false;
	}
	
	// 업로드 파일이 이미지인 경우 썸네일 보여주기
	//매개변수로 입력받은 이미지를 보여준다
	@GetMapping("/cscenterGet/display")
	@ResponseBody
	public ResponseEntity<byte[]> getFile(String fileName){
		
		File file = new File("/Users/hykim/Documents/SpringStudy/Gutter/src/main/webapp/resources/images/" + fileName);
		
		ResponseEntity<byte[]> result = null;
		
		try {
			//헤더 정보를 가져오는 객체
			HttpHeaders header = new HttpHeaders();
			
			//MIME을 image/jpg 헤더에 추가
			header.add("Content-Type",Files.probeContentType(file.toPath()));
			
			result = new ResponseEntity<>(FileCopyUtils.copyToByteArray(file),header,HttpStatus.OK);
			
		}catch(IOException e) {
			e.printStackTrace();
		}
		
		return result;
	}
	
	// 첨부파일 다운로드 처리
	@GetMapping(
		value="/cscenterGet/download",
		//파일 다운로드 처리시 선언
		produces=MediaType.APPLICATION_OCTET_STREAM_VALUE)
	@ResponseBody
	//Resource? 자원에 대한 정보를 가지고 있는 객체
	//@RequestHeader? Http 요청 헤더 정보를 리턴하는 객체
	//User-Agent? 클라이언트가 요청한 브라우저의 종류를 가지고 있음
	public ResponseEntity<Resource> downloadFile(@RequestHeader("User-Agent") String userAgent,String fileName){
		
		Resource resource = new FileSystemResource("/Users/hykim/Documents/SpringStudy/Gutter/src/main/webapp/resources/images/" + fileName);
		//만약에 해당 파일이 없으면
		if(resource.exists() == false) {
			//파일이 없으면 404 리턴
			return new ResponseEntity<>(HttpStatus.NOT_FOUND);
		}
		
		//다운로드 하려는 파일이름을 변수에 대입
		String resourceName = resource.getFilename();
		
		//p539 UUID 명을 제외하고 실제 파일명만 가져온다.
		String resourceOriginalName = resourceName.substring(resourceName.indexOf("_") + 1);
		
		HttpHeaders headers = new HttpHeaders();
		
		try {
			
			String downloadName = null;
			
			//Internet Explorer 브라우저를 사용
			if(userAgent.contains("Trident")) {
				downloadName = URLEncoder.encode(resourceOriginalName,"UTF-8").replaceAll("/+","");
			}else if(userAgent.contains("Edge")) {
				//브라우저가 Edge에서 실행시 
				downloadName = URLEncoder.encode(resourceOriginalName,"UTF-8");
			}else {
				//기타 브라우저인 경우 처리
				downloadName = new String(resourceOriginalName.getBytes("UTF-8"),"ISO-8859-1");
			}
			
			//파일 다운로드 처리 헤더 정보
			headers.add("Content-Disposition","attachment; filename=" + downloadName);
			
		}catch(UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		
		return new ResponseEntity<Resource>(resource,headers,HttpStatus.OK);
		
	}
	
	//p548 첨부파일 삭제처리
	@PreAuthorize("isAuthenticated()")
	@PostMapping("/cscenterRegister/deleteFile")
	@ResponseBody
	public ResponseEntity<String> deleteFile(String fileName,String type){

		File file;
		
		try {
			
			// upload 폴더에 있는 파일명을 찾아서 삭제
			file = new File("/Users/hykim/Documents/SpringStudy/Gutter/src/main/webapp/resources/images/" + URLDecoder.decode(fileName,"UTF-8"));
			
			file.delete();
			
			// 삭제하려는 첨부 파일이 이미지이면 
			// 썸네일 파일도 함께 삭제처리
			if(type.equals("image")) {
			
				String largeFileName = file.getAbsolutePath().replace("s_","");
				
				file = new File(largeFileName);
				
				file.delete();
			}
					
		}catch(UnsupportedEncodingException e) {
			e.printStackTrace();
			
			return new ResponseEntity<>(HttpStatus.NOT_FOUND);
		}
		
		HttpHeaders header = new HttpHeaders();
		
		// 한글 깨짐 방지를 위한 헤더 정보 변경
		header.add("Content-Type","text/html;charset=UTF-8");
		
		// 삭제성 공시 
		return new ResponseEntity<String>("정상적으로 삭제!",header,HttpStatus.OK);
	}

}
