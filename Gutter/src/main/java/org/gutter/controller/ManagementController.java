package org.gutter.controller;

import org.gutter.domain.Criteria;
import org.gutter.domain.PageDTO;
import org.gutter.service.MemberService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import lombok.extern.log4j.Log4j;

@RequestMapping("/management/*")
@Controller
@Log4j
public class ManagementController {
	
	@Autowired
	private MemberService memberService;
	
	@PreAuthorize("hasRole('ROLE_ADMIN')")
	@GetMapping({"/office"})
	public void officeGET() throws Exception {
		log.info("오피스 페이지 접속");
	}
	
	@PreAuthorize("hasRole('ROLE_ADMIN')")
	@RequestMapping(value="/members", method = RequestMethod.GET)
	public void membersGET(Criteria cri, Model model) {
		log.info("멤버 관리 페이지 접속");
		model.addAttribute("list", memberService.getList(cri));
		log.info("list: " + cri);
//		전체 행수를 변수에 대입 
		int total = memberService.getTotal(cri);
		model.addAttribute("pageMaker", new PageDTO(cri, total));
	}
	
	@PreAuthorize("hasRole('ROLE_ADMIN')")
	@PostMapping("/quitMember")
	public String quitMemberPOST(String id) throws Exception {
		memberService.memberDelete(id);
		log.info("회원 강제 탈퇴 완료");
		return "redirect:/management/members";
	}
	
	@PreAuthorize("hasRole('ROLE_ADMIN')")
	@GetMapping("/statistics")
	public void staticsGet() throws Exception {
		
	}
}
