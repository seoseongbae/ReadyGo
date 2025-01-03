package kr.or.ddit.impl_DO;

import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.springframework.stereotype.Service;

import kr.or.ddit.mapper.NotificationMapper;
import kr.or.ddit.service_DO.NotificationService;
import kr.or.ddit.vo.NotificationVO;

@Service
public class NotificationServiceImpl implements NotificationService {

	@Inject
	NotificationMapper notificationMapper;
	
	@Override
	public void sendAlram(NotificationVO notificationVO) {
		this.notificationMapper.sendAlram(notificationVO);
	}

	@Override
	public List<NotificationVO> alramList(String loggedInUser) {
		return this.notificationMapper.alramList(loggedInUser);
	}

	@Override
	public int alramDel(String ntcnNo) {
		return this.notificationMapper.alramDel(ntcnNo);
	}

	@Override
	public int alramAllDel(String commonId) {
		// TODO Auto-generated method stub
		return this.notificationMapper.alramAllDel(commonId);
	}

	@Override
	public int alramTotal(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return this.notificationMapper.alramTotal(map);
	}

	@Override
	public List<NotificationVO> memAlramList(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return this.notificationMapper.memAlramList(map);
	}

	@Override
	public int selectAlramAllDel(List<String> ntcnNoList) {
		// TODO Auto-generated method stub
		return this.notificationMapper.selectAlramAllDel(ntcnNoList);
	}

	@Override
	public int alramRealAllDel(String commonId) {
		// TODO Auto-generated method stub
		return this.notificationMapper.alramRealAllDel(commonId);
	}

	@Override
	public int alramLinkClick(String ntcnNo) {
		// TODO Auto-generated method stub
		return this.notificationMapper.alramLinkClick(ntcnNo);
	}


}
