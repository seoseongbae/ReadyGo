<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>공고 임시저장</title>
	<link rel="stylesheet" href="<%=request.getContextPath() %>/resources/css/enter/tempPbanc.css" />
	<link rel="stylesheet"
   href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200" />
   <link rel="stylesheet" href="<%=request.getContextPath()%>/resources/css/alert.css" />
   <script src="https://cdn.jsdelivr.net/npm/sweetalert2@10"></script>
	<script type="text/javascript" src="/resources/js/jquery.min.js"></script>
</head>
<body>
	<sec:authentication property="principal" var="prc" />
	<c:if test="${prc ne 'anonymousUser'}">
		<input type="hidden" id="hasRoleEnter" value="${prc.authorities}" />
	</c:if>
    <div class="announcement-container">
     
        <div style="display: flex;align-items: flex-end;">
        	<h2>공고 임시저장</h2>
        	<p class="total">전체  <b>${total}</b></p>
        </div>
        <div class="search-box">
        	<!-- 셀렉트 박스 -->
	        <div class="filter-dropdown">
			    <select class="gubunDateSelect" name="gubunDate">
			        <option value=""  disabled selected>공고일순 선택</option>
			        <option value="insert" ${gubunDate == 'insert' ? 'selected' : ''}>공고 등록일순</option>
			        <option value="start" ${gubunDate == 'start' ? 'selected' : ''}>공고 시작일순</option>
			        <option value="last" ${gubunDate == 'last' ? 'selected' : ''}>공고 마감일순</option>
			    </select>
	        </div>
	        
       		<!-- 검색  -->
       		<form action="/enter/tempPbanc" method="get">
				<div class="search">
					<input type="hidden" id="entId" name="entId"
						value="${prc.username}"/>
					<a href="/enter/tempPbanc?entId=${entId}"><button class="reload"><img class="backImg" alt="back" src="../resources/icon/back.png"></button></a>
					<input type="text" id="keywordInput" name="keywordInput"
						placeholder="공고명을 입력하세요."/>
			        <div class="select-search">
			            <select name="gubun" class="gubun-select">
			            	<option value="" disabled selected>선택해주세요</option>
			                <option value="wrt">공고 등록일</option>
			                <option value="bgng">공고 시작일</option>
			                <option value="ddln">공고 마감일</option>
			            </select>
			        </div>					
					<input type="date" id="dateInput" name="dateInput"/>
					<button type="submit">검색</button>
				</div>
				<sec:csrfInput />
       		</form>
       		<!-- 검색 -->
        </div>

        
        <table>
            <thead>
                <tr style="background:#f3f3f3; border-top: 2px solid #232323;">
                    <th>번호</th>
                    <th id="entNm">기업명</th>
                    <th class="pbanc">공고</th>
                    <th>임시저장일자</th>
                    <th>시작일자</th>
                    <th>마감일자</th>
		            <th>상세 / 삭제</th>
                </tr>
            </thead>
            <tbody>
           	 <c:if test="${not empty tempPbanc}">
                <c:forEach var="pbancVO" items="${articlePage.content}" varStatus="status">
                    <tr>
                        <td class="rnum">${pbancVO.rnum}</td>
                        <td class="entNm">${pbancVO.entNm}</td>
                        <td>
                            <div class="title">
                            	<a href="/enter/pbancTempInsert?pbancNo=${pbancVO.pbancNo}&entId=${prc.username}">
                            	${pbancVO.pbancTtl}
                            	</a>
                            </div>
                            <div class="industry">${pbancVO.pbancTpbizNm}</div>
                        </td>
                        <td><div class="dt">${pbancVO.pbancWrtDt}</div></td>
                        <td><div class="dt">${pbancVO.pbancBgngDt}</div></td>
                        <td><div class="dt">${pbancVO.pbancDdlnDt}</div></td>
						<td class="detail-cell">
								<div style="display: flex; align-items: center;justify-content: center;">
			                        <div>
				                        <div><a href="/enter/pbancTempInsert?pbancNo=${pbancVO.pbancNo}&entId=${prc.username}"><button class="details-button">상세</button></a></div>
				                        <div><p style="color: red; font-size: 12px;">${pbancVO.pbancBeforeWrt}일 전 임시저장</p></div>
			                        </div>
			                        <div>
			                    		<input type="hidden" id="mbrId" name="mbrId" value="${prc.username}">
			                    		<input type="hidden" id="pbancNo" value="${pbancVO.pbancNo}" />
										<input type="hidden" id="entId" value="${pbancVO.entId}" />
										<button type="button" class="btnDel" id="btnDel"><span class="material-symbols-outlined delete">delete</span></button>						
			                        </div>
		                        </div>
	                    </td>
                    </tr>
                </c:forEach>
                 </c:if>
                <c:if test="${empty tempPbanc}">
                	 <tr>
                	 	<td colspan="8">검색 조건이 없습니다.</td>
                	 </tr>
                </c:if>                
            </tbody>
            <tfoot>
			    <tr></tr>
			</tfoot>
        </table>
				<!-- 페이지네이션 -->
				<div class="card-body table-responsive p-0"
					style="display: flex; justify-content: center;">
					<table>
						<tr>
							<td class="pageTable" colspan="4" style="text-align: center;">
								<div class="dataTables_paginate" id="example2_paginate"
									style="display: flex; justify-content: center; margin-top: -30px;">
									<ul class="pagination">

										<!-- 맨 처음 페이지로 이동 버튼 -->
										<c:if test="${articlePage.currentPage gt 1}">
											<li class="paginate_button page-item first"><a
												href="/enter/tempPbanc?entId=${prc.username}&currentPage=1"
												aria-controls="example2" data-dt-idx="0" tabindex="0"
												class="page-link">&lt;&lt;</a></li>
										</c:if>

										<!-- 이전 페이지 버튼 -->
										<c:if test="${articlePage.startPage gt 1}">
											<li class="paginate_button page-item previous"
												id="example2_previous"><a
												href="/enter/tempPbanc?entId=${prc.username}&currentPage=${(articlePage.startPage - 1) lt 1 ? 1 : (articlePage.startPage - 1)}"
												aria-controls="example2" data-dt-idx="0" tabindex="0"
												class="page-link">&lt;</a></li>
										</c:if>

										<!-- 페이지 번호 -->
										<c:forEach var="pNo" begin="${articlePage.startPage}"
											end="${articlePage.endPage}">
											<li
												class="paginate_button page-item ${pNo == articlePage.currentPage ? 'active' : ''}">
												<a
												href="/enter/tempPbanc?entId=${prc.username}&currentPage=${pNo}"
												aria-controls="example2" class="page-link">${pNo}</a>
											</li>
										</c:forEach>

										<!-- 다음 페이지 버튼 -->
										<c:if test="${articlePage.endPage lt articlePage.totalPages}">
											<li class="paginate_button page-item next" id="example2_next">
												<a
												href="/enter/tempPbanc?entId=${prc.username}&currentPage=${articlePage.startPage+5}"
												aria-controls="example2" data-dt-idx="7" tabindex="0"
												class="page-link">&gt;</a>
											</li>
										</c:if>

										<!-- 맨 마지막 페이지로 이동 버튼 -->
										<c:if
											test="${articlePage.currentPage lt articlePage.totalPages}">
											<li class="paginate_button page-item last"><a
												href="/enter/tempPbanc?entId=${prc.username}&currentPage=${articlePage.totalPages}"
												aria-controls="example2" data-dt-idx="7" tabindex="0"
												class="page-link">&gt;&gt;</a></li>
										</c:if>

									</ul>
								</div>
							</td>
						</tr>
					</table>
				</div>
				<!-- 페이지네이션 끝 -->
    </div>
