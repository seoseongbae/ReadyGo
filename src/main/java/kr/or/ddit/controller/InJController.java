package kr.or.ddit.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import kr.or.ddit.enter.entservice.EnterService;
import kr.or.ddit.util.ArticlePage;
import kr.or.ddit.util.GetUserUtil;
import kr.or.ddit.vo.CodeVO;
import kr.or.ddit.vo.MemberVO;
import kr.or.ddit.vo.PbancVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/member")
public class InJController {
	
	
	@Inject
	EnterService enterService;
	
	@Inject
	GetUserUtil getUserUtil;
	
	///enter/injae?entId=test01&currentPage=2&keywordInput=Abaqus,Amazon%20EMR,Amazon%20RDS
	/* 인재 */
	@GetMapping("/injae")
	public ModelAndView injae(ModelAndView mav,
			@RequestParam(value = "keywordInput", required = false, defaultValue = "") String keyword,
			@RequestParam(value = "currentPage", required = false, defaultValue = "1") Integer currentPage) {
		String userId = getUserUtil.getLoggedInUserId();
		//keyword : Abaqus,Amazon%20EMR,Amazon%20RDS
		
		String[] keywordInput = null;
		
		if(keyword.length()>0) {//페이지네이션에서 왔을 때
			keywordInput = keyword.split(","); 
		}else {//최초 인재 메뉴를 클랙했을 때(keyword.length가 0이므로)
			keywordInput = null;
		}
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("entId", "");
		map.put("currentPage", currentPage);
		map.put("keyword", keywordInput);
		
		log.info("list->map : " + map);
		
		List<CodeVO> skillList = enterService.getSkillList(map); // 스킬 목록 가져오기
		List<MemberVO> getInjaeList = this.enterService.getInjaeList2(map); //인재리스트
		List<MemberVO> recommendList = enterService.getRecommendList(map); // 추천인재
		List<PbancVO> pbancList = enterService.pbancList(map); // 스카우트 제안 - 해당기업 공고 꺼내기
		
		log.info("skillList : " + skillList);
		log.info("list -> getInjaeList : " + getInjaeList);

		int total = this.enterService.getTotalInjae(map); // 페이지네이션 전체 행의수

		// 페이지네이션 객체
		ArticlePage<MemberVO> articlePage = new ArticlePage<MemberVO>(total, currentPage, 8, getInjaeList, map);
		
		log.info("articlePage : " + articlePage);
		
		mav.addObject("total", total);
		mav.addObject("keyword", keyword);
		mav.addObject("skillList", skillList);// 스킬 목록 가져오기
		mav.addObject("getInjaeList", getInjaeList); //인재리스트
		mav.addObject("articlePage", articlePage);// 페이지네이션 + 인재리스트
		mav.addObject("recommendList", recommendList);// 추천인재
		mav.addObject("pbancList", pbancList); // 스카우트 제안 - 해당기업 공고 꺼내기

		// 뷰 리졸버
		mav.setViewName("common/inJ/inJ");

		return mav;
	}
	
	/* 인재 */
	@PostMapping("/injaePost")
	public ModelAndView injaePost(ModelAndView mav,
			@RequestParam(value = "keywordInput", required = false, defaultValue = "") String[] keywordInput,
			@RequestParam(value = "currentPage", required = false, defaultValue = "1") Integer currentPage) {
		
		//currentPage : 1
		log.info("currentPage : " + currentPage);
		///enter/injae?entId=test01&currentPage=2&keywordInput=[Ljava.lang.String;@3521116
		String keywordInputStr = String.join(",", keywordInput); 
		//Abaqus,Amazon EMR,Amazon RDS
		log.info("injaePost->keywordInputStr : " + keywordInputStr);
		
		for(String keyword : keywordInput) {
			//keyword! : Amazon EC2
			log.info("keyword! : " + keyword);
		}
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("entId", "");
		map.put("currentPage", currentPage);
		if(keywordInputStr !=null || keywordInputStr!="") {
			map.put("keyword", keywordInput);//String[]
		}
		log.info("keyword : " + keywordInput);
		log.info("list->map : " + map);
		
		List<CodeVO> skillList = enterService.getSkillList(map); // 스킬 목록 가져오기
		log.info("injaePost -> skillList : " + skillList);
		List<MemberVO> getInjaeList = this.enterService.getInjaeList2(map); //인재리스트*****
		log.info("injaePost -> getInjaeList : " + getInjaeList);
		List<MemberVO> recommendList = enterService.getRecommendList(map); // 추천인재
		log.info("injaePost -> recommendList : " + recommendList);
		List<PbancVO> pbancList = enterService.pbancList(map); // 스카우트 제안 - 해당기업 공고 꺼내기
		log.info("injaePost -> pbancList : " + recommendList);
		
		
		int total = this.enterService.getTotalInjae(map); // 페이지네이션 전체 행의수
		
		// 페이지네이션 객체
		ArticlePage<MemberVO> articlePage = new ArticlePage<MemberVO>(total, currentPage, 8, getInjaeList, map);
		
		mav.addObject("keyword", keywordInputStr);
		mav.addObject("skillList", skillList);// 스킬 목록 가져오기
		mav.addObject("getInjaeList", getInjaeList); //인재리스트
		mav.addObject("articlePage", articlePage);// 페이지네이션 + 인재리스트
		mav.addObject("recommendList", recommendList);// 추천인재
		mav.addObject("pbancList", pbancList); // 스카우트 제안 - 해당기업 공고 꺼내기
		mav.addObject("total", total); // 인재 - 전체행의수
		
		// 뷰 리졸버
		mav.setViewName("common/inJ/inJ");
		
		return mav;
	}
}
