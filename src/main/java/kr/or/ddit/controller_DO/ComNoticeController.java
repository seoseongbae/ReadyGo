package kr.or.ddit.controller_DO;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.AnonymousAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import kr.or.ddit.security.SocketHandler;
import kr.or.ddit.service_DO.NoticeService;
import kr.or.ddit.service_DO.NotificationService;
import kr.or.ddit.util.ArticlePage;
import kr.or.ddit.vo.BoardVO;
import kr.or.ddit.vo.FileDetailVO;
import kr.or.ddit.vo.MemberVO;
import kr.or.ddit.vo.NotificationVO;
import lombok.extern.slf4j.Slf4j;


@RequestMapping("/common/notice")
@Controller
@Slf4j
public class ComNoticeController {

	@Inject
	NoticeService noticeService;
	
	@Inject
	NotificationService notificationService;
	
    
	@RequestMapping(value="/noticeList",method=RequestMethod.GET)
	public ModelAndView list(ModelAndView mav,
			@RequestParam(value="currentPage",required=false,defaultValue="1") int currentPage) {
        
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("currentPage", currentPage);
		log.info("list->map : " + map);
		
		
		List<BoardVO> boardVOList = this.noticeService.admList(map);
        
		int total = this.noticeService.getTotal();
		
        // JSP로 전달하기 위해 Model 객체에 boardVOList 저장
        mav.addObject("boardVOList", boardVOList);
		
		//페이지네이션 객체
		ArticlePage<BoardVO> articlePage = 
			new ArticlePage<BoardVO>(total, currentPage, 10, boardVOList, map);
		log.info("articlePage : " + articlePage);
		
		mav.addObject("articlePage", articlePage);
		
		mav.setViewName("common/notice/noticeList");
		
	    // 로그인한 사용자 ID 가져오기
	    Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
	    String loggedInUser = "anonymousUser";  // 기본 값 설정

	    if (authentication != null && authentication.isAuthenticated() && !(authentication instanceof AnonymousAuthenticationToken)) {
	        loggedInUser = authentication.getName();
	        mav.addObject("loggedInUser", loggedInUser);
	       //알림 목록 조회
			List<NotificationVO> alramList = notificationService.alramList(loggedInUser);

			//알림 데이터 모델에 추가
			mav.addObject("alramList", alramList);
	    }
		return mav;
	}	
	
	@GetMapping("/noticeDetail")
	public String detail(@RequestParam("pstSn") String pstSn, Model model) {
	    log.info("detail=> getpstSn : "+pstSn);
	    
	    // 조회수 증가 호출
	    this.noticeService.InqCnt(pstSn);

	    // 상세정보 가져오기
	    BoardVO boardVO = this.noticeService.admDetail(pstSn);
	    model.addAttribute("boardVO", boardVO);

		// 파일 상세 정보 가져오기
		List<FileDetailVO> fileDetails = this.noticeService.getFileDetailsByPstSn(pstSn);
		model.addAttribute("fileDetails", fileDetails); // 파일 상세 정보 추가
		
	    // 로그인한 사용자 ID 가져오기
	    Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
	    String loggedInUser = "anonymousUser";  // 기본 값 설정

	    if (authentication != null && authentication.isAuthenticated() && !(authentication instanceof AnonymousAuthenticationToken)) {
	        loggedInUser = authentication.getName();
	        model.addAttribute("loggedInUser", loggedInUser);
	       //알림 목록 조회
			List<NotificationVO> alramList = notificationService.alramList(loggedInUser);

			//알림 데이터 모델에 추가
			model.addAttribute("alramList", alramList);
	    }
	    return "common/notice/noticeDetail";  
	}
}
