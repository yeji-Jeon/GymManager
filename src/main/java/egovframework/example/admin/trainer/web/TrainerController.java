package egovframework.example.admin.trainer.web;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.springframework.web.servlet.support.RequestContextUtils;

import egovframework.example.admin.trainer.service.TrainerService;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @Class Name : TrainerController.java
 * @Description : 트레이너crud 컨트로러
 * @Modification Information
 * @
 * @  수정일      수정자              수정내용
 * @ ---------   ---------   -------------------------------
 * @ 19.05.19           최초생성
 *
 * @author 전예지
 * @since 2019. 05. 19
 * @version 1.0
 * @see
 *
 *  Copyright (C) All right reserved.
 */

@Controller
public class TrainerController {
	
	/** TrainerService */
	@Resource
	private TrainerService trainerService;
	
	/**
	 * 트레이너 목록을 조회한다. 
	 * 트레이너 목록 조회 - trainerLists
	 * 트레이너 목록 갯수 - trainerListsCnt
	 * @param paramMap - 트레이너 검색  조건 정보가 담긴 paramMap
	 * @param model
	 * @return "admin/trainer/trainerLists" - 트레이너목록페이지
	 * @exception Exception
	 */
	@RequestMapping(value="admin/trainerLists.do")
	public String trainerLists(HttpServletRequest request
			,@RequestParam HashMap<String,String> paramMap, ModelMap model) throws Exception {
		
		// 트레이너삭제,수정,등록 후 검색조건 값 받기
		Map<String, ?> redirectMap = RequestContextUtils.getInputFlashMap(request);
		
		// 트레이너 수정,등록,삭제 후 검색조건을 가져온다
		if(redirectMap != null) {
			paramMap = (HashMap<String, String>) redirectMap.get("paramMap");
		} else {
			// 첫시작일 때, 검색조건을 세팅해준다.
			if(paramMap.size() < 1) {
				paramMap.put("searchCon", "0");
				paramMap.put("rowCnt", "10");
				paramMap.put("currPage", "1");
			}
		}
		
		try{
			// 트레이너 목록 조회
			List<EgovMap> trainerLists = trainerService.SelectTrainerServiceList(paramMap);
			model.addAttribute("trainerLists", trainerLists);
			
			// 트레이너 목록 갯수 - paging
			String trainerListsCnt = trainerService.SelectTrainerCntServiceList(paramMap);
			model.addAttribute("trainerListsCnt", trainerListsCnt);

		} catch(Exception e) {
			// 에러결과 바인딩
			paramMap.put("searcherrorMsg", "트레이너조회에 실패하였습니다.");
		}
		
		// 레프트메뉴 active를 위한 값
		paramMap.put("pageName","trainer");
		// 조회했을 때의 검색조건
		model.addAttribute("paramMap", paramMap);
		
		// 트레이너 목록페이지
		return "admin/trainer/trainerLists";
	}
	
	/**
	 * 트레이너등록 화면을 조회한다.
	 * @return "admin/trainer/trainerAdd"
	 */
	@RequestMapping(value="admin/trainerAdd.do")
	public String trainerAdd() throws Exception {
		return "admin/trainer/trainerAdd";
	}
	
	/**
	 * 트레이너을 등록한다.
	 * @param paramMap - 등록할 트레이너정보와 트레이너목록 검색 조건이 담긴 hashmap
	 * @return "admin/trainerLists.do" - 트레이너목록 , 트레이너추가 결과값(request 바인딩)
	 * @exception Exception
	 */
	@RequestMapping(value="admin/trainerRealAdd.do")
	public String trainerRealAdd(@RequestParam HashMap<String,String> paramMap
			,RedirectAttributes attributes) throws Exception {
				 
		try {
			// 트레이너을 등록한다
			String result = trainerService.insertTrainerInfoServiceList(paramMap);
			
			// 트레이너 추가 결과값(트레이너ID) 바인딩
			paramMap.put("successMsg", result);
			
		} catch(Exception e) {
			// 에러결과 바인딩
			paramMap.put("errorMsg", "트레이너등록에 실패하였습니다.");
		}
		
		// 트레이너 목록 검색조건 바인딩
		attributes.addFlashAttribute("paramMap",paramMap);
		// 트레이너목록페이지
		return "redirect:/admin/trainerLists.do";
	}
	
