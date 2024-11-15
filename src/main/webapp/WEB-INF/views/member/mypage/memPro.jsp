<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/security/tags"
	prefix="sec"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<link rel="stylesheet"
	href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200" />
<link rel="stylesheet"
	href="<%=request.getContextPath()%>/resources/css/member/memPro.css" />
<script
	src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script type="text/javascript" src="/resources/js/jquery.min.js"></script>
<script>
	$(function() {
		$(".okBtn").on("click", function() {
			// data-pbancttl 속성에서 pbancTtl 값을 가져옴
			let propseNo = $(this).data("propse-no");
			let mbrId = $(this).data("mbr-id");
			let entNm = $(this).data("ent-nm");
			let propseCn = $(this).data("propse-cn");
			let propseTtl = $(this).data("propse-ttl");
			let propseDate = $(this).data("propse-date");
			let propseFile = $(this).data("propse-file");
			let propsePbancTtl = $(this).data("propse-pbanc-ttl");

			// modal에 반영 
			$("#modalpropseNo").val(propseNo); // 제안 번호
			$("#modalMbrId").val(mbrId); // 회원 아이디
			$("#modalpropseDate").val(propseDate); // 제안 날짜
			$("#modalpropseTtl").val(propseTtl); // 제안 제목
			$("#modalpropseCn").val(propseCn); // 제안 내용 
			$("#modalEntNm").val(entNm); // 기업 이름
			$("#modalpropseFile").val(propseFile); // 첨부파일  
			$("#modalpropsePbancTtl").val(propsePbancTtl); // 첨부파일  

			// 또는 모달의 텍스트로 표시하고 싶다면 아래 코드 사용
			// $("#modalCancel .modal-body").prepend("<p>공고 제목: " + pbancTtl + "</p>");

		});
	});
