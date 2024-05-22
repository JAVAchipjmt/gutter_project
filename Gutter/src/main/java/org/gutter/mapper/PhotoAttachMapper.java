package org.gutter.mapper;

import java.util.List;

import org.gutter.domain.CScenterAttachVO;

public interface PhotoAttachMapper {
	
	//신규 첨부파일 등록 처리
	public void insert(CScenterAttachVO vo);
	
	//특정 첨부파일 삭제 처리
	public void delete(String uuid);
	
	//특정 게시물에 대한 첨부파일 목록 처리
	public List<CScenterAttachVO> findByBno(Long bno);
	
	//게시물 삭제 시 첨부파일 함께 삭제
	public void deleteAll(Long bno);
	
	//테이블과 서버를 비교하여 필요없는 첨부파일 삭제
	public List<CScenterAttachVO> getOldFiles();
}
