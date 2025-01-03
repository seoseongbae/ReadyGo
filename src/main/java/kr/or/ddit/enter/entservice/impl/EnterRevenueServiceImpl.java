package kr.or.ddit.enter.entservice.impl;

import java.util.List;

import javax.inject.Inject;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.or.ddit.mapper.EnterRevenueMapper;
import kr.or.ddit.enter.entservice.*;
import kr.or.ddit.vo.EnterEmpYcntVO;
import kr.or.ddit.vo.EnterRevenueVO;

@Transactional
@Service
public class EnterRevenueServiceImpl implements EnterRevenueService {

	@Inject
	EnterRevenueMapper enterRevenueMapper;
	
	@Override
	public List<EnterRevenueVO> revenue(String entId) {
		return this.enterRevenueMapper.revenue(entId);
	}

	@Override
	public int insertRevenues(List<EnterRevenueVO> revenues) {
		int result = 0;
		for (EnterRevenueVO enterRevenueVO : revenues) {
			result += this.enterRevenueMapper.insertRevenues(enterRevenueVO);
		}
		return result;
		
	}

	@Override
	public int updateRevenues(List<EnterRevenueVO> revenues) {
		int result = 0;
		for (EnterRevenueVO enterRevenueVO : revenues) {
			result += this.enterRevenueMapper.updateRevenues(enterRevenueVO);
		}
		return result;
	}

	@Override
	public int updateYcnt(List<EnterEmpYcntVO> ycnt) {
		int result = 0;
		for (EnterEmpYcntVO enterEmpYcntVO : ycnt) {
			result += this.enterRevenueMapper.updateYcnt(enterEmpYcntVO);
		}
		return result;
	}

	@Override
	public int insertYcnt(List<EnterEmpYcntVO> ycnt) {
		int result = 0;
		for (EnterEmpYcntVO enterEmpYcntVO : ycnt) {
			result += this.enterRevenueMapper.insertYcnt(enterEmpYcntVO);
		}
		return result;
	}



}
