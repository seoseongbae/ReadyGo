<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<script type="text/javascript" src="/resources/ckeditor5/ckeditor.js"></script>
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
body {
    margin: 0;
    padding: 0;
    font-family: pretendard;
    background-color: #fff;
}

.container2 {
    width: 80%;
    margin: 0 auto;
    margin-left: 400px;
    padding-right: 300px;
}

h1 {
    font-size: 28px !important;
    font-weight: bold;
    text-align: left;
    padding-top: 20px;
    padding-bottom: 20px;
}

.input-title {
    flex: 1;
    font-size: 15px;
    border-radius: 8px;
    border: 1px solid #D9D9D9;
    height: 50px;
}

.title-group {
    display: flex;
    align-items: center;
    gap: 10px;
    flex: 1;
    margin-top: 30px;
}

.ck-placeholder {
    color: #aaa;
    white-space: pre-wrap;
    font-size: 12px;
}

.ck-editor__main .ck-content {
    height: 450px;
    border: 1px solid #000;
}

.faq-btn {
	background: white;
	color: #FD5D6C;
	border: 1px solid #FD5D6C;
	width: 100px;
	transition: all 0.3s ease 0s;
    text-align: center;
    padding: 8px 15px;
    border-radius: 5px;
}

.button-container {
    display: flex;
    justify-content: flex-end; 
    gap: 10px;
    margin-top: 20px;
    margin-bottom: 20px;
}

.faq-btn:hover {
    background-color: #FD5D6C;
    color: white;
}

.content-group{
	margin-top: 20px;
}
#file-list button, 
#existing-file-list button, 
#new-file-list button {  
    background: white;
    color: #FD5D6C; 
    border: 1px solid #FD5D6C;  
    transition: all 0.3s ease 0s;
    height: 25px;
    width: 25px;
    text-align: center;
    border-radius: 50%;  
    font-weight: bold;
    display: inline-flex;  
    justify-content: center; 
    align-items: center;  
    padding: 0;  
    cursor: pointer;  
    line-height: 0; 
}

#file-list button:hover,
#existing-file-list button:hover,
#new-file-list button:hover {
    background: #FD5D6C;  /
    color: white;  
    border: 1px solid #FD5D6C;
}

label:not(.form-check-label):not(.custom-file-label) {
    font-weight: normal;
}
.smRegust {
    display: flex;
    justify-content: center; 
    align-items: center; 
    border: 1px solid rgba(0, 0, 0, 0.1);
    border-radius: 0px 0px 12px 12px;
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
    border-top: solid 4px #FD5D6C;
    height: 100%; 
}
.size {
    width: 800px;
    margin: 0 auto; 
}
.btn-list{
   width: 100px;
    display: flex;
    justify-content: center;
    align-items: center;
    text-align: center;
   padding: 8px 15px;
    border-radius: 5px;
    font-size: 14px;
    background: white;
   color: #232323;
   border: 1px solid #B5B5B5;
   transition: all 0.3s ease 0s;
}
.btn-list:hover{
   background: #ECECEC;
   color: #232323;
   border: 1px solid #B5B5B5;
}
.file-item a{
	color: black;
}
.file-item a:hover{
	color: #FD5D6C;
}
</style>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div class="container2">
    <header>
        <h1>자유 게시판</h1>
    </header>
   	<div class="smRegust">
	<div class="size">
    <form name="registForm" id="registForm" action="/adm/freeBoard/updatePost"  method="post" enctype="multipart/form-data">
    <input type="hidden" name="fileGroupSn" id="fileGroupSn" value="${fileGroupSn}">
    <div class="title-group">
       <div class="cat_main">
			<select class="form-control category" name="pstOthbcscope" id="pstOthbcscope" required>
			    <option value="" selected disabled hidden>공지/안내</option>
			    <c:forEach var="codeVO" items="${codeVOList}">
			        <c:choose>
			            <c:when test="${codeVO.comCodeNm == boardVO.pstOthbcscope}">
			                <option value="${codeVO.comCodeNm}" selected>${codeVO.comCodeNm}</option>
			            </c:when>
			            <c:otherwise>
			                <option value="${codeVO.comCodeNm}">${codeVO.comCodeNm}</option>
			            </c:otherwise>
			        </c:choose>
			    </c:forEach>
			</select>
        </div>
        <input type="text" class="input-title" placeholder="제목을 작성해주세요" name="pstTtl" id="pstTtl" value="${boardVO.pstTtl}">
    </div>
    <div class="content-group">
        <div id="pstCnTemp" name="pstCnTemp">
	        <textarea id="pstCn" name="pstCn"></textarea>
        </div>
        <div style="margin-top:10px;">
			<label class="faq-btn" for="pstFileFile" id="file-input">
			  파일첨부
			</label>
			<div class="form-group nb">
			    <input type="file" class="input-file" hidden
			           name="pstFileFile" id="pstFileFile" multiple onchange="test(this.files)"/>
			<!-- 기존 파일 리스트 -->
			<div id="existing-file-list">
			    <p>기존 파일:</p>
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
    <input type="hidden" name="pstSn" value="${boardVO.pstSn}">
    <div class="button-container">
        <button type="button" class="faq-btn btn-list" onclick="location.href='/adm/freeBoard/admFreeList'">취소</button>
        <button type="submit" class="faq-btn btn-regist">수정</button>
    </div>
    <sec:csrfInput/>
    </form>
    </div>
    </div>
</div>

<script type="text/javascript">
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
// CKEditor5 적용 및 데이터 넣기
ClassicEditor.create(document.querySelector('#pstCnTemp'), { 
    placeholder: '\n 내용을 작성해주세요 \n\n * 등록한 글은 사용자 아이디로 등록됩니다. \n * 저작권 침해, 음란, 청소년 유해물, 기타 위법 자료 등을 게시할 경우 게시글 삭제 및 작성자에게 경고 조치 됩니다.',
    ckfinder: {
        uploadUrl: '/image/upload?${_csrf.parameterName}=${_csrf.token}'  // 파일 업로드 경로
    }
})
.then(editor => { 
    window.editor = editor;
    
    editor.setData('${boardVO.pstCn}');	//입력된 값 넣는 곳!
    
    // 폼 제출 전 CKEditor의 내용을 textarea에 동기화
    document.querySelector('#registForm').addEventListener('submit', function(event) {
        document.querySelector('#pstCn').value = editor.getData();
    });
})
.catch(err => { console.error(err.stack); });
</script>
