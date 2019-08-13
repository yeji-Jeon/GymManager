package egovframework.example.admin.trainer.service;

import java.util.HashMap;
import java.util.List;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @Class Name : TrainerService.java
 * @Description : TrainerService Class
 * @Modification Information
 * @
 * @  수정일      수정자              수정내용
 * @ ---------   ---------   -------------------------------
 * @ 2019.05.19           최초생성
 *
 * @author 전예지
 * @since 2019.05.19
 * @version 1.0
 * @see
 *
 *  Copyright (C) All right reserved.
 */

public interface TrainerService {

	/**
	 * 트레이너 목록 조회
	 * @param paramMap  트레이너 조건검색이 담긴 hashmap
	 * @return 트레이너 목록
	 * @exception Exception
	 */
	List<EgovMap> SelectTrainerServiceList(HashMap<String, String> paramMap) throws Exception;
	
	/** 
	 * 트레이너 목록 갯수 조회
	 * @param paramMap  트레이너 조건검색이 담긴 hashmap
	 * @return 트레이너 목록 총 갯수
	 * @exception Exception
	 */
	String SelectTrainerCntServiceList(HashMap<String, String> paramMap)throws Exception;
	
	/**
	 * 트레이너을 등록한다.
	 * @param paramMap - 등록할 트레이너정보와 트레이너목록 검색 조건이 담긴 hashmap
	 * @return 등록한 트레이너의 트레이너의ID
	 * @exception Exception
	 */
	String insertTrainerInfoServiceList(HashMap<String, String> paramMap) throws Exception;

	/**
	 * 트레이너을 삭제한다.
	 * @param chk_info - 삭제할 트레이너Id가 담긴 List
	 * @exception Exception
	 */
	void trainerDelete(List<String> chk_info) throws Exception;

	/**
	 * 특정 트레이너을 조회한다.
	 * @param tId - 조회할 트레이너id
	 * @return 조회할 트레이너의 정보
	 * @exception Exception
	 */
	EgovMap selectTrainerInfoService(String tId) throws Exception;
	
	/**
	 * 트레이너를 수정한다.
	 * @param paramMap - 수정할 트레이너정보, 트레이너목록 검색 조건이 담긴 hashmap
	 * @return 트레이너 수정결과
	 * @exception Exception
	 */
	String updateTrainerInfo(HashMap<String, String> paramMap) throws Exception;

}
