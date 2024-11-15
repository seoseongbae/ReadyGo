<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec"%>
<sec:authorize access="isAuthenticated()">
	<sec:authentication property="principal.memVO" var="memVO" />
</sec:authorize>

<script type="text/javascript" src="/resources/js/sweetalert2.js"></script>
<!-- 외주 css 파일 -->
<link rel="stylesheet"
	href="<%=request.getContextPath()%>/resources/css/outsou/reviewregist.css" />
<!-- ckeditor -->
<script type="text/javascript" src="/resources/ckeditor5/ckeditor.js"></script> 
<script type="text/javascript" src="/resources/js/jquery.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@10"></script>
<link rel="stylesheet" href="<%=request.getContextPath()%>/resources/css/alert.css" />
<script type="text/javascript">

var Toast = Swal.mixin({
	   toast: true,
	    position: 'center',
	    showConfirmButton: false,
	    timer: 3000
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
	
	$(document).ready(function() {
	    // select 박스에서 값이 변경될 때 hidden 필드를 업데이트하는 이벤트 리스너
	    $('#outordNo').on('change', function() {
	        var selectedValue = $(this).val();  // 선택된 외주 번호
	        $('#selectedOutordNo').val(selectedValue);  // hidden 필드에 선택된 값을 설정
	    });
	});
	
	//리뷰를 등록 할 때 
	$("#savebtn").on("click", function(event){
	    event.preventDefault(); // 기본 폼 제출 막기
	    // success, error, warning, info, question, 
	    Toast.fire({
	        icon:'success',
	        title:'리뷰 등록이 완료되었습니다.'
	    });

	    $("#reviewRegistForm").submit();  // 폼 제출
	});
	
	//취소할때 
	$(".cancel").on("click", function() {
	    Swal.fire({
	        title: '취소하시겠습니까? \n 작성한 내용은 저장되지 않습니다.',
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
	            window.location.href = "/outsou/reviewList";
	        }
	    });
	});
	
	
})//function 끝

</script>
<div class="registAll">
	<!-- 등록 정보 전체 -->
	<div class="regist">
		<div class="registTitle">
			<h2>리뷰 게시글 등록</h2>
		</div>

		<!-- 리뷰 저장 -->
		<div class="smRegust">
			<form name="reviewRegistForm" id="reviewRegistForm"
				action="/outsou/reviewRegistPost?${_csrf.parameterName}=${_csrf.token}" method="post" enctype="multipart/form-data">
		
		
		    <!-- 로그인된 사용자의 ID -->
		    <input type="hidden" name="mbrId" value="${memVO.mbrId}" />
					<div class="GigFormInput1">
						<div class="Forminput">
							<!-- 구매한 상품 -->
							<div class="form-group1">
								<select id="outordNo" name="outordNo" class="title_1" required>
									<option value="" selected disabled>구입한 상품을 선택해주세요.</option>
									<c:forEach var="osAplyVOList" items="${osAplyVOList}">
										<option value="${osAplyVOList.outordNo}">${osAplyVOList.outordTtl}</option>
									</c:forEach>
								</select>
							</div>
							<!-- 구매한 상품 끝 -->
							<!-- 제목  -->
							<div class="form-group2">
								<input type="text" name="pstTtl" id="pstTtl" class="title_2" placeholder="제목을 입력해 주세요"
									maxlength="50" required />
							</div>
						 </div>
							<div class="GigFormInput5">
								<div>
									<div class="form-group8">
										<div id="pstCnTemp" name="pstCnTemp">
									        <textarea id="pstCn" name="pstCn"></textarea>
								        </div>
									</div>
									<div>
										<label class="faq-btn" for="pstFileFile" id="file-input">
										  파일첨부
										</label>
										<div class="form-group nb">
										    <input type="file" class="input-file" hidden
										           name="pstFileFile" id="pstFileFile" multiple onchange="test(this.files)"/>
										    <div id="file-list"></div>
										</div>
								    </div>
								</div>
								<div id="editBox">
									<p>
										<input type="button" class="cancel" value="취소" />
										<input type="submit" id="savebtn" value="등록" />
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

let selectedFiles = [];

function test(files) {
    console.log(files);
    const fileList = document.getElementById('file-list');  // 파일 리스트를 표시할 div
    for(let i=0; i<files.length; i++) {
        selectedFiles.push(files[i]);  // 선택된 파일을 배열에 저장
        const item = document.createElement('div');  // 파일 리스트의 항목(div)
        const fileName = document.createTextNode(files[i].name);  // 파일 이름을 텍스트로 생성
        const deleteButton = document.createElement('button');  // 삭제 버튼 생성

        // 삭제 버튼 클릭 시 파일 항목을 제거하는 이벤트 리스너
        deleteButton.addEventListener('click', (event) => {
            item.remove();  // 화면에서 파일 항목(div)을 제거
            event.preventDefault();
            deleteFile(files[i]);  // 배열에서 파일을 제거하는 함수 호출
        });

        deleteButton.innerText = "x";  // 삭제 버튼에 텍스트 표시
        item.appendChild(fileName);  // 파일 이름을 파일 항목에 추가
        item.appendChild(deleteButton);  // 삭제 버튼을 파일 항목에 추가
        fileList.appendChild(item);  // 파일 항목을 파일 리스트에 추가
    }
}

// 파일 삭제 시 배열에서 해당 파일을 제거하는 함수
function deleteFile(file) {
    selectedFiles = selectedFiles.filter(f => f !== file);
    console.log('Updated selected files:', selectedFiles);
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
