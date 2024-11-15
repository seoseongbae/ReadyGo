package kr.or.ddit.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import javax.inject.Inject;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.or.ddit.enter.entservice.EnterService;
import kr.or.ddit.mapper.UserMapper;
import kr.or.ddit.security.CustomUser;
import kr.or.ddit.service.MemProfileService;
import kr.or.ddit.service.MemberService;
import kr.or.ddit.util.CodeSelect;
import kr.or.ddit.util.GetUserUtil;
import kr.or.ddit.vo.CodeGrpVO;
import kr.or.ddit.vo.CodeVO;
import kr.or.ddit.vo.MemberVO;
import kr.or.ddit.vo.PbancVO;
import kr.or.ddit.vo.PrfAcbgVO;
import kr.or.ddit.vo.PrfActVO;
import kr.or.ddit.vo.PrfBusinessVO;
import kr.or.ddit.vo.PrfCareerVO;
import kr.or.ddit.vo.PrfCrtfctVO;
import kr.or.ddit.vo.PrfSkillVO;
import kr.or.ddit.vo.PrfVO;
import kr.or.ddit.vo.PrfWnpzVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/member")
@PreAuthorize("hasAnyRole('ROLE_MEMBER','ROLE_MEMENTER','ROLE_ENTER')")
public class MemProfileController {

    @Autowired
    MemProfileService memProfileService;
    
    @Autowired
    MemberService memberService;
    
    @Autowired
    UserMapper userMapper;
    
    @Inject
    CodeSelect codeSelect;
    
    @Inject
    GetUserUtil getUserUtil;
    
