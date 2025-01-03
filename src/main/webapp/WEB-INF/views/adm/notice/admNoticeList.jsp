<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<script type="text/javascript" src="/resources/js/jquery.min.js"></script>
<script type="text/javascript" src="/resources/ckeditor5/ckeditor.js"></script>
<script type="text/javascript" src="/resources/js/sweetalert2.js"></script>
<link rel="stylesheet" href="<%=request.getContextPath()%>/resources/css/admAlert.css" />
<sec:authentication property="principal" var="prc"/>
<!-- 비로그인 또는 로그인한 사용자가 'admin'이 아닐 때 접근 금지 메시지를 표시하거나 리디렉션 -->
<sec:authorize access="!isAuthenticated() or principal.username != 'admin'">
    <script>
    Swal.fire({
        icon: 'error',
        title: '접근 권한이 없습니다',
        showConfirmButton: false,
        timer: 2000 
    }).then(() => {
        window.location.href = "/"; 
    });
    </script>
</sec:authorize>
<link rel="stylesheet"
	href="<%=request.getContextPath()%>/resources/css/board/admList.css" />
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<div class="inquiryRow">
	<div class="registTitle">
            <h1>공지 게시판</h1>
    </div>
   	<div class="sortingALl">
		<div class="count">
				<p id="count">
				전체&nbsp;&nbsp;<span id="total">${articlePage.total}</span>
			</p>
			<br>
		</div>
	</div>
       <div class="card_body table_responsive p_0">
			<table>
				<thead>
                <tr style="background:#f3f3f3; border-top: 2px solid #232323;">
                    <th class="number" style="width: 13%;">번호</th>
                    <th class="number" style="width: 2%;"></th>
                    <th class="contTitle" style="width: 40%;">제목</th>
                    <th class="write" style="width: 15%;">작성자</th>
                    <th class="write" style="width: 15%;">작성일</th>
                    <th class="cnt" style="width: 15%;">조회수</th>
                </tr>
            </thead>
            <tbody>
     	        <c:forEach var="boardVO" items="${articlePage.content}">
                <tr>
                    <td class="number">${boardVO.rnum}</td>
                    <td>
						<c:if test="${not empty boardVO.fileGroupSn}">
						    <img class="FileLink"src="/resources/icon/FileLink.png" alt="파일첨부">
						</c:if>
					</td>
                    <td class="contTitle">
	                    <a class="ListTitle" href="/adm/notice/admNoticeDetail?seNo=3&pstSn=${boardVO.pstSn}">[${boardVO.pstOthbcscope}]&nbsp;&nbsp;${boardVO.pstTtl}</a>
                    </td>
                    <td class="write" style="width: 10%;">★관리자</td>
                    <td class="write" style="width: 10%;">${boardVO.pstWrtDt}</td>
                    <td class="cnt" style="width: 10%;">${boardVO.pstInqCnt}</td>
                </tr>
                </c:forEach>
            </tbody>
            <tfoot>
				<tr></tr>
			</tfoot>
        </table>
        <div class="button-container">
            <button type="button" class="btn filter-button" onclick="location.href='/adm/notice/admNoticeRegist'">등록</button>
        </div>
		<!--페이지네이션 -->
		<div class="card-body table-responsive p-0" style="display: flex; justify-content: center;">
		    <table style="margin-bottom: 30px;">
		        <tr>
		            <td colspan="4" style="text-align: center;">
		                <div class="dataTables_paginate" id="example2_paginate" style="display: flex; justify-content: center; margin-top: 20px;">
		                    <ul class="pagination">		            
		            
			      		    <!-- 맨 처음 페이지로 이동 버튼 -->
			                <c:if test="${articlePage.currentPage gt 1}">
			                    <li class="paginate_button page-item first"><a
			                        href="/adm/notice/admNoticeList?currentPage=1"
			                        aria-controls="example2" data-dt-idx="0" tabindex="0" class="page-link">&lt;&lt;</a></li>
			                </c:if>
			                <!-- 이전 페이지 이동 버튼 -->
			                <c:if test="${articlePage.startPage gt 5}">
			                    <li class="paginate_button page-item previous">
			                        <a href="/adm/notice/admNoticeList?currentPage=${articlePage.currentPage - 5}" aria-controls="example2" data-dt-idx="0" tabindex="0" class="page-link">&lt;</a>
			                    </li>
			                </c:if>
			
			                <!-- 페이지 번호 -->
			                <c:forEach var="pNo" begin="${articlePage.startPage}" end="${articlePage.endPage}">
			                    <li class="paginate_button page-item ${pNo == articlePage.currentPage ? 'active' : ''}">
			                        <a href="/adm/notice/admNoticeList?currentPage=${pNo}" aria-controls="example2" class="page-link">${pNo}</a>
			                    </li>
			                </c:forEach>
			
			                <!-- 다음 페이지 이동 버튼 -->
			                <c:if test="${articlePage.endPage lt articlePage.totalPages}">
			                    <li class="paginate_button page-item next">
			                        <a href="/adm/notice/admNoticeList?currentPage=${articlePage.currentPage + 5}" aria-controls="example2" data-dt-idx="7" tabindex="0" class="page-link">&gt;</a>
			                    </li>
			                </c:if>
			                <!-- 맨 마지막 페이지로 이동 버튼 -->
			                <c:if test="${articlePage.currentPage lt articlePage.totalPages}">
			                    <li class="paginate_button page-item last">
			                        <a href="/adm/notice/admNoticeList?currentPage=${articlePage.totalPages}"
			                         aria-controls="example2" data-dt-idx="7" tabindex="0" class="page-link">&gt;&gt;</a></li>
			                </c:if>		
		                    </ul>
		                </div>
		            </td>
		        </tr>
		    </table>
		</div>
    </div>
</div>
