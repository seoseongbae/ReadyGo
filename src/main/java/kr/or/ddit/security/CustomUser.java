package kr.or.ddit.security;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.User;

import kr.or.ddit.vo.AdminVO;
import kr.or.ddit.vo.EnterVO;
import kr.or.ddit.vo.MemberVO;
import kr.or.ddit.vo.UserAuthVO;

//User : 스프링 시큐리티가 제공하고 있는 사용자 정보 클래스
public class CustomUser extends User {
	//이 memVO 객체는 JSP에서 사용할 수 있음
	private MemberVO memVO;
	private EnterVO entVO;
	private AdminVO admVO;
	
	public CustomUser(String username, String password, 
			Collection<? extends GrantedAuthority> authorities, String userType) {
		super(username, password, authorities);
	}
	//생성자
	//memVO : select한 사용자 및 권한 정보가 들어있음
	//MemVO 타입의 객체 memVO를 스프링 시큐리티에서 제공해주고 있는 UsersDetails 타입으로 변환
	//스프링 시큐리티야, 회원정보를 보내줄테니 이제부터 니가 좀 관리해줘 
	public CustomUser(MemberVO memberVO) {
		//1) username / 2) password / 3) authorities
		//memVO.getMemAuthVOList() : 
		//	2	ROLE_ADMIN
		//	2	ROLE_MEMBER
		//memVO.getMemAuthVOList().stream() :
		//  2	ROLE_ADMIN	2	ROLE_MEMBER
		/*
		 memVO.getMemAuthVOList().stream()
			.map(auth->new SimpleGrantedAuthority(auth.getAuth()))
			.collect(Collectors.toList())
		 */
		super(memberVO.getMbrId(), memberVO.getMbrPswd(), 
				getMemCollect(memberVO));
		this.memVO = memberVO;
	}
	public CustomUser(EnterVO enterVO) {
		super(enterVO.getEntId(), enterVO.getEntPswd(), 
				getEntCollect(enterVO));
		this.entVO = enterVO;
	}
	public CustomUser(AdminVO adminVO) {
		super(adminVO.getAdmId(), adminVO.getAdmPswd(), 
				getAdminCollect(adminVO));
		this.admVO = adminVO;
	}

	public static List<SimpleGrantedAuthority> getMemCollect(MemberVO memberVO){
		List<SimpleGrantedAuthority> authorities 
			= new ArrayList<SimpleGrantedAuthority>();
		
		/*
		 2	ROLE_ADMIN
		 2	ROLE_MEMBER
		 */
		List<UserAuthVO> userAuthVOList = memberVO.getUserAuthVOList();	
		//memAuthVO : 2	ROLE_ADMIN
		for(UserAuthVO userAuthVO : userAuthVOList) {			
			//memAuthVO.getAuth() : ROLE_ADMIN
			SimpleGrantedAuthority authority = 
					new SimpleGrantedAuthority(userAuthVO.getAuth());
			authorities.add(authority);
		}
		
		return authorities;
	}
	public static List<SimpleGrantedAuthority> getEntCollect(EnterVO enterVO){
		List<SimpleGrantedAuthority> authorities 
		= new ArrayList<SimpleGrantedAuthority>();
		
		List<UserAuthVO> userAuthVOList = enterVO.getUserAuthVOList();		
		for(UserAuthVO userAuthVO : userAuthVOList) {			
			SimpleGrantedAuthority authority = 
					new SimpleGrantedAuthority(userAuthVO.getAuth());
			authorities.add(authority);
		}
		
		return authorities;
	}
	public static List<SimpleGrantedAuthority> getAdminCollect(AdminVO adminVO){
		List<SimpleGrantedAuthority> authorities 
		= new ArrayList<SimpleGrantedAuthority>();
		
		List<UserAuthVO> userAuthVOList = adminVO.getUserAuthVOList();		
		for(UserAuthVO userAuthVO : userAuthVOList) {			
			SimpleGrantedAuthority authority = 
					new SimpleGrantedAuthority(userAuthVO.getAuth());
			authorities.add(authority);
		}
		
		return authorities;
	}
	
	
	public MemberVO getMemVO() {
		return memVO;
	}
	public void setMemVO(MemberVO memVO) {
		this.memVO = memVO;
	}
	public EnterVO getEntVO() {
		return entVO;
	}
	public void setEntVO(EnterVO entVO) {
		this.entVO = entVO;
	}
	public AdminVO getAdmVO() {
		return admVO;
	}
	public void setAdmVO(AdminVO admVO) {
		this.admVO = admVO;
	}



}
