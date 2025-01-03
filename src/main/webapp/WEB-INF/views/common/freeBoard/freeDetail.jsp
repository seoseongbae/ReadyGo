<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<script type="text/javascript" src="/resources/js/jquery.min.js"></script>
<script type="text/javascript" src="/resources/ckeditor5/ckeditor.js"></script>
<script type="text/javascript" src="/resources/js/sweetalert2.js"></script>
<link rel="stylesheet" href="<%=request.getContextPath()%>/resources/css/alert.css" />
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec"%>
<sec:authentication property="principal" var="prc"/>

<!-- css 파일 -->
<link rel="stylesheet" href="<%=request.getContextPath()%>/resources/css/board/Detail.css" />

<script src="https://cdn.jsdelivr.net/npm/sockjs-client@1/dist/sockjs.min.js"></script><!-- 웹소켓 -->
<style>
#commentsList {
    transition: max-height 0.3s ease-in-out;
    overflow: hidden;
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
            Swal.fire({
                icon: 'info',
                title: '댓글 내용을 작성해주세요',
            });
            return;
        }
        
        if (username === 'anonymousUser') {
            Swal.fire({
                title: '로그인 후 댓글 작성할 수 있습니다.',
                text: "로그인 페이지로 이동하시겠습니까?",
                icon: 'warning',
                showCancelButton: true,
                confirmButtonColor: 'white',
                cancelButtonColor: 'white',
                confirmButtonText: '예',
                cancelButtonText: '아니오',
            }).then((result) => {
                if (result.isConfirmed) {
                    window.location.href = "/security/login";
                }
            });
            return;
        }

        // Ajax로 댓글 등록 요청
        $.ajax({
            url: '/common/freeBoard/registReplyPost',
            type: 'POST',
            data: {
                commentContent: commentContent,
                pstSn: pstSn
            },
            beforeSend: function(xhr) {
                xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
            },
            success: function(response) {
                location.reload(); // 댓글 목록 갱신
                $('#commentContent').val('');
            },
            error: function(xhr, status, error) {
                alert('댓글 등록 실패: ' + error);
            }
        });
    });

    let commentsToShow = 5;  // 처음에 보여줄 댓글 개수
    const totalComments = $(".comment-item").length;  // 전체 댓글 개수

    // 초기 상태에서 5개 댓글만 보이게 함
    $(".comment-item").slice(0, commentsToShow).show();

    // 더보기 버튼 클릭 시 5개씩 추가 표시
    $('#loadMoreBtn').on('click', function() {
        commentsToShow += 5;  // 댓글을 추가로 5개씩 더 보여줌
        $(".comment-item").slice(0, commentsToShow).slideDown();  // 추가 댓글 표시

        // 모든 댓글을 다 불러왔을 경우 더보기 버튼 숨김
        if (commentsToShow >= totalComments) {
            $('#loadMoreBtn').hide();
        }
    });

    // 댓글 개수가 5개 이하일 때 더보기 버튼 숨기기
    if (totalComments <= commentsToShow) {
        $('#loadMoreBtn').hide();
    }
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
		<h2>자유 게시글</h2>
	</div>
   <div class="title-group">
      <div class="content-group">
         <form name="deletePost" id="deletePost" action="/common/freeBoard/deletePost" method="post">
         <input type="hidden" name="_csrf" value="${_csrf.token}" />
            <div class="Content">
					<div class="rv-detail">
						<!--  제목, 신고버튼 -->
						<div class="titlegroup">
                    <div class="left">
                         <p style="font-weight: bold;  font-size: 30px;"> ${boardVO.pstTtl}</p>
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
					                        <p>작성자&nbsp;:&nbsp;<a href="/member/profile?mbrId=${boardVO.mbrId}">${boardVO.mbrId}</a></p>
					                        <p>작성일&nbsp;:&nbsp; ${boardVO.pstWrtDt}&nbsp;(수정됨)</p>
				                        </div>
				                      </c:if>
							    	  <c:if test="${boardVO.pstMdfcnDt == null}">
				                     	<div class="wit">
					                        <p>작성자&nbsp;:&nbsp;<a href="/member/profile?mbrId=${boardVO.mbrId}">${boardVO.mbrId}</a></p>
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
						<!-- 첨부 파일 다운로드 링크 -->
	                   	<c:forEach var="file" items="${fileDetails}">
						    <div class="filelist">
						        <a href="/download?fileName=${file.filePathNm}" download="${file.orgnlFileNm}">
						            <i class="fas fa-link mr-1"  style="font-weight:600; font-size:14px;">${file.orgnlFileNm} (${file.fileFancysize})</i>
						        </a>
					    	</div>
						</c:forEach>
						<!-- 첨부 파일 다운로드 링크 -->
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
               		<input type="button" class="btn btn-List"  onclick="location.href='/common/freeBoard/freeList'" value="목록" />
               	</div>
               <div class="button-group-right">
                  <!-- 로그인하지 않은 경우 버튼 숨기기 -->
                  <c:if test="${pageContext.request.userPrincipal == null}">
                     <!-- 아무것도 표시하지 않음 -->
                  </c:if>
                  
                  <!-- 로그인한 사용자인 경우 -->
                  <c:if test="${pageContext.request.userPrincipal != null}">
                     <!-- 로그인한 사용자와 게시글 작성자가 같을 때만 수정/삭제 버튼을 표시 -->
                     <c:if test="${pageContext.request.userPrincipal != null && pageContext.request.userPrincipal.name == boardVO.mbrId}">
                     	<div id="editBox">
							<p>
								<input type="button" class="cancel" value="삭제" />
								<button type="button" id="savebtn"  onclick="location.href='/common/freeBoard/freeUpdate?seNo=${boardVO.seNo}&pstSn=${boardVO.pstSn}'">수정</button>
							</p>
						</div>
                     </c:if>
                  </c:if>
                  <input type="hidden" id="pstSn" name="pstSn"  value="${boardVO.pstSn}" />
               </div>
            </div>
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
         <input type="hidden" id="pstSn" name="pstSn" value="${boardVO.pstSn}" />
      </form>

      <!-- 댓글 목록 -->
      <div id="commentsList">
         <c:if test="${empty commentsList}">
            <p>댓글이 없습니다.</p>
         </c:if>
         <c:forEach var="comment" items="${commentsList}">
            <div class="comment-item" data-cmnt-no="${comment.cmntNo}" style="display: none;">
                 <p>
                     <c:choose>
                         <c:when test="${comment.mbrId == 'admin'}">
                             <strong style="background-color:  rgba(36, 213, 158, 0.11);">★관리자</strong>(${comment.cmntRegDt})
                         </c:when>
                         <c:otherwise>
                             <strong>${comment.mbrId}</strong>(${comment.cmntRegDt})
                         </c:otherwise>
                     </c:choose>
                 </p>
               <div class="button-group-right">
                  <p class="comment-content">${comment.cmntCn}</p>
                  <!-- 로그인하지 않은 경우 버튼 숨기기 -->
                  <c:if test="${pageContext.request.userPrincipal == null}">
                     <!-- 아무것도 표시하지 않음 -->
                  </c:if>
                  <!-- 로그인한 사용자인 경우 -->
                  <c:if test="${pageContext.request.userPrincipal != null}">
                     <!-- 로그인한 사용자와 댓글 작성자가 같을 때만 수정/삭제 버튼을 표시 -->
                     <c:if test="${pageContext.request.userPrincipal.name == comment.mbrId}">
                        <div class="comment-buttons">
                           <button type="button" class="btn-delete-comment"
                              data-id="${comment.cmntNo}"><img src="${pageContext.request.contextPath}/resources/icon/Del_icon.png" alt="삭제" style="width: 20px; height: 20px;"></button>
                           <button type="button" class="btn-edit-comment"
                              data-id="${comment.cmntNo}"><img src="${pageContext.request.contextPath}/resources/icon/Edit_icon.png" alt="수정" style="width: 20px; height: 20px;"></button>
                        </div>
                     </c:if>
                     <c:if test="${pageContext.request.userPrincipal.name != comment.mbrId && comment.mbrId != 'admin'}">
                        <div class="comment-buttons">
                           <button type="button" class="btn-report-comment"
                              data-id="${comment.cmntNo}"><img src="${pageContext.request.contextPath}/resources/icon/Warn_icon.png" alt="신고" style="width: 20px; height: 20px;"></button>
                        </div>
                     </c:if>
                  </c:if>
               </div>

               <!-- 댓글 수정 폼-->
               <div class="edit-comment-form" style="display: none;">
				<input type="text" class="edit-comment-text rpltext"
                     value="${comment.cmntCn}">
                  <button type="button" class="btn btn-cancel-edit">취소</button>
                  <button type="button" class="btn btn-save-edit">저장</button>
               </div>
            </div>
         </c:forEach>
      </div>
		   <button id="loadMoreBtn" class="btn" style="margin-left: 5px;">더보기</button>
   </div>

