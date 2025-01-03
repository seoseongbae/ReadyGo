package kr.or.ddit.controller;

import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import kr.or.ddit.service.EnterListService;
import kr.or.ddit.service.PbancService;
import kr.or.ddit.util.ArticlePage;
import kr.or.ddit.vo.CodeVO;
import kr.or.ddit.vo.EnterVO;
import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
@RequestMapping("/common")
public class EnterListController {
	
	@Autowired
	EnterListService enterListService;
	
	@Autowired
	PbancService pbancService;
	
	@RequestMapping(value="/enterList",method=RequestMethod.GET)
	public ModelAndView list(ModelAndView mav,
			@RequestParam(value="currentPage",required=false,defaultValue="1") int currentPage,
			@RequestParam(value="selCity", required=false) String[] selCity, 
		    @RequestParam(value="selJob", required=false) String[] selJob, 
		    @RequestParam(value="selKeyword", required=false,defaultValue="") String keyword 
			) {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("currentPage", currentPage);
		log.info("list->map : " + map);
		
		// 선택된 도시와 직업 로그 출력
	    if (selCity != null) {
	        log.info("Selected Cities: " + Arrays.toString(selCity)); // 선택된 도시 출력
	    } else {
	        selCity = new String[] {}; // 모든 도시를 사용하기 위해 빈 배열로 설정
	    }
	    
	    if (selJob != null) {
	        log.info("Selected Jobs: " + Arrays.toString(selJob)); // 선택된 직업 출력
	    } else {
	        selJob = new String[] {}; // 모든 직업을 사용하기 위해 빈 배열로 설정
	    }
	    log.info("Keyword: " + keyword); // 선택된 키워드 출력
	    
	    // 선택된 도시와 직업을 map에 추가
	    map.put("selCity", Arrays.asList(selCity)); // List로 변환하여 추가
	    map.put("selJob", Arrays.asList(selJob)); // List로 변환하여 추가
	    map.put("keyword", keyword); // 키워드 추가
		
		List<EnterVO> enterVOList = this.enterListService.list(map);
		List<CodeVO> regionList = this.pbancService.regionList();
		List<CodeVO> jobList = this.pbancService.jobList();
		log.info("enterVOList : " + enterVOList);
		log.info("regionList : " + regionList);
		log.info("jobList : " + jobList);


		int total = this.enterListService.getTotal(map);
		log.info("list->total : " + total);
		
		ArticlePage<EnterVO> articlePage = 
			new ArticlePage<EnterVO>(total, currentPage, 10, enterVOList);
		log.info("articlePage : " + articlePage);
		
		mav.addObject("articlePage", articlePage);
		mav.addObject("regionList", regionList);
		mav.addObject("jobList", jobList);
		mav.addObject("total", total);
		
		// /WEB-INF/view/common/enterList.jsp
		mav.setViewName("common/enterList");
		
		return mav;
	}
	
	
}