<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib uri="http://www.springframework.org/security/tags"
	prefix="sec"%>
<sec:authorize access="isAuthenticated()">
	<sec:authentication property="principal.memVO" var="memVO" />
</sec:authorize>

<script type="text/javascript" src="/resources/js/sweetalert2.js"></script>
<!-- 외주 css 파일 -->
<link rel="stylesheet"
	href="<%=request.getContextPath()%>/resources/css/outsou/reviewUpdate.css" />
<!-- ckeditor -->
<script type="text/javascript" src="/resources/ckeditor5/ckeditor.js"></script>
<script type="text/javascript" src="/resources/js/jquery.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@10"></script>
<link rel="stylesheet" href="<%=request.getContextPath()%>/resources/css/alert.css" />
<script type="text/javascript">
//알람창 
var Toast = Swal.mixin({
	   toast: true,
	    position: 'center',
	    showConfirmButton: false,
	    timer: 2000
	});
//이미지 처리 함수 
function HandleImg(e, targetElement) {
    let files = e.target.files; // 선택한 파일들
    let fileArr = Array.prototype.slice.call(files); // 배열로 변환
    let accumStr = "";

    fileArr.forEach(function(f) {
        // 이미지가 아니면
        if (!f.type.match("image.*")) {
            alert("이미지 확장자만 가능합니다.");
            return;
        }

        // 이미지일 경우 처리
        let reader = new FileReader();
        reader.onload = function(e) {
            accumStr += "<img src='" + e.target.result + "' style='width: 220px; height:180px; border: 1px solid #CED4DA;'>";
            $(targetElement).html(accumStr); // targetElement로 지정된 곳에 이미지 표시
        };
        reader.readAsDataURL(f);
    });
}

$(function(){
	console.log("개똥이");
	
	
	
	//이미지  미리보기 시작///
	$("#mainFile").on('change', function(e) {
    HandleImg(e, "#mainpImg");
	});
	
	$("#detailFile").on('change', function(e) {
	    HandleImg(e, "#detpImg");
	});
	//이미지 미리보기 끝///
	
	// 수정하기 버튼을 눌렀을 때 
	 $("#savebtn").on("click", function(event) {
	        event.preventDefault(); // 기본 폼 제출 막기
	        Swal.fire({
	            title: '수정하시겠습니까?',
	            icon: 'question',
	            showCancelButton: true,
	            confirmButtonColor: 'white',
	            cancelButtonColor: 'white',
	            confirmButtonText: '예',
	            cancelButtonText: '아니오'
	        }).then((result) => {
	            if (result.isConfirmed) {
	                // 수정 확인 시 폼 전송
	               $("#reviewUpdateForm").submit();
	                Toast.fire({
	                    icon: 'success',
	                    title: '수정이 완료되었습니다.'
	                });
	            } else {
	                // 수정 취소 시 버튼 다시 활성화
	                $("#savebtn").prop('disabled', false);
	                Toast.fire({
	                    icon: 'error',
	                    title: '수정이 취소되었습니다.'
	                });
	            }
	        });
	        
	    });
	
	//수정하기 버튼 클릭시 
		$(".cancel").on("click", function() {
		    Swal.fire({
		        title: '취소하시겠습니까? \n 수정한 내용은 저장되지 않습니다.',
		        icon: 'question',
		        showCancelButton: true,
		        confirmButtonColor: 'white',
		        cancelButtonColor: 'white',
		        confirmButtonText: '예',
		        cancelButtonText: '아니오'
		    }).then((result) => {
		        // 사용자가 "예"를 선택했을 경우에만 동작
		        if (result.isConfirmed) {
		            // 외주 번호를 URL 파라미터로 함께 전달
		            let pstSn = '${boardVO.pstSn}';  // JSP에서 외주 번호를 올바르게 전달받아야 합니다.
		            window.location.href = "/outsou/reviewDetail?seNo=5&pstSn=" + pstSn;
		        }
		    });
		});
	//취소하기 끝
	
	
})//function 끝

