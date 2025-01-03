<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<script type="text/javascript" src="/resources/js/jquery.min.js"></script>
<link rel="stylesheet"
	href="../resources/assets/css/templatemo-cyborg-gaming.css">
<script>


$(document).ready(function() {
	
	//저장된 검색영역 데이터를 불러옴
	$("#selCheck").html(sessionStorage.getItem("searchHtml"));
	$("#selCheck").css("width","90%").css("display","flex");
	
	$(".regText").on("click", function() {
		
		// 이전에 regTextActive 클래스가 있는 버튼에서 제거
	    $(".regText").removeClass('regTextActive');

	    // 클릭한 버튼에 regTextActive 클래스 추가
	    $(this).addClass('regTextActive');
		
		let comCode = $(this).data('com-code');
		
	    $.ajax({
	        url: '/common/cityList', // 요청할 URL
	        type: 'GET', // HTTP 메서드
	        data: { comCode: comCode }, // 전송할 데이터
	        success: function(response) {
	        	
	        	const cityListContainer = $('#cityListContainer');
	    	    cityListContainer.empty(); // 기존 내용을 비움

	    	    let listItem = ''; // li 태그를 저장할 변수

	    	    // 도시 목록을 동적으로 추가
	    	    $.each(response, function(index, city) {
	    	        if (index % 4 === 0) {
	    	            // 4개마다 li 태그 시작
	    	            if (listItem) {
	    	                cityListContainer.append(listItem); // 이전 li 닫기
	    	            }
	    	            listItem = '<li>'; // 새로운 li 태그 시작
	    	        }

	    	        listItem += '<p class="cityText" data-city-name="' + city.comCodeNm + '">' +
	    	            '<input type="checkbox" name="selCity" data-region="' + city.upperComCodeNm + '" value="' + city.comCode + '">' +
	    	            city.comCodeNm +
	    	            '</p>';

	    	        // 마지막 요소인지 확인하여 li 태그 닫기
	    	        if (index === response.length - 1) {
	    	            listItem += '</li>'; // 마지막 li 태그 닫기
	    	        }
	    	    });

	    	    // 모든 li 태그 추가
	    	    if (listItem) {
	    	        cityListContainer.append(listItem);
	    	    }
	        },
	        error: function(xhr, status, error) {
	            // 오류 발생 시 처리할 코드 
	            console.error(error);
	        }
	    });
	});
		
// 상세검색 제출 클릭
$("#sendBtn").on("click", function() {
	//동적으로 생성된 검색 정보
	let searchHtml = $("#selCheck").html();
	sessionStorage.setItem("searchHtml",searchHtml);
	
//2. 검색form을 submit 
	$("#DetailForm").submit();
});

//검색조건 초기화
$("#resetBtn").on("click", function() {
	//저장된 검색영역 데이터를 초기화
	$("#selCheck").empty();
	sessionStorage.setItem("searchHtml","");
});

$('#cityListContainer').on('change', 'input[name="selCity"]', function() {
    const regText = $(this).data('region'); // 클릭한 지역 코드 가져오기
    const cityText = $(this).parent('.cityText').data('city-name'); // 클릭한 도시 텍스트 가져오기

    // 선택된 도시 표시
//     const existingCities = $('#selCheck .selected-cities'); // 기존 도시 표시 부분
//     const selectedCityHtml = `<b>\${regText} \${cityText}</b>`;
    const existingCities = $('#selCheck .selected-cities'); // 기존 도시 표시 부분
    
    if ($(this).is(':checked')) {
    	// 선택된 도시 표시
        let selectedCityHtml = '';

        // regText가 '세종시'일 때만 cityText를 append
        if (regText === '세종') {
            selectedCityHtml = `\${cityText}`;
        } else {
            selectedCityHtml = `\${regText} \${cityText}`;
        }

        if (existingCities.length) {
            existingCities.append(`<b>, \${selectedCityHtml}</b>`); // 기존 도시 뒤에 추가
        } else {
            $('#selCheck').css('display', 'flex').html(`<div class="selected-cities">선택 지역 >> <b>\${selectedCityHtml}</b></div>&nbsp;&nbsp;&nbsp;`);
        }
    } else {
    	// 체크 해제된 경우
         existingCities.find(`b:contains("\${regText} \${cityText}")`).remove();
    }

    // 선택된 도시 코드 저장
    const selectedCities = $('input[name="selCity"]:checked').map(function() {
        return $(this).val();
    }).get().join(','); // 체크된 도시 코드들을 쉼표로 구분하여 문자열로 변환

    $('#selCity').val(selectedCities); // 숨겨진 입력 필드에 저장
});								

// 직업 선택
$('input[name="selJob"]').on('change',function(event) {
event.preventDefault(); // 기본 링크 클릭 동작 방지



const jobText = $(this).parent('.jobText').data('job-name');
const jobCode = $(this).val(); // 클릭한 직업 코드 가져오기

//선택된 직업 표시
const existingJobs = $('#selCheck .selected-jobs'); // 기존 직업 표시 부분

if ($(this).is(':checked')) {
	// 선택된 도시 표시
	if (existingJobs.length) {
    	existingJobs.append(`<b>, \${jobText}</b>`); // 기존 직업 뒤에 추가
	} else {
    	$('#selCheck').css('display', 'flex').append(`&nbsp;&nbsp;&nbsp;<div class="selected-jobs">선택 직무 >> <b>\${jobText}</b></div>`);
	}
} else {
	// 체크 해제된 경우
     existingJobs.find(`b:contains("\${jobText}")`).remove();
}

//선택된 직업 코드 저장
const selectedJobs = $('input[name="selJob"]:checked').map(function() {
    return $(this).val();
}).get().join(','); // 체크된 직업 코드들을 쉼표로 구분하여 문자열로 변환

$('#selJob').val(selectedJobs); // 숨겨진 입력 필드에 저장

});								

//키워드 입력 실시간 표시 및 저장
$('#keywordInput').on('keyup', function() {
    let keyword = $(this).val(); // 입력된 키워드 가져오기
    console.log(keyword);
    $('#selCheck .keyword-display').remove(); // 기존 키워드 표시 제거

    if (keyword) {
        $('#selCheck').append(`<div class="keyword-display">&nbsp;&nbsp;&nbsp;키워드 >> <b>\${keyword}</b></div>`); // 새로운 키워드 표시
    }
    
    $('#selKeyword').val(keyword);
});

//기본적으로 regSearch div가 표시되도록 설정
$('#region').click(function() {
	$('#regSearch').show();
	$('#jobDiv, #keywordDiv').hide();
	$(this).addClass('colorActive'); 
    $('#job, #keyword').removeClass('colorActive');
});

$('#job').click(function() {
	sessionStorage.setItem("searchHtml","");
	$('#regSearch').hide();
	$('#jobDiv').show();
	$('#keywordDiv').hide();
	$(this).addClass('colorActive'); 
	$('#region').css('background-color','white');
    $('#region, #keyword').removeClass('colorActive');
});

$('#keyword').click(function() {
	sessionStorage.setItem("searchHtml","");
	$('#regSearch, #jobDiv').hide();
	$('#keywordDiv').show();
	$(this).addClass('colorActive'); 
	$('#region').css('background-color','white');
    $('#region, #job').removeClass('colorActive');
});

//검색어 삭제 버튼 동작 추가
$('.btn-close').on('click', function() {
    $('#keywordInput').val('');

});

});						
</script>


