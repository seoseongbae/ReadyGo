<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/security/tags"
	prefix="sec"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<sec:authorize access="isAuthenticated()">
	<sec:authentication property="principal.memVO" var="priVO" />
</sec:authorize>
<link rel="stylesheet"
	href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200" />
<link rel="stylesheet" href="<%=request.getContextPath()%>/resources/css/member/scrap.css" />
<link rel="stylesheet" href="<%=request.getContextPath()%>/resources/css/alert.css" />

<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script type="text/javascript" src="/resources/js/jquery.min.js"></script>
<script type="text/javascript" src="/resources/js/sweetalert2.js"></script>
<script>
	//sweetAlert 창 띄우기 변수
	var Toast = Swal.mixin({
		toast : true,
		position : 'center',
		showConfirmButton : false,
		timer : 3000
	});
	$(function() {
		$(".delete").on("click", function() {
					let pbancNo = $(this).data("pbancNo");
					let mbrId = $(this).data("mbrId");
					let $this = $(this);

					let data = {
						"mbrId" : mbrId,
						"pbancNo" : pbancNo
					}
					
					 Swal.fire({
							title: '스크랩한 공고를 삭제 하시겠습니까?',
				            icon: 'error',
				            showCancelButton: true,
				            confirmButtonColor: 'white',
				            cancelButtonColor: 'white',
				            confirmButtonText: '예',
				            cancelButtonText: '아니오',
				            reverseButtons: false, // 버튼 순서 거꾸로
				            
				          }).then((result) => {
				        	  if (result.isConfirmed) {
				        		  $.ajax({
										url : '/member/delScrap',
										contentType : 'application/json;charset=utf-8',
										data : JSON.stringify(data),
										type : 'POST',
										dataType : 'json',
										beforeSend : function(xhr) {
											xhr.setRequestHeader("${_csrf.headerName}",
													"${_csrf.token}");
										},
										success : function(result) {
											Toast.fire({
												icon : 'success',
												title : '삭제 성공'
											});
											$this.closest('.scrBox').remove();
										},
										error : function(xhr, status, error) {
											Toast.fire({
												icon : 'warning',
												title : '삭제 실패'
											});
										}

									})
				        	  }
				        })
				   })
// 		// 제목 클릭시 공고 상세 페이지로 이동
// 		$(".pbanc-ttl").on("click", function() {
// 			var pbancNo = $(this).data("pbancno");
// 			window.location.href = '/enter/pbancDetail?pbancNo=' + pbancNo;
// 		})

		// 공고 상태 필터링 변경
		$("#selState").on("change", function() {
			$("#filterForm").submit();
		})
	});
</script>

<br>
<div class="container" style="position: relative; bottom: 35px;">
	<p id="h3">스크랩한 공고</p>
	<br>
	<br>
	<%--    <p>${scrapVOList}</p> --%>
	<p id="count">
		전체&nbsp;&nbsp;<span id="total">${articlePage.total}</span>
	</p>
	<br>
	<div id="filter">
		<!-- 		<input type="date" id="dateInput1" name="dateInput1">&nbsp;~&nbsp;<input type="date" id="dateInput2" name="dateInput2"> -->
		<form id="filterForm" action="/member/scrap" method="GET">
			<select id="selState" name="state">
				<option value="" <c:if test="${param.state==''}">selected</c:if>>전체</option>
				<option value="start"
					<c:if test="${param.state=='start'}">selected</c:if>>진행중</option>
				<option value="finish"
					<c:if test="${param.state=='finish'}">selected</c:if>>마감</option>
			</select>
			<div style="position: relative; top: 1px;">
				<input type="text" id="keywordInput" name="keywordInput"
					placeholder="검색" value="${param.keywordInput}">
				<button class="search" type="submit">검색</button>
				<span class="material-symbols-outlined" id="sricon">search</span>
			</div>
		</form>
	</div>
	<div class="card-body table-responsive p-0">
		<table class="table table-hover text-nowrap">
			<thead>
				<tr>
					<th class="entNm" style="font-size: 16px;">기업</th>
					<th></th>
					<th class="aplct">공고</th>
					<th style="padding-right: 50px;">마감일자</th>
				</tr>
			</thead>
			<tbody>
				<c:choose>
					<c:when test="${not empty articlePage.content}">
						<c:forEach var="pbancVO" items="${articlePage.content}"
							varStatus="stat">
							<tr class="scrBox" style="border-bottom: 1px solid #dee2e6">
							    <td class="entLogo"><img class="logo" src="${pbancVO.entLogo}" alt="${pbancVO.entLogo}"/></td>
