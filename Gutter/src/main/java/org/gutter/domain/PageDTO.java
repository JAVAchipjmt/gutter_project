package org.gutter.domain;

import lombok.Data;

@Data
public class PageDTO {
//	필드 선언
//	각 페이지 하단에 표시되는 시작 페이지
	private int startPage;
//	각 페이지 하단에 표시되는 종료 페이지
	private int endPage;
//	이전, 이후 페이지 출력 여부
	private boolean prev, next;
	
//	출력할 총 게시물 수
	private int total;
//	현재 페이지 게시물을 보여 주는 클래스
	private Criteria cri;
	
//	생성자
	public PageDTO(Criteria cri, int total) {
		
		this.cri = cri;
		this.total = total;
		
//		각 페이지에 대해서 endPage가 무엇인지 계산하는 식
		this.endPage = (int) (Math.ceil(cri.getPageNum() / 6.0)) * 10;
//		하단 종료 페이지 - 9 = 하단 시작 페이지
		this.startPage = this.endPage - 9;
		
//		실제 마지막 페이지
		int realEnd = (int) (Math.ceil((total * 1.0) / cri.getAmount()));
		
		if (realEnd < this.endPage) {
			this.endPage = realEnd;
		}
		
//		이전 페이지 체크
		this.prev = this.startPage > 1;
//		다음 페이지 체크
		this.next = this.endPage < realEnd;
	}
	
}