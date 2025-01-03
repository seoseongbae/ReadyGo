package kr.or.ddit.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;

import kr.or.ddit.mapper.MemAplctMapper;
import kr.or.ddit.mapper.MemResumeMapper;
import kr.or.ddit.mapper.MemCoverLetterMapper;
import kr.or.ddit.mapper.MemProposalMapper;
import kr.or.ddit.service.MemResumeService;
import kr.or.ddit.util.ArticlePage;
import kr.or.ddit.util.CodeSelect;
import kr.or.ddit.util.GetUserUtil;
import kr.or.ddit.util.ItextPdfUtil;
import kr.or.ddit.vo.CodeGrpVO;
import kr.or.ddit.vo.CodeVO;
import kr.or.ddit.vo.CoverLetterSaveVO;
import kr.or.ddit.vo.FileDetailVO;
import kr.or.ddit.vo.MemberVO;
import kr.or.ddit.vo.ResumeVO;
import kr.or.ddit.vo.RsmAcademicVO;
import kr.or.ddit.vo.RsmCareerVO;
import kr.or.ddit.vo.RsmCertificateVO;
import kr.or.ddit.vo.RsmClVO;
import kr.or.ddit.vo.RsmExpactEDCVO;
import kr.or.ddit.vo.RsmPortfolioVO;
import kr.or.ddit.vo.RsmSkillVO;
import lombok.extern.slf4j.Slf4j;

@RequestMapping("/member")
@Slf4j
@Controller
@PreAuthorize("hasAnyRole('ROLE_MEMBER','ROLE_MEMENTER','ROLE_ENTER')")
public class MemResumeController {
	
	@Inject
	MemResumeService memResumeService;
	
	
	@Inject
	MemResumeMapper memResumeMapper;
	
	@Inject
	CodeSelect codeSelect;
	
	@Inject
	GetUserUtil getUserUtil;
	
	@Inject
	ItextPdfUtil itextpdfUtil;
	
	@Inject
	String uploadPath; 
	
	@Inject
	MemAplctMapper memAplctMapper;
	
	@Inject
	MemCoverLetterMapper memCoverLetterMapper;
	
	@Inject
	MemProposalMapper memProposalMapper;
	
	
	// 이력서 관리페이지
	@GetMapping("/resume")
	public String reume(Model model, 
			@RequestParam(value = "currentPage", required = false, defaultValue="1") Integer currentPage,
			@RequestParam(value="state",required=false, defaultValue="") String state,
    		@RequestParam(value="keywordInput",required=false, defaultValue="")String keywordInput) {
		// 로그인 한 회원의 아이디를 가져와서 작성한 이력서들을 셀렉트 합니다.
		String mbrId = getUserUtil.getLoggedInUserId();
		Map<String, Object> map = new HashMap<String,Object>();
        map.put("mbrId", mbrId);
        map.put("currentPage", currentPage);
        map.put("keywordInput", keywordInput);
        map.put("state", state);
        // 회원의 대표 이력서를 가져옵니다.
		ResumeVO openResume = memResumeService.openResume(mbrId);
		// 회원이 작성한 이력서를 가져옵니다.
		List<ResumeVO> resumeVOList = memResumeService.resumeList(map);
		// 공통코드를 가져옵니다
		List<CodeVO> codeVOList = codeSelect.codeSelect("RERE");
		// 페이징을 위한 목록의 총 겟수와 페이징한 결과값을 가져옵니다.
		int total = memResumeMapper.resumeListTotal(map);
		ArticlePage<ResumeVO> articlePage = new ArticlePage<ResumeVO>(total, currentPage, 3, resumeVOList, map);
		List<ResumeVO> resumeVOListList = memResumeMapper.selectResumeList(mbrId);
		
		Map<String, Object> map2 = new HashMap<String,Object>();
		map2.put("mbrId", mbrId);
		int total1 = memResumeMapper.getTotal1(map2); 
		int total2 = memResumeMapper.getTotal2(map2);
		
		
		model.addAttribute("openResume", openResume);
		model.addAttribute("resumeVOList", resumeVOList);
		model.addAttribute("codeVOList", codeVOList);
		model.addAttribute("articlePage", articlePage);
		model.addAttribute("total", total);
		model.addAttribute("propototal", total1);
		model.addAttribute("apltotal", total2);
		model.addAttribute("resumeVOListList", resumeVOListList);
		return "member/mypage/resume";
	}
	
