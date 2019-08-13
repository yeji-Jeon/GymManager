package egovframework.example.admin.schedule.service.impl;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import egovframework.example.admin.schedule.service.ScheduleService;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @Class Name : ScheduleServiceImpl.java
 * @Description : 스케쥴 등록,취소,조회 / 수업일지 조회,수정 서비스
 * @Modification Information
 * @
 * @  수정일      수정자              수정내용
 * @ ---------   ---------   -------------------------------
 * @ 2019.05.20          최초생성
 *
 * @author  전예지
 * @since 2019.05.20
 * @version 1.0
 * @see
 *  
 */

@Service("ScheduleService")
public class ScheduleServiceImpl implements ScheduleService {

   
   /** ScheduleMapper */
   @Resource
   private ScheduleMapper scheduleMapper;
   
   /**
    *  배정 일정 목록을 조회한다. 
    * @param paramMap - 일정 ROW갯수 조건, 현재페이지번호
    * @return  일정관리 리스트
    * @exception Exception
    */
   @Transactional
   @Override
   public List<EgovMap> selectScheduleServiceList(HashMap<String, String> paramMap) throws Exception {
      return scheduleMapper.selectScheduleServiceList(paramMap);
   }

   /**
    *  배정 일정 목록 갯수조회
    * @param paramMap  배정 일정 ROW갯수 조건, 현재페이지번호이 담긴 hashmap
    * @return 배정 일정 목록 총 갯수
    * @exception Exception
    */
   @Transactional
   @Override
   public String selectScheduleCntServiceList(HashMap<String, String> paramMap) throws Exception {
      return scheduleMapper.selectScheduleCntServiceList(paramMap);
   }


   /**
    * PT 횟수가 남은 회원이고 존재하는 회원인지 확인
    * @param mbrId 검색할 회원
    * @return 결과값에 해당하는 문자열
    * @exception Exception
    */
   @Transactional
   @Override
   public String selectPtLeftMbrListServiceList(String mbrId) throws Exception {
      
      // 리턴값을 담을 변수선언
      String result = "";
      
      try {
         
         // 회원ID로 조회한 결과값
         String memberExist = scheduleMapper.selectPtLeftMbrListServiceList(mbrId);
         
         // 회원이 존재하지 않으면 false 리턴
         if(memberExist == null) {
            result = "false";
         // 회원이 존재하지만 pt횟수가 없다면 halfFail 리턴
         } else if(Integer.parseInt(memberExist) == 0) {
            result = "halfFail";
         // 배정가능한 회원이라면 true 리턴
         } else {
            result = "true";
         }
      } catch(Exception e) {
         result = "fail";
      }
      
      return result;
   }

   /**
    * 트레이너의이름과 ID의 리스트를 가져온다
    * @param model
    * @return  List<EgovMap> trainerInfoList
    */
   @Transactional
   @Override
   public List<EgovMap> selectTrainerInfoServiceList() throws Exception {
      return scheduleMapper.selectTrainerInfoServiceList();
   }

