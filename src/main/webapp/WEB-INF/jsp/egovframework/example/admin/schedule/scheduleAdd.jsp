<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %> 
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
  /**
  * @Class Name : scheduleAdd.jsp
  * @Description : 일정 등록 화면
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
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<jsp:include page="/WEB-INF/jsp/egovframework/example/cmmn/default-head.jsp" flush="true"/>
    <!-- Main css -->
	<link rel="stylesheet" href="/css/style.css">
	<link href="//netdna.bootstrapcdn.com/bootstrap/3.1.0/css/bootstrap.min.css" rel="stylesheet" id="bootstrap-css">
	<script src="http://dmaps.daum.net/map_js_init/postcode.v2.js"></script>
	<script src="/js/daum_address_api.js"></script>
	<script src="https://ajax.aspnetcdn.com/ajax/jQuery/jquery-3.3.1.min.js"></script>
</head>

<script>


	$(function() {
		// 디폴트 달력 초기화
		defaultSet.datePicker();
		// 트레이너 선택변경 시
		search.trainerSelect();
		// 가능한 시간대 테이블 클릭 시
		search.selectDateTime();
	});
	
	/************************************************************
	defaultSet 페이지가 실행될 때 디폴트 세팅
	datePicker - 달력 초기화
	************************************************************/
	var defaultSet = {
			
		// 달력 초기화
		datePicker :function() {
			$("#datePick").datepicker({
				dateFormat: 'yy-mm-dd' //Input Display Format 변경
		                ,showOtherMonths: true //빈 공간에 현재월의 앞뒤월의 날짜를 표시
		                ,showMonthAfterYear:true //년도 먼저 나오고, 뒤에 월 표시
		                ,changeYear: true //콤보박스에서 년 선택 가능
		                ,changeMonth: true //콤보박스에서 월 선택 가능   
		                ,showOn: "both" 
		                ,buttonImage: "/images/egovframework/calendar_mini.png"
		                ,inline: true
		                ,prevText: '이전달'
		                ,nextText: '다음달'
		                ,minDate : new Date()
			});
		}
	}
	
	// 입력하거나 클릭한 값 저장
	var inputValue = {
			mbrId : "", // 회원번호
			trId : "",  // 트레이너번호
			ptCode : "", // pt종류
			chkPickDT: "", // 등록일시
			addSchDate : "" // 날짜
	}
	
	/******************************************************************************************
	insertMbr 등록버튼 클릭시 모음
	insertSubmitFn - 등록버튼 submit
	*******************************************************************************************/
	
	// 등록버튼 클릭 시
	var insertMbr = {	
			
		/*
		@param 클릭한 input button의 구별인자
		*/
		insertSubmitFn : function(page) {
			
			// 필수 값이 있는지 
			if(search.inputAllChk()) {
				// 검색버튼 클릭했는지
				if(search.chkSeachBtnClick()) {
					// 가능한 시간대를 클릭했다면
					if($("[name='reservationDate']").val().length > 17) {
						
						// 클릭한 시간을 등록전에 다시 한번 체크
						search.selectDTajax();
						if($("[name='reservationDate']").val() != "") {
							
							//수업 등록
							$.ajax({
								url : "/admin/insertNewClass.do",
								data : JSON.stringify({
										"mbrId" : inputValue.mbrId,
										"trId" : inputValue.trId,
										"ptCode" : inputValue.ptCode,
										"chkPickDT" : inputValue.chkPickDT,
										}),
								dataType : "text",
								contentType: "application/json",
			            		async :false,
			            		type : "post",
								success : function(data) {
									alert("수업이 성공적으로 등록되었습니다.");
									
									// redirect to 일정목록
									location.href="/admin/schedule.do?currPage="+"${param.currPage}" + "&rowCnt=" + "${param.rowCnt}";
								},
								error :function() {
									alert("서버오류로 확인이 불가합니다.");
								}
							})
						}
					} else {
						alert("등록을 원하는 시간을 체크해주세요");
					}
				} else {
					alert("검색을 클릭 해주세요");
				}
			}
		}
	}
	
	/******************************************************************************************
	search 가능한 시간대 검색
	timeTable - 가능한 시간대 데이터와 해당 시간대 가능여부(0,1로 구성)
	memberSearch - 회원 찿기 버튼 클릭 시
	timeSearch -  검색버튼 클릭 시 유효성검사 후 서버로 값을 넘김
	inputAllChk - 입력값이 모두 다 들어왔는지 확인
	init 모든 값 초기화
	makeTimeTable 가능한 시간대 테이블 만들기
	trainerSelect 	트레이너에 따른 근무시간 표시
	*******************************************************************************************/
	var search = {
			
			// 가능한 시간대 데이터들 저장용
			timeTable : "",
			
			
			// 회원 찿기 버튼 클릭 시
			memberSearch : function() {
				
				// 회원번호가 빈값이 아니라면 회원번호 존재여부 체크
				if($("#mbrId").val().length > 0) {
		           	$.ajax({
		           		url : "/admin/ptLeftMbr.do",
		           		data : "mbrId=" + $("#mbrId").val(),
		           		dataType : "text",
		           		async :false,
		           		type : "post",
		           		success : function(data) {
		           			
		           			// 존재하지 않는 회원
		           			if(data == "false") {
		           				alert("존재하지 않는 회원입니다.");
		           			 	$("#mbrId").val("");
		           			// pt횟수가 없는 회원
		           			} else if(data == "halfFail") {
		           				alert("PT횟수가 없는 회원입니다.");
		           				$("#mbrId").val("");
		           			} else if(data == "true") {
		           				// 가능한 회원이라면 input 변경불가
		           				$("#mbrId").prop("readonly","readonly");
		           				alert("가능한 회원입니다.");
		           			} else {
		           				alert("회원을 확인하는 과정에서 오류가 발생하였습니다.");
		           			}
		           		},
		           		
		           		error : function(data) {
		           			alert("회원을 찿는데 오류가 발생");
		           		}
		           	})
		        // 회원번호가 빈값
				} else {
					$("#mbrId").addClass("warnInput");
					$("#mbrId").focus();
					
					alert("회원번호를 입력해주세요");
				}
			},
			
			// 검색버튼 클릭 시 유효성검사 후 서버로 값을 넘김
			timeSearch : function() {
				
				// 유효성 검사가 true라면
				if(this.inputAllChk()) {
					
					inputValue.mbrId = $("[name='mbrId']").val();
					inputValue.trId = $("[name='trainerPick']").val();
					inputValue.ptCode = $("[name='kind']").val();
					inputValue.addSchDate = $("[name='addSchDate']").val();
					
					// 가능한 시간대 검색할 조건들
					var searchData = {
							addSchDate : inputValue.addSchDate,
							trainerPick : inputValue.trId,
							mbrId : inputValue.mbrId,
							kind : inputValue.ptCode,
					}
					
					// 조건에 따른 시간대 받기
					$.ajax({
						url : "/admin/findTimeSchedule.do",
						type : "post",
						data : JSON.stringify(searchData),
						dataType : "JSON",
						contentType : "application/json; charset=UTF-8",
						success : function(data) {
							
							// 가능시간대 저장
							search.timeTable = data;
							// 가능한 시간대를 보여주는 테이블 만들기
							search.makeTimeTable();

							// 입력받는 부분들 선택불가
							$("[name='addSchDate']").prop("disabled",true);;
							$("[name='addSchDate']").datepicker("destroy");
							$("[name='trainerPick']").prop("disabled",true);
							$("[name='kind']").prop("disabled",true);
						},
						error :function() {
							alert("검색하지 못하였습니다.");
						}
					})
				}
			},
			
			// 입력값이 모두 다 들어왔는지 확인
			inputAllChk : function() {
				
				// 모든 값이 입력되었는지 확인
				var cnt = 0;
				
				// 값이 모두 입력되었는지 확인
				// 날짜 확인
				// 날짜 값이 들어왔다면
				if($("#datePick").val().length > 0) {
					
					$("#datePick").removeClass("warnInput");
					cnt++;
					
				// 날짜가 빈값이라면
				} else {
					// css로 표시해준다
					$("#datePick").addClass("warnInput");
					$("#datePick").focus();
				}
				
				// 트레이너 선택
				// 트레이너를 선택 했다면
				if($("[name='trainerPick']").val() != "noselect") {
					
					$("#datePick").removeClass("warnInput");
					cnt++;
					
				// 트레이너를 선택 안했다면	
				} else {
					$("[name='trainerPick']").addClass("warnInput");
					$("[name='trainerPick']").focus();
				}
				
				// 회원 선택
				// 회원번호가 빈값이 아니라면
				if($("#mbrId").val().length > 0) {
					// 회원찿기를 하지 않았다면
					if($("#mbrId").attr("readonly") != "readonly") {
						
						alert("회원찿기를 진행해주세요");
						
						$("#mbrId").addClass("warnInput");
						$("#mbrId").focus();
					// 회원찿기를 했다면
					} else {
						$("#datePick").removeClass("warnInput");
						cnt++;
					}
				// 회원번호가 빈값이라면
				} else {
					$("#mbrId").addClass("warnInput");
					$("#mbrId").focus();
				}
				
				// 종류 선택
				// 종류를 선택 했다면
				if($("[name='kind']").val() != "noKind") {
					$("#datePick").removeClass("warnInput");
					cnt++;
					
				// 종류를 선택 안했다면	
				} else {
					$("[name='kind']").addClass("warnInput");
					$("[name='kind']").focus();
				}
				
				// 모두 유효성검사에 통과 되었다면 4
				if(cnt == 4) {
					return true;
				} else {
					return false;
				}
			},
			
			// 모든 값 초기화
			init : function() {
				// 날짜 초기화
				$("[name='addSchDate']").prop("disabled",false);
				defaultSet.datePicker();
				$("[name='addSchDate']").val("");
				// 수업종류 초기화
				$("[name='kind']").prop("disabled",false);
				$("[name='kind']").val("noKind");
				// 트레이너 초기화
				$("[name='trainerPick']").prop("disabled",false);
				$("[name='trainerPick']").val("noselect");
				// 회원 초기화
				$("#mbrId").val("");
				$("#mbrId").removeAttr("readonly");
				// 가능한 시간 초기화
				$("[name='reservationDate']").val("");
				// 트레이너 근무시간삭제
				$("#trainerTime").empty();
				// 가능한 시간대 테이블 초기화
				$(".table tbody").empty();
				
				inputValue.trId = "";
				inputValue.mbrId = "";
				inputValue.ptCode = "";
				inputValue.chkPickDT = "";
				inputValue.addSchDate = "";
			},
			
			// 검색버튼을 클릭했는지 확인
			chkSeachBtnClick : function() {
				if($("[name='addSchDate']").is(":disabled") && $("[name='kind']").is(":disabled") && 
						$("[name='trainerPick']").is(":disabled") && $("#mbrId").attr("readonly") == "readonly") {
					return true;
				}
				return false;
			},
			// 가능한 시간대 테이블 만들기
			makeTimeTable : function() {
				
				// 기존데이터 삭제
				$(".table tbody").empty();
				
				// 가능한시간을 10분단위로해서 10분당 TR하나
				for(var i=0; i < this.timeTable[0].timeTable.length; i++) {
					if(search.timeTable[0].availableTimetable[i] == 1) {
						$("#timeT tbody").append("<tr class='notResv' style='background-color:grey;'><td>" + this.timeTable[0].timeTable[i] + "</td><td class='hidden'>" + i + "</td></tr>");
					} else {
						$("#timeT tbody").append("<tr><td>" + this.timeTable[0].timeTable[i] + "</td><td class='hidden'>" + i + "</td></tr>");
					}
				}
			},
			
			// 트레이너에 따른 근무시간 표시
			trainerSelect : function() {
				
				// 트레이너 선택 변경 시
				$("[name='trainerPick']").on("change",function() {
					if($(this).val() != "noselect") {
						// 근무시간 모두 표시 삭제
						$("#trainerTime").empty();
						// 선택한 트레이너 근무시간 표시
						$("#trainerTime").append("근무시작시간 " + $(this).find("option:checked").data("stime") + "근무종료시간 " + $(this).find("option:checked").data("dtime"));	
					} else {
						// 선택해주세요 셀렉트박스 클릭 시 근무시간 삭제
						$("#trainerTime").empty();
					}
				})
			},
			
			// 가능한시간대 테이블 클릭 시 , 가능한 시간대인지 확인!
			selectDateTime : function() {
				
				// 이전에 선택했던 값 삭제
				$("[name='trainerPick']").val("");
			
				$(document).on("click","tbody tr",function() {
					
					// 가능한 시간대를 클릭했을 때
					if(!$(this).hasClass("notResv")) {
						// 클릭한 일시
						inputValue.chkPickDT = $(this).find("td").eq(0).text();
						
						//  선택한 시간이 가능한 시간대인지 확인
						search.selectDTajax();
						
					} else {
						alert("수업등록이 불가한 시간입니다.");
					}
				})
			},
			
			// 테이블 클릭 시
			//  선택한 시간이 가능한 시간대인지 확인
			selectDTajax : function() {
				$.ajax({
					url : "/admin/chkAvailDT.do",
					data : JSON.stringify({
							// 선택한 날짜, 트레이너, pt종류, 회원ID
							"chkPickDT" : inputValue.chkPickDT,
							"trainerPick" : inputValue.trId,
							"ptCode" : inputValue.ptCode,
							"mbrId" : inputValue.mbrId,
							"addSchDate" : inputValue.addSchDate}),
					dataType : "text",
					contentType: "application/json",
            		async :false,
            		type : "post",
					success : function(data) {
						
						if(data == "success") {
							alert("등록 가능한 수업 시간입니다.");
							
							// 가능한 일시 input에 저장
							$("[name='reservationDate']").val(inputValue.chkPickDT);
							
						} else if (data == "notAvailable") {
							
							alert("수업 불가능한 시간입니다.");
							// 저장값 삭제
							inputValue.chkPickDT = "";
							$("[name='reservationDate']").val("");
						} else if (data == "fail") {
							
							alert("수업 등록 가능 조회 실패");
							// 저장값 삭제
							inputValue.chkPickDT = "";
							$("[name='reservationDate']").val("");
						} 
					},
					error :function() {
						alert("서버오류로 확인이 불가합니다.");
					}
				})
			}
	}