    @Inject
    EnterService enterService;
    
    
    // 프로필 조회
    @GetMapping("/profile")
    @PreAuthorize("permitAll")
    public String profile(@RequestParam("mbrId") String mbrId, Model model) {
    	// 로그인된 사용자 ID
        String Member = getUserUtil.getLoggedInUserId();
        
        
     // 현재 로그인된 사용자의 권한 정보 가져오기
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        boolean Enter = authentication.getAuthorities().stream()
                            .anyMatch(grantedAuthority -> grantedAuthority.getAuthority().equals("ROLE_ENTER"));
        boolean MemberRole = authentication.getAuthorities().stream()
                .anyMatch(grantedAuthority -> grantedAuthority.getAuthority().equals("ROLE_MEMBER"));
        boolean MemEnterRole = authentication.getAuthorities().stream()
        		.anyMatch(grantedAuthority -> grantedAuthority.getAuthority().equals("ROLE_MEMENTER"));
        
     // mbrId가 없으면 로그인된 사용자의 ID를 사용 (자신의 프로필을 조회)
        if (mbrId == null || mbrId.isEmpty()) {
            mbrId = Member;
        }
        
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("mbrId", mbrId);
 
        // 회원 조회
        MemberVO memberVO = this.memberService.detail(mbrId);
        log.info("profile -> memVO : " + memberVO);
        model.addAttribute("memberVO",memberVO);
        
        // 프로필 조회
        PrfVO prfVO = this.memProfileService.profile(mbrId);
        log.info("profile -> prfVO : " + prfVO);
        
        // 경력 리스트 조회
        List<PrfCareerVO> prfCareerVOList = memProfileService.careerList(mbrId);
        
        // 학력 조회
        List<PrfAcbgVO> prfAcbgVOList = memProfileService.acbgList(mbrId);   
        // 프로필 학력 항목
        List<CodeVO> prseList = memProfileService.prseList();     
        // 학위 항목
        List<CodeVO> acdeList = memProfileService.acdeList();       
        // 전공계열 항목
        List<CodeVO> acspList = memProfileService.acspList();
        
        // 자격증 조회
        List<PrfCrtfctVO> prfCrtfctVOList = memProfileService.crtfctList(mbrId);
        
        // 수상 조회
        List<PrfWnpzVO> prfWnpzVOList = memProfileService.WnpzList(mbrId);
        
        // 활동 조회
        List<PrfActVO> prfActVOList = memProfileService.ActList(mbrId);
        
        // 스킬 조회
        List<PrfSkillVO> skillVOList = memProfileService.skillList(mbrId);
        
        // 업종 조회
        List<PrfBusinessVO> prfBusinessVOList = memProfileService.BusinessList(mbrId);
        
        List<CodeVO> inseVOList = userMapper.codeSelect("INSE");
        // 스킬 공통 코드 불러오기
        List<String> list = new ArrayList<String>();
        list.add("SK");	// 스킬
        Map<String, CodeGrpVO> codeGrpVOMap = codeSelect.codeGrpSelect(list);
        
        // 선택된 업종 코드 리스트 생성
        List<String> selectedCodes = prfBusinessVOList.stream()
            .map(PrfBusinessVO::getTpbizSeCd)
            .collect(Collectors.toList());     
        
        // 입사 제안 여부 공통 코드(스카우트 여부)
        List<CodeVO> rlscVOList = userMapper.codeSelect("RLSC");
        
       
        
        
     // 로그인한 사용자가 자신인지 타인인지 구분하기 위한 플래그 설정
        boolean isOwner = Member.equals(mbrId);
        
        model.addAttribute("prfVO", prfVO);
//        model.addAttribute("prfRlsscopeCd", prfVO.getPrfRlsscopeCd());
        model.addAttribute("prfCareerVOList", prfCareerVOList);
        model.addAttribute("prfAcbgVOList", prfAcbgVOList);
        model.addAttribute("prseList", prseList);
        model.addAttribute("acdeList", acdeList);
        model.addAttribute("acspList", acspList);
        model.addAttribute("prfCrtfctVOList", prfCrtfctVOList);
        model.addAttribute("prfWnpzVOList", prfWnpzVOList);
        model.addAttribute("prfActVOList", prfActVOList);
        model.addAttribute("prfBusinessVOList", prfBusinessVOList);
        model.addAttribute("skillVOList",skillVOList);
        model.addAttribute("inseVOList", inseVOList);
        model.addAttribute("selectedCodes", selectedCodes);
        model.addAttribute("rlscVOList", rlscVOList);
        model.addAttribute("codeGrpVOMap",codeGrpVOMap);
        model.addAttribute("isOwner", isOwner);  // 본인 여부 체크를 위한 플래그
        model.addAttribute("Enter", Enter);  // 본인 여부 체크를 위한 플래그
        model.addAttribute("MemberRole", MemberRole);  // 본인 여부 체크를 위한 플래그
        model.addAttribute("MemEnterRole", MemEnterRole);  // 본인 여부 체크를 위한 플래그
        
        
        
        return "member/profile";  // profile.jsp 페이지로 이동
    }
    
    @ResponseBody
    @PostMapping("/profilePbanc")
    public List<PbancVO> profilePbanc(Model model,
    		@RequestBody Map<String,Object> value){
    	
    	log.info("profilePbanc : entId : " + value.get("entId"));
    	String entId = value.get("entId").toString();
    	
    	 Map<String, Object> map = new HashMap<String, Object>();
    	 map.put("entId",entId);
    	 
    	 
    	 List<PbancVO> pbancList = enterService.pbancList(map); // 스카우트 제안 - 해당기업 공고 꺼내기
    
    	 model.addAttribute("pbancList", pbancList);  //스카우트제안에서 해당 기업 공고를 꺼냄 
    	 
    	 return pbancList;
    }
    
    
    
    // 프로필 수정
    /*
        {
		    "mbrId": "test1",
		    "proflContent": "안녕하세요, 저는 Java 웹 개발자입니다. Spring Framework와 RESTful API에 능숙합니덩2"
		}
     */
    @ResponseBody
    @PostMapping("/prfUpdateAjax")
    public int prfUpdateAjax(@RequestBody Map<String, Object> map, MemberVO memberVO) {
    	//{mbrId=test1, proflContent=안녕하세요, 저는 Java 웹 개발자입니다. Spring Framework와 RESTful API에 능숙합니덩112}
    	log.info("pdfUpdataAjax->map : " + map);
    	
    	
    	int result = this.memProfileService.prfUpdateAjax(map);
    	getUserUtil.getMemVO().setMbrPswd(memberVO.getMbrPswd());
    	return result;
    }
    
