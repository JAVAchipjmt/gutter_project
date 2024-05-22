package org.gutter.mapper;

import org.gutter.domain.CScenterVO;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringRunner;

import lombok.extern.log4j.Log4j;

@RunWith(SpringRunner.class)
@ContextConfiguration("file:src/main/webapp/WEB-INF/spring/root-context.xml")
@Log4j
public class CScenterMapperTests {

	@Autowired
	private CScenterMapper cscenterMapper;
	
	@Test
	public void cscenterInsert() throws Exception {
		CScenterVO cscenter = new CScenterVO();
		
		cscenter.setTitle("CScenter 테스트 제목2");
		cscenter.setContent("CScenter 테스트 내용2");
		cscenter.setWriter("test");
		
		cscenterMapper.insert(cscenter);
		
		log.info(cscenter);
	}
}
