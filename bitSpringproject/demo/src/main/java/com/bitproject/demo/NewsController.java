package com.bitproject.demo;

import java.util.HashMap;
import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
public class NewsController {

	@RequestMapping("/")
	public @ResponseBody Map<String, Object> show() {
		Map<String, Object> map = new HashMap<> ();
		map.put("title", "뉴욕증시 안도 랠리···S&P500 이틀째 최고치 마감");
		map.put("content", "나스닥 4주연속 상승세·S&P도 3주째 올라\r\n"
				+ "존슨앤드존슨 백신 폐기로 1%이상 떨어져\r\n"
				+ "맥도날드는 고객정보 유출에도 1%대 상승");
		map.put("category", "STOCK");
		return map;
	}
}