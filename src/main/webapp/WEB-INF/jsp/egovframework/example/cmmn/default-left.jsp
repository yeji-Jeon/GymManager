<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
  /**
  * @Class Name : default-left.jsp
  * @Description : 레프트 네비 화면
  * @Modification Information
  *
  *   수정일         수정자                   수정내용
  *  -------    --------    ---------------------------
  *  2019.05.14            최초 생성
  *
  * author 전예지
  * since 2019.05.14
  *
  * Copyright (C) All right reserved.
  */
%>
	<script type="text/javascript">
	
	$(function() {
		
		// 레프트메뉴 하이라이트 처리
		leftNav.hLFn();
	})
	// 레프트 메뉴 하이라이트와 submit함수 모음
	var leftNav = {
			 
		 // 레프트 메뉴 하이라이트 처리
		 hLFn : function() {
			 // 레프트메뉴 클릭 한 페이지 
			 var pageParam = "${paramMap.pageName}";
			 var paramMap = "${paraMap}";
			 // 하이라이트 삭제
			 $("#menu").find("li").removeClass("active");
			 // 하위메뉴 닫기
			 $("#menu").find("collapse").removeClass("in");
			 
			 // 회원관리 클릭시
			 if(pageParam == "member") {
				 $(".member").addClass("active").find("ul").addClass("in");
			 // 트레이너 관리 클릭시 
			 } else if (pageParam == "trainer") {
				 $(".trainer").addClass("active").find("ul").addClass("in");
			 // 일정관리 클릭 시 
			 } else if (pageParam == "schedule") {
				 $(".schedule").addClass("active").find("ul").addClass("in");
			 // 통계 클릭 시
			 // 통계는 1depth만 존재
			 } else if (paramMap == "statics") {
				 $(".statics").addClass("active");
			 }
		 }
	 }
	 </script>

		<div class="sidebar-menu">
            <div class="sidebar-header">
                <div class="logo">
                    <a href="#" onclick="location.href='/admin/main.do'"><img src="/images/egovframework/cmmn/logo_mini.png" alt="logo"></a>
                </div>
            </div>
            <div class="main-menu">
                <div class="menu-inner">
                    <nav>
                        <ul class="metismenu" id="menu">
                            <li class="member">
                                <a href="javascript:void(0)" aria-expanded="true"><i class="ti-dashboard"></i><span>회원</span></a>
                                <ul class="collapse">
                                    <li class="member"><a href="javascript:void(0)" onclick="location.href='/admin/member.do'">회원관리</a></li>
                                </ul>
                            </li>
                            <li class="trainer">
                                <a href="javascript:void(0)" aria-expanded="true"><i class="ti-dashboard"></i><span>트레이너
                                    </span></a>
                                <ul class="collapse">
                                    <li class="trainer"><a href="javascript:void(0)" onclick="location.href='/admin/trainerLists.do'">트레이너관리</a></li>
                                </ul>
                            </li>
                            <li class="schedule">
                                <a href="javascript:void(0)" aria-expanded="true"><i class="ti-dashboard"></i><span>일정관리</span></a>
                                <ul class="collapse">
                                   <!--  <li class="schedule"><a href="javascript:void(0)" onclick="leftNav.pageSub('schedule')">이번달 배정일정 관리</a></li> -->
                                    <li class="schedule"><a href="javascript:void(0)" onclick="location.href='/admin/schedule.do'">이번달 배정일정 관리</a></li>
                                </ul>
                            </li>
                            <li class="statics"><a href="javascript:void(0)" onclick="location.href='/admin/statics.do'"><i class="ti-pie-chart"></i><span>통계</span></a></li>
                        </ul>
                    </nav>
                </div>
            </div>
        </div>