	/**
	 * 트레이너을 삭제한다.
	 * @param paramMap - 목록 조회조건 정보가 담긴 Hashmap
	 * @param chk_info - 삭제할 트레이너Id가 담긴 List
	 * @param attributes - 삭제할 트레이너Id가 담긴 List
	 * @return "redirect:/admin/trainerLists.do" - 트레이너목록
	 * @exception Exception
	 */
	@RequestMapping(value="admin/trainerDelete.do")
	public String trainerDelete(@RequestParam HashMap<String,String> paramMap
			,@RequestParam(value="chk_info",required=true) List<String> chk_info
			,RedirectAttributes attributes) throws Exception {
				
		try {
			// 트레이너 삭제
			trainerService.trainerDelete(chk_info);
			
			// 삭제성공메세지 바인딩
			paramMap.put("successMsg", "트레이너가 삭제 되었습니다.");
			
		} catch(Exception e) {
			// 에러 결과 바인딩
			paramMap.put("errorMsg", "트레이너정보를 삭제하지 못하였습니다.");
			
		}
		
		// 리다이렉트 paramMap 바인딩
		attributes.addFlashAttribute("paramMap",paramMap);
		
		return "redirect:/admin/trainerLists.do";
	}
	
	/**
	 * 트레이너 상세정보를 조회한다.
	 * @param request
	 * @param tId - 상세조회할 트레이너ID
	 * @param paramMap - 목록 조회조건 정보가 담긴 Hashmap
	 * @param model
	 * @param attributes
	 * trainerInfo - 트레이너정보(EgovMap), 검색했던 조건들
	 * @return "admin/member/trainerDetail" - 상세정보가 담긴 페이지
	 * @exception Exception
	 */
	@RequestMapping(value="admin/trainerDetail.do")
	public String trainerDetail(@RequestParam(value="rowTId",required=true) String rowTId
			,@RequestParam HashMap<String,String> paramMap
			,RedirectAttributes attributes ,ModelMap model) throws Exception {
		
		// 리턴할 페이지가 담긴 변수
		String returnVal = "admin/trainer/trainerDetail";
		
		try {
			// 트레이너정보(EgovMap) 가져옴
			EgovMap trainerInfo = trainerService.selectTrainerInfoService(rowTId);
			model.addAttribute("trainerInfo",trainerInfo);
						
		} catch(Exception e) {
			// 에러결과 메세지
			paramMap.put("errorMsg", "트레이너의 상세를 조회하지 못했습니다.");
			// 리다이렉트 paramMap 바인딩
			attributes.addFlashAttribute("paramMap",paramMap);
			// 트레이너목록으로 돌아가기
			returnVal = "redirect:/admin/trainerLists.do";
		}
		
		return returnVal;
	}
	
	/**
	 * 트레이너 수정화면을 조회한다.
	 * @param tId - 수정할 트레이너id
	 * @param paramMap - 목록 조회조건 정보가 담긴 Hashmap
	 * @param attributes
	 * @param model
	 * trainerInfo - 트레이너정보(EgovMap), 검색했던 조건들
	 * @return "admin/trainer/trainerUpdate" - 트레이너 수정페이지
	 * @exception Exception
	 */
	@RequestMapping(value="admin/trainerUpdate.do")
	public String trainerUpdate(@RequestParam HashMap<String,String> paramMap
			,@RequestParam(value="rowTId",required=true) String tId
			,RedirectAttributes attributes ,ModelMap model) throws Exception {
		
		// 리턴할 페이지가 담긴 변수
		String returnVal = "admin/trainer/trainerUpdate";
		
		try {
			// 트레이너정보(EgovMap)
			EgovMap trainerInfo = trainerService.selectTrainerInfoService(tId);
			model.addAttribute("trainerInfo",trainerInfo);
			
		} catch(Exception e) {
			// 에러결과 메세지
			paramMap.put("errorMsg", "트레이너 수정페이지를 조회하지 못했습니다.");
			// 리다이렉트 paramMap 바인딩
			attributes.addFlashAttribute("paramMap",paramMap);
			// 트레이너목록으로 돌아가기
			returnVal = "redirect:/admin/trainerLists.do";
		}
		
		return returnVal;
	}
	
	/**
	 * 트레이너를 수정한다.
	 * @param paramMap - 수정할 트레이너정보, 트레이너목록 검색 조건이 담긴 hashmap
	 * @param attributes
	 * @return "redirect:/admin/trainerLists.do" - 트레이너 목록 페이지
	 * @exception Exception
	 */
	@RequestMapping(value="admin/trainerRealUpdate.do")
	public String trainerRealUpdate(@RequestParam HashMap<String,String> paramMap
			,RedirectAttributes attributes) throws Exception {
				
		try {
			// 트레이너 수정하기
			String result = trainerService.updateTrainerInfo(paramMap);
			
			if(result.equals("1")) {
				// 수정 성공 결과 메세지
				paramMap.put("successMsg", "트레이너이 수정되었습니다.");				
			} else {
				// 수정 실패 메세지
				paramMap.put("successMsg", "트레이너이 수정되지 못하였습니다.");
			}
			
		} catch(Exception e) {
			// 에러 결과 메세지
			paramMap.put("errorMsg", "트레이너을 수정하지 못하였습니다.");
		}
		
		// 리다이렉트 트레이너검색조건 바인딩
		attributes.addFlashAttribute("paramMap",paramMap);
		
		// 트레이너 목록으로 돌아가기
		return "redirect:/admin/trainerLists.do";
	}
}
