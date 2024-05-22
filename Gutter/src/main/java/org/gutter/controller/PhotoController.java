package org.gutter.controller;

import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;

import org.gutter.domain.CScenterAttachVO;
import org.gutter.domain.CScenterVO;
import org.gutter.domain.Criteria;
import org.gutter.domain.PageDTO;
import org.gutter.service.PhotoService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import lombok.extern.log4j.Log4j;

@RequestMapping("/squeak/*")
@Controller
@Log4j
public class PhotoController {
	
	@Autowired
	private PhotoService photoService;
	
	// 게시물 리스트 페이지 접속
	@RequestMapping(value="/photoList", method = RequestMethod.GET)
	public void photoListGET(Criteria cri, Model model) {
		log.info("list: " + cri);
		model.addAttribute("list", photoService.getList(cri));
//		전체 행수를 변수에 대입 
		int total = photoService.getTotal(cri);
		model.addAttribute("pageMaker", new PageDTO(cri, total));
		log.info("Photo 리스트 페이지 접속");
	}
	
	// 게시물 상세 조회
	@PreAuthorize("isAuthenticated()")
	@GetMapping({"/photoGet","/photoModify"})
	public void photoGet(@RequestParam("bno") Long bno, @ModelAttribute("cri") Criteria cri,
			    Model model) {
		
		log.info("Photo 상세 내역 조회");
		
		//service.get(bno)? 특정 게시물번호에 대해서 상세보기
		//실행하여 결과값을 board라는 속성에 대입		
		model.addAttribute("photo", photoService.get(bno));
	}
	
	//특정 게시물 수정 처리
	@PreAuthorize("principal.username == #writer")
	@PostMapping("/photoModify")
	public String modify(CScenterVO board, @ModelAttribute("cri") Criteria cri,
			             RedirectAttributes rttr,
			             String writer) {
	
		if(photoService.modify(board)) {
			//게시물 수정후 일회성 속성을 지정
			rttr.addFlashAttribute("result","success");
		}
		//게시물 목록으로 이동
		return "redirect:/squeak/photoList" + cri.getListLink();
	}
	
//	정상적으로 로그인한 사용자 아이디와 매개변수로 전달된 작성자가 동일하면 삭제 처리 허용
	@PreAuthorize("principal.username == #writer")
	@PostMapping("/photoRemove")
	public String remove(
			@RequestParam("bno") Long bno, @ModelAttribute("cri") Criteria cri,
			RedirectAttributes rttr,
			String writer) {
			
			photoService.removeReply(bno);
			
//			특정 게시물 번호에 대한 첨부 파일 내역을 변수에 대입
			List<CScenterAttachVO> attachList = photoService.getAttachList(bno);
			
		//특정 게시물 삭제처리
		if(photoService.remove(bno)) {
			//게시물 수정후 일회성 속성을 지정
			deleteFiles(attachList);
			
			rttr.addFlashAttribute("result", "success");
		}
		//게시물 목록으로 이동
		return  "redirect:/squeak/photoList" + cri.getListLink();
	}
	
	//	게시물 첨부 파일 목록 가져오기
	@GetMapping(value = "/photoGet/getAttachList", produces = MediaType.APPLICATION_JSON_UTF8_VALUE)
	@ResponseBody
	public ResponseEntity<List<CScenterAttachVO>> getAttachList(Long bno) {
		log.info("첨부 파일 목록을 가져올 게시물 번호" + bno);
		return new ResponseEntity<>(photoService.getAttachList(bno), HttpStatus.OK);
	}
	
	//	특정 게시물에 대한 첨부 파일 전부 삭제 처리
	private void deleteFiles(List<CScenterAttachVO> attachList) {
		
		if(attachList == null || attachList.size() == 0) {
			return;
		}
		
//		삭제하려는 첨부 파일 내역이 있으면 처리
		attachList.forEach(attach -> {
			try {
//				삭제하려는 파일을 검색
				Path file = Paths.get("/Users/hykim/Documents/SpringStudy/Gutter/src/main/webapp/resources/images"+attach.getUploadPath()+"\\"+attach.getUuid()+"_"+attach.getFileName());
//				존재하면 삭제 처리
				Files.deleteIfExists(file);
				
//				이미지 파일일 경우에는 썸네일도 삭제해 줘야 함
//				probeContentType? MIME(image/jpg,text/html)
				if(Files.probeContentType(file).startsWith("image")) {
//					썸네일 파일 찾기
					Path thumbNail = Paths.get("/Users/hykim/Documents/SpringStudy/Gutter/src/main/webapp/resources/images"+attach.getUploadPath()+"\\s_"+attach.getUuid()+"_"+attach.getFileName());
					
					Files.delete(thumbNail);
				}
			} catch(Exception e) {
				log.error("delete file error" + e.getMessage());
			}
		});
	}
		// 게시물 작성 페이지 접속
		@GetMapping("/photoRegister")
		//	정상적으로 로그인한 사용자만 게시물 등록 가능
		@PreAuthorize("isAuthenticated()")
		public void photorRegisterGET() {
				log.info("Photo 작성 페이지 접속");
			}
			
//		게시물 작성
		@PreAuthorize("isAuthenticated()")
		@RequestMapping(value="/photoRegister", method = RequestMethod.POST)
		public String photoRegisterPOST(CScenterVO cscenter, RedirectAttributes rttr) throws Exception {
			log.info("게시물 작성 진행");
			if(cscenter.getAttachList() != null) {
				cscenter.getAttachList().forEach(attach -> log.info(attach));
			}
			photoService.insert(cscenter); 
			rttr.addFlashAttribute("result",cscenter.getBno());
			log.info("게시물 작성 성공");
			return "redirect:/squeak/photoList";
		}

}