   /**
    * 일정등록이 가능한 시간대를 찿는다.
    * 	1. 트레이너 근무시간을 선택한 날짜와 합겨처 가져온다
    *   2. 날짜에 해당하는 회원일정과 트레이너 일정을 가져온다
    *   3. 트레이너 근무시간 만큼의 10분단위 배열을 선언하고 1이면 불가능한 시간, 0이면 가능한 시간대로 계산한다.
    *   4. 가능한 시간대를 가지고 있는 배열과, 그 배열인덱스의 시간을 담고 있는 배열을  각각 map에 넣고  그 맵을 list에 넣는다.
    * @param paramMap 관리자가 고른 pt일정의 날짜, 회원, 트레이너, 수업종류
    * @return List<EgovMap> 가능한 시간대체크 배열과 그 시간대를 표시한 배열이 담긴  list
    */
   @Transactional
   @Override
   public List<EgovMap> selectTimeServiceList(Map<String, Object> paramMap)
         throws Exception {
      
      // 트레이너 근무시간 뽑아온다.
      HashMap<String,String> workTime =  scheduleMapper.selectTrainerWorkTime(paramMap);
      
      // 근무시작시간, 근무종료시간
      String workStartTm = workTime.get("WORK_START_TM");
      String workFinishTm = workTime.get("WORK_FINISH_TM");
      
      paramMap.put("workStartTm", workStartTm);
      paramMap.put("workFinishTm", workFinishTm);
      
      // 해당 날짜 안의 회원의 일정 리스트
      List<HashMap<String, String>> memberClassList =  scheduleMapper.selectMemberClass(paramMap);
      // 해당 날짜에 걸치는 회원의 일정 리스트
      List<HashMap<String, String>> memberOutClassList =  scheduleMapper.selectMemberOutClass(paramMap);      
      // 근무시간안의 트레이너 일정 리스트
      List<HashMap<String, String>> trainerClassList =  scheduleMapper.selectTrainerClass(paramMap);
     
      
      SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
      Date d1 = format.parse(workFinishTm);
      Date d2 = format.parse(workStartTm);

      long diffMinutes = (d1.getTime() - d2.getTime()) / (60 * 1000); //수업이 차있는 시간을 체크해 주기 위해  milliseconds -> minute -> minute/10 = 시작 index(배열 한 칸마다 10분)
      int arrSize = (int) (diffMinutes/10);
      
      // 불가능한 시간대를 체크할 배열 선언(0,1)
      int[] availableTimetable = new int[arrSize];
      
      // 근무시간을 10분단위로 보여주기위한 배열
      // 근무시간을 10분으로 쪼갠 배열 선언
      // 근무시간 시작부터 10분씩 더해서  배열에 넣어준다 
      String[] timeTable = new String[arrSize]; 
      String myTime = String.valueOf(workTime.get("WORK_START_TM"));
      SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
      Date d = df.parse(myTime); 
      Calendar cal = Calendar.getInstance();
      cal.setTime(d);

      for (int i = 0; i < timeTable.length; i++) {
         if(i==0 ) {
        	// 처음 시간은 10분을 더하지 않는다
            String newTime = df.format(cal.getTime());
            timeTable[i] = newTime;   
         } else {
        	// 첫번째 인덱스 이후 부터는 10분씩 증가시킨다. 
            cal.add(Calendar.MINUTE, 10);
            String newTime = df.format(cal.getTime());
            timeTable[i] = newTime;            
         }
      }
      
      // 회원일정 체크해서 배열에 해당시간에 1넣기 (시작시간기준)
      for(HashMap<String,String> memberClass : memberClassList) {
    	  
    	  //index 구하기                  
          int index = getIndex(String.valueOf(memberClass.get("START_DTM")), workStartTm);
     	 
          //PT_CODE -> int ptTime
          int ptTime = Integer.parseInt(memberClass.get("PT_CODE"));
          //타임테이블에 체크하기 
          checkOnTimeTable(availableTimetable, index, ptTime);
      }
      
      // 회원일정 체크해서 배열에 해당시간에 1넣기 (종료시간기준)
      for(HashMap<String,String> memberClass : memberOutClassList) {
          
    	  //시작 index는 무조건 0 : 계산 필요 없음                  
          int index = 0;
          
          //PT_CODE -> int ptTime
          int ptTime = Integer.parseInt(String.valueOf(memberClass.get("PT_CODE")));
          //타임테이블에 체크하기 
          checkOnTimeTable(availableTimetable, index, ptTime);

      }
      
      // 트레이너일정 체크해서 배열에 해당시간에 1넣기 (시작시간기준)
      for(HashMap<String,String> trainerrClass : trainerClassList) {
    	  
    	  //index 구하기                  
         int index = getIndex(String.valueOf(trainerrClass.get("START_DTM")), String.valueOf(workTime.get("WORK_START_TM")));
    	 
         //PT_CODE -> int ptTime
         int ptTime = Integer.parseInt(trainerrClass.get("PT_CODE"));
         //타임테이블에 체크하기 
         checkOnTimeTable(availableTimetable, index, ptTime);

      }
      
      // 불가능한 시간대를 체크한 배열과 그 배열의 시간을담은 배열
      EgovMap scheduleChkMap = new EgovMap();
      // 리턴값들을 담을  list 선언
      List<EgovMap> schduleChkList = new ArrayList<EgovMap>();
      
      // 가능한 시간대 배열
      scheduleChkMap.put("availableTimetable",availableTimetable);
      scheduleChkMap.put("timeTable",timeTable);
      schduleChkList.add(scheduleChkMap);
      
      // 가능한시간대배열과, 그배열에 해당하는 시간이 담긴 list
      return schduleChkList;
   }


   /**
	 * 수업등록이 가능한 시간인지 확인한다.
	 * @param paramMap 선택한 수업일시, 트레이너, pt종류, 회원ID
	 * @return 확인결과
	 */
    @Transactional
	@Override
	public String selectChkPickDTService(Map<String,Object> paramMap) throws Exception {
   	
	   	// 결과값 저장
	   	List<HashMap<String, String>> resultList = null;
	   	// 리턴 결과값 저장
	   	String result = "";
	   	
	   	try {
	   		// 트레이너 근무시간 뽑아온다.
	        HashMap<String,String> workTime =  scheduleMapper.selectTrainerWorkTime(paramMap);
	        
	        // 수업이 끝나는 시간이 트레이너 근무시간 안인지 확인한다.
	        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd kk:mm:ss");
			//요청시간을 Date로 parsing 후 time가져오기
			Date WORK_FINISH_TM = dateFormat.parse(workTime.get("WORK_FINISH_TM"));
			Date chkPickDT = dateFormat.parse((String) paramMap.get("chkPickDT"));
			long reqDateTime = WORK_FINISH_TM.getTime();
			long chkPickDateTime = chkPickDT.getTime();
			int aa = Integer.parseInt((String) paramMap.get("ptCode"));
			//분으로 표현
			long minute = (reqDateTime - chkPickDateTime) / 60000;
			
			// 트레이너 근무시간 안이면 수업일정이 겹치는 체크
	        if(minute > aa) {
	        	
	        	// 선택한일시 등록가능 확인
		   		resultList = scheduleMapper.selectChkPickDTService(paramMap);
		   		// 돌아오는 값이 없다면 선택한 수업일시는 가능한 시간
		   		if(resultList == null || resultList.size()==0) {
		   			// 가능
		   			result = "success";
		   		} else {
		   			// 불가능
		   			result = "notAvailable";
		   		}
		   		
		   	// 근무시간을 넘으면 불가능 리턴	
	        } else {
	        	// 불가능
	   			result = "notAvailable";
	        }
	        
	   	} catch(Exception e) {
	   		// 확인 불가능
	   		result = "fail";
	   	}
	   	
	   	return result;
	}

