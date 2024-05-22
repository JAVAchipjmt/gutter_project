package org.gutter.service;

import java.util.List;

import org.gutter.domain.Criteria;
import org.gutter.domain.ReplyPageDTO;
import org.gutter.domain.ReplyVO;
import org.gutter.mapper.CScenterMapper;
import org.gutter.mapper.ReplyMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import lombok.extern.log4j.Log4j;
//구현 객체
@Service
@Log4j
public class CScenterReplyServiceImpl implements CScenterReplyService {
	@Autowired
	private ReplyMapper mapper;

	@Autowired
	private CScenterMapper cscenterMapper;
//	신규 댓글 처리를 ReplyMapper 인터페이스에 위임
//	댓글 등록 & 댓글 건수 1 증가, 모두 성공하면 commit, 하나라도 실패하면 rollback
	@Transactional
	@Override
	public int register(ReplyVO vo) {
		log.info("register......" + vo);
		cscenterMapper.updateReplyCnt(vo.getBno(), 1);
		return mapper.insert(vo);
	}
// 특정 댓글 상세 보기를 ReplyMapper 인터페이스에 위임
	@Override
	public ReplyVO get(Long rno) {
		log.info("get......" + rno);
		return mapper.read(rno);
	}
//	특정 댓글 수정을 ReplyMapper 인터페이스에 위임
	@Override
	public int modify(ReplyVO vo) {
		log.info("modify......" + vo);
		return mapper.update(vo);
	}
//	특정 댓글 삭제를 ReplyMapper 인터페이스에 위임
//	댓글 삭제 & 댓글 건수 1차감, 모두 성공하면 commit, 하나라도 실패하면 rollback
	@Transactional
	@Override
	public int remove(Long rno) {
		log.info("remove......" + rno);
//		댓글 삭제 시 게시물 번호를 알기 위해 실행
		ReplyVO vo = mapper.read(rno);
		cscenterMapper.updateReplyCnt(vo.getBno(), -1);
		return mapper.delete(rno);
	}
// 댓글 목록 처리를 ReplyMapper 인터페이스에 위임
	@Override
	public List<ReplyVO> getList(Criteria cri, Long bno) {
		log.info("get Reply List of a Board " + bno);
		return mapper.getListWithPaging(cri, bno);
	}
	@Override
	public ReplyPageDTO getListPage(Criteria cri, Long bno) {
		return new ReplyPageDTO(
				mapper.getCountByBno(bno),
				mapper.getListWithPaging(cri, bno)
				);
	}
}