</script>
<div class="registAll">
	<!-- 등록 정보 전체 -->
	<div class="regist">
		<div class="registTitle">
			<h2>리뷰 게시글 수정</h2>
		</div>

		<!-- 리뷰 저장 -->
		<div class="smRegust">
			<form name="reviewUpdateForm" id="reviewUpdateForm"
			    action="/outsou/reviewUpdatePost?${_csrf.parameterName}=${_csrf.token}" method="POST"
			    enctype="multipart/form-data">


				<!-- 로그인된 사용자의 ID -->
				<input type="hidden" name="pstSn" value="${boardVO.pstSn}" /> 
				<input	type="hidden" name="mbrId" value="${memVO.mbrId}" />
				<input	type="hidden" name="mbrId" value="${ boardVO.outordNo}" />
				<div class="GigFormInput1">
					<div class="Forminput">
						<!-- 구매한 상품 -->
						<div class="form-group1">
							<select id="outordNo" name="outordNo" class="title_1" required disabled>
							    <!-- 선택된 상품 제목만 표시 -->
							    <c:forEach var="osAplyVO" items="${osAplyVOList}">
							        <c:if test="${osAplyVO.outordNo == boardVO.outordNo}">
							            <option value="${osAplyVO.outordNo}" selected>${osAplyVO.outordTtl}</option>
							        </c:if>
							    </c:forEach>
							</select>
						</div>
						<!-- 구매한 상품 끝 -->
						<!-- 제목  -->
						<div class="form-group2">
							<input type="text" name="pstTtl" id="pstTtl" class="title_2"
								value="${boardVO.pstTtl}" maxlength="50" required />
						</div>
					</div>
					<div class="GigFormInput5">
						<div>
							<div class="form-group8">
								<div id="pstCnTemp" name="pstCnTemp">
									<textarea id="pstCn" name="pstCn">${boardVO.pstCn}</textarea>
								</div>
							</div>
							<div>
								<label class="faq-btn" for="pstFileFile" id="file-input">
							        파일첨부
							    </label>
							    <div class="form-group nb">
							        <input type="file" class="input-file" hidden
							               name="pstFileFile" id="pstFileFile" multiple onchange="test(this.files)"/>
							
									<!-- 기존 파일 리스트 -->
									<div id="existing-file-list">
									    <p>기존파일:</p>
									    <c:forEach var="file" items="${fileDetails}">
									        <div class="file-item">
									            <!-- 기존 파일 다운로드 링크 -->
									            <a href="${file.filePathNm}" download="${file.orgnlFileNm}">
									                ${file.orgnlFileNm} (${file.fileFancysize}) 
									            </a>
									            <!-- 기존 파일 삭제 버튼 -->
									            <button type="button" class="delete-existing-file-btn" data-file-sn="${file.fileSn}">x</button>
									        </div>
									    </c:forEach>
									</div>
									
									<!-- 새로 추가된 파일 리스트 -->
									<div id="new-file-list">
									    <p>업로드 파일:</p>
									</div>
							    </div>
							</div>
						</div>
						
						<div id="editBox">
							<p>
									<input type="button" class="cancel" value="취소" />
								<input type="submit" id="savebtn" value="수정" />
							</p>
						</div>
					</div>
				</div>
				<sec:csrfInput />
			</form>
		</div>
		<!-- 기본정보 끝 -->
	</div>
</div>
<!-- 서비스 설명 부분에 해당하는 스크립트 -->
<script type="text/javascript">
function handleImg(e){
	//e.target : <input type="file" id="uploadFile"..>
	let files = e.target.files;//선택한 파일들
	//fileArr = [a.jpg,b.jpg,c.jpg]
	let fileArr = Array.prototype.slice.call(files);
	//f : a.jpg객체
	let accumStr = "";
	fileArr.forEach(function(f){
		//이미지가 아니면
		if(!f.type.match("image.*")){//MIME타입
			alert("이미지 확장자만 가능합니다.");
			return;//함수 종료
		}
		//이미지가 맞다면
		let reader = new FileReader();
		//e : reader가 이미지 객체를 읽는 이벤트
		reader.onload = function(e){
			accumStr += "<img src='"+e.target.result+"' style='width:20%;border:1px solid #D7DCE1;' />";
			$("#pImg").html(accumStr);
		}
		reader.readAsDataURL(f);
	});
}

