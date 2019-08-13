package egovframework.example.admin.statics.web;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import egovframework.example.admin.statics.service.StaticsService;
import egovframework.rte.psl.dataaccess.util.EgovMap;
/**
 * @Class Name : staticsController.java
 * @Description : 통계 컨트롤러
 * @Modification Information
 * @
 * @  수정일      수정자              수정내용
 * @ ---------   ---------   -------------------------------
 * @ 19.05.22           최초생성
 *
 * @author 전예지
 * @since 2019. 05. 22
 * @version 1.0
 * @see
 *
 *  Copyright (C) All right reserved.
 */
@Controller
public class StaticsController {

	/** StaticsService */
	@Resource
	private StaticsService staticsService;
	
	/**
	 * 통계화면을 조회한다.
	 * 통계정보를 가져와 model에 내린다.
	 * @param model
	 * @return "admin/statics/statics" - 통계화면
	 * @exception Exception
	 */
	@RequestMapping(value="/admin/statics.do")
	public String statics(ModelMap model) throws Exception {
		
		try {
			
			// 통계 정보 
			// 회원수,정상회원수,만료회원수,임박회원수,트레이너수
			EgovMap staticMap = staticsService.selectStaticsMapService();
			model.addAttribute("staticMap",staticMap);
			
		} catch(Exception e) {
			
			model.addAttribute("erroMsg","통계정보를 불러 오지 못했습니다.");
		}
		
		// 레프트 메뉴 active 하기위해
		model.addAttribute("paraMap","statics");
		
		return "admin/statics/statics";
	}
}
