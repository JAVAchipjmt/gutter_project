package org.gutter.service;

import java.util.List;

import org.gutter.domain.Criteria;
import org.gutter.domain.MemberVO;
import org.gutter.mapper.MemberMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import lombok.AllArgsConstructor;
import lombok.extern.log4j.Log4j;

@Service
@Log4j
@AllArgsConstructor
public class MemberServiceImpl implements MemberService {

	@Autowired
	MemberMapper memberMapper;
	
//	아이디 중복 검사
	@Override
	public int idCheck(String id) {
		log.info("서비스 아이디:" + id);
		int cnt = memberMapper.idCheck(id);
		System.out.println("cnt: " + cnt);
		return cnt;
	}
	
//	회원 가입
	@Override
	public void memberInsert(MemberVO member) throws Exception {
				memberMapper.memberInsert(member);
	}
	
//	로그인
	@Override
	public MemberVO memberLogin(MemberVO member) throws Exception {
		return memberMapper.memberLogin(member);
	}
	
//	멤버 상세 정보 조회
	@Override
	public MemberVO memberDetail(String id) throws Exception {
		return memberMapper.memberDetail(id);
	}
	
// 회원 수정
	@Override
	public void memberUpdate(MemberVO member) throws Exception {
				memberMapper.memberUpdate(member);
		
	}
// 회원 삭제
	@Override
	public void memberDelete(String id) throws Exception {
				memberMapper.memberDelete(id);
	}

//	관리자 메뉴 멤버 목록 조회
	@Override
	public List<MemberVO> getList(Criteria cri) {
		log.info("criteria와 목록 가져오기: " + cri);
		return memberMapper.getListWithPaging(cri);
	}

	@Override
	public int getTotal(Criteria cri) {
		return memberMapper.getTotalCount(cri);
	}
	
	
}
