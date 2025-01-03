package kr.or.ddit.controller_DO;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import kr.or.ddit.mapper.UserMapper;
import kr.or.ddit.security.SocketHandler;
import kr.or.ddit.service.MemberService;
import kr.or.ddit.service_DO.InquiryBoardService;
import kr.or.ddit.service_DO.NotificationService;
import kr.or.ddit.util.ArticlePage;
import kr.or.ddit.vo.BoardVO;
import kr.or.ddit.vo.CodeVO;
import kr.or.ddit.vo.CommentVO;
import kr.or.ddit.vo.MemberVO;
import kr.or.ddit.vo.NotificationVO;
import kr.or.ddit.vo.PbancVO;
import lombok.extern.slf4j.Slf4j;

@RequestMapping("/adm/inquiryBoard")
@Slf4j
@Controller
public class AdmInquiryBoardController {

	@Inject
	InquiryBoardService inquiryBoardService;
	
	@Autowired
	UserMapper userMapper;
	
	@Inject
	NotificationService notificationService;
	
    @Autowired
    private SocketHandler socketHandler;
	
	@GetMapping("/cssTest")
	public String cssTest() {
		return null;
	}
	
	@GetMapping("/admInquiryRegist")
	public String regist(Model model) {
	    List<CodeVO> codeVOList = userMapper.codeSelect("NOCA");
	    log.info("codeVOList", codeVOList);
	    
	    model.addAttribute("codeVOList", codeVOList);	
	    
		return "adm/inquiryBoard/admInquiryRegist";
	}
	
	@RequestMapping(value="/admInquiryList",method=RequestMethod.GET)
	public ModelAndView list(ModelAndView mav,
			@RequestParam(value="currentPage",required=false,defaultValue="1") int currentPage) {
        
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("currentPage", currentPage);
		log.info("list->map : " + map);
		
		
		List<BoardVO> boardVOList = this.inquiryBoardService.list(map);
        
		int total = this.inquiryBoardService.getTotal();
		
        // JSP로 전달하기 위해 Model 객체에 boardVOList 저장
        mav.addObject("boardVOList", boardVOList);
		
		//페이지네이션 객체
		ArticlePage<BoardVO> articlePage = 
			new ArticlePage<BoardVO>(total, currentPage, 10, boardVOList, map);
		log.info("articlePage : " + articlePage);
		
		mav.addObject("articlePage", articlePage);
		
		mav.setViewName("adm/inquiryBoard/admInquiryList");
		
		return mav;
	}	
	
	
	@PostMapping("/registPost")
	public String registPost(@ModelAttribute BoardVO boardVO) {
	    // 로그인한 사용자 정보 가져오기
	    Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
	    String mbrId = authentication.getName();  // 로그인한 사용자 이름 (id)
	    
	    // boardVO의 작성자(writer) 필드에 로그인한 사용자 설정
	    boardVO.setMbrId(mbrId);
	    
	    log.info("registPost->boardVO : " + boardVO);
	    int result = this.inquiryBoardService.registPost(boardVO);
	    log.info("registPost->result : " + result);
	    
	    return "redirect:/adm/inquiryBoard/admInquiryDetail?seNo=4"+ "&pstSn=" + boardVO.getPstSn();
	}
	
	@GetMapping("/admInquiryDetail")
	public String detail(@RequestParam("pstSn") String pstSn, Model model) {
	    log.info("detail=> getpstSn : "+pstSn);
	    
	    // 상세정보 가져오기
	    BoardVO boardVO = this.inquiryBoardService.detail(pstSn);
	    model.addAttribute("boardVO", boardVO);
	    
	    // 댓글 목록 가져오기
	    List<CommentVO> commentsList = this.inquiryBoardService.getComments(pstSn);
	    model.addAttribute("commentsList", commentsList);

        // 로그인한 사용자 ID 가져오기
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        String mbrId = authentication.getName();
        model.addAttribute("loggedInUser", mbrId);
	    
	    return "adm/inquiryBoard/admInquiryDetail";    
	}

	@GetMapping("/admInquiryUpdate")
	public String update(@RequestParam("pstSn") String pstSn, Model model) {
	    log.info("update => get pstSn : " + pstSn);
	    List<CodeVO> codeVOList = userMapper.codeSelect("NOCA");
	    log.info("codeVOList", codeVOList);
	    
	    
	    // 게시글 상세 정보 가져오기
	    BoardVO boardVO = this.inquiryBoardService.getPostDetails(pstSn);
	    model.addAttribute("boardVO", boardVO);
	    model.addAttribute("codeVOList", codeVOList);	

	    return "adm/inquiryBoard/admInquiryUpdate";  // 수정 페이지로 이동
	}

