package kr.or.ddit.service;

import java.util.List;
import java.util.Map;

import kr.or.ddit.vo.CodeVO;
import kr.or.ddit.vo.EnterVO;

public interface EnterListService {
	//기업목록
	public List<EnterVO> list(Map<String, Object> map);
	
	//총 행의 갯수
	public int getTotal(Map<String, Object> map);


}