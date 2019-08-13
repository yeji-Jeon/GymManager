<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
  /**
  * @Class Name : memberDetail.jsp
  * @Description : 회원 상세 화면
  * @Modification Information
  *
  *   수정일         수정자                   수정내용
  *  -------    --------    ---------------------------
  *  2019.05.17            최초 생성
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
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>회원 상세보기</title>
		<jsp:include page="/WEB-INF/jsp/egovframework/example/cmmn/default-head.jsp" flush="true" />
	</head>
	<!-- Main css -->
	<link rel="stylesheet" href="/css/style.css">
	<link href="//netdna.bootstrapcdn.com/bootstrap/3.1.0/css/bootstrap.min.css" rel="stylesheet" id="bootstrap-css">
	
	<!-- <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/css/bootstrap.min.css"> -->
	
	<!-- JS -->
	<script src="/vendor/jquery-validation/dist/jquery.validate.min.js"></script>
	<script src="/vendor/jquery-validation/dist/additional-methods.min.js"></script>
	<script src="/js/main.js"></script>
	<script src="/js/datepicker_ko.js"></script>
	<script src="//netdna.bootstrapcdn.com/bootstrap/3.1.0/js/bootstrap.min.js"></script>
	<script src="/js/jquery.bpopup.min.js"></script>
	<script src="/js/paging.js"></script>
	<script>
	
	$(function() {
		// 디폴트 세팅
		defaultSet.init();
		// 게시판 더블클릭 이벤트
		schedule.tableDoubleclik();
	});

	/************************************************************
		defaultSet 페이지가 실행될 때 디폴트 세팅
		currPagination - 회원일정 게시판 페이징
		pageSubmit 페이지 submit모음(목록/수정/삭제) 
	 ************************************************************/
	 
	/*************************************************************************************************
	 	defaultSet의 각각의 함수 설명.
	 	init - 초기화 세팅 모음
	**************************************************************************************************/

	var defaultSet = {
		
		// 초기화 세팅
		init : function() {
			// 페이징 세팅
			currPagination.pageBtn();
		}
	}

	/*************************************************************************************************
		 currPagination의 각각의 함수 설명. - 회원일정 게시판 페이징
		 pageBtn - 페이지가 그려 질 떼 페이징 생성시킨다.
		 pageSubmit - 페이징버튼 클릭한 것에 따른 처리 및 submit
	**************************************************************************************************/
	// paging처리 모음
	var currPagination = {
		
			// 페이징 생성
			pageBtn : function() {
				// 전체 데이터 수
				var totalMbrCnt = "${scheduleLists.scheduleListCtn}";
				// 페이지 당 보여줄 데이터 개수
				var rowCnt =  5;
				// 페이지 그룹 범위
				var pageSize = 5;
				// 현재페이지
				var currPage = "${param.pageNum}";
				 
				if(currPage == "") {
					 currPage = $("[name='pageNum']").val();
				} else {
					$("[name='pageNum']").val(currPage);
				}
				
				if(totalMbrCnt != "" && totalMbrCnt != "0") {
					
					// 페이지 함수 호출
					// Paging(전체데이터수,페이지당 보여줄 데이타수,페이지 그룹 범위,현재페이지 번호)
					pagination.paging(totalMbrCnt,rowCnt,pageSize,currPage);
				}
			},
			
			/* @param - 페이징의 누른 input버튼 구별 */
			pageSubmit : function(param) {
				
				// 현재 페이지 값을 가져온다.
				var currPage =  $("[name='pageNum']").val();
				 
				// 페이징 버튼에 따라서 보낼 현재 페이지값을 넣어준다.
				// 처음버튼 클릭시
				if(param == "first") {
					 $("[name='pageNum']").val("1");
				// 이전 버튼 클릭시	
				} else if(param == "previous") {
					currPage--;
					$("[name='pageNum']").val(currPage);
				// 다음 버튼 클릭 시	
				} else if(param == "next") {
					currPage++;
					$("[name='pageNum']").val(currPage);
				// 끝 버튼 클릭 시	
				} else if(param == "last") {
					$("[name='pageNum']").val(pageValues.endPage);
				// 페이지 번호 클릭 시	
				} else {
					currPage = param;
					$("[name='pageNum']").val(currPage);
				}
				
				$("#mbrDetailFrm").submit();
			}
	}	
	
	
	/*************************************************************************************************
	 	schedule의 각각의 함수 설명.
	  	회원 배정된 일정 확인 관련 함수모음
	 
	  	tableDoubleclik - 일정관리 게시판을 두번클릭 시, 수업일지 팝업창가능여부를 체크하고 팝업창을 띄움
	**************************************************************************************************/
	
	// 회원 일전관리 게시판 이벤트 관련모음
	var schedule = {
		
		// 일정 게시판 두번 클릭 시 이벤트
		tableDoubleclik : function() {
			
			// 일정 갯수
			var totSchedule = "${scheduleLists.scheduleListCtn}";
			
			// 일정이 1개 이상이라면
			if(totSchedule > 0) {
				// 게시판을 더블클릭 했을 때
				$("tbody").on("click","tr",function() {
					
					// 클릭한 일정의 관리번호
					var mngNO = $(this).children("td").eq(0).text();
					
					// 클릭한 일정의 시작일시를 date로 변환
					var old = new Date($(this).children("td").eq(3).text()),
						now = new Date();
					
					// 시작일시와 현재시간의 차이를 시, 분, 초로 나눔
					var hours = Math.floor((now - old) / 36e5),
				   		minutes = Math.floor((now - old) % 36e5 / 60000),
				   		seconds = Math.floor((now - old) % 60000 / 1000);
					
					// 클릭한 일정의 시작일시가 현재시간 이후라면
					if(hours < 0 || minutes < 0 || seconds < 0 ) {
						// 수업일지를 볼 수 없다
						alert("수업일지는 수업중일때부터 열람가능합니다.");
					} else {
						
						// 수업일지 팝업창
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
				            			$(".popupContent").html(data);
				            		},
				            		
				            		error : function(data) {
				            			alert("수업일지를 가져오는데 오류가 발생");
				            		}
				            	})
				            }, 
				            onClose: function() { 
				            }
						});
					}
				})
			}
		}
	}
	</script>
	<body>
		<div class="main">
			<section class="signup">
				<div class="container">
					<div class="signup-content">
						<form method="post" id="mbrDetailFrm" action="/user/userPage.do" style="margin-left:230px;margin-right:55px;">
						
							<div class="form-row">
								<div class="col-md-12">
									<h1>${memberInfo.memberInfo.mbrNm} 회원님 어서오세요!</h1>
								</div>
							</div>
							<div class="form-row">
								<div class="col-md-3">
									<div class="col-md-8">
										<Strong><label for="birth_date">회원권 남은일자</label></Strong>
									</div>
									<div class="col-md-4">${memberInfo.memberInfo.mbrDday}일</div>
								</div>
								<div class="col-md-3">
									<div class="col-md-7">
										<Strong><label for="re_password">남은 PT횟수</label></Strong>
									</div>
									<div class="col-md-4">${memberInfo.memberInfo.mbrPtCnt}회</div>
								</div>
							</div>
							<div class="form-row">
                               	<div class="col-md-12">
                               		<div class="col-md-2">
                               			<label for="password">사물함 배정정보</label>
	                                </div>
		                        	<div class="col-md-5">
										<div class="" style="overflow:auto;max-height:131px;">
			                               	<c:forEach items="${memberInfo.cabinetInfo}" var="cabinetInfo">
				                               	<div class="row">
				                               		<div class="col-md-12">
				                               			<label for="">${cabinetInfo.cabId} 번 (만료일 : ${cabinetInfo.cabFinishDt})</label>
													</div>
				                               	</div>
			                               	</c:forEach>
			                            </div>
			                         </div>
		                        </div>
		                    </div>
							<div class="form-row" style="width:70%;margin-bottom:4px">
		                        <table id="" class="table table-hover table-bordered">
		                             <thead>
		                                <tr> 
		                                	 <th class="hide">관리번호</th>
		                                     <th>트레이너ID</th>
		                                     <th>PT종류</th>
		                                     <th>시작일시</th>
		                                     <th>종료일시</th>
		                                     <th>상태</th>
		                                 </tr>
		                             </thead>
		                             <tbody>				
		                                 <c:choose>
		                             		<c:when test="${!empty scheduleLists.scheduleLists}">
		                             		  <c:forEach items="${scheduleLists.scheduleLists}" var="scheduleLists">
		                             		  	<tr>
		                             		  		<td class="hide"><c:out value="${scheduleLists.mngNo}"></c:out></td>
		                             		  		<td><c:out value="${scheduleLists.trId}"></c:out></td>
		                             		  		<td><c:out value="${scheduleLists.ptCode}"></c:out></td>
		                             		  		<td><c:out value="${scheduleLists.startDtm}"></c:out></td>
		                             		  		<td><c:out value="${scheduleLists.finishDtm}"></c:out></td>
		                             		  		<td><c:out value="${scheduleLists.status}"></c:out></td>
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
		                    </div>
		                    <div class="form-row">
		                    	<div class="col-md-2">
		                        	보기
		                            <c:choose>
										 <c:when  test="${fn:length(scheduleLists.scheduleLists) > 0}">
										 	<c:forEach items="${scheduleLists.scheduleLists}" var="schedule" varStatus= "status">
										 		<c:if test="${status.first}">
										 			<fmt:parseNumber var="rnum" value="${schedule.rnum}" integerOnly="true"></fmt:parseNumber>
													<c:out value="${rnum}"/>
													- 
												</c:if>
												<c:if test="${status.last}">
													<fmt:parseNumber var="rnum" value="${schedule.rnum}" integerOnly="true"></fmt:parseNumber>
													<c:out value="${rnum}"/> 
												</c:if>
											</c:forEach>
										 	 / 전체 ${scheduleLists.scheduleListCtn} 명
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
	                        <div class="form-row">
	                        	* 수업일지는 수업진행중 또는 종료 후에 확인하실 수 있습니다.
	                        </div>
							<input type="hidden" name="chk_info" class="" value="${param.rowMbrId}" />
							<input type="hidden" name="currPage" class="" value="${param.currPage}" /> 
							<input type="hidden" name="rowMbrId" value="${param.rowMbrId}" />
							<input type="hidden" name="pageNum" value="1" />
						</form>
					</div>
				</div>
			</section>
		</div>
		<div id="popupLayer">
			<div class="b-close" style="font-size:large;">X</div>
	      		<p style="font-size: 29px;">수업일지</p>
	        <div class="popupContent"></div>
	    </div>
	</body>
</html>