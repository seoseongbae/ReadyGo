package kr.or.ddit.mapper;

import java.util.List;
import java.util.Map;

import kr.or.ddit.vo.AdminVO;
import kr.or.ddit.vo.BoardVO;
import kr.or.ddit.vo.CodeGrpVO;
import kr.or.ddit.vo.CodeVO;
import kr.or.ddit.vo.DeclarationVO;
import kr.or.ddit.vo.EnterVO;
import kr.or.ddit.vo.FileDetailVO;
import kr.or.ddit.vo.MemberVO;

public interface AdminMapper {
	public AdminVO selectOne(String adminVO);

	//공통 코드관리 시작
    public List<CodeVO> codeManage(String comCodeGrp);
    
	public List<CodeVO> codeAllSelect(Map<String, Object> map);


	public int codeGrpAdd(CodeGrpVO codeGrpVO);

	public int codeGrpDel(CodeGrpVO codeGrpVO);
	
    public int codeAdd(CodeVO code);
    public int codeDel(String comCode);

	public int getTotal(Map<String, Object> map);

	public List<CodeVO> codeSelect(Map<String, Object> map);

	public List<CodeVO> codeSelect(String comCodeGrp);

	
	//기업승인시작
	public int entOk(String entId);

	public int entNo(String entId);

	public EnterVO enterDetail(String entId);

	//관리자 메인
	public String main();
	
	//회원관리시작
	public String memManage();

	public int memTotal(Map<String, Object> memMap);

	public List<MemberVO> memList(Map<String, Object> memMap);

	public List<MemberVO> memOrgList();

	public int entTotal(Map<String, Object> entMap);

	public List<EnterVO> entList(Map<String, Object> entMap);

	public int reportTotal(Map<String, Object> reportMap);

	public List<DeclarationVO> reportList(Map<String, Object> reportMap);

	public List<EnterVO> reportBoardList();

	public int boardReport(Map<String, Object> paramMap);

	public int reportBoardDel(DeclarationVO declarationVO);

	//메인페이지
	public int mainEntSignTotal();

	public int mainInquiryTotal();
	
	public int mainReportMemTotal();
	
	public int mainReportBoardTotal();

	public List<DeclarationVO> mainReportList();

	public List<BoardVO> mainNoticeList();

	public List<BoardVO> mainInquiryList();

	public List<EnterVO> mainEntList();

	public int reportLimit(Map<String, Object> paramMap);

	public EnterVO enterAllDetail(String entId);

	public MemberVO memAllDetail(String mbrId);

	public int codeNmCh(Map<String, Object> paramMap);

	public int codeCodeCh(Map<String, Object> paramMap);

	public List<FileDetailVO> getEntBrFile(String entId);

	public String warningMsg(String mbrId);

	public List<DeclarationVO> reportBoardList(Map<String, Object> map);

	public List<EnterVO> enterList(Map<String, Object> map);



}
