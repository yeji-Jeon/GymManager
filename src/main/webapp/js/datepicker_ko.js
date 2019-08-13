
(function($){
	// KR language callendar
	$.datepicker.regional['kr'] = {
			closeText: '닫기',
	        prevText: '이전달',
	        nextText: '다음달',
	        currentText: '오늘',
	        monthNames: ['1월(JAN)','2월(FEB)','3월(MAR)','4월(APR)','5월(MAY)','6월(JUN)',
	        '7월(JUL)','8월(AUG)','9월(SEP)','10월(OCT)','11월(NOV)','12월(DEC)'],
	        monthNamesShort: ['1월','2월','3월','4월','5월','6월',
	        '7월','8월','9월','10월','11월','12월'],
	        dayNames: ['일','월','화','수','목','금','토'],
	        dayNamesShort: ['일','월','화','수','목','금','토'],
	        dayNamesMin: ['일','월','화','수','목','금','토'],
	        weekHeader: '주',
	        dateFormat: 'yy-mm-dd',
	        firstDay: 0,
	        isRTL: false,
	        showMonthAfterYear: true,
	        yearSuffix: '년',
	        showOn: 'both',
	        buttonText: "달력",
	        changeMonth: true,
	        changeYear: true,
	        showButtonPanel: true,
	        yearRange: 'c-99:c+99',
	        changeMonth : true,
	    	changeYear : true
	};

	// Seeting up default language, Korean
	$.datepicker.setDefaults($.datepicker.regional['kr']);

	
	$("#startDate").datepicker({
		dateFormat: 'yy-mm-dd' //Input Display Format 변경
                ,showOtherMonths: true //빈 공간에 현재월의 앞뒤월의 날짜를 표시
                ,showMonthAfterYear:true //년도 먼저 나오고, 뒤에 월 표시
                ,changeYear: true //콤보박스에서 년 선택 가능
                ,changeMonth: true //콤보박스에서 월 선택 가능   
                ,showOn: "both" 
                ,buttonImage: "/images/egovframework/calendar_mini.png"
	});
	$("#finishDate").datepicker({
		dateFormat: 'yy-mm-dd' //Input Display Format 변경
			,showOtherMonths: true //빈 공간에 현재월의 앞뒤월의 날짜를 표시
			,showMonthAfterYear:true //년도 먼저 나오고, 뒤에 월 표시
			,changeYear: true //콤보박스에서 년 선택 가능
			,changeMonth: true //콤보박스에서 월 선택 가능   
			,showOn: "both" 
            ,buttonImage: "/images/egovframework/calendar_mini.png"
	});
	
	 $('#startDate').datepicker("option", "maxDate", $("#finishDate").val());
	 $('#startDate').datepicker("option", "onClose", function ( selectedDate ) {
	        $("#finishDate").datepicker( "option", "minDate", selectedDate );
	 });
	    
    $('#finishDate').datepicker("option", "minDate", $("#startDate").val());
    $('#finishDate').datepicker("option", "onClose", function ( selectedDate ) {
        $("#startDate").datepicker( "option", "maxDate", selectedDate );
    });   
}(jQuery));

