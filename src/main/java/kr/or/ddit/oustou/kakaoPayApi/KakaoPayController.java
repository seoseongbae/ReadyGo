package kr.or.ddit.oustou.kakaoPayApi;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.Map;

import javax.inject.Inject;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.or.ddit.oustou.service.OutsouService;
import kr.or.ddit.security.SocketHandler;
import kr.or.ddit.service_DO.NotificationService;
import kr.or.ddit.vo.NotificationVO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequiredArgsConstructor
@RequestMapping("/outsou")
public class KakaoPayController {

//	@Autowired
//	KakaoPayService kakaoPayService;
	
	private final KakaoPayService kakaoPayService;
	@Inject
	NotificationService notificationService;
	
    @Autowired
    private SocketHandler socketHandler;
	@Inject
	OutsouService outsouService;
	@PostMapping("/pay/ready")
	public @ResponseBody ReadyResponse payReady(@RequestBody Map<String, Object> data) {
		
		 // 이미 결제가 진행된 상태인지 확인하는 로직 추가
	    String outordNo = (String) data.get("outordNo");
	    if (SessionUtils.getAttribute("payment_done") != null && (boolean) SessionUtils.getAttribute("payment_done")) {
	        throw new IllegalStateException("중복 결제 시도입니다.");
	    }
	    
	    // 결제 준비 처리 로직
		String title = (String) data.get("title");
	    int price = Integer.parseInt(data.get("price").toString());
	    String mbrId = (String) data.get("mbrId");  // partner_user_id로 사용
	    String setleMn = (String) data.get("setleMn");

	    log.info("상품 제목 :" + title);
	    log.info("상품 가격 :" + price);
	    log.info("외주 번호 :" + outordNo);
	    log.info("회원 아이디 :" + mbrId);
	    log.info("결제수단 :" + setleMn);

	    // 결제 준비 로직 호출
	    ReadyResponse readyResponse = kakaoPayService.payReady(title, price, mbrId, outordNo, setleMn);
	    log.info("결제 준비 완료, 결제 고유번호(tid): " + readyResponse.getTid()); // 이 로그가 제대로 출력되는지 확인
        
	 // 결제 준비 완료 시 세션에 결제 진행 중 상태 저장
	    SessionUtils.addAttribute("tid", readyResponse.getTid());
	    SessionUtils.addAttribute("payment_in_progress", true);
	    
	    
//	   // 결제 정보를 세션에 저장
	    String tid = readyResponse.getTid();
	    SessionUtils.addAttribute("tid", tid);
	    SessionUtils.addAttribute("price", price);
	    SessionUtils.addAttribute("outordNo", outordNo);
	    SessionUtils.addAttribute("partner_user_id", mbrId);
	    SessionUtils.addAttribute("setleMn", setleMn);
	    SessionUtils.addAttribute("title", title);
        
	    // `tid` 값은 이미 서비스에서 처리되었음
	    log.info("결제 준비 완료, 결제 고유번호(tid): " + readyResponse.getTid());

        return readyResponse;
    }

	
	//결제 승인 처리
    @GetMapping("/payok")
    public String payCompleted(@RequestParam("pg_token") String pgToken,  Model model) {
        // 세션 또는 DB에서 저장된 tid 가져오기
        String tid = (String) SessionUtils.getAttribute("tid"); // 세션이나 DB에 저장된 `tid`를 사용
        String mbrId = (String) SessionUtils.getAttribute("partner_user_id"); // 저장된 사용자 정보
        String outordNo = (String) SessionUtils.getAttribute("outordNo");
        String setleMn = (String) SessionUtils.getAttribute("setleMn");
        int price = (Integer) SessionUtils.getAttribute("price");
        String title = (String) SessionUtils.getAttribute("title");

        log.info("Received pg_token: " + pgToken);
        log.info("Stored tid: " + tid);
        log.info("titled: " + title);
        
        
     // 결제 상태 확인
        if (tid == null || tid.isEmpty()) {
            log.error("세션에서 tid를 찾을 수 없습니다.");
            return "redirect:/error-page";
        }



        log.info("pg_token: " + pgToken);
        log.info("tid: " + tid);

        // 카카오 결제 승인 요청
        AproveResponse aproveResponse = kakaoPayService.payApprove(tid, pgToken, mbrId, outordNo, setleMn, price);
        
	    //판매자알림!!
        //판매자알림!!
        // WebSocket 메시지 포맷
        String websocketMessage = String.format("%s상품이 %s님이 구매하셨습니다!",title, mbrId); // 제목은 적절하게 가져와서 사용
        //판매자 id가져오기
        String Writer = this.outsouService.Writer(outordNo);
        // 현재 URL
        String currentUrl = "/outsou/paydetail?outordNo=" + outordNo;
        // WebSocket 세션 체크 후 메시지 전송
        log.info("현재 등록된 세션 목록: " + socketHandler.getUserSessionsMap().keySet());

        if (socketHandler.getUserSessionsMap().containsKey(Writer)) {
            socketHandler.sendMessageToUser(Writer, websocketMessage);
        } else {
            log.warn("WebSocket 세션을 찾을 수 없음, 사용자: " + Writer);
            log.info("현재 등록된 세션 목록: " + socketHandler.getUserSessionsMap().keySet());
        }
        
        //알림 저장
        NotificationVO notificationVO = new NotificationVO();
        notificationVO.setCommonId(Writer); // 구매자 ID
        notificationVO.setNtcnCn(websocketMessage); // 알림 메시지 내용
        notificationVO.setNtcnUrl(currentUrl); // 알림과 연결된 URL

        this.notificationService.sendAlram(notificationVO);  // 알림 저장	
        //구매자알림!
        //구매자알림!
        //구매자알림!
        String websocketMessage2 = String.format("%s상품 구매를 확인하세요!",title); // 제목은 적절하게 가져와서 사용
        // 현재 URL
        String currentUrl2 = "/member/setleList?mbrId=";
        // WebSocket 세션 체크 후 메시지 전송
        log.info("현재 등록된 세션 목록: " + socketHandler.getUserSessionsMap().keySet());
        
        if (socketHandler.getUserSessionsMap().containsKey(mbrId)) {
        	socketHandler.sendMessageToUser(mbrId, websocketMessage2);
        } else {
        	log.warn("WebSocket 세션을 찾을 수 없음, 사용자: " + mbrId);
        	log.info("현재 등록된 세션 목록: " + socketHandler.getUserSessionsMap().keySet());
        }
        
        //알림 저장
        NotificationVO notificationVO2 = new NotificationVO();
        notificationVO2.setCommonId(mbrId); // 구매자 ID
        notificationVO2.setNtcnCn(websocketMessage2); // 알림 메시지 내용
        notificationVO2.setNtcnUrl(currentUrl2); // 알림과 연결된 URL
        
        this.notificationService.sendAlram(notificationVO2);  // 알림 저장	
        
        
        LocalDate today = LocalDate.now();
        DateTimeFormatter formatter  = DateTimeFormatter.ofPattern("yyyy. MM. dd");
        String formattedDate = today.format(formatter); // 날짜를 해당 형식으로 포맷
        
        model.addAttribute("tid", tid);  // 주문 번호
        model.addAttribute("formattedDate", formattedDate);  // 오늘 날짜
        model.addAttribute("title", title);  // 오늘 날짜
        
        // 결제 승인 완료 후 페이지로 리다이렉트
        return "redirect:/outsou/payokResult?mode=open";  // 성공 페이지로 리다이렉트
    }
    
    //결제 승인 처리
    @GetMapping("/payokResult")
    public String payokResult(String mode, Model model) {
        
    	String title = (String) SessionUtils.getAttribute("title");

        LocalDate today = LocalDate.now();
        DateTimeFormatter formatter  = DateTimeFormatter.ofPattern("yyyy. MM. dd");
        String formattedDate = today.format(formatter); // 날짜를 해당 형식으로 포맷

        log.info("mode : " + mode + ", title : " + title + ", formattedDate : " + formattedDate);
        
        model.addAttribute("formattedDate", formattedDate);  // 오늘 날짜
        model.addAttribute("title", title);  // 오늘 날짜
        
        // 결제 승인 완료 후 페이지로 리다이렉트
        return "outsou/regist/pay/payok";  // 성공 페이지로 리다이렉트
    }
	
}