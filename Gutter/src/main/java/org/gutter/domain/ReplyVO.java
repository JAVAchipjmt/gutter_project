package org.gutter.domain;

import java.util.Date;

import com.fasterxml.jackson.annotation.JsonFormat;

import lombok.Data;

@Data
public class ReplyVO {
	private Long rno; // 댓글 번호
	private Long bno; // 게시물 번호
	
	private String reply; // 댓글 내용
	private String replyer; // 댓글 작성자
	
//	날짜 타입으로 바꾸기
	@JsonFormat(pattern="yyyy-MM-dd HH:mm:ss", timezone="Asia/Seoul")
	private Date replyDate; // 댓글 등록 일자
	@JsonFormat(pattern="yyyy-MM-dd HH:mm:ss", timezone="Asia/Seoul")
	private Date updateDate; // 댓글 수정 일자
}
