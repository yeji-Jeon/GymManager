package egovframework.example.admin.schedule.web;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.springframework.web.servlet.support.RequestContextUtils;

import egovframework.example.admin.schedule.service.ScheduleService;
import egovframework.example.cmmn.JsonUtil;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @Class Name : ScheduleController.java
 * @Description : 스케쥴 등록,취소,조회 / 수업일지 조회,수정 컨트롤러
 * @Modification Information
 * @
 * @  수정일      수정자              수정내용
 * @ ---------   ---------   -------------------------------
 * @ 19.05.20           최초생성
 *
 * @author 전예지
 * @since 2019. 05. 20
 * @version 1.0
 * @see
 *
 *  Copyright (C) All right reserved.
 */

@Controller
public class ScheduleController {
	
	/** scheduleService */
	@Resource
	private ScheduleService scheduleService;
	
	/**
	 * 배정 일정 목록을 조회한다. 
	 * 일정 목록 조회 - schedList
	 * 일정 목록 갯수 - schedListsCnt
	 * @param paramMap - 일정 ROW갯수 조건, 현재페이지번호
	 * @param model
	 * @return "admin/scheduel/scheduleList" - 이번달 일정관리 페이지
	 * @exception Exception
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value ="admin/schedule.do")
	public String scheduleList(HttpServletRequest request
			,@RequestParam HashMap<String,String> paramMap, ModelMap model) throws Exception {
		
		// 일정삭제,수정,등록 후 검색조건 값 받기
		Map<String, ?> redirectMap = RequestContextUtils.getInputFlashMap(request);
		
		if(redirectMap != null) {
			paramMap = (HashMap<String, String>) redirectMap.get("paramMap");
		} else {
			// 첫시작일 때, 검색조건을 세팅해준다.
			// 2인 이유는 leftnav를 누르면 항상  pageName값이 있기 때문에
			if(paramMap.size() < 1) {
				paramMap.put("rowCnt", "10");
				paramMap.put("currPage", "1");
			}
		}
		
		try{
			// 수업 일정 목록
			List<EgovMap> schedList = scheduleService.selectScheduleServiceList(paramMap);
			model.addAttribute("schedList", schedList);
			
			// 수업 일정 목록 갯수 - paging
			String schedListsCnt = scheduleService.selectScheduleCntServiceList(paramMap);
			model.addAttribute("schedListsCnt", schedListsCnt);

		} catch(Exception e) {
			// 에러결과 바인딩
			paramMap.put("searcherrorMsg", "일정 조회에 실패하였습니다.");
		}
		
		// 레프트메뉴 active를 위한 값
		paramMap.put("pageName","schedule");
		// 검색조건
		model.addAttribute("paramMap", paramMap);
		
		return "admin/schedule/scheduleList";
	}
	
	/**
	 * 일정등록 화면을 조회한다.
	 * List<EgovMap> trainerInfoList - 트레이너의이름과 ID
	 * @param model
	 * @return "admin/schedule/scheduleAdd"
	 */
	@RequestMapping(value="admin/scheduleAdd.do")
	public String scheduleAdd(@RequestParam HashMap<String,String> paramMap
			,RedirectAttributes attributes, ModelMap model) throws Exception {
		
		// 리턴값을 담을 변수선언
		String result = "";
		
		try {
			// 트레이너이름과 ID를 가져옴
			List<EgovMap> trainerInfoList = scheduleService.selectTrainerInfoServiceList();
			// 검색조건
			model.addAttribute("trainerInfoList", trainerInfoList);
			
			result = "admin/schedule/scheduleAdd";
			
		} catch(Exception e) {
			
			// 에러결과 바인딩
			paramMap.put("erroMsg", "일정등록 화면 조회에 실패하였습니다.");
			// 리다이렉트 paramMap 바인딩
			attributes.addFlashAttribute("paramMap",paramMap);
			// 일정목록으로 돌아가가
			result = "redirect:/admin/schedule.do";
		}
		return result;
	}
	
	/**
	 *  ajax
	 *  PT 횟수가 남은 회원이고 존재하는 회원인지 확인
	 *  @return 회원 일정 추가 가능여부
	 */
	@RequestMapping(value="admin/ptLeftMbr.do")
	@ResponseBody
	public String ptLeftMbr(HttpServletRequest request) throws Exception {
		
		// 리턴할 결과값 저장 변수선언
		String mbrConfirm = "" ;
		
		// 검색할 회원ID를 담을 변수선언
		String mbrId = request.getParameter("mbrId");
		
		// 회원 일정 추가 가능여부
		mbrConfirm = scheduleService.selectPtLeftMbrListServiceList(mbrId);
		
		return mbrConfirm;
	}
	
