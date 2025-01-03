package kr.or.ddit.enter.entservice.impl;

import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.apache.commons.mail.DefaultAuthenticator;
import org.apache.commons.mail.EmailAttachment;
import org.apache.commons.mail.EmailException;
import org.apache.commons.mail.HtmlEmail;
import org.apache.commons.mail.MultiPartEmail;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import kr.or.ddit.enter.entservice.EnterServiceS;
import kr.or.ddit.mapper.EnterMapperS;
import kr.or.ddit.vo.ApplicantVO;
import kr.or.ddit.vo.EnterVO;
import kr.or.ddit.vo.FileDetailVO;
import kr.or.ddit.vo.MemberVO;
import kr.or.ddit.vo.NotificationVO;
import kr.or.ddit.vo.PbancVO;
import kr.or.ddit.vo.VideoRoomVO;
import lombok.extern.slf4j.Slf4j;

@Transactional
@Slf4j
@Service
public class EnterServiceImplS implements EnterServiceS {
	 private final String hostName = "smtp.gmail.com";
	 private final int smtpPort = 587;
	
	@Inject
	EnterMapperS enterMapperS;

	@Override
	public int pbCount(String entId) {
		// TODO Auto-generated method stub
		return this.enterMapperS.pbCount(entId);
	}

	@Override
	public int openCount(String entId) {
		// TODO Auto-generated method stub
		return this.enterMapperS.openCount(entId);
	}

	@Override
	public int closeCount(String entId) {
		// TODO Auto-generated method stub
		return this.enterMapperS.closeCount(entId);
	}

	@Override
	public int ppCount(String entId) {
		// TODO Auto-generated method stub
		return this.enterMapperS.ppCount(entId);
	}

	@Override
	public List<PbancVO> pbancList(String entId) {
		// TODO Auto-generated method stub
		return this.enterMapperS.pbancList(entId);
	}

	@Override
	public List<PbancVO> pbancCalendarList(String entId) {
		// TODO Auto-generated method stub
		return this.enterMapperS.pbancCalendarList(entId);
	}

	@Override
	public List<NotificationVO> alarmList(String entId) {
		// TODO Auto-generated method stub
		return this.enterMapperS.alarmList(entId);
	}

	@Override
	public List<ApplicantVO> intrvwList(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return this.enterMapperS.intrvwList(map);
	}

	@Override
	public List<PbancVO> pbancsList(String entId) {
		// TODO Auto-generated method stub
		return this.enterMapperS.pbancsList(entId);
	}

	@Override
	public List<MemberVO> injaeNewList() {
		// TODO Auto-generated method stub
		return this.enterMapperS.injaeNewList();
	}

	@Override
	public List<MemberVO> injaeOldList() {
		// TODO Auto-generated method stub
		return this.enterMapperS.injaeOldList();
	}

	@Override
	public int getIntrvwTotal(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return this.enterMapperS.getIntrvwTotal(map);
	}

	@Override
	public List<VideoRoomVO> videointrvwPost(String job) {
		// TODO Auto-generated method stub
		return this.enterMapperS.videointrvwPost(job);
	}

	@Override
	public void intrvwFormPost(Map<String, Object> map) {
		// TODO Auto-generated method stub
		this.enterMapperS.intrvwFormPost(map);
	}

	@Override
	public void intrvwFormPost2(Map<String, Object> map) {
		// TODO Auto-generated method stub
		this.enterMapperS.intrvwFormPost2(map);
	}

	@Override
	public List<VideoRoomVO> videoRoomList(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return this.enterMapperS.videoRoomList(map);
	}

	@Override
	public int getvideoIntrvwTotal(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return this.enterMapperS.getvideoIntrvwTotal(map);
	}

	@Override
	public int updateIntrvw(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return this.enterMapperS.updateIntrvw(map);
	}

	@Override
	public List<ApplicantVO> AplctListExcel(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return this.enterMapperS.AplctListExcel(map);
	}

	@Override
	public int updateIntrvwPrcsStat(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return this.enterMapperS.updateIntrvwPrcsStat(map);
	}

	@Override
	public List<MemberVO> memberList(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return this.enterMapperS.memberList(map);
	}

