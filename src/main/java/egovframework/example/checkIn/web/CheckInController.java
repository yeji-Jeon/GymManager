package egovframework.example.checkIn.web;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import egovframework.example.checkIn.service.CheckInService;

/**
 * @Class Name : CheckInController.java
 * @Description : 출석체크 페이지에 관련 된 컨트롤러
 * @Modification Information
 * @
 * @  수정일      수정자              수정내용
 * @ ---------   ---------   -------------------------------
 * @ 19.05.21           최초생성
 * @ 19.05.23           출석체크 회원 확인 
 *
 * @author 전예지
 * @since 2019. 05. 21
 * @version 1.0
 * @see
 *
 *  Copyright (C) All right reserved.
 */

@Controller
public class CheckInController {

	/* CheckInService */
	@Resource
	private CheckInService checkInService;
	
	/**
	 * 출석체크 페이지를 조회한다. 
	 * @return "checkIn/checkIn";
	 * @exception Exception
	 */
	@RequestMapping(value="yejiHealth.do")
	public String checkIn() throws Exception {
		return "checkIn/checkIn";
	}
	
	/**
	 * 회원ID를 조회한다. 
	 * @param mbrId 조회할 회원ID
	 * @return 회원존재여부결과 
	 * @exception Exception
	 */
	@RequestMapping(value="mbrChk.do", method=RequestMethod.POST)
	@ResponseBody
	public String mbrChk(HttpServletRequest request) throws Exception {
		
		// 확인할 회원ID
		String mbrId = request.getParameter("mbrId");
		// 리턴할 결과값을 담은 변수 선언
		String result ="";
		
		try {
			// 회원존재여부
			result = checkInService.selectChcekInMbrService(mbrId);
			
		} catch(Exception e) {
			
			// 회원 조회 실패
			result = "fail";
		}
		
		return result;
	}
}
