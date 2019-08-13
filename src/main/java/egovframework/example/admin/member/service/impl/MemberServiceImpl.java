package egovframework.example.admin.member.service.impl;

import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import egovframework.example.admin.member.service.MemberService;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @Class Name : MemberServiceImpl.java
 * @Description : 회원 crud / 사물함 crud
 * @Modification Information
 * @
 * @  수정일      수정자              수정내용
 * @ ---------   ---------   -------------------------------
 * @ 2019.05.14          최초생성
 *
 * @author  전예지
 * @since 2019.05.14
 * @version 1.0
 * @see
 *  
 */

@Service("MemberService")
public class MemberServiceImpl implements MemberService {
	
	/** MemberMapper */
	@Resource
	private MemberMapper memberMapper;
	
	/**
	 * 회원 목록을 조회한다. 
	 * @param paramMap - 조회할 조건정보가 담긴 hashmap
	 * @return 회원 목록
	 * @exception Exception
	 */
	@Transactional
	@Override
	public List<EgovMap> selectMemberServiceList(HashMap<String, String> paramMap) throws Exception {
		return memberMapper.selectMemberServiceList(paramMap);
	}

	/**
	 * 회원목록 총 갯수를 조회한다. 
	 * @param paramMap - 조회할 조건정보가 담긴 paramMap
	 * @return 회원 목록 총 갯수
	 * @exception Exception
	 */
	@Transactional
	@Override
	public String selectMemberListCnt(HashMap<String, String> paramMap) throws Exception {
		return memberMapper.selectMemberListCnt(paramMap);
	}

	
	/**
	 * 회원을 등록한다.
	 * 1. paramMap 매개변수를 가져가 회원을 등록한다.
	 * 2. paramMap에 들은 데이터로 사물함 사용유무를 확인하고 사물함을 쓴다면 등록한다.
	 *   2-1 사물함id만큼 for문을 돌려서 사물함 정보들을 egovmap에 저장하고 사물함을 등록한다.
	 * @paramMap - 등록할 회원정보와 회원목록 검색 조건이 담긴 hashmap
	 * @cabId 사물함번호 list
	 * @cabSDate 사물함등록일자 list
	 * @cabFDate 사물함만료일자 list
	 * @return 등록한 회원ID
	 * @exception Exception
	 */
	@Transactional
	@Override
	public String insertMemberInfoServiceList(HashMap<String, String> paramMap,
			List<String> cabId, List<String> cabSDate, List<String> cabFDate)  throws Exception {
		
		// 회원등록
		memberMapper.insertMember(paramMap);
		
		// 사물함 정보 저장
		EgovMap newCab ;
		
		// 사물함 여러개 등록
		if(paramMap.get("cabUseOneMore").equals("Y")) {
			for(int i=0; i < cabId.size() ; i++) {
				
				// 사물함 한개를 담을 맵 선언
				newCab = new EgovMap();
				// 사물함 번호를 맵에 넣는다
				newCab.put("cabId", cabId.get(i));
				// 사물함 등록일을 맵에 넣는다.
				newCab.put("cabSDate",cabSDate.get(i));
				// 사물함 만료일을 맵에 넣는다.
				newCab.put("cabFDate",cabFDate.get(i));
				// 사물함을 등록한다.
				memberMapper.insertCabinet(newCab);
			}
		}
		
		// 등록된 회원의  ID를 가져온다
		String mbrId = memberMapper.selectLastRegMbr();
		
		// 등록한 회원ID를 리턴
		return mbrId;
	}

	/** 
	 * 회원 상세정보를 가져온다
	 * 1. 회원정보를 egovMap으로 가져온다
	 * 2. 사물함 정보를 List<egovMap>  cabinet 가져온다
	 * 3. 일정 정보를 List<egovMap> 가져온다
	 * 4. 두개의 정보를 하나의 맵으로 합친다. resultMap(memberInfo:멤버맵 ,cabinetInfo:캐비넷리스트 ) 
	 * @param mbr_Id - 조회할 회원id
	 * @return 상세조회할 회원과 사물함들의 정보
	 * @exception Exception
	 * @desc 회원 상세보기
	 * @see egovframework.example.admin.member.service.MemberService#selectMemberInfo(java.util.HashMap)
	 */
	@Transactional
	@Override
	public EgovMap selectMemberInfo(String mbr_id)
			throws Exception {
		
		// 리턴할 값을 담을 맵 선언
		EgovMap resutlMap = new EgovMap();
		
		// 특정 회원의 상세정보를 가져온다
		EgovMap member = memberMapper.selectMemberInfo(mbr_id);
		
		// 특정회원의 사물함 정보들을 가져온다.
		List<EgovMap> cabinet = memberMapper.selectCabinetInfo(mbr_id);
		
		// 회원상세정보를 리턴할 맵에 담는다.
		resutlMap.put("memberInfo", member);
		// 사물함정보들을 리턴할 맵에 담는다.
		resutlMap.put("cabinetInfo", cabinet);
		
		// 회원 정보와 사물함정보들을 리턴한다.
		return resutlMap;
	}

