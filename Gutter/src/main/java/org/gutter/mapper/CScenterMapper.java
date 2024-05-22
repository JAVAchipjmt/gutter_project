package org.gutter.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.gutter.domain.CScenterVO;
import org.gutter.domain.Criteria;

public interface CScenterMapper {
	
//	게시물 목록 조회 
	public List<CScenterVO> getList();
	
//	페이징 처리
	public List<CScenterVO> getListWithPaging(Criteria cri);
	
//	특정 게시물 번호에 대한 상세 내역 처리
	public CScenterVO read(Long bno);
	
//	전체 행수 처리
	public int getTotalCount(Criteria cri);
	
	public void updateReplyCnt(@Param("bno") Long bno, @Param("amount") int mount);
	
//	게시물 등록 처리
	public void insert(CScenterVO board);
	
//	특정 게시물 번호에 대한 내역 삭제 처리
//	delete문을 수행 후 delete된 행수를 리턴받기 때문에 int로 선언해 둠
	public int delete(Long bno);
	
	public int deleteReply(Long bno);
	
//	특정 게시물 내역 수정 처리
	public int update(CScenterVO board);
	
//	멤버 mypage 내가 쓴 게시물 조회
	public List<CScenterVO> getMyList();
}
