package org.gutter.domain;

import lombok.Data;

@Data
public class AttachFileDTO {
	
	private String fileName;//업로드 파일명
	private String uploadPath;//업로드 경로
	private String uuid;//32자리 UUID 값
	private boolean image;//업로드 파일이 이미지인지 여부
}
