package org.gutter.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.gutter.domain.Criteria;
import org.gutter.domain.ReplyVO;

public interface PhotoReplyMapper {
//	신규 댓글 등록 처리
	public int insert(ReplyVO vo);
//	특정 댓글 읽기
	public ReplyVO read(Long rno);
//	특정 댓글 삭제 처리
	public int delete(Long rno);
//	특정 댓글 수정 처리
	public int update(ReplyVO reply);
//	댓글 페이징 처리
//	@Param:  URL에 있는 매개변수 값을 가져올 때 사용
	public List<ReplyVO> getListWithPaging(
			@Param("cri") Criteria cri,
			@Param("bno") Long bno);
//	댓글 숫자 파악
	public int getCountByBno(Long bno);
}
