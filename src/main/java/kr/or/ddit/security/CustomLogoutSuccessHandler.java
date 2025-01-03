package kr.or.ddit.security;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.web.authentication.logout.LogoutSuccessHandler;

public class CustomLogoutSuccessHandler implements LogoutSuccessHandler {

	@Override
	public void onLogoutSuccess(HttpServletRequest request
			, HttpServletResponse response, Authentication auth)
			throws IOException, ServletException {
		User userDetail = (User) auth.getPrincipal();
		List<String> roleNames = new ArrayList<String>();
		auth.getAuthorities().forEach(authority->{
		roleNames.add(authority.getAuthority());
		});
		String logoutPath = "/";
		if (roleNames.contains("ROLE_ADMIN")) {
		    logoutPath = "/";
		} else if (roleNames.contains("ROLE_ENTER")) {
			logoutPath = "/enter/main";
		} else if (roleNames.contains("ROLE_MEMENTER")) {
			logoutPath = "/enter/main";
		} else if (roleNames.contains("ROLE_MEMBER")) {
			logoutPath = "/";
		}
		//auth : 로그인 정보
		if(auth != null && auth.getDetails()!=null) {
			try {
				request.getSession().invalidate();
			}catch(Exception e) {
				e.printStackTrace();
			}
		}
		
		response.setStatus(HttpServletResponse.SC_OK);
		
		response.sendRedirect(logoutPath);

	}

}
