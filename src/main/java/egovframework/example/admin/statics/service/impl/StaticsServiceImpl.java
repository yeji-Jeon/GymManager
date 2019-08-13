package egovframework.example.admin.statics.service.impl;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import egovframework.example.admin.member.service.impl.MemberMapper;
import egovframework.example.admin.statics.service.StaticsService;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @Class Name : StaticsServiceImpl.java
 * @Description : 통계 서비스 구현
 * @Modification Information
 * @
 * @  수정일      수정자              수정내용
 * @ ---------   ---------   -------------------------------
 * @ 2019.05.22          최초생성
 *
 * @author  전예지
 * @since 2019.05.22
 * @version 1.0
 * @see
 *  
 */

@Service
public class StaticsServiceImpl implements StaticsService {

	/** StaticsMapper */
	@Resource
	private StaticsMapper staticsMapper;
	
	/**
	 * 통계정보를 가져온다
	 * @return 통계정보가 담긴 egovmap (회원수,정상회원수,만료회원수,임박회원수,트레이너수)
	 * @exception Exception
	 */
	@Override
	public EgovMap selectStaticsMapService() throws Exception {
		return staticsMapper.selectStaticsMapService();
	}

}