//selectedFiles가 비어 있으면 fileGroupSn을 null로 설정하는 함수
let selectedFiles = [];

//기존 파일 삭제 처리
$(document).on('click', '.delete-existing-file-btn', function() {
    const fileSn = $(this).data('file-sn');
    $(this).parent().remove();  // 화면에서 파일 항목 제거
    console.log("Deleted existing fileSn:", fileSn);
    // 추가적으로 삭제할 기존 파일 리스트에 포함시키는 로직을 처리 (서버로 전송 필요)
});

//파일 삭제 시 배열에서 해당 파일을 제거하는 함수
function deleteFile(fileName) {
 selectedFiles = selectedFiles.filter(f => f.name !== fileName);
 console.log('Updated selected files:', selectedFiles);
 updateFileGroupSn();  // 파일 삭제 후 fileGroupSn 값 업데이트
}
//새로 업로드된 파일 리스트를 관리하는 함수
function test(files) {
    const fileList = document.getElementById('new-file-list');  // 새로 추가된 파일 리스트를 표시할 div
    for (let i = 0; i < files.length; i++) {
        selectedFiles.push(files[i]);  // 선택된 파일을 배열에 저장
        const item = document.createElement('div');  // 파일 리스트의 항목(div)
        const fileName = document.createTextNode(files[i].name);  // 파일 이름을 텍스트로 생성
        const deleteButton = document.createElement('button');  // 삭제 버튼 생성

        // 삭제 버튼 클릭 시 새로 추가된 파일 항목을 제거하는 이벤트 리스너
        deleteButton.addEventListener('click', (event) => {
            item.remove();  // 화면에서 파일 항목(div)을 제거
            event.preventDefault();
            deleteFile(files[i].name);  // 배열에서 파일을 제거하는 함수 호출
        });

        deleteButton.innerText = "x";  // 삭제 버튼에 텍스트 표시
        item.appendChild(fileName);  // 파일 이름을 파일 항목에 추가
        item.appendChild(deleteButton);  // 삭제 버튼을 파일 항목에 추가
        fileList.appendChild(item);  // 파일 항목을 파일 리스트에 추가
    }
}


//selectedFiles가 비어 있으면 fileGroupSn을 null로 설정하는 함수
function updateFileGroupSn() {
    const fileGroupSnInput = document.getElementById('fileGroupSn');
    if (selectedFiles.length === 0) {
        fileGroupSnInput.value = null;  // selectedFiles가 비어 있으면 null로 설정
    } else {
        fileGroupSnInput.value = "${fileGroupSn}";  // 값이 있으면 기존 fileGroupSn 유지
    }
}

//CKEditor5 적용 및 데이터 넣기
ClassicEditor.create(document.querySelector('#pstCn'), {
    placeholder: '\n 내용을 작성해주세요 \n\n * 등록한 글은 사용자 아이디로 등록됩니다. \n * 저작권 침해, 음란, 청소년 유해물, 기타 위법 자료 등을 게시할 경우 게시글 삭제 및 작성자에게 경고 조치 됩니다.',
    ckfinder: {
        uploadUrl: '/image/upload?${_csrf.parameterName}=${_csrf.token}'  // 파일 업로드 경로
    }
})
.then(editor => {
    window.editor = editor;
    
    // 폼 제출 전 CKEditor의 내용을 textarea에 동기화
    document.querySelector('#reviewRegistForm').addEventListener('submit', function(event) {
        // CKEditor에서 작성된 내용을 textarea로 동기화
        document.querySelector('#pstCn').value = editor.getData();
        console.log(document.querySelector('#pstCn').value)
    });
})
.catch(err => {
    console.error(err.stack);
});
</script>
