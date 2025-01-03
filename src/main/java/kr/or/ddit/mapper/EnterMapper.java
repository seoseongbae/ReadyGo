package kr.or.ddit.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

import kr.or.ddit.vo.ApplicantVO;
import kr.or.ddit.vo.CodeVO;
import kr.or.ddit.vo.EnterEmpYcntVO;
import kr.or.ddit.vo.EnterVO;
import kr.or.ddit.vo.FileDetailVO;
import kr.or.ddit.vo.MemberVO;
import kr.or.ddit.vo.PbancVO;
import kr.or.ddit.vo.ProposalVO;

public interface EnterMapper {
	
	/*기업프로필*/
	public EnterVO profile(String entId);//기업프로필
	public List<EnterEmpYcntVO> empYcnt(String entId);//기업 프로필 연도별 입사자수
	public List<CodeVO> getIndutyList();//기업프로필 - 업종
	
	/*기업정보수정*/
	public EnterVO edit(String entId);//기업정보수정 폼
	public List<CodeVO> getEntStleCdList();//기업정보수정 - 기업형태
	public int editPost1(EnterVO enterVO);//기업정보수정 실행
	public int editPost2(EnterVO enterVO);//INDUTY(업종) 테이블을 업데이트
	public EnterVO selectOne(String entId);
	public EnterVO passEdit(String entId);//비밀번호수정
	public int passEditPost(EnterVO enterVO);//비밀번호수정실행
	
	//기업탈퇴
	public int deleteAjax(String entId);

	/*인재*/
	public List<CodeVO> getSkillList(Map<String, Object> map);//인재-스킬
	public List<MemberVO> getInjaeList(Map<String, Object> map);//인재리스트
	public int getTotal(Map<String, Object> map);//페이지네이션
	public List<MemberVO> getRecommendList(Map<String, Object> map);//기업추천인재
	public int getTotalInjae(Map<String, Object> map);//페이지네이션
	public EnterVO getEntInfo(Map<String, Object> map);//인재 메일 보낼때 기업 정보 꺼내오기
	public FileDetailVO getfilePath(Map<String, Object> map);//인재 메일 파일 위치 데이터 뽑아오기
	public void setProposal(Map<String, Object> map);//인재 제안테이블 추가

	/*스카우트제안*/
	public List<PbancVO> pbancList(Map<String, Object> map);//기업 스카우트 제안 공고
	public List<ProposalVO> scoutList(Map<String, Object> map); //스카우트 제안 리스트
	public List<ProposalVO> scoutListExcel(Map<String, Object> map);//스카우트리스트 엑셀

	/*기업 공고관리*/
	public List<PbancVO> getPbancList(Map<String, Object> map);//기업 공고관리
	public int getTotalPbanc(Map<String, Object> map);//페이지네이션
	public PbancVO pbancDetailList(Map<String, Object> map);//공고상세
	public int addScrap(Map<String, Object> map);//스크랩증가
	public int getscrap(Map<String, Object> map); //스크랩 회원 여부
	public int cancelScrap(Map<String, Object> map);//스크랩취소
	public int getScrapCount(String pbancNo);//스크랩조회
	public int pbancDelete(Map<String, Object> map);//공고삭제
	
	/*공고수정*/
	public int pbancUpdate(PbancVO pbancVO); //공고수정:pbanc
	public void favorDelete(PbancVO pbancVO);//공고수정:favor삭제
	public int favorUpdate(PbancVO pbancVO);//공고수정"favor
	public int recruitmentUpdate(PbancVO pbancVO);//공고수정:recruitment
	public int procssDelete(PbancVO pbancVO);//공고수정:procss삭제
	public int procssUpdate(PbancVO pbancVO);//공고수정:procss
	public void tpbizDelete(PbancVO pbancVO); //공고수정:업종 삭제
	public int fileUpdate(PbancVO pbancVO); //공고수정:파일업로드
	public void powkDelete(PbancVO pbancVO);//공고수정:지역삭제	
	public int tpbizUpdate(PbancVO pbancVO);//공고수정:업종
	public int addrUpdate(PbancVO pbancVO);//공고수정:지역
	public List<CodeVO> getpowkCdList();//공고지역대장
	public void privilegedDelete(PbancVO pbancVO);//공고수정:필수삭제
	public int privilegedUpdate(PbancVO pbancVO);//공고수정:필수
	public void preferDelete(PbancVO pbancVO);//공고수정:우대삭제
	public int preferUpdate(PbancVO pbancVO);//공고수정:우대
	
	/*공고등록*/
	public EnterVO getEntInfor(String entId);//공고등록기업정보조회
	public int pbancInsertPost1(PbancVO pbancVO);//공고등록실행:pbanc
	public int pbancInsertPost2(PbancVO pbancVO);//공고등록실행:favor
	public int pbancInsertPost3(PbancVO pbancVO);//공고등록실행:recruitment
	public int pbancInsertPost4(PbancVO pbancVO);//공고등록실행:procss
	public int pbancInsertPost5(PbancVO pbancVO);//공고등록실행:file
	public int pbancInsertPost6(PbancVO pbancVO);//공고등록실행:업종
	public int pbancInsertPost7(PbancVO pbancVO);//공고등록실행:지역
	public int pbancInsertPost8(PbancVO pbancVO);//공고등록실행:필수조건
	public int pbancInsertPost9(PbancVO pbancVO);//공고등록실행:우대조건	
	
	/*공고임시저장*/
	public EnterVO location(String entId);//카카오맵
	public List<PbancVO> tempPbanc(Map<String, Object> map);//공고임시저장
	public int getTotalTempPbanc(Map<String, Object> map);//공고임시저장 페이지네이션
	public int pbancSavePost1(PbancVO pbancVO); //공고임시저장 실행:pbanc
	public int pbancSavePost2(PbancVO pbancVO); //공고임시저장 실행:favor
	public int pbancSavePost3(PbancVO pbancVO); //공고임시저장 실행:recruitment
	public int pbancSavePost4(PbancVO pbancVO); //공고임시저장 실행:procss
	public int pbancSavePost5(PbancVO pbancVO); //공고임시저장 실행:file	
	public int pbancSavePost6(PbancVO pbancVO); //공고임시저장 실행:업종	
	public int pbancTempInsertPost1(PbancVO pbancVO);//공고임시저장 -> 저장
	public int retempPbancSavePost1(PbancVO pbancVO); //공고임시저장-> 임시저장 버튼 실행
	
	/*지원자리스트*/
	public List<ApplicantVO> aplctList(Map<String, Object> map);//지원자리스트
	public int getTotalListAplct(Map<String, Object> map);//페이지네이션
	public int updateAplctSt(Map<String, Object> map);//지원자상태저장
	public List<ApplicantVO> AplctListExcel(Map<String, Object> map);//지원자 리스트 엑셀
	public List<PbancVO> entPbancList(Map<String, Object> map);//공고꺼내기
	public List<ProposalVO> proposalList(Map<String, Object> map);//제안 아이디 꺼내기
	public void updateAplctIntrvw(Map<String, Object> map); //지원자상태저장시 면접 관리 추가
	public int intrvwChk(Map<String, Object> map);	//지원자 상태 저장시 interview 안 유무 체크
	public List<MemberVO> getInjaeList2(Map<String, Object> map);
	
	

	
	

	
	
	
	
	
	




	
	














	
}