    // 프로필 이미지 수정
    @PostMapping("/profile/editPrfImg")
    public String editPrfImg(@ModelAttribute MemberVO memberVO) {
    	// 로그인된 mbrId로 설정
        memberVO.setMbrId(getUserUtil.getLoggedInUserId());
        log.info("editPrfImg->memberVO : " + memberVO);
        
        int result = this.memberService.editPrfImg(memberVO);
        log.info("editPrfImg->result : " + result);
        
        return "redirect:/member/profile?mbrId="+memberVO.getMbrId();
    }

    // 프로필 스카우트 버튼 활/비활성화
    @ResponseBody
    @PostMapping("/prfUpdateScout")
    public int prfUpdateScout(@RequestBody Map<String, Object> map) {
    	log.info("result->prfUpdateScout: " + map);
        int result = this.memProfileService.prfUpdateScout(map);
        log.info("result->prfUpdateScout: " + result);
        return result;
    }
    
    
    // 경력 추가
    @ResponseBody
    @PostMapping("/careerAddAjax")
    public int careerAddAjax(@RequestBody PrfCareerVO prfCareerVO) {
    	
    	log.info("careerAddAjax->prfCareerVO : " + prfCareerVO);
    	
    	int result = this.memProfileService.careerAddAjax(prfCareerVO);
    	
    	return result;
    }
    // 경력 수정
    @PostMapping("/careerUpdatePost")
    public String careerUpdatePost(PrfCareerVO prfCareerVO) {
    	
    	int result = this.memProfileService.careerUpdateAjax(prfCareerVO);
    	log.info("careerUpdatePost->result : " + result);
    	
    	return "redirect:/member/profile?mbrId="+prfCareerVO.getMbrId();
    }
    
    // 경력 수정
    @ResponseBody
    @PostMapping("/careerUpdateAjax")
    public int careerUpdateAjax(@RequestBody PrfCareerVO prfCareerVO) {
    	
    	int result = this.memProfileService.careerUpdateAjax(prfCareerVO);
    	
    	return result;
    }
    
    // 경력 삭제
    @ResponseBody
    @PostMapping("/careerDelAjax")
    public int careerDelAjax(@RequestBody Map<String, Object> map) {
    	 	
    	int result = this.memProfileService.careerDelAjax(map);
    	
    	return result;

    }
    
    // 학력 추가
    /*
	    {
		    "mbrId": "test1",
		    "prseSeCd": "PRSE01",
		    "acbgSchlNm": "1",
		    "acdeSeCd": "ACDE01",
		    "acspSeCd":"",
		    "acbgMjrNm": "PRSE01",
		    "acbgMtcltnym": "3",
		    "acbgGrdtnym": "5"
		}
	 */
    @ResponseBody
    @PostMapping("/acbgAddAjax")
    public int acbgAddAjax(@RequestBody PrfAcbgVO prfAcbgVO) {
    	log.info("prfAcbgVO : " + prfAcbgVO);
    	
    	int result = this.memProfileService.acbgAddAjax(prfAcbgVO);
    	
    	return result;
    }
    
    // 학력 수정
    //RequestBody 애너테이션은 비동기 방식에서 사용
    @PostMapping("/acbgUpdatePost")
    public String acbgUpdatePost(PrfAcbgVO prfAcbgVO) {
    	//PrfAcbgVO prfAcbgVO를 활용해보자
    	/*
    	PrfAcbgVO(mbrId=test1, acbgNo=AC0001, prseSeCd=PRSE01, acbgSchlNm=서울대학교2
    	, acbgMjrNm=컴퓨터공학2, acbgMtcltnym=2021.03, acbgGrdtnym=2025.08, acspSeCd=null
    	, acdeSeCd=ACDE02, prseSeNm=null, acdeSeNm=null, acspSeNm=null, codeVOList=null)
    	 */
    	log.info("acbgUpdatePost->prfAcbgVO : " + prfAcbgVO);
    	
    	int result = this.memProfileService.acbgUpdateAjax(prfAcbgVO);
    	log.info("acbgUpdatePost->result : " + result);
    	
    	return "redirect:/member/profile?mbrId="+prfAcbgVO.getMbrId();
    }
    
