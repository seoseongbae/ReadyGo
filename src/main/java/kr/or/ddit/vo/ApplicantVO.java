package kr.or.ddit.vo;

import java.util.Date;
import java.util.List;

import org.springframework.web.multipart.MultipartFile;

import kr.or.ddit.util.ArticlePage;
import lombok.Data;

// 지원자
@Data
public class ApplicantVO {
	private int rnum;	// 행의 수
	private String mbrId;
	private String pbancNo;
	private String rsmNo;			// 이력서 번호
	private String rsmTtl;		    // 이력서 이름
	private Date aplctAppymd;
	private String aplctAppymds;
	private String aplctPrcsStatCd;
	private String aplctPrcsStatCdNm;
	private String aplctFile;	
	private String aplctFileNm;		//첨부파일 이름
//	private String aplctPrvcagreYmd;
	private String aplctCancelCd;	// 입사 지원 취소 코드
	private String aplctPrcsNm;	    // 지원 상태 코드명
	
	// 지원자 파일
	private MultipartFile[] uploadFile;		// 데이터베이스 매핑에 사용되지 않음
	private String fileGroupSn;				//파일 그룹 번호
	private String orgnlFileNm;
	
	// 지원(APPLICANT) : 파일그룹(FILE_DT) = 1 : N
	private List<FileDetailVO> fileDetailVOList;
	
	private String entNm;	// 기업명
	private String pbancTtl; // 공고제목
	private String rcritNm;  // 모집명
	
	// APPLICANT : PBANC = 1 : N
	// 지원한 공고 목록
	private List<PbancVO> pbancVOList;

	private String mbrNm; // 회원 이름
	private String intrvwYmd; // 면접일자
	private String skCd; // 스킬
	private String pbancDdlnDt; //공고마감일
	private String rsmCareerCd; //경력신입코드
	private String intrvwSttusCd; //면접 상태 코드
	private String intrvwSttusCdNm; //면접 상태 코드
	private ArticlePage<ApplicantVO> articlePage; //페이징 처리
	private String intrvwTyCd; //면접구분코드
	private String intrvwNo; //면접 번호
	private String fileNm; //파일 이름
	private String procssCd; //면접 구분 코드
	
}