	@Override
	public int sendMemAddEmail(Map<String, Object> map)throws EmailException {
		    String subject="기업회원 초대 메일입니다.";
		    
	    	EnterVO entVO = this.enterMapperS.getEntInfo(map);
	    	log.info("mbrId"+map.get("mbrId"));
			log.info("mbrNm"+map.get("mbrNm"));
			log.info("mbrEml"+map.get("mbrEml"));
			log.info("mbrTelno"+map.get("mbrTelno"));
			log.info("entId"+map.get("entId"));
	    	log.info("entVO : "+entVO);
	    	
	    	map.put("entNm",entVO.getEntNm());
	    	
	    	//메일 보낼 글 작성 변수
	    	String htmlmsg="<html lang=\"ko\">\r\n" + 
		    		"<head>\r\n" + 
		    		"    <meta charset=\"UTF-8\">\r\n" +  
		    		"</head>\r\n" + 
		    		"<body>\r\n" +  
		    		"<div class=\"email-container\">\r\n" + 
		    		"    <h2><span style=\"color: #5b92e5;\">"+map.get("mbrId")+"</span>님, "+entVO.getEntNm()+"</h2>\r\n" + 
		    		"    <h3>인사 담당 멤버로 초대되었습니다.</h3>\r\n" + 
		    		"    <p>인사 담당 멤버로 채용 서비스에 함께 참여해주세요!<br>\r\n" + 
		    		"        초대를 통한 가입 후 채용 서비스를 이용하실 수 있습니다.</p>\r\n" + 
		    		"\r\n" + 
		    		"    <div class=\"arrow-indicator\">\r\n" + 
		    		"        <a href='http://localhost/enterMem/acceptPage?entNm="+entVO.getEntNm()+"&mbrId="+map.get("mbrId")+"' class=\"invite-button\">수락하러가기</a>\r\n" + 
		    		"    </div>\r\n" + 
		    		"\r\n" + 
		    		"    <p class=\"note\">해당 메일은 발송 후 72시간 내 가입을 요청드립니다.</p>\r\n" + 
		    		"</div>\r\n" + 
		    		"\r\n" + 
		    		"</body>\r\n" + 
		    		"</html>";
	    	
	    	
	    	//회원 아이디가 있는지 체크
	    	int result = this.enterMapperS.mbrIdChk(map);
	    	log.info("result : "+result);
	    	if(result<1) {
	    		return 0;
	    	}
	    	//검사후 초기화
	    	result = 0;
	    	//회원 기업에 같은 값이 있는지 체크
	    	result += this.enterMapperS.entMemChk(map);
	    	log.info("result : "+result);
	    	if(result>0) {
	    		log.info("들어왔다.");
	    		return 0;
	    	}
	    	String username = entVO.getEntMail(); // 발신자 이메일
	    	String password = entVO.getEntMailApppswd(); // 구글 앱 비밀번호
	    	
	    	log.info("username : "+username);
	    	log.info("password : "+password);
	    	
	    	// 이메일 객체 생성
	    	HtmlEmail email = new HtmlEmail();
	    	email.setCharset("euc-kr");
	        email.setHostName(hostName);
	        email.setSmtpPort(smtpPort);
	        email.setAuthenticator(new DefaultAuthenticator(username, password));
	        email.setStartTLSRequired(true);
	        email.setFrom(username); // 발신자 이메일

	        email.setSubject(subject); // 메일 제목"
	        email.setHtmlMsg(htmlmsg);
	        email.addTo((String) map.get("mbrEml")); // 수신자 이메일
	        email.send(); // 메일 전송
	        result += this.enterMapperS.setEntMember(map);
	        return result;
	}
	@Override
	public int resendMemAddEmail(Map<String, Object> map)throws EmailException {
		String subject="기업회원 초대 메일입니다.";
		
		EnterVO entVO = this.enterMapperS.getEntInfo(map);
		log.info("mbrId"+map.get("mbrId"));
		log.info("mbrNm"+map.get("mbrNm"));
		log.info("mbrEml"+map.get("mbrEml"));
		log.info("mbrTelno"+map.get("mbrTelno"));
		log.info("entId"+map.get("entId"));
		log.info("entVO : "+entVO);
		
		map.put("entNm",entVO.getEntNm());
		
		//메일 보낼 글 작성 변수
		String htmlmsg="<html lang=\"ko\">\r\n" + 
				"<head>\r\n" + 
				"    <meta charset=\"UTF-8\">\r\n" +  
				"</head>\r\n" + 
				"<body>\r\n" +  
				"<div class=\"email-container\">\r\n" + 
				"    <h2><span style=\"color: #5b92e5;\">"+map.get("mbrId")+"</span>님, "+entVO.getEntNm()+"</h2>\r\n" + 
				"    <h3>인사 담당 멤버로 초대되었습니다.</h3>\r\n" + 
				"    <p>인사 담당 멤버로 채용 서비스에 함께 참여해주세요!<br>\r\n" + 
				"        초대를 통한 가입 후 채용 서비스를 이용하실 수 있습니다.</p>\r\n" + 
				"\r\n" + 
				"    <div class=\"arrow-indicator\">\r\n" + 
				"        <a href='http:/localhost/enter/main' class=\"invite-button\">수락하러가기</a>\r\n" + 
				"    </div>\r\n" + 
				"\r\n" + 
				"    <p class=\"note\">해당 메일은 발송 후 72시간 내 가입을 요청드립니다.</p>\r\n" + 
				"</div>\r\n" + 
				"\r\n" + 
				"</body>\r\n" + 
				"</html>";
		
		
		//회원 아이디가 있는지 체크
		int result = this.enterMapperS.mbrIdChk(map);
		log.info("result : "+result);
		if(result<1) {
			return 0;
		}
		String username = entVO.getEntMail(); // 발신자 이메일
		String password = entVO.getEntMailApppswd(); // 구글 앱 비밀번호
		
		log.info("username : "+username);
		log.info("password : "+password);
		
		// 이메일 객체 생성
		HtmlEmail email = new HtmlEmail();
		email.setCharset("euc-kr");
		email.setHostName(hostName);
		email.setSmtpPort(smtpPort);
		email.setAuthenticator(new DefaultAuthenticator(username, password));
		email.setStartTLSRequired(true);
		email.setFrom(username); // 발신자 이메일
		
		email.setSubject(subject); // 메일 제목"
		email.setHtmlMsg(htmlmsg);
		email.addTo((String) map.get("mbrEml")); // 수신자 이메일
		email.send(); // 메일 전송
		result++;
		return result;
	}

	@Override
	public int entaddmemDel(Map<String, Object> map) {
		int result = this.enterMapperS.entaddmemDel(map);
		result+= this.enterMapperS.entmemDel(map);
		return result;
	}

	@Override
	public int memberListTotal(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return this.enterMapperS.memberListTotal(map);
	}

	@Override
	public int updateappstatus(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return this.enterMapperS.updateappstatus(map);
	}

	@Override
	public int updateDateIntrvw(String intrvwNo) {
		// TODO Auto-generated method stub
		return this.enterMapperS.updateDateIntrvw(intrvwNo);
	}


	
}
