package egovframework.example.checkIn.service.impl;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import egovframework.example.checkIn.service.CheckInService;

@Service
public class CheckInServiceImpl implements CheckInService {

	/* CheckInMapper */
	@Resource
	private CheckInMapper checkInMapper;
	

	/**
	 * 회원ID를 조회한다. 
	 * @param mbrId 조회할 회원ID
	 * @return 회원존재여부;
	 * @exception Exception
	 */
	@Override
	public String selectChcekInMbrService(String mbrId) throws Exception {
		
		// 조회 결과값을 받을 변수 선언
		String result = "" ;
		
		// 회원존재여부 확인
		result = checkInMapper.selectChcekInMbrService(mbrId);
		
		// 회원이 존재하지 않는다면
		if(result == null) {
			result = "noMbr";
		} 
		
		return result;
	}

}
