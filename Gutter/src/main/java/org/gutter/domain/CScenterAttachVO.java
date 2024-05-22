package org.gutter.domain;

import lombok.Data;

@Data
public class CScenterAttachVO {
	
	private String uuid; // 32자리 랜덤 문자열
	private String uploadPath; // 업로드 경로
	private String fileName; // 업로드 파일명
	private boolean fileType; // 업로드 파일 구분
	
	private Long bno; // 게시물 번호
	
}
