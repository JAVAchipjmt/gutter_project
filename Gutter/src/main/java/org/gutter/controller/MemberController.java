package org.gutter.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.gutter.domain.MemberVO;
import org.gutter.service.MemberService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import lombok.extern.log4j.Log4j;

@RequestMapping("/member/*")
@Controller
@Log4j
public class MemberController {

	@Autowired
	private MemberService memberService;
	
	@Autowired
	private BCryptPasswordEncoder pwEncoder;
	
//	아이디 중복 검사
	@RequestMapping(value="/idCheck", method=RequestMethod.POST, produces={"application/json"}) 
	@ResponseBody
	public int idCheck(String id) {
		log.info("아이디 중복 검사 시작");
		int cnt = memberService.idCheck(id);
		log.info(cnt);
		return cnt;
	}
	
//	회원 가입 페이지 접속
	@PreAuthorize("isAnonymous()")
	@RequestMapping(value="/joinus", method = RequestMethod.GET)
	public void joinusGET() {
		log.info("joinus 페이지 접속");
	}
	
//	회원 가입
	@RequestMapping(value="/joinus", method = RequestMethod.POST)
	public String joinusPOST(MemberVO member) throws Exception {
		log.info("회원가입 진행");
		String rawPw = "";
		String encodePw = "";
		
		rawPw = member.getPassword();
		encodePw = pwEncoder.encode(rawPw);
		member.setPassword(encodePw);
		
		memberService.memberInsert(member);
		log.info("회원가입 성공");
		return "redirect:/member/login";
	}
	
//	로그인 페이지 접속
	@RequestMapping(value="/login", method = RequestMethod.GET)
	public void loginGET() {
		log.info("login 페이지 접속");
	}
	
//	로그인
	@RequestMapping(value="/loginProcess", method = RequestMethod.POST)
	public String loginPOST(HttpServletRequest request, MemberVO member, RedirectAttributes rttr) throws Exception {
		HttpSession session = request.getSession();
		String rawPw = "";
		String encodePw = "";
		
		MemberVO lvo = memberService.memberLogin(member);
		
		if (lvo != null) { // 일치하는 아이디 존재 시
			rawPw = member.getPassword(); // 사용자가 입력한 비밀번호
			encodePw = lvo.getPassword(); // 데이터베이스에 저장한 인코딩 비밀번호
			
			if(true == pwEncoder.matches(rawPw, encodePw)) { // 비밀번호 일치 여부 판단
				lvo.setPassword(""); // 인코딩된 비밀번호 정보 지움
				session.setAttribute("member", lvo); // session에 사용자 정보 저장
				return "redirect:/";
			} else {
				rttr.addFlashAttribute("result",0);
				return "redirect:/member/login";
			}
		} else {
			rttr.addFlashAttribute("result",0);
			return "redirect:/member/login";
		}
	}
	
// 로그아웃
	@RequestMapping(value="/logout", method = RequestMethod.GET)
	public String logoutGet(HttpServletRequest request) throws Exception {
		log.info("로그아웃");
		HttpSession session = request.getSession();
		session.invalidate();
		return "redirect:/";
	}
	
//	회원 수정
	@PreAuthorize("isAuthenticated()")
	@RequestMapping(value="/updateMember", method = RequestMethod.POST)
	public String updateMemberPost(MemberVO member) throws Exception {
		String rawPw = "";
		String encodePw = "";
		
		rawPw = member.getPassword();
		encodePw = pwEncoder.encode(rawPw);
		member.setPassword(encodePw);
		
		memberService.memberUpdate(member);
		log.info("회원 수정 완료");
		return "redirect:/";
	}
	
//	회원 탈퇴
	@PreAuthorize("isAuthenticated()")
	@RequestMapping(value="/removeMember", method = RequestMethod.POST)
	public String removeMember(HttpServletRequest request, String id) throws Exception {
		HttpSession session = request.getSession();
		session.invalidate();
		memberService.memberDelete(id);
		log.info("회원 탈퇴 완료");
		return "redirect:/";
	}
}
