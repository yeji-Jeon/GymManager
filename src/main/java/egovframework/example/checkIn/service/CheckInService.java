package egovframework.example.checkIn.service;

/**
 * @Class Name : CheckInService.java
 * @Description : 출석체크 서비스
 * @Modification Information
 * @
 * @  수정일      수정자              수정내용
 * @ ---------   ---------   -------------------------------
 * @ 2019.05.22           최초생성
 *
 * @author 전예지
 * @since 2019.05.22
 * @version 1.0
 * @see
 *
 *  Copyright (C) All right reserved.
 */

public interface CheckInService {

	/**
	 * 회원ID를 조회한다. 
	 * @param mbrId 조회할 회원ID
	 * @return 회원존재여부;
	 * @exception Exception
	 */
	String selectChcekInMbrService(String mbrId) throws Exception;

}
