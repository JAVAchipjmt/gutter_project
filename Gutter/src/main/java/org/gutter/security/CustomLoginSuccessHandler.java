package org.gutter.security;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.security.core.Authentication;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;

//AuthenticationSuccessHandler?
//로그인 성공시 처리를 담당하는 인터페이스		
public class CustomLoginSuccessHandler 
			implements AuthenticationSuccessHandler {

	@Override
	public void onAuthenticationSuccess(
			//클라이언트 요청에 대한 정보를 가지고 있는 인터페이스
			HttpServletRequest request,
			//서버의 응답처리 정보를 가지고 있는 인터페이스
			HttpServletResponse response,
			//인증에 성공한 사용자의 정보를 가지고 있는 인터페이스
			Authentication auth) throws IOException, ServletException {
		
		//사용자에 대한 권한명을 가지는 배열을 선언
		List<String> roleNames = new ArrayList<>();

		//사용자에 대한 권한을 반복문을 통해 배열에 대입
		auth.getAuthorities().forEach(authority -> {
			
			roleNames.add(authority.getAuthority());
		});
		
		if(roleNames.contains("ROLE_ADMIN")) {
			
			response.sendRedirect("/");
			return;
		}
		
		response.sendRedirect("/");
		
	}

}



