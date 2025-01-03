package kr.or.ddit.oustou.controller;


import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Map;
import java.util.function.Function;
import java.util.stream.Collectors;

import javax.inject.Inject;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.authentication.AnonymousAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.or.ddit.mapper.OutsouMapper;
import kr.or.ddit.mapper.UserMapper;
import kr.or.ddit.oustou.service.OutsouService;
import kr.or.ddit.service_DO.NotificationService;
import kr.or.ddit.vo.CodeGrpVO;
import kr.or.ddit.vo.CodeVO;
import kr.or.ddit.vo.NotificationVO;
import kr.or.ddit.vo.OutsouVO;
import lombok.extern.slf4j.Slf4j;


@Slf4j
@Controller
@RequestMapping("/outsou")
public class OutsouController {

	@Inject
	OutsouService outsouService;
	
	//공통코드를 가져오기 위함 
	@Autowired
	UserMapper userMapper;
	@Autowired
	OutsouMapper outsouMapper;
	
	@Inject
	NotificationService notificationService;
	
	//공통 코드를 가져오기 위함 
	public Map<String, CodeGrpVO> codeGrpSelect(List<String> list) {
		List<CodeGrpVO> resultList = userMapper.codeGrpSelect(list);
		return resultList.stream().collect(Collectors.toMap(CodeGrpVO::getComCodeGrp, Function.identity()));
	}
	
	
	
	/**
	 * 1차 카테고리에 따른 2차 카테고리 선택
	 * 요청URI : /outsou/category2
	 * 요청파라미터 : JSON {comCode:OUML}
	 * 요청방식 : POST
	 *
	 * @ResponseBody : 반환 데이터를 JSON 형식으로 변환하는 애너테이션
	 */
	@ResponseBody
	@PostMapping("/category2")
	public List<CodeVO> category2(@RequestBody Map<String, String> data, Model model) {
	    String comCode = data.get("comCode");  // 1차 카테고리에서 선택한 comCode 값
	    log.info("category2 -> comCode : " + comCode);
	    //2차 카테고리 카테고리 
	  	List<CodeVO> OUMLcodeVOList = this.outsouMapper.cacodeSelect(comCode);
	    log.info("category2 -> OUMLcodeVOList : " + OUMLcodeVOList);
	    
	    model.addAttribute("OUMLcodeVOList",OUMLcodeVOList);//자기소개서 카테고리
	    
	    return OUMLcodeVOList;  // JSON 형식으로 2차 카테고리 데이터를 클라이언트에 반환
	}
	

