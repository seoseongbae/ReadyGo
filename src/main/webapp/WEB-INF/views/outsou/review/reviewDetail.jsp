<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<script type="text/javascript" src="/resources/js/jquery.min.js"></script>
<script type="text/javascript" src="/resources/ckeditor5/ckeditor.js"></script>
<link rel="stylesheet" href="../../resources/assets/css/templatemo-cyborg-gaming.css">
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@10"></script> 

<link rel="stylesheet" href="<%=request.getContextPath()%>/resources/css/alert.css" />
<!-- Spring Security 인증 정보를 가져오기 -->
<link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@24,400,0,0" />
<!-- 외주 css 파일 -->
<link rel="stylesheet" href="<%=request.getContextPath()%>/resources/css/outsou/reviewdetail.css" />

<style>
#commentsList {
    max-height: 350px; /* 초기 최대 높이 */
    overflow: hidden; /* 스크롤 숨김 */
    transition: max-height 0.5s ease-in-out; /* 높이 변화 애니메이션 */
}
</style>
<script type="text/javascript">
$(document).ready(function(){
    // 로그인한 사용자 정보 가져오기
    var username = "${pageContext.request.userPrincipal != null ? pageContext.request.userPrincipal.name : 'anonymousUser'}";
    console.log("현재 사용자: " + username);

    // 댓글 등록 버튼 클릭 시
    $('#submitComment').on("click", function(event) {
        event.preventDefault(); // 기본 폼 제출 막기

        const commentContent = $('#commentContent').val();  // 댓글 내용
        const pstSn = $('#pstSn').val();  // 게시글 번호

        if (commentContent === "") {
        	Toast.fire({
                icon: 'info',
                title: '댓글 내용을 작성해주세요',
            });
            return;
        }
        
        
        

        // 비로그인 사용자 확인
        if (username === 'anonymousUser') {
        	
        	Swal.fire({
        		  title: '로그인 후 댓글을 작성할 수 있습니다. \n 로그인하시겠습니까?',
        		  icon: 'question',
        		  showCancelButton: true,
        		  confirmButtonColor: 'white',
        		  cancelButtonColor: 'white',
        		  confirmButtonText: '예',
        		  cancelButtonText: '아니오',
        		  reverseButtons: false, // 버튼 순서 거꾸로
        		}).then((result) => {
                if (result.isConfirmed) {
                    window.location.href = "/security/login";
                }
            });
            return;
        }

        // Ajax로 댓글 등록 요청
        $.ajax({
            url: '/outsou/registReplyPost',
            type: 'POST',
            data: {
                commentContent: commentContent,
                pstSn: pstSn
            },
            beforeSend: function(xhr) {
                xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
            },
            success: function(response) {
            	Toast.fire({
    				icon:'success',
    				title:'댓글이 등록되었습니다.'
    			});
                location.reload(); // 댓글 목록 갱신
            },
            error: function(xhr, status, error) {
            	Toast.fire({
    				icon:'error',
    				title:'댓글 등록도중 오류가 발생하였습니다.'
    			});
            }
        });
    });

    // 게시글 신고 버튼 클릭 시
    $(document).on("click", '.btn-Report', function() {
        if (username === "anonymousUser") {
        	Swal.fire({
      		  title: '로그인 후 신고 할수 있습니다. \n 로그인하시겠습니까?',
      		  icon: 'question',
      		  showCancelButton: true,
      		  confirmButtonColor: 'white',
      		  cancelButtonColor: 'white',
      		  confirmButtonText: '예',
      		  cancelButtonText: '아니오',
      		  reverseButtons: false, // 버튼 순서 거꾸로
      		}).then((result) => {
        	
                if (result.isConfirmed) {
                    window.location.href = "/security/login";
                }
            });
            return;
        } else {
            $('#dclrCn').val(''); // 신고 내용 텍스트 초기화
            $('input[name="radio"]').prop('checked', false);
            $('#repotModal').modal('show');
        }
    });

    // 신고 모달창 처리
    $(document).on("click", '.dclr-btn', function() {
        const dclrTp = $('input[type="radio"]:checked').next('.dclrTp').text(); 
        const dclrCn = $('#dclrCn').val(); 
        const pstSn = $('#pstSn').val(); 
        const mbrId = '${boardVO.mbrId}'; 

        const dclrUrl = 'http://localhost/adm/review/reviewDetail?seNo=3&pstSn=' + pstSn;

        if (!dclrTp || !dclrCn) {
        	Toast.fire({
                icon: 'info',
                title: '신고 유형과 내용을 입력해주세요',
            });
            return;
        }

        $.ajax({
            url: '/common/freeBoard/boardReport',
            type: 'POST',
            contentType: 'application/json',
            data: JSON.stringify({
                dclrTp: dclrTp,
                dclrCn: dclrCn,
                dclrUrl: dclrUrl,
                pstSn: pstSn, 
                mbrId: mbrId
            }),
            beforeSend: function(xhr) {
                xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
            },
            success: function(response) {
                if (response === "success") {
                    Toast.fire({
                        icon: 'success',
                        title: '신고가 접수되었습니다.'
                    });
                    $('#repotModal').modal('hide');
                } else {
                	Toast.fire({
                        icon: 'error',
                        title: '신고 접수 실패',
                    });
                }
            },
            error: function(xhr, status, error) {
            	Toast.fire({
                    icon: 'error',
                    title: '신고 접수 중 오류 발생: ' + error,
                });
            }
        });
    });
    const initialHeight = 510; 
    const increaseBy = 510; 
    let currentHeight = initialHeight; 

    // 더보기 버튼 클릭 시
    $('#loadMoreBtn').on('click', function() {
        currentHeight += increaseBy; 
        $('#commentsList').animate({ maxHeight: currentHeight + 'px' }, 500); 

        // 전체 댓글이 다 표시되면 더보기 버튼 숨기기
        if ($('#commentsList')[0].scrollHeight <= currentHeight) {
            $('#loadMoreBtn').hide();
        }
    });

});
</script>

