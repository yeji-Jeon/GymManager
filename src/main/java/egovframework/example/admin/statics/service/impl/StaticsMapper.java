package egovframework.example.admin.statics.service.impl;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper
public interface StaticsMapper {

	/**
	 * 통계정보를 가져온다
	 * @return 통계정보가 담긴 egovmap (회원수,정상회원수,만료회원수,임박회원수,트레이너수)
	 * @exception Exception
	 */
	EgovMap selectStaticsMapService() throws Exception;

}