</script>
<br>
<div class="container" style="position: relative; bottom: 35px;">
	<p id="h3">받은 제안</p>
	<br>
	<br>
	<p id="count">
		전체&nbsp;&nbsp;<span id="total">${articlePage.total}</span>
	</p>
	<br>
	<div id="filter">
		<form id="filterForm" action="/member/memPro" method="GET">

		<div style="position: relative; right: 310px; top: 40px;">
			<input type="date" id="dateInput1" name="dateInput1">&nbsp;~&nbsp;

			<input type="date" id="dateInput2" name="dateInput2">
		</div>	
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
					<th class="propseDate">제안일자</th>
					<th class="entNm">기업명</th>
					<th class="propseTtl">제목</th>
					<th class="propseMng">제안서</th>
				</tr>
			</thead>
			<tbody>
			<c:choose>
				<c:when test="${not empty articlePage.content}">
					<c:forEach var="proposalVO" items="${articlePage.content}"
						varStatus="stat">
							<tr style="border-bottom: 1px solid #dee2e6;">
								<td class="propseDate"><fmt:formatDate
										value="${proposalVO.propseDate}" pattern="yyyy.MM.dd" /></td>
								<td class="entNm">${proposalVO.entNm}</td>

								<td class="propseTtl">${proposalVO.propseTtl}<br>
								</td>
								<td><span class="btn btn-default okBtn" id="okBtn"
									data-toggle="modal" data-target="#modalOk"
									data-propse-no="${proposalVO.propseNo}"
									data-mbr-id="${proposalVO.mbrId}"
									data-ent-nm="${proposalVO.entNm}"
									data-propse-ttl="${proposalVO.propseTtl}"
									data-propse-cn="${proposalVO.propseCn}"
									data-propse-date="<fmt:formatDate value='${proposalVO.propseDate}' pattern='yyyy.MM.dd'/>"
									data-propse-file="${proposalVO.propseFile}"
									data-propse-pbanc-ttl="${propsePbancTtl}">상세보기</span>
									<!--                      <span class="btn btn-default" id="noBtn">거절</span> -->
									<!--                      <span class="btn btn-default" id="successBtn">수락됨</span> -->
									<!--                      <span class="btn btn-default" id="badBtn">거절됨</span> -->
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
			<c:if test="${not empty articlePage.content}">
			<!-- ///////////////////// 페이징 ///////////////////// -->
			<tfoot>
				<tr>
					<td colspan="4" style="text-align: center; border-top: 1px solid #666363;">
						<div class="dataTables_paginate" id="example2_paginate"
							style="display: flex; justify-content: center; margin-top: 10px;">
							<ul class="pagination">
								<br>
								<!-- 맨 처음 페이지로 이동 버튼 -->
								<c:if test="${articlePage.currentPage gt 1}">
									<li class="paginate_button page-item first"><a
										href="/member/memPro?mbrId=${param.mbrId}&currentPage=1&keywordInput=${param.keywordInput}&dateInput1=${param.dateInput1}&dateInput2=${param.dateInput2}"
										aria-controls="example2" data-dt-idx="0" tabindex="0"
										class="page-link">&lt;&lt;</a></li>
								</c:if>

								<!-- 이전 페이지 버튼 -->
								<c:if test="${articlePage.startPage gt 1}">
									<li class="paginate_button page-item previous"
										id="example2_previous"><a
										href="/member/memPro?mbrId=${param.mbrId}&currentPage=${(articlePage.startPage - 1) lt 1 ? 1 : (articlePage.startPage - 1)}&keywordInput=${param.keywordInput}&dateInput1=${param.dateInput1}&dateInput2=${param.dateInput2}"
										aria-controls="example2" data-dt-idx="0" tabindex="0"
										class="page-link">&lt;</a></li>
								</c:if>

								<!-- 페이지 번호 -->
								<c:forEach var="pNo" begin="${articlePage.startPage}"
									end="${articlePage.endPage}">
									<li
										class="paginate_button page-item ${pNo == articlePage.currentPage ? 'active' : ''}">
										<a
										href="/member/memPro?mbrId=${param.mbrId}&currentPage=${pNo}&keywordInput=${param.keywordInput}&dateInput1=${param.dateInput1}&dateInput2=${param.dateInput2}"
										aria-controls="example2" class="page-link">${pNo}</a>
									</li>
								</c:forEach>

								<!-- 다음 페이지 버튼 -->
								<c:if test="${articlePage.endPage lt articlePage.totalPages}">
									<li class="paginate_button page-item next" id="example2_next">
										<a
										href="/member/memPro?mbrId=${param.mbrId}&currentPage=${articlePage.startPage+5}&keywordInput=${param.keywordInput}&dateInput1=${param.dateInput1}&dateInput2=${param.dateInput2}"
										aria-controls="example2" data-dt-idx="7" tabindex="0"
										class="page-link">&gt;</a>
									</li>
								</c:if>

								<!-- 맨 마지막 페이지로 이동 버튼 -->
								<c:if
									test="${articlePage.currentPage lt articlePage.totalPages}">
									<li class="paginate_button page-item last"><a
										href="/member/memPro?mbrId=${param.mbrId}&currentPage=${articlePage.totalPages}&keywordInput=${param.keywordInput}&dateInput1=${param.dateInput1}&dateInput2=${param.dateInput2}"
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

	<!-- 스카우트 제안 정보 모달 시작 ///////////////////////////////// -->
	<div class="modal fade" id="modalOk">
		<div class="modal-dialog">
			<div class="modal-content" style="position: relative; bottom: 40px;">
				<form id="detailForm"
					action="/member/aplctDelete?${_csrf.parameterName}=${_csrf.token}"
					method="post">
					<!-- form 시작 -->
					<div class="modal-header">
						<span id="title">스카우트 제안 정보</span>
					</div>
					<p id="proInfo">자세한 제안 정보와 제안 수락 방법은 메일에서 조회 가능합니다.</p>
					<div class="modal-body">
						<p id="propseBox">
							<label>제안 날짜</label> <input type="text" id="modalpropseDate"
								readonly /> <label>제목</label> <input type="text"
								id="modalpropseTtl" readonly /> <label>공고 제목</label> <input
								type="text" id="modalpropsePbancTtl" placeholder="-" readonly />

							<label>기업</label> <input type="text" id="modalEntNm" readonly />

							<label>내용</label>
							<!-- 	           <input type="text" id="modalpropseCn" readonly/> -->
							<textarea id="modalpropseCn" readonly></textarea>

							<input type="hidden" name="mbrId" id="modalMbrId" /> <input
								type="hidden" name="propseNo" id="modalpropseNo" /><br>
					</div>
					<sec:csrfInput />
				</form>
			</div>
			<!-- /.modal-content -->
		</div>
		<!-- /.modal-dialog -->
	</div>
	<!-- /.modal -->
</div>

