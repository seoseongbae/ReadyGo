<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<script type="text/javascript" src="/resources/js/jquery.min.js"></script>
<script type="text/javascript" src="/resources/ckeditor5/ckeditor.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@10"></script>
<link rel="stylesheet" href="<%=request.getContextPath()%>/resources/css/alert.css" />
<!-- css 파일 -->
<link rel="stylesheet"
	href="<%=request.getContextPath()%>/resources/css/board/freeList.css" />
<sec:authentication property="principal" var="prc"/>

<script type="text/javascript">
$(document).ready(function() {
    $('.boardRegist').on('click', function(event) {
        var prcUsername = '${prc != "anonymousUser" ? prc.username : "anonymousUser"}';

        if (prcUsername === "anonymousUser") {
            event.preventDefault(); // 기본 폼 제출 막기
            Swal.fire({
                title: '로그인 후 작성 할 수 있습니다.',
                text: "로그인 페이지로 이동하시겠습니까?",
                icon: 'warning',
                showCancelButton: true,
                confirmButtonColor: 'white',
                cancelButtonColor: 'white',
                confirmButtonText: '예',
                cancelButtonText: '아니오',
                
              }).then((result) => {
                if (result.isConfirmed) {
                  window.location.href = "/security/login"
                }
              })
            return;
        } else {
            window.location.href = '/common/freeBoard/freeRegist';
        }
    });
})
</script>
<style>
#freeType{
	color: #24D59E;
	width : 80px;
    background-color: #ccffef;
    font-weight: 450;
    border: none;
    border-radius: 999px;
    margin-left: 25px;
}
</style>
<div class="inquiryRow">
	<div class="registTitle">
		<h2>자유 게시판</h2>
	</div>
        
	<!-- 각 카테고리별 보기 -->
	<div class="filter-buttons">
	    <button type="button" class="filter-button cat" 
	        onclick="location.href='${pageContext.request.contextPath}/common/freeBoard/freeList?currentPage=1&pstOthbcscope=&searchKeyword='">전체글</button>
	    <c:forEach var="codeVO" items="${codeVOList}">
			<button type="button" class="filter-button cat" 
			    onclick="location.href='${pageContext.request.contextPath}/common/freeBoard/freeList?currentPage=1&pstOthbcscope=' + encodeURIComponent('${codeVO.comCodeNm}') + '&searchKeyword=${param.searchKeyword}'">
			    ${codeVO.comCodeNm}
			</button>
	    </c:forEach>
	</div>

       
       
       <!-- 게시글 수량 및 검색-->
		<div class="sortingALl">
			<div class="count">
				<p id="count">
					전체&nbsp;&nbsp;<span id="total">${articlePage.total}</span>
				</p>
				<br>
			</div>
			<!-- 검색  -->
			<div class="search-container">
				<form action="${pageContext.request.contextPath}/common/freeBoard/freeList"  method="get">
					<input type="hidden" name="currentPage" value="1">
					<input type="text" name="searchKeyword" placeholder="제목을 검색하세요"  value="${param.searchKeyword}">
					<button type="submit" class="search-button">검색</button>
				</form>
			</div>
		</div>
	
	<div class="card_body table_responsive p_0">
			<table>
				<thead>
					<tr style="background:#f3f3f3; border-top: 2px solid #232323;">
						<th class="number" style="width: 13%;">주제</th>
						<th class="number" style="width: 2%;"></th>
						<th class="contTitle" style="width: 40%;">제목</th>
						<th class="write" style="width: 15%;">작성자</th>
						<th class="write" style="width: 15%;">작성일</th>
						<th class="cnt" style="width: 15%;">조회수</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach var="boardVO" items="${articlePage.content}">
						<tr style="<c:if test='${boardVO.mbrId == "admin"}'>background-color: #F0FCF8;</c:if>">
							<td style="text-align: center;"><p id="freeType">${boardVO.pstOthbcscope}</p></td>
							<td>
							<c:if test="${not empty boardVO.fileGroupSn}">
							    <img class="FileLink"src="/resources/icon/FileLink.png" alt="파일첨부">
							</c:if>
							</td>
							<td class="free-title" style="text-align: left;">
							        <a class="ListTitle" href="/common/freeBoard/freeDetail?seNo=3&pstSn=${boardVO.pstSn}">${boardVO.pstTtl}</a>
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
							<td style="text-align: center;">${boardVO.pstInqCnt}</td>
						</tr>
					</c:forEach>
				</tbody>
				<tfoot>
					<tr></tr>
				</tfoot>
			</table>
		</div>	
			<div class="button-container">
				<button type="button" class="btn filter-button boardRegist">등록</button>
			</div>
		<!-- 			최신화 페이지네이션 -->
		<div class="card-body table-responsive p-0" style="display: flex; justify-content: center;">
		    <table style="margin-bottom: 30px;">
		        <tr>
		            <td colspan="4" style="text-align: center;">
		                <div class="dataTables_paginate" id="example2_paginate"
		                    style="display: flex; justify-content: center; margin-top: 20px;">
		                    <ul class="pagination">
		
		                        <!-- 맨 처음 페이지로 이동 버튼 -->
		                        <c:if test="${articlePage.currentPage gt 1}">
		                            <li class="paginate_button page-item first">
		                                <a href="/common/freeBoard/freeList?currentPage=1&pstOthbcscope=${pstOthbcscope}&searchKeyword=${param.searchKeyword}"
		                                   class="page-link">&lt;&lt;</a>
		                            </li>
		                        </c:if>
		
		                        <!-- 이전 페이지 버튼 -->
		                        <c:if test="${articlePage.startPage gt 1}">
		                            <li class="paginate_button page-item previous">
		                                <a href="/common/freeBoard/freeList?currentPage=${articlePage.currentPage-5}&pstOthbcscope=${pstOthbcscope}&searchKeyword=${param.searchKeyword}"
		                                   class="page-link">&lt;</a>
		                            </li>
		                        </c:if>
		
		                        <!-- 페이지 번호 -->
		                        <c:forEach var="pNo" begin="${articlePage.startPage}" end="${articlePage.endPage}">
		                            <li class="paginate_button page-item ${pNo == articlePage.currentPage ? 'active' : ''}">
		                                <a href="/common/freeBoard/freeList?currentPage=${pNo}&pstOthbcscope=${pstOthbcscope}&searchKeyword=${param.searchKeyword}"
		                                   class="page-link">${pNo}</a>
		                            </li>
		                        </c:forEach>
		
		                        <!-- 다음 페이지 버튼 -->
		                        <c:if test="${articlePage.endPage lt articlePage.totalPages}">
		                            <li class="paginate_button page-item next">
		                                <a href="/common/freeBoard/freeList?currentPage=${articlePage.currentPage+5}&pstOthbcscope=${pstOthbcscope}&searchKeyword=${param.searchKeyword}"
		                                   class="page-link">&gt;</a>
		                            </li>
		                        </c:if>
		
		                        <!-- 맨 마지막 페이지로 이동 버튼 -->
		                        <c:if test="${articlePage.currentPage lt articlePage.totalPages}">
		                            <li class="paginate_button page-item last">
		                                <a href="/common/freeBoard/freeList?currentPage=${articlePage.totalPages}&pstOthbcscope=${pstOthbcscope}&searchKeyword=${param.searchKeyword}"
		                                   class="page-link">&gt;&gt;</a>
		                            </li>
		                        </c:if>
		
		                    </ul>
		                </div>
		            </td>
		        </tr>
		    </table>
		</div>
	</div>