	@PostMapping("/updatePost")
	public String updatePost(@ModelAttribute BoardVO boardVO) {
	    log.info("updatePost -> boardVO : " + boardVO);

	    // 수정된 데이터 업데이트
	    int result = this.inquiryBoardService.updatePost(boardVO);
	    
	    // 수정된 게시글의 세부정보 페이지로 리디렉션
	    return "redirect:/adm/inquiryBoard/admInquiryDetail?seNo=4&pstSn=" + boardVO.getPstSn();

	}
	
	@PostMapping("/deletePost")
	public String deletePost(@RequestParam("pstSn") String pstSn) {
	    log.info("deletePost -> getpstSn : " + pstSn);
	    
	    // 게시글 삭제
	    int result = inquiryBoardService.deletePost(pstSn);
	    if (result > 0) {
	        log.info("게시글 삭제 성공");
	    } else {
	        log.info("게시글 삭제 실패");
	    }
	    
	    return "redirect:/adm/inquiryBoard/admInquiryList"; // 삭제 후 목록 페이지로 리디렉션
	}
	@PostMapping("/registReplyPost")
	public String registReplyPost(@RequestParam("commentContent") String commentContent, @RequestParam("pstSn") String pstSn) {
	    // 로그인한 사용자 정보 가져오기
	    Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
	    String mbrId = authentication.getName();  // 로그인한 사용자 이름 (id)

	    // 댓글 등록 VO 객체 생성
	    CommentVO commentVO = new CommentVO();
	    commentVO.setCmntCn(commentContent);
	    commentVO.setPstSn(pstSn);
	    commentVO.setMbrId(mbrId);
	    commentVO.setCmntDelYn("1");

	    // 댓글 등록
	    int result = this.inquiryBoardService.registComment(commentVO);
	    log.info("registReplyPost->result : " + result);

	    if (result > 0) {
	        String boardWriter = inquiryBoardService.getBoardWriter(pstSn); // 게시글 작성자 ID
	        log.info("게시글 작성자 ID: " + boardWriter);

	        // WebSocket 메시지 포맷
	        String websocketMessage = String.format("★관리자가 작성하신 문의글에 답글을 달았습니다."); // 제목은 적절하게 가져와서 사용
	        // 현재 URL
            String currentUrl = "/common/inquiryBoard/inquiryDetail?pstSn=" + pstSn;
	        // WebSocket 세션 체크 후 메시지 전송
	        log.info("boardWriter: " + boardWriter);
	        log.info("현재 등록된 세션 목록: " + socketHandler.getUserSessionsMap().keySet());
	        if(!boardWriter.equals(mbrId)) {
		        if (socketHandler.getUserSessionsMap().containsKey(boardWriter)) {
		            socketHandler.sendMessageToUser(boardWriter, websocketMessage);
		        } else {
		            log.warn("WebSocket 세션을 찾을 수 없음, 사용자: " + boardWriter);
		            log.info("현재 등록된 세션 목록: " + socketHandler.getUserSessionsMap().keySet());
		        }
	        //알림 저장
	        NotificationVO notificationVO = new NotificationVO();
	        notificationVO.setCommonId(boardWriter); // 게시글 작성자 ID
	        notificationVO.setNtcnCn(websocketMessage); // 알림 메시지 내용
	        notificationVO.setNtcnUrl(currentUrl); // 알림과 연결된 URL
	        this.notificationService.sendAlram(notificationVO);  // 알림 저장	 
	        }
	    }
	    // 댓글 등록 후 상세로 이동
	        return "redirect:/adm/inquiryBoard/admInquiryDetail?pstSn=" + pstSn;
	}
    @PostMapping("/updateComment")
    @ResponseBody
    public String updateComment(@RequestBody CommentVO commentVO) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        String mbrId = authentication.getName();

        // 댓글 수정 처리
        commentVO.setMbrId(mbrId);
        int result = this.inquiryBoardService.updateComment(commentVO);
        return result > 0 ? "success" : "fail";
    }

    @PostMapping("/deleteComment")
    @ResponseBody
    public String deleteComment(@RequestParam("cmntNo") String cmntNo, @RequestParam("pstSn") String pstSn) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        String mbrId = authentication.getName();

        // 댓글 삭제 처리
        int result = this.inquiryBoardService.deleteComment(cmntNo, pstSn, mbrId);
        return result > 0 ? "success" : "fail";
    }
}

