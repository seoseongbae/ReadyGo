package kr.or.ddit.controller_DO;

import java.security.Principal;
import java.util.List;

import javax.inject.Inject;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import kr.or.ddit.mapper.NotificationMapper;
import kr.or.ddit.service_DO.NotificationService;
import kr.or.ddit.util.GetUserUtil;
import kr.or.ddit.vo.NotificationVO;
import lombok.extern.slf4j.Slf4j;

@RequestMapping("/notification")
@RestController 
@Slf4j
public class socketController {

	@Inject
	NotificationService notificationService;
	
	@Inject
	NotificationMapper notificationMapper;
	
	@Inject
	GetUserUtil getUserUtil;
//	@GetMapping("/socket")
//	public String socket() {
//        // 로그인한 사용자 ID 가져오기
//        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
//        String mbrId = authentication.getName();
//		return "adm/socket";
//	}
	@ResponseBody
    @GetMapping("/list")
    public List<NotificationVO> getNotificationList() {
        // 현재 로그인된 사용자 정보 가져오기
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        String loggedInUser = authentication.getName();

        // 알림 목록 조회
        List<NotificationVO> alramList = notificationService.alramList(loggedInUser);
        return alramList;
    }
    
	@ResponseBody
	@GetMapping("/getAlramCnt")
	public int getAlramCnt(Principal principal) {
		String userId = getUserUtil.getLoggedInUserId();
		int cnt = this.notificationMapper.getAlramCnt(userId);
		return cnt;
	}
	
    @PostMapping("/alramDel")
    @ResponseBody
    public String deleteNotification(@RequestParam("ntcnNo") String ntcnNo) {
        int result = 0;
        try {
            // 알림 상태 업데이트
            result = notificationService.alramDel(ntcnNo);
        } catch (Exception e) {
            return "fail";
        }
        // 성공 여부에 따라 반환
        return result > 0 ? "success" : "fail";
    }
    @PostMapping("/alramLinkClick")
    @ResponseBody
    public String alramLinkClick(@RequestParam("ntcnNo") String ntcnNo) {
    	int result = 0;
    	try {
    		// 알림 상태 업데이트
    		result = notificationService.alramLinkClick(ntcnNo);
    	} catch (Exception e) {
    		return "fail";
    	}
    	// 성공 여부에 따라 반환
    	return result > 0 ? "success" : "fail";
    }
    @PostMapping("/selectAlramAllDel")
    @ResponseBody
    public String selectAlramAllDel(@RequestBody List<String> alramIds) {
        int result = 0;
        try {
            // 알림 상태 업데이트
            result = notificationService.selectAlramAllDel(alramIds);
        } catch (Exception e) {
            return "fail";
        }
        // 성공 여부에 따라 반환
        return result > 0 ? "success" : "fail";
    }


    @PostMapping("/alramMemAllDel")
    @ResponseBody
    public String alramMemAllDel() {
        try {
            // 현재 로그인한 사용자 ID 가져오기
            Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
            String commonId = authentication.getName();  // 로그인한 사용자 ID

            // 알림 전체 삭제 서비스 호출
            int result = notificationService.alramAllDel(commonId);
            
            // 삭제 성공 여부 반환
            return result > 0 ? "success" : "fail";
        } catch (Exception e) {
            e.printStackTrace();
            return "error";
        }
    }
    @PostMapping("/alramRealAllDel")
    @ResponseBody
    public String alramRealAllDel() {
    	try {
    		// 현재 로그인한 사용자 ID 가져오기
    		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
    		String commonId = authentication.getName();  // 로그인한 사용자 ID
    		
    		// 알림 전체 삭제 서비스 호출
    		int result = notificationService.alramRealAllDel(commonId);
    		
    		// 삭제 성공 여부 반환
    		return result > 0 ? "success" : "fail";
    	} catch (Exception e) {
    		e.printStackTrace();
    		return "error";
    	}
    }
    @PostMapping("/alramAllDel")
    @ResponseBody
    public String alramAllDel() {
        try {
            // 현재 로그인한 사용자 ID 가져오기
            Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
            String commonId = authentication.getName();  // 로그인한 사용자 ID

            // 서비스 또는 매퍼에서 삭제 로직 실행
            int result = notificationService.alramAllDel(commonId); // 서비스 호출
            
            return result > 0 ? "success" : "fail";  // 삼항 연산자 사용
        } catch (Exception e) {
            e.printStackTrace();
            return "error";  // 예외 발생 시 처리
        }
    }


}
