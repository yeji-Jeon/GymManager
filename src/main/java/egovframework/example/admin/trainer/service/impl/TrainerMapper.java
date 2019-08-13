package egovframework.example.admin.trainer.service.impl;

import java.util.HashMap;
import java.util.List;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * 트레이너관리에 관한 데이터처리 매퍼 클래스
 *
 * @author  전예지
 * @since 2019.05.19
 * @version 1.0
 * @see <pre>
 *  == 개정이력(Modification Information) ==
 *
 *          수정일          수정자           수정내용
 *  ----------------    ------------    ---------------------------
 *   2019.05.19           전에지          최초 생성
 *
 * </pre>
 */

@Mapper
public interface TrainerMapper {

	/** 
	 * 트레이너 목록 조회
	 * @param paramMap  조회할 트레이너 조건검색이 담긴 hashmap
	 * @return 트레이너 목록
	 * @exception Exception
	 */
	List<EgovMap> SelectTrainerServiceList(HashMap<String, String> paramMap) throws Exception;
	
	/**
	 *  트레이너 목록 갯수조회
	 * @param paramMap 조회할 트레이너 조건검색이 담긴 hashmap
	 * @return 트레이너 목록 총 갯수
	 * @exception Exception
	 */
	String SelectTrainerCntServiceList(HashMap<String, String> paramMap) throws Exception;
	
	/**
	 * 트레이너를 등록한다.
	 * @param paramMap - 등록할 트레이너정보와 트레이너목록 검색 조건이 담긴 hashmap
	 * @return void
	 * @exception Exception
	 */
	void insertTrainerInfo(HashMap<String, String> paramMap) throws Exception;

	/**
	 * 마지막으로 등록된 트레이너를 조회한다.
	 * @return 트레이너ID
	 * @exception Exception
	 */
	String selectLastRegTrainerId() throws Exception;

	/**
	 * 트레이너를 삭제한다.
	 * @param mbr_id - 삭제할를Id
	 * @exception Exception
	 * @return void형
	 */
	void trainerDelete(String tId) throws Exception;

	/** 
	 * 트레이너 상세정보를 가져온다
	 * @param tId - 조회할 트레이너id
	 * @exception Exception
	 * @return 트레이너 상세정보와 총 PT횟수
	 */
	EgovMap selectTrainerInfo(String tId) throws Exception;

	/**
	 * 트레이너를 수정한다.
	 * @param paramMap - 수정할 트레이너정보, 트레이너목록 검색 조건이 담긴 hashmap
	 * @return 트레이너 수정결과 update 갯수반화
	 * @exception Exception
	 */
	int updateTrainerInfo(HashMap<String, String> paramMap) throws Exception;

}