<script type="text/javascript">
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

<div class="container2">
   <div class="registTitle">
        <h2>리뷰 게시글</h2>
    </div>
   <div class="reviewDetail-group">
      <div class="content-group">
         <form name="reviewDeletePost" id="reviewDeletePost"  action="/outsou/reviewDeletePost" method="post">
            <div class="Content">
               <div class="rv-detail">
                <!-- 제목, 신고 버튼 -->
                  <div class="titlegroup">
                    <div class="left">
                         <p style="font-weight: bold;  font-size: 30px;"> ${boardVO.pstTtl}</p>
                         <br>
                         <p> 구입한 상품 <a href="/outsou/detail?outordNo=${boardVO.outordNo}">[ ${boardVO.outordTtl} ]</a></p>
                    </div>
                    <c:choose>
                        <c:when test="${boardVO.mbrId == 'admin'}"></c:when>
                        <c:otherwise>
                            <!-- 작성한 사람일 때 신고 버튼 숨기기 -->
                            <c:if test="${pageContext.request.userPrincipal != null && pageContext.request.userPrincipal.name != boardVO.mbrId && boardVO.mbrId != 'admin'}">
                                <div class="right">
                                    <input type="button" class="btn btn-Report" value="신고"/>
                                </div>
                            </c:if>
                        </c:otherwise>
                    </c:choose>
                  </div>
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
                                        <p>작성자&nbsp;:&nbsp;<a href="/member/profile?mbrId=${boardVO.mbrId}">${boardVO.mbrId}</a></p>
                                        <p>작성일&nbsp;:&nbsp;${boardVO.pstWrtDt}&nbsp;(수정됨)</p>
                                    </div>
                                </c:if>
                                <c:if test="${boardVO.pstMdfcnDt == null}">
                                    <div class="wit">
                                        <p>작성자&nbsp;:&nbsp;<a href="/member/profile?mbrId=${boardVO.mbrId}">${boardVO.mbrId}</a></p>
                                        <p>작성일&nbsp;:&nbsp;${boardVO.pstWrtDt}</p>
                                    </div>
                                </c:if>
                                <div class="upDown">
                                    <p>조회수&nbsp;:&nbsp;${boardVO.pstInqCnt}</p>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <c:if test="${boardVO.pstFile != '2' }">
                        <c:forEach var="file" items="${fileDetails}">
                            <div class="filelist">
                                <a href="${file.filePathNm}" download="${file.orgnlFileNm}">
                                    <i class="fas fa-link mr-1" style="font-weight:600; font-size:14px;">${file.orgnlFileNm} (${file.fileFancysize})</i>
                                </a>
                            </div>
                        </c:forEach>
                    </c:if>
                    <div class="hr"></div>
                    <!-- 리뷰 내용 -->
                    <div class="pstCn">
                        ${boardVO.pstCn}
                    </div>
               </div>
            </div>
            <!-- 버튼 배치 -->
            <div class="button-container">
                <div id="editBox1">
                    <a href="/outsou/reviewList"><input type="button" id="savebtn" value="목록" /></a>
                </div>
                <div class="button-group-right">
                    <!-- 로그인하지 않은 경우 버튼 숨기기 -->
                    <c:if test="${pageContext.request.userPrincipal == null}">
                        <!-- 아무것도 표시하지 않음 -->
                    </c:if>
                    <!-- 로그인한 사용자인 경우 -->
                    <c:if test="${pageContext.request.userPrincipal != null}">
                        <!-- 로그인한 사용자와 게시글 작성자가 같을 때만 수정/삭제 버튼을 표시 -->
                        <c:if test="${pageContext.request.userPrincipal.name == boardVO.mbrId}">
                            <div id="editBox">
                                <p>
                                    <input type="button" class="cancel" value="삭제" />
                                    <button type="button" id="savebtn" onclick="location.href='/outsou/reviewUpdate?seNo=${boardVO.seNo}&pstSn=${boardVO.pstSn}'">수정</button>
                                </p>
                            </div>
                        </c:if>
                    </c:if>
                    <input type="hidden" id="pstSn" name="pstSn" value="${boardVO.pstSn}" />
                </div>
            </div>
            <sec:csrfInput />
         </form>
      </div>
   </div>

   <!-- 댓글 입력창 및 목록 섹션 -->
   <div class="comment-section">
      <!-- 댓글 입력창 -->
      <form name="replyRegistPost" id="replyRegistPost"
         action="/common/freeBoard/registReplyPost" method="post">
         <div class="comment-input">
            <input type="text" id="commentContent" name="commentContent" class="form-control ck-blurred" placeholder="댓글을 입력하세요" rows="5">
            <button type="submit" id="submitComment" class="btn btn-Regist">등록</button>
         </div>
         <sec:csrfInput />
         <input type="hidden" id="pstSn" name="pstSn" value="${boardVO.pstSn}" />
      </form>

      <!-- 댓글 목록 -->
      <div id="commentsList" style="max-height: 510px; overflow: hidden;">
         <c:if test="${empty commentsList}">
            <p>댓글이 없습니다.</p>
         </c:if>
    <c:forEach var="comment" items="${commentsList}">
        <div class="comment-item" data-cmnt-no="${comment.cmntNo}">
            <p>
                <c:choose>
                    <c:when test="${comment.mbrId == 'admin'}">
                        <strong style="background-color: rgba(36, 213, 158, 0.11);">★관리자</strong>(${comment.cmntRegDt})
                    </c:when>
                    <c:otherwise>
                        <strong>${comment.mbrId}</strong>(${comment.cmntRegDt})
                    </c:otherwise>
                </c:choose>
            </p>
            <div class="button-group-right">
                <p class="comment-content">${comment.cmntCn}</p>
                <!-- 로그인한 사용자일 때 수정/삭제 버튼 표시 -->
                <c:if test="${pageContext.request.userPrincipal.name == comment.mbrId}">
                    <div class="comment-buttons">
                        <button type="button" class="btn-delete-comment" data-id="${comment.cmntNo}">
                            <img src="${pageContext.request.contextPath}/resources/icon/Del_icon.png" alt="삭제" style="width: 20px; height: 20px;">
                        </button>
                        <button type="button" class="btn-edit-comment" data-id="${comment.cmntNo}">
                            <img src="${pageContext.request.contextPath}/resources/icon/Edit_icon.png" alt="수정" style="width: 20px; height: 20px;">
                        </button>
                    </div>
                </c:if>
            </div>

            <!-- 댓글 수정 폼 -->
            <div class="edit-comment-form" style="display: none;">
                <input type="text" class="edit-comment-text rpltext" value="${comment.cmntCn}">
                <button type="button" class="btn btn-cancel-edit cnBtn">취소</button>
                <button type="button" class="btn btn-save-edit">저장</button>
            </div>
        </div>
    </c:forEach>
