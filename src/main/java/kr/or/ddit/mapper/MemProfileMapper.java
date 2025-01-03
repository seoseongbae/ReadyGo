package kr.or.ddit.mapper;

import java.util.List;
import java.util.Map;

import kr.or.ddit.vo.CodeVO;
import kr.or.ddit.vo.MemberVO;
import kr.or.ddit.vo.PrfAcbgVO;
import kr.or.ddit.vo.PrfActVO;
import kr.or.ddit.vo.PrfBusinessVO;
import kr.or.ddit.vo.PrfCareerVO;
import kr.or.ddit.vo.PrfCrtfctVO;
import kr.or.ddit.vo.PrfSkillVO;
import kr.or.ddit.vo.PrfVO;
import kr.or.ddit.vo.PrfWnpzVO;

public interface MemProfileMapper {
	
	  // 프로필 
    public PrfVO profile(String mbrId);
    // 프로필 수정
    public int prfUpdateAjax(Map<String, Object>map);
    // 입사 제안 수정
    public int prfUpdateScout(Map<String, Object>map);
	
    // 경력 목록 조회
    public List<PrfCareerVO> careerList(String mbrId); 
    // 경력 추가
    public int careerAddAjax(PrfCareerVO prfCareerVO);   
    // 경력 수정
    public int careerUpdateAjax(PrfCareerVO prfCareerVO);
    // 경력 삭제
    public int careerDelAjax(Map<String, Object> map);
    
    
	// 학력 목록 조회
	public List<PrfAcbgVO> acbgList(String mbrId);	
	// 학력 추가
	public int acbgAddAjax(PrfAcbgVO prfAcbgVO);
    // 학력 수정
    public int acbgUpdateAjax(PrfAcbgVO prfAcbgVO);
    // 학력 삭제
    public int acbgDelAjax(Map<String, Object> map);
    
	// 프로필 학력 항목
	public List<CodeVO> prseList();	
	// 학위 항목
	public List<CodeVO> acdeList();
	// 전공계열 항목
	public List<CodeVO> acspList();
    
	// 수상 조회
	public List<PrfWnpzVO> WnpzList(String mbrId);    
	// 수상 추가
	public int WnpzAddAjax(PrfWnpzVO prfWnpzVO);
	// 수상 수정
	public int wnpzUpdateAjax(PrfWnpzVO prfWnpzVO);
	// 수상 삭제
	public int WnpzDelAjax(Map<String, Object> map);
	
    
    // 활동 조회
    public List<PrfActVO> ActList(String mbrId);
    // 활동 추가
    public int actAddAjax(PrfActVO prfActVO);
    // 활동 수정
    public int actUpdateAjax(PrfActVO prfActVO);
    // 활동 삭제
    public int actDelAjax(Map<String, Object> map);
    
	
    // 자격증 조회
    public List<PrfCrtfctVO> crtfctList(String mbrId);
    // 자격증 추가
    public int crtfctAddAjax(PrfCrtfctVO prfCrtfctVO);
    // 자격증 수정
    public int crtfctUpdateAjax(PrfCrtfctVO prfCrtfctVO);
    // 자격증 삭제
    public int crtfctDelAjax(Map<String, Object> map);
    
    

    
    // 업종 조회
    public List<PrfBusinessVO> BusinessList(String mbrId);
    // 업종 추가
    public int BusinessAdd(PrfBusinessVO prfBusinessVO);
    // 업종 삭제
    public int BusinessDelAjax(PrfBusinessVO prfBusinessVO);
    
    
	// 스킬 조회
	public List<PrfSkillVO> skillList(String mbrId);
    // 스킬 추가
    public int skillAdd(PrfSkillVO prfSkillVO);
    // 스킬 삭제
    public int skillDel(PrfSkillVO prfSkillVO);
    
    
    
}
