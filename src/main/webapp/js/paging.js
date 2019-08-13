
var pageValues = {
    		
    		// 현재 페이지 
			currPage : 1,
    		
    		// 한 페이지에 출력될 회원 수 
			rowCnt : 10,
    		
    		// 총 회원 수
			totalMbrCnt : 0,
    		
    		// 한 화면에 출력될 페이지 수 
			pageSize : 5,
    		
    		// 총 페이지
			totPageCnt : 1,
    		
    		// 페이지번호 시작
    		startPage : 1,
    		
    		// 끝 번호 시작
    		endPage : 1
    };


var pagination = {
		paging : function(totalMbrCnt,rowCnt,pageSize,currPage) {
			
			totalMbrCnt = parseInt(totalMbrCnt);// 전체레코드수
			rowCnt = parseInt(rowCnt);// 페이지 당 보여줄 데이터 개수
			pageSize = parseInt(pageSize);// 페이지 그룹 범위
			currPage = parseInt(currPage);// 현재페이지번호
    		var startPage = 1;// 페이지번호 시작
    		var endPage = 1// 끝 번호 시작
		    var totPageCnt = 1; // 총 페이지 수
		    
			var  html = new Array();
			
			// 총 페이지 수
		    totPageCnt =  Math.floor(totalMbrCnt / rowCnt);
		    
		    if(totalMbrCnt % rowCnt > 0) {
		    	
		    	totPageCnt++;
		    }
		    
		    // 끝 페이지
		    var temp = Math.round((currPage/pageSize) + (currPage % pageSize)) * pageSize;
		    
		    if(temp > totPageCnt) {
		    	endPage = totPageCnt;
		    } else {
		    	endPage = temp;
		    }
		    
		    // 시작페이지
		    startPage = Math.floor((endPage -1) / pageSize ) * pageSize +1;
		    
		    // 페이징 번호 생성 
		    if(currPage != 1) {
		    	$("#pageUl").append("<li class='page-item'><a class='page-link' href='#' onclick='currPagination.pageSubmit(\"first\")'>처음</a></li>");
		    	$("#pageUl").append("<li class='page-item'><a class='page-link' href='#' onclick='currPagination.pageSubmit(\"previous\")'>이전</a></li>");
		    }
		    for(var iCount = startPage ; iCount <= endPage; iCount++ ) {
		    	console.log(iCount, currPage);
		    	if(iCount == currPage) {
		    		$("#pageUl").append("<li class='page-item active'><a class='page-link' href='#' onclick='currPagination.pageSubmit(" + iCount + ")'>" + iCount + "</a></li>");	

		    	} else {
		    		$("#pageUl").append("<li class='page-item'><a class='page-link' href='#' onclick='currPagination.pageSubmit(" + iCount + ")'>" + iCount + "</a></li>");	
		    	}
			};
			if(currPage != totPageCnt) {
				$("#pageUl").append("<li class='page-item'><a class='page-link' href='#' onclick='currPagination.pageSubmit(\"next\")'>다음</a></li>");
				$("#pageUl").append("<li class='page-item'><a class='page-link' href='#' onclick='currPagination.pageSubmit(\"last\")'>끝</a></li>");
			}
			
			// 계산 페이징 변수 저장
			pageValues.currPage = currPage;
			pageValues.rowCnt = rowCnt;
			pageValues.totalMbrCnt = totalMbrCnt;
			pageValues.pageSize = pageSize;
			pageValues.totPageCnt = totPageCnt;
			pageValues.startPage = startPage;
			pageValues.endPage = endPage;
		}
}