</div>
<!-- 더보기 버튼 -->
<button id="loadMoreBtn" class="btn btn-primary" style="margin-top: 10px;">더보기</button>
   </div>
   <!--게시글 신고 -->
   <div id="repotModal" class="modal fade" tabindex="-1" role="dialog">
       <div class="modal-dialog" role="document">
           <div class="modal-content" style="position: relative; top: 120px;">
               <div class="modal-header">
                   <h5 class="modal-title" style="color:black">게시글 신고</h5>
                   <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                       <span aria-hidden="true">&times;</span>
                   </button>
               </div>
               <div class="modal-body">
                   <c:forEach var="codeVO" items="${codeVOList}">
                       <p><input type="radio" name="radio" style="margin-left: 1px;">
                       <label for="select" class="dclrTp" >&nbsp;${codeVO.comCodeNm}</label></p>
                   </c:forEach>
                   <textarea name="report_contents" id="dclrCn" class="inp_tarea dclrCn" title="신고내용 입력" placeholder="내용을 입력해주세요" rows="5" cols="54"></textarea>
               </div>
               <div class="modal-footer">
                   <button type="button" class="btn btn-secondary dclr-btn" data-dismiss="modal">접수</button>
               </div>
           </div>
       </div>
   </div>
</div>

<script type="text/javascript">
var Toast = Swal.mixin({
	   toast: true,
	    position: 'center',
	    showConfirmButton: false,
	    timer: 2000
	});