    // 학력 수정
    @ResponseBody
    @PostMapping("/acbgUpdateAjax")
    public int acbgUpdateAjax(@RequestBody PrfAcbgVO prfAcbgVO) {
    	
    	int result = this.memProfileService.acbgUpdateAjax(prfAcbgVO);
    	
    	return result;
    }
    
    
    // 학력 삭제
    @ResponseBody
    @PostMapping("/acbgDelAjax")
    public int acbgDelAjax(@RequestBody Map<String, Object> map) {
    	 	
    	int result = this.memProfileService.acbgDelAjax(map);
    	
    	return result;

    }
    
    
    // 수상 추가
    @ResponseBody
    @PostMapping("/WnpzAddAjax")
    public int WnpzAddAjax(@RequestBody PrfWnpzVO prfWnpzVO) {
    	
    	int result = this.memProfileService.WnpzAddAjax(prfWnpzVO);
    	
    	return result;
    }
    
    // 수상 수정
    @PostMapping("/wnpzUpdatePost")
    public String wnpzUpdatePost(PrfWnpzVO prfWnpzVO) {
    	
    	int result = this.memProfileService.wnpzUpdateAjax(prfWnpzVO);
    	log.info("wnpzUpdatePost->result : " + result);
    	
    	return "redirect:/member/profile?mbrId="+prfWnpzVO.getMbrId();
    }
    
    // 수상 수정
    @ResponseBody
    @PostMapping("/wnpzUpdateAjax")
    public int wnpzUpdateAjax(@RequestBody PrfWnpzVO prfWnpzVO) {
    	
    	int result = this.memProfileService.wnpzUpdateAjax(prfWnpzVO);
    	
    	return result;
    }
    
    // 수상 삭제
    @ResponseBody
    @PostMapping("/WnpzDelAjax")
    public int WnpzDelAjax(@RequestBody Map<String, Object> map) {
    	 	
    	int result = this.memProfileService.WnpzDelAjax(map);
    	
    	return result;

    }
    
    // 활동 추가
    @ResponseBody
    @PostMapping("/actAddAjax")
    public int actAddAjax(@RequestBody PrfActVO prfActVO) {
    	
    	int result = this.memProfileService.actAddAjax(prfActVO);
    	
    	return result;
    }
    // 활동 수정
    @PostMapping("/actUpdatePost")
    public String actUpdatePost(PrfActVO prfActVO) {
    	
    	int result = this.memProfileService.actUpdateAjax(prfActVO);
    	log.info("actUpdatePost->result : " + result);
    	
    	
    	return "redirect:/member/profile?mbrId="+prfActVO.getMbrId();
    }
    // 활동 수정
    @ResponseBody
    @PostMapping("/actUpdateAjax")
    public int actUpdateAjax(@RequestBody PrfActVO prfActVO) {
    	
    	int result = this.memProfileService.actUpdateAjax(prfActVO);
    	
    	return result;
    }
    // 활동 삭제
    @ResponseBody
    @PostMapping("/actDelAjax")
    public int actDelAjax(@RequestBody Map<String, Object> map) {
    	 	
    	int result = this.memProfileService.actDelAjax(map);
    	
    	return result;

    }
    
    // 자격증 추가
    @ResponseBody
    @PostMapping("/crtfctAddAjax")
    public int crtfctAddAjax(@RequestBody PrfCrtfctVO prfCrtfctVO) {
    	
    	int result = this.memProfileService.crtfctAddAjax(prfCrtfctVO);
    	
    	return result;
    }
    // 자격증 수정
    @PostMapping("/crtfctUpdatePost")
    public String crtfctUpdatePost(PrfCrtfctVO prfCrtfctVO) {
    	
    	int result = this.memProfileService.crtfctUpdateAjax(prfCrtfctVO);
    	log.info("crtfctUpdatePost->result : " + result);
    	
    	
    	return "redirect:/member/profile?mbrId="+prfCrtfctVO.getMbrId();
    }
    // 자격증 수정
    @ResponseBody
    @PostMapping("/crtfctUpdateAjax")
    public int crtfctUpdateAjax(@RequestBody PrfCrtfctVO prfCrtfctVO) {
    	
    	int result = this.memProfileService.crtfctUpdateAjax(prfCrtfctVO);
    	
    	return result;
    }
    // 자격증 삭제
    @ResponseBody
    @PostMapping("/crtfctDelAjax")
    public int crtfctDelAjax(@RequestBody Map<String, Object> map) {
    	 	
    	int result = this.memProfileService.crtfctDelAjax(map);
    	
    	return result;

    }
    
