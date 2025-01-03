<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec"%>   
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>   

<link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200" />
<link rel="stylesheet" href="<%=request.getContextPath() %>/resources/css/member/myBoard.css" />
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script> 
<script type="text/javascript" src="/resources/js/jquery.min.js"></script>
<script>
$(function(){

});


</script>

<br>
<div class="container" style="position: relative; bottom: 35px;">
   <p id="h3">작성글 관리</p>
   <br><br>
   <p id="count">전체&nbsp;&nbsp;<span id="total">${articlePage.total}</span></p><br>
   <div id="flexDiv">
   <p class="middleTitle">문의게시판 작성글 목록</p>
   <div id="filter">
		<form id="filterForm" action="/member/myInquiryBoard" method="GET">
		
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
	</div>
   <div class="card-body table-responsive p-0">
            <table class="table table-hover text-nowrap">
            <thead>
               <tr>
                  <th style="text-align: left; padding-left: 82px;">상태</th>
                  <th class="entNm">제목</th>
                  <th class="aplct">공개설정</th>
                  <th>작성자</th>
                  <th>작성일</th>
               </tr>
            </thead>
            <tbody>
            <c:choose>
			<c:when test="${not empty articlePage.content}">
            <c:forEach var="boardVO" items="${articlePage.content}">
				    <tr style="border-bottom: 1px solid #dee2e6;">
				        <td>
			                <c:choose>
			                    <c:when test="${boardVO.replyCnt gt 0}"> <!-- 상태 -->
			                        	<p id="complete">답변완료</p>
			                    </c:when>
			                    <c:otherwise>
			                        	<p id="wait">답변대기</p>
			                    </c:otherwise>
			                </c:choose>
				        </td>
				        <td class="contTitle" style="text-align: left;">
				            <a target="_blank" class="ListTitle"
				                href="/common/inquiryBoard/inquiryDetail?seNo=4&pstSn=${boardVO.pstSn}">${boardVO.pstTtl}</a>
				        </td>
				        <td>${boardVO.pstOthbcscope}</td> <!-- 공개설정 -->
				        <td>${boardVO.mbrId}</td>	<!-- 작성자 -->
				        <td>${boardVO.pstWrtDt}</td> <!-- 작성일 -->
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
                  <td colspan="5" style="text-align: center; border-top: 1px solid #666363;">
                     <div class="dataTables_paginate" id="example2_paginate"
                        style="display: flex; justify-content: center; margin-top:10px;">
                        <ul class="pagination">
                                       <br>
                        <!-- 맨 처음 페이지로 이동 버튼 -->
                        <c:if test="${articlePage.currentPage gt 1}">
                            <li class="paginate_button page-item first">
                                <a href="/member/myInquiryBoard?mbrId=${param.mbrId}&currentPage=1&keywordInput=${param.keywordInput}&dateInput1=${param.dateInput1}&dateInput2=${param.dateInput2}"
                                   aria-controls="example2" data-dt-idx="0" tabindex="0" class="page-link">&lt;&lt;</a>
                            </li>
                        </c:if>

                           <!-- 이전 페이지 버튼 -->
                           <c:if test="${articlePage.startPage gt 1}">
                               <li class="paginate_button page-item previous" id="example2_previous">
                                    <a href="/member/myInquiryBoard?mbrId=${param.mbrId}&currentPage=${(articlePage.startPage - 1) lt 1 ? 1 : (articlePage.startPage - 1)}&keywordInput=${param.keywordInput}&dateInput1=${param.dateInput1}&dateInput2=${param.dateInput2}"
                                      aria-controls="example2" data-dt-idx="0" tabindex="0" class="page-link">&lt;</a>
                               </li>
                           </c:if>
                           
                           <!-- 페이지 번호 -->
                           <c:forEach var="pNo" begin="${articlePage.startPage}" end="${articlePage.endPage}">
                               <li class="paginate_button page-item ${pNo == articlePage.currentPage ? 'active' : ''}">
                                   <a href="/member/myInquiryBoard?mbrId=${param.mbrId}&currentPage=${pNo}&keywordInput=${param.keywordInput}&dateInput1=${param.dateInput1}&dateInput2=${param.dateInput2}" 
                                   aria-controls="example2" class="page-link">${pNo}</a>
                               </li>
                           </c:forEach>
                           
                           <!-- 다음 페이지 버튼 -->
                           <c:if test="${articlePage.endPage lt articlePage.totalPages}">
                               <li class="paginate_button page-item next" id="example2_next">
                                   <a href="/member/myInquiryBoard?mbrId=${param.mbrId}&currentPage=${articlePage.startPage+5}&keywordInput=${param.keywordInput}&dateInput1=${param.dateInput1}&dateInput2=${param.dateInput2}"
                                      aria-controls="example2" data-dt-idx="7" tabindex="0" class="page-link">&gt;</a>
                               </li>
                           </c:if>
                           
                           <!-- 맨 마지막 페이지로 이동 버튼 -->
                        <c:if test="${articlePage.currentPage lt articlePage.totalPages}">
                            <li class="paginate_button page-item last">
                                <a href="/member/myInquiryBoard?mbrId=${param.mbrId}&currentPage=${articlePage.totalPages}&keywordInput=${param.keywordInput}&dateInput1=${param.dateInput1}&dateInput2=${param.dateInput2}"
                                   aria-controls="example2" data-dt-idx="7" tabindex="0" class="page-link">&gt;&gt;</a>
                            </li>
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

