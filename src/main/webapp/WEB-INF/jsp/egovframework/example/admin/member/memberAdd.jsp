<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
  /**
  * @Class Name : memberAdd.jsp
  * @Description : 회원 등록 화면
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
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>회원 등록</title>
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
		newCabinet.eventAll();
		validation.valEvent();
	});
	
	/************************************************************
		defaultSet 페이지가 실행될 때 디폴트 세팅
		newCabinet 사물함 관련 함수들을 모음.
	************************************************************/
	
	/************************************************************
	defaultSet 페이지가 실행될 때 디폴트 세팅\
	init - 최초 생성시 초기화
	************************************************************/
	var defaultSet = {
			
		init : function() {
			// 사물함 미사용 디폴트, 사물함 입력 숨기기
			$("#cabN").attr("checked","checked");
			$(".cabVisible").hide();
			
			// 올바른형식입력메세지 숨김
			$(".errorText").hide();
			
			// 필수입력 메세지 숨김
			$(".must").hide();
			
			// 배정버튼 disabled
			$("#cabAssign").prop("disabled", true);
		}
	}
	
	/************************************************************
		validationFn 설명 유효성관련
		valEvent - 유효성 이벤트 모음
		validationFn - 유효성 검사 함수
		maxLengthCheck - 입력창 총 길이 제한
		beforeMustSubmitFn - 수정하기전 필수입력 체크
		beforeSubmitCabDeleteFn - submit하기전에 회원권 사용유무가 미사용이면 사물함 정보 다 삭제
		beforeSelectSubmitFn - submit전에 유효성 검사
	************************************************************/	
	
	var validation = {
			 
		valEvent : function() {
			validation.validationFn();
		},
		
		validationFn : function() {
			// 회원이름 정규식
			var mbrNm = RegExp(/^[ㄱ-ㅎ|가-힣|a-z|A-Z|\*]+$/);
			// 휴대폰 정규식
			var cellNo = /^(01[016789]{1})([0-9]{3,4})([0-9]{4})$/;
			/* var detailAddr = RegExp(/^[ㄱ-ㅎ|가-힣|a-z|A-Z|0-9|\*]+$/);*/
			var ptChk = /^[1-9][0-9]?$/

			
			/******************************
				필수 입력란 유효성 검사
			*******************************/
			
			// 회원이름 유효성검사
			// focusout
			$("[name=mbrNm]").focusout(function() {
				var $this = $(this);
				
				// 값이 입력되어 있다면
				if($this.val().length > 0) {
					
					// 필수입력 메세지 숨기기
					$this.nextAll("div").eq(1).hide();
					
					// 올바른 입력이 아니라면
					if(!mbrNm.test($this.val())) {
						// 올바른 입력 메세지 띄우기
						$this.next("div").show();
						// 입력값 삭제
						$this.val("");
					// 올바른 입력이 맞다면
					} else {
						// 모든 메세지 숨기기
						$this.next("div").hide();
					}
				// 값이 입력 안되어 있다면
				} else {
					// 올바른 입력 메세지 숨기고
					$this.next("div").hide();
					// 필수 입력 메세지 띄우기
					$this.nextAll("div").eq(1).show();
				}
				
			});
			
			// 회원명 문자이외의 값이 눌려졌을때
			// keydown
			$("[name=mbrNm]").keydown(function() {
				var $this = $(this);
				
				// 값이 입력되어 있다면
				if($this.val().length > 0) {
					// 올바른 입력이 아니라면
					if(!mbrNm.test($this.val())) {
						// 입력값 삭제
						$this.val("");
					} 
				}
			});
			
			// 휴대폰 유효성 검사
			$("[name=phone_number]").focusout(function(e) {
				var $this = $(this);
				
				// 숫자만 입력가능
				$this.val($this.val().replace(/[^0-9]/g,''));
				
				// 값이 입력되어 있다면
				if($this.val().length > 0) {
					$this.nextAll("div").eq(1).hide();
					
					if(!cellNo.test($this.val())) {
						$this.next("div").show();
					} else {
						$this.next("div").hide();
					}
				} else {
					$this.next("div").hide();
					$this.nextAll("div").eq(1).show();
				}
					
			});
			
			// 가입일 유효성 검사
			$('#startDate').datepicker("option", "onClose", function ( selectedDate ) {
				
				// 만료일 최소날짜세팅
				$("#finishDate").datepicker( "option", "minDate", selectedDate );
				
				// 가입일 필수 체크
				if($("#startDate").val().length == 0) {
					$("#startDate").nextAll("div").show();
				} else {
					$("#startDate").nextAll("div").hide();
				}
			});
			
			// 만료일 유효성 검사
			 $('#finishDate').datepicker("option", "onClose", function ( selectedDate ) {
				
				// 가입일 최소날짜세팅
		        $("#startDate").datepicker( "option", "maxDate", selectedDate );
		        
				// 만료일 필수 체크
		        if($('#finishDate').val().length == 0) {
		        	$('#finishDate').nextAll("div").show();
				} else {
					$('#finishDate').nextAll("div").hide();
				}
		    });
			
			// PT횟수 유효성 검사
			$("#ptCnt").focusout(function() {
				var $this = $(this);
				
				// 숫자만 입력가능
				$this.val($this.val().replace(/[^0-9]/g,''));
				
				if($this.val().length <= 0) {
					$this.next("div").show();
				} else {
					$this.nextAll("div").hide();
				}
			});
		},
		
		// 필수 입력 
		beforeMustSubmitFn : function() {
			
			var cnt = 0;
			
			/* 필수 입력 확인*/
			// 회원 이름
			if($("[name=mbrNm]").val().length == 0) {
				$("[name=mbrNm]").nextAll("div").eq(1).show();
				cnt++;
			}
			// 회원 가입일
			if($("#startDate").val().length == 0) {
				$("#startDate").nextAll("div").show();
				cnt++;
			}
			// 회원 만료일
			if($("#finishDate").val().length == 0) {
				$("#finishDate").nextAll("div").show();
				cnt++;
			}
			// 회원 휴대폰 번호
			if($("[name=phone_number]").val().length == 0) {
				$("[name=phone_number]").nextAll("div").eq(1).show();
				cnt++;
			}
			// 회원 pt횟수
			if($("#ptCnt").val().length == 0) {
				$("#ptCnt").nextAll("div").show();
				cnt++;
			}
			// 사물함 마지막꺼 입력되었는지 확인
			cabId = $(".well").find(".form-row").last().find("input").eq(0).val();
			cabSDate = $(".well").find(".form-row").last().find("input").eq(1).val();
			cabFDate = $(".well").find(".form-row").last().find("input").eq(2).val();
			
			// 회원권 사용유무가 사용일 때
			if($("#cabY").is(":checked")) {
				// 한줄이상 추가 되었을 때
				if($(".well").find(".form-row").length > 0) {
					if($(".well").find(".form-row").last().find("input").eq(0).attr("readonly") != "readonly") {
						alert("사물함을 배정하시거나 삭제해주세요.");
						cnt++;
					} else {
						$("[name='cabUseOneMore']").val("Y");
					}
				} 
			}
			
			// 필수입력이 하나라도 체크 안되있다면 false 리턴
			if(cnt > 0 ) {
				return false;
			} else {
				return true;
			}
		},
		
		// submit하기전에 회원권 사용유무가 미사용이면 사물함 정보 다 삭제
		beforeSubmitCabDeleteFn : function() {
			if($("#cabN").is(":checked")) {
				alert("회원권 미사용이라 사물함 정보가 모두 배정되지 않습니다.");
				$(".well").empty();
			} 
		},
		
		// submit 전 유효성 체크
		beforeSelectSubmitFn : function() {
			// 회원 이름 정규식
			var mbrNm = RegExp(/^[ㄱ-ㅎ|가-힣|a-z|A-Z|\*]+$/);
			// 휴대폰번호 정규식
			var cellNo = /^(01[016789]{1})([0-9]{3,4})([0-9]{4})$/;
			
			// 회원이름 유효성 체크
			if(!mbrNm.test($("[name=mbrNm]").val())) {
				$(this).nextAll("div").eq(1).show();
				return false;
			}
			
			// 휴대폰번호 유효성 체크
			if(!cellNo.test($("[name=phone_number]").val())) {
				$(this).nextAll("div").eq(1).show();
				return false;
			}
					
			// 회원설명의 엔터를 <br/>로 변경
			if($("[name='mbrDesc']").val().length > 0) {
				var explain = "";
				explain = $("[name='mbrDesc']").val();
				explain = explain.replace(/(?:\r\n|\r|\n)/g, '<br/>');
				$("[name='mbrDesc']").val(explain);
			}
			
			return true;
		}
	};
	
	/******************************************************************************************
		newCabinet 사물함 관련 함수들을 모음.
		cabAssignArray - 배정된 사물함 저장
		eventAll - 모든 함수를 모아둠
		useynFn  - 사물함 사용여부에 따라서 배정부분이 show , hide됨
		newFn -  사물함 생성버튼(+) 클릭
		deleteFn - 사물함 삭제 버튼(-) 클릭
		assingFn - 배정버튼 클릭
		alreadyAssign - 이미 사물함번호가 배정되었는지 확인
		cabDatePicker -  사물함 배정 달력 생성
	*******************************************************************************************/
	
	var newCabinet = {
		
		// 배정된 사물함 저장
		cabAssignArray : new Array(),
		
		// 모든 실행되는 함수 모아둠
		eventAll : function() {
			// 회원권 사용유무에 따른 hide, show
			this.useynFn();
			// 사물함 삭제 버튼 클릭시 이벤트
			this.deleteFn();
		},
		
		// 회원권 사용유무에 따른 사물함 배정 hide, show
		useynFn : function() {
			$(".form-radio .form-flex").on("click","[name='useYN']",function() {
				if($(this).attr("id") == "cabY") {
					$(".cabVisible").show();
				} else {
					$(".cabVisible").hide();
				}
			})
		},
		
		// 사물함 생성버튼(+) 클릭
		newFn : function() {
			// 생성할 사물함 입력폼 row
			var cabinetOneRow = "<div class='form-row'><div class='col-md-12'><div class='col-md-3'><label for='password'>사물함 번호</label>" +
	                  			"<input type='text' name='cabId' value=''  class='cab form-control' maxlength='2'  onkeyup ='this.value=this.value.replace(/[^0-9]|(^0+)/g,\"\");' onfocusout='this.value=this.value.replace(/[^0-9]|(^0+)/g,\"\");' placeholder='1~99번 숫자만 가능'/></div>" +
	                   			"<div class='col-md-4'><label for='password'>사물함 등록일</label>" +
	                   			"<input type='text' name='cabStartDate' value=''class='cab form-control cabJoinDate cabDate' readonly='true' />" +
	                  			"</div><div class='col-md-4'><label for='password'>사물함 만료일</label>" +
	                   			"<input type='text' name='cabFinishDate' value='' class='cab form-control cabFinishDate cabDate'  readonly='true'/> </div>" +
	                  			"<div class='input-group-append' style='padding-top:23px;'>" +
						   		"<button class='btn btn-outline-secondary btn-add form-control deleteCabClick' type='button' >-</button></div></div></div>";
			
			// append 하기 전에 데이트피커 삭제
			$(document).find(".cabDate").datepicker("destroy");
			$(document).find(".cabDate").removeClass("hasDatepicker").removeClass("cabJoinDate").removeClass("cabFinishDate");
			
			// 사물함 추가 row생성
			$(".well").append(cabinetOneRow);
			// 생성된 row에 달력 추가
			this.cabDatePicker();
			
			// + 버튼 disabled
			$("#newCab").prop("disabled", true);
			
			// 배정버튼 abled
			$("#cabAssign").prop("disabled", false);
			
		},
		
		// 사물함 삭제 버튼(-) 클릭
		deleteFn : function(elmt) {
			$(document).on("click",".deleteCabClick",function() {
				var $this = $(this);
				
				$(this).closest(".form-row").remove();
				
				// 더이상 삭제할 row가 없다면 플러스 버튼 활성화 또는 마지막이 배정되있는 row라면 활성화
				if( $(".well").find(".form-row").length == 0 || $(".well").find(".form-row").last().find("input").eq(0).attr("readonly") == "readonly" ) {
					
					// + 버튼 abled
					$("#newCab").prop("disabled", false);
					
					// 배정버튼 disabled
					$("#cabAssign").prop("disabled", true);
					
					// 배열에서 사물함 번호 삭제
					newCabinet.cabAssignArray = $.grep(newCabinet.cabAssignArray, function(value) { 
						return value != $this.closest(".form-row").find("[name='cabId']").val(); 
					});
					
				}
			});
		},
		
		// 배정버튼 클릭
		assingFn : function() {
			// 사물함 정보
			cabId = $(".well").find(".form-row").last().find("input").eq(0).val();
			cabSDate = $(".well").find(".form-row").last().find("input").eq(1).val();
			cabFDate = $(".well").find(".form-row").last().find("input").eq(2).val();
			
			// 사물함 정보 모두 입력확인
			if(cabId.length > 0 && cabSDate.length > 0 && cabFDate.length > 0 ) {
				// 사물함번호가 이미 배정되었는지 확인
				if(this.alreadyAssign()) {
					$.ajax({
						url : "/admin/CabUseChk.do",
						type : "get",
						dataType :"text",
						async : false,
						data : {cabId : cabId},
						/*
						@param data - 사물함 사용여부  사용=fail, 미사용=success
						*/
						success : function (data) {
							
							if(data === "fail") {
								alert("이미 사용중인 사물함 입니다.");
								$(".well").find(".form-row").last().find("input").eq(0).val("");
							} else {
								alert("배정되었습니다.")
								$(".well").find(".form-row").last().find("input").prop("readonly",true);
								// + 버튼 사용가능
								$("#newCab").prop("disabled", false);
								// 배정버튼 사용불가
								$("#cabAssign").prop("disabled", true);
								// 달력해제
								$(".well").find(".form-row").last().find("input").eq(1).datepicker("destroy");
								$(".well").find(".form-row").last().find("input").eq(2).datepicker("destroy");
								
								// 배정 사물함 정보 담기
								newCabinet.cabAssignArray.push($(".well").find(".form-row").last().find("input").eq(0).val());
							}
						},
						
						error : function (data) {
							alert("사물함 배정 중 오류가 발생하였습니다.");
						}
					});
				} else {
					alert("이미 배정된 번호 입니다");
					$(".well").find(".form-row").last().find("input").eq(0).val("");
				}
			} else {
				alert("사물함 폼을 모두 입력해야지만 배정이 가능합니다.");
			}
		},
		
		// 이미 사물함번호가 배정되었는지 확인 함수
		alreadyAssign : function() {
			// 배열에 저장된 배정된 사물함 번호와 입력한 번호 비교
			for(var i=0; i < this.cabAssignArray.length; i++) {
				if(this.cabAssignArray[i] == $(".well").find(".form-row").last().find("input").eq(0).val()) {
					return false;
				} 
			}
			return true;
		},
		
		// 사물함 배정 달력 생성
		cabDatePicker : function() {
			$(document).find(".cabJoinDate").datepicker({
				 changeMonth : true,
				 changeYear : true,
				 showOn: "both",
			     buttonImage: "/images/egovframework/calendar_mini.png",
			     buttonImageOnly: true,
			     minDate : $('#startDate').val(),
			     maxDate : $('#finishDate').val(),
			     onClose: function( selectedDate ) {    
			         // 시작일(startDatepicker) datepicker가 닫힐때
			         // 종료일(endDatepicker)의 선택할수있는 최소 날짜(minDate)를 선택한 시작일로 지정
			         $(".cabFinishDate").datepicker( "option", "minDate", selectedDate );
			     } 
			});
			$(document).find(".cabFinishDate").datepicker({
				 changeMonth : true,
				 changeYear : true,
				 showOn: "both",
			     buttonImage: "/images/egovframework/calendar_mini.png",
			     buttonImageOnly: true,
			     maxDate: $('#finishDate').val(),
			     minDate: $('#startDate').val(),
			     onClose: function( selectedDate ) {    
			         // 시작일(startDatepicker) datepicker가 닫힐때
			         // 종료일(endDatepicker)의 선택할수있는 최소 날짜(minDate)를 선택한 시작일로 지정
			         $(".cabJoinDate").datepicker( "option", "maxDate", selectedDate );
			         
			     } 
			});
			
			// 가입일 만료일에 따른 사물함 날짜 동적생성 onclose해주기
		    $('#startDate').datepicker("option", "onClose", function ( selectedDate ) {
		        $(document).find(".cabJoinDate").datepicker( "option", "minDate", selectedDate );
		        $(document).find(".cabFinishDate").datepicker( "option", "minDate", selectedDate );
			 });
		    
		    $('#finishDate').datepicker("option", "onClose", function ( selectedDate ) {
		        $(document).find(".cabFinishDate").datepicker( "option", "maxDate", selectedDate );
		        $(document).find(".cabJoinDate").datepicker( "option", "maxDate", selectedDate );
		    }); 
		}
	}
	
	/******************************************************************************************
	updateMbr 수정버튼 클릭시 모음
	updateSubmitFn - 수정버튼 submit
	*******************************************************************************************/
	
	// 등록버튼 클릭 시
	var insertMbr = {
		/*
		@param 클릭한 input button의 구별인자
		*/
		insertSubmitFn : function(page) {
			
			if(page = "insert") {
				// 필수체크확인
				if(validation.beforeMustSubmitFn()) {
					// 유효성 체크
					if(validation.beforeSelectSubmitFn()) {
						
						// 회원권 사용유무에 따른 사물함 정보 삭제
						validation.beforeSubmitCabDeleteFn();
						$("#mbrAddFrm").attr("action","/admin/memberRealAdd.do");
						$("#mbrAddFrm").submit();
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
                    <form method="post" id="mbrAddFrm" action="/admin/member.do">
                    <div class="form-row" style="padding-bottom:35px;color:red;">
                   		 <div class="col-md-6">*는 필수 입력입니다.</div>
                    </div>
                    <div class="form-row">
                        <div class="form-group">
                            <label for="first_name">*회원명</label>
                            <input type="text" class="form-input required" name="mbrNm"
                            onkeyup ="this.value=this.value.replace(/[^a-zA-Zㄱ-ㅎ|ㅏ-ㅣ|가-힣]/g,'');" maxlength="20" placeholder="'문자만 입력가능합니다/ 최대 20자" />
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
                           		 <input type="text" class="form-input nodisable" name="post" id="sample4_postcode" readonly/>
                            </div>
                            <div class="col-md-4" style="padding-right:6px;padding-left:4px;">
                            	 <input type="button" onclick="addressPopup()" value="우편번호 찾기"><br>
                            </div>
                        </div>
                    </div>
                     <div class="form-row">
                        <div class="form-group">
                            <label for="last_name">도로명주소</label>
                            <input type="text" class="form-input nodisable" name="RoadAddress" id="sample4_roadAddress" readonly/>
                        </div>
                        <div class="form-group">
                            <label for="last_name">상세주소</label>
                            <input type="text" class="form-input" name="detailAddress" id="sample4_detailAddress" maxlength="20" placeholder="'최대20자 입력가능"/>
                        </div>
                     </div>
	                    <div class="form-row">
	                        <div class="form-group form-icon">
	                            <label for="birth_date">*가입일</label>
	                            <input type="text" class="form-input required" name="addJoinDate" id="startDate" readonly />
	                            <div class="must" style="color:red;">필수입력입니다.</div>
	                        </div>
	                         <div class="form-group form-icon">
	                            <label for="birth_date">*만료일</label>
	                            <input type="text" class="form-input required"  name="addFinishDate" id="finishDate" readonly/>
	                            <div class="must" style="color:red;">필수입력입니다.</div>
	                        </div>
	                    </div>
                        <div class="form-row">
	                        <div class="col-md-6 cellNo">
	                            <label for="phone_number">*휴대폰번호</label>
	                            <input type="text" class="form-input required" name="phone_number" id="phone_number"
	                            onkeyup ="this.value=this.value.replace(/[^0-9]/g,'');" maxlength='11'  placeholder="'-' 없이 숫자만 입력가능합니다" />
	                            <div class="errorText" style="color:red;">올바른 형식으로 입력해주세요</div>
	                            <div class="must" style="color:red;">필수입력입니다.</div>
	                        </div>
                        </div>
                        <div class="form-row">
                        	<div class="col-md-12" style="padding-bottom:10px;padding-top:15px;">
                                <label for="password">회원설명</label>
                                <textarea class="form-input valid" name="mbrDesc" rows="4" style="resize:none;width:100%;border:1px solid #ebebeb;" maxlength="500" aria-invalid="false"
                                placeholder="최대500자까지 입력가능합니다"></textarea>
                            </div>
                         </div>
                        <div class="form-row">
                       		<div class="col-md-6">
	                            <label for="re_password">*PT횟수</label>
	                            <input type="text" class="form-input required" name="ptCnt" id="ptCnt" 
	                            onkeyup ="this.value=this.value.replace(/[^0-9]/g,'');" maxlength='5'  placeholder="'숫자만 입력가능합니다" />
	                            <div class="must" style="color:red;">필수입력입니다.</div>
	                         </div>
                        </div>
                        
                        <div class="form-radio" style="padding-top: 20px;">
	                           <label for="cabYN">*회원권 사용유무</label>
	                           <div class="form-flex">
	                               <input type="radio" name="useYN" value="Y" class="" id="cabY" />
	                               <label for="cabY">사용</label>
	
	                               <input type="radio" name="useYN" value="N"  class="" id="cabN" checked="checked"/>
	                               <label for="cabN">미사용</label>
                           </div>
                        <div class="row">
                        	<div class="col-md-6" style="padding-top: 20px;">
                        	 ※회원권 미사용이면 사물함 배정이 불가합니다.
                        	</div>
                        </div>
                        </div>
                        <div class="cabVisible">
	                        <div class="row " style="padding-top:23px;">
	                       		<div class="col-md-2">
									<button class="btn btn-outline-secondary btn-add form-control btn-default"  id="cabAssign" type="button" onclick="newCabinet.assingFn()">배정</button>
								</div>
	                        	<div class="col-md-2">
									<button class="btn btn-outline-secondary btn-add form-control btn-default" id="newCab" type="button" onclick="newCabinet.newFn()">+</button>
								</div>
								<div class="col-md-8">	
									※ 모두 입력하고 배정해주세요. 새로운 사물함이 배정이 되면 +버튼이 활성화 됩니다.
								</div>
							</div>
                            <div class="well" style="overflow:auto;max-height:300px;">
                               	<!-- <div class="form-row">
                               		<div class="col-md-12">
                               			<div class="col-md-3">
                               				 <label for="password">사물함 번호</label>
	                                  		<input type="number" name="cabId" value=""  class="cab form-control" maxlength="2" placeholder="'숫자만 입력가능합니다"/>
	                                   </div>
	                                   <div class="col-md-4">
	                                   		<label for="password">사물함 등록일</label>
	                                   		<input type="text" name="cabStartDate" value=""  class="cab form-control cabJoinDate"  readonly />
	                                   </div>
	                                   <div class="col-md-4">
	                                   		<label for="password">사물함 만료일</label>
		                               		<input type="text" name="cabFinishDate" value=""  class="cab form-control cabFinishDate"  readonly/>
		                               </div>
		                               <div class="input-group-append" style="padding-top:23px;">
										   	<button class="btn btn-outline-secondary btn-add form-control deleteCabClick" type="button">-</button>
									   </div>
									</div>
                               	</div> -->
                            </div>
                       </div>
                        <div class="form-row">
                        	<div class="col-md-5">
                            	<input type="button" onclick="insertMbr.insertSubmitFn('insert')" class="form-submit" value="등록"/>
                            </div>
                            <div class="col-md-3">
                           		<input type="submit"  class="form-submit" value="목록"/>
                            </div>
                        </div>
                            <input type="hidden" name="searchCon" class="" value="${param.searchCon}"/>
                            <input type="hidden" name="searchText" value="${param.searchText}" />
                            <input type="hidden" name="use_yn" class="" value="${param.use_yn}"/>
                            <input type="hidden" name="status" class="" value="${param.status}"/>
                            <input type="hidden" name="rowCnt" class="" value="${param.rowCnt}"/>
                            <input type="hidden" name="currPage" class="" value="${param.currPage}"/>
                            <input type="hidden" name="startDate" value="${param.startDate}" />
						 	<input type="hidden" name="finishDate" value="${param.finishDate}" />
                            <input type="hidden" name="cabUseOneMore"  value="N"/>
                        	<input type="hidden" name="pageName" value="${param.pageName}"/>
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