	/**
	 * 일정등록이 가능한 시간대를 찿는다.
	 * List<EgovMap> 가능한 시간대 list
	 * @param paramMap json형태 pt일정의 날짜, 회원, 트레이너, 수업종류
	 * @param model
	 * @return JsonUtil.ListToJson(timeLists)
	 */
	@RequestMapping(value="admin/findTimeSchedule.do", method=RequestMethod.POST)
	@ResponseBody
	public String findTimeSchedule(@RequestBody String paramMap,
			ModelMap model) throws Exception {
		
		// 결과값 넘기기
		String result = "";
		// 가능한 시간대 리스트 저장할 리스트
		List<EgovMap> timeLists = null;
		
		try {
			// JSON으로 받아온 값을 parse 후 찿기
			timeLists = scheduleService.selectTimeServiceList(JsonUtil.JsonToMap(paramMap));
			// 가능한 시간대 리스트 json으로 변경
			result = JsonUtil.ListToJson(timeLists);
			
		} catch (Exception e) {
			
			result = "가능한 시간대를 가져오지 못했습니다.";
		}
		return result;
	}
	
	/**
	 * 수업을 삭제한다.
	 * @param paramMap - 목록 페이징 정보가 담긴 Hashmap
	 * @param chk_info - 일정 관리번호
	 * @param attributes - 삭제할 회원Id가 담긴 List
	 * @return "redirect:/admin/schedule.do" - 일정목록
	 * @exception Exception
	 */
	@RequestMapping(value="admin/scheduleCancel.do")
	public String scheduleCancel(@RequestParam HashMap<String,String> paramMap
			,@RequestParam(value="chk_info",required=true) List<String> chk_info
			,RedirectAttributes attributes) throws Exception {
				
		try {
			// 일정 삭제
			scheduleService.deleteSchedule(chk_info);
			
			// 삭제성공메세지 바인딩
			paramMap.put("successMsg", "일정이 취소 되었습니다.");
			
		} catch(Exception e) {
			// 에러 결과 바인딩
			paramMap.put("errorMsg", "일정정보를 취소하지 못하였습니다.");
		}
		
		// 리다이렉트 paramMap 바인딩
		attributes.addFlashAttribute("paramMap",paramMap);
		
		return "redirect:/admin/schedule.do";
	}
	
	/**
	 * 수업일지를 수정한다.
	 * @param dailyLog 수업일지와 일지관리번호
	 * @param model
	 * @return 수업일지 수정 결과
	 */
	@RequestMapping(value="/admin/dailyLogSave.do", method=RequestMethod.POST)
	@ResponseBody
	public String dailyLogSave(@RequestBody String dailyLog,ModelMap model) throws Exception {
		
		// 결과를 저장한다.
		String result = "";
		
		try {
			// JSON으로 받아온 값을 parse 후 수정보냄
			// 수업일지를 수정
			result = scheduleService.updateDailyLogService(JsonUtil.JsonToMap(dailyLog));
			
		} catch (Exception e) {
			
			// 수업일지 수정 실패시
			result = "fail";
		}
		
		return result;
	}
	
	/**
	 * 수업등록이 가능한 시간인지 확인한다.
	 * @param param 선택한 수업일시, 트레이너, pt종류, 회원ID
	 * @return 확인결과
	 */
	@RequestMapping(value="/admin/chkAvailDT.do", method=RequestMethod.POST)
	@ResponseBody
	public String chkAvailDT(@RequestBody String param) throws Exception {
		
		// 가능한 시간대를 저장
		// 선택한 트레이너
		// JSON으로 받아온 값을 parse
		Map<String, Object> paramMap = JsonUtil.JsonToMap(param);
		
		// 결과를 저장한다.
		String result = "";
		
		try {
			// 시간등록 가능여부 체크
			result = scheduleService.selectChkPickDTService(paramMap);
			
		} catch (Exception e) {
			
			// 등록 시간 조회 실패시
			result = "fail";
		}
		
		return result;
	}
	
	/**
	 * 수업을 등록한다
	 * @param param  배정일시, 트레이너, pt종류, 회원ID
	 * @return 수업일지 등록 결과
	 * @throws Exception
	 */
	@RequestMapping(value="/admin/insertNewClass.do", method=RequestMethod.POST)
	@ResponseBody
	public String insertNewClass(@RequestBody String param) throws Exception {
		
		// 가능한 시간대를 저장
		// 선택한 트레이너
		// JSON으로 받아온 값을 parse
		Map<String, Object> paramMap = JsonUtil.JsonToMap(param);
		
		// 결과를 저장한다.
		String result = "";
		
		try {
			// 시간등록 가능여부 체크
			result = scheduleService.insertNewClass(paramMap);
			
		} catch (Exception e) {
			
			// 수업일지 수정 실패시
			result = "fail";
		}
		
		return result;
	}
	
}