	/** 외주 게시판 기본 정보 등록폼
	 * 요청URI: /outsou/regist
	 * 요청파라미터 : 
	 * 요청방식 :get
	 */
	@PreAuthorize("hasAnyRole('ROLE_MEMBER')")
	@GetMapping("/regist")
	public String regit1(Model model) {
		 
		//공통 코드 보내기
		List<String> list = new ArrayList<String>(); 
		list.add("OULC");//1차카테고리
		list.add("RCCA");//직업분야
		list.add("SRKN");//기업 종류
		list.add("SRAR");//지원 종류
		list.add("SRLE");//기술수준
		list.add("SRTE");//팀규모
		list.add("SRLA");//개발언어 공통코드 
		list.add("SRDB");//데이터베이스 공통코드
		list.add("SRCL");//클라우드
		list.add("SRJP");//작업기간
		list.add("SRUM");//수정횟수
		Map<String, CodeGrpVO> codeGrpVOMap = codeGrpSelect(list);
		 
		 model.addAttribute("codeGrpVOMap",codeGrpVOMap); //공통코드
		
		//웹소켓 알림설정 
	    // 로그인한 사용자 ID 가져오기
	    Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
	    String loggedInUser = "anonymousUser";  // 기본 값 설정
	    // 게시판 제한 경고 및 비로그인 사용자 접근 가능
	    if (authentication != null && authentication.isAuthenticated() && !(authentication instanceof AnonymousAuthenticationToken)) {
	        loggedInUser = authentication.getName();
	        model.addAttribute("loggedInUser", loggedInUser);
	        // 알림 목록 조회
	        List<NotificationVO> alramList = notificationService.alramList(loggedInUser);
	
	        // 알림 데이터 모델에 추가
	        model.addAttribute("alramList", alramList);	        
	    };    
		 
		return "outsou/regist/data/regist";
	}
	
	
	/**외주 게시판 등록실행 
	요청URI :/outsou/registPostAjax
	요청 파라미터 : 
	요청방식 : post
	*/
	@PreAuthorize("hasAnyRole('ROLE_MEMBER')")
	@ResponseBody
	@PostMapping("/registPostAjax")
	public String registPostAjax(@ModelAttribute OutsouVO outsouVO) {
		/*
		 [1.IT프로그래밍]->OUTSOU, OS_DEVAL, OS_KEYWOED
		 OutsouVO(outordNo=null, outordLclsf=OULC01, outordMlsfc=OULC01-002, outordTtl=1, ..., 
		 	osDevalVO=OsDevalVO(srvcNo=null, outordNo=null, srvcLevelCd=SRLE01, srvcTeamscaleCd=SRTE01, srvcLangCd=SRLA16, srvcDatabaseCd=SRDB16, srvcCludCd=SRCL14, srvcEtc=b, ..), 
		 	osClVO=OsClVO(srvcNo=null, ..), 
		 	osKeywordVO=OsKeywordVO(kwrdNo=null, outordNo=null, kwrdNm=a))
		 
		 
		 [2.자기소개서]->OUTSOU, OS_CL 이 두 개의 테이블에 insert
		 OutsouVO(outordNo=null, outordLclsf=OULC02, outordMlsfc=OULC02-001, outordTtl=1, ...,
		  	osDevalVO=OsDevalVO(srvcNo=null, outordNo=null, srvcLevelCd=null, srvcTeamscaleCd=null, srvcLangCd=null, srvcDatabaseCd=null, srvcCludCd=null, srvcEtc=, srvcJobpd=null, srvcUpdtnmtm=null, srvcFileprovdyn=null, srvcSklladit=null), 
		  	osClVO=OsClVO(srvcNo=null, outordNo=null, srvcFld=SRFL02, srvcKnd=SRKN03, srvcArctype=SRAR02), 
		  	osKeywordVO=OsKeywordVO(kwrdNo=null, outordNo=null, kwrdNm=))
		 */
		log.info("registPostAjax -> outsouVO : " + outsouVO);
		
		//각 VO에 담겨 있는지 확인
		log.info("OsDevalVO: " + outsouVO.getOsDevalVO());
		log.info("OsdeLangVOList: " + outsouVO.getOsDevalVO().getOsdeLangVOList());
		log.info("OsdeDatabaseVOList: " + outsouVO.getOsDevalVO().getOsdeDatabaseVOList());
		log.info("OsdeCludVOList: " + outsouVO.getOsDevalVO().getOsdeCludVOList());
		log.info("OsKeywordVOList: " + outsouVO.getOsKeywordVOList());
		log.info("OsClVO: " + outsouVO.getOsClVO());
		
		int result = this.outsouService.registPostAjax(outsouVO);
		log.info("registPostAjax -> result : " + result);
		
		log.info("outsouVO.getOutordNo() -> " +outsouVO.getOutordNo() );
		
		return outsouVO.getOutordNo();
	}
	
	
	
