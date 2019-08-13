package egovframework.example.admin.main.web;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 * @Class Name : MainController.java
 * @Description : 메인페이지 컨트롤러
 * @Modification Information
 * @
 * @  수정일      수정자              수정내용
 * @ ---------   ---------   -------------------------------
 * @ 19.05.23           최초생성
 *
 * @author 전예지
 * @since 2019. 05. 23
 * @version 1.0
 * @see
 *
 *  Copyright (C) All right reserved.
 */

@Controller
public class MainController {

	/**
	 * 메인페이지 화면
	 * @return 메인화면 jsp
	 * @throws Exception
	 */
	@RequestMapping(value="admin/main.do")
	public String Main() throws Exception {
		return "admin/main/main";
	}
}
