package org.gutter.domain;

import java.util.Date;
import java.util.List;

import lombok.Data;

@Data
public class CScenterVO {

	private Long bno;  // 게시물 번호
	private String title; // 게시물 제목
	private String content; // 게시물 내용
	private String writer; // 게시물 작성자
	private Date regdate; // 게시물 등록 일자
	private Date updateDate; // 게시물 수정 일자

	private int replyCnt; //댓글수
	
	//특정 게시물에 대한 첨부파일 목록을 가지는 리스트 선언
	private List<CScenterAttachVO> attachList;
	
	@Override
	public String toString() {
		return "CScenterVO [bno=" + bno + ", title=" + title + ", content=" + content + ", writer=" + writer
				+ ", regdate=" + regdate + ", updateDate=" + updateDate + ", replyCnt=" + replyCnt + ", attachList="
				+ attachList + "]";
	}
}
