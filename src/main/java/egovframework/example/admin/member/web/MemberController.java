package egovframework.example.admin.member.web;

import java.net.URLEncoder;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.springframework.web.servlet.support.RequestContextUtils;

import egovframework.example.admin.member.service.MemberService;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @Class Name : MemberController.java
 * @Description : 회원 crud 컨트롤러
 * @Modification Information
 * @
 * @  수정일      수정자              수정내용
 * @ ---------   ---------   -------------------------------
 * @ 19.05.17           최초생성
 *
 * @author 전예지
 * @since 2019. 05. 10
 * @version 1.0
 * @see
 *
 *  Copyright (C) All right reserved.
 */

@Controller
public class MemberController {

	/** MemberService */
	@Resource
	private MemberService memberService;
	
	/**
	 * 회원 목록을 조회한다. 
	 *  처음 회원목록을 조회하면 디폴트 설정값을 넣어준다.
	 *  회원 리스트와 회원페이징을 계산할 리스트를 model에 담는다
	 * @param paramMap - 조회할 조건정보가 담긴 paramMap
	 * @param model
	 * @return "admin/member/memberList" - 회원목록페이지
	 * @exception Exception
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="admin/member.do")
	public String memberList(HttpServletRequest request
			,@RequestParam HashMap<String,String> paramMap,
			ModelMap model) throws Exception {
		
		
		// 회원삭제,수정,등록 리다렉트 값 받기(post방식)
		Map<String, ?> redirectMap = RequestContextUtils.getInputFlashMap(request);
		
		// 처음조회가 아니고 회원삭제,수정,등록 후라면 검색조건 값 받기
		if(redirectMap != null) {
			paramMap = (HashMap<String, String>) redirectMap.get("paramMap");
		} else {
			// 처음 조회를 할 때 paramMap의 디폴트 조건 세팅
			if(paramMap.size() < 1) {
				paramMap.put("searchCon", "0");
				paramMap.put("searchText", "");
				paramMap.put("use_yn", "0");
				paramMap.put("status", "0");
				paramMap.put("rowCnt", "10");
				paramMap.put("currPage", "1");
				paramMap.put("startDate", "");
				paramMap.put("finishDate", "");
			}
		}
		
		try {
			
			// 검색 조건 
			model.addAttribute("paramMap", paramMap);
			
			// 회원 리스트들
			List<EgovMap> memberLists = memberService.selectMemberServiceList(paramMap);
			model.addAttribute("memberLists",memberLists);
			
			// 회원 리스트 갯수(페이징용)
			String memberListsCnt = memberService.selectMemberListCnt(paramMap);
			model.addAttribute("memberListsCnt",memberListsCnt);
			
		} catch(Exception e) {
			// 에러결과 바인딩
			paramMap.put("searcherrorMsg", "회원조회에 실패하였습니다.");
		}
		
		// 레프트메뉴 active를 위한 값
		paramMap.put("pageName","member");
		// 조회 검색조건을 보낸다
		model.addAttribute("paramMap", paramMap);
		
		return "admin/member/memberList";
	}
	
	/**
	 * 회원등록 화면을 조회한다.
	 * @return "admin/member/memberAdd"
	 */
	@RequestMapping(value="admin/memberAdd.do")
	public String memberAdd() throws Exception {
		return "admin/member/memberAdd";
	}
	
