package kr.or.ddit.controller_DO;

import java.util.List;

import javax.inject.Inject;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import kr.or.ddit.service_DO.FAQService;
import kr.or.ddit.vo.BoardVO;
import lombok.extern.slf4j.Slf4j;

@RequestMapping("/adm/faqBoard")
@Slf4j
@Controller
public class AdmFaqController {

	@Inject
	FAQService faqService;
	
	@GetMapping("/admFaqList")
	public String admList(Model model) {
		List<BoardVO> boardVOList = this.faqService.admList();
		int total = this.faqService.getTotal();
		
	    // model을 통해 데이터를 JSP로 전달
	    model.addAttribute("boardVOList", boardVOList);
	    model.addAttribute("total", total);
	    log.info("boardVOList"+boardVOList);
	    log.info("boardVOList",boardVOList);
	    
		return "adm/faqBoard/admFaqList";
	}
	
	@GetMapping("/admFaqRegist")
	public String admRegist() {
		return "adm/faqBoard/admFaqRegist";
	}
	
	@PostMapping("/admRegistPost")
	public String admRegistPost(@ModelAttribute BoardVO boardVO) {
	    // 로그인한 사용자 정보 가져오기
	    Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
	    String mbrId = authentication.getName();  // 로그인한 사용자 이름 (id)
	    
	    // boardVO의 작성자(writer) 필드에 로그인한 사용자 설정
	    boardVO.setMbrId(mbrId);
	    
	    log.info("registPost->boardVO : " + boardVO);
	    int result = this.faqService.admRegistPost(boardVO);
	    log.info("registPost->result : " + result);
	    
	    return "redirect:/adm/faqBoard/admFaqList";
	}
	@PostMapping("/deletePost")
	public String deletePost(@RequestParam("pstSn") String pstSn) {
	    log.info("deletePost -> getpstSn : " + pstSn);
	    
	    // 게시글 삭제
	    int result = faqService.deletePost(pstSn); // 서비스에서 게시글 삭제
	    if (result > 0) {
	        log.info("게시글 삭제 성공");
	    } else {
	        log.info("게시글 삭제 실패");
	    }
	    
	    return "redirect:/adm/faqBoard/admFaqList"; // 삭제 후 목록 페이지로 리디렉션
	}	
	
	@GetMapping("/admFaqUpdate")
	public String update(@RequestParam("pstSn") String pstSn, Model model) {
	    log.info("update => get pstSn : " + pstSn);

	    // 게시글 상세 정보 가져오기
	    BoardVO boardVO = this.faqService.getPostDetails(pstSn);
	    model.addAttribute("boardVO", boardVO);

	    return "adm/faqBoard/admFaqUpdate";  // 수정 페이지로 이동
	}

	
	@PostMapping("/updatePost")
	public String updatePost(@ModelAttribute BoardVO boardVO) {
	    log.info("updatePost -> boardVO : " + boardVO);

	    // 수정된 데이터 업데이트
	    int result = this.faqService.updatePost(boardVO);
	    
	    // 수정된 게시글의 세부정보 페이지로 리디렉션
	    return "redirect:/adm/faqBoard/admFaqList";

	}
}
