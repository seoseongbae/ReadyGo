<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec"%>   
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>   

<link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200" />
<link rel="stylesheet" href="<%=request.getContextPath() %>/resources/css/member/myBoard.css" />
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script> 
<script type="text/javascript" src="/resources/js/jquery.min.js"></script>
<script type="text/javascript" src="/resources/js/sweetalert2.js"></script>
<link rel="stylesheet" href="<%=request.getContextPath()%>/resources/css/alert.css" />
<script type="text/javascript">
$(function() {
    const Toast = Swal.mixin({
        toast: true,
        position: 'center-center',  // 원하는 위치로 변경 가능 ('top-right', 'bottom-left' 등)
        showConfirmButton: false,
        timer: 1500,
        didOpen: (toast) => {
            toast.addEventListener('mouseenter', Swal.stopTimer);
            toast.addEventListener('mouseleave', Swal.resumeTimer);
        }
    });

    // 전체 삭제 버튼 클릭 이벤트
    $(document).on('click', '.AllDel', function(event) {
        event.preventDefault();  // 기본 동작 방지

        Swal.fire({
            title: '모든 알림을 삭제하시겠습니까?',
            icon: 'error',
            showCancelButton: true,
            confirmButtonColor: 'white',
            cancelButtonColor: 'white',
            confirmButtonText: '예',
            cancelButtonText: '아니오'
        }).then((result) => {
            if (result.isConfirmed) {
                $.ajax({
                    url: '<%=request.getContextPath()%>/notification/alramRealAllDel',
                    method: 'POST',
                    beforeSend: function(xhr) {
                        xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
                    },
                    success: function(response) {
                        if (response === 'success') {
                            Toast.fire({
                                icon: 'success',
                                title: '모든 알림이 삭제되었습니다.'
                            }).then(() => {
                                $('tbody').empty();  
                                location.reload();
                            });
                        } else {
                            Toast.fire({
                                icon: 'error',
                                title: '삭제에 실패했습니다.'
                            });
                        }
                    },
                    error: function(xhr, status, error) {
                        Toast.fire({
                            icon: 'error',
                            title: '서버와의 통신 중 오류가 발생했습니다.'
                        });
                    }
                });
            }
        });
    });

    // 선택 삭제 버튼 클릭 이벤트
    $(document).on('click', '.selectDel', function(event) {
        event.preventDefault();

        var selectedAlrams = [];
        $('input[name="selectAlram"]:checked').each(function() {
            selectedAlrams.push($(this).val());
        });

        if (selectedAlrams.length === 0) {
            Toast.fire({
                icon: 'error',
                title: '삭제할 알림을 선택하세요.'
            });
            return;
        }

        Swal.fire({
            title: '선택하신 알림을 삭제하시겠습니까?',
            icon: 'error',
            showCancelButton: true,
            confirmButtonColor: 'white',
            cancelButtonColor: 'white',
            confirmButtonText: '예',
            cancelButtonText: '아니오'
        }).then((result) => {
            if (result.isConfirmed) {
                $.ajax({
                    url: '<%=request.getContextPath()%>/notification/selectAlramAllDel',
                    method: 'POST',
                    contentType: 'application/json',
                    data: JSON.stringify(selectedAlrams),
                    beforeSend: function(xhr) {
                        xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
                    },
                    success: function(response) {
                        if (response === 'success') {
                            Toast.fire({
                                icon: 'success',
                                title: '선택하신 알림이 삭제되었습니다.'
                            }).then(() => {
                                $('input[name="selectAlram"]:checked').each(function() {
                                    $(this).closest('tr').remove();
                                });
                                location.reload();
                            });
                        } else {
                            Toast.fire({
                                icon: 'error',
                                title: '삭제에 실패했습니다.'
                            });
                        }
                    },
                    error: function(xhr, status, error) {
                        Toast.fire({
                            icon: 'error',
                            title: '서버와의 통신 중 오류가 발생했습니다.'
                        });
                    }
                });
            }
        });
    });
    
    $(document).on('click', '.notify-link', function(e) {
        e.preventDefault(); // 기본 동작 막기 (바로 이동되지 않도록)

        // 알림의 ntcnNo 값 가져오기
        var ntcnNo = $(this).data('ntcnNo');
        var targetUrl = $(this).attr('href');
        // AJAX 요청으로 알림 삭제하기
        $.ajax({
            url: '/notification/alramLinkClick',  // 알림 삭제 처리하는 API 엔드포인트
            method: 'POST',
            data: {
                ntcnNo: ntcnNo  // 삭제할 알림 번호 전달
            },
            beforeSend: function(xhr) {
                xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");  // CSRF 토큰 설정
            },
            success: function(response) {
                if (response === 'success') {
                    window.location.href = targetUrl;
                } else {
                    alert('알림 삭제 중 오류가 발생했습니다.');
                }
            },
            error: function() {
                alert('알림 삭제 중 오류가 발생했습니다.');
            }
        });
    });
});