<!-- 게시글 신고 모달 -->
<div id="repotModal" class="modal fade" tabindex="-1" role="dialog">
 	<div class="modal-dialog" role="document">
       <div class="modal-content" style="position: relative; top: 120px;
       ">
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

<!-- 댓글 신고 모달 -->
<div id="replyReportModal" class="modal fade" tabindex="-1" role="dialog">
   <div class="modal-dialog" role="document">
       <div class="modal-content">
           <div class="modal-header">
               <h5 class="modal-title" style="color:black">댓글 신고</h5>
               <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                   <span aria-hidden="true">&times;</span>
               </button>
           </div>
           <div class="modal-body">
               <c:forEach var="codeVO" items="${codeVOList}">
                   <p><input type="radio" name="radio" style="margin-left: 1px;">
                   <label for="select" class="dclrTp2" >&nbsp;${codeVO.comCodeNm}</label></p>
               </c:forEach>
               <textarea name="report_contents" id="dclrCn2" class="inp_tarea dclrCn" title="신고내용 입력" placeholder="내용을 입력해주세요" rows="5" cols="54"></textarea>
           </div>
           <div class="modal-footer">
               <button type="button" class="btn btn-secondary dclr-reply-btn" data-dismiss="modal">접수</button>
           </div>
       </div>
   </div>
