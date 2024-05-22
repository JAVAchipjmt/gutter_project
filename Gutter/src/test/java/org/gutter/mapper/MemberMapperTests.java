package org.gutter.mapper;

import org.gutter.domain.MemberVO;
import org.junit.Ignore;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringRunner;

import lombok.extern.log4j.Log4j;

@RunWith(SpringRunner.class)
@ContextConfiguration("file:src/main/webapp/WEB-INF/spring/root-context.xml")
@Log4j
public class MemberMapperTests {

	@Autowired
	private MemberMapper memberMapper;
	
	@Ignore
	public void memberInsert() throws Exception {
		MemberVO member = new MemberVO();
		
		member.setId("test");
		member.setPassword("test1234");
		member.setName("김확인");
		member.setPhone("010-1234-5678");
		member.setEmail("test@naver.com");
		
		memberMapper.memberInsert(member);
		
		log.info(member);
	}
	
	@Test
	public void memberLogin() throws Exception {
		MemberVO member = new MemberVO();
		
		member.setId("test");
		member.setPassword("test1234");
		
		memberMapper.memberLogin(member);
		
		log.info(member);
	}
}
