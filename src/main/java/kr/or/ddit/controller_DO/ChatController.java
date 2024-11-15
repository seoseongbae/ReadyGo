package kr.or.ddit.controller_DO;

import java.util.Collections;
import java.util.List;

import javax.inject.Inject;

import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.or.ddit.service_DO.ChatService;
import kr.or.ddit.vo.ChatMsgVO;
import kr.or.ddit.vo.ChatRoomVO;
import lombok.extern.slf4j.Slf4j;

@Controller
@RequestMapping("/chat")
@Slf4j
public class ChatController {
	
	@Inject
	ChatService chatService;
	
	//지금 테스트하는 채팅방
	@GetMapping("/socket")
	public String socket() {
		
		return "adm/socket";
	}
	//지금 테스트하는 채팅방
	@GetMapping("/memChatList")
	public String memChatList(Model model) {
        // 로그인한 사용자 ID 가져오기
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        String mbrId = authentication.getName();
        
        // 서비스에서 사용자 ID로 채팅방 목록 조회
        List<ChatRoomVO> chatRoomList = chatService.memFindChatRoom(mbrId);
        
        // 조회한 채팅방 목록을 모델에 추가
        model.addAttribute("chatRoomList", chatRoomList);
        
		return "member/mypage/memChatList";
	}
	
	//채팅방 생성
	@PostMapping("/createChatRoom")
	@ResponseBody
	public String createChatRoom(@RequestParam String senderUser, @RequestParam String receiveUser) {
	    try {
	        chatService.createChatRoom(senderUser, receiveUser); // 채팅방 생성 서비스 호출
	        log.info("생성했다!");
	        return "success";
	    } catch (Exception e) {
	        return "fail";
	    }
	}

	//채팅기록가져오기
	@GetMapping("/getChatRoom")
	@ResponseBody
	public ResponseEntity<List<ChatMsgVO>> getChatRoom(@RequestParam String roomNo) {
	    // 로그인한 사용자 ID 가져오기
	    Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
	    String mbrId = authentication.getName();
	    // 채팅방 정보를 가져옴 (채팅 기록이 없을 수도 있음)
	    List<ChatMsgVO> chatMessages = chatService.memChatHistory(roomNo);

	    // 채팅 기록이 없을 경우 빈 리스트 반환
	    if (chatMessages.isEmpty()) {
	        return ResponseEntity.ok(Collections.emptyList());  // 빈 리스트 반환
	    }

	    return ResponseEntity.ok(chatMessages);  // JSON으로 반환
	}

	@PostMapping("/updateReadStatus")
	@ResponseBody
	public String updateReadStatus(@RequestParam String roomNo) {
	    // 로그인한 사용자 ID 가져오기
	    Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
	    String mbrId = authentication.getName();
	    
	    // 읽음 처리 로직 호출
	    chatService.readYn(roomNo, mbrId);
	    
	    return "success";
	}
	
	//모달닫았을때 ajax로 가져오기
	@GetMapping("/getChatList")
	@ResponseBody
	public List<ChatRoomVO> getChatList(Authentication authentication) {
	    String mbrId = authentication.getName(); // 현재 로그인한 사용자 ID
	    return chatService.memFindChatRoom(mbrId); // 서비스에서 채팅방 목록 조회
	}
	
	//채팅방 나가기
	@PostMapping("/byeChat")
	@ResponseBody
	public String byeChat(@RequestParam String roomNo, 
	                      @RequestParam String senderUser, 
	                      @RequestParam String receiveUser) {
	    // 로그인한 사용자 ID 가져오기
	    Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
	    String mbrId = authentication.getName();
	    
	    chatService.byeChat(roomNo, mbrId, senderUser, receiveUser);
	    
	    return "success";
	}

}
