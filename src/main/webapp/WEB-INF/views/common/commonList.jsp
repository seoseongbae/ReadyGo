<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<script type="text/javascript" src="/resources/js/jquery.min.js"></script>
<script>


$(document).ready(function() {

var keyword = "${param.keyword}"; // JSP에서 설정한 keyword
	
	$('#resultText').text(keyword);
   if (keyword) {
       var regex = new RegExp('(' + keyword + ')', 'gi'); // 키워드를 대소문자 구분 없이 찾기 위한 정규 표현식

       // highlightable 클래스를 가진 td에서 키워드 강조
       $('.highlightable').each(function() {
           var html = $(this).html();
           $(this).html(html.replace(regex, '<span style="background-color: rgba(44, 207, 195, 0.30);">$1</span>'));
       });
   }

//1. 선택박스가 변경되면 (채용공고)
$("#selCategory").on("change", function() {
//2. 검색form을 submit 
$("#searchForm").submit();

});
				

//채용정보와 기업정보 선택 표시
$('#pbanc').click(function() {
	window.location.href = "/common/commonList?currentPage=1&keyword=${param.keyword}";
});

$('#enter').click(function() {
	
	window.location.href = "/common/commonList2?currentPage=1&keyword=${param.keyword}";
});

});						
</script>


<!-- 1행 영역 -->
<h4><span id="resultText" style="color:#24D59E;"></span>에 대한 검색결과입니다.</h4>
<div class="row">
	<!-- /// 리스트 시작 /// -->
	<div class="col-md-8" style="width: 100%;">
		<div class="card2">
			<div class="card2-body">

				<div id="categoryTap">
					<input type="button" id="pbanc" value="채용정보"> 
					<input type="button" id="enter" value="기업정보">
				</div>
				<!-- 채용정보 목록 시작 -->
				<div id="pbancList">
				
				<!--목록정렬 시작-->
				<form id="searchForm">
					<!--  상세검색이 들어갈지도 모름 / 정렬기준 select바-->
					<select id="selCategory" name="order">
						<option value="pbancNo"
							<c:if test="${param.order=='pbancNo'}">selected</c:if>>최신순</option>
						<option value="pbancScrapCo"
							<c:if test="${param.order=='pbancScrapCo'}">selected</c:if>>스크랩순</option>
						<option value="pbancDlnDt"
							<c:if test="${param.order=='pbancDlnDt'}">selected</c:if>>마감순</option>
					</select>
   			 		<input type="hidden" name="keyword" value="${param.keyword}">
				</form>
				<p class="total">전체 <span id="totalBold">${pbancTotal}</span>건</p>
				<!--목록정렬 끝-->
				<table class="table table-bordered custom-table">
				    <tbody>
				        <c:choose>
				            <c:when test="${not empty articlePage.content}">
				                <c:forEach var="pbancVO" items="${articlePage.content}" varStatus="stat">
				                    <tr>
				                        <td>${pbancVO.rnum}</td>
				                        <td class="highlightable">
				                            <a target="_blank" href="enter/pbancDetail?pbancNo=${pbancVO.pbancNo}"><b>${pbancVO.pbancTtl}</b></a><br>
				                            <span class="smallDetail">
				                                ${fn:escapeXml(pbancVO.pbancCareerCdNm)}&nbsp;&nbsp;|&nbsp;&nbsp;
				                                ${fn:escapeXml(pbancVO.pbancAplctEduCdNm)}&nbsp;&nbsp;|&nbsp;&nbsp;
				                                <c:if test="${pbancVO.pbancRprsrgnNm != '세종' && pbancVO.pbancRprsrgnNm != '전국'}">
				                                    ${fn:escapeXml(pbancVO.pbancRprsrgnNm)}
				                                </c:if>
				                                ${fn:escapeXml(pbancVO.pbancCityNm)}&nbsp;&nbsp;|&nbsp;&nbsp;
				                                ${fn:escapeXml(pbancVO.pbancWorkstleCdNm)}
				                            </span>
				                        </td>
				                        <td><a target="_blank" href="enter/pbancDetail?pbancNo=${pbancVO.pbancNo}" class="DetailGo">상세보기</a></td>
				                    </tr>
				                </c:forEach>
				            </c:when>
				            <c:otherwise>
				                <tr>
				                    <td colspan="3" style="text-align: center;">검색 결과가 없습니다.</td>
				                </tr>
				            </c:otherwise>
				        </c:choose>
				    </tbody>
				    <c:if test="${not empty articlePage.content}">
				        <tfoot>
				            <tr>
				                <td colspan="4" style="text-align: center;">
				                    <div class="dataTables_paginate" id="example2_paginate" style="display: flex; justify-content: center;">
				                        <ul class="pagination">
				                            <!-- 맨 처음 페이지로 이동 버튼 -->
				                            <c:if test="${articlePage.currentPage gt 1}">
				                                <li class="paginate_button page-item first"><a
				                                    href="/common/commonList?currentPage=1&keyword=${param.keyword}&order=${param.order}"
				                                    aria-controls="example2" data-dt-idx="0" tabindex="0"
				                                    class="page-link">&lt;&lt;</a></li>
				                            </c:if>
				
				                            <!-- 이전 페이지 버튼 -->
				                            <c:if test="${articlePage.startPage gt 1}">
				                                <li class="paginate_button page-item previous" id="example2_previous"><a
				                                    href="/common/commonList?currentPage=${(articlePage.startPage - 1) lt 1 ? 1 : (articlePage.startPage - 1)}&keyword=${param.keyword}&order=${param.order}"
				                                    aria-controls="example2" data-dt-idx="0" tabindex="0"
				                                    class="page-link">&lt;</a></li>
				                            </c:if>
				
				                            <!-- 페이지 번호 -->
				                            <c:forEach var="pNo" begin="${articlePage.startPage}" end="${articlePage.endPage}">
				                                <li class="paginate_button page-item ${pNo == articlePage.currentPage ? 'active' : ''}">
				                                    <a href="/common/commonList?currentPage=${pNo}&keyword=${param.keyword}&order=${param.order}"
				                                       aria-controls="example2" class="page-link">${pNo}</a>
				                                </li>
				                            </c:forEach>
				
				                            <!-- 다음 페이지 버튼 -->
				                            <c:if test="${articlePage.endPage lt articlePage.totalPages}">
				                                <li class="paginate_button page-item next" id="example2_next">
				                                    <a href="/common/commonList?currentPage=${articlePage.startPage+5}&keyword=${param.keyword}&order=${param.order}"
				                                       aria-controls="example2" data-dt-idx="7" tabindex="0"
				                                       class="page-link">&gt;</a>
				                                </li>
				                            </c:if>
				
				                            <!-- 맨 마지막 페이지로 이동 버튼 -->
				                            <c:if test="${articlePage.currentPage lt articlePage.totalPages}">
				                                <li class="paginate_button page-item last"><a
				                                    href="/common/commonList?currentPage=${articlePage.totalPages}&keyword=${param.keyword}&order=${param.order}"
				                                    aria-controls="example2" data-dt-idx="7" tabindex="0"
				                                    class="page-link">&gt;&gt;</a></li>
				                            </c:if>
				                        </ul>
				                    </div>
				                </td>
				            </tr>
				        </tfoot>
				    </c:if>
				</table>
				</div> <!-- 채용정보 목록 끝 -->
			</div>
		</div>
	</div>
