package org.gutter.controller;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import javax.sql.DataSource;

import org.junit.Ignore;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration({ "file:src/main/webapp/WEB-INF/spring/root-context.xml",
		"file:src/main/webapp/WEB-INF/spring/security-context.xml" })
public class MemberTests {

	// 비밀번호를 단방향으로 암호화 처리
	@Autowired
	private PasswordEncoder pwencoder;

	// 데이터베이스 연결
	@Autowired
	private DataSource ds;

	@Ignore
	public void testInsertMember() throws SQLException {

		String sql = "insert into member(id,password,name,regdate) values (?,?,?,sysdate)";

		// 반복문을 사용하여 100명의 사용자를 등록처리
		for (int i = 90; i <= 100; i++) {

			Connection con = null;
			PreparedStatement pstmt = null;

			try {

				// 데이터베이스 연결
				con = ds.getConnection();
				pstmt = con.prepareStatement(sql);

				// 두번째 ?에 암호화된 비밀번호 대입
				pstmt.setString(2, pwencoder.encode("pw" + i));

//				인덱스가 1  ~ 80   => 일반사용자(80명)
//					   user1 ~ user80 
//					   pw1 ~ pw80	
//					   
//					   81 ~	90   => 운영자(10명)
//					   manager81 ~ manager90 
//					   pw81 ~ pw90
//					   
//					   91 ~ 100  => 관리자(10명)
//					   admin91 ~ admin100
//					   pw91 ~ pw100

				if (i <= 80) {
					pstmt.setString(1, "user" + i);
					pstmt.setString(3, "일반사용자" + i);
				} else if (i <= 90) {
					pstmt.setString(1, "manager" + i);
					pstmt.setString(3, "운영자" + i);
				} else {
					pstmt.setString(1, "admin" + i);
					pstmt.setString(3, "관리자" + i);
				}

				pstmt.executeUpdate();

			} catch (Exception e) {
				e.printStackTrace();
			} finally {
				if (pstmt != null)
					pstmt.close();
				if (con != null)
					con.close();
			}
		}
	}
//	p656 사용자 권한 추가
		@Test
		public void testInsertAuth() throws SQLException {
			
		String sql = "insert into member_auth(id,auth) values (?,?)";

		// 반복문을 사용하여 100명의 사용자를 등록처리
		for (int i = 90; i <= 100; i++) {

			Connection con = null;
			PreparedStatement pstmt = null;

			try {

				// 데이터베이스 연결
				con = ds.getConnection();
				pstmt = con.prepareStatement(sql);

				//user1 ~ user80 =>  ROLE_USER
				//manager81 ~ manager90 => ROLE_MANAGER
				//admin91 ~ admin100 => ROLE_ADMIN
				
				if (i <= 80) {
					pstmt.setString(1, "user" + i);
					pstmt.setString(2, "ROLE_USER");
				} else if (i <= 90) {
					pstmt.setString(1, "manager" + i);
					pstmt.setString(2, "ROLE_MANAGER");
				} else {
					pstmt.setString(1, "admin" + i);
					pstmt.setString(2, "ROLE_ADMIN");
				}

				pstmt.executeUpdate();

			} catch (Exception e) {
				e.printStackTrace();
			} finally {
				if (pstmt != null)
					pstmt.close();
				if (con != null)
					con.close();
			}
		}

	}
}
