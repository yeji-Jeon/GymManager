<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %> 
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
  /**
  * @Class Name : scheduleList.jsp
  * @Description : 일정관리 목록 화면
  * @Modification Information
  *
  *   수정일         수정자                   수정내용
  *  -------    --------    ---------------------------
  *  2019.05.20            최초 생성
  *
  * author 전예지
  * since 2019.05.20
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
  <script src="/js/paging.js"></script>
  <script>
	 
	 $(function() {
		 
		 // 페이지 로딩시 세팅해야할 것들
		 pageHold.init();
		 // 이벤트 발생시 처리 함수 모음
		 pageHold.pageEvent();
	 });
	 
	/************************************************************************************************
	 pageChange이 되는지 안되는지에 따라서 객체 리터럴로 나눔.
		- pageHold - 테이블에서 발생하는 이벤트들을 모아둠.
		- submit - submit되는 버튼을 클릭했을 때 일어나는 이벤트를 모아둠.
		- currPagination - paging처리 
	**************************************************************************************************/
	
	/*************************************************************************************************
	 currPagination의 각각의 함수 설명. paging처리 함수
	 pageBtn - 페이지가 그려 질 떼 페이징 생성시킨다.
	 pageSubmit - 페이징버튼 클릭한 것에 따른 처리 및 submit
	 deleteChkBox - 트레이너삭제전 미리 페이지 계산해서 input에 넣어줌
	**************************************************************************************************/
	
	// paging처리 모음
	var currPagination = {
		
		// 페이징 생성
		pageBtn : function() {
			
			// 전체 데이터 수
			var schedListsCnt = "${schedListsCnt}";
			// 페이지 당 보여줄 데이터 개수
			var rowCnt =  $("[name='rowCnt']").val();
			// 페이지 그룹 범위
			var pageSize = 5;
			// 현재 페이지 번호
			var currPage = $("[name='currPage']").val();
			
			if(schedListsCnt != "" && schedListsCnt != "0") {
				
				// 페이지 함수 호출
				// Paging(전체데이터수,페이지당 보여줄 데이타수,페이지 그룹 범위,현재페이지 번호)
				pagination.paging(schedListsCnt,rowCnt,pageSize,currPage);
			}
		},
		
		/* 
		@param - 페이징의 누른 input버튼 구별값 
		*/
		pageSubmit : function(param) {
			
			// 이전 검색조건으로 검색조건을 유지시킨다.
			pageHold.existParam();
			
			 // 쿼리스트링을 보내기위해 변수에 값을 넣어준다.
			 var rowCnt = $("[name='rowCnt']").val();
			 var currPage = $("[name='currPage']").val();
			 
			 // 페이징 버튼에 따라서 보낼 현재 페이지값을 넣어준다.
			 // 처음버튼 클릭시
			 if(param == "first") {
				currPage = 1;
			 // 이전 버튼 클릭시	
			 } else if(param == "previous") {
				currPage--;
			 // 다음 버튼 클릭 시	
			 } else if(param == "next") {
				currPage++;
			 // 끝 버튼 클릭 시	
			 } else if(param == "last") {
				currPage = pageValues.endPage;
			 // 페이지 번호 클릭 시	
			 } else {
				currPage = param;
			 }
			 
			 // 누른페이징 버튼의 페이지로 이동한다.
			 location.href = "/admin/schedule.do?rowCnt=" + rowCnt
		     + "&currPage=" + currPage + "&pageName=schedule";;
			
		},
		
		// 일정 삭제 전 미래 페이지 미리 계산
		deleteChkBox : function() {
			
			// 총 페이지 계산
			var totPageCnt = Math.floor((pageValues.totalMbrCnt - $("[name='chk_info']:checked").length) / pageValues.rowCnt);
			
			if((pageValues.totalMbrCnt - $("[name='chk_info']:checked").length)  % pageValues.rowCnt > 0) {
		    	totPageCnt++;
		    }
			
			if($("[name='currPage']").val() > totPageCnt) {
				if($("[name='currPage']").val() != 1) {
					$("[name='currPage']").val(totPageCnt);
				}
			}
		}
	}
	
	
	/*******************************************************************************************************************
	 pageHold의 각각의 함수 설명.
	 init - 페이지가 로딩 될 때, 초기화 시켜야 될 이벤트들의 모음
	 pageEvent - 이벤트 발생 시, 각각의 이벤트를 모두 모아두는 역할
	 searchChange - 검색조건(전제초죄, 트레이너ID, 트레이너명)이 변할 때 마다  전체조회를 제외하고 검색입력창에 입력이 가능하다.
	 talbeOneClick - 테이블을 한번 클릭할 때, 그 한줄의 css처리와 트레이너ID를 저장한다.
	 conditionClear- 초기화 버튼 클릭시, 모든 검색조건을 초기화 시킨다.
	 deleteAllChkBox - 트레이너삭제 전체 체크박스 이벤트
	*********************************************************************************************************************/
	
 	var pageHold = {
		
		// 페이지가 뜰 때 생겨야 하는 일들
		init : function() {
			
			// 이전 검색조건 세팅
			this.existParam();
			// 결과메세지  alert
			this.resultMsg();
			
			/* 검색조건이 전체조회가 아니라면 검색입력창에 입력이 가능하다. */
			 if($("[name='searchCon']").val() == 0) {
				 $("[name='searchText']").attr("readonly",true); 
			 } else {
				 $("[name='searchText']").removeAttr("readonly");
			 }
			
			 // 페이징 세팅
			 currPagination.pageBtn();
		},
		
		// 모든 펑션을 모아두고 한번에 불러온다.
		pageEvent : function() {
			this.talbeOneClick();
			this.deleteAllChkBox();
			this.logSave();
		},
		
		// 결과 메세지 세팅
		resultMsg : function() {
			
			// 조회 실패 메세지
			var searcherrorMsg = "${paramMap.searcherrorMsg}";
			if(searcherrorMsg != "") {
				alert(searcherrorMsg);
			}
			
			// 조회 성공 메세지
			var clickBtn = "${paramMap.clickBtn}";
			if(clickBtn == "조회") {
				alert("조회되었습니다.");
			}
			// 삭제,수정,등록 완료메세지
			var successMsg = "${paramMap.successMsg}";
			// 성공메세지를 띄운다.
			if(successMsg != "") {
				alert(successMsg);
			}
			
			// 조회,삭제,수정,등록에서 에러가 났을때
			var erroMsg = "${paramMap.errorMsg}";
			// 에러메세지를 띄운다.
			if(erroMsg != "") {
				alert(erroMsg);
			}	
		},
		
		// 이전 검색조건이 세팅
		existParam : function() {
			// 검색 조건
			 var searchCon = "${paramMap.searchCon}";
			 // 검색 값
			 var searchText = "${paramMap.searchText}";
			 // 보여줄 트레이너 갯수
			 var rowCnt = "${paramMap.rowCnt}";
			 // 현재페이지 조건
			 var currPage = "${paramMap.currPage}";
			 
			// 이미 디폴트 세팅이 되어 있어서 이전 값이 있을 때만 세팅
			 if(searchCon != "") {
				 $("[name='searchCon']").val(searchCon);
			 }
			 
			 if(rowCnt != "") {
				 $("[name='rowCnt']").val(rowCnt);
			 }
			 if(currPage != "") {
				 $("[name='currPage']").val(currPage);
			 }
			 
			 // 디폴트 세팅이 빈값이라 이전값이 있던 없던 값을 넣어줘도 상관없다.
			 $("[name='searchText']").val(searchText);
		},
		
		
		// 가져온 일정데이터가 있다면, 테이블을 한번클릭 할 때 그  row가 active 된다.
		talbeOneClick : function() {
			
			var schedListsCnt = "${schedListsCnt}";
			
			if(schedListsCnt.length > 0) {
				$("table > tbody").on("click","tr",function() {
					 var $this = $(this);
	        		 // 이미 눌렀던 row라면 액티브 해제
	       		 	if($this.hasClass("active")) {
	       		 		
	       		 		$this.removeClass("active");
	       		 		$("[name='rowSId']").val("");
	       		 	// 클릭한 row 액티브 세팅
	       		 	} else {
	       		 		// 수업일정 예정이라면 클릭 불가
	       		 		if($this.find("td").eq(9).text() != "예정") {
		       		 		// 모든 하이라이트 해제
							$("tbody").find("tr").removeClass("active");
							// 클릭한 row 액티브
							 $this.addClass("active");
							// 클릭한 트레이너ID input에 담긴다.
							$("[name='rowSId']").val($this.find("td").eq(1).text());
	       		 		} else {
	       		 			alert("예정중인 수업은 선택할 수 없습니다.");
	       		 		}
	       		 	}
				}); 
			}
		},
		
		// 체크 박스 전체 클릭 이벤트
		deleteAllChkBox : function() {
			 // 삭제 전체 체크박스
	    	$("#checkall").click(function () {
    	      var chk = $(this).is(":checked");
    			if (chk) {
    	            $("input[type=checkbox]").each(function () {
    	                $(this).prop("checked", true);
    	            });
    	        } else {
    	            $("input[type=checkbox]").each(function () {
    	                $(this).prop("checked", false);
    	            });
    	        }
			});
		},
		
		/*****************************************************************
		 			수업일지 저장
		**********************************************************************/
		// 수업일지 저장
		logSave : function() {
			
			// 팝업창의 저장클릭 시
			$(document).on("click","#logSave",function() {
				// 수업일지를 저장한다.
				$.ajax({
					url : "/admin/dailyLogSave.do",
            		data : JSON.stringify({
            			dailyLog :  $("#logContent").val(),
            			mngNo : $("[name='rowSId']").val()
            			}),
            		dataType : "text",
            		contentType: "application/json",
            		async :false,
            		type : "post",
            		success : function(data) {
            			console.log(data);
            			if(data == "success") {
            				alert("수업일지를 저장하였습니다.");
            			} else if(data == "noUpdate") {
            				alert("저장된 수업일지가 없습니다.");
            			} else {
            				alert("수업일지를 저장하지 못하였습니다.");
            			}
            		},
            		
            		error : function(data) { console.log(data);
            			alert("수업일지를 저장하지 못하였습니다.");
            		}
				})
			})
		}
	};
	
 	/********************************************************************
	 scheduleMng의 각각의 함수 설명. - 수업등록, 수업일지 등록, 수업취소
	*********************************************************************/
	
	var scheduleMng = {
 			
 		// 등록버튼 클릭 시
		searchFn : function() {
			
			// 등록를 클릭했음을 input에 저장
			$("[name='clickBtn']").val("등록");
			// 수업등록
			$("#trainerLists").attr("action","/admin/scheduleAdd.do");
			$("#trainerLists").submit();
		},
		
		// 수업일지버튼 클릭 시
		dailyLog : function() {
			
			// 수업을 클릭 했다면
			if($("[name='rowSId']").val().length > 0) {
				
				// 클릭한 일정의 관리번호
				var mngNO = $("[name='rowSId']").val();
				
				// 수업일지 팝업창 뜬다.
				// 수업일지를 가져온다.
				$("#popupLayer").bPopup({
					content:'ajax',
		            contentContainer:'.popupContent',
		            follow: [false, false], //x, y
		            scrollBar : true,
		            position :['auto','auto'],
		            onOpen: function() { 
		            	$.ajax({
		            		url : "/admin/dailyLog.do",
		            		data : "mngNo=" + mngNO,
		            		dataType : "text",
		            		async :false,
		            		type : "post",
		            		success : function(data) {
		            			data = decodeURIComponent(data)	;
		            			// 디코딩된 문자열의 +를 공백으로 치환
		            			data = decodeURIComponent((data + '').replace(/\+/g, '%20'));
		            			console.log(data);
		            			$(".popupContent textarea").val(data);
		            		},
		            		
		            		error : function(data) {
		            			alert("수업일지를 가져오는데 오류가 발생");
		            		}
		            	})
		            }, 
		            onClose: function() { 
		            }
				});
			} else {
				alert("일정을 먼저 클릭해주세요");
			}
		},
		
		// 수업취소
		cancelFn : function() {
			
			// 취소 체크박스가 하나이상 클릭되어 있다면
			if($("[name='chk_info']").is(":checked")) {
				
				// 취소 불가능한 일정 갯수
				var cantCancel = 0;
				var canCancel = 0;
				
				// 체크된 열을 하나씩 체크한다.
				$("[name='chk_info']:checked").parents("tr").each(function() {
					
					// 일정이 종료되었거나 진행중이면 취소 불가능
					if($(this).find("td").eq(9).text() == "진행중" || $(this).find("td").eq(9).text() == "종료") {
						
						// 체크된 일정 체크해지
						$(this).find("input").prop("checked",false);
						cantCancel++;
						
					} else {
						canCancel++;
					}
				})
				
				// 취소 불가능 일정 알림
				if(cantCancel > 0) {
					alert("이미 종료되었거나 진행중이 일정은 취소가 불가능합니다.");
				} 
				
				// 취소 여부 묻기
				if(canCancel > 0 ) {
					if(confirm("예정인 수업을 취소하시겠습니까? 복구가 불가능합니다.")) {
						
						// 취소 전 미래 페이지 계산
						currPagination.deleteChkBox();
						// 수업 취소되고 일정목록으로 돌아간다.
						$("#trainerLists").attr("action","/admin/scheduleCancel.do");
						$("#trainerLists").submit();
					}
				}
				
			} else {
				alert("삭제할 일정의 체크박스들을 클릭해주세요.")
			}
		}
	};
 </script>
 
    <!-- page container area start -->
    <div class="page-container">
    
	 	<form id="trainerLists" action="/admin/schedule.do" method="post">
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
	                        		<h1>일정관리</h1>
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
                    	<div class="col-md-12">
	                        <div class="card">
	                            <div class="card-header ">
	                             	<div class="row">
	                                     <div class="col-sm-12">  
	                                     	<div class="pull-right button-group">   
	                                     		<input type="button" name="addBtn" class="btn btn-outline-primary"  onclick="scheduleMng.searchFn()" value="등록"></input>	
	                                     		<input type="button" name="deleteBtn" class="btn btn-outline-primary"  onclick="scheduleMng.dailyLog()" value="수업일지"></input>	
	                                     		<input type="button" name="detailBtn" class="btn btn-outline-primary"  onclick="scheduleMng.cancelFn()" value="수업취소"></input>
	                                        </div>
	                                     </div>
                                     </div>
	                            	<div class="form-inline">
		                                <div class="form-group" style="display:none;" >
		                                    	<select name="rowCnt" class="custom-select custom-select-sm form-control form-control-sm" style="width:100px;">
			                                    	<option value="5">5</option>
			                                    	<option value="10" selected>10</option>
			                                    	<option value="15">15</option>
			                                    	<option value="20">20</option>
		                                    	</select> 
		                                </div>
		                             </div>
                                    
	                           	</div> 
	                            <div class="card-body">
	                                <table id="" class="table table-hover table-bordered">
	                                    <thead>
	                                       <tr>
	                                        	<th>
		                                        	 <div class="custom-control custom-checkbox">
		                                        	 	<input onclick="event.cancelBubble=true" class="" name="chk_infoAll" type="checkbox" value="" id="checkall">
		                                           	 </div>
		                                        </th> 
	                                            <th style="display:none">관리번호</th>
	                                            <th>트레이너ID</th>
	                                            <th>트레이너 이름</th>
	                                            <th>회원ID</th>
	                                            <th>회원 이름</th>
	                                            <th>수업 종류</th>
	                                            <th>시작일시</th>
	                                            <th style="display:none">종료일시</th>
	                                            <th>상태</th>
	                                        </tr>
	                                    </thead>
	                                    <tbody>
	                                        <c:choose>
	                                    		<c:when test="${!empty schedList}">
	                                    		  <c:forEach items="${schedList}" var="schedList">
	                                    		  <c:choose>
	                                    		  		<c:when test="${schedList.status eq '예정'}">
			                                    		  	<tr style="background-color:linen;">
	                                    		  		</c:when>
	                                    		  		<c:otherwise>
		                                    		  		<tr>
	                                    		  		</c:otherwise>
	                                    		  </c:choose>	
			                                    		  		<td>
			                                    		  			 <div class="custom-control custom-checkbox">
												                		<input type="checkbox" onclick="event.cancelBubble=true" name="chk_info" class="deleteChk" value="${schedList.mngNo}">
												              		</div>
												              	</td>
			                                    		  		<td style="display:none"><c:out value="${schedList.mngNo}"></c:out></td>
			                                    		  		<td><c:out value="${schedList.trId}"></c:out></td>
			                                    		  		<td><c:out value="${schedList.trNm}"></c:out></td>
			                                    		  		<td><c:out value="${schedList.mbrId}"></c:out></td>
			                                    		  		<td><c:out value="${schedList.mbrNm}"></c:out></td>
			                                    		  		<td><c:out value="${schedList.ptCode}"></c:out></td>
			                                    		  		<td><c:out value="${schedList.workStartTm}"></c:out></td>
			                                    		  		<td style="display:none"><c:out value="${schedList.workFinishTm}"></c:out></td>
			                                    		  		<td><c:out value="${schedList.status}"></c:out></td>
			                                    		  	</tr>
	                                    		  </c:forEach>
	                                    		</c:when>
	                                    		<c:otherwise>
	                                    		  <tr>
	                                    		  	<td colspan="10"> 조회된 일정이 없습니다.</td>
	                                    		  </tr>
	                                    		</c:otherwise>
	                                    	</c:choose>
	                                    </tbody>
	                                </table>
	                                <div class="row">
		                               	<div class="col-md-6">
		                               		보기
		                               		<c:choose>
											<c:when  test="${fn:length(schedList) > 0}">
											 	<c:forEach items="${schedList}" var="schedList" varStatus= "status">
											 		<c:if test="${status.first}">
											 			<fmt:parseNumber var="rnum" value="${schedList.rnum}" integerOnly="true"></fmt:parseNumber>
														<c:out value="${rnum}"/>
														- 
													</c:if>
													
													<c:if test="${status.last}">
														<fmt:parseNumber var="rnum" value="${schedList.rnum}" integerOnly="true"></fmt:parseNumber>
														 <c:out value="${rnum}"/> 
													</c:if>
												</c:forEach>
											 	 / 전체 ${schedListsCnt} 개
											 </c:when >
											 <c:otherwise>
											  	 0 - 0 / 전체 0 개
	   										 </c:otherwise>
										</c:choose>
		                               	</div>
		                               	<div class="pull-right col-md-6">
			                                <ul class="pagination  center-block pull-right" id="pageUl" style="justify-content: center;">
			                                </ul>
		                                </div>
	                                </div>
	                            </div>
	                        </div>
                    	</div>
					</div>
           		 </div><!-- .animated -->
       		 </div><!-- .content -->
                   
         </div>
     	 <!-- main content area end -->
      <input type="hidden" name="rowSId"/>
      <input type="hidden" name="currPage" value="1"/>
      <input type="hidden" name="clickBtn" value=""/>
      <input type="hidden" name="pageName" value="${param.pageName}"/>
      </form> 
      </div>
      <!-- 팝업창 시작 -->
      <div class="schedule" id="popupLayer">
			<div class="btn b-close" style="font-size:large;">닫기</div>
			<div class="btn saveLog" id="logSave" style="font-size:large;">저장</div>
	      		<p style="font-size: 29px;">수업일지</p>
	        <div class="popupContent">
	        <textarea id="logContent" style="resize:none;width:675px;height:423px;" placeHolder="수업일지가 없습니다."></textarea></div>
	  </div>
	  <!-- 팝업창 종료 -->
      <!-- page container area end -->
   
    <!-- bootstrap 4 js -->
    <script src="/assets/js/popper.min.js"></script>
    <script src="/assets/js/bootstrap.min.js"></script>
    <script src="/assets/js/owl.carousel.min.js"></script>
    <script src="/assets/js/metisMenu.min.js"></script>
    <script src="/assets/js/jquery.slimscroll.min.js"></script>
    <script src="/assets/js/jquery.slicknav.min.js"></script>
    <script src="/js/datepicker_ko.js"></script>
	<script src="/js/jquery.bpopup.min.js"></script>
  
    <!-- others plugins -->
    <script src="/assets/js/plugins.js"></script>
    <script src="/assets/js/scripts.js"></script> 
    
</body>
</html>