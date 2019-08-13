<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %> 
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
  /**
  * @Class Name : trainerUpdate.jsp
  * @Description : 트레이너 수정 화면
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
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<jsp:include page="/WEB-INF/jsp/egovframework/example/cmmn/default-head.jsp" flush="true"/>
    <!-- Main css -->
	<link rel="stylesheet" href="/css/style.css">
	<link href="//netdna.bootstrapcdn.com/bootstrap/3.1.0/css/bootstrap.min.css" rel="stylesheet" id="bootstrap-css">
	<script src="http://dmaps.daum.net/map_js_init/postcode.v2.js"></script>
	<script src="/js/daum_address_api.js"></script>
	<script language="javascript" src="https://ajax.aspnetcdn.com/ajax/jQuery/jquery-3.3.1.min.js"></script>
	<!-- <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/css/bootstrap.min.css"> -->
</head>

<script>
	$(function() {
		defaultSet.init();
		validation.valEvent();
	});
	
	/************************************************************
		defaultSet 페이지가 실행될 때 디폴트 세팅
	************************************************************/
	
	/************************************************************
	defaultSet 페이지가 실행될 때 디폴트 세팅\
	init - 최초 생성시 초기화
	setting- 트레이너 정보 세팅
	************************************************************/
	var defaultSet = {
			
		init : function() {
			// 올바른형식입력메세지 숨김
			$(".errorText").hide();
			
			// 필수입력 메세지 숨김
			$(".must").hide();
			
			// 미래에 배정된 일정 갯수
			var futureSchedule = "${trainerInfo.future}";
			
			// 미래에 배정된 일정이 있다면
			if(futureSchedule != "" && futureSchedule != "0") {
				// 근무시간 수정불가
				$(".time").prop("disabled",true);
				// 근무시간 수정불가 메세지 띄움
				$("#workingTime").prepend("<div style='color:red;'>배정된 일정이 있으므로 근무시간 변경불가능합니다.</div>");
			}
			
			// 정보 세팅
			this.setting();
		},
		
		// 트레이너 정보 세팅
		setting : function() {
			
			// 트레이너 성별 세팅
			var gender = "${trainerInfo.trGender}";
			
			if(gender == "F") {
				$("#female").prop("checked",true);
			} else {
				$("#male").prop("checked",true);
			}
			
			// 근무시간 세팅
			// 근무시작시간
			var Stime = "${trainerInfo.workStartTm}";
			var Shour = Stime.substring(3,5);
			var sMinute = Stime.substring(7,9);
			var pmAmS = Stime.substring(0,2);
			$("[name='sHour']").val(Shour);
			// 자정일때는 00 으로 디폴트세팅
			if(pmAmS == "AM" && Shour == "12") {
				$("[name='sHour']").val("00");
			}
			$("[name='sMinute']").val(sMinute);
			// 근무종료시간
			var ftime = "${trainerInfo.workFinishTm}";
			var pmAmF = ftime.substring(0,2);
			var fhour = ftime.substring(3,5);
			var fMinute = ftime.substring(7,9);
			$("[name='fHour']").val(fhour);
			// 자정일때는 00 으로 디폴트세팅
			if(pmAmF == "AM" && fhour == "12") {
				$("[name='fHour']").val("00");
			}
			$("[name='fMinute']").val(fMinute);
			
		}
	}
	
	/************************************************************
		validationFn 설명 유효성관련
		valEvent - 유효성 이벤트 모음
		validationFn - 유효성 검사 함수
		maxLengthCheck - 입력창 총 길이 제한
		beforeMustSubmitFn - 수정하기전 필수입력 체크
		beforeSelectSubmitFn - submit전에 유효성 검사
	************************************************************/	
	
	// 유효성 관련  
	var validation = {
			
		// 모든 함수 모음
		valEvent : function() {
			validation.validationFn();
		},
		
		// 유효성 검사 함수
		validationFn : function() {
			// 트레이너이름 정규식
			var tNm = RegExp(/^[ㄱ-ㅎ|가-힣|a-z|A-Z|\*]+$/);
			// 휴대폰 정규식
			var cellNo = /^(01[016789]{1})([0-9]{3,4})([0-9]{4})$/;

			/******************************
				필수 입력란 유효성 검사
			*******************************/
			
			// 트레이너이름 유효성검사
			// focusout
			$("[name='tNm']").focusout(function() {
				var $this = $(this);
				
				// 입력을 했다면
				if($this.val().length > 0) {
					// 필수입력 메세지 숨기기
					$this.nextAll("div").eq(1).hide();
					
					// 올바른 입력이 아니라면
					if(!tNm.test($this.val())) {
						// 올바른 입력이 아니라는 메세지 표시
						$this.next("div").show();
						// 입력한 값 삭제
						$this.val("");
					} else {
						$this.next("div").hide();
					}
				} else {
					// 입력을 안했다면 필수입력이라고 알리기
					$this.next("div").hide();
					$this.nextAll("div").eq(1).show();
				}
				
			});
			// 트레이너 이름 검사
			// keydown
			$("[name='tNm']").keydown(function() {
				var $this = $(this);
				
				// 입력을 했다면
				if($this.val().length > 0) {
					// 올바른 입력이 아니라면
					if(!tNm.test($this.val())) {
						// 입력 값 삭제
						$this.val("");
					} 
				}
			});
			
			// 휴대폰 유효성 검사
			$("[name=phone_number]").focusout(function(e) {
				var $this = $(this);
				
				// 숫자만 입력가능
				$this.val($this.val().replace(/[^0-9]/g,''));
				
				// 입력을 했다면
				if($this.val().length > 0) {
					$this.nextAll("div").eq(1).hide();
					
					// 올바른 입력이 아니라면
					if(!cellNo.test($this.val())) {
						// 올바른 입력이 아니라는 메세지 표시
						$this.next("div").show();
					} else {
						// 올바른 입력이라면 메세지 숨기기
						$this.next("div").hide();
					}
				} else {
					// 입력을 안했다면 필수입력이라고 알리기
					$this.next("div").hide();
					$this.nextAll("div").eq(1).show();
				}
					
			});
			
		},
		
		// 필수 입력 
		beforeMustSubmitFn : function() {
			
			// 필수입력 체크를 위한 변수
			var cnt = 0;
			
			/* 필수 입력 확인*/
			// 트레이너 이름
			if($("[name='tNm']").val().length == 0) {
				$("[name='tNm']").nextAll("div").eq(1).show();
				cnt++;
			}
			// 트레이너 휴대폰 번호
			if($("[name=phone_number]").val().length == 0) {
				$("[name=phone_number]").nextAll("div").eq(1).show();
				cnt++;
			}
			
			// 필수입력이 하나라도 체크 안되있다면 false 리턴
			if(cnt > 0 ) {
				return false;
			} else {
				return true;
			}
		},
		
		// submit 전 유효성 체크
		beforeSelectSubmitFn : function() {
			// 트레이너 이름 정규식
			var tNm = RegExp(/^[ㄱ-ㅎ|가-힣|a-z|A-Z|\*]+$/);
			// 휴대폰번호 정규식
			var cellNo = /^(01[016789]{1})([0-9]{3,4})([0-9]{4})$/;
			
			// 트레이너이름 유효성 체크
			if(!tNm.test($("[name='tNm']").val())) {
				$(this).nextAll("div").eq(1).show();
				return false;
			}
			
			// 휴대폰번호 유효성 체크
			if(!cellNo.test($("[name=phone_number]").val())) {
				$(this).nextAll("div").eq(1).show();
				return false;
			}
			
			return true;
		}
	};
	
	/******************************************************************************************
	updateMbr 수정버튼 클릭시 모음
	updateSubmitFn - 수정버튼 submit
	*******************************************************************************************/
	
	// 수정버튼 클릭 시
	var updateMbr = {
		/*
		@param 클릭한 input button의 구별인자
		*/
		updateSubmitFn : function(page) {
			
			if(page = "update") {
				// 필수체크확인
				if(validation.beforeMustSubmitFn()) {
					// 유효성 체크
					if(validation.beforeSelectSubmitFn()) {
						$(".time").prop("disabled",false);
						// 트레이너 수정하고 트레이너 목록페이지로 이동
						$("#tAddFrm").attr("action","/admin/trainerRealUpdate.do");
						$("#tAddFrm").submit();
					}
				}
			}
		}
	}
