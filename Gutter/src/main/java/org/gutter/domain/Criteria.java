package org.gutter.domain;

import org.springframework.web.util.UriComponentsBuilder;

import lombok.Data;

@Data
public class Criteria {

	private int pageNum;	// 현재 페이지 번호
	private int amount; // 한 페이지당 보여지는 행 수
	
//	검색 조건(제목, 내용, 작성자 등)
	private String type;
//	검색하려는 문자열
	private String keyword;
	
	public Criteria() {
//		매개변수 2 개 생성자 호출
		this(1,6);
	}
	public Criteria(int pageNum, int amount) {
		this.pageNum = pageNum;
		this.amount = amount;
	}
	
	public String[] getTypeArr() {
//		삼항 연산자
//		검색 조건을 선택한 경우 공백으로 분리하여 처리
		return type == null? new String[] {}: type.split("");
	}
	
//	현재 페이지 번호, 보여지는 행수, 검색 조건, 검색 문자열을 특정 URL에 매개변수로 전달하기 위해 사용
	public String getListLink() {
		
		UriComponentsBuilder builder = UriComponentsBuilder.fromPath("")
			.queryParam("pageNum", this.pageNum)
			.queryParam("amount", this.getAmount())
			.queryParam("type", this.getType())
			.queryParam("keyword", this.getKeyword());
			
		
		return builder.toUriString();
	}
}

