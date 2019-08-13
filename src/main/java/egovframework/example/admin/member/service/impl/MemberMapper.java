package egovframework.example.admin.member.service.impl;

import java.util.HashMap;
import java.util.List;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * 회원관리에 관한 데이터처리 매퍼 클래스
 *
 * @author  전예지
 * @since 2019.05.10
 * @version 1.0
 * @see <pre>
 *  == 개정이력(Modification Information) ==
 *
 *          수정일          수정자           수정내용
 *  ----------------    ------------    ---------------------------
 *   2019.05.10           전에지          최초 생성
 *   2019.05.18           전에지          주석 수정
 *
 * </pre>
 */

@Mapper
public interface MemberMapper {

	/**
	 * 회원 목록을 조회한다. 
	 * @param paramMap - 조회할 조건정보가 담긴 paramMap
	 * @return 회원 목록
	 * @exception Exception
	 */
	List<EgovMap> selectMemberServiceList(HashMap<String, String> paramMap) throws Exception;

	/**
	 * 회원목록 총 갯수를 조회한다. 
	 * @param paramMap - 조회할 조건정보가 담긴 paramMap
	 * @return 회원 목록 총 갯수
	 * @exception Exception
	 */
	String selectMemberListCnt(HashMap<String, String> paramMap)  throws Exception;

	/**
	 * 회원을 등록한다.
	 * @paramMap - 등록할 회원정보와 회원목록 검색 조건이 담긴 hashmap
	 * @return 성공여부(int 1 여러개여도 1)
	 * @exception Exception
	 */
	int insertMember(HashMap<String, String> paramMap)  throws Exception;

	/**
	 * 사물함을 등록한다.
	 * @cabId 사물함번호 list
	 * @cabSDate 사물함등록일자 list
	 * @cabFDate 사물함만료일자 list
	 * @return 사물함 update된 행 갯수(없다면 0)
	 * @exception Exception
	 */
	int insertCabinet(EgovMap newCab) throws Exception;

	/**
	 * 회원 상세정보를 가져온다
	 * @param mbr_Id - 조회할 회원id
	 * @return 상세조회할 회원
	 * @exception Exception
	 */
	EgovMap selectMemberInfo(String mbr_id) throws Exception;

	/** 
	 * 회원이 사용하는 사물함 정보들을 가져온다
	 * @param mbr_Id - 조회할 회원id
	 * @return 상세조회할 회원
	 * @exception Exception
	 */
	List<EgovMap> selectCabinetInfo(String mbr_id) throws Exception;

	/**
	 * 회원 정보를 삭제한다.
	 * @param mbr_id - 삭제할 회원Id
	 * @exception Exception
	 * @return void형
	 */
	void deleteMember(String mbr_id) throws Exception;

	/**
	 * 사물함 정보를 삭제한다.
	 * @param mbr_id - 삭제할 사물함들의 회원Id
	 * @exception Exception
	 * @return void형
	 */
	void deleteCabinet(String mbr_id) throws Exception;

	/**
	 * 사물함 사용여부를 체크한다.
	 * @param cabId 사용여부를 체크할 사물함 번호
	 * @return 사물함 사용여부(N,Y)
	 * @exception Exception
	 */
	String cabinetUseChkService(String cabId) throws Exception;

	/** 
	 * 회원수정을 한다.
	 * @param paramMap - 수정할 회원정보, 회원목록 검색 조건이 담긴 hashmap
	 * @return void형
	 * @exception Exception
	 */
	void updateMember(HashMap<String, String> paramMap) throws Exception;

	/**
	 *  사물함 수정을 한다.
	 * @param cabId - 수정할 사물함번호가 담긴 List
	 * @param cabStartDate - 수정할 사물함등록일이 담긴 List
	 * @param cabFinishDate - 수정할 사물함만료일이 담긴 List
	 * @return void형
	 * @exception Exception
	 */
	void updateCabinet(EgovMap newCab) throws Exception;

	/**
	 * 특정 회원에게 배정된 일정 정보들을 가져온다.
	 * @param paramMap - 목록 조회조건 정보가 담긴 Hashmap
	 * @return 배정된 일정들
	 * @exception Exception
	 */
	List<EgovMap> selectScheduleInfo(HashMap<String, String> paramMap) throws Exception;

	/**
	 * 특정 회원에게 배정된 일정 정보 갯수를 가져온다.
	 * @param paramMap - 목록 조회조건 정보가 담긴 Hashmap
	 * @return 배정된 일정들 총 갯수
	 * @exception Exception
	 */
	String selectScheduleInfoCnt(HashMap<String, String> paramMap) throws Exception;

	/**
	 * 특정 수업일지를 조회한다.
	 * @param mngNo 수업일정 관리번호
	 * @return 특정 수업일지
	 * @exception Exception
	 */
	String selectDailyLogService(String mngNo) throws Exception;

	/**
	 * 마지막으로 등록된 회원을 조회한다.
	 * @return 회원ID
	 * @exception Exception
	 */
	String selectLastRegMbr() throws Exception;

}
