<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/security/tags"
	prefix="sec"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<script type="text/javascript" src="/resources/js/jquery.min.js"></script>
<!-- 외주 css 파일 -->
<link rel="stylesheet"
	href="<%=request.getContextPath()%>/resources/css/outsou/list.css" />

<script type="text/javascript">

$(function() {
    // 옵션 박스 토글 (보이기/숨기기)
    $("#opbtn").on("click", function() {
        $(".downdrop").toggle(); // 클릭할 때마다 옵션 박스 보여주거나 숨기기
    });

    // 적용하기 버튼 클릭 시
    $("#applyBtn").on("click", function(e) {
        e.preventDefault(); // 기본 폼 제출 막기
        $(".downdrop").hide(); // 옵션 박스 숨기기
        $("#searchForm").submit(); // 폼 제출
    });

    // 인기순 클릭 시
    $("#btnRdcnt").on("click", function() {
        $("#ord").val('rdcnt'); // 'rdcnt'로 정렬 설정
        $("#searchForm").submit(); // 폼 제출
    });

    // 등록순 클릭 시
    $("#btnWrtde").on("click", function() {
        $("#ord").val('wrtde'); // 'wrtde'로 정렬 설정
        $("#searchForm").submit(); // 폼 제출
    });

    // 페이지 로드 시 체크박스 값 유지
    var urlParams = new URLSearchParams(window.location.search);

    // srvcLevelCd 체크박스 상태 유지
    $('input[name="srvcLevelCd"]').each(function() {
        if (urlParams.getAll('srvcLevelCd').includes($(this).val())) {
            $(this).prop('checked', true);
        }
    });

    // srvcTeamscaleCd 체크박스 상태 유지
    $('input[name="srvcTeamscaleCd"]').each(function() {
        if (urlParams.getAll('srvcTeamscaleCd').includes($(this).val())) {
            $(this).prop('checked', true);
        }
    });

    // 동적으로 필터 값을 추가하는 함수
    function buildUrlWithFilters(baseUrl) {
        var srvcLevelCd = [];
        var srvcTeamscaleCd = [];
        var ord = $('#ord').val(); // 정렬 기준 값

        // 선택된 기술수준 체크박스 값 가져오기
        $('input[name="srvcLevelCd"]:checked').each(function() {
            srvcLevelCd.push($(this).val());
        });

        // 선택된 팀규모 체크박스 값 가져오기
        $('input[name="srvcTeamscaleCd"]:checked').each(function() {
            srvcTeamscaleCd.push($(this).val());
        });

        // URL에 필터 값 추가 (필터가 존재하는 경우에만 추가)
        if (srvcLevelCd.length > 0) {
            baseUrl += '&srvcLevelCd=' + srvcLevelCd.join(',');
        }
        if (srvcTeamscaleCd.length > 0) {
            baseUrl += '&srvcTeamscaleCd=' + srvcTeamscaleCd.join(',');
        }
        if (ord) {
            baseUrl += '&ord=' + ord;
        }

        return baseUrl;
    }

    // 동적으로 필터 값을 추가하는 함수
    function buildUrlWithFilters(baseUrl, currentPage) {
        var srvcLevelCd = [];
        var srvcTeamscaleCd = [];
        var ord = $('#ord').val(); // 정렬 기준 값

        // 페이지 번호 추가
        baseUrl += '&currentPage=' + encodeURIComponent(currentPage);

        // 선택된 기술수준 체크박스 값 가져오기
        $('input[name="srvcLevelCd"]:checked').each(function() {
            baseUrl += '&srvcLevelCd=' + encodeURIComponent($(this).val());
        });

        // 선택된 팀규모 체크박스 값 가져오기
        $('input[name="srvcTeamscaleCd"]:checked').each(function() {
            baseUrl += '&srvcTeamscaleCd=' + encodeURIComponent($(this).val());
        });

        // 정렬 값 추가
        if (ord) {
            baseUrl += '&ord=' + encodeURIComponent(ord);
        }

        return baseUrl;
    }

    // 페이지 링크 클릭 시 동적으로 필터 값 및 페이지 번호 추가
    $('.dynamic-filter-link').on('click', function(e) {
        e.preventDefault(); // 기본 링크 동작 막기

        var baseUrl = $(this).data('href'); // 고정된 부분 가져오기
        var currentPage = $(this).text(); // 클릭한 페이지 번호 가져오기 (예: 2, 3 등)

        var fullUrl = buildUrlWithFilters(baseUrl, currentPage); // 필터 값 추가된 URL 생성

        // 새 페이지로 이동
        window.location.href = fullUrl;
    });
});
</script>


