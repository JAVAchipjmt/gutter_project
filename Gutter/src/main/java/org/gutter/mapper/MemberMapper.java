package org.gutter.mapper;

import java.util.List;

import org.gutter.domain.Criteria;
import org.gutter.domain.MemberVO;

public interface MemberMapper {

	// 멤버 내역 조회
	public List<MemberVO> memberList();
	
	// 아이디 중복 검사
	public int idCheck(String id);
	
	// 신규 멤버 등록
	public void memberInsert(MemberVO member);
	
	// 멤버 로그인
	public MemberVO memberLogin(MemberVO member);
	
	// 멤버 수정
	public void memberUpdate(MemberVO member);
	
	// 멤버 삭제
	public void memberDelete(String id);
	
	// 특정 멤버 상세 내역 조회
	public MemberVO memberDetail(String id);
	
	// 멤버 권한
	public MemberVO read(String userid);
	
	
//	관리자 메뉴
// 멤버 목록 목록 조회 
	public List<MemberVO> getList();
	
//	페이징 처리
	public List<MemberVO> getListWithPaging(Criteria cri);
	
//	전체 행수 처리
	public int getTotalCount(Criteria cri);
}
