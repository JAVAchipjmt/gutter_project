package org.gutter.service;

import java.util.List;

import org.gutter.domain.Criteria;
import org.gutter.domain.MemberVO;

public interface MemberService {

	// 아이디 중복 검사
	public int idCheck(String id);
	
	// 회원 가입
	public void memberInsert(MemberVO member) throws Exception;
	
	// 로그인
	public MemberVO memberLogin(MemberVO member) throws Exception;
	
	// 멤버 상세 조회
	public MemberVO memberDetail(String id) throws Exception;
	
	// 회원 수정
	public void memberUpdate(MemberVO member) throws Exception;
	
	// 회원 탈퇴
	public void memberDelete(String id) throws Exception;
	
	// 관리자 메뉴 멤버 목록 조회 처리
	public List<MemberVO> getList(Criteria cri);
	public int getTotal(Criteria cri);
}
