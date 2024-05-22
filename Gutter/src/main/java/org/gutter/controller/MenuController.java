package org.gutter.controller;

import org.gutter.domain.Criteria;
import org.gutter.domain.PageDTO;
import org.gutter.service.CScenterService;
import org.gutter.service.MemberService;
import org.gutter.service.PhotoService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import lombok.extern.log4j.Log4j;

@Controller
@Log4j
public class MenuController {
	
	@Autowired
	private MemberService memberService;
	
	@Autowired
	private PhotoService photoService;
	
	@Autowired
	private CScenterService cscenterService;
	
	@GetMapping("/menu/about")
	public void about() {
		log.info("개요 화면 실행 중......");
	}
	
//	MYPAGE, 회원 수정 접속
	@PreAuthorize("isAuthenticated()")
	@GetMapping({"/member/mypage", "/member/updateMember"})
	public void mypageGET(@RequestParam("id") String id, Model model) throws Exception {
		model.addAttribute("member", memberService.memberDetail(id));
		log.info("MYPAGE 페이지 접속");
	}
	
// 내가 쓴 게시물 접속
	@PreAuthorize("isAuthenticated()")
	@GetMapping({"/member/checkPost"})
	public void checkPostGET(@RequestParam("id") String id, Model model) throws Exception {
		log.info("내가 쓴 게시물 접속");
	}
	
//	내가 쓴 Photo 접속
	@PreAuthorize("isAuthenticated()")
	@GetMapping({"/member/myPhoto"})
	public void checkPhotoGET(Criteria cri, Model model, @RequestParam("id") String id) throws Exception {
		model.addAttribute("list", photoService.getMyList(cri));
		int total = photoService.getTotal(cri);
		model.addAttribute("pageMaker", new PageDTO(cri, total));
		log.info("My Photo 리스트 페이지 접속");
	}
	
//	내가 쓴 CScenter 접속
	@PreAuthorize("isAuthenticated()")
	@GetMapping({"/member/myCS"})
	public void checkCSGET(Criteria cri, Model model, @RequestParam("id") String id) throws Exception {
		model.addAttribute("list", cscenterService.getMyList(cri));
		int total = cscenterService.getTotal(cri);
		model.addAttribute("pageMaker", new PageDTO(cri, total));
		log.info("My CS 리스트 페이지 접속");
	}
}