<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
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
<!-- css 파일 -->
<link rel="stylesheet" 	href="<%=request.getContextPath()%>/resources/css/board/admDetail.css" />
<script src="https://cdn.jsdelivr.net/npm/sockjs-client@1/dist/sockjs.min.js"></script><!-- 웹소켓 -->
<script type="text/javascript">
$(document).ready(function(){
    // 댓글 등록 버튼 클릭 시
    $('#submitComment').on("click", function(event) {
        event.preventDefault(); // 폼 제출 막기
        
        const commentContent = $('#commentContent').val();  // 댓글 내용
        const pstSn = $('#pstSn').val();  // 게시글 번호
        
        if (commentContent === "") {
            Swal.fire({
                icon: 'info',
                title: '댓글 내용을 작성해주세요',
              });
            return;
        }

        // Ajax로 댓글 등록 요청
        $.ajax({
            url: '/adm/inquiryBoard/registReplyPost',
            type: 'POST',
            data: {
                commentContent: commentContent,
                pstSn: pstSn
            },
            beforeSend: function(xhr) {
                xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
            },
            success: function(response) {
                location.reload(); // 성공 시 댓글 목록 갱신
                $('#commentContent').val(''); // 댓글 입력창 초기화
            },
            error: function(xhr, status, error) {
                alert('댓글 등록 실패: ' + error);
            }
        });
    });
    // 댓글 목록 로딩
//     function loadComments() {
//         const pstSn = $('#pstSn').val();

//         $.ajax({
//             url: '/adm/inquiryBoard/replyList',
//             type: 'GET',
//             data: { pstSn: pstSn },
//             success: function(response) {
//                 $('#commentsList').html(response); // 댓글 목록 업데이트
//             },
//             error: function(xhr, status, error) {
//                 alert('댓글 목록 로딩 실패: ' + error);
//             }
//         });
//     }

//     // 페이지 로드 시 댓글 목록 불러오기
//     loadComments();
});
</script>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<div class="container2">
	<div class="registTitle">
        <h1>문의 게시판</h1>
	</div>
    <div class="title-group">
        <div class="content-group">
        <form name="deletePost" id="deletePost" action="/adm/inquiryBoard/deletePost" method="post">
			<div class="Content">
				<div class="rv-detail">
					<!--  제목 -->
					<div class="titlegroup">
						<div class="left" >
		                     <p style="font-weight: bold;  font-size: 30px;"> [${boardVO.pstOthbcscope}]&nbsp;${boardVO.pstTtl}</p>
	                  	</div>
					</div>       					
						<!--  제목 -->
						<!-- 작성자, 작성일, 조회수 -->
		                  <div class="reviewWit">
			                     <c:choose>
			                        <c:when test="${boardVO.mbrId == 'admin'}">
			                        <c:if test="${boardVO.pstMdfcnDt != null}">
				                        <div class="wit">
					                        <p>★관리자</p>
					                        <p>작성일&nbsp;:&nbsp;${boardVO.pstWrtDt}&nbsp;(수정됨)</p>
				                        </div>
			                        </c:if>
			                        
			                        <c:if test="${boardVO.pstMdfcnDt == null}">
				                        <div class="wit">
					                        <p>★관리자</p>
					                        <p>작성일&nbsp;:&nbsp;${boardVO.pstWrtDt}</p>
				                        </div>
			                        </c:if>
			                        </c:when>
			                     <c:otherwise>
			                      <c:if test="${boardVO.pstMdfcnDt != null}">
			                     	<div class="wit">
				                        <p>작성자&nbsp;:&nbsp;${boardVO.mbrId}</p>
				                        <p>작성일&nbsp;:&nbsp; ${boardVO.pstWrtDt}&nbsp;(수정됨)</p>
			                        </div>
			                        </c:if>
			                        <c:if test="${boardVO.pstMdfcnDt == null}">
			                     	<div class="wit">
				                        <p>작성자&nbsp;:&nbsp;${boardVO.mbrId}</p>
				                        <p>작성일&nbsp;:&nbsp; ${boardVO.pstWrtDt}</p>
			                        </div>
			                        </c:if>
			                        <div class="upDown">
			                     		<p>조회수&nbsp;:&nbsp;${boardVO.pstInqCnt}</p>
			                        </div>
			                     </c:otherwise>
			                     </c:choose>
		                  </div>
		                  <!-- 작성자, 작성일, 조회수 -->
					<div class="hr"></div>
					<!-- 리뷰내용 -->
					<div class="pstCn">${boardVO.pstCn}</div>
                </div>
            </div>
            <!-- 버튼 배치 -->
		    <div class="button-container">
		        <!-- 공지 목록 버튼 (왼쪽 정렬) -->
		        <button type="button" class="btn btn-List" onclick="location.href='/adm/inquiryBoard/admInquiryList'">목록</button>
		        <!-- 수정 및 삭제 버튼 그룹 (오른쪽 정렬) -->
		        <div class="button-group-right">
		            <button type="button" class="btn btn-Del" style="margin-right: 20px;">삭제</button>
		        	<c:if test="${boardVO.mbrId == 'admin'}">
		        	<button type="button" class="btn btn-Edit" onclick="location.href='/adm/inquiryBoard/admInquiryUpdate?seNo=${boardVO.seNo}&pstSn=${boardVO.pstSn}'">수정</button>
					</c:if>
		            <input type="hidden" name="pstSn" id="pstSn" value="${boardVO.pstSn}">
		        </div>
		    </div>
            <sec:csrfInput/>
        </form>
        </div>
    </div>

    <!-- 댓글 입력창 및 목록 섹션 -->
    <div class="comment-section">
        <!-- 댓글 입력창 -->
        <form name="replyRegistPost" id="replyRegistPost" action="/adm/inquiryBoard/registReplyPost" method="post">
        <div class="comment-input">
             <input type="text" id="commentContent" name="commentContent" class="form-control ck-blurred" placeholder="댓글을 입력하세요" rows="5">
            <button type="submit" id="submitComment" class="btn btn-Regist">등록</button>
        </div>
        <sec:csrfInput/>
        <input type="hidden" id="pstSn" name="pstSn" value="${boardVO.pstSn}"/>
        </form>

        <!-- 댓글 목록 -->
        <div id="commentsList">
            <c:if test="${empty commentsList}">
            	<c:choose>
            		<c:when test="${boardVO.mbrId =='admin'}"></c:when>
            		<c:otherwise>
		            <p>답변이 등록되지 않았습니다.</p>
		            </c:otherwise>
	            </c:choose>
	        </c:if>
		    <c:forEach var="comment" items="${commentsList}">
            <div class="comment-item" data-cmnt-no="${comment.cmntNo}">
				    <p>
                     <c:choose>
                         <c:when test="${comment.mbrId == 'admin'}">
                             <strong style="background-color: #FD5D6C;">★관리자</strong>(${comment.cmntRegDt})
                         </c:when>
                         <c:otherwise>
                             <strong>${comment.mbrId}</strong>(${comment.cmntRegDt})
                         </c:otherwise>
                     </c:choose>
				    </p>
					<div class="button-group-right">
					    <p class="comment-content">${comment.cmntCn}</p>
					    <div class="comment-buttons">
					        <c:if test="${prc.username == comment.mbrId}">
					            <button type="button" class="btn-delete-comment" data-id="${comment.cmntNo}"><img src="${pageContext.request.contextPath}/resources/icon/Del_icon.png" alt="삭제" style="width: 20px; height: 20px;"></button>
					            <button type="button" class="btn-edit-comment" data-id="${comment.cmntNo}"><img src="${pageContext.request.contextPath}/resources/icon/Edit_icon.png" alt="수정" style="width: 20px; height: 20px;"></button>
					        </c:if>
					    </div>
					</div>

	                <!-- 댓글 수정 폼-->
	                <div class="edit-comment-form" style="display: none;">
			            <input type="text" class="edit-comment-text" value="${comment.cmntCn}">
			            <button type="button" class="btn btn-cancel-edit">취소</button>
			            <button type="button" class="btn btn-save-edit">저장</button>
			        </div>
		        </div>
		        </c:forEach>
            </div>