   /**
    * 수업을 등록한다
    * 등록된 회원의 해당 회원의 pt횟수를 -1 한다
    * @return 등록결과
	* @exception Exception
    */
    @Transactional
	@Override
	public String insertNewClass(Map<String, Object> paramMap) throws Exception {
		String result = "";
		
		try {
			// 수업을 등록
	   		scheduleMapper.insertNewClass(paramMap);
	   		// 회원pt횟수 감소
	   		scheduleMapper.updateMbrPtCnt(String.valueOf(paramMap.get("mbrId")));
	   		
	   	} catch(Exception e) {
	   		result = "fail";
	   	}
		
		return result;
	}

    /**
	 * 일정을 삭제한다.
	 *  1. 회원 pt횟수 추가
	 *  2. 일정 삭제
	 * @param chk_info - 삭제할 일정의 관리번호가 담긴 List
	 * @exception Exception
	 */
    @Transactional
	@Override
	public void deleteSchedule(List<String> chk_info) throws Exception {
		
    	HashMap<String,String> temp;
    	
		for(int i=0; i < chk_info.size() ; i++) {
			
			// selectkey 사용을 위한 임시 temp맵 
			temp = new HashMap<String,String>();
			// 관리번호 맵에 담기
			temp.put("mngNo",chk_info.get(i));
			
			// 회원 PT횟수 추가
			scheduleMapper.mbrPtCntPlus(temp);
			// 일정 삭제
			scheduleMapper.deleteSchedule(chk_info.get(i));
		}
	}

    /**
	 * 수업일지를 수정한다.
	 * @param dailyLog - 수업 일지가 담긴 map
	 * @return 수업일지 수정 결과
	 * @exception Exception
	 */
    @Transactional
	@Override
	public String updateDailyLogService(Map<String,Object> dailyLogMap) throws Exception {
		
		// 수업일지를 저장할 변수 선언
		String result = "";
		
		// 수업일지 수정하고 그 결과 값
		int updateRslt = scheduleMapper.updateDailyLogService(dailyLogMap);
		
		// 수정 성공시 success 리턴
		if(updateRslt > 0) {
			result = "success";
		// 수정 실패 시 noUpdate 리턴
		} else {
			result = "noUpdate";
		}
		return result;
	}
   
    
    
    private int getIndex(String ptStartTime, String workStartTime) throws ParseException {
   	 /* 수업 시작시간 - 근무시작시간 = 근무시작시간에서 수업시작시간까지의 시간차 -> 인덱스 */
    	
       //시분초 포맷
       SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
       Date d1 = null;
       Date d2 = null;
       //d1 : 수업시작시간 ,  d2 : 근무시작시간
       d1 = format.parse(ptStartTime);
       d2 = format.parse(workStartTime);

       long diffMinutes = (d1.getTime() - d2.getTime()) / (60 * 1000); //수업이 차있는 시간을 체크해 주기 위해  milliseconds -> minute -> minute/10 = 시작 index(배열 한 칸마다 10분)
       
       // 수업시작시간 - 근무시작시간을 뺀 시간 = 비는 시간을 10분단위로 자른다.
       int index = (int) (diffMinutes/10);
       
       return index;
   }

    
    private void checkOnTimeTable(int[] availableTimetable, int index, int ptTime) {
    // 트레이너 근무시간 일 때만 배열인덱스를 가져온다 : index가 0보다 작으면 수업시작시간이 근무시작시간 전이기 때문에 체크할 필요 없음 ;
    	
    	if(index>=0) {
        	 for(int i=index; i<(index+ptTime/10+1); i++) { //한칸에 10분 , 수업시간 30분 그리고 휴식시간 10분까지해서 총 4칸(40분) 체크
                 availableTimetable[i] = 1;
                 if(i == (availableTimetable.length-1)) break; //수업시간이 근무시간을 넘어가면 체크 불필요(게다가  arrayOutofIndex 에러남)
              } 
         }
    }

}