	/**
	 * 외주 게시판 상세
	 * 요청 URI : /outsou/detail
	 * 요청파라미터 : {outordNo=1}
	 * @return
	 */
	@GetMapping("/detail")
	public String detail(@RequestParam("outordNo") String outordNo, Model model) {
		
		log.info("detail->outordNo : " + outordNo);
		 
		 //외주 상세 (외주, 서비스타입, 키워드)
		OutsouVO outsouVO = this.outsouService.detail(outordNo);
		 /*
		 1 :
		 OutsouVO(outordNo=5, outordLclsf=IT·프로그래밍, outordMlsfc=홈페이지 신규 제작, outordTtl=테스트
		 , outordExpln=<p>겁나게 잘해져</p>, outordAmt=550000, outordAmtExpln=홈페이지를개발하는데 최적화되ㅇ있습니다.
		 , outordMainFile=null, outordDetailFile=null, outordDmndmatter=<ol><li>연락먼저</li><li>1. 연라먼저</li><li>2.시넝</li><li>3. 도메인준비</li></ol>, outordProvdprocss=<p>겁나게 잘해져</p>, outordRefndregltn=<p>겁나게 잘해져</p>
		 , outordWrtde=Wed Sep 25 20:46:06 KST 2024, outordUpdde=null, outordDelde=null, outordRdcnt=0, mbrId=yyy123
		 		1 : 
		 		, osDevalVO=OsDevalVO(srvcNo=5, outordNo=5, srvcLevelCd=초급:소스분석 / 수정, srvcTeamscaleCd=1인, srvcLangCd=ActionScript
		 		, srvcDatabaseCd=CouchDB, srvcCludCd=Amazon Athena, srvcEtc=null, srvcJobpd=2일, srvcUpdtnmtm=1회, srvcFileprovdyn=1, srvcSklladit=2), 
		 		
		 		1 : 
		 		osClVO=OsClVO(srvcNo=5, outordNo=5, srvcFld=null, srvcKnd=null, srvcArctype=null)
		 		
		 		, osKeywordVO=null, mainFile=null, detailFile=null
		 		
		 		N
		 		, fileDetailVOList=[
		 		FileDetailVO(fileGroupSn=null, gubun=MAIN, fileSn=0, orgnlFileNm=null, strgFileNm=null, filePathNm=/upload/outsou/mainFile/2024/09/25/da95d79e-09a4-4b21-8098-264c36b59c5d_이미지 등록.png, fileSz=0, fileExtnNm=null, fileMime=null, fileFancysize=null, fileStrgYmd=null, fileDwnldCnt=0), FileDetailVO(fileGroupSn=null, gubun=DETAIL, fileSn=0, orgnlFileNm=null, strgFileNm=null, filePathNm=/upload/outsou/detailFile/2024/09/25/24f913b1-a57e-482e-89e0-3f8a7ace9324_404.jpg, fileSz=0, fileExtnNm=null, fileMime=null, fileFancysize=null, fileStrgYmd=null, fileDwnldCnt=0), FileDetailVO(fileGroupSn=null, gubun=DETAIL, fileSn=0, orgnlFileNm=null, strgFileNm=null, filePathNm=/upload/outsou/detailFile/2024/09/25/657dae26-e9c4-443a-a89d-f4632fde1627_500.jpg, fileSz=0, fileExtnNm=null, fileMime=null, fileFancysize=null, fileStrgYmd=null, fileDwnldCnt=0), FileDetailVO(fileGroupSn=null, gubun=DETAIL, fileSn=0, orgnlFileNm=null, strgFileNm=null, filePathNm=/upload/outsou/detailFile/2024/09/25/f95035ca-3e9d-40f3-bbca-e85aa9c9c6eb_ReadyUp-로고.png, fileSz=0, fileExtnNm=null, fileMime=null, fileFancysize=null, fileStrgYmd=null, fileDwnldCnt=0), FileDetailVO(fileGroupSn=null, gubun=DETAIL, fileSn=0, orgnlFileNm=null, strgFileNm=null, filePathNm=/upload/outsou/detailFile/2024/09/25/30cf28a1-f1e5-4a04-a1b4-8e289901fd71_scj.jpg, fileSz=0, fileExtnNm=null, fileMime=null, fileFancysize=null, fileStrgYmd=null, fileDwnldCnt=0), FileDetailVO(fileGroupSn=null, gubun=DETAIL, fileSn=0, orgnlFileNm=null, strgFileNm=null, filePathNm=/upload/outsou/detailFile/2024/09/25/83fd8508-5ca1-41c8-9f59-4dc68dae2bb3_sjh.jpg, fileSz=0, fileExtnNm=null, fileMime=null, fileFancysize=null, fileStrgYmd=null, fileDwnldCnt=0), FileDetailVO(fileGroupSn=null, gubun=DETAIL, fileSn=0, orgnlFileNm=null, strgFileNm=null, filePathNm=/upload/outsou/detailFile/2024/09/25/e1f99653-0268-42ea-9fe5-7c1d98f34764_외주 상세페이지 이미지.jpg, fileSz=0, fileExtnNm=null, fileMime=null, fileFancysize=null, fileStrgYmd=null, fileDwnldCnt=0)], fileGroupNo=null)
		  */
		 log.info("detail->outsouVO : " + outsouVO);
		 
		 
		 OutsouVO  outsouVO2 = this.outsouService.getOutsouMem(outordNo);
		 
		 model.addAttribute("outsouVO",outsouVO);
		 model.addAttribute("outsouVO2",outsouVO2);
			//웹소켓 알림설정 
		    // 로그인한 사용자 ID 가져오기
		    Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
		    String loggedInUser = "anonymousUser";  // 기본 값 설정
		    // 게시판 제한 경고 및 비로그인 사용자 접근 가능
		    if (authentication != null && authentication.isAuthenticated() && !(authentication instanceof AnonymousAuthenticationToken)) {
		        loggedInUser = authentication.getName();
		        model.addAttribute("loggedInUser", loggedInUser);
		        // 알림 목록 조회
		        List<NotificationVO> alramList = notificationService.alramList(loggedInUser);
		
		        // 알림 데이터 모델에 추가
		        model.addAttribute("alramList", alramList);	        
		    };    
		    
		return "outsou/detail";
	}
	
	

