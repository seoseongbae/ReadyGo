package kr.or.ddit.service_DO;

import java.util.List;
import java.util.Map;

import kr.or.ddit.vo.BoardVO;
import kr.or.ddit.vo.CodeGrpVO;
import kr.or.ddit.vo.CodeVO;
import kr.or.ddit.vo.DeclarationVO;
import kr.or.ddit.vo.EnterVO;
import kr.or.ddit.vo.FileDetailVO;
import kr.or.ddit.vo.MemberVO;

public interface AdminService {
    // @공통 코드 목록을 반환하도록 변경
    public List<CodeVO> codeManage(String comCodeGrp);

	public int codeGrpAdd(CodeGrpVO codeGrpVO);

	public int codeGrpDel(CodeGrpVO codeGrpVO);

	public int codeAdd(CodeVO codeVO);

	public int codeDel(String comCode);

	public int getTotal(Map<String, Object> map);
	
	//@기업관리 시작
	public int entOk(String entId);

	public int entNo(String entId);

	public EnterVO entDetail(String entId);

	//@관리자메인
	public String main();
	
	//@회원관리 시작
	public String memManage();
	
	//회원수
	public int memTotal(Map<String, Object> memMap);
	//회원리스트
	public List<MemberVO> memList(Map<String, Object> memMap);

	public int entTotal(Map<String, Object> entMap);

	public List<EnterVO> entList(Map<String, Object> entMap);

	public int reportTotal(Map<String, Object> reportMap);

	public List<DeclarationVO> reportList(Map<String, Object> reportMap);

	public int boardReport(Map<String, Object> paramMap);

	public int reportBoardDel(String dclrNo);

	public int mainEntSignTotal();
	
	public int mainInquiryTotal();
	
	public int mainReportMemTotal();
	
	public int mainReportBoardTotal();

	public List<DeclarationVO> mainReportList();

	public List<BoardVO> mainNoticeList();

	public List<BoardVO> mainInquiryList();

	public List<EnterVO> mainEntList();

	public int reportLimit(Map<String, Object> paramMap);

	public int codeCodeCh(Map<String, Object> paramMap);

	public List<FileDetailVO> getEntBrFile(String entId);
	public EnterVO getEnterDetail(String entId);

	public List<DeclarationVO> reportBoardList(Map<String, Object> map);

	public List<EnterVO> enterList(Map<String, Object> map);

}