</script>
<body>
	 <div class="main">
        <section class="signup">
            <!-- <img src="images/signup-bg.jpg" alt=""> -->
            <div class="container">
                <div class="signup-content">
                    <form method="post" id="sAddFrm" action="/admin/schedule.do">
                    <div class="col-md-12">
	                    <div class="col-md-6">
		                    <div class="col-md-12" style="padding-bottom:35px;color:red;">
		                   		 <div class="col-md-12">모두 입력한 뒤, 검색버튼을 클릭해주세요.</div>
		                    </div>
		                    <div class="col-md-12 bottomPadding">
		                        <label for="birth_date">*날짜</label>
		                        <input type="text" class="form-input required" name="addSchDate" id="datePick" readonly />
		                    </div>
		                    <div class="col-md-12 ">
	                            <label for="">트레이너 선택</label>
	                            <select name="trainerPick" class="form-control required" style="overflow:auto;height:calc(2.25rem + 23px);text-overflow: ellipsis;">
	                            <option value="noselect">선택해주세요</option>
	                            <c:forEach items="${trainerInfoList}" var ="trainerInfoList">
		                              <option value="${trainerInfoList.trId}" data-stime="${trainerInfoList.workStartTm}" data-dtime="${trainerInfoList.workFinishTm}">##ID:<c:out value="${trainerInfoList.trId}"/> ##이름:<c:out value="${trainerInfoList.trNm}"/>
		                              </option>
	                            </c:forEach>
	                            </select>
			                </div>
			                <div class="col-md-12 bottomPadding" id="trainerTime" style="color:lightcoral;"></div>
		                    <div class="col-md-12 bottomPadding">
	                            <label for="">회원 선택</label>
	                            <div class="col-md-7" style="padding-left:0px;padding-right:0px;">
	                           		 <input type="text" class="form-input nodisable required" name="mbrId" id="mbrId"  placeholder="ID입력 후 회원찿기 클릭"
	                           		 onkeyup="this.value=this.value.replace(/[^0-9]/g,'');" onfocusout="this.value=this.value.replace(/[^0-9]/g,'');" />
	                            </div>
	                            <div class="col-md-5" >
	                            	 <input type="button" onclick="search.memberSearch()" value="회원 찿기" ><br>
	                            </div>
		                    </div>
		                    <div class="col-md-12 bottomPadding">
		                    	<label for="hour">*수업 종류</label>
		                        <select name="kind" class="form-control required" style="height : calc(2.25rem + 23px);">
		                            <option value="noKind">선택해주세요</option>
		                            <option value="30">30분</option>
		                            <option value="50">50분</option>
		                        </select>
			              </div>
			               <div class="col-md-12">
	                            <div class="col-md-5" style="padding-right:6px;padding-left:4px;">
	                            	 <input type="button" onclick="search.timeSearch()" value="검색"><br>
	                            </div>
	                            <div class="col-md-5" style="padding-left:0px;padding-right:0px;">
	                            	 <input type="button" onclick="search.init()" value="초기화"><br>
	                            </div>
		                   </div>
	                   </div>
	                   <div class ="col-md-6">
	                        <div class="col-md-12" style="">
	                            <div>회색칸은 배정불가</div>
	                            <div>**트레이너는 수업종료 후 10분간의 휴식시간이 보장됩니다.**</div>
	                        </div>
		                   <div class="col-md-12" style="padding-top:20px;padding-bottom:20px;">
		                    	<div class="col-md-8" style="overflow:auto;height:442px;">
		                            <table id="timeT" class="table table-hover table-bordered">
		                            	<tbody></tbody>
		                            </table>
		                        </div>
		                   </div>
                           <div class="col-md-12" style="">
                            	<div>
                            		<label for=pickDate>배정하는 일시</label>
                            		<input type="text" name="reservationDate" readonly/>
								</div>
                           </div>
	                   </div>
                   </div>
                   <div class="col-md-12">
	                  <div class="form-row">
							<div class="col-md-5">
								<input type="button" onclick="insertMbr.insertSubmitFn('insert')"
									class="form-submit" value="등록" />
							</div>
							<div class="col-md-3">
								<input type="submit" class="form-submit" value="목록" />
							</div>
					  </div>
				  </div>
                  <input type="hidden" name="rowCnt" class="" value="${param.rowCnt}"/>
                  <input type="hidden" name="currPage" class="" value="${param.currPage}"/>
                  <input type="hidden" name="cabUseOneMore"  value="N"/>
                  <input type="hidden" name="pageName" value="schedule"/>
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
    <!-- 수업일지 팝업  -->
    <div class="schedule" id="popupLayer">
		<div class="schedule b-close" style="font-size:large;">X</div>
      		<p style="font-size: 29px;">수업일지</p>
        <div class="schedule popupContent"></div>
    </div>
</body>
</html>