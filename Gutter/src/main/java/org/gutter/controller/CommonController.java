package org.gutter.controller;

import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import lombok.extern.log4j.Log4j;

@Controller
@Log4j
public class CommonController {

	@GetMapping("/accessError")
	//Authentication ? 
	//현재 접근하려는 사용자의 정보와 권한을 가지는 인터페이스
	public void accessDenied(Authentication auth,
							 Model model) {
		
		log.info("접근 불가:" + auth);
		
		model.addAttribute("msg","Access Denied!");
	}
	

}