</div>

</div>
<script type="text/javascript">
function handleImg(e){
   let files = e.target.files; // 선택한 파일들
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
    $(document).on('click', '.close', function() {
        $(this).closest('.modal').modal('hide');
    });
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
    
	$(document).on('click', '.cancel', function() {
	    Swal.fire({
	        title: '게시글을 삭제하시겠습니까?',
	        icon: 'error',
	        showCancelButton: true,
	        confirmButtonColor: 'white',
	        cancelButtonColor: 'white',
	        confirmButtonText: '예',
	        cancelButtonText: '아니오',
	    }).then((result) => {
	        if (result.isConfirmed) {
	            $('#deletePost').submit();  // 폼 제출
	        }
	    });
	});


    $('.btn-Regist').on('click', function(event) {
        var username = "${pageContext.request.userPrincipal != null ? pageContext.request.userPrincipal.name : 'anonymousUser'}";

        if (username === "anonymousUser") {
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
        }
    });

    $(document).on("click", '.btn-Report', function() {
        var username = "${pageContext.request.userPrincipal != null ? pageContext.request.userPrincipal.name : 'anonymousUser'}";

        if (username === "anonymousUser") {
            Swal.fire({
                title: '로그인 후 신고 할 수 있습니다.',
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
            $('#dclrCn').val(''); // 신고 내용 텍스트 초기화
            $('input[name="radio"]').prop('checked', false);
            $('#repotModal').modal('show');
        }
    });

    $(document).on("click", '.dclr-btn', function() {
        const dclrTp = $('input[type="radio"]:checked').next('.dclrTp').text(); 
        const dclrCn = $('#dclrCn').val(); 
        const pstSn = $('#pstSn').val(); 
        const mbrId = '${boardVO.mbrId}'; 
        const currentUrl = window.location.href;  
        const dclrUrl = 'http://localhost/adm/freeBoard/admFreeDetail?seNo=3&pstSn=' + pstSn;

        if (!dclrTp || !dclrCn) {
            Swal.fire({
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
                    const Toast = Swal.mixin({
                        toast: true,
                        position: 'center-center',
                        showConfirmButton: false,
                        timer: 1500,
                        
                        didOpen: (toast) => {
                          toast.addEventListener('mouseenter', Swal.stopTimer),
                          toast.addEventListener('mouseleave', Swal.resumeTimer)
                        }
                    })

                    Toast.fire({
                        icon: 'success',
                        title: '신고가 접수되었습니다.'
                    })
                    $('#repotModal').modal('hide'); 
                } else {
                    alert("신고 접수 실패.");
                }
            },
            error: function(xhr, status, error) {
                alert("신고 접수 중 오류 발생: " + error);
            }
        });
    });

    $(document).on("click", '.btn-report-comment', function() {
        const commentItem = $(this).closest('.comment-item');  
        const mbrId = commentItem.find('strong').text().trim(); 
        $('#mbrId').val(mbrId);  // 신고할 사용자 ID 설정
        $('#replyReportModal').modal('show'); // 신고 모달 열기
        $('#dclrCn2').val(''); // 신고 내용 텍스트 초기화
        $('input[name="radio"]').prop('checked', false);

        $(document).on("click", '.dclr-reply-btn', function() {
            const dclrTp = $('input[type="radio"]:checked').next('.dclrTp2').text();
            const dclrCn = $('#dclrCn2').val();  
            const pstSn = $('#pstSn').val();  
            const dclrUrl = 'http://localhost/adm/freeBoard/admFreeDetail?seNo=3&pstSn=' + pstSn;

            if (!dclrTp || !dclrCn) {
                Swal.fire({
                    icon: 'info',
                    title: '신고 유형과 내용을 입력해주세요',
                });
                return;
            }

            $.ajax({
                url: '/common/freeBoard/replyReport',
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
                            const Toast = Swal.mixin({
                                toast: true,
                                position: 'center-center',
                                showConfirmButton: false,
                                timer: 1500,
                                
                                didOpen: (toast) => {
                                  toast.addEventListener('mouseenter', Swal.stopTimer),
                                  toast.addEventListener('mouseleave', Swal.resumeTimer)
                                }
                            })

                            Toast.fire({
                                icon: 'success',
                                title: '신고가 접수되었습니다.'
                            })
                            $('#replyReportModal').modal('hide'); 
                        } else {
                            alert("신고 접수 실패.");
                        }
                    },
                error: function(xhr, status, error) {
                    Swal.fire({
                        icon: 'error',
                        title: '신고 접수 중 오류 발생: ' + xhr.responseText,
                    });
                }
            });
        });
    });

   $(document).on("click", '.btn-edit-comment', function() {
       const commentItem = $(this).closest('.comment-item');
       commentItem.find('.comment-content').hide();
       commentItem.find('.edit-comment-form').show();
       commentItem.find('.btn-edit-comment').hide(); 
       commentItem.find('.btn-delete-comment').hide(); 
   });

   $(document).on("click", '.btn-cancel-edit', function() {
       const commentItem = $(this).closest('.comment-item');
       commentItem.find('.comment-content').show(); 
       commentItem.find('.edit-comment-form').hide();
       commentItem.find('.btn-edit-comment').show(); 
       commentItem.find('.btn-delete-comment').show(); 
   });

   $(document).on("click", '.btn-save-edit', function() {
        const commentItem = $(this).closest('.comment-item');
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
                    commentItem.find('.btn-edit-comment').show(); 
                    commentItem.find('.btn-delete-comment').show();
                    Toast.fire({
                        icon: 'success',
                        title: '댓글이 수정되었습니다.'
                    });                     
                } else {
                    alert('댓글 수정 실패');
                }
            },
            error: function(xhr, status, error) {
                alert('댓글 수정 실패: ' + error);
            }
        });
    });

    $(document).on("click", '.btn-delete-comment', function() {
        const cmntNo = $(this).data('id');
        const pstSn = $('#pstSn').val();

        Swal.fire({
            title: '댓글을 삭제하시겠습니까?',
            icon: 'error',
            showCancelButton: true,
            confirmButtonColor: 'white',
            cancelButtonColor: 'white',
            confirmButtonText: '예',
            cancelButtonText: '아니오',
            
        }).then((result) => {
            if (result.isConfirmed) {
                $.ajax({
                    url: '/common/freeBoard/deleteComment',
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
                            Toast.fire({
                  				icon:'success',
                  				title:'댓글이 삭제되었습니다.'
                  			}).then(() => {
                                location.reload();
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
        
        document.querySelector('#registForm').addEventListener('submit', function(event) {
            document.querySelector('#pstCn').value = editor.getData();
        });
    })
    .catch(error => {
        console.error(error);
    });
</script>