<!-- 1행 영역 -->
<h3>기업정보</h3>
<div class="row">
	<!-- /// 리스트 시작 /// -->
	<div class="col-md-8" style="width: 100%;">
		<div class="card2">
			<div class="card2-body">
				<div id="category">
					<div id="categoryTap">
						<input type="button" id="region" value="지역 선택" style="background-color: rgba(44, 207, 195, 0.11);"> 
						<input type="button" id="job" value="업종 선택">
						<input type="button" id="keyword" value="검색어 입력" style="border-right: none;">
					</div>
					<div id="regSearch">
						<div id="selectReg" style="width: 33%;">
							<ul>
								<c:forEach var="region" items="${regionList}" varStatus="stat">
									<c:if test="${stat.index % 3 == 0}">
										<li>
									</c:if>
									<button class="regText" data-com-code="${region.comCode}">
                   						 ${region.comCodeNm}</button>
									<c:if test="${stat.index % 3 == 2 || stat.last}">
										</li>
									</c:if>
								</c:forEach>
							</ul>
						</div>
						<div id="selectCity" style="width: 67%;">
							<ul id="cityListContainer">
        						<!-- 도시 목록이 여기에 동적으로 추가됨 -->
   							</ul>
						</div>
					</div>
					<!-- //regSearch -->
					<div id="jobDiv" style="display: none;">
						<ul>
							<c:forEach var="job" items="${jobList}" varStatus="stat">
								<c:if test="${stat.index % 5 == 0}">
									<li>
								</c:if>
								<p class="jobText" data-job-name="${job.comCodeNm}">
   									<input type="checkbox" name="selJob" value="${job.comCode}">
    										${job.comCodeNm}</p>
								<c:if test="${stat.index % 5 == 4 || stat.last}">
									</li>
								</c:if>
							</c:forEach>
						</ul>
					</div>

					<div id="keywordDiv" style="display: none;">
						<div class="search-input">
							<input type="text" id="keywordInput" placeholder="검색어를 입력하세요">
							<button class="btn-close"></button>
						</div>
					</div>
				</div>
				<!-- //category -->

				<div id="sendDiv" style="display:flex">
					<div id="selCheck" style=" width:90%;"></div>
					<button id="resetBtn" type="button">초기화</button>
					<button id="sendBtn" type="button">검색하기</button>
					<form id="DetailForm" action="#" method="get">
						<input type="hidden" id="selCity" name="selCity" value="">
						<input type="hidden" id="selJob" name="selJob" value=""> 
						<input type="hidden" id="selKeyword" name="selKeyword" value="">
					</form>
				</div>

				<p class="total">전체 <span id="totalBold">${total}</span>건</p>
				<table class="table table-bordered custom-table">
					<tbody>
					<c:choose>
				        <c:when test="${not empty articlePage.content}">
							<c:forEach var="enterVO" items="${articlePage.content}"
	 							varStatus="stat"> 
								<tr>
	 								<td width="160px" height="80px">
	 								<img class="entlogo" src="${enterVO.entLogo}" />
	 								</td>
	 								<td>
	 								<a target="_blank" href="/enter/profile?entId=${enterVO.entId}"><b>${enterVO.entNm}</b></a><br>
	 								<span class="smallDetail">
	 								${enterVO.entStleCdNm}&nbsp;&nbsp;|&nbsp;&nbsp;
	 								<c:if test="${enterVO.entRprsrgnNm != '세종' && enterVO.entRprsrgnNm != '전국'}">
	 								${enterVO.entRprsrgnNm}
	 								</c:if>
	 								${enterVO.entCityNm}&nbsp;&nbsp;|&nbsp;&nbsp;
	 								${enterVO.tpbizSeCdNm}</span>
	 								</td>
	 								<td><a target="_blank" href="/enter/profile?entId=${enterVO.entId}" class="DetailGo"> 기업정보 </a></td> 
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
								<div class="dataTables_paginate" id="example2_paginate"
									style="display: flex; justify-content: center;">
									<ul class="pagination">
										<!-- 맨 처음 페이지로 이동 버튼 -->
										<c:if test="${articlePage.currentPage gt 1}">
											<li class="paginate_button page-item first"><a
												href="/common/enterList?currentPage=1&selCity=${param.selCity}&selJob=${param.selJob}&selKeyword=${param.selKeyword}&order=${param.order}"
												aria-controls="example2" data-dt-idx="0" tabindex="0"
												class="page-link">&lt;&lt;</a></li>
										</c:if>

										<!-- 이전 페이지 버튼 -->
										<c:if test="${articlePage.startPage gt 1}">
											<li class="paginate_button page-item previous"
												id="example2_previous"><a
												href="/common/enterList?currentPage=${(articlePage.startPage - 1) lt 1 ? 1 : (articlePage.startPage - 1)}&selCity=${param.selCity}&selJob=${param.selJob}&selKeyword=${param.selKeyword}&order=${param.order}"
												aria-controls="example2" data-dt-idx="0" tabindex="0"
												class="page-link">&lt;</a></li>
										</c:if>
										<!-- 페이지 번호
										selCity=&selJob=&selKeyword=셀   또한 같이가야함
										param : selCity=&selJob=&selKeyword=셀
										param.selKeyword => 셀
										 -->
										<c:forEach var="pNo" begin="${articlePage.startPage}"
											end="${articlePage.endPage}">
											<li
												class="paginate_button page-item ${pNo == articlePage.currentPage ? 'active' : ''}">
												<a href="/common/enterList?currentPage=${pNo}&selCity=${param.selCity}&selJob=${param.selJob}&selKeyword=${param.selKeyword}&order=${param.order}"
												aria-controls="example2" class="page-link">${pNo}</a>
											</li>
										</c:forEach>
										<!-- 다음 페이지 버튼 -->
										<c:if test="${articlePage.endPage lt articlePage.totalPages}">
											<li class="paginate_button page-item next" id="example2_next">
												<a
												href="/common/enterList?currentPage=${articlePage.startPage+5}&selCity=${param.selCity}&selJob=${param.selJob}&selKeyword=${param.selKeyword}&order=${param.order}"
												aria-controls="example2" data-dt-idx="7" tabindex="0"
												class="page-link">&gt;</a>
											</li>
										</c:if>

										<!-- 맨 마지막 페이지로 이동 버튼 -->
										<c:if
											test="${articlePage.currentPage lt articlePage.totalPages}">
											<li class="paginate_button page-item last"><a
												href="/common/enterList?currentPage=${articlePage.totalPages}&selCity=${param.selCity}&selJob=${param.selJob}&selKeyword=${param.selKeyword}&order=${param.order}"
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


