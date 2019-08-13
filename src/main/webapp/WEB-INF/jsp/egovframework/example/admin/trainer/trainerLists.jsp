<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %> 
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
  /**
  * @Class Name : trainerLists.jsp
  * @Description : 트레이너 목록 화면
  * @Modification Information
  *
  *   수정일         수정자                   수정내용
  *  -------    --------    ---------------------------
  *  2019.05.18            최초 생성
  *
  * author 전예지
  * since 2019.05.18
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
			var trainerListsCnt = "${trainerListsCnt}";
			// 페이지 당 보여줄 데이터 개수
			var rowCnt =  $("[name='rowCnt']").val();
			// 페이지 그룹 범위
			var pageSize = 5;
			// 현재 페이지 번호
			var currPage = $("[name='currPage']").val();
			
			if(trainerListsCnt != "" && trainerListsCnt != "0") {
				
				// 페이지 함수 호출
				// Paging(전체데이터수,페이지당 보여줄 데이타수,페이지 그룹 범위,현재페이지 번호)
				pagination.paging(trainerListsCnt,rowCnt,pageSize,currPage);
			}
		},
		
		/* 
		@param - 페이징의 누른 input버튼 구별값 
		*/
		pageSubmit : function(param) {
			
			// 이전 검색조건으로 검색조건을 유지시킨다.
			pageHold.existParam();
			
			 // 쿼리스트링을 보내기위해 변수에 값을 넣어준다.
			 var searchCon = $("[name='searchCon']").val();
			 var searchText = $("[name='searchText']").val();
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
			 location.href = "/admin/trainerLists.do?searchCon=" + searchCon + "&searchText=" + searchText + "&rowCnt=" + rowCnt
		     + "&currPage=" + currPage + "&pageName=trainer";;
			
		},
		
		// 트레이너 삭제 전 미래 페이지 미리 계산
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
			 
			// 조회 실패 메세지
			var searcherrorMsg = "${searcherrorMsg}";
			if(searcherrorMsg != "") {
				alert(searcherrorMsg);
			}
			
			 // 페이징 세팅
			 currPagination.pageBtn();
		},
		
		// 모든 펑션을 모아두고 한번에 불러온다.
		pageEvent : function() {
			this.searchChange();
			this.talbeOneClick();
			this.deleteAllChkBox();
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
		
		
		// 검색조건이 변할 때 마다 입력이 가능한 조건인지 확인.
		searchChange : function() {
			
			$("[name='searchCon']").change(function() {
				/* 검색조건이 전체조회가 아니라면 검색입력창에 입력이 가능하다. */
				 if($("[name='searchCon']").val() != 0) {
					 $("[name='searchText']").removeAttr("readonly");
				 } else {
					 $("[name='searchText']").attr("readonly",true); 
				 }
			})
		},
		
		// 가져온 트레이너데이터가 있다면, 테이블을 한번클릭 할 때 그  row가 active 된다.
		talbeOneClick : function() {
			
			var trainerListsCnt = "${trainerListsCnt}";
			
			if(trainerListsCnt.length > 0) {
				$("table > tbody").on("click","tr",function() {
					 var $this = $(this);
 	        		
	        		 // 이미 눌렀던 row라면 액티브 해제
	       		 	if($this.hasClass("active")) {
	       		 		
	       		 		$this.removeClass("active");
	       		 		$("[name='rowTId']").val("");
	       		 	// 클릭한 row 액티브 세팅
	       		 	} else {
	       		 		// 모든 하이라이트 해제
						$("tbody").find("tr").removeClass("active");
						// 클릭한 row 액티브
						 $this.addClass("active");
						// 클릭한 트레이너ID input에 담긴다.
						$("[name='rowTId']").val($this.find("td").eq(1).text());
	       		 	}
				});
			}
		},
		
		// 초기화 버튼 클릭시 모든 조건의 값을 초기화 시킨다.
		conditionClear : function() {
			
			//첫번째 페이지로 설정
			$("[name='currPage']").val("1");
			$("[name='searchCon']").val("0");
			$("[name='rowCnt']").val(10);
			$("[name='searchText']").val("");
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
		}
	};
	
 	/**********************************************
	 pageChange의 각각의 함수 설명.
	 searchFn - 조회, 등록, 삭제 , 상세보기 버튼을 클릭 시, 조건을 설정하고 submit을 한다.
	 oneDeletePageCal - 트레이너상세보기에서 삭제를 대비해서 미리 페이지 계산
	**********************************************/
	
	var pageChange = {
 			
 		// param : 조회, 등록, 삭제 , 상세보기 버튼
		searchFn : function(param) {
			
			//조회 클릭시
			if(param == "search") {
				//첫번째 페이지로 설정
				$("[name='currPage']").val(1);
				// 조회를 클릭했음을 input에 저장
				$("[name='clickBtn']").val("조회");
				$("#trainerLists").attr("action","/admin/trainerLists.do");
				$("#trainerLists").submit();
				
			} else if(param == "add") {
				
				/*
				 * 트레이너 상세보기, 삭제, 등록페이지로 넘어갈 때, 검색조건이 함께 넘어간다. 
				 * 검색 조건을 유지시키기 위해  이전 검색조건을 넘기는 값으로 넣어준다.
				 */
				pageHold.existParam();
				
				// 트레이너 등록페이지로 넘어간다.
				$("#trainerLists").attr("action","/admin/trainerAdd.do");
				$("#trainerLists").submit();
				
			} else if(param == "delete") {
				
				// 삭제 할 트레이너 클릭하였는지 확인
				if($("[name='chk_info']").is(":checked")) {	
					
					// 삭제할 트레이너의 ID의 를 추출
					var TId = "";
					// 삭제 불가능한 트레이너 ID를 저장할 변수 선언
					var notDeleteId = "";
					
					$("[name='chk_info']:checked").parents("tr").each(function() {
						
						// pt이력이 존재 한다면  삭제불가능
						if($(this).find("td").eq(7).text() > 0 ) {
							// 체크된 트레이너 체크해지
							$(this).find("input").prop("checked",false);
							// 삭제 불가능한 트레이너Id 를 저장
							notDeleteId = notDeleteId + $(this).find("td").eq(1).text() + "번 ";
						} else {
							// 삭제가능한 트레이너Id를 저장
							TId = TId + $(this).find("td").eq(1).text() + "번  ";
						}
					})
					// 삭제 불가능한 트레이너 Id 알리기
					if(notDeleteId.length > 0) {
						alert("트레이너 ID " + notDeleteId + "은 배정된 일정이 있어서 삭제가 불가능합니다.");						
					}
					
					// 삭제할 Id가 있다면 삭제
					if(TId.length > 0) {
						// 삭제 여부 묻기
						if(confirm("트레이너ID " + TId + " 삭제하시겠습니까? *경고* 트레이너의 정보가 데이터베이스에서 완전삭제가 진행됩니다. 추후 데이터복구가 불가능합니다.")) {
							/*
							 * 트레이너 상세보기, 삭제, 등록페이지로 넘어갈 때, 검색조건이 함께 넘어간다. 
							 * 검색 조건을 유지시키기 위해  이전 검색조건을 넘기는 값으로 넣어준다.
							 */
							pageHold.existParam();
							// 삭제 전 미래 페이지 계산
							currPagination.deleteChkBox();
							
							// 트레이너이 삭제되고 트레이너목록으로 돌아간다.
						
						$("#trainerLists").attr("action","/admin/trainerDelete.do");
						$("#trainerLists").submit();
						
						}
					}
				} else {
					alert("삭제할 트레이너의 체크박스들을 클릭해주세요.")
				}
				
			} else if(param == "detail") {
				
				if($("[name='rowTId']").val().length > 0) {
					
					/*
					 * 트레이너 상세보기, 삭제, 등록페이지로 넘어갈 때, 검색조건이 함께 넘어간다. 
					 * 검색 조건을 유지시키기 위해  이전 검색조건을 넘기는 값으로 넣어준다.
					 */
					pageHold.existParam();

					/*
					 * 트레이너상세보기에서 트레이너을 삭제하고 트레이너목록으로 돌아오게 될 때,
					 * 원래 보고있던 페이지가 마지막 페이지고 상세보기트레이너을 삭제하면 서 그 페이지의 트레이너이 한명도 없어질때를 생각해서
					 * 트레이너 상세보기로 넘기기 전에 페이지 계산을 해서 넘겨준다.
					 */
					$("#trainerLists").append("<input type='hidden' name='oneDeletePageNum' value='" + this.oneDeletePageCal() + "'/>")
					
					// 트레이너상세보기 페이지로 넘어간다.
					$("#trainerLists").attr("action","/admin/trainerDetail.do");
					$("#trainerLists").submit();
				} else {
					alert("상세보기 할 트레이너를 클릭해주세요");
				}
			}
		},
		
		//트레이너상세보기에서 삭제를 대비해서 미리 페이지 계산
		oneDeletePageCal : function() {
			// 총 페이수 계산
			var totPageCnt = Math.floor((pageValues.totalMbrCnt - 1) / pageValues.rowCnt);
			
			if((pageValues.totalMbrCnt - 1)  % pageValues.rowCnt > 0) {
		    	totPageCnt++;
		    }
			
			// 현재 페이지가 토탈페이지 보다 크고 첫페이지가 아니라면 계산한 총 페이지를 리턴
			if($("[name='currPage']").val() > totPageCnt) {
				if($("[name='currPage']").val() != 1) {
					return totPageCnt;
				}
			} else {
				return $("[name='currPage']").val();
			}
		}
	};
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
	                        		<h1>트레이너목록</h1>
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
	                                     		<input type="button" name="searchBtn" class="btn btn-outline-primary" onclick="pageChange.searchFn('search')" value="조회"></input>	
	                                     		<input type="button" name="addBtn" class="btn btn-outline-primary"  onclick="pageChange.searchFn('add')" value="등록"></input>	
	                                     		<input type="button" name="deleteBtn" class="btn btn-outline-primary"  onclick="pageChange.searchFn('delete')" value="삭제"></input>	
	                                     		<input type="button" name="detailBtn" class="btn btn-outline-primary"  onclick="pageChange.searchFn('detail')" value="상세보기"></input>
	                                       		<button class="btn" onclick="pageHold.conditionClear()">초기화</button>
	                                        </div>
	                                     </div>
                                     </div>
	                            	<div class="form-inline">
		                                <div class="form-group" >
		                                    	<select name="rowCnt" class="custom-select custom-select-sm form-control form-control-sm" style="width:100px;">
			                                    	<option value="5">5</option>
			                                    	<option value="10" selected>10</option>
			                                    	<option value="15">15</option>
			                                    	<option value="20">20</option>
		                                    	</select> 
	                                        <select name="searchCon" class="form-control-sm form-control" style="width:121px;">
	                                            <option value="0">전체조회</option>
	                                            <option value="1">트레이너ID</option>
	                                            <option value="2">트레이너명</option>
	                                        </select>
	                                         <div class="form-group">
		                                   		<input type="text" class="input-sm form-control-sm form-control" name="searchText" maxlength="20" readonly>
		                                     </div> 
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
	                                            <th>트레이너ID</th>
	                                            <th>이름</th>
	                                            <th>성별</th>
	                                            <th>근무시작시간</th>
	                                            <th>근무종료시간</th>
	                                            <th>총 수업 횟수</th>
	                                        </tr>
	                                    </thead>
	                                    <tbody>
	                                        <c:choose>
	                                    		<c:when test="${!empty trainerLists}">
	                                    		  <c:forEach items="${trainerLists}" var="trainerLists">
	                                    		  	<tr>
	                                    		  		<td>
	                                    		  			 <div class="custom-control custom-checkbox">
										                		<input type="checkbox" onclick="event.cancelBubble=true" name="chk_info" class="deleteChk" value="${trainerLists.trId}">
										              		</div>
										              	</td>
	                                    		  		<td><c:out value="${trainerLists.trId}"></c:out></td>
	                                    		  		<td><c:out value="${trainerLists.trNm}"></c:out></td>
	                                    		  		<td><c:out value="${trainerLists.trGender}"></c:out></td>
	                                    		  		<td><c:out value="${trainerLists.workStartTm}"></c:out></td>
	                                    		  		<td><c:out value="${trainerLists.workFinishTm}"></c:out></td>
	                                    		  		<td><c:out value="${trainerLists.totcnt}"></c:out>회</td>
	                                    		  		<td style="display:none"><c:out value="${trainerLists.future}"></c:out></td>
	                                    		  	</tr>
	                                    		  </c:forEach>
	                                    		</c:when>
	                                    		<c:otherwise>
	                                    		  <tr>
	                                    		  	<td colspan="10"> 조회된 트레이너가 없습니다.</td>
	                                    		  </tr>
	                                    		</c:otherwise>
	                                    	</c:choose>
	                                    </tbody>
	                                </table>
	                                <div class="row">
		                               	<div class="col-md-6">
		                               		보기
		                               		<c:choose>
											<c:when  test="${fn:length(trainerLists) > 0}">
											 	<c:forEach items="${trainerLists}" var="trainer" varStatus= "status">
											 		<c:if test="${status.first}">
											 			<fmt:parseNumber var="rnum" value="${trainer.rnum}" integerOnly="true"></fmt:parseNumber>
														<c:out value="${rnum}"/>
														- 
													</c:if>
													
													<c:if test="${status.last}">
														<fmt:parseNumber var="rnum" value="${trainer.rnum}" integerOnly="true"></fmt:parseNumber>
														 <c:out value="${rnum}"/> 
													</c:if>
												</c:forEach>
											 	 / 전체 ${trainerListsCnt} 명
											 </c:when >
											 <c:otherwise>
											  	 0 - 0 / 전체 0 명
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
      <input type="hidden" name="rowTId"/>
      <input type="hidden" name="currPage" value="1"/>
      <input type="hidden" name="clickBtn" value=""/>
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
    <script src="/js/datepicker_ko.js"></script>

  
    <!-- others plugins -->
    <script src="/assets/js/plugins.js"></script>
    <script src="/assets/js/scripts.js"></script> 
</body>
</html>