// 이미지 처리 함수 (기존 유지)
function handleImg(e){
    let files = e.target.files;
    let fileArr = Array.prototype.slice.call(files);
    let accumStr = "";
    fileArr.forEach(function(f){
        if(!f.type.match("image.*")){
            alert("이미지 확장자만 가능합니다");
            return;
        }
        let reader = new FileReader();
        reader.onload = function(e){
            accumStr += "<img src='"+e.target.result+"'/>";
            $("#pImg").html(accumStr);
        }
        reader.readAsDataURL(f);
    });
}

$(document).ready(function(){
	// 게시글 삭제
	$('.cancel').on('click', function(event) {
		Swal.fire({
			  title: '게시글을 삭제하시겠습니까?',
			  icon: 'question',
			  showCancelButton: true,
			  confirmButtonColor: 'white',
			  cancelButtonColor: 'white',
			  confirmButtonText: '예',
			  cancelButtonText: '아니오',
			  reverseButtons: false, // 버튼 순서 거꾸로
			}).then((result) => {
	        if (result.isConfirmed) {
	            // Toast.fire() 실행
	            Toast.fire({
	                icon: 'success',
	                title: '리뷰가 삭제되었습니다.'
	            });

	            // 바로 폼 제출
	            $('#reviewDeletePost').submit(); // 폼 제출
	        }
	    });
	});


    
    
    
    $('.btn-Regist').on('click', function(event) {
        var username = "${pageContext.request.userPrincipal != null ? pageContext.request.userPrincipal.name : 'anonymousUser'}";

        if (prcUsername === "anonymousUser") {
            event.preventDefault(); // 기본 폼 제출 막기
            Swal.fire({
          	  title: '로그인 후 작성할 수 있습니다. \n 로그인하시겠습니까?',
          	  icon: 'question',
          	  showCancelButton: true,
          	  confirmButtonColor: 'white',
          	  cancelButtonColor: 'white',
          	  confirmButtonText: '예',
          	  cancelButtonText: '아니오',
          	  reverseButtons: false, // 버튼 순서 거꾸로
          	}).then((result) => {
                if (result.isConfirmed) {
                  window.location.href = "/security/login"
                }
              })
            return;
        }
    });
    $(document).on("click", '.close', function() {
        $(this).closest('.modal').modal('hide');
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
         commentItem.find('.comment-content').show(); // 댓글 내용 표시
         commentItem.find('.edit-comment-form').hide(); // 수정 폼 숨기기
         commentItem.find('.btn-edit-comment').show(); 
         commentItem.find('.btn-delete-comment').show(); 
         const cmntNo = commentItem.data('cmnt-no');
         const pstSn = $('#pstSn').val();
         const cmntCn = commentItem.find('.edit-comment-text').val();

         $.ajax({
             url: '/common/freeBoard/updateComment',
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
                     commentItem.find('.comment-content').text(cmntCn).show(); 
                     commentItem.find('.edit-comment-form').hide();
                     Toast.fire({
         				icon:'success',
         				title:'댓글이 수정되었습니다.'
         			});  
                     
                 } else {
                	 Toast.fire({
          				icon:'error',
          				title:'댓글이 수정되지 않았습니다.'
          			});  
                 }
             },
             error: function(xhr, status, error) {
            	 Toast.fire({
       				icon:'error',
       				title:'댓글이 수정되지 않았습니다.'
       			});  
             }
         });
     });

     // 댓글 삭제 버튼 클릭 시
        $(document).on("click", '.btn-delete-comment', function() {
            const cmntNo = $(this).data('id');
            const pstSn = $('#pstSn').val();

            Swal.fire({
          	  title: '댓글을 삭제하시겠습니까?',
          	  icon: 'question',
          	  showCancelButton: true,
          	  confirmButtonColor: 'white',
          	  cancelButtonColor: 'white',
          	  confirmButtonText: '예',
          	  cancelButtonText: '아니오',
          	  reverseButtons: false, // 버튼 순서 거꾸로
          	}).then((result) => {
                if (result.isConfirmed) {
                    // 삭제 요청 진행
                    $.ajax({
                        url: '/outsou/deleteComment',
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
									icon:'success',
									title:'댓글이 삭제되었습니다.'
								}).then(() => {
                                    location.reload(); // 댓글 삭제 후 목록 갱신
                                });
                            } else {
                            	Toast.fire({
									icon:'error',
									title:'댓글 삭제 도중 오류가 발생하겼습니다.'
								})
                            }
                        },
                        error: function(xhr, status, error) {
                        	Toast.fire({
								icon:'error',
								title:'댓글 삭제 도중 오류가 발생하겼습니다.'
							})
                        }
                    });
                }
            });
        });

    });
</script>
