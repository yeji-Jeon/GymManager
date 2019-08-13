package egovframework.example.admin.trainer.service.impl;

import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import egovframework.example.admin.trainer.service.TrainerService;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @Class Name : TrainerServiceImpl.java
 * @Description : 트레이너 crud
 * @Modification Information
 * @
 * @  수정일      수정자              수정내용
 * @ ---------   ---------   -------------------------------
 * @ 2019.05.19          최초생성
 *
 * @author  전예지
 * @since 2019.05.19
 * @version 1.0
 * @see
 *  
 */

@Service
public class TrainerServiceImpl implements TrainerService {
	
	/** TrainerMapper */
	@Resource
	private TrainerMapper trainerMapper;
	
	/** 
	 * 트레이너 목록 조회
	 * @param paramMap  조회할 트레이너 조건검색이 담긴 hashmap
	 * @return 트레이너 목록
	 * @exception Exception
	 */
	@Transactional
	@Override
	public List<EgovMap> SelectTrainerServiceList(HashMap<String, String> paramMap) throws Exception {
		return trainerMapper.SelectTrainerServiceList(paramMap);
	}
	
	/**
	 *  트레이너 목록 갯수조회
	 * @param paramMap 조회할 트레이너 조건검색이 담긴 hashmap
	 * @return 트레이너 목록 총 갯수
	 * @exception Exception
	 */
	@Transactional
	@Override
	public String SelectTrainerCntServiceList(HashMap<String, String> paramMap) throws Exception {
		return trainerMapper.SelectTrainerCntServiceList(paramMap);
	}
	
	/**
	 * 1.트레이너 근무시간 '시','분'을 합친다.
	 * 2.트레이너을 등록한다.
	 * 3.등록한 트레이너의 ID를 가져온다.
	 * @param paramMap - 등록할 트레이너정보와 트레이너목록 검색 조건이 담긴 hashmap
	 * @return 등록한 트레이너의 트레이너의ID
	 * @exception Exception
	 */
	@Transactional
	@Override
	public String insertTrainerInfoServiceList(HashMap<String, String> paramMap) throws Exception {
		
		// 근무시작시간 시,분 합치기
		String sTime = paramMap.get("sHour") + ":" + paramMap.get("sMinute");
		paramMap.put("sTime", sTime);
		// 근무시작시간 시,분 합치기
		String fTime = paramMap.get("fHour") + ":" + paramMap.get("fMinute");
		paramMap.put("fTime", fTime);
		
		// 트레이너 등록
		trainerMapper.insertTrainerInfo(paramMap);
		
		// 등록한 트레이너의 ID 저장할 변수선언
		String tId = "";
		try {
			// 등록한 트레이너의 ID
			tId = trainerMapper.selectLastRegTrainerId();
			tId = "트레이너ID는 " + tId + " 입니다." ;
		} catch(Exception e) {
			tId = "트레이너등록완료! 하지만 트레이너ID를 가져오지 못했습니다.";
		}
		
		return tId;
	}
	
	/**
	 * 트레이너 정보를 삭제한다.
	 * @param chk_info - 삭제할 트레이너Id가 담긴 List
	 * @exception Exception
	 * @return void형
	 */
	@Transactional
	@Override
	public void trainerDelete(List<String> tId) throws Exception {
		
		for(int i=0; i < tId.size() ; i++) {
			// 트레이너 한명 씩 삭제
			trainerMapper.trainerDelete(tId.get(i));
		}
	}

	/** 
	 * 트레이너 상세정보를 가져온다
	 * @param tId - 조회할 트레이너id
	 * @exception Exception
	 * @return 트레이너 상세정보와 총 PT횟수
	 */
	@Transactional
	@Override
	public EgovMap selectTrainerInfoService(String tId) throws Exception {
		return trainerMapper.selectTrainerInfo(tId);
	}

	/**
	 * 트레이너를 수정한다.
	 * @param paramMap - 수정할 트레이너정보, 트레이너목록 검색 조건이 담긴 hashmap
	 * @return 트레이너 수정결과
	 * @exception Exception
	 */
	@Transactional
	@Override
	public String updateTrainerInfo(HashMap<String, String> paramMap)
			throws Exception {
		
		// 반환할 결과값 저장할 변수
		String rst = "";
		// 근무시작시간 시,분 합치기
		String workStartTm = paramMap.get("sHour") + ":" + paramMap.get("sMinute") + ":00";
		paramMap.put("workStartTm", workStartTm);
		
		// 근무시작시간 시,분 합치기
		String workFinishTm = paramMap.get("fHour") + ":" + paramMap.get("fMinute") + ":00";
		paramMap.put("workFinishTm", workFinishTm);
		
		// 트레이너 수정 쿼리 실행
		int result = trainerMapper.updateTrainerInfo(paramMap);
		
		if(result > 0) 	{
			rst = "1";
		} else {
			rst = "0";
		}
		
		// 결과를 문자열로 반환
		return rst;
	}
}