</body>
<script>

$(function() {
	
	var Toast = Swal.mixin({
		toast: true,
		position: 'center',
		showConfirmButton: false,
		timer: 3000
		});
	
	
    // hidden input에서 ROLE_ENTER 권한 여부 값을 가져옴
    let hasRoleEnter = $('#hasRoleEnter').val();
	console.log("hasRoleEnter", hasRoleEnter);
    // 문자열 "true" 또는 "false"로 넘어오는지 확인
    if (hasRoleEnter == "[ROLE_ENTER]") {
        $("#scrapBtn").prop('disabled', true);
        $("#applyBtn").prop('disabled', true);
    }

    // 공고 삭제 함수
    function deletePbanc(pbancNo, entId) {
        let obj = { entId: entId, pbancNo: pbancNo };
        let enterId = $("#mbrId").val();

        // SweetAlert2 대화상자
        Swal.fire({
            title: '공고를 삭제하시겠습니까?',
            icon: 'error',
            showCancelButton: true,
            confirmButtonColor: 'white', 
            cancelButtonColor: 'white', 
            confirmButtonText: '예',
            cancelButtonText: '아니오',
            reverseButtons: false // 버튼 순서 거꾸로
        }).then((result) => {
            if (result.isConfirmed) {
                // 예 버튼 클릭 시, 공고 삭제 요청
                $.ajax({
                    type: 'POST',
                    url: '/enter/pbancDelete',
                    data: JSON.stringify(obj), // JSON으로 변환
                    contentType: "application/json;charset=UTF-8",
                    beforeSend: function(xhr) {
                        xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
                    },
                    success: function(response) {
                        if (response > 0) {
                        	Toast.fire({
                				icon:'success',
                				title:'공고가 삭제되었습니다.'
                            }).then(() => {
                                location.href = "/enter/tempPbanc?entId=" + enterId; // 삭제 후 리다이렉트
                            });
                        } else {
                        	Toast.fire({
                				icon:'error',
                				title:'공고 삭제 중 오류가 발생했습니다.'
                            });
                        }
                    },
                    error: function(error) {
                        console.log('Error:', error);
                        Toast.fire({
            				icon:'error',
            				title:'공고 삭제 중 오류가 발생했습니다.'
                        });
                    }
                });
            }
        });
    }

    // 버튼 클릭 시 공고 삭제
    $('.btnDel').on('click', function() {
        var pbancNo = $(this).closest('tr').find('#pbancNo').val(); 
        var entId = $(this).closest('tr').find('#entId').val();
        deletePbanc(pbancNo, entId);  
    });	
});

window.onload = function() {
    // date input과 gubun-select를 가져옵니다.
    var dateInput = document.getElementById('dateInput');
    var gubunSelect = document.querySelector('.gubun-select');
    
    // 초기에는 date input 비활성화
    dateInput.disabled = true;

    // gubun-select가 변경될 때 이벤트 처리
    gubunSelect.addEventListener('change', function() {
        if (gubunSelect.value) {
            dateInput.disabled = false; // 옵션이 선택되면 date input 활성화
        } else {
            dateInput.disabled = true; // 옵션이 선택되지 않으면 date input 비활성화
        }
    });

    // date input에 포커스가 갈 때 이벤트 처리
    dateInput.addEventListener('focus', function() {
        if (!gubunSelect.value) { // 옵션이 선택되지 않았다면
            alert('공고 등록일과 마감일 옵션을 선택하세요.');
            gubunSelect.focus(); // gubun-select로 포커스 이동
        }
    });
}

</script>
</html>
