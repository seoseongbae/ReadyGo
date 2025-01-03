package kr.or.ddit.mapper;

import java.util.List;
import java.util.Map;

import kr.or.ddit.vo.ApplicantVO;
import kr.or.ddit.vo.EnterVO;
import kr.or.ddit.vo.MemberVO;
import kr.or.ddit.vo.NotificationVO;
import kr.or.ddit.vo.PbancVO;
import kr.or.ddit.vo.VideoRoomVO;

public interface EnterMapperS {

	// 기업 진행중 공고 카운트
	int pbCount(String entId);

	// 기업 열람 지원자 카운트
	int openCount(String entId);

	// 기업 미열람 지원자 카운트
	int closeCount(String entId);

	// 기업 스카우트 제안한 카운트
	int ppCount(String entId);
	//공고리스트
	List<PbancVO> pbancList(String entId);
	//공고 캘린더 리스트
	List<PbancVO> pbancCalendarList(String entId);
	//알람 리스트
	List<NotificationVO> alarmList(String entId);
	//공고별 지원자 리스트
	List<ApplicantVO> intrvwList(Map<String, Object> map);
	//공고리스트
	List<PbancVO> pbancsList(String entId);
	//인재 신입 리스트
	List<MemberVO> injaeNewList();
	//인재 경력 리스트
	List<MemberVO> injaeOldList();
	//페이징 토탈 처리
	int getIntrvwTotal(Map<String, Object> map);
	//면접일자 등록 모달 면접방 리스트 조회
	List<VideoRoomVO> videointrvwPost(String job);
	//면접일자(화상면접) 업데이트
	void intrvwFormPost(Map<String, Object> map);
	//면접일자(일반면접) 업데이트
	void intrvwFormPost2(Map<String, Object> map);
	//화상면접방 리스트
	List<VideoRoomVO> videoRoomList(Map<String, Object> map);
	//화상면접방 페이징(토탈수)
	int getvideoIntrvwTotal(Map<String, Object> map);
	//면접관리 면접상태 업데이트
	int updateIntrvw(Map<String, Object> map);
	//면접 관리 엑셀 저장
	List<ApplicantVO> AplctListExcel(Map<String, Object> map);
	//면접 관리 지원자상태 업데이트
	int updateIntrvwPrcsStat(Map<String, Object> map);
	//멤버추가(기업회원 리스트)
	List<MemberVO> memberList(Map<String, Object> map);
	//멤버추가(기업정보)
	EnterVO getEntInfo(Map<String, Object> map);
	//멤버추가(메일 전송 후 기업회원 테이블 추가)
	int setEntMember(Map<String, Object> map);
	//메일 보내기전 회원 아이디 여부 체크
	int mbrIdChk(Map<String, Object> map);
	//메일 보내기전 기업 회원 여부 체크
	int entMemChk(Map<String, Object> map);

	int entaddmemDel(Map<String, Object> map);

	int memberListTotal(Map<String, Object> map);

	int updateappstatus(Map<String, Object> map);

	int updateDateIntrvw(String intrvwNo);

	int entmemDel(Map<String, Object> map);

}