#category {
	width: 100%;
	height: 230px;
	border: 1px solid #D6D6D6;
}

#categoryTap {
	display: flex;
	align-items: center;
}

#region, #job, #keyword {
	width: 100%;
	height: 50px;
	border: 1px solid #D6D6D6;
	background: #FFFFFF;
	border: none;
    border-right: 1px solid #dee2e6;
    border-bottom: 1px solid #dee2e6;
}

#selectReg {
	overflow-y: auto;
	height: 150px;
	margin: 15px 15px 15px 15px;
}

#selectCity {
	overflow-y: auto;
	height: 150px;
	margin: 15px 0px 15px 0px;
}

.regText {
/*  	border: 1.5px solid #24D59E;  */
	border: none;
	background : white;
	color: #666;
	border-radius: 5px;
	margin: 10px 5px 10px 5px;
	display: inline-block; /* 블록 형식으로 처리 */
	width: 90px; /* 원하는 고정 너비 설정 */
	text-align: center; /* 텍스트 중앙 정렬 */
	cursor: pointer;
	transition: background-color 0.3s;
}
.regText:hover {
	background-color: #24D59E;
	color: white;
	font-weight: bold;
}

.colorActive{
	background-color: rgba(44, 207, 195, 0.11) !important;
}

.cityText {
	margin: 20px 10px 20px 10px;
	display: inline-block; /* 블록 형식으로 처리 */
	width: 130px; /* 원하는 고정 너비 설정 */
	text-align: center; /* 텍스트 중앙 정렬 */
}
.cityText input[type="checkbox"] {
    margin-right: 5px; /* 체크박스 오른쪽에 5px의 여백 추가 */
}

