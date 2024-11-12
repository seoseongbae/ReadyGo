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
    margin: 0 auto; /* 수평 중앙 정렬 */
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
</style>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<div class="container2">
    <header>
        <h1>FAQ 게시판</h1>
    </header>
    <div class="smRegust">
    <div class="size">
    <form name="registForm" id="registForm" action="/adm/faqBoard/updatePost"  method="post">
    <div class="title-group">
        <input type="text" class="input-title" placeholder="제목을 작성해주세요" name="pstTtl" id="pstTtl" value="${boardVO.pstTtl}">
    </div>
    <div class="content-group">
        <div id="pstCnTemp" name="pstCnTemp">
	        <textarea id="pstCn" name="pstCn"></textarea>
        </div>
    </div>
    <div class="button-container">
        <button type="button" class="faq-btn btn-list" onclick="location.href='/adm/faqBoard/admFaqList'">취소</button>
        <button type="submit" class="faq-btn btn-regist">수정</button>
    </div>
    <input type="hidden" name="pstSn" value="${boardVO.pstSn}" />
	<input type="hidden" name="seNo" value="${boardVO.seNo}" />
    <sec:csrfInput/>
    </form>
    </div>
    </div>
</div>

<script type="text/javascript">
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

