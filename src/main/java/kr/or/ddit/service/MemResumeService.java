package kr.or.ddit.service;

import java.util.List;
import java.util.Map;

import kr.or.ddit.vo.CoverLetterSaveVO;
import kr.or.ddit.vo.ResumeVO;
import kr.or.ddit.vo.RsmAcademicVO;
import kr.or.ddit.vo.RsmCareerVO;
import kr.or.ddit.vo.RsmCertificateVO;
import kr.or.ddit.vo.RsmClVO;
import kr.or.ddit.vo.RsmExpactEDCVO;
import kr.or.ddit.vo.RsmPortfolioVO;
import kr.or.ddit.vo.RsmSkillVO;

public interface MemResumeService {
	public ResumeVO openResume(String mbrId);
	public List<ResumeVO> resumeList(Map<String, Object> map);
	public ResumeVO resumebasInfo(ResumeVO resumeVO);
	public List<RsmAcademicVO> acbgRegistPost(RsmAcademicVO rsmAcademicVO);
	public List<RsmAcademicVO> acbgDeletePost(RsmAcademicVO rsmAcademicVO);
	public List<RsmCareerVO> careerRegistPost(RsmCareerVO rsmCareerVO);
	public List<RsmCareerVO> careerDeletePost(RsmCareerVO rsmCareerVO);
	public List<RsmSkillVO> skillRegistPost(RsmSkillVO rsmSkillVO);
	public List<RsmExpactEDCVO> actRegistPost(RsmExpactEDCVO rsmExpactEDCVO);
	public List<RsmExpactEDCVO> actDeletePost(RsmExpactEDCVO rsmExpactEDCVO);
	public List<RsmCertificateVO> crtfctRegistPost(RsmCertificateVO certificateVO);
	public List<RsmCertificateVO> crtfctDeletePost(RsmCertificateVO certificateVO);
	public List<RsmPortfolioVO> prtRegistPost(RsmPortfolioVO rsmPortfolioVO);
	public List<RsmPortfolioVO> prtDeletePost(RsmPortfolioVO rsmPortfolioVO);
	public List<RsmClVO> CLRegistPost(RsmClVO rsmClVO);
	public List<RsmClVO> CLDeletePost(RsmClVO rsmClVO);
	public ResumeVO lastSavePost(ResumeVO resumeVO);
	public Map<String, Object> copyResume(Map<String, Object> map);
	public int deleteResume(Map<String, Object> map);
	public void updateResumeRere(Map<String, Object> map);
	public void updateResumeRere2(Map<String, Object> map);
	public int coverRegistPost(CoverLetterSaveVO coverVO);
	public int coverDeletePost(CoverLetterSaveVO coverVO);
}
