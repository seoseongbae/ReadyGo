package kr.or.ddit.reflection;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
@RequestMapping("/common")
public class CodingTestController {
	@GetMapping("/coding")
	public String coding() {
		return "common/CodingTest/coding";
	}
}
