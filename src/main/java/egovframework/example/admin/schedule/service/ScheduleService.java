package egovframework.example.admin.schedule.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @Class Name : ScheduleService.java
 * @Description : Schedule Service Class
 * @Modification Information
 * @
 * @  수정일      수정자              수정내용
 * @ ---------   ---------   -------------------------------
 * @ 2019.05.20           최초생성
 *
 * @author 전예지
 * @since 2019.05.20
 * @version 1.0
 * @see
 *
 *  Copyright (C) All right reserved.
 */

public interface ScheduleService {

	/**
	 *  배정 일정 목록을 조회한다. 
	 * @param paramMap - 일정 ROW갯수 조건, 현재페이지번호
	 * @return  일정관리 리스트
	 * @exception Exception
	 */
	List<EgovMap> selectScheduleServiceList(HashMap<String, String> paramMap) throws Exception ;

	
	/** 
	 *  배정 일정 목록 갯수 조회
	 * @param paramMap  배정 일정 ROW갯수 조건, 현재페이지번호이 담긴 hashmap
	 * @return 배정 일정 목록 총 갯수
	 * @exception Exception
	 */
	String selectScheduleCntServiceList(HashMap<String, String> paramMap)  throws Exception ;


	/**
	 * PT 횟수가 남은 회원이고 존재하는 회원인지 확인
	 * @param mbrId 검색할 회원
	 * @return 회원ID,회원명 list
	 */
	String selectPtLeftMbrListServiceList(String mbrId) throws Exception ;


	/**
	 * 트레이너의이름과 ID의 리스트를 가져온다
	 * @param model
	 * @return  List<EgovMap> trainerInfoList
	 */
	List<EgovMap> selectTrainerInfoServiceList() throws Exception ;

	/**
	 * 일정등록이 가능한 시간대를 찿는다.
	 * @param parammap 관리자가 고른 pt일정의 날짜, 회원, 트레이너, 수업종류
	 * @return List<EgovMap> 가능한 시간대체크 배열과 그 시간대를 표시한 배열이 담긴  list
	 */
	List<EgovMap> selectTimeServiceList(Map<String, Object> paramMap) throws Exception ;

	/**
	 * 일정을 삭제한다.
	 * @param chk_info - 삭제할 일정의 관리번호가 담긴 List
	 * @exception Exception
	 */
	void deleteSchedule(List<String> chk_info) throws Exception ;


	/**
	 * 수업일지를 수정한다.
	 * @param dailyLogMap - 수업 일지와 관리번호
	 * @return 수업일지 수정 결과
	 * @exception Exception
	 */
	String updateDailyLogService(Map<String, Object> dailyLogMap) throws Exception ;

	/**
	 * 수업등록이 가능한 시간인지 확인한다.
	 * @param chkPickDT 체크한 시간대
	 * @return 확인결과
	 */
	String selectChkPickDTService(Map<String,Object> paramMap) throws Exception ;

	/**
	 * 수업을 등록한다
	 * @param param  배정일시, 트레이너, pt종류, 회원ID
	 * @return 수업일지 등록 결과
	 * @throws Exception
	 */
	String insertNewClass(Map<String, Object> paramMap) throws Exception ;



}