<div class="submainAll">
	<div class="catnm">
	<!-- 
	action 이 생략 : 현재 URL을 재요청
	method가 생략 : get
	
	/outsou/DataList?outordMlsfc=OULC01-001&currentPage=1&srvcLevelCd=&srvcTeamscaleCd=&ord=rdcnt
	 -->
	<form id="searchForm" method="GET" action="/outsou/DataList">
		 <input type="hidden" name="outordMlsfc" value="${param.outordMlsfc}" />
	    <input type="hidden" name="currentPage" value="${param.currentPage}" />
	    <input type="hidden" id="ord" name="ord" value="${param.ord}" />
	    	
		    <c:choose>
		        <c:when test="${param.outordMlsfc == 'OULC01-007'}">
		        	   <p>데이터 구매·구축</p>
		        </c:when>
		        <c:when test="${param.outordMlsfc == 'OULC01-008'}">
		          	 <p>데이터 라벨링</p>
		        </c:when>
		        <c:when test="${param.outordMlsfc == 'OULC01-009'}">
		            <p>데이터베이스</p>
		        </c:when>
		        <c:otherwise>
		            <p>데이터</p>
		        </c:otherwise>
	    </c:choose>

		<div class="ArryOP">
			<!-- Trigger Button -->
			<input type="button"  class="trigger-btn" id="opbtn" value="옵션별" />

			<!-- 옵션별 메뉴 -->
			<div id="downdrop" class="downdrop" >
				<div class="checkbox-grid">
					<div class="chText">
						<p>기술수준</p>
					</div>
					<c:forEach var="Srle" items="${SrleList}">
						<label><input type="checkbox" id="srvcLevelCd" name="srvcLevelCd"  value="${Srle.comCode}">&nbsp;${Srle.comCodeNm}</label>
					</c:forEach>
				</div>

				<div class="hrline"></div>

				<div class="checkbox-grid">
					<div class="chText">
						<p>팀규모</p>
					</div>
					<c:forEach var="Srte" items="${SrteList}">
						<label><input type="checkbox" id="srvcTeamscaleCd" name="srvcTeamscaleCd" value="${Srte.comCode}">&nbsp;${Srte.comCodeNm}</label>
					</c:forEach>
				</div>

				<div class="hrline"></div>

				<input type="submit" class="apply-btn" id="applyBtn" value="적용하기">
			</div>
		</div>

		<div class="ArryOP">
			<!--정렬
			인기순 클릭
			 - jquery로 <input type="text" id="ord" .. 요소에 접근하여 value를 rdcnt로 변경
			 - <form id="searchForm"> 요소에 접근하여 submit
			등록순 클릭
			 - jquery로 <input type="text" id="ord" .. 요소에 접근하여 value를 wrtde로 변경
			 - <form id="searchForm"> 요소에 접근하여 submit
			 -->
			<input type="button" class="trigger-btn" id="btnRdcnt" name="btnRdcnt" value="인기순"/><!-- 파라미터에 &ord=rdcnt -->
			<input type="button" class="trigger-btn" id="btnWrtde" name="btnWrtde" value="등록순"/><!-- 파라미터에 &ord=wrtde -->
		</div>
	</form>
	</div>
</div>


<div class="newtboxAll">
	<div class="newtbox">
		<!-- 게시글 목록 -->
		<c:forEach var="getDetailVO" items="${articlePage.content}">
			<div class="item_box">
				<div class="plus"></div>
				<a class="item_thum"
					href="/outsou/detail?outordNo=${getDetailVO.outordNo}"> <img
					src="${getDetailVO.outordMainFile}"
					alt="${getDetailVO.outordMainFile}" class="product-image" id="pImg" />
				</a> <a class="item_tit"
					href="/outsou/detail?outordNo=${getDetailVO.outordNo}">
					${getDetailVO.outordTtl} </a>
				<div class="item_info_wrap clear">
					<div class="item_info">
						<hr class="outhr">
						<p class="price">
							<fmt:formatNumber pattern="#,###"
								value="${getDetailVO.outordAmt}" />원
						</p>
					</div>
				</div>
			</div>
		</c:forEach>
	</div>
</div>

<!-- 페이지 처리 -->
<!-- 페이지네이션 -->
<div class="card-body table-responsive p-0"
	style="display: flex; justify-content: center;">
<table style="margin-bottom: 30px;">
	<tr>
		<td colspan="4" style="text-align: center;">
			<div class="dataTables_paginate" id="example2_paginate"
				style="display: flex; justify-content: center; margin-top: 20px;">
				<ul class="pagination">
					
					<!-- 
					param : outordMlsfc=OULC01-001
					 -->
					
					<!-- << 처음 페이지로 이동 버튼 -->
					<c:if test="${articlePage.currentPage gt 1}">
					    <li class="paginate_button page-item first">
					        <a href="javascript:void(0);" data-href="/outsou/DataList?outordMlsfc=${param.outordMlsfc}&currentPage=1"
					           class="page-link dynamic-filter-link">&lt;&lt;</a>
					    </li>
					</c:if>
					
					<!-- 페이지 번호 -->
					<c:forEach var="pNo" begin="${articlePage.startPage}" end="${articlePage.endPage}">
					    <li class="paginate_button page-item ${pNo == articlePage.currentPage ? 'active' : ''}">
					        <a href="javascript:void(0);" data-href="/outsou/DataList?outordMlsfc=${param.outordMlsfc}&currentPage=${pNo}"
					           class="page-link dynamic-filter-link">${pNo}</a>
					    </li>
					</c:forEach>
					
					<!-- >> 다음 페이지로 이동 버튼 -->
					<c:if test="${articlePage.endPage lt articlePage.totalPages}">
					    <li class="paginate_button page-item next">
					        <a href="javascript:void(0);" data-href="/outsou/DataList?outordMlsfc=${param.outordMlsfc}&currentPage=${articlePage.endPage + 1}"
					           class="page-link dynamic-filter-link">&gt;</a>
					    </li>
					</c:if>
					
					<!-- 맨 마지막 페이지로 이동 버튼 -->
					<c:if test="${articlePage.currentPage lt articlePage.totalPages}">
					    <li class="paginate_button page-item last">
					        <a href="javascript:void(0);" data-href="/outsou/DataList?outordMlsfc=${param.outordMlsfc}&currentPage=${articlePage.totalPages}"
					           class="page-link dynamic-filter-link">&gt;&gt;</a>
					    </li>
					</c:if>


					</ul>
				</div>
			</td>
		</tr>
	</table>
</div>