	/**
	 * 회원을 등록한다.
	 * @param cabId - 사물함번호들이 담긴 List
	 * @param cabStartDate - 사물함등록일들이 담긴 List
	 * @param cabFinishDate - 사물함 만료일들이 담긴 List
	 * @param paramMap - 등록할 회원정보와 회원목록 검색 조건이 담긴 hashmap
	 * @param attributes - 리다이렉션을 위함
	 * @return "redirect:/admin/member.do" - 회원목록 , 회원추가 결과값(request 바인딩)
	 * @exception Exception
	 */
	@RequestMapping(value="admin/memberRealAdd.do")
	public String memberRealAdd(@RequestParam(value="cabId",required=false) List<String> cabId
			,@RequestParam(value="cabStartDate",required=false) List<String> cabStartDate
			,@RequestParam(value="cabFinishDate",required=false) List<String> cabFinishDate
			,@RequestParam HashMap<String,String> paramMap
			,RedirectAttributes attributes) throws Exception {
		
		try {
			// 회원을 등록한다
			String result = memberService.insertMemberInfoServiceList(paramMap,cabId,cabStartDate,cabFinishDate);
			
			// 회원 추가 결과값(회원ID) 바인딩
			paramMap.put("successMsg", "회원ID " + result + "가 등록되었습니다.");
			
		} catch(Exception e) {
			// 에러결과 바인딩
			paramMap.put("errorMsg", "회원등록에 실패하였습니다.");
		}
		
		// 리다이렉트 paramMap 바인딩
		attributes.addFlashAttribute("paramMap",paramMap);
		
		return "redirect:/admin/member.do";
	}
	
	/**
	 * 회원 상세정보를 조회한다.
	 * 회원 상세페이지로 이동한다
	 * @param mbr_Id - 상세조회할 회원ID
	 * @param paramMap - 목록 조회조건 정보가 담긴 Hashmap
	 * @param model
	 * @param attributes
	 * memberInfo - 회원정보회원정보(EgovMap), 그 회원이 사용하는 사물함 정보(List<EgovMap>)
	 * scheduleLists - 배정된 PT일정과 그 일정의 갯수정보
	 * @return "admin/member/memberDetail" - 상세정보가 담긴 페이지
	 * @exception Exception
	 */
	@RequestMapping(value="admin/memberDatail.do")
	public String memberDatail(@RequestParam(value="rowMbrId",required=true) String mbr_Id
			,@RequestParam HashMap<String,String> paramMap
			,RedirectAttributes attributes ,ModelMap model) throws Exception {
		
		// 회원상세페이지 리턴
		String returnVal = "admin/member/memberDetail";
		
		try {
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
			returnVal = "redirect:/admin/member.do";
		}
		
		return returnVal;
	}
	
	/**
	 * 회원을 삭제한다.
	 * @param paramMap - 목록 조회조건 정보가 담긴 Hashmap
	 * @param chk_info - 삭제할 회원Id가 담긴 List
	 * @param attributes - 삭제할 회원Id가 담긴 List
	 * @return "redirect:/admin/member.do" - 회원목록
	 * @exception Exception
	 */
	@RequestMapping(value="admin/memberDelete.do")
	public String memberDelete(@RequestParam HashMap<String,String> paramMap
			,@RequestParam(value="chk_info",required=true) List<String> chk_info
			,RedirectAttributes attributes) throws Exception {
		
		try {
			// 회원 삭제
			memberService.deleteMember(chk_info);
			
			// 삭제성공메세지 바인딩
			paramMap.put("successMsg", "회원이 삭제 되었습니다.");
			
		} catch(Exception e) {
			// 에러 결과 바인딩
			paramMap.put("errorMsg", "회원정보를 삭제하지 못하였습니다.");
		}
		
		// 리다이렉트 paramMap 바인딩
		attributes.addFlashAttribute("paramMap",paramMap);
		
		return "redirect:/admin/member.do";
	}
	
	/**
	 * 회원 수정화면을 조회한다.
	 * 수정할 회원정보를 가져온다.
	 * @param mbr_Id - 수정할 회원id
	 * @param paramMap - 목록 조회조건 정보가 담긴 Hashmap
	 * @param attributes
	 * @param model
	 * memberInfo - 회원정보회원정보(EgovMap), 그 회원이 사용하는 사물함 정보(List<EgovMap>)
	 * @return "admin/member/memberUpdate"
	 * @exception Exception
	 */
	@RequestMapping(value="admin/memberUpdate.do")
	public String memberUpdate(@RequestParam HashMap<String,String> paramMap
			,@RequestParam(value="rowMbrId",required=true) String mbr_Id
			,RedirectAttributes attributes ,ModelMap model) throws Exception {
		
		// 리턴할 페이지가 담긴 변수
		String returnVal = "admin/member/memberUpdate";
		
		try {
			// 수정할 회원과 사물함 정보
			EgovMap memberInfo = memberService.selectMemberInfo(mbr_Id);
			model.addAttribute("memberInfo",memberInfo);
			
		} catch(Exception e) {
			// 에러 결과 바인딩
			paramMap.put("errorMsg", "수정할 회원정보를 가져오지 못하였습니다.");
			// 리다이렉트 paramMap 바인딩
			attributes.addFlashAttribute("paramMap",paramMap);
			// 회원목록페이지로 리턴
			returnVal = "redirect:/admin/member.do";
		}
		
		return returnVal;
	}
	
