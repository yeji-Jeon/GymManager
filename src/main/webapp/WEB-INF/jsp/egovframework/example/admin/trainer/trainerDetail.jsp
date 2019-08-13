  <%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
  /**
  * @Class Name : trainerDetail.jsp
  * @Description : 트레이너 상세 화면
  * @Modification Information
  *
  *   수정일         수정자                   수정내용
  *  -------    --------    ---------------------------
  *  2019.05.19            최초 생성
  *
  * author 전예지
  * since 2019.05.19
  *
  * Copyright (C) All right reserved.
  */
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		
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
	

	/*************************************************************************************************
	 	pageSubmit의 각각의 함수 설명. - 페이지가 넘어갈 때 
	 	pageSubmitFn -  목록, 수정, 삭제 버튼  클릭 시 페이지 전환
	**************************************************************************************************/
	
	var pageSubmit = {

		/* 목록, 수정, 삭제 버튼  클릭 시 페이지 전환
		@param selectedBtn 목록 수정 삭제 버튼 input 구별값
		*/
		pageSubmitFn : function(selectedBtn) {
			
			// 삭제 버튼 클릭
			if(selectedBtn == "delete") {
				// 배정된 일정 저장 변수 선언
				var future = "${trainerInfo.future}";
				// 배정된 일정이 없다면
				if(future == "0" || future == "") {
					// 트레이너 삭제가능
					if(confirm("트레이너를 삭제하시겠습니까? *경고* 트레이너의 정보가 데이터베이스에서 완전삭제가 진행됩니다. 추후 데이터복구가 불가능합니다.")) {
						$("[name='currPage']").val("${param.oneDeletePageNum}");
						$("#tDetailFrm").prop("action","/admin/trainerDelete.do");
						$("#tDetailFrm").submit();
					}
				} else {
					alert("배정된 수업일정이 있는 트레이너는 삭제 불가합니다.");
				}
			// 목록 버튼 클릭
			} else if(selectedBtn == "memberLists") {
				
					$("#tDetailFrm").prop("action","/admin/trainerLists.do");
					$("#tDetailFrm").submit();
				
			// 수정 버튼 클릭
			} else {
				$("#tDetailFrm").prop("action","/admin/trainerUpdate.do");
				$("#tDetailFrm").submit();
			}
		}
	}
	
	</script>
	<body>
		<div class="main">
			<section class="signup">
				<div class="container">
					<div class="signup-content">
						<form method="post" id="tDetailFrm" action="/admin/memberDatail.do" style="margin-left:140px;margin-right:-135px;">
							<div class="form-row">
								<div class="col-md-6">
									<div class="col-md-3">
										<Strong><label for="gender">*트레이너ID</label></Strong>
									</div>
									<div class="col-md-6">${trainerInfo.trId}</div>
								</div>
							</div>
							<div class="form-row">
								<div class="col-md-6">
									<div class="col-md-3">
										<Strong><label for="gender">*이름</label></Strong>
									</div>
									<div class="col-md-6">${trainerInfo.trNm}</div>
								</div>
								<div class="col-md-6">
									<div class="col-md-3">
										<Strong><label for="gender">*성별</label></Strong>
									</div>
									<div class="col-md-6">
										<c:if test="${trainerInfo.trGender eq 'F'}">여자</c:if>
										<c:if test="${trainerInfo.trGender eq 'M'}">남자</c:if>
									</div>
								</div>
							</div>
							<div class="form-row">
								<div class="col-md-6">
									<div class="col-md-3">
										<Strong><label for="phone_number">우편번호</label></Strong>
									</div>
									<div class="col-md-6">${trainerInfo.trPostCode}</div>
								</div>
							</div>
							<div class="form-row">
								<div class="col-md-6">
									<div class="col-md-3">
										<Strong><label for="phone_number">도로명주소</label></Strong>
									</div>
									<div class="col-md-6">${trainerInfo.trRoadAddress}</div>
								</div>
								<div class="col-md-6">
									<div class="col-md-3">
										<Strong><label for="phone_number">상세주소</label></Strong>
									</div>
									<div class="col-md-6">${trainerInfo.trDtlAddress}</div>
								</div>
							</div>
							<div class="form-row">
								<div class="col-md-6">
									<div class="col-md-3">
										<Strong><label for="birth_date">*근무시작일시</label></Strong>
									</div>
									<div class="col-md-6">${trainerInfo.workStartTm}</div>
								</div>
								<div class="col-md-6">
									<div class="col-md-3">
										<Strong><label for="birth_date">*근무종료일시</label></Strong>
									</div>
									<div class="col-md-6">${trainerInfo.workFinishTm}</div>
								</div>
							</div>
							<div class="form-row">
								<div class="col-md-6">
									<div class="col-md-3">
										<Strong><label for="phone_number">*휴대폰번호</label></Strong>
									</div>
									<div class="col-md-6">${trainerInfo.trCellno}</div>
								</div>
							</div>
							<div class="form-row">
								<div class="col-md-6">
									<div class="col-md-3">
										<Strong><label for="re_password">*총 PT횟수</label></Strong>
									</div>
									<div class="col-md-6">${trainerInfo.cnt}</div>
								</div>
							</div>
							<div class="form-row">
								<div class="col-md-12">
									<div class="col-md-2">
										<input type="button"
											onclick="pageSubmit.pageSubmitFn('memberLists')"
											class="form-submit" value="목록" />
									</div>
									<div class="col-md-3">
										<input type="button"
											onclick="pageSubmit.pageSubmitFn('memberUpdate')"
											class="form-submit" value="수정" />
									</div>
									<div class="col-md-3">
										<input type="button" onclick="pageSubmit.pageSubmitFn('delete')"
											class="form-submit" value="삭제" />
									</div>
								</div>
							</div>
							<input type="hidden" name="searchCon" class=""value="${param.searchCon}" /> 
							<input type="hidden" name="searchText" value="${param.searchText}" />
							<input type="hidden" name="rowCnt" class="" value="${param.rowCnt}" />
							<input type="hidden" name="chk_info" class="" value="${param.rowTId}" />
							<input type="hidden" name="currPage" class="" value="${param.currPage}" /> 
							<input type="hidden" name="rowTId" value="${param.rowTId}" />
							<input type="hidden" name="pageName" value="trainer"/>
						</form>
					</div>
				</div>
			</section>
		</div>
		<div id="popupLayer">
			<div class="b-close" style="font-size: large;">X</div>
	      		<p style="font-size: 29px;">수업일지</p>
	        <div class="popupContent"></div>
	    </div>
	</body>
</html>