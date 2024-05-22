package org.gutter.domain;

import java.util.Date;
import java.util.List;

import lombok.Data;

@Data
public class MemberVO {

	private String id; // 멤버 아이디
	private String password; // 멤버 비밀번호
	private String name; // 멤버 이름
	private String phone; // 멤버 연락처
	private String email; // 멤버 이메일
	private Date regDate; // 멤버 가입 일자
	private Date updateDate; // 멤버 수정 일자
	private String grade; // 멤버 등급
	private List<AuthVO> authList;//사용자의 권한들
}