	/**
	 * 회원을 수정한다.
	 * @param cabId - 수정할 사물함번호가 담긴 List
	 * @param cabStartDate - 수정할 사물함등록일이 담긴 List
	 * @param cabFinishDate - 수정할 사물함만료일이 담긴 List
	 * @param paramMap - 수정할 회원정보, 회원목록 검색 조건이 담긴 hashmap
	 * @param model
	 * @param attributes
	 * @return "redirect:/admin/member.do" - 회원목록페이지
	 * @exception Exception
	 */
	@RequestMapping(value="admin/memberRealUpdate.do")
	public String memberRealUpdate(@RequestParam(value="cabId",required=false) List<String> cabId
			,@RequestParam(value="cabStartDate",required=false) List<String> cabStartDate
			,@RequestParam(value="cabFinishDate",required=false) List<String> cabFinishDate
			,@RequestParam HashMap<String,String> paramMap
			,RedirectAttributes attributes) throws Exception {
		
		try {
			// 회원, 사물함 수정
			memberService.updateMemberInfo(paramMap,cabId,cabStartDate,cabFinishDate);
			// 수정 성공 결과 메세지
			paramMap.put("successMsg", "회원이 수정되었습니다.");
			
		} catch(Exception e) {
			// 에러 결과 메세지
			paramMap.put("errorMsg", "회원을 수정하지 못하였습니다.");
		}
		// 리다이렉트 paramMap 바인딩
		attributes.addFlashAttribute("paramMap",paramMap);
		
		return "redirect:/admin/member.do";
	}
	
	/**
	 * ajax
	 * 사물함의 사용여부를 체크한다.
	 * @param request
	 * @return rslt - 사용여부     false(사용),true(미사용)
	 * @exception Exception
	 */
	@RequestMapping(value="admin/CabUseChk.do")
	@ResponseBody
	public String CabUseChk(HttpServletRequest request) throws Exception {
		
		// 사용여부 체크할 사물함번호
		String cabId = request.getParameter("cabId");
		
		// 조회여부 한 결과값을 담을 변수선언
		String rslt = "";
		
		// 사용여부 결과값
		boolean result = memberService.cabinetUseChkService(cabId);
		
		// 사용을 하고 있다면  false
		if(result == false) {
			rslt = "fail";
	    // 미사용이라면 true
		} else {
			rslt = "success";
		}
		
		return rslt;
	}
	
	/**
	 * ajax
	 * 수업일지를 조회한다.
	 * @param request
	 * @return dailyLog - 인코딩된 수업일지
	 * @exception Exception
	 */
	@RequestMapping(value="admin/dailyLog.do")
	@ResponseBody
	public String SelectDailyLog(HttpServletRequest request) throws Exception {
		
		// 클릭한 수업일지 관리번호
		String mngNo = request.getParameter("mngNo");
		
		// 조회한 수업일지
		String dailyLog = memberService.selectDailyLogService(mngNo);
		
		// 수업일지 내용이 있다면
		if(dailyLog != null) {
			// 수업일지 인코딩
			dailyLog = URLEncoder.encode(dailyLog, "UTF-8");
		} 
		// 수업일지 내용이 없다면
		else {
			// 실패 메세지 인코딩
			dailyLog = URLEncoder.encode("", "UTF-8");
		}
		
		return dailyLog;
	}
}