</div>
</div>
<script type="text/javascript">
$(document).ready(function(){
    var Toast = Swal.mixin({
        toast: true,
        position: 'center',
        showConfirmButton: false,
        timer: 1500,
        
        didOpen: (toast) => {
            toast.addEventListener('mouseenter', Swal.stopTimer);
            toast.addEventListener('mouseleave', Swal.resumeTimer);
        }
    });
    $('.btn-Del').on('click', function() {
        Swal.fire({
            title: '게시글을 삭제하시겠습니까?',
            icon: 'error',
            showCancelButton: true,
            confirmButtonColor: 'white',
            cancelButtonColor: 'white',
            confirmButtonText: '예',
            cancelButtonText: '아니오',
            reverseButtons: true
        }).then((result) => {
            if (result.isConfirmed) {
                $('#deletePost').submit();
            }
        });
    });
    // 댓글 수정 버튼 클릭 시
    $(document).on("click", '.btn-edit-comment', function() {
        const commentItem = $(this).closest('.comment-item');
        commentItem.find('.comment-content').hide(); // 댓글 내용 숨기기
        commentItem.find('.edit-comment-form').show(); // 수정 폼 표시하기
        commentItem.find('.btn-edit-comment').hide(); 
        commentItem.find('.btn-delete-comment').hide(); 
    });
    // 댓글 수정 취소 버튼 클릭 시
    $(document).on("click", '.btn-cancel-edit', function() {
        const commentItem = $(this).closest('.comment-item');
        commentItem.find('.comment-content').show(); // 댓글 내용 표시
        commentItem.find('.edit-comment-form').hide(); // 수정 폼 숨기기
        commentItem.find('.btn-edit-comment').show(); 
        commentItem.find('.btn-delete-comment').show(); 
    });
    // 댓글 수정 저장 버튼 클릭 시
    $(document).on("click", '.btn-save-edit', function() {
        const commentItem = $(this).closest('.comment-item');
        const cmntNo = commentItem.data('cmnt-no');
        const pstSn = $('#pstSn').val();
        const cmntCn = commentItem.find('.edit-comment-text').val();

        $.ajax({
            url: '/adm/inquiryBoard/updateComment',
            type: 'POST',
            contentType: 'application/json',
            data: JSON.stringify({
                cmntNo: cmntNo,
                pstSn: pstSn,
                cmntCn: cmntCn
            }),
            beforeSend: function(xhr) {
                xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
            },
            success: function(response) {
                if (response === "success") {
                    commentItem.find('.comment-content').text(cmntCn).show(); // 댓글 내용 업데이트 및 표시
                    commentItem.find('.edit-comment-form').hide(); // 수정 폼 숨기기
                    
                    // 수정 및 삭제 버튼 다시 표시
                    commentItem.find('.btn-edit-comment').show(); 
                    commentItem.find('.btn-delete-comment').show();
                    Toast.fire({
                        icon: 'success',
                        title: '댓글이 수정되었습니다.'
                    })
                } else {
                    alert('댓글 수정 실패');
                }
            },
            error: function(xhr, status, error) {
                alert('댓글 수정 실패: ' + error);
            }
        });
    });

    // 댓글 삭제 버튼 클릭 시
   $(document).on("click", '.btn-delete-comment', function() {
       const cmntNo = $(this).data('id');
       const pstSn = $('#pstSn').val();

       // SweetAlert로 확인 창 표시
       Swal.fire({
           title: '댓글을 삭제하시겠습니까?',
           icon: 'error',
           showCancelButton: true,
           confirmButtonColor: 'white',
           cancelButtonColor: 'whie',
           confirmButtonText: '예',
           cancelButtonText: '아니오',
       }).then((result) => {
           if (result.isConfirmed) {
               // 삭제 요청 진행
               $.ajax({
                   url: '/adm/inquiryBoard/deleteComment',
                   type: 'POST',
                   data: {
                       cmntNo: cmntNo,
                       pstSn: pstSn
                   },
                   beforeSend: function(xhr) {
                       xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
                   },
                   success: function(response) {
                       if (response === "success") {
                           // 삭제 성공 시 알림 표시
	                     Toast.fire({
	                        icon: 'success',
	                        title: '댓글이 삭제되었습니다.'
                    	}).then(() => {
                               location.reload(); // 댓글 삭제 후 목록 갱신
                           });
                       } else {
                           Swal.fire(
                               '삭제 실패',
                               '댓글 삭제 중 오류가 발생했습니다.',
                               'error'
                           );
                       }
                   },
                   error: function(xhr, status, error) {
                       Swal.fire(
                           '삭제 실패',
                           '댓글 삭제 중 오류가 발생했습니다.',
                           'error'
                       );
                   }
               });
           }
       });
   });
});

ClassicEditor.create(document.querySelector('#pstCnTemp'))
    .then(editor => {
        editor.enableReadOnlyMode('#pstCnTemp');
        window.editor = editor;
        
        // 폼 제출 전 CKEditor의 내용을 textarea에 동기화
        document.querySelector('#registForm').addEventListener('submit', function(event) {
            document.querySelector('#pstCn').value = editor.getData();
        });
    })
    .catch(error => {
        console.error(error);
    });
</script>
