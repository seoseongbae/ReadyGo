<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<script type="text/javascript" src="/resources/js/jquery.min.js"></script>
<link rel="stylesheet"
	href="../resources/assets/css/templatemo-cyborg-gaming.css">
	<link rel="stylesheet" href="../../resources/css/common/pbancList.css">
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
//1. 선택박스가 변경되면
$("#selCategory").on("change", function() {
//2. 검색form을 submit 
$("#searchForm").submit();
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

// 기본적으로 regSearch div가 표시되도록 설정
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
<h3>채용정보</h3>
<div class="row">
	<!-- /// 리스트 시작 /// -->
	<div class="col-md-8" style="width: 100%;">
		<div class="card2">
			<div class="card2-body">
				<div id="category">
					<div id="categoryTap">
						<input type="button" id="region" value="지역 선택" style="background-color: rgba(44, 207, 195, 0.11);"> 
						<input type="button" id="job" value="직무 선택"> 
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
					<div id="selCheck" style=" width:90%;">
					</div>
					<button id="resetBtn" type="button">초기화</button>
					<button id="sendBtn" type="button">검색하기</button>
					<form id="DetailForm" action="#" method="get">
						<input type="hidden" id="selCity" name="selCity" value="">
						<input type="hidden" id="selJob" name="selJob" value=""> 
						<input type="hidden" id="selKeyword" name="selKeyword" value="">
					</form>
				</div>


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
					<input type="hidden" name="currentPage" value="${pNo}">
   					<input type="hidden" name="selCity" value="${param.selCity}">
    				<input type="hidden" name="selJob" value="${param.selJob}">
   			 		<input type="hidden" name="selKeyword" value="${param.selKeyword}">
				</form>
				<p class="total">전체 <span id="totalBold">${total}</span>건</p>
				<table class="table table-bordered custom-table">
					<tbody>
					<c:choose>
				        <c:when test="${not empty articlePage.content}">
							<c:forEach var="pbancVO" items="${articlePage.content}"
								varStatus="stat">
								<tr>
									<td>${pbancVO.rnum}</td>
									<td class="entNm"><span>${pbancVO.entNm}</span></td>
									<td>
									<div class="pbancContent">
									<a target="_blank" href="/enter/pbancDetail?pbancNo=${pbancVO.pbancNo}"><b>${pbancVO.pbancTtl}</b></a><br>
									<span class="smallDetail">
									${pbancVO.pbancCareerCdNm}&nbsp;&nbsp;|&nbsp;&nbsp;
									${pbancVO.pbancAplctEduCdNm}&nbsp;&nbsp;|&nbsp;&nbsp;
									<c:if test="${pbancVO.pbancRprsrgnNm != '세종' && pbancVO.pbancRprsrgnNm != '전국'}">
	                   				 ${pbancVO.pbancRprsrgnNm}
	                				</c:if>
									${pbancVO.pbancCityNm}&nbsp;&nbsp;|&nbsp;&nbsp;
									${pbancVO.pbancWorkstleCdNm}</span>
									</div>
									</td>
									<td><a target="_blank" href="/enter/pbancDetail?pbancNo=${pbancVO.pbancNo}" class="DetailGo"> 상세보기 </a></td>
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
												href="/common/pbancList?currentPage=1&selCity=${param.selCity}&selJob=${param.selJob}&selKeyword=${param.selKeyword}&order=${param.order}"
												aria-controls="example2" data-dt-idx="0" tabindex="0"
												class="page-link">&lt;&lt;</a></li>
										</c:if>

										<!-- 이전 페이지 버튼 -->
										<c:if test="${articlePage.startPage gt 1}">
											<li class="paginate_button page-item previous"
												id="example2_previous"><a
												href="/common/pbancList?currentPage=${(articlePage.startPage - 1) lt 1 ? 1 : (articlePage.startPage - 1)}&selCity=${param.selCity}&selJob=${param.selJob}&selKeyword=${param.selKeyword}&order=${param.order}"
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
												<a href="/common/pbancList?currentPage=${pNo}&selCity=${param.selCity}&selJob=${param.selJob}&selKeyword=${param.selKeyword}&order=${param.order}"
												aria-controls="example2" class="page-link">${pNo}</a>
											</li>
										</c:forEach>
										<!-- 다음 페이지 버튼 -->
										<c:if test="${articlePage.endPage lt articlePage.totalPages}">
											<li class="paginate_button page-item next" id="example2_next">
												<a
												href="/common/pbancList?currentPage=${articlePage.startPage+5}&selCity=${param.selCity}&selJob=${param.selJob}&selKeyword=${param.selKeyword}&order=${param.order}"
												aria-controls="example2" data-dt-idx="7" tabindex="0"
												class="page-link">&gt;</a>
											</li>
										</c:if>

										<!-- 맨 마지막 페이지로 이동 버튼 -->
										<c:if
											test="${articlePage.currentPage lt articlePage.totalPages}">
											<li class="paginate_button page-item last"><a
												href="/common/pbancList?currentPage=${articlePage.totalPages}&selCity=${param.selCity}&selJob=${param.selJob}&selKeyword=${param.selKeyword}&order=${param.order}"
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
