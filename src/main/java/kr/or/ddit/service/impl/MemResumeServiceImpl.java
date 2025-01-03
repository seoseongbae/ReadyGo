package kr.or.ddit.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import kr.or.ddit.mapper.MemCoverLetterMapper;
import kr.or.ddit.mapper.MemResumeMapper;
import kr.or.ddit.service.MemResumeService;
import kr.or.ddit.util.GetUserUtil;
import kr.or.ddit.util.UploadController;
import kr.or.ddit.vo.CoverLetterSaveVO;
import kr.or.ddit.vo.MemberVO;
import kr.or.ddit.vo.ResumeVO;
import kr.or.ddit.vo.RsmAcademicVO;
import kr.or.ddit.vo.RsmCareerVO;
import kr.or.ddit.vo.RsmCertificateVO;
import kr.or.ddit.vo.RsmClVO;
import kr.or.ddit.vo.RsmExpactEDCVO;
import kr.or.ddit.vo.RsmPortfolioVO;
import kr.or.ddit.vo.RsmSkillVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class MemResumeServiceImpl implements MemResumeService {
	@Inject
	MemResumeMapper memResumeMapper;
	
	@Inject
	UploadController uploadController;
	
	@Inject
	GetUserUtil getUserUtil;
	
	@Inject
	MemCoverLetterMapper memCoverLetterMapper;

	@Override
	public ResumeVO openResume(String mbrId) {
		return memResumeMapper.openResume(mbrId);
	}

	@Override
	public List<ResumeVO> resumeList(Map<String, Object> mbrId) {
		return memResumeMapper.resumeList(mbrId);
	}
	
	// 이력서 이미지 파일 그룹에 저장후 그룹번호 받고 이력서에 인서트 이미 있으면 업데이트
	// 이력서 기본정보 갱신
	@Override
	public ResumeVO resumebasInfo(ResumeVO resumeVO) {
		MultipartFile[] multipartFiles = resumeVO.getUploadFile();
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("mbrId", resumeVO.getMbrId());
		map.put("rsmNo", resumeVO.getRsmNo());
		ResumeVO rsmVO =  memResumeMapper.selectOneResume(map);
		
	    if(resumeVO.getRsmNo() == null || resumeVO.getRsmNo().trim().isEmpty()) {
	    	if (multipartFiles == null || multipartFiles.length == 0 || multipartFiles[0].isEmpty()) {
	    		MemberVO memVO = getUserUtil.getMemVO();
	    		resumeVO.setRsmFile(memVO.getFileGroupSn());
	    	}else {
	    		String fileGroupSn = this.uploadController.multiImageUpload(multipartFiles, "/resume");
	    		resumeVO.setRsmFile(fileGroupSn);
				log.info("editPost->fileGroupSn : " + fileGroupSn);
	    	}
			memResumeMapper.insertResumebasInfo(resumeVO);
			map.put("rsmNo", resumeVO.getRsmNo());
		}else {
			if (multipartFiles == null || multipartFiles.length == 0 || multipartFiles[0].isEmpty()) {
				log.info("새로운 파일이 업로드되지 않았습니다. 기존 파일을 유지합니다.");
				if(rsmVO.getRsmFile()== null || rsmVO.getRsmFile().trim().isEmpty()) {
					resumeVO.setRsmFile(null);
				}else {
					resumeVO.setRsmFile(rsmVO.getRsmFile());
				}
			} else {
				// 새로운 파일 업로드 처리
				String fileGroupSn = this.uploadController.multiImageUpload(multipartFiles, "/resume");
				log.info("editPost->fileGroupSn : " + fileGroupSn);
				
				// 새로운 파일 그룹 번호 설정
				resumeVO.setRsmFile(fileGroupSn);
			}
			memResumeMapper.updateResumebasInfo(resumeVO);
		}
	    resumeVO = memResumeMapper.selectOneResume(map);
		return resumeVO;
	}
	// 학력 갱신
	@Override
	public List<RsmAcademicVO> acbgRegistPost(RsmAcademicVO rsmAcademicVO) {
		String rsmNo = rsmAcademicVO.getRsmNo();
		String AcbgNo = rsmAcademicVO.getAcbgNo().trim();
		if(rsmAcademicVO.getAcbgMtcltnym().length()> 5) {
			String mtcltnym =  rsmAcademicVO.getAcbgMtcltnym().replaceAll("-", "").substring(0, 6);
			rsmAcademicVO.setAcbgMtcltnym(mtcltnym);
		}
		if(rsmAcademicVO.getAcbgGrdtnym().length() > 5) {
			String grdtnym = rsmAcademicVO.getAcbgGrdtnym().replaceAll("-", "").substring(0, 6);
			rsmAcademicVO.setAcbgGrdtnym(grdtnym);;
		}
		
		log.info("AcbgNo : " + AcbgNo );
		if(AcbgNo==null || AcbgNo.equals("")){
			 memResumeMapper.insertAcdg(rsmAcademicVO);
		}else {
			memResumeMapper.updateAcdg(rsmAcademicVO);
			
		}
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("rsmNo", rsmNo);
		map.put("mbrId", getUserUtil.getMemVO().getMbrId());
		List<RsmAcademicVO> rsmVO = memResumeMapper.selectAcdgList(map);
		return rsmVO;
	}
	// 학력 삭제
	@Override
	public List<RsmAcademicVO> acbgDeletePost(RsmAcademicVO rsmAcademicVO) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("rsmNo", rsmAcademicVO.getRsmNo());
		map.put("AcbgNo", rsmAcademicVO.getAcbgNo());
		memResumeMapper.deleteAcbg(map);
		map.put("mbrId", getUserUtil.getMemVO().getMbrId());
		List<RsmAcademicVO> rsmVO = memResumeMapper.selectAcdgList(map);
		return rsmVO;
	}
	// 경력 갱신
	@Override
	public List<RsmCareerVO> careerRegistPost(RsmCareerVO rsmCareerVO) {
		String rsmNo = rsmCareerVO.getRsmNo();
		String careerNo = rsmCareerVO.getCareerNo().trim();
		if(rsmCareerVO.getCareerJncmpYmd().length()> 6) {
			String careerJncmpYmd =  rsmCareerVO.getCareerJncmpYmd().replaceAll("-", "").substring(0, 8);
			rsmCareerVO.setCareerJncmpYmd(careerJncmpYmd);
		}
		if(rsmCareerVO.getCareerRetireYmd().length() > 6) {
			String careerRetireYmd = rsmCareerVO.getCareerRetireYmd().replaceAll("-", "").substring(0, 8);
			rsmCareerVO.setCareerRetireYmd(careerRetireYmd);;
		}
		
		if(careerNo==null || careerNo.equals("")){
			memResumeMapper.insertCareer(rsmCareerVO);
		}else {
			memResumeMapper.updateCareer(rsmCareerVO);
			
		}
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("rsmNo", rsmNo);
		map.put("mbrId", getUserUtil.getMemVO().getMbrId());
		List<RsmCareerVO> rsmVO = memResumeMapper.selectCareerList(map);
		return rsmVO;
	}
	// 경력 삭제
	@Override
	public List<RsmCareerVO> careerDeletePost(RsmCareerVO rsmCareerVO) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("rsmNo", rsmCareerVO.getRsmNo());
		map.put("careerNo", rsmCareerVO.getCareerNo());
		memResumeMapper.deleteCareer(map);
		map.put("mbrId", getUserUtil.getMemVO().getMbrId());
		List<RsmCareerVO> rsmVO = memResumeMapper.selectCareerList(map);
		return rsmVO;
	}
	// 스킬 갱신
	@Override
	public List<RsmSkillVO> skillRegistPost(RsmSkillVO rsmSkillVO) {
		String rsmNo = rsmSkillVO.getRsmNo();
		String skCd = rsmSkillVO.getSkCd();
		String[] skCdArr = skCd.split(",");
		
		memResumeMapper.deleteSkill(rsmNo);
		
		for(int i = 0; i < skCdArr.length; i++) {
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("rsmNo", rsmNo);
			map.put("skCd", skCdArr[i]);
			log.info("skCdArr : " + skCdArr[i]);
			log.info("map skCd : " + map.get("skCd"));
			memResumeMapper.insertSkill(map);
		}
		
		Map<String, Object> map2 = new HashMap<String, Object>();
		map2.put("rsmNo", rsmNo);
		map2.put("mbrId", getUserUtil.getMemVO().getMbrId());
		List<RsmSkillVO> rsmVO = memResumeMapper.selectSkillList(map2);
		return rsmVO;
	}
	// 경험 갱신
	@Override
	public List<RsmExpactEDCVO> actRegistPost(RsmExpactEDCVO rsmExpactEDCVO) {
		String rsmNo = rsmExpactEDCVO.getRsmNo();
		String actNo = rsmExpactEDCVO.getActNo().trim();
		if(rsmExpactEDCVO.getActBeginYmd().length()> 6) {
			String beginYmd =  rsmExpactEDCVO.getActBeginYmd().replaceAll("-", "").substring(0, 8);
			rsmExpactEDCVO.setActBeginYmd(beginYmd);
		}
		if(rsmExpactEDCVO.getActEndYmd().length() > 6) {
			String actEndYmd = rsmExpactEDCVO.getActEndYmd().replaceAll("-", "").substring(0, 8);
			rsmExpactEDCVO.setActEndYmd(actEndYmd);
		}
		
		if(actNo==null || actNo.equals("")){
			memResumeMapper.insertAct(rsmExpactEDCVO);
		}else {
			memResumeMapper.updateAct(rsmExpactEDCVO);
			
		}
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("rsmNo", rsmNo);
		map.put("mbrId", getUserUtil.getMemVO().getMbrId());
		List<RsmExpactEDCVO> rsmVO = memResumeMapper.selectActList(map);
		return rsmVO;
	}
	// 경험 삭제
	@Override
	public List<RsmExpactEDCVO> actDeletePost(RsmExpactEDCVO rsmExpactEDCVO) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("rsmNo", rsmExpactEDCVO.getRsmNo());
		map.put("actNo", rsmExpactEDCVO.getActNo());
		memResumeMapper.deleteAct(map);
		map.put("mbrId", getUserUtil.getMemVO().getMbrId());
		List<RsmExpactEDCVO> rsmVO = memResumeMapper.selectActList(map);
		return rsmVO;
	}
	// 자격증 갱신
	@Override
	public List<RsmCertificateVO> crtfctRegistPost(RsmCertificateVO certificateVO) {
		String rsmNo = certificateVO.getRsmNo();
		String crtfctNo = certificateVO.getCrtfctNo().trim();
		if(certificateVO.getCrtfctAcqsYm().length()> 5) {
			String crtfctAcqsYm =  certificateVO.getCrtfctAcqsYm().replaceAll("-", "").substring(0, 6);
			certificateVO.setCrtfctAcqsYm(crtfctAcqsYm);
		}
		
		if(crtfctNo==null || crtfctNo.equals("")){
			memResumeMapper.insertCrtfct(certificateVO);
		}else {
			memResumeMapper.updateCrtfct(certificateVO);
			
		}
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("rsmNo", rsmNo);
		map.put("mbrId", getUserUtil.getMemVO().getMbrId());
		List<RsmCertificateVO> rsmVO = memResumeMapper.selectCrtfctList(map);
		return rsmVO;
	}
	// 자격증 삭제
	@Override
	public List<RsmCertificateVO> crtfctDeletePost(RsmCertificateVO certificateVO) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("rsmNo", certificateVO.getRsmNo());
		map.put("crtfctNo", certificateVO.getCrtfctNo());
		memResumeMapper.deleteCrtfct(map);
		map.put("mbrId", getUserUtil.getMemVO().getMbrId());
		
		List<RsmCertificateVO> rsmVO = memResumeMapper.selectCrtfctList(map);
		return rsmVO;
	}
	// 포트폴리오 갱신
	@Override
	public List<RsmPortfolioVO> prtRegistPost(RsmPortfolioVO rsmPortfolioVO) {
		String rsmNo = rsmPortfolioVO.getRsmNo();
		String prtNo = rsmPortfolioVO.getPrtNo().trim();
		MultipartFile[] multipartFiles = rsmPortfolioVO.getUploadFile();
		RsmPortfolioVO prtVO = null;
		if(prtNo.length() > 0) {
			Map<String, Object> map2 = new HashMap<String, Object>();
			map2.put("rsmNo", rsmNo);
			map2.put("prtNo", prtNo);
			map2.put("mbrId", getUserUtil.getMemVO().getMbrId());
			prtVO = memResumeMapper.selectOnePrt(map2);
		}
		
		if(prtNo==null || prtNo.equals("")){
			if (multipartFiles == null || multipartFiles.length == 0 || multipartFiles[0].isEmpty()) {
				rsmPortfolioVO.setPrtFile(null); // fileGroupNo의 값을 세팅
			} else {
				String fileGroupSn = this.uploadController.multiImageUpload(multipartFiles, "/resume/prtFile");
				rsmPortfolioVO.setPrtFile(fileGroupSn); // fileGroupNo의 값을 세팅
			}
			memResumeMapper.insertPrt(rsmPortfolioVO);
		}else {
			if (multipartFiles == null || multipartFiles.length == 0 || multipartFiles[0].isEmpty()) {
				rsmPortfolioVO.setPrtFile(prtVO.getPrtFile()); // fileGroupNo의 값을 세팅
			} else {
				// 새로운 파일 업로드 처리
				String fileGroupSn = this.uploadController.multiImageUpload(multipartFiles, "/resume/prtFile");
				log.info("mainFile->fileGroupSn : " + fileGroupSn);
				rsmPortfolioVO.setPrtFile(fileGroupSn); // fileGroupNo의 값을 세팅
			}
			memResumeMapper.updatePrt(rsmPortfolioVO);
			
		}
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("rsmNo", rsmPortfolioVO.getRsmNo());
		List<RsmPortfolioVO> rsmVO = memResumeMapper.selectPrtList(map);
		return rsmVO;
	}
	// 포트폴리오 삭제
	@Override
	public List<RsmPortfolioVO> prtDeletePost(RsmPortfolioVO rsmPortfolioVO) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("rsmNo", rsmPortfolioVO.getRsmNo());
		map.put("prtNo", rsmPortfolioVO.getPrtNo());
		memResumeMapper.deletePrt(map);
		List<RsmPortfolioVO> rsmVO = memResumeMapper.selectPrtList(map);
		return rsmVO;
	}
	// 이력서 자기소개서 갱신
	@Override
	public List<RsmClVO> CLRegistPost(RsmClVO rsmClVO) {
		String rsmNo = rsmClVO.getRsmNo();
		String clNo = rsmClVO.getClNo().trim();
		
		if(clNo==null || clNo.equals("")){
			memResumeMapper.insertCL(rsmClVO);
		}else {
			memResumeMapper.updateCL(rsmClVO);
			
		}
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("rsmNo", rsmNo);
		map.put("mbrId", getUserUtil.getMemVO().getMbrId());
		List<RsmClVO> rsmVO = memResumeMapper.selectCLList(map);
		return rsmVO;
	}
	// 이력서 자기소개서 삭제
	@Override
	public List<RsmClVO> CLDeletePost(RsmClVO rsmClVO) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("rsmNo", rsmClVO.getRsmNo());
		map.put("clNo", rsmClVO.getClNo());
		memResumeMapper.deleteCL(map);
		map.put("mbrId", getUserUtil.getMemVO().getMbrId());
		
		List<RsmClVO> rsmVO = memResumeMapper.selectCLList(map);
		return rsmVO;
	}
	// 이력서 제목 저장
	@Override
	public ResumeVO lastSavePost(ResumeVO resumeVO) {
		memResumeMapper.insertRsmTtl(resumeVO);
		return resumeVO;
	}

	// 이력서 복사
	@Override
	public Map<String, Object> copyResume(Map<String, Object> map) {
		Map<String, Object> VOList = new HashMap<String, Object>();
		
		ResumeVO resumeVO = memResumeMapper.selectOneResume(map);
		List<RsmAcademicVO> rsmAcademicVOList = memResumeMapper.selectAcdgList(map);
		List<RsmCareerVO> rsmCareerVOList = memResumeMapper.selectCareerList(map);
		List<RsmSkillVO> rsmSkillVOList = memResumeMapper.selectSkillList(map);
		List<RsmExpactEDCVO> rsmExpactEDCVOList = memResumeMapper.selectActList(map);
		List<RsmCertificateVO> rsmCertificateVOList = memResumeMapper.selectCrtfctList(map);
		List<RsmClVO> rsmClVOList = memResumeMapper.selectCLList(map);
		List<RsmPortfolioVO> rsmPrtVOList = memResumeMapper.selectPrtList(map);
		
		memResumeMapper.insertResumebasInfo(resumeVO);
		for(RsmAcademicVO VO : rsmAcademicVOList) {
			VO.setRsmNo(resumeVO.getRsmNo());
			memResumeMapper.insertAcdg(VO);
		}
		for(RsmCareerVO VO : rsmCareerVOList) {
			VO.setRsmNo(resumeVO.getRsmNo());
			memResumeMapper.insertCareer(VO);
		}
		for(RsmSkillVO VO : rsmSkillVOList) {
			VO.setRsmNo(resumeVO.getRsmNo());
			memResumeMapper.insertSkill2(VO);
		}
		for(RsmExpactEDCVO VO : rsmExpactEDCVOList) {
			VO.setRsmNo(resumeVO.getRsmNo());
			memResumeMapper.insertAct(VO);
		}
		for(RsmCertificateVO VO : rsmCertificateVOList) {
			VO.setRsmNo(resumeVO.getRsmNo());
			memResumeMapper.insertCrtfct(VO);
		}	
		for(RsmClVO VO : rsmClVOList) {
			VO.setRsmNo(resumeVO.getRsmNo());
			memResumeMapper.insertCL(VO);
		}
		for(RsmPortfolioVO VO : rsmPrtVOList) {
			VO.setRsmNo(resumeVO.getRsmNo());
			memResumeMapper.insertPrt(VO);
		}
		VOList.put("resumeVO", resumeVO);
		VOList.put("rsmAcademicVOList", rsmAcademicVOList);
		VOList.put("rsmCareerVOList", rsmCareerVOList);
		VOList.put("rsmSkillVOList", rsmSkillVOList);
		VOList.put("rsmExpactEDCVOList", rsmExpactEDCVOList);
		VOList.put("rsmCertificateVOList", rsmCertificateVOList);
		VOList.put("rsmClVOList", rsmClVOList);
		VOList.put("rsmPrtVOList", rsmPrtVOList);
		
		return VOList;
	}
	//	이력서 삭제
	@Override
	public int deleteResume(Map<String, Object> map) {
		int result = memResumeMapper.deleteResume(map);
		return result;
	}
	// 대표 이력서 설정
	@Override
	public void updateResumeRere(Map<String, Object> map) {
		int cnt = memResumeMapper.selectRERE(map);
		if(cnt <= 1) {
			memResumeMapper.updateResumeRere(map);
		}
	}
	// 대표 이력서 갯수 확인
	@Override
	public void updateResumeRere2(Map<String, Object> map) {
		memResumeMapper.updateResumeRere2(map);
	}
	// 자기소개서 작성
	@Override
	public int coverRegistPost(CoverLetterSaveVO coverVO) {
		String clStrgNo = coverVO.getClStrgNo();
		int result = 0;
		if(clStrgNo.isEmpty()) {
			result = memCoverLetterMapper.insertCoverLetter(coverVO);
		}else {
			result = memCoverLetterMapper.updateCoverLetter(coverVO);
		}
		
		return result;
	}
	// 자기소개서 삭제
	@Override
	public int coverDeletePost(CoverLetterSaveVO coverVO) {
		Map<String, Object> map = new HashMap<String, Object>();
		String mbrId = getUserUtil.getLoggedInUserId();
		String clStrgNo = coverVO.getClStrgNo();
		map.put("clStrgNo", clStrgNo);
		map.put("mbrId", mbrId);
		int result = memCoverLetterMapper.deleteCoverLetter(map);
		return result;
	}

}
