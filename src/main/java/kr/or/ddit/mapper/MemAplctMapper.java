package kr.or.ddit.mapper;

import java.util.List;
import java.util.Map;

import kr.or.ddit.vo.ApplicantVO;
import kr.or.ddit.vo.CodeVO;
import kr.or.ddit.vo.FileDetailVO;
import kr.or.ddit.vo.PbancVO;
import kr.or.ddit.vo.ScrapVO;

public interface MemAplctMapper {
	
	// 입사 목록 조회
	public List<ApplicantVO> aplctList(Map<String, Object> map);

	// 전체 입사 행 수
	public int getTotal(Map<String, Object> map);
	
	// 입사 지원 취소 사유 항목
	public List<CodeVO> cancelList();

	// 특정 공고 입사 지원 취소 사유 update
	public int aplctDelete(Map<String, Object> map);
	
	// 입사 관리 목록 조회
	public List<ApplicantVO> aplctManage(Map<String, Object>map);
	
	// 입사 지원 중복 체크
	public ApplicantVO aplctChk(Map<String, Object> map);
	
	// 입사 지원 관리 전체 행의 수
	public int getManTotal(Map<String, Object> map);
	
	// 받은 제안 목록 조회
	public List<ApplicantVO> comscoutList (String mbrId);
	
	// 상태 미평가 행의 수
	public int getNotTotal(String mbrId);
	
	// 상태 서류 합격 행의 수
	public int getDocTotal(String mbrId);
	
	// 상태 최종합격 행의 수
	public int getFinTotal(String mbrId);
	
	// 상태 불합격 행의 수
	public int getBadTotal(String mbrId);
	
	// 내가 스크랩한 공고 조회
	public List<PbancVO> scrapList(Map<String, Object> map);
	
	// 스크랩한 전체 행의 수
	public int getScrapTotal(Map<String, Object> map);
	
	// 공고 스크랩 추가
 	public int addScrap(ScrapVO scrapVO);
 	
	// 스크랩한 공고 삭제
 	public int delScrap(Map<String, Object> map);
	
 	// 공고 스크랩 여부 확인
 	public int scrapYN(Map<String, Object> map);
 	
 	// 입사 지원 
 	public int aplctAdd(ApplicantVO applicantVO);

	public String getPbancEntId(String pbancNo);

	public PbancVO getPbanc(String pbancNo);
}
