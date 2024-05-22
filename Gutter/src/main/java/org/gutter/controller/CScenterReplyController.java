package org.gutter.controller;

import org.gutter.domain.Criteria;
import org.gutter.domain.ReplyPageDTO;
import org.gutter.domain.ReplyVO;
import org.gutter.service.CScenterReplyService;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import lombok.AllArgsConstructor;
import lombok.extern.log4j.Log4j;

@RequestMapping("/menu/")
//해당 클래스가 REST 방식으로 처리됨
@RestController
@Log4j
//모든 필드를 매개변수로 하는 생성자를 자동으로 생성
@AllArgsConstructor
public class CScenterReplyController {
//	자동 주입
	private CScenterReplyService service;
	
//	신규 댓글 등록
	@PreAuthorize("hasRole('ROLE_ADMIN')")
	@PostMapping(value = "/cscenterGet/new",
//			모든 클라이언트의 요청 중에서 데이터가 json 형태로 들어오는 URL만 서버가 처리
			consumes = "application/json",
//			서버가 클라이언트에 응답 처리 시 텍스트 형태로 응답
			produces = {MediaType.TEXT_PLAIN_VALUE })
//		서버가 클라이언트에게 응답 처리 시 데이터 + Http 상태 코드 값을 함께 전송
//		@RequestBody: json 형태의 데이터를 자바 클래스 형태로 매핑
		public ResponseEntity<String> create(@RequestBody ReplyVO vo) {
		log.info("ReplyVO: " + vo);
		int insertCount = service.register(vo);
		log.info("Reply INSERT COUNT: " + insertCount);
		
		return insertCount == 1
				? new ResponseEntity<>("success", HttpStatus.OK)
				: new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
	}
	
	@GetMapping(value="/cscenterGet/reply/{bno}/{page}",
			produces = {
//					클라이언트 응답 데이터 형식 선언(XML, JSON)
					MediaType.APPLICATION_XML_VALUE,
					MediaType.APPLICATION_JSON_UTF8_VALUE
			})
	public ResponseEntity<ReplyPageDTO> getList(
//			매개변수 값을 URL에서 가져온다
			@PathVariable("page") int page,
			@PathVariable("bno") Long bno) {
		
		log.info("getList...............");
		Criteria cri = new Criteria(page,10);
		log.info(cri);
		
//		정상적으로 실행되면 200번 상태 코드 값, 댓글 리스트 리턴
		return new ResponseEntity<>(service.getListPage(cri, bno), HttpStatus.OK);
	}
//	특정 댓글 상세 보기
	@GetMapping(value = "/cscenterGet/{rno}",
			produces = {
					MediaType.APPLICATION_XML_VALUE,
					MediaType.APPLICATION_JSON_UTF8_VALUE
			})
	public ResponseEntity<ReplyVO> get(@PathVariable("rno") Long rno) {
		log.info("get: " + rno);
		return new ResponseEntity<>(service.get(rno), HttpStatus.OK);
	}
	
//	특정 댓글 삭제 처리
	@PreAuthorize("principal.username == #vo.replyer")
	@DeleteMapping(value="/cscenterGet/{rno}")
	public ResponseEntity<String> remove(@RequestBody ReplyVO vo, @PathVariable("rno") Long rno) {
		log.info("remove: " + rno);
		
		return service.remove(rno) == 1
				? new ResponseEntity<>("success", HttpStatus.OK)
				: new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
	}
	
//	특정 댓글 수정 처리
//	PUT: 전체 수정, PATCH: 일부 수정
	@PreAuthorize("principal.username == #vo.replyer")
	@RequestMapping(value="/cscenterGet/{rno}",
	        //PUT : 전체항목을 수정시 사용
	        //PATCH: 일부를 수정시 사용
	        method= {RequestMethod.PATCH,
	        		 RequestMethod.PUT},
	        //클라이언트의 요청중 JSON형태만 처리
	        consumes="application/json",
	        produces= {MediaType.TEXT_PLAIN_VALUE})
		public ResponseEntity<String> modify(
			@RequestBody ReplyVO vo,
			@PathVariable("rno") Long rno){
		
		//댓글번호를 ReplyVO 클래스의 필드에 대입
		vo.setRno(rno);
		
		return service.modify(vo) == 1 ?
				new ResponseEntity<>("success",HttpStatus.OK) :
				new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);	
	}
}
