<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<script type="text/javascript" src="/resources/js/jquery.min.js"></script>
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
<style>
#wait{
	color: #666363;
	width : 100px;
	background-color: rgb(244 244 244);
    font-weight: 450;
    border: none;
    border-radius: 999px;
    margin-left: 73px;
    height: 40px;
    padding-top: 10px;
}
#complete{
	color: #FD5D6C;
	width : 100px;
    background-color: rgba(253, 93, 108, 0.3);
    font-weight: 450;
    border: none;
    border-radius: 999px;
    margin-left: 73px;
    height: 40px;
    padding-top: 10px;
}
#admNotice{
	color: white;
	width : 100px;
	background-color: #FD5D6C;
    font-weight: 450;
    border: none;
    border-radius: 999px;
    margin-left: 73px;
    height: 40px;
    padding-top: 10px;
}
.table_responsive table tr td{
	padding: 0px !important;
}
</style>
<link rel="stylesheet"
	href="<%=request.getContextPath()%>/resources/css/board/admList.css" />
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<div class="inquiryRow">
	<div class="registTitle">
        <h1>문의 게시판</h1>
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
					<th class="number" style="width: 20%;">상태</th>
					<th class="contTitle" style="width: 40%;">제목</th>
					<th class="Public" style="width: 10%;">공개설정</th>
					<th class="write" style="width: 15%;">작성자</th>
					<th class="write" style="width: 15%;">작성일</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="boardVO" items="${articlePage.content}">
                <tr style="<c:if test='${boardVO.mbrId == "admin"}'>background-color: rgba(253, 93, 108, 0.11);</c:if>">
                    <td style="display: flex; align-items: center; padding-top: 10px !important;">
						<c:if test="${boardVO.mbrId == 'admin'}"><p id="admNotice">${boardVO.pstOthbcscope}</p></c:if>
			            <c:if test="${boardVO.mbrId != 'admin'}">
			                <c:choose>
			                    <c:when test="${boardVO.replyCnt gt 0}">
			                        <p id="complete">답변완료</p>
			                    </c:when>
			                    <c:otherwise>
			                        <p id="wait">답변대기</p>
			                    </c:otherwise>
			                </c:choose>
			            </c:if>
                    </td>
			        <td class="contTitle">
	                    <a class="ListTitle" 
	                    	href="/adm/inquiryBoard/admInquiryDetail?seNo=4&pstSn=${boardVO.pstSn}"
			                data-pst-othbcscope="${boardVO.pstOthbcscope}"
			                data-mbr-id="${boardVO.mbrId}">${boardVO.pstTtl}</a>
                   	</td>
                    <td style="text-align: center;">
                    	<c:if test="${boardVO.mbrId=='admin'}"></c:if>
                    	<c:if test="${boardVO.mbrId!='admin'}"> ${boardVO.pstOthbcscope}</c:if>
                    </td>
                    <c:choose>
                    	<c:when test="${boardVO.mbrId=='admin'}">
		                    <td style="text-align: center;">★관리자</td>
                    	</c:when>
                    	<c:otherwise>
		                    <td style="text-align: center;">${boardVO.mbrId}</td>
                    	</c:otherwise>
                    </c:choose>
                    <td style="text-align: center;">${boardVO.pstWrtDt}</td>
                </tr>
                </c:forEach>
            </tbody>
            <tfoot>
				<tr></tr>
			</tfoot> 
        </table>
        <div class="button-container">
            <button type="button" class="btn filter-button" onclick="location.href='/adm/inquiryBoard/admInquiryRegist'">등록</button>
        </div>
        
        <!-- Pagination -->
		<div class="card-body table-responsive p-0" style="display: flex; justify-content: center;">
		    <table style="margin-bottom: 30px;">
		        <tr>
		            <td colspan="4" style="text-align: center;">
        		        <div class="dataTables_paginate" id="example2_paginate" style="display: flex; justify-content: center;">
		                    <ul class="pagination">
		            
		            
      		    <!-- 맨 처음 페이지로 이동 버튼 -->
                <c:if test="${articlePage.currentPage gt 1}">
                    <li class="paginate_button page-item first"><a
                        href="/adm/inquiryBoard/admInquiryList?currentPage=1"
                        aria-controls="example2" data-dt-idx="0" tabindex="0" class="page-link">&lt;&lt;</a></li>
                </c:if>
                <!-- 이전 페이지 이동 버튼 -->
                <c:if test="${articlePage.startPage gt 5}">
                    <li class="paginate_button page-item previous">
                        <a href="/adm/inquiryBoard/admInquiryList?currentPage=${articlePage.currentPage - 5}" aria-controls="example2" data-dt-idx="0" tabindex="0" class="page-link">&lt;</a>
                    </li>
                </c:if>

                <!-- 페이지 번호 -->
                <c:forEach var="pNo" begin="${articlePage.startPage}" end="${articlePage.endPage}">
                    <li class="paginate_button page-item ${pNo == articlePage.currentPage ? 'active' : ''}">
                        <a href="/adm/inquiryBoard/admInquiryList?currentPage=${pNo}" aria-controls="example2" class="page-link">${pNo}</a>
                    </li>
                </c:forEach>

                <!-- 다음 페이지 이동 버튼 -->
                <c:if test="${articlePage.endPage lt articlePage.totalPages}">
                    <li class="paginate_button page-item next">
                        <a href="/adm/inquiryBoard/admInquiryList?currentPage=${articlePage.currentPage + 5}" aria-controls="example2" data-dt-idx="7" tabindex="0" class="page-link">&gt;</a>
                    </li>
                </c:if>
                <!-- 맨 마지막 페이지로 이동 버튼 -->
                <c:if test="${articlePage.currentPage lt articlePage.totalPages}">
                    <li class="paginate_button page-item last">
                        <a href="/adm/inquiryBoard/admInquiryList?currentPage=${articlePage.totalPages}"
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

