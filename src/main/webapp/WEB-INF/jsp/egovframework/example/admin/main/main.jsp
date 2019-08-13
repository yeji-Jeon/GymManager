<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %> 
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
  /**
  * @Class Name : main.jsp
  * @Description : 관리자 첫 화면
  * @Modification Information
  *
  *   수정일         수정자                   수정내용
  *  -------    --------    ---------------------------
  *  2019.05.10            최초 생성
  *
  * author 전예지
  * since 2019.05.10
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
        <!-- page container area start -->
        <div class="page-container">
    
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
	                        		<h1></h1>
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
                    	<h1> 어서오세요!</h1>
                    	<h1> 예지의 헬스장 관리자 페이지입니다.!</h1>
					</div>
           		</div><!-- .animated -->
       		</div><!-- .content -->
                   
        </div>
        <!-- main content area end -->
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