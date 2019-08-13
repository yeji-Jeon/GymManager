package egovframework.example.admin.member.service;

import java.util.HashMap;
import java.util.List;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @Class Name : MemberService.java
 * @Description : MemberService Class
 * @Modification Information
 * @
 * @  수정일      수정자              수정내용
 * @ ---------   ---------   -------------------------------
 * @ 2019.05.18           최초생성
 *
 * @author 전예지
 * @since 2019.05.10
 * @version 1.0
 * @see
 *
 *  Copyright (C) All right reserved.
 */

public interface MemberService {

	/**
	 * 회원 목록을 조회한다. 
	 * @param paramMap - 조회할 조건정보가 담긴 paramMap
	 * @return 회원 목록
	 * @exception Exception
	 */
	List<EgovMap> selectMemberServiceList(HashMap<String, String> paramMap) throws Exception ;

	/**
	 * 회원목록 총 갯수를 조회한다. 
	 * @param paramMap - 조회할 조건정보가 담긴 paramMap
	 * @return 회원 목록 총 갯수
	 * @exception Exception
	 */
	String selectMemberListCnt(HashMap<String, String> paramMap) throws Exception;

	/**
	 * 회원을 등록한다.
	 * @param cabId - 사물함번호들이 담긴 List
	 * @param cabStartDate - 사물함등록일들이 담긴 List
	 * @param cabFinishDate - 사물함 만료일들이 담긴 List
	 * @param paramMap - 등록할 회원정보와 회원목록 검색 조건이 담긴 hashmap
	 * @return 등록한 회원의 회원ID
	 * @exception Exception
	 */
	String insertMemberInfoServiceList(HashMap<String, String> paramMap,
			List<String> cabId, List<String> cabSDate, List<String> cabFDate)  throws Exception;

	/**
	 * 특정 회원을 조회한다.
	 * @param mbr_Id - 조회할 회원id
	 * @return 조회할 회원의 정보
	 * @exception Exception
	 */
	EgovMap selectMemberInfo(String mbr_Id) throws Exception;

	/**
	 * 회원을 삭제한다.
	 * @param chk_info - 삭제할 회원Id가 담긴 List
	 * @exception Exception
	 */
	void deleteMember(List<String> chk_info) throws Exception;

	/**
	 * 사물함의 사용여부를 체크한다.
	 * @param cabId 사용여부를 체크할 사물함 번호
	 * @return 사물함 사용여부
	 * @exception Exception
	 */
	boolean cabinetUseChkService(String cabId) throws Exception;

	/**
	 * 회원을 수정한다.
	 * @param cabId - 수정할 사물함번호가 담긴 List
	 * @param cabStartDate - 수정할 사물함등록일이 담긴 List
	 * @param cabFinishDate - 수정할 사물함만료일이 담긴 List
	 * @param paramMap - 수정할 회원정보, 회원목록 검색 조건이 담긴 hashmap
	 * @exception Exception
	 */
	void updateMemberInfo(HashMap<String, String> paramMap, List<String> cabId,
			List<String> cabStartDate, List<String> cabFinishDate) throws Exception;

	/**
	 * 특정회원의 배정된 일정을 조회한다.
	 * @param paramMap - 목록 조회조건 정보가 담긴 Hashmap
	 * @return 배정된 일정들
	 * @exception Exception
	 */
	EgovMap selectMemberScheduleList(HashMap<String, String> paramMap) throws Exception;

	/**
	 * 특정 수업일지를 조회한다.
	 * @param mngNo 수업일정 관리번호
	 * @return 특정 수업일지
	 * @exception Exception
	 */
	String selectDailyLogService(String mngNo) throws Exception;



}
