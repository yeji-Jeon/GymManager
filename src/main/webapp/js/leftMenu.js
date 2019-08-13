/**
 * 
 */

	$(function() {
		
		// 레프트메뉴 하이라이트 처리
		leftNav.hLFn();
		leftNav.pageSub();
	})
	// 레프트 메뉴 하이라이트와 submit함수 모음
	var leftNav = {
			 
		 // 레프트 메뉴 하이라이트 처리
		 hLFn : function() {
			 // 레프트메뉴 클릭 한 페이지 
			 var pageParam = "${param.pageName}";
			 var pageParam = $('[name=pageName]').val();
			 
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
			 // 이번달 일정관리 클릭 시 
			 } else if (pageParam == "schedule") {
				 $(".schedule").addClass("active").find("ul").addClass("in");
			 }
		 },
		 
		 /*
		 page 넘김
		 @param menu - 클릭한  a태그의 메뉴
		 */
		 pageSub : function(menu) {
			 
			 // input값으로 페이지이름을 넣는다
			 $("[name='pageName']").val(menu);
			 
			 // 회원 관리 클릭시
			 if(menu === "member") {
				 $("#trainerLists").attr("action","/admin/member.do");
				 $("#trainerLists").submit();
			 // 트레이너 관리 클릭시 
			 } else if (menu === "trainer") {
				 
				 $("#trainerLists").attr("action","/admin/trainerLists.do");
				 $("#trainerLists").submit();
			 // 이번달 일정관리 클릭 시 
			 } else if (menu === "schedule") {
				 
				 $("#trainerLists").attr("action","/admin/monthSchedule.do");
				 $("#trainerLists").submit();
			 }
		 }
	 }