	// 이력서 작성 페이지
	@GetMapping("/resumeRegist")
	public String resumeRegist(Model model, String resumeNo) {
		// 로그인한 회원정보를 가져옵니다.
		MemberVO memVO = getUserUtil.getMemVO();
		String mbrId = memVO.getMbrId();
		Map<String, Object> map = new HashMap<String,Object>();
		map.put("mbrId", mbrId);
		// 로그인한 회원이 작성한 이력서 정보를 불러옵니다. (기본 정보 미리 입력하기 위한)
		ResumeVO openResume = memResumeService.openResume(mbrId);
		List<CoverLetterSaveVO> CLVOList = memCoverLetterMapper.selectCoverLetterListNonePaging(map);
		List<String> list = new ArrayList<String>();
		list.add("GEND"); // 성별
		list.add("ACSE"); // 학력
		list.add("ACRC"); // 인정 학력
		list.add("ACGD"); // 졸업 구분
		list.add("AGPN"); // 학점
		list.add("CRDT"); // 직무
		list.add("CRBG"); // 직급
		list.add("WRGN"); // 지역
		list.add("SK"); // 스킬
		list.add("ACTS"); // 활동구분
		list.add("CLW"); // 자격/어학/수상 구분
		list.add("ACQS");  // 자격 합격구분
		list.add("LSLN");  // 어학 언어
		list.add("LSGD"); // 어학 급수
		list.add("LSYN"); // 어학 취득 여부
		list.add("POFL"); // 포트폴리오 파일
		list.add("SAL"); // 연봉
		list.add("RSCA"); // 경력
		list.add("RLSC"); // 공개범위
		list.add("POTY"); // 포트폴리오 구분
		// 코드그룹을 맵퍼로 맵핑해주는 유틸 클래스 
		Map<String, CodeGrpVO> codeGrpVOMap = codeSelect.codeGrpSelect(list);
		model.addAttribute("codeGrpVOMap", codeGrpVOMap);
		model.addAttribute("openResume", openResume);
		model.addAttribute("memVO", memVO);
		model.addAttribute("CLVOList", CLVOList);
		return "member/resumeRegist";
	}
	
	// 이력서 기본 정보 등록 ajax
	@ResponseBody
	@PostMapping("/resumebasInfoPost")
	public ResumeVO resumebasInfoPost(ResumeVO resumeVO) {
		String mbrId = getUserUtil.getLoggedInUserId();
		resumeVO.setMbrId(mbrId);
		ResumeVO rsmVO = memResumeService.resumebasInfo(resumeVO);
		return rsmVO;
	}
	
	// 학력 정보 등록 ajax
	@ResponseBody
	@PostMapping("/acbgRegistPost")
	public List<RsmAcademicVO> acbgRegistPost(RsmAcademicVO rsmAcademicVO) {
		List<RsmAcademicVO> rsmVO = memResumeService.acbgRegistPost(rsmAcademicVO);
		
		return rsmVO;
	}
	
	// 학력 정보 삭제 ajax
	@ResponseBody
	@PostMapping("/acbgDeletePost")
	public List<RsmAcademicVO> acbgDeletePost(RsmAcademicVO rsmAcademicVO) {
		List<RsmAcademicVO> rsmVO = memResumeService.acbgDeletePost(rsmAcademicVO);
		return rsmVO;
	}
	
