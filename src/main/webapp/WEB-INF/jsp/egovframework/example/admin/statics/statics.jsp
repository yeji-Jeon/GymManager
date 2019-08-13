<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %> 
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
  /**
  * @Class Name : statics.jsp
  * @Description : 통계 화면
  * @Modification Information
  *
  *   수정일         수정자                   수정내용
  *  -------    --------    ---------------------------
  *  2019.05.22            최초 생성
  *
  * author 전예지
  * since 2019.05.22
  *
  * Copyright (C) All right reserved.
  */
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
  <head>
	<jsp:include page="/WEB-INF/jsp/egovframework/example/cmmn/default-head.jsp" flush="true"/>
  </head>	
  <body>
  <script>
	 
	 $(function() {
		 // 초기화 
		 staticMng.init();
	 });
	 
	 // 통계화면 조작
	 var staticMng = {
			 
		 // 초기화 
		 init : function() {
			 
			 // 통계정보를 못 가져왔을 때 에러메시지가 있음
			 var erroMsg = "${erroMsg}";
			 
			 // 에러메세지 존재시 alert창 띄움
			 if(erroMsg != "") {
				 alert(erroMsg);
			 }
		 }
	 }
 </script>
 
    <!-- page container area start -->
    <div class="page-container">
    
	 	<form id="trainerLists" action="/admin/trainerLists.do" method="post">
        <!-- sidebar menu area start -->
        <jsp:include page="/WEB-INF/jsp/egovframework/example/cmmn/default-left.jsp" flush="true"/>
        <!-- sidebar menu area end -->
        <!-- main content area start -->
        
        <div class="main-content">
        
            <!-- header area start -->
            <div class="header-area">
                <div class="row align-items-center">
                    <!-- nav -->
                    <div class="col-md-6 col-sm-8 clearfix">
                        <div class="nav-btn pull-left">
                            <span></span>
                            <span></span>
                            <span></span>
                        </div>
                    </div>
                </div>
            </div>
            <!-- header area end -->
            
            <!-- page title area start -->
             <div class="page-title-area">
                <div class="row align-items-center">
                    <div class="col-sm-6">
                        <div class="breadcrumbs-area clearfix">
                			<div class="page-header float-left">
	                   			 <div class="page-title">
	                        		<h1>통계</h1>
			                     </div>
		                	</div>
		            	
                        </div>
                    </div>
                </div>
            </div>
            <!-- page title area end -->
            <div class="main-content-inner">
            	<div class="content mt-3">
            		<div class="animated fadeIn">
	            		<div class="row" style="margin-top:209px;">
	                    	<div class="col-md-4" style="margin-left: 173px;">
		                    	<table class="table">
			                    	<tr><td>회원권 종료 회원 수</td><td>${staticMap.end}명</td></tr>
			                    	<tr><td>회원권 정상 회원 수 </td><td>${staticMap.normal}명</td></tr>
			                    	<tr><td> 회원권 임박 회원 수 </td><td>${staticMap.almost}명</td></tr>
			                    	<tr style="border-top-color:lightseagreen;border-top-style: double;"><td>총 회원 수</td><td> ${staticMap.mbrCnt}명</td></tr>
		                    	</table>
	                    	</div>
	                    	<div class="col-md-4">
	                    		<table class="table">
		                    		<tr><td>  PT 사용권 있는 회원 수</td><td> ${staticMap.ptmbr}명</td></tr>
				                    <tr><td>  트레이너 수</td><td> ${staticMap.tcnt}명</td></tr>
			                    </table>
	                    	</div>
						</div>
           		    </div><!-- .animated -->
       		     </div><!-- .content --> 
       		  </div>
     	 <!-- main content area end -->
	      </form> 
	   </div>
      <!-- page container area end -->
   
    <!-- bootstrap 4 js -->
    <script src="/assets/js/popper.min.js"></script>
    <script src="/assets/js/bootstrap.min.js"></script>
    <script src="/assets/js/owl.carousel.min.js"></script>
    <script src="/assets/js/metisMenu.min.js"></script>
    <script src="/assets/js/jquery.slimscroll.min.js"></script>
    <script src="/assets/js/jquery.slicknav.min.js"></script>

  
    <!-- others plugins -->
    <script src="/assets/js/plugins.js"></script>
    <script src="/assets/js/scripts.js"></script> 
</body>
</html>