</script>
<body>
	 <div class="main">
        <section class="signup">
            <!-- <img src="images/signup-bg.jpg" alt=""> -->
            <div class="container">
                <div class="signup-content">
                    <form method="post" id="tAddFrm" action="/admin/trainerLists.do">
                    <div class="form-row" style="padding-bottom:35px;color:red;">
                   		 <div class="col-md-6">*는 필수 입력입니다.</div>
                    </div>
                     <div class="form-row">
                    	<div class="col-md-6">
                            <label for="last_name">트레이너ID</label>
                            <div class="col-md-8" style="padding-left: 6px;">
                           		 <input type="text" class="form-input nodisable" name="tId" value="${trainerInfo.trId}" readonly/>
                            </div>
                        </div>
                    </div>
                    <div class="form-row">
                        <div class="form-group">
                            <label for="first_name">*트레이너명</label>
                            <input type="text" class="form-input required" name="tNm"
                            onkeyup ="this.value=this.value.replace(/[^a-zA-Zㄱ-ㅎ|ㅏ-ㅣ|가-힣]/g,'');" value="${trainerInfo.trNm}"
                            onfocusout ="this.value=this.value.replace(/[^a-zA-Zㄱ-ㅎ|ㅏ-ㅣ|가-힣]/g,'');" maxlength="20" placeholder="'문자만 입력가능합니다/ 최대 20자" />
                            <div class="errorText" style="color:red;">문자입력만 가능합니다.</div>
                            <div class="must" style="color:red;">필수입력입니다.</div>
                        </div>
                        <div class="form-radio">
                            <label for="gender">*성별</label>
                            <div class="form-flex">
                                <input type="radio" name="gender" value="M" id="male" checked="checked" />
                                <label for="male">남자</label>

                                <input type="radio" name="gender" value="F" id="female" />
                                <label for="female">여자</label>
                            </div>
                        </div>
                    </div>
                    <div class="form-row">
                    	<div class="col-md-6">
                            <label for="last_name">우편번호</label>
                            <div class="col-md-8" style="padding-left: 6px;">
                           		 <input type="text" class="form-input nodisable" name="post" id="sample4_postcode" value="${trainerInfo.trPostCode}" readonly/>
                            </div>
                            <div class="col-md-4" style="padding-right:6px;padding-left:4px;">
                            	 <input type="button" onclick="addressPopup()" value="우편번호 찾기"><br>
                            </div>
                        </div>
                    </div>
                     <div class="form-row">
                        <div class="form-group">
                            <label for="last_name">도로명주소</label>
                            <input type="text" class="form-input nodisable" name="RoadAddress" id="sample4_roadAddress" value="${trainerInfo.trRoadAddress}" readonly/>
                        </div>
                        <div class="form-group">
                            <label for="last_name">상세주소</label>
                            <input type="text" class="form-input" name="detailAddress" id="sample4_detailAddress" maxlength="20" value="${trainerInfo.trDtlAddress}"  placeholder="'최대20자 입력가능"/>
                        </div>
                     </div>
                     <div class="form-row">
                        <div class="col-md-6 cellNo">
                            <label for="phone_number">*휴대폰번호</label>
                            <input type="text" class="form-input required" name="phone_number" id="phone_number"
                            onkeyup ="this.value=this.value.replace(/[^0-9]/g,'');" onfocusout="this.value=this.value.replace(/[^0-9]/g,'');"
                            maxlength='11'  placeholder="'-' 없이 숫자만 입력가능합니다"  value="${trainerInfo.trCellno}"/>
                            <div class="errorText" style="color:red;">올바른 형식으로 입력해주세요</div>
                            <div class="must" style="color:red;">필수입력입니다.</div>
                        </div>
                     </div>
                     <div class="form-row"  id="workingTime">
                     </div>
                     <div class="form-row">
                        <div class="form-group col-md-6">
                            <label for="hour">원래 근무시작시간</label>
                            <div class="col-md-3"><c:out value="${trainerInfo.workStartTm}"/></div>
                         </div>
                         <div class="form-group col-md-6">
                            <label for="birth_date">원래 근무종료시간</label>
                            <div class="col-md-3"><c:out value="${trainerInfo.workFinishTm}"/></div>
                         </div>
                       </div>
                     <div class="form-row">
                        <div class="form-group col-md-6">
                            <label for="hour">*근무시작시간</label>
                            <div class="col-md-2">
	                            <select name="sHour" class="time custom-select form-control" style="width:84px;height : calc(2.25rem + 10px);">
									<c:forEach var="i" begin="0" end="23" step="1" varStatus ="status">
										<option value='<fmt:formatNumber pattern="00" value="${i}"/>' ><fmt:formatNumber pattern="00" value="${i}"/></option>
									</c:forEach>
                                </select> 
                             </div>
                             <div class="col-md-1">시</div>
                             <div class="col-md-2">
                                <select name="sMinute" class="time form-control" style="width:84px;height : calc(2.25rem + 10px);">
                                    <option value="00">00</option>
                                    <option value="10">10</option>
                                    <option value="20">20</option>
                                    <option value="30">30</option>
                                    <option value="40">40</option>
                                    <option value="50">50</option>
                                </select>
                            </div>
                            <div class="col-md-1">분</div>
                         </div>
                         <div class="form-group col-md-6">
                            <label for="birth_date">*근무종료시간</label>
                            <div class="col-md-2">
	                            <select name="fHour" class="time custom-select form-control" style="width:84px;height : calc(2.25rem + 10px);">
                                  	<c:forEach var="i" begin="0" end="23" step="1" varStatus ="status">
										<option value='<fmt:formatNumber pattern="00" value="${i}"/>' ><fmt:formatNumber pattern="00" value="${i}"/></option>
									</c:forEach>
                                </select> 
                            </div>
                            <div class="col-md-1">시</div>
                            <div class="col-md-2">
                                <select name="fMinute" class="time form-control" style="width:84px;height : calc(2.25rem + 10px);">
                                    <option value="00">00</option>
                                    <option value="10">10</option>
                                    <option value="20">20</option>
                                    <option value="30">30</option>
                                    <option value="40">40</option>
                                    <option value="50">50</option>
                                </select>
                            </div>
                            <div class="col-md-1">분</div>
                         </div>
                       </div>
                       <div class="form-row">
                       	<div class="col-md-5">
                           	<input type="button" onclick="updateMbr.updateSubmitFn('update')" class="form-submit" value="수정"/>
                           </div>
                           <div class="col-md-3">
                          		<input type="submit"  class="form-submit" value="목록"/>
                           </div>
                       </div>
                            <input type="hidden" name="searchCon" class="" value="${param.searchCon}"/>
                            <input type="hidden" name="searchText" value="${param.searchText}" />
                            <input type="hidden" name="rowCnt" class="" value="${param.rowCnt}"/>
                            <input type="hidden" name="currPage" class="" value="${param.currPage}"/>
                        	<input type="hidden" name="pageName" value="trainer"/>
                    </form>
                </div>
            </div>
        </section>

    </div>

    <!-- JS -->
    <script src="/vendor/jquery/jquery.min.js"></script>
    <script src="/vendor/jquery-ui/jquery-ui.min.js"></script>
    <script src="/vendor/jquery-validation/dist/jquery.validate.min.js"></script>
    <script src="/vendor/jquery-validation/dist/additional-methods.min.js"></script>
    <script src="/js/main.js"></script>
    <script src="/js/datepicker_ko.js"></script>
    <script src="//netdna.bootstrapcdn.com/bootstrap/3.1.0/js/bootstrap.min.js"></script>
    
</body>
</html>