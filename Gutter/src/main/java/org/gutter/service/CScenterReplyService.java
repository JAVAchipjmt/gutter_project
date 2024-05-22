package org.gutter.service;

import java.util.List;

import org.gutter.domain.Criteria;
import org.gutter.domain.ReplyPageDTO;
import org.gutter.domain.ReplyVO;

public interface CScenterReplyService {
//	신규 댓글 입력
	public int register(ReplyVO vo);
//	특정 댓글 상세 보기 처리
	public ReplyVO get(Long rno);
//	특정 댓글 수정
	public int modify(ReplyVO vo);
// 특정 댓글 삭제
	public int remove(Long rno);
//	댓글 목록 처리
	public List<ReplyVO> getList(Criteria cri, Long bno);
//	댓글 건수를 포함한 댓글 목록 처리
	public ReplyPageDTO getListPage(Criteria cri, Long bno);
}
