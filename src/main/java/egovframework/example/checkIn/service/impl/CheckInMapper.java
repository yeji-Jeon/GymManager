package egovframework.example.checkIn.service.impl;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

@Mapper
public interface CheckInMapper {

	/**
	 * 회원ID를 조회한다. 
	 * @param mbrId 조회할 회원ID
	 * @return 회원조회
	 * @exception Exception
	 */
	String selectChcekInMbrService(String mbrId)  throws Exception;

}
