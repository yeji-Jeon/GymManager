<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %> 
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
  /**
  * @Class Name : checkIn.jsp
  * @Description : 출석체크 화면
  * @Modification Information
  *
  *   수정일         수정자                   수정내용
  *  -------    --------    ---------------------------
  *  2019.05.23            최초 생성
  *
  * author 전예지
  * since 2019.05.23
  *
  * Copyright (C) All right reserved.
  */
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<jsp:include page="/WEB-INF/jsp/egovframework/example/cmmn/default-head.jsp" flush="true"/> 
		<!--===============================================================================================-->
		<link rel="stylesheet" type="text/css" href="/css/util.css">
		<link rel="stylesheet" type="text/css" href="/css/main.css">
		<!--===============================================================================================-->
	</head>	
    <body>
 <script>
	
 	// 출석체크 관련 함수
	var checkIn = {
 			// 출석체크 클릭 시
			checkMbr : function() {
				// input값이 빈값이 아니라면
				if($("[name='mbrId']").val().length > 0) {
					// 회원ID존재여부를 확인
					$.ajax({
						url : "mbrChk.do",
	            		data : "mbrId=" + $("[name='mbrId']").val(),
	            		dataType : "text",
	            		async :false,
	            		type : "POST",
	            		success : function(data) {
	            			console.log(data);
	            			if(data == "fail") {
	            				alert("회원조회에 실패하였습니다.");
	            			} else if(data == "noMbr"){
	            				alert(" 등록되지 않은 아이디이거나, 아이디를 잘못 입력하셨습니다.");
	            			} else {
	            				
	            				// 존재 한다면 input에 id값을 저장한다.
	            				$("[name='rowMbrId']").val(data);
	            				// 회원 상세페이지로 submit
	            				checkIn.pageSubmitFn();
	            			} 
	            		},
	            		
	            		error : function(data) {
	            			alert("회원조회 중 오류가 발생하였습니다.");
	            		}
					})
				}
			},
			
			pageSubmitFn : function() {
				// 입력값 삭제하기, 뒤로 돌아가기 했을때 아이디 삭제를 위해
				$("#mbrIdInput").val("");
				
				// 회원정보보기페이지로 이동
				$("#checkIn").attr("action","/user/userPage.do")	;
				$("#checkIn").submit();
			}
	}
 </script>
  <form id="checkIn" method="post" action="/user/userPage.do">
  <input type="hidden"	name="rowMbrId" value=""/>
  </form>
    <!-- page container area start -->
   <div class="limiter">
		<div class="container-login100">
			<div class="wrap-login100 p-t-85 p-b-20">
				<form class="login100-form validate-form">
					<span class="login100-form-title p-b-23">
						YEJI'S GYM
					</span>
					<div class="wrap-input100 validate-input m-t-85 m-b-35" data-validate = "회원ID 입력">
						<input class="input100" type="text" name="mbrId" onkeyup="this.value=this.value.replace(/[^0-9]/g,'');"
						onfocusout="this.value=this.value.replace(/[^0-9]/g,'');" id="mbrIdInput" value="">
						<span class="focus-input100" data-placeholder="회원 ID"></span>
					</div>
					<div class="container-login100-form-btn">
						<input type="button" class="login100-form-btn" onclick="checkIn.checkMbr()" value="출석체크">
						</input>
					</div>
				</form>
			</div>
		</div>
	</div>		
     <!-- page container area end -->
     <!-- bootstrap 4 js -->
  	<!--  <script src="/assets/js/popper.min.js"></script> -->
  	 <script src="/assets/js/bootstrap.min.js"></script>
 <!--  	 <script src="/assets/js/owl.carousel.min.js"></script> 
  	 <script src="/assets/js/metisMenu.min.js"></script>
  	 <script src="/assets/js/jquery.slimscroll.min.js"></script>
  	 <script src="/assets/js/jquery.slicknav.min.js"></script>
  	 <script src="/js/datepicker_ko.js"></script>  -->
	
  	 <!-- others plugins -->
  	<!--  <script src="/assets/js/plugins.js"></script>
  	 <script src="/assets/js/scripts.js"></script> 
  	 <script src="/js/paging.js"></script> -->
  	 <!-- main.js -->
	 <script src="/js/checkIn-main.js"></script>
  </body>
</html>