	// 경력 정보 등록 ajax
	@ResponseBody
	@PostMapping("/careerRegistPost")
	public List<RsmCareerVO> careerRegistPost(RsmCareerVO rsmCareerVO) {
		List<RsmCareerVO> rsmVO = memResumeService.careerRegistPost(rsmCareerVO);
		
		return rsmVO;
	}
	// 경력 정보 삭제 ajax
	@ResponseBody
	@PostMapping("/careerDeletePost")
	public List<RsmCareerVO> careerDeletePost(RsmCareerVO rsmCareerVO) {
		List<RsmCareerVO> rsmVO = memResumeService.careerDeletePost(rsmCareerVO);
		return rsmVO;
	}
	// 스킬 등록 ajax
	@ResponseBody
	@PostMapping("/skillRegistPost")
	public List<RsmSkillVO> skillRegistPost(RsmSkillVO rsmSkillVO) {
		List<RsmSkillVO> rsmVO = memResumeService.skillRegistPost(rsmSkillVO);
		
		return rsmVO;
	}
	// 활동 등록 ajax
	@ResponseBody
	@PostMapping("/actRegistPost")
	public List<RsmExpactEDCVO> actRegistPost(RsmExpactEDCVO rsmExpactEDCVO) {
		List<RsmExpactEDCVO> rsmVO = memResumeService.actRegistPost(rsmExpactEDCVO);
		
		return rsmVO;
	}
	// 활동 삭제 ajax
	@ResponseBody
	@PostMapping("/actDeletePost")
	public List<RsmExpactEDCVO> actDeletePost(RsmExpactEDCVO rsmExpactEDCVO) {
		List<RsmExpactEDCVO> rsmVO = memResumeService.actDeletePost(rsmExpactEDCVO);
		return rsmVO;
	}
	// 자격증 등록 ajax
	@ResponseBody
	@PostMapping("/crtfctRegistPost")
	public List<RsmCertificateVO> crtfctRegistPost(RsmCertificateVO certificateVO) {
		List<RsmCertificateVO> rsmVO = memResumeService.crtfctRegistPost(certificateVO);
		
		return rsmVO;
	}
	// 자격증 삭제 ajax
	@ResponseBody
	@PostMapping("/crtfctDeletePost")
	public List<RsmCertificateVO> crtfctDeletePost(RsmCertificateVO certificateVO) {
		List<RsmCertificateVO> rsmVO = memResumeService.crtfctDeletePost(certificateVO);
		return rsmVO;
	}
	// 포트폴리오 등록 ajax
	@ResponseBody
	@PostMapping("/prtRegistPost")
	public List<RsmPortfolioVO> prtRegistPost(RsmPortfolioVO rsmPortfolioVO) {
		log.info("controller : " + rsmPortfolioVO.getUploadFile());
		log.info("controller : " + rsmPortfolioVO);
		List<RsmPortfolioVO> rsmVO = memResumeService.prtRegistPost(rsmPortfolioVO);
		
		return rsmVO;
	}
	// 포트폴리오 삭제 ajax
	@ResponseBody
	@PostMapping("/prtDeletePost")
	public List<RsmPortfolioVO> prtDeletePost(RsmPortfolioVO rsmPortfolioVO) {
		log.info("controller : " + rsmPortfolioVO);
		List<RsmPortfolioVO> rsmVO = memResumeService.prtDeletePost(rsmPortfolioVO);
		return rsmVO;
	}
	// 자기소개서 등록 ajax
	@ResponseBody
	@PostMapping("/CLRegistPost")
	public List<RsmClVO> CLRegistPost(RsmClVO rsmClVO) {
		log.info("controller : " + rsmClVO);
		List<RsmClVO> rsmVO = memResumeService.CLRegistPost(rsmClVO);
		
		return rsmVO;
	}
	// 자기소개서 삭제 ajax
	@ResponseBody
	@PostMapping("/CLDeletePost")
	public List<RsmClVO> CLDeletePost(RsmClVO rsmClVO) {
		log.info("controller : " + rsmClVO);
		List<RsmClVO> rsmVO = memResumeService.CLDeletePost(rsmClVO);
		return rsmVO;
	}
	