#regSearch {
	display: flex;
	width: 100%;
}

#jobDiv {
	overflow-y: auto;
	height: 130px;
	margin: 15px 0px 15px 0px;
}

.jobText {
	margin: 20px 20px 20px 20px;
	display: inline-block; /* 블록 형식으로 처리 */
	width: 170px; /* 원하는 고정 너비 설정 */
	text-align: center; /* 텍스트 중앙 정렬 */
}

.row {
	margin: 0px 20% 0px 20%;
	min-height : 1300px;
}


#selCheck {
	background-color: #EBEBEB;
	border-radius: 10px;
	height: 60px;
	padding: 20px 20px 0px 20px;
	font-size: 14px;
	margin-top: 10px;
}

#sendBtn {
	width : 10%;
	background-color: #24D59E;
	padding: 10px 15px 10px 15px;
	border: 1px solid #EBEBEB;
	border-radius: 10px;
	color: white;
	margin: 10px 0px 0px 10px;
	transition: all 0.3s ease 0s;
}

.search-input{
	
	display : flex;
	align-items: center;
/* 	gap: 10px; */
}
#keywordDiv{
	margin-left: 66.5%;
	height: 180px;
	border: 1px solid #EBEBEB;
}
#keywordInput {
width : 95%;
border: 1px solid #D9D9D9;
}

h3 {
margin : 30px 0px 15px 24%;
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
vertical-align: middle;
margin-top: 10px;
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
.entlogo{
	width: 100%;
	height: 100%;
    aspect-ratio: 2 / 1; /* CSS Aspect Ratio 사용 */
}
.total {
    font-size: 16px;
    width: 100px;
    position: relative;
}	
#totalBold{
	font-weight: bold;
	font-size: 18px;
}
.btn-close{
	border-left : none;
	padding : 8px;
	border-radius:  0;
	border: 1px solid #D9D9D9;
}
#resetBtn {
	width : 8%;
	background-color: #EBEBEB;
	padding: 10px 15px 10px 15px;
	border: 1px solid #EBEBEB;
	border-radius: 10px;
	margin: 10px 0px 0px 10px;
	transition: all 0.3s ease 0s;
}

.regTextActive{
	background-color: #24D59E;
	color: white;
	font-weight: bold;
}

</style>