	/**
	 * 특정 회원에게 배정된 일정 정보와 갯수를 가져온다.
	 * @param paramMap - 목록 조회조건 정보가 담긴 Hashmap
	 * @return 배정된 일정들과 그 총 갯수
	 * @exception Exception
	 * @see egovframework.example.admin.member.service.MemberService#selectMemberScheduleList(java.util.HashMap)
	 */
	@Override
	public EgovMap selectMemberScheduleList(
			HashMap<String, String> paramMap) throws Exception {

		// 리턴할 결과를 저장한 맵을 선언
		EgovMap resutlMap = new EgovMap();
		
		// 특정 회원에게  배정된 일정정보
		List<EgovMap> scheduleLists = memberMapper.selectScheduleInfo(paramMap);
		// 특정 회원에게  일정정보 갯수
		String scheduleListCtn = memberMapper.selectScheduleInfoCnt(paramMap);
				
		// 일정정보들을 맵에 담음
		resutlMap.put("scheduleLists", scheduleLists);
		// 일정정보 총 갯수를 맵에 담음
		resutlMap.put("scheduleListCtn", scheduleListCtn);
		
		// 특정회원의 일정정보와 그 총 갯수를 리턴
		return resutlMap;
	}
	
	/**
	 * 회원 정보를 삭제한다.
	 * 1. 사물함 정보를 삭제한다.
	 * 2. 회원정보를 삭제한다
	 * @param chk_info - 삭제할 회원Id가 담긴 List
	 * @exception Exception
	 * @return void형
	 * @see egovframework.example.admin.member.service.MemberService#deleteMember(java.util.List)
	 */
	@Transactional
	@Override
	public void deleteMember(List<String> chk_info) throws Exception {
		
		for(int i=0; i < chk_info.size() ; i++) {
			//일정삭제- 일정이 있으면 삭제할수없다 그러므로 일정삭제는 없음
			
			// 사용하고 있는 사물함 정보 삭제
			memberMapper.deleteCabinet(chk_info.get(i));
			// 회원정보 삭제
			memberMapper.deleteMember(chk_info.get(i));
		}
	}

	/**
	 * 사물함 사용여부를 체크한다.
	 * @param cabId 사용여부를 체크할 사물함 번호
	 * @return 사물함 사용여부
	 * @exception Exception
	 * @see egovframework.example.admin.member.service.MemberService#cabinetUseChkService(java.lang.String)
	 */
	@Transactional
	@Override
	public boolean cabinetUseChkService(String cabId) throws Exception {
		
		// 사물함 사용여부를 담을 불린 선언
		boolean rst = true;
		
		// 사물함 사용여부확인시 담을 변수(N ,Y)
		String result = "";
		
		// 사용여부를 조회하고 결과값 조회
		result = memberMapper.cabinetUseChkService(cabId);
		
		// 사물함을 사용하고 있다면(Y)
		if(result.equals("Y")) {
			// 사용을 할  수 없으므로 false반환
			rst = false;
		}
		
		return rst;
	}
	
	/** 
	 * 회원수정을 한다.
	 * 1. 회원 수정을 한다.
	 * 2. 회원이 사용하고 있던 사물함들을 삭제한다.
	 * 3. 회원 사물함을 배정한다.
	 * 		3-1 회원권 사용중이라면 사물함배정
	 * 		3-2 회원권 미사용중이라면 사물함 삭제
	 * @param cabId - 수정할 사물함번호가 담긴 List
	 * @param cabStartDate - 수정할 사물함등록일이 담긴 List
	 * @param cabFinishDate - 수정할 사물함만료일이 담긴 List
	 * @param paramMap - 수정할 회원정보, 회원목록 검색 조건이 담긴 hashmap
	 * @return void형
	 * @exception Exception
	 * @see egovframework.example.admin.member.service.MemberService#updateMemberInfo(java.util.HashMap, java.util.List, java.util.List, java.util.List)
	 */
	@Transactional
	@Override
	public void updateMemberInfo(HashMap<String, String> paramMap,
			List<String> cabId, List<String> cabStartDate,List<String> cabFinishDate) throws Exception {
		
		// 회원정보 수정
		memberMapper.updateMember(paramMap);
		
		// 사물함 정보 저장
		EgovMap newCab ;
		
		// 사물함 배정
		if(paramMap.get("cabUseOneMore").equals("Y")) {
			
			// 회원이 사용하는 사물함 정보 삭제
			memberMapper.deleteCabinet(paramMap.get("mbrId"));
			
			// 파라미터로 들어온 사물함을 모두 배정한다.
			for(int i=0; i < cabId.size() ; i++) {
				// 사물함 한개 담을 맵 선언
				newCab = new EgovMap();
				// 사물함정보의 회원ID
				newCab.put("mbrId",paramMap.get("mbrId"));
				// 회원정보를 넣을 사물함번호
				newCab.put("cabId", cabId.get(i));
				// 사물함정보의 사물함등록일
				newCab.put("cabStartDate",cabStartDate.get(i));
				// 사물함정보의 사물함만료일
				newCab.put("cabFinishDate",cabFinishDate.get(i));
				
				// 사물함 배정을 한다.
				memberMapper.updateCabinet(newCab);
			}
		} 
		// 회원권 미사용 시, 사물함 삭제
		else {
			// 회원이 사용중인 모든 사물함의 정보를 null로 변환
			memberMapper.deleteCabinet(paramMap.get("mbrId"));
		}
	}
	
	/**
	 * 특정 수업일지를 조회한다.
	 * @param mngNo 가져올 수업일지의 관리번호
	 * @return 특정 수업일지
	 * @see egovframework.example.admin.member.service.MemberService#selectDailyLogService()
	 */
	@Override
	public String selectDailyLogService(String mngNo) throws Exception {
		return memberMapper.selectDailyLogService(mngNo);
	}

}