	@PostMapping("/resumeEdit")
	public String resumeEdit(@RequestParam String rsmNo, Model model) {
		String mbrId = getUserUtil.getLoggedInUserId();
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("mbrId", mbrId);
		map.put("rsmNo", rsmNo);
		ResumeVO resumeVO = memResumeMapper.selectOneResume(map);
		List<RsmAcademicVO> rsmAcademicVOList = memResumeMapper.selectAcdgList(map);
		List<RsmCareerVO> rsmCareerVOList = memResumeMapper.selectCareerList(map);
		List<RsmSkillVO> rsmSkillVOList = memResumeMapper.selectSkillList(map);
		List<RsmExpactEDCVO> rsmExpactEDCVOList = memResumeMapper.selectActList(map);
		List<RsmCertificateVO> rsmCertificateVOList = memResumeMapper.selectCrtfctList(map);
		List<RsmClVO> rsmClVOList = memResumeMapper.selectCLList(map);
		List<RsmPortfolioVO> rsmPrtVOList = memResumeMapper.selectPrtList(map);
		List<CoverLetterSaveVO> CLVOList = memCoverLetterMapper.selectCoverLetterListNonePaging(map);
		List<String> list = new ArrayList<String>();
		list.add("GEND"); // 성별
		list.add("ACSE"); // 학력
		list.add("ACRC"); // 인정 학력
		list.add("ACGD"); // 졸업 구분
		list.add("AGPN"); // 학점
		list.add("CRDT"); // 직무
		list.add("CRBG"); // 직급
		list.add("WRGN"); // 지역
		list.add("SK"); // 스킬
		list.add("ACTS"); // 활동구분
		list.add("CLW"); // 자격/어학/수상 구분
		list.add("ACQS");  // 자격 합격구분
		list.add("LSLN");  // 어학 언어
		list.add("LSGD"); // 어학 급수
		list.add("LSYN"); // 어학 취득 여부
		list.add("POFL"); // 포트폴리오 파일
		list.add("SAL"); // 연봉
		list.add("RSCA"); // 경력
		list.add("RLSC"); // 공개범위
		list.add("POTY"); // 포트폴리오 구분
		// 코드그룹을 맵퍼로 맵핑해주는 유틸 클래스 
		Map<String, CodeGrpVO> codeGrpVOMap = codeSelect.codeGrpSelect(list);
		model.addAttribute("codeGrpVOMap", codeGrpVOMap);
		model.addAttribute("resumeVO", resumeVO);
		model.addAttribute("rsmAcademicVOList", rsmAcademicVOList);
		model.addAttribute("rsmCareerVOList", rsmCareerVOList);
		model.addAttribute("rsmSkillVOList", rsmSkillVOList);
		model.addAttribute("rsmExpactEDCVOList", rsmExpactEDCVOList);
		model.addAttribute("rsmCertificateVOList", rsmCertificateVOList);
		model.addAttribute("rsmClVOList", rsmClVOList);
		model.addAttribute("rsmPrtVOList", rsmPrtVOList);
		model.addAttribute("CLVOList", CLVOList);
		return "member/resumeEdit";
	}
	@PostMapping("/resumeCopy")
	public String resumeCopy(@RequestParam String rsmNo, Model model) {
		String mbrId = getUserUtil.getLoggedInUserId();
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("mbrId", mbrId);
		map.put("rsmNo", rsmNo);
		List<String> list = new ArrayList<String>();
		list.add("GEND"); // 성별
		list.add("ACSE"); // 학력
		list.add("ACRC"); // 인정 학력
		list.add("ACGD"); // 졸업 구분
		list.add("AGPN"); // 학점
		list.add("CRDT"); // 직무
		list.add("CRBG"); // 직급
		list.add("WRGN"); // 지역
		list.add("SK"); // 스킬
		list.add("ACTS"); // 활동구분
		list.add("CLW"); // 자격/어학/수상 구분
		list.add("ACQS");  // 자격 합격구분
		list.add("LSLN");  // 어학 언어
		list.add("LSGD"); // 어학 급수
		list.add("LSYN"); // 어학 취득 여부
		list.add("POFL"); // 포트폴리오 파일
		list.add("SAL"); // 연봉
		list.add("RSCA"); // 경력
		list.add("RLSC"); // 공개범위
		list.add("POTY"); // 포트폴리오 구분
		// 코드그룹을 맵퍼로 맵핑해주는 유틸 클래스 
		Map<String, Object> VOList = memResumeService.copyResume(map);
		Map<String, CodeGrpVO> codeGrpVOMap = codeSelect.codeGrpSelect(list);
		model.addAttribute("codeGrpVOMap", codeGrpVOMap);
		model.addAttribute("resumeVO", VOList.get("resumeVO"));
		model.addAttribute("rsmAcademicVOList", VOList.get("rsmAcademicVOList"));
		model.addAttribute("rsmCareerVOList", VOList.get("rsmCareerVOList"));
		model.addAttribute("rsmSkillVOList", VOList.get("rsmSkillVOList"));
		model.addAttribute("rsmExpactEDCVOList", VOList.get("rsmExpactEDCVOList"));
		model.addAttribute("rsmCertificateVOList", VOList.get("rsmCertificateVOList"));
		model.addAttribute("rsmPrtVOList", VOList.get("rsmPrtVOList"));
		model.addAttribute("rsmClVOList", VOList.get("rsmClVOList"));
		return "member/resumeCopy";
	}
	// 이력서 작성 완료 ajax
		@ResponseBody
		@PostMapping("/lastSavePost")
		public ResumeVO lastSavePost(ResumeVO resumeVO) {
			log.info("controller : " + resumeVO);
			resumeVO.setMbrId(getUserUtil.getLoggedInUserId());
			ResumeVO rsmVO = memResumeService.lastSavePost(resumeVO);
			return rsmVO;
		}
		// 이력서 삭제
		@ResponseBody
		@PostMapping("/deleteResume")
		public int deleteResume(@RequestParam String rsmNo) {
			Map<String, Object> map = new HashMap<String, Object>();
			getUserUtil.getLoggedInUserId();
			map.put("mbrId", getUserUtil.getLoggedInUserId());
			map.put("rsmNo", rsmNo);
			int result = memResumeService.deleteResume(map);
			return result;
		}
		//대표이력서 설정
		@ResponseBody
		@PostMapping("/updateResumeRere")
		public String updateResumeRere(ResumeVO resumeVO) {
			Map<String, Object> map = new HashMap<String, Object>();
			getUserUtil.getLoggedInUserId();
			map.put("mbrId", getUserUtil.getLoggedInUserId());
			map.put("rsmNo", resumeVO.getRsmNo());
			map.put("rere", resumeVO.getRsmRlsscopeCd());
			if(resumeVO.getRsmRlsscopeCd().equals("RERE01")) {
				memResumeService.updateResumeRere2(map);
			}
			memResumeService.updateResumeRere(map);
			int cnt = memResumeMapper.selectRERE(map);
			if(cnt >= 2) {
				memResumeService.updateResumeRere2(map);
			}
			return "";
		}
		// 이력서 확인
		@PostMapping("/resumeRead")
		public String resumeRead(Model model,
				String rsmNo) {
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("mbrId", getUserUtil.getLoggedInUserId());
			map.put("rsmNo", rsmNo);
			ResumeVO resumeVO = memResumeMapper.selectOneResume(map);
			List<RsmAcademicVO> rsmAcademicVOList = memResumeMapper.selectAcdgList(map);
			List<RsmCareerVO> rsmCareerVOList = memResumeMapper.selectCareerList(map);
			List<RsmSkillVO> rsmSkillVOList = memResumeMapper.selectSkillList(map);
			List<RsmExpactEDCVO> rsmExpactEDCVOList = memResumeMapper.selectActList(map);
			List<RsmCertificateVO> rsmCertificateVOList = memResumeMapper.selectCrtfctList(map);
			List<RsmClVO> rsmClVOList = memResumeMapper.selectCLList(map);
			List<RsmPortfolioVO> rsmPrtVOList = memResumeMapper.selectPrtList(map);
			ObjectMapper mapper = new ObjectMapper();
			try {
				String rsmCareerVOListJson = mapper.writeValueAsString(rsmCareerVOList);
				model.addAttribute("rsmCareerVOListJson", rsmCareerVOListJson);
				String rsmExpactEDCVOListJson = mapper.writeValueAsString(rsmExpactEDCVOList);
				model.addAttribute("rsmExpactEDCVOListJson", rsmExpactEDCVOListJson);
			} catch (JsonProcessingException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			
			model.addAttribute("resumeVO", resumeVO);
			model.addAttribute("rsmAcademicVOList", rsmAcademicVOList);
			model.addAttribute("rsmCareerVOList", rsmCareerVOList);
			model.addAttribute("rsmSkillVOList", rsmSkillVOList);
			model.addAttribute("rsmExpactEDCVOList", rsmExpactEDCVOList);
			model.addAttribute("rsmCertificateVOList", rsmCertificateVOList);
			model.addAttribute("rsmClVOList", rsmClVOList);
			model.addAttribute("rsmPrtVOList", rsmPrtVOList);
			return "/member/resumeRead";
		}
		@PostMapping("/resumeRead2")
		public String resumeRead2(Model model,
				String rsmNo, String mbrId) {
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("mbrId", mbrId);
			map.put("rsmNo", rsmNo);
			log.info("mbrId : " + mbrId);
			log.info("rsmNo : " + rsmNo);
			ResumeVO resumeVO = memResumeMapper.selectOneResume(map);
			List<RsmAcademicVO> rsmAcademicVOList = memResumeMapper.selectAcdgList(map);
			List<RsmCareerVO> rsmCareerVOList = memResumeMapper.selectCareerList(map);
			List<RsmSkillVO> rsmSkillVOList = memResumeMapper.selectSkillList(map);
			List<RsmExpactEDCVO> rsmExpactEDCVOList = memResumeMapper.selectActList(map);
			List<RsmCertificateVO> rsmCertificateVOList = memResumeMapper.selectCrtfctList(map);
			List<RsmClVO> rsmClVOList = memResumeMapper.selectCLList(map);
			List<RsmPortfolioVO> rsmPrtVOList = memResumeMapper.selectPrtList(map);
			ObjectMapper mapper = new ObjectMapper();
			try {
				String rsmCareerVOListJson = mapper.writeValueAsString(rsmCareerVOList);
				model.addAttribute("rsmCareerVOListJson", rsmCareerVOListJson);
				String rsmExpactEDCVOListJson = mapper.writeValueAsString(rsmExpactEDCVOList);
				model.addAttribute("rsmExpactEDCVOListJson", rsmExpactEDCVOListJson);
			} catch (JsonProcessingException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			
			model.addAttribute("resumeVO", resumeVO);
			model.addAttribute("rsmAcademicVOList", rsmAcademicVOList);
			model.addAttribute("rsmCareerVOList", rsmCareerVOList);
			model.addAttribute("rsmSkillVOList", rsmSkillVOList);
			model.addAttribute("rsmExpactEDCVOList", rsmExpactEDCVOList);
			model.addAttribute("rsmCertificateVOList", rsmCertificateVOList);
			model.addAttribute("rsmClVOList", rsmClVOList);
			model.addAttribute("rsmPrtVOList", rsmPrtVOList);
			return "/member/resumeRead";
		}
		// 이력서 다운로드
		@PostMapping("/resumeDownload")
		public String resumeDownload(Model model, 
				String rsmNo) {
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("mbrId", getUserUtil.getLoggedInUserId());
			map.put("rsmNo", rsmNo);
			ResumeVO resumeVO = memResumeMapper.selectOneResume(map);
			List<RsmAcademicVO> rsmAcademicVOList = memResumeMapper.selectAcdgList(map);
			List<RsmCareerVO> rsmCareerVOList = memResumeMapper.selectCareerList(map);
			List<RsmSkillVO> rsmSkillVOList = memResumeMapper.selectSkillList(map);
			List<RsmExpactEDCVO> rsmExpactEDCVOList = memResumeMapper.selectActList(map);
			List<RsmCertificateVO> rsmCertificateVOList = memResumeMapper.selectCrtfctList(map);
			List<RsmClVO> rsmClVOList = memResumeMapper.selectCLList(map);
			List<RsmPortfolioVO> rsmPrtVOList = memResumeMapper.selectPrtList(map);
			ObjectMapper mapper = new ObjectMapper();
			try {
				String rsmCareerVOListJson = mapper.writeValueAsString(rsmCareerVOList);
				model.addAttribute("rsmCareerVOListJson", rsmCareerVOListJson);
				String rsmExpactEDCVOListJson = mapper.writeValueAsString(rsmExpactEDCVOList);
				model.addAttribute("rsmExpactEDCVOListJson", rsmExpactEDCVOListJson);
			} catch (JsonProcessingException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			
			
			model.addAttribute("resumeVO", resumeVO);
			model.addAttribute("rsmAcademicVOList", rsmAcademicVOList);
			model.addAttribute("rsmCareerVOList", rsmCareerVOList);
			model.addAttribute("rsmSkillVOList", rsmSkillVOList);
			model.addAttribute("rsmExpactEDCVOList", rsmExpactEDCVOList);
			model.addAttribute("rsmCertificateVOList", rsmCertificateVOList);
			model.addAttribute("rsmClVOList", rsmClVOList);
			model.addAttribute("rsmPrtVOList", rsmPrtVOList);
			return "/member/resumeDownload";
		}
		// 이력서 다운로드
		@PostMapping("/resumeDownload2")
		public String resumeDownload2(Model model, 
				String rsmNo, String mbrId) {
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("mbrId", mbrId);
			map.put("rsmNo", rsmNo);
			ResumeVO resumeVO = memResumeMapper.selectOneResume(map);
			List<RsmAcademicVO> rsmAcademicVOList = memResumeMapper.selectAcdgList(map);
			List<RsmCareerVO> rsmCareerVOList = memResumeMapper.selectCareerList(map);
			List<RsmSkillVO> rsmSkillVOList = memResumeMapper.selectSkillList(map);
			List<RsmExpactEDCVO> rsmExpactEDCVOList = memResumeMapper.selectActList(map);
			List<RsmCertificateVO> rsmCertificateVOList = memResumeMapper.selectCrtfctList(map);
			List<RsmClVO> rsmClVOList = memResumeMapper.selectCLList(map);
			List<RsmPortfolioVO> rsmPrtVOList = memResumeMapper.selectPrtList(map);
			ObjectMapper mapper = new ObjectMapper();
			try {
				String rsmCareerVOListJson = mapper.writeValueAsString(rsmCareerVOList);
				model.addAttribute("rsmCareerVOListJson", rsmCareerVOListJson);
				String rsmExpactEDCVOListJson = mapper.writeValueAsString(rsmExpactEDCVOList);
				model.addAttribute("rsmExpactEDCVOListJson", rsmExpactEDCVOListJson);
			} catch (JsonProcessingException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			
			
			model.addAttribute("resumeVO", resumeVO);
			model.addAttribute("rsmAcademicVOList", rsmAcademicVOList);
			model.addAttribute("rsmCareerVOList", rsmCareerVOList);
			model.addAttribute("rsmSkillVOList", rsmSkillVOList);
			model.addAttribute("rsmExpactEDCVOList", rsmExpactEDCVOList);
			model.addAttribute("rsmCertificateVOList", rsmCertificateVOList);
			model.addAttribute("rsmClVOList", rsmClVOList);
			model.addAttribute("rsmPrtVOList", rsmPrtVOList);
			return "/member/resumeDownload";
		}
		
		
		// 자소서 관리페이지
		@GetMapping("/cover")
		public String cover(Model model, 
				@RequestParam(value = "currentPage", required = false, defaultValue="1") Integer currentPage,
				@RequestParam(value="state",required=false, defaultValue="") String state,
	    		@RequestParam(value="keywordInput",required=false, defaultValue="")String keywordInput) {
			// 로그인 한 회원의 아이디를 가져와서 작성한 자소서들을 셀렉트 합니다.
			String mbrId = getUserUtil.getLoggedInUserId();
			
			Map<String, Object> map = new HashMap<String,Object>();
			map.put("mbrId", mbrId);
			map.put("currentPage", currentPage);
			map.put("state", state);
			map.put("keywordInput", keywordInput);
			// 회원이 작성한 자소서를 가져옵니다.
			List<CoverLetterSaveVO> coverLetterSaveVOList = memCoverLetterMapper.selectCoverLetterList(map);
			// 공통코드를 가져옵니다
			// 페이징을 위한 목록의 총 겟수와 페이징한 결과값을 가져옵니다.
			int total = memCoverLetterMapper.selectCLTotal(map);
			ArticlePage<CoverLetterSaveVO> articlePage = new ArticlePage<CoverLetterSaveVO>(total, currentPage, 4, coverLetterSaveVOList, map);
			
			model.addAttribute("articlePage", articlePage);
			model.addAttribute("total", total);
			return "member/mypage/cover";
		}
		
		// 자소서 작성페이지
		@PostMapping("/coverRegist")
		public String coverRegist(Model model, CoverLetterSaveVO coverVO) {
			Map<String, Object> map = new HashMap<String, Object>();
			String mbrId = getUserUtil.getLoggedInUserId();
			String clStrgNo = coverVO.getClStrgNo();
			map.put("clStrgNo", clStrgNo);
			map.put("mbrId", mbrId);
			coverVO = memCoverLetterMapper.selectOneCoverLetter(map);
			model.addAttribute("coverVO", coverVO);
			return "member/coverRegist";
		}
		
		// 자소서 작성 post
		@ResponseBody
		@PostMapping("/coverRegistPost")
		public int coverRegistPost(CoverLetterSaveVO coverVO) {
			log.info("coverRegistPost : " + coverVO);
			coverVO.setMbrId(getUserUtil.getLoggedInUserId());
			int result = memResumeService.coverRegistPost(coverVO);
			return result;
		}
		// 자소서  delete
		@ResponseBody
		@PostMapping("/coverDeletePost")
		public int coverDeletePost(CoverLetterSaveVO coverVO) {
			int result = 0;
			result = memResumeService.coverDeletePost(coverVO);
			return result;
		}
}



