	/**
	 * 외주 결제 상세 
	 * 요청 URI : /readyUP/outsou/paydetail
	 * 요청파라미터 : {outordNo=1}
	 * @return
	 */
	@GetMapping("/paydetail")
	public String paydetail(@RequestParam("outordNo") String outordNo, Model model) {
			log.info("paydetail->outordNo : " + outordNo);
		 
		 //외주 상세 (외주, 서비스타입, 키워드) 저장 내용 가져옴 
		OutsouVO outsouVO = this.outsouService.paydetail(outordNo);
		 log.info("paydetail->outsouVO : " + outsouVO);
		 
		 OutsouVO  outsouVO2 = this.outsouService.getOutsouMem(outordNo);
		 model.addAttribute("outsouVO",outsouVO);
		 model.addAttribute("outsouVO2",outsouVO2);
		
			//웹소켓 알림설정 
		    // 로그인한 사용자 ID 가져오기
		    Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
		    String loggedInUser = "anonymousUser";  // 기본 값 설정
		    // 게시판 제한 경고 및 비로그인 사용자 접근 가능
		    if (authentication != null && authentication.isAuthenticated() && !(authentication instanceof AnonymousAuthenticationToken)) {
		        loggedInUser = authentication.getName();
		        model.addAttribute("loggedInUser", loggedInUser);
		        // 알림 목록 조회
		        List<NotificationVO> alramList = notificationService.alramList(loggedInUser);
		
		        // 알림 데이터 모델에 추가
		        model.addAttribute("alramList", alramList);	        
		    };    
		
		return "outsou/regist/pay/paydetail";
		
	}
	
	//결제 완료 
	@GetMapping("/payok2")
	public String payok2() {
		 
		return "outsou/regist/pay/payok2";
	}
	
	
	/** 외주 삭제 
	* 요청URI : /outsou/deletePost
	* 요청파라미터 : {outordNo=}	
	* 요청방식 : post
	*/
	// 외주 삭제 요청 처리
	@PreAuthorize("hasAnyRole('ROLE_MEMBER')")
	@ResponseBody
	@PostMapping("/deletePost")
	public int deletePost(@RequestParam("outordNo") String outordNo) {
	    log.info("deletePost -> outordNo : " + outordNo);
	    
	    int result = this.outsouService.deletePost(outordNo);
	    log.info("deletePost -> result : " + result);
	    
	    return result; // Return result as an integer (1 for success, 0 for failure)
	}
	/**
	 * 외주 수정 폼
	 */
	@PreAuthorize("hasAnyRole('ROLE_MEMBER')")
	@GetMapping("/updatePost")
	public String updatePost(@RequestParam("outordNo") String outordNo, Model model) {
		
		log.info("detail->outordNo : " + outordNo);
		 
		List<String> list = new ArrayList<String>(); 
		list.add("OULC");//1차카테고리
		list.add("RCCA");//직업분야
		list.add("SRKN");//기업 종류
		list.add("SRAR");//지원 종류
		list.add("SRLE");//기술수준
		list.add("SRTE");//팀규모
		list.add("SRLA");//개발언어 공통코드 
		list.add("SRDB");//데이터베이스 공통코드
		list.add("SRCL");//클라우드
		list.add("SRJP");//작업기간
		list.add("SRUM");//수정횟수
		Map<String, CodeGrpVO> codeGrpVOMap = codeGrpSelect(list);
		
		
		 //외주 상세 (외주, 서비스타입, 키워드)
		OutsouVO outsouVO = this.outsouService.detail(outordNo);
		log.info("updatePost->outsouVO : " + outsouVO);
		 
		 model.addAttribute("outsouVO",outsouVO);
		 model.addAttribute("codeGrpVOMap",codeGrpVOMap); //공통코드
		
			//웹소켓 알림설정 
		    // 로그인한 사용자 ID 가져오기
		    Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
		    String loggedInUser = "anonymousUser";  // 기본 값 설정
		    // 게시판 제한 경고 및 비로그인 사용자 접근 가능
		    if (authentication != null && authentication.isAuthenticated() && !(authentication instanceof AnonymousAuthenticationToken)) {
		        loggedInUser = authentication.getName();
		        model.addAttribute("loggedInUser", loggedInUser);
		        // 알림 목록 조회
		        List<NotificationVO> alramList = notificationService.alramList(loggedInUser);
		
		        // 알림 데이터 모델에 추가
		        model.addAttribute("alramList", alramList);	
		        if (!loggedInUser.equals(outsouVO.getMbrId())) {
		            // 작성자가 아닌경우 List로 보내기
		            return "redirect:/outsou/main";
		        }
		    }else {
		        // 비로그인 사용자 로그인창으로
		        return "redirect:/security/login";
		    }    
		 
		return "outsou/regist/data/edit";
	}
	
