package org.gutter.service;

import java.util.List;

import org.gutter.domain.CScenterAttachVO;
import org.gutter.domain.CScenterVO;
import org.gutter.domain.Criteria;
import org.gutter.mapper.CScenterAttachMapper;
import org.gutter.mapper.CScenterMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import lombok.AllArgsConstructor;
import lombok.extern.log4j.Log4j;

@Service
@Log4j
@AllArgsConstructor
public class CScenterServiceImpl implements CScenterService {

	@Autowired
	private CScenterMapper cscenterMapper;

	@Autowired
	private CScenterAttachMapper attachMapper;
	
//	게시물 목록 조회 처리
	@Override
	public List<CScenterVO> getList(Criteria cri) {
		log.info("criteria와 목록 가져오기: " + cri);
		return cscenterMapper.getListWithPaging(cri);
	}
// 전체 행수 구하기
	@Override
	public int getTotal(Criteria cri) {
		// TODO Auto-generated method stub
		return cscenterMapper.getTotalCount(cri);
	}
	
	// 게시물 상세 조회
	@Override
	public CScenterVO get(Long bno) {
		
		log.info("게시물 상세보기:" + bno);
		
		return cscenterMapper.read(bno);
	}
	
	// 게시물 작성
	@Override
	public void insert(CScenterVO cscenter) throws Exception {
		cscenterMapper.insert(cscenter);
		
		if(cscenter.getAttachList()==null || cscenter.getAttachList().size() == 0) {
			return;
		}
		
//		첨부 파일을 테이블에 추가
		cscenter.getAttachList().forEach(attach -> {
//			첨부 파일 내역에 게시물 번호를 대입
			attach.setBno(cscenter.getBno());
			attachMapper.insert(attach);
		});
	}
	
	//	특정 게시물에 대한 첨부 파일 목록
	@Override
	public List<CScenterAttachVO> getAttachList(Long bno) {
		
		return attachMapper.findByBno(bno);
	}

	// 게시물 수정
	@Transactional
	@Override
	public boolean modify(CScenterVO cscenter) {
		
		attachMapper.deleteAll(cscenter.getBno());
		
		boolean modifyResult = cscenterMapper.update(cscenter) == 1;
		
//		첨부 파일이 존재하면 반복문을 사용하여 첨부 파일 테이블에 추가
		if(modifyResult && cscenter.getAttachList() != null && cscenter.getAttachList().size() > 0) {
			cscenter.getAttachList().forEach(attach -> {
				
				attach.setBno(cscenter.getBno());
				attachMapper.insert(attach);
				
			});
		}
		return cscenterMapper.update(cscenter) == 1;
	}

	// 게시물 삭제
	@Transactional
	@Override
	public boolean remove(Long bno) {
		
		attachMapper.deleteAll(bno);
		
		return cscenterMapper.delete(bno) == 1;
	}
	// 게시물에 달린 댓글 삭제 삭제
	@Transactional
	@Override
	public boolean removeReply(Long bno) {
		
		return cscenterMapper.deleteReply(bno) == 1;
	}
	// 내가 쓴 게시물 확인
	@Override
	public List<CScenterVO> getMyList(Criteria cri) {
		log.info("criteria와 My 목록 가져오기: " + cri);
		return cscenterMapper.getListWithPaging(cri);
	}
}
