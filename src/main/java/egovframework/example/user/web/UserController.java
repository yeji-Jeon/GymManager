package egovframework.example.user.web;

import java.util.HashMap;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import egovframework.example.admin.member.service.MemberService;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @Class Name : UserController.java
 * @Description : 사용자 화면에 사용자정보 컨트롤러
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
public class UserController {

	/** MemberService */
	@Resource
	private MemberService memberService;
	
	/**
	 * 회원 상세정보를 조회한다. 
	 * @param paramMap - 조회할 조건정보가 담긴 paramMap
	 * @param model
	 * @return "admin/member/memberList" - 회원목록페이지
	 * @exception Exception
	 */
	@RequestMapping(value="/user/userPage.do")
	public String memberList(HttpServletRequest request
			,@RequestParam HashMap<String,String> paramMap
			,RedirectAttributes attributes ,ModelMap model) throws Exception {
		
		String returnVal = "user/userInfo";
		
		try {
			// 출석체크한 회원ID를 뽑는다.
			String mbr_Id = request.getParameter("rowMbrId");
			// 회원정보(EgovMap) + 사물함 정보들(List<EgovMap>)
			EgovMap memberInfo = memberService.selectMemberInfo(mbr_Id);
			model.addAttribute("memberInfo",memberInfo);
			
			// 배정된 일정관리 게시판의 페이징 번호
			// 페이지가 처음 뜰 때 디폴트 값을 넣어줌
			if(!paramMap.containsKey("pageNum")) {
				paramMap.put("pageNum", "1");
			}
			
			// 배정된 일정관리 정보들
			EgovMap scheduleLists = memberService.selectMemberScheduleList(paramMap);
			model.addAttribute("scheduleLists",scheduleLists);
			
		} catch(Exception e) {
			// 에러결과 메세지
			paramMap.put("errorMsg", "회원의 상세를 조회하지 못했습니다.");
			// 리다이렉트 paramMap 바인딩
			attributes.addFlashAttribute("paramMap",paramMap);
			// 회원목록으로 돌아가기
			returnVal = "redirect:/user/logIn.do";
		}
		
		return returnVal;
	}
}
