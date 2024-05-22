package org.gutter.service;

import java.util.List;

import org.gutter.domain.CScenterAttachVO;
import org.gutter.domain.CScenterVO;
import org.gutter.domain.Criteria;

public interface CScenterService {
	
	// 게시물 목록 조회 처리
	public List<CScenterVO> getList(Criteria cri);
	public int getTotal(Criteria cri);
	
	// 특정 게시물 상세 조회 처리
	public CScenterVO get(Long bno);
	
	// 게시물 등록 처리
	public void insert(CScenterVO cscenter) throws Exception;
	
	//	첨부 파일 목록 가져오기
	public List<CScenterAttachVO> getAttachList(Long bno);
	
	//특정 게시물 번호 수정 처리
	public boolean modify(CScenterVO cscenter);
	
	//특정 게시물 내역 삭제 처리
	public boolean remove(Long bno);
	
	public boolean removeReply(Long bno);
	
	// 내가 쓴 게시물 확인
	public List<CScenterVO> getMyList(Criteria cri);
}