<!-- 								<td class="entLogo"><img class="logo" src="/resources/images/enter/db그룹.jpg" alt="db그룹.jpg" /></td> -->
								<td class="entNm"
									style="margin: 0px; padding: 0px; position: relative; right: 80px; font-weight: 550;">
									${pbancVO.entNm}</td>

								<td class="aplct"><span class="pbanc-ttl"
									data-pbancno="${pbancVO.pbancNo}">
									<a target="_blank" href="/enter/pbancDetail?pbancNo=${pbancVO.pbancNo}">${pbancVO.pbancTtl}</a></span><br>
									<span class="aplcont1">${pbancVO.pbancCareerCdNm}&nbsp;&nbsp;|&nbsp;</span>
									<span class="aplcont1">${pbancVO.pbancAplctEduCdNm}↑&nbsp;&nbsp;|&nbsp;</span>
									<span class="aplcont1">${pbancVO.pbancWorkstleNm}&nbsp;&nbsp;|</span>
									<span class="aplcont1">${pbancVO.powkCd}&nbsp;</span>&nbsp;
									<span class="aplcont1">${pbancVO.pbancRprsrgnNm}</span></td>
								<td><fmt:formatDate var="currentDate"
										value="<%=new java.util.Date()%>"
										pattern="yyyy-MM-dd HH:mm:ss" /> <c:choose>
										<c:when test="${pbancVO.pbancDdlnDt < currentDate}">
											<span id="finish">마감</span>
										</c:when>
										<c:otherwise>
											<span id="start">진행 중</span>
										</c:otherwise>
									</c:choose> <br> <fmt:parseDate var="parsedDate"
										value="${pbancVO.pbancDdlnDt}" pattern="yyyy-MM-dd HH:mm:ss" />
									~<fmt:formatDate value="${parsedDate}" pattern="yyyy.MM.dd" />
									<span class="material-symbols-outlined delete"
									data-pbanc-no="${pbancVO.pbancNo}" data-mbr-id="${priVO.mbrId}">delete</span>
								</td>
							</tr>
						</c:forEach>
					</c:when>
					<c:otherwise>
						<tr>
							<td id="noSrc"colspan="4">검색 결과가 없습니다.</td>
						</tr>
					</c:otherwise>
				</c:choose>
			</tbody>
			<!-- ///////////////////// 페이징 ///////////////////// -->
			<c:if test="${not empty articlePage.content}">
			<tfoot>
				<tr style="border-top: 1px solid #666363;">
					<td colspan="4"
						style="text-align: center; border-top: 1px solid #666363;">
						<div class="dataTables_paginate" id="example2_paginate"
							style="display: flex; justify-content: center; margin-top: 10px;">
							<ul class="pagination">
								<br>
								<!-- 맨 처음 페이지로 이동 버튼 -->
								<c:if test="${articlePage.currentPage gt 1}">
									<li class="paginate_button page-item first"><a
										href="/member/scrap?mbrId=${param.mbrId}&currentPage=1&keywordInput=${param.keywordInput}&state=${param.state}"
										aria-controls="example2" data-dt-idx="0" tabindex="0"
										class="page-link">&lt;&lt;</a></li>
								</c:if>

								<!-- 이전 페이지 버튼 -->
								<c:if test="${articlePage.startPage gt 1}">
									<li class="paginate_button page-item previous"
										id="example2_previous"><a
										href="/member/scrap?mbrId=${param.mbrId}&currentPage=${(articlePage.startPage - 1) lt 1 ? 1 : (articlePage.startPage - 1)}&keywordInput=${param.keywordInput}&state=${param.state}"
										aria-controls="example2" data-dt-idx="0" tabindex="0"
										class="page-link">&lt;</a></li>
								</c:if>

								<!-- 페이지 번호 -->
								<c:forEach var="pNo" begin="${articlePage.startPage}"
									end="${articlePage.endPage}">
									<li
										class="paginate_button page-item ${pNo == articlePage.currentPage ? 'active' : ''}">
										<a
										href="/member/scrap?mbrId=${param.mbrId}&currentPage=${pNo}&keywordInput=${param.keywordInput}&state=${param.state}"
										aria-controls="example2" class="page-link">${pNo}</a>
									</li>
								</c:forEach>

								<!-- 다음 페이지 버튼 -->
								<c:if test="${articlePage.endPage lt articlePage.totalPages}">
									<li class="paginate_button page-item next" id="example2_next">
										<a
										href="/member/scrap?mbrId=${param.mbrId}&currentPage=${articlePage.startPage+5}&keywordInput=${param.keywordInput}&state=${param.state}"
										aria-controls="example2" data-dt-idx="7" tabindex="0"
										class="page-link">&gt;</a>
									</li>
								</c:if>

								<!-- 맨 마지막 페이지로 이동 버튼 -->
								<c:if
									test="${articlePage.currentPage lt articlePage.totalPages}">
									<li class="paginate_button page-item last"><a
										href="/member/scrap?mbrId=${param.mbrId}&currentPage=${articlePage.totalPages}&keywordInput=${param.keywordInput}&state=${param.state}"
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

