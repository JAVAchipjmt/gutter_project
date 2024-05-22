package org.gutter.security;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.web.access.AccessDeniedHandler;

// 접근 권한이 없는 사용자가 URL에 접근시 403 예외발생하는데
//이를 처리하는 AccessDeniedHandler 인터페이스를 가지고
//구현된 CustomAccessDeniedHandler 객체를 선언
public class CustomAccessDeniedHandler 
             implements AccessDeniedHandler {

	@Override
	public void handle(HttpServletRequest request, HttpServletResponse response,
			AccessDeniedException accessDeniedException) throws IOException, ServletException {

		response.sendRedirect("/accessError");
		
	}

}