    // 업종 추가
    //<input type="checkbox" class="busiChk" name="business"
    @PostMapping("/BusinessAdd")
    public String BusinessAdd(PrfBusinessVO prfBusinessVO, Model model) {
    	//PrfBusinessVO(tpbizSeCd=null, mbrId=test1, tpbizNm=null, business=[INSE07, INSE11, INSE19], businessStr=null)
    	log.info("prfBusinessVO : " + prfBusinessVO);
    	
        // INSE 그룹의 코드 리스트 가져오기
        List<CodeVO> inseVOList = userMapper.codeSelect("INSE");

        // comCode와 comCodeNm을 매핑하기 위한 맵 생성
        Map<String, String> codeMap = new HashMap<>();
        for (CodeVO codeVO : inseVOList) {
            codeMap.put(codeVO.getComCode(), codeVO.getComCodeNm());
        }

        // 리스트를 서비스로 전달하여 데이터베이스에 삽입
        int result = memProfileService.BusinessAdd(prfBusinessVO);
        
        log.info("result ->",result);
        
     // 업종 조회
        List<PrfBusinessVO> prfBusinessVOList = memProfileService.BusinessList(prfBusinessVO.getMbrId());
        
        // 선택된 업종 코드 리스트 생성
        List<String> selectedCodes = prfBusinessVOList.stream()
            .map(PrfBusinessVO::getTpbizSeCd)
            .collect(Collectors.toList());     
        
        
        model.addAttribute("inseVOList",inseVOList);
        model.addAttribute("selectedCodes",selectedCodes);

        return "redirect:/member/profile?mbrId=" + prfBusinessVO.getMbrId(); 
    }
    
    // 업종 삭제
    @PostMapping("/BusinessDelAjax")
    public int BusinessDelAjax(PrfBusinessVO prfBusinessVO) {
    	 	
    	int result = this.memProfileService.BusinessDelAjax(prfBusinessVO);
    	log.info("result -> BusinessDelAjax" + result);
    	
    	return result;

    }
    
    // 스킬 추가
    /* 
	from
	
	<input type="text" name="skill" value="SK0004">
	<input type="text" name="skill" value="SK0011">
	
	to
	
	private String[] skill; 
	*/
    @ResponseBody
    @PostMapping("/skillAdd")
    public List<PrfSkillVO> skillAdd(PrfSkillVO prfSkillVO , Model model) {
    	log.info("prfSkillVO : " + prfSkillVO);
    	prfSkillVO.setMbrId(getUserUtil.getLoggedInUserId());
    	log.info("result -> prfSkillVOList ",prfSkillVO.getSkCd());
    	log.info("result -> prfSkillVOList ",prfSkillVO.getSkCd());
    	
        
        int result = this.memProfileService.skillAdd(prfSkillVO);
        log.info("result -> prfSkillVOList "+result);
        
//         회원의 스킬 조회
        List<PrfSkillVO> prfSkillVOList = this.memProfileService.skillList(prfSkillVO.getMbrId());
        model.addAttribute("prfSkillVOList",prfSkillVOList);
        
        return prfSkillVOList;

    }
    
    
    // 스킬 삭제
    @PostMapping("/skillDel")
    public int skillDel(PrfSkillVO prfSkillVO) {
    	int result = this.memProfileService.skillDel(prfSkillVO);
    	log.info("result -> skillDel" + result);
    	
    	return result;
    }
    
}
