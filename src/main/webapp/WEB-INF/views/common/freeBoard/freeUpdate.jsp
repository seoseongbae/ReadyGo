<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="sec"
	uri="http://www.springframework.org/security/tags"%>
<script type="text/javascript" src="/resources/ckeditor5/ckeditor.js"></script>
<script type="text/javascript" src="/resources/js/jquery.min.js"></script>
<!-- css 파일 -->
<link rel="stylesheet"
	href="<%=request.getContextPath()%>/resources/css/board/Regist_Update.css" />
<script type="text/javascript">

</script>

<div class="registAll">
	<!-- 등록 정보 전체 -->
	<div class="regist">
		<div class="registTitle">
			<h2>자유 게시글 수정</h2>
		</div>
		<div class="smRegust">
			<div class="size">
				<form name="registForm" id="registForm"
					action="/common/freeBoard/updatePost" method="post"
					enctype="multipart/form-data">
					<input type="hidden" name="fileGroupSn" id="fileGroupSn"
						value="${fileGroupSn}">

					<div class="title-group">
						<div class="cat_main">
							<select class="form-control category" name="pstOthbcscope"
								id="pstOthbcscope" required style="width: 115px !important;">
								<option value="" selected disabled hidden>카테고리 선택</option>
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
						<div>
							<input type="text" class="input-title" placeholder="제목을 작성해주세요"
								name="pstTtl" id="pstTtl" value="${boardVO.pstTtl}" style="width: 735px !important;">
						</div>
					</div>

					<div class="GigFormInput5">
						<div>
							<div class="content-group">
								<div id="pstCnTemp" name="pstCnTemp">
									<textarea id="pstCn" name="pstCn"></textarea>
								</div>

								<div>
									<label class="faq-btn" for="pstFileFile" id="file-input">
										파일첨부 </label>
									<div class="form-group nb">
										<input type="file" class="input-file" hidden
											name="pstFileFile" id="pstFileFile" multiple
											onchange="test(this.files)" />

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
							<input type="hidden" name="pstSn" value="${boardVO.pstSn}">
							<div id="editBox">
								<p>
									<input type="button" class="cancel"  onclick="location.href='/common/freeBoard/freeList'" value="취소" />
									<input type="submit" id="savebtn" class="faq-btn btn-regist" value="수정" />
								</p>
							</div>
						</div>
					</div>

					<!-- 							<div class="button-container"> -->
					<!-- 								<button type="button" class="faq-btn btn-list" -->
					<!-- 									onclick="location.href='/common/freeBoard/freeList'">취소</button> -->
					<!-- 								<button type="submit" class="faq-btn btn-regist">수정</button> -->
					<!-- 							</div> -->
					<sec:csrfInput />
				</form>
			</div>
		</div>
	</div>
</div>	

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

// CKEditor5 적용 및 데이터 넣기
ClassicEditor.create(document.querySelector('#pstCnTemp'), { 
    placeholder: '\n 내용을 작성해주세요 \n\n * 등록한 글은 사용자 아이디로 등록됩니다. \n * 저작권 침해, 음란, 청소년 유해물, 기타 위법 자료 등을 게시할 경우 게시글 삭제 및 작성자에게 경고 조치 됩니다.',
    ckfinder: {
        uploadUrl: '/image/upload?${_csrf.parameterName}=${_csrf.token}'  // 파일 업로드 경로
    }
})
.then(editor => { 
    window.editor = editor;
    
    editor.setData('${boardVO.pstCn}');	// 입력된 값 넣는 곳!
    
    // 폼 제출 전 CKEditor의 내용을 textarea에 동기화
    document.querySelector('#registForm').addEventListener('submit', function(event) {
        document.querySelector('#pstCn').value = editor.getData();
    });
})
.catch(err => { console.error(err.stack); });
</script>