	/**
	 * 외주 수정 실행(동기방식)
	 */
	@PreAuthorize("hasAnyRole('ROLE_MEMBER')")
	@PostMapping("/updatePost")
	public String updatePost(@ModelAttribute OutsouVO outsouVO) {
		/*
		[IT프로그래밍]
		outsouVO : OutsouVO(outordNo=10, outordTtl=홈페이지제작, 반응형홈페이지제작, 디자인부터 제작까지
		, outordLclsf=OULC01, outordLclsfNm=null, 
			outordMlsfc=OULC01-001, outordMlsfcNm=null, outordAmt=550000, outordAmtExpln=설문조사 사이트 구축
온라인이나 모바일로 설문조사를 할 수 있는 사이트를 구축하여 드립니다.약 40문항까
지가 기본입니다., 
outordExpln=, outordProvdprocss=, outordRefndregltn=, outordMainFile=null, outordDetailFile=null, 
outordDmndmatter=, outordWrtde=null, outordUpdde=null, outordDelde=null, outordRdcnt=0, 
mbrId=test1, 
	osDevalVO=OsDevalVO(srvcNo=null, outordNo=null, srvcLevelCd=SRLE01, srvcLevelNm=null, 
	srvcTeamscaleCd=SRTE01, srvcTeamscaleNm=null, srvcJobpd=SRJP01, srvcJobpdNm=null, 
	srvcUpdtnmtm=SRUM01, srvcUpdtnmtmNm=null, srvcFileprovdyn=null, srvcSklladit=0, 
	osdeLangVOList=null, osdeDatabaseVOList=null, osdeCludVOList=null, 
		srvcLangCd=[SRLA01, SRLA02], 
		srvcDatabaseCd=[SRDB01, SRDB03],
		srvcCludCd=[SRCL01, SRCL05]), 
	osClVO=OsClVO(srvcNo=null, outordNo=null, srvcFld=RCCA01, srvcFldNm=null, srvcKnd=SRKN05, 
	srvcKndNm=null, srvcArctype=SRAR01, srvcArctypeNm=null), 
	osKeywordVOList=null, kwrdNm=[], 
	mainFile=[org.springframework.web.multipart.support.StandardMultipartHttpServletRequest$StandardMultipartFile@95b898], 
	detailFile=[org.springframework.web.multipart.support.StandardMultipartHttpServletRequest$StandardMultipartFile@3007a166], 
	fileDetailVOList=null, fileGroupNo=null)
		 */
		log.info("updatePostAjax -> outsouVO : " + outsouVO);
		
		//각 VO에 담겨 있는지 확인
		log.info("OsDevalVO: " + outsouVO.getOsDevalVO());
		log.info("SrvcLangCd[]: " + outsouVO.getOsDevalVO().getSrvcLangCd());
		log.info("SrvcDatabaseCd[]: " + outsouVO.getOsDevalVO().getSrvcDatabaseCd());
		log.info("SrvcCludCd[]: " + outsouVO.getOsDevalVO().getSrvcCludCd());
		log.info("kwrdNm[]: " + outsouVO.getKwrdNm());
		log.info("OsClVO: " + outsouVO.getOsClVO());
		
		int result = this.outsouService.updatePost(outsouVO);
		log.info("updatePostAjax -> result : " + result);
		
		log.info("outsouVO.getOutordNo() -> " +outsouVO.getOutordNo() );
		
		return "redirect:/outsou/detail?outordNo="+outsouVO.getOutordNo();
	}


}