</script>

<br>
<div class="container" style="position: relative; bottom: 35px;">
   <p id="h3">알림 목록</p>
   <br><br>
   <p id="count">전체&nbsp;&nbsp;<span id="total">${articlePage.total}</span></p><br>
   <div id="flexDiv">
	</div>
   <div class="card-body table-responsive p-0">
            <table class="table table-hover text-nowrap">
            <thead>
               <tr>
                  <th class="alramSelect" style="width: 8%; font-size: 16px;">선택</th>
                  <th class="alramRead" style="width: 6%; font-size: 16px;">상태</th>
                  <th class="entNm" style="text-align: center; width: 7%; font-size:16px;">번호</th>
                  <th class="aplct" style="text-align: left; width: 65%; font-size: 16px;">내용</th>
                  <th style="width: 20%; font-size: 16px;">알림일자</th>
               </tr>
            </thead>
            <div style="margin-bottom: 10px;">
            	<button class="selectDel">선택 삭제</button>
            	<button class="AllDel">전체 삭제</button>
            </div>
            <tbody>
            <c:choose>
			<c:when test="${not empty articlePage.content}">
            <c:forEach var="notificationVO" items="${articlePage.content}">
                <tr style="border-bottom: 1px solid #dee2e6;">
                    <input type="hidden" id=ntcnNo name="ntcnNo"  value="${notificationVO.ntcnNo}" />
                    <td style="text-align: center;">
			            <input type="checkbox" name="selectAlram" value="${notificationVO.ntcnNo}"/>
                    </td> 
                    <c:choose>
                    	<c:when test="${notificationVO.ntcnIdntyYn == '0' && notificationVO.ntcnDelYn =='0'}">
                    		<td><span class="material-symbols-outlined">drafts</span></td>
                   		</c:when>
                   		<c:otherwise>
                   			<td><span class="material-symbols-outlined">mark_email_unread</span></td>
                   		</c:otherwise>
                    </c:choose>
                    <td style="text-align: center;">${notificationVO.rnum}</td> 
					<td class="free-title" style="text-align: left;">
					    <a class="ListTitle alramTtitle notify-link" href="${notificationVO.ntcnUrl}" data-ntcn-no="${notificationVO.ntcnNo}">
					        ${notificationVO.ntcnCn}
					    </a>
					</td>
					<td>
					    <fmt:formatDate value="${notificationVO.ntcnYmd}" pattern="yyyy.MM.dd HH:mm"/>
					</td>
            </c:forEach>
            </c:when>
				<c:otherwise>
					<tr>
						<td id="noSrc"colspan="5">알림이 없습니다.</td>
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
                     <a href="<%=request.getContextPath()%>/member/memAlram?currentPage=1"
                        aria-controls="example2" data-dt-idx="0" tabindex="0" class="page-link">&lt;&lt;</a>
                  </li>
               </c:if>

               <!-- 이전 페이지 버튼 -->
               <c:if test="${articlePage.startPage gt 1}">
                  <li class="paginate_button page-item previous" id="example2_previous">
                     <a href="<%=request.getContextPath()%>/member/memAlram?currentPage=${(articlePage.startPage - 5) lt 1 ? 1 : (articlePage.startPage - 1)}"
                        aria-controls="example2" data-dt-idx="0" tabindex="0" class="page-link">&lt;</a>
                  </li>
               </c:if>

               <!-- 페이지 번호 -->
               <c:forEach var="pNo" begin="${articlePage.startPage}" end="${articlePage.endPage}">
                  <li class="paginate_button page-item ${pNo == articlePage.currentPage ? 'active' : ''}">
                     <a href="<%=request.getContextPath()%>/member/memAlram?currentPage=${pNo}" 
                        aria-controls="example2" class="page-link">${pNo}</a>
                  </li>
               </c:forEach>

               <!-- 다음 페이지 버튼 -->
               <c:if test="${articlePage.endPage lt articlePage.totalPages}">
                  <li class="paginate_button page-item next" id="example2_next">
                     <a href="<%=request.getContextPath()%>/member/memAlram?currentPage=${articlePage.startPage+5}"
                        aria-controls="example2" data-dt-idx="7" tabindex="0" class="page-link">&gt;</a>
                  </li>
               </c:if>

               <!-- 맨 마지막 페이지로 이동 버튼 -->
               <c:if test="${articlePage.currentPage lt articlePage.totalPages}">
                  <li class="paginate_button page-item last">
                     <a href="<%=request.getContextPath()%>/member/memAlram?currentPage=${articlePage.totalPages}"
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

