package egovframework.example.admin.schedule.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 *  일정 관리에 관한 데이터처리 매퍼 클래스
 *
 * @author  전예지
 * @since 2019.05.20
 * @version 1.0
 * @see <pre>
 *  == 개정이력(Modification Information) ==
 *
 *          수정일          수정자           수정내용
 *  ----------------    ------------    ---------------------------
 *   2019.05.20           전에지          최초 생성
 *
 * </pre>
 */

@Mapper
public interface ScheduleMapper {

	/**
	 *  배정 일정 목록을 조회한다. 
	 * @param paramMap - 일정 ROW갯수 조건, 현재페이지번호
	 * @return  일정관리 리스트
	 * @exception Exception
	 */
	List<EgovMap> selectScheduleServiceList(HashMap<String, String> paramMap) throws Exception;

	/**
	 *  배정 일정 목록 갯수조회
	 * @param paramMap  배정 일정 ROW갯수 조건, 현재페이지번호이 담긴 hashmap
	 * @return 배정 일정 목록 총 갯수
	 * @exception Exception
	 */
	String selectScheduleCntServiceList(HashMap<String, String> paramMap) throws Exception;

	/**
	 *  PT 횟수가 남은 회원을 조회한다.
	 *  @return 회원ID,회원명 list
	 */
	String selectPtLeftMbrListServiceList(String mbrId) throws Exception;

	/**
	 * 트레이너의이름과 ID의 리스트를 가져온다
	 * @param model
	 * @return  List<EgovMap> trainerInfoList
	 */
	List<EgovMap> selectTrainerInfoServiceList()  throws Exception;

	/**
	 * 특정 트레이너의 근무시간을 가져온다
	 * @param model
	 * @return  EgovMap 근무시작시간, 근무종료시간
	 */
	HashMap<String,String> selectTrainerWorkTime(Map<String, Object> paramMap) throws Exception;

	/**
	 * 특정 회원의 수업시간을 가져온다(근무시간 안 기준)
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	List<HashMap<String, String>> selectMemberClass(Map<String, Object> paramMap) throws Exception;

	/**
	 * 특정 회원의 수업시간을 가져온다(근무시간에 걸친 기준)
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	List<HashMap<String, String>> selectMemberOutClass(Map<String, Object> paramMap) throws Exception;

	/**
	 * 특정 트레이너의 수업시간을 가져온다 
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	List<HashMap<String, String>> selectTrainerClass(Map<String, Object> paramMap) throws Exception;

	/**
	 * 수업등록이 가능한 시간인지 확인한다.
	 * @param chkPickDT 체크한 시간대
	 * @return 일정이 있다면 가져온다
	 */
	List<HashMap<String, String>> selectChkPickDTService(Map<String,Object> paramMap) throws Exception;
	
	/**
	 * 수업을 등록한다
	 * @param paramMap
	 * @return void
	 * @throws Exception
	 */
	void insertNewClass(Map<String, Object> paramMap) throws Exception;
	
	/**
	 *  회원 PT횟수 추가
	 * @param temp 일정 관리번호가 담긴 맵
	 * @throws Exception
	 */
	void mbrPtCntPlus(HashMap<String,String> temp) throws Exception;

	/**
	 * 일정삭제
	 * @param mngNo 일정 관리번호
	 * @throws Exception
	 */
	void deleteSchedule(String mngNo) throws Exception;

	/**
	 * 수업일지를 수정한다.
	 * @param dailyLogMap - 수업 일지와 관리번호
	 * @return 수업일지 수정 결과
	 * @exception Exception
	 */
	int updateDailyLogService(Map<String, Object> dailyLogMap) throws Exception;

	/**
	 * 일정이배정되 회원의pt횟수 감소
	 * @param object - 회원ID
	 * @return void
	 * @exception Exception
	 */
	void updateMbrPtCnt(String mbrId)  throws Exception;


 

}
