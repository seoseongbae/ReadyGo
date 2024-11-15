package kr.or.ddit.service;

import java.util.List;
import java.util.Map;

import kr.or.ddit.vo.CodeVO;
import kr.or.ddit.vo.PbancVO;

public interface PbancService {
	
	//공고 목록
	public List<PbancVO> list(Map<String, Object> map);
	
	//전체 행의 수
	public int getTotal(Map<String, Object> map);

	
	//기업 현재 채용중인 공고 리스트
	public List<PbancVO> getPbancList(String entId);
	
	// 지역 리스트
	public List<CodeVO> regionList();
	
	//선택한 지역의 시/구 리스트
	public List<CodeVO> cityList(String comCode);
	
	//직무 리스트
	public List<CodeVO> jobList();

}