</div>
<!-- /// 리스트 끝 /// -->
<style> /* 페이징 css 시작*/
.page-link {
	color: black;
	border-radius: 7px;
	margin: 5px;
} /* 버튼클릭했을 때! */
.page-item.active .page-link {
	z-index: 3;
	font-weight: 700;
	color: #24D59E;
	background-color: rgba(44, 207, 195, 0.11);
	border-radius: 7px;
}

.write_date {
	text-align: right;
}

.page-item.active .page-link {
	border-color: #dee2e6;
}

a.page-link:hover {
	color: #000000;
	background-color: #dee2e6;
} /* 페이징 css 끝*/


#categoryTap {
	display: flex;
	align-items: center;
}

#pbanc, #enter{
	width: 100%;
	height: 50px;
	border: 1px solid #D6D6D6;
	transition: background-color 0.3s;
	
}

#enter {
	background-color: white;
}

#pbanc {
	background-color: rgba(44, 207, 195, 0.11);
}


#regSearch {
	display: flex;
	width: 100%;
}


.row {
	margin: 0px 20% 0px 20%;
	min-height : 1170px;
}

#selCategory {
	float: right;
	margin: 20px 0 5px 0;
	border-radius: 5px;
    font-size: 14px;
    height: 40px;
    border: 1px solid #ddd;
    padding: 10px;
    font-size: 16px;

}


h4 {
margin : 30px 0px 15px 21%;
}

.DetailGo {
float: right; 
padding: 5px 15px;
background: white;
color: #232323;
border: 1px solid #B5B5B5;
border-radius: 5px;
font-weight: 500;
transition: all 0.3s ease 0s;
}

.DetailGo:hover {
background: #ECECEC;
border: 1px solid #B5B5B5;
color: #232323;
}
.smallDetail {
	font-size: 0.8em;
	color : #666363;
}
.custom-table {
    border-collapse: collapse; /* 테두리 겹침 방지 */
}

.custom-table td {
	padding : 10px 20px 10px 20px;
    border-left: none !important; /* 세로선 제거 */
    border-right: none !important; /* 세로선 제거 */
}

.custom-table tr td:first-child {
    border-left: 1px solid black; /* 왼쪽 가장자리 테두리 유지 (선택 사항) */
}

.custom-table tr td:last-child {
    border-right: 1px solid black; /* 오른쪽 가장자리 테두리 유지 (선택 사항) */
}
.total{
	font-size: 16px;
}
#totalBold{
	font-weight: bold;
	font-size: 18px;
}

</style>