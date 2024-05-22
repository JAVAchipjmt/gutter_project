package org.gutter.security;

import org.gutter.domain.CustomUser;
import org.gutter.domain.MemberVO;
import org.gutter.mapper.MemberMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;

import lombok.extern.log4j.Log4j;

// UserDetailsService? 사용자 정보를 가져와서 인증 처리를 담당하는 인터페이스
// CustomUserDetailsService? 구현 객체
@Log4j
public class CustomUserDetailsService implements UserDetailsService {
	
	@Autowired
	private MemberMapper memberMapper;
	
//	사용자 아이디를 매개변수로 받아서 사용자 정보를 UserDetails라는 인터페이스에 전달
	@Override
	public UserDetails loadUserByUsername(String id) throws UsernameNotFoundException {
		
//		매개변수로 전달받은 사용자 아이디에 대한 사용자 정보를 리턴받아 변수에 대입
		MemberVO vo = memberMapper.read(id);
//		사용자 정보가 있으면 CustomUser 생성자 호출
		return vo == null ? null : new CustomUser(vo);
	}
}
