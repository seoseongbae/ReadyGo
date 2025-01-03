<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/security/tags"
	prefix="sec"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<link rel="stylesheet"
	href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200" />
<link rel="stylesheet"
	href="<%=request.getContextPath()%>/resources/css/member/aplctList.css" />
<link rel="stylesheet"
	href="<%=request.getContextPath()%>/resources/css/security/loginForm.css" />
	<link rel="stylesheet" href="<%=request.getContextPath()%>/resources/css/alert.css" />
<script
	src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script type="text/javascript" src="/resources/js/jquery.min.js"></script>
<script src="/resources/js/sweetalert2.js"></script>
<script>
var Toast = Swal.mixin({
	toast: true,
    position: 'top-end',
    showConfirmButton: false,
    timer: 3000
});
$(function() {
	$("#registBtn").on("click", function(){
		let clStrgNo = $(this).data("clStrgNo");
		$("#editPageclStrgNo").val(clStrgNo);
		$("#editPage").submit();
	})
	$(".editBtn").on("click", function(){
		let clStrgNo = $(this).data("clStrgNo");
		$("#editPageclStrgNo").val(clStrgNo);
		$("#editPage").submit();
		
	})
	$(".deleteBtn").on("click", function(){
     	let clStrgNo = $(this).data("clStrgNo");
        let pat = $(this).parents(".cvConBox");
        	Swal.fire({
        	  title: '삭제 하시겠습니까?',
        	  icon: 'error',
        	  showCancelButton: true,
        	  confirmButtonColor: 'white',
        	  cancelButtonColor: 'white',
        	  confirmButtonText: '예',
        	  cancelButtonText: '아니오',
        	  reverseButtons: false, // 버튼 순서 거꾸로
        	}).then((result) => {
        	  if (result.isConfirmed) {
        		  let formData = new FormData();
        			
  		 	    formData.append("clStrgNo", clStrgNo);
  		 		
                  
                  $.ajax({
                      url: "/member/coverDeletePost",
                      processData: false,
                      contentType: false,
                      data: formData,
                      type: "post",
                      dataType: "json",
                      beforeSend: function(xhr) {
                          xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
                      },
                      success: function(result) {
                      	if(result>0){
          	                Toast.fire({
          	                    icon: 'success',
          	                    title: '자기소개서 삭제 완료'
          	                });
          	               $("")
                      	}else{
          	                Toast.fire({
          	                    icon: 'warning',
          	                    title: '자기소개서 삭제 실패'
          	                });
          	                return;
                      	}
                      	history.go(0);
                      }
               	});
                  
        	  }
        })
	})
});
</script>
<style>
#topbox {
	background-image: linear-gradient(90deg, #24D59E, #2CCFC3);
	height: auto;
	width: 100%;
	min-width: 1200px;
	margin: 0;
	border-radius: 16px;
	padding: 15px 50px 15px 50px;
	align-items: center;
}

#conbox {
	background-color: white;
	height: 290px;
	width: 100%;
	margin: 0;
	border-radius: 16px;
	padding: 15px 50px 0px 50px;
	align-items: center;
}

.headBox {
	width: 1360px;
}

#topbox img {
	width: 30px;
	position: relative;
	bottom: 8px;
}

#conbox img {
	width: 30px;
}

.topboxContent {
	width: auto;
}

.aBtn a {
	background-color: white;
	color: #666363;
	width: auto;
	font-size: 14px;
	font-weight: bold;
	border-radius: 30px;
	padding: 10px 30px 10px 30px;
}

#conbox p {
	color: #475067;
	font-weight: bold;
	font-size: 14px;
}

.aBtn {
	margin-top: 15px;
}

#total {
	position: relative;
	right: 14px;
	bottom: 15px;
	background: #bcbcbc;
	color: white;
	min-width: 40px;
	padding: 7px 8px 7px 8px;
	border-radius: 999px;
	font-size: 14px;
}

.resetBtn {
	background: white;
	color: #232323;
	border: 1px solid #B5B5B5;
	transition: all 0.3s ease 0s;
	padding: 10px 30px 10px 30px;
	margin-right: 20px;
	border-radius: 5px;
}

.resetBtn:hover {
	background: #ECECEC;
	border: 1px solid #B5B5B5;
}

.submitBtn {
	background: white;
	color: #24D59E;
	border: 1px solid #24D59E;
	transition: all 0.3s ease 0s;
	padding: 7px 40px 7px 40px;
	border-radius: 5px;
}

.submitBtn:hover {
	background-color: #24D59E;
	color: white;
}

.editBtn {
	border: solid white 1px;
	color: white;
	background-color: transparent;
	padding: 10px 40px 10px 40px;
	margin-right: 20px;
	border-radius: 5px;
}

.setBtnForm {
	display: flex;
	justify-content: space-between;
	margin-top: 10px;
}

.vertImg {
	cursor: pointer;
}

.vertImg:hover {
	background-color: #24AAA0;
	border-radius: 4px;
}

#conbox .vertImg:hover {
	background-color: #e5e5e5;
	border-radius: 4px;
}

hr {
	border-top: 2.5px solid rgb(0 0 0/ 66%);
	margin: 0;
}

.conBtn {
	padding: 7px 40px 7px 40px;
	font-size: 14px;
}

.memoP {
	margin-top: 10px;
	width: 1186px;
	left: 23px;
	position: absolute;
}

#topbox .headerP>.asdf {
	position: relative;
	box-shadow: inset 0 -8px 0 #dbe8fe6e;
}

#topbox .headerP {
	display: flex;
	position: relative;
	color: var(- -blue90);
	font-weight: bold;
	line-height: 16px;
	padding-bottom: 14px;
}

.downMenu {
	width: 130px;
	display: none;
	position: absolute;
	background-color: white;
	list-style: none;
	padding: 4px;
	border: 1px solid #ccc;
	text-align: center;
	border-radius: 5px;
	right: 42px;
	top: 61px;
}

.downMenu li a {
	color: #2f2f2f;
	font-size: 12px;
	font-family: pretendard;
	font-weight: 500;
	height: auto;
}

.downMenu li a:hover {
	color: #24D59E;
}
</style>
<form id="editPage" action="/member/coverRegist" method="post">
	<input type="hidden" name="clStrgNo" id="editPageclStrgNo" value="" />
	<sec:csrfInput/>
</form>
<form id="deletePage" action="/member/coverDelete" method="post">
	<input type="hidden" name="clStrgNo" id="deletePageclStrgNo" value="" />
	<sec:csrfInput/>
</form>
<div style="zoom:0.9; display: flex; justify-content: center;position: relative; bottom: 10px;">
	<div class="container headBox">
		<p id="h3"style="font-size: 33.33px;">자기소개서 관리</p>
		<br>
		<br>
		<div class="row setBtnForm"
			style="margin: 0; align-items: center;">
			<p style="color: #0000008a; font-size: 18px;">전체 ${total}</p>
			<div class="form-group row" style="width: 975px; justify-content: space-between;" >
				<form action="/member/cover" method="get" class="row" style="width: 786px; justify-content: space-between;">
					<select class="form-control"id="state" name="state" style="width: 150px;">
						<option value="" <c:if test="${param.state==''}">selected</c:if> selected>정렬선택</option>
							<option value="new"
							 <c:if test="${param.state=='new'}">selected</c:if>>최신순</option>
							<option value="old"
							 <c:if test="${param.state=='old'}">selected</c:if>>오래된순</option>
					</select>
					<input type="text" class="form-control"  style="width: 500px;" name="keywordInput"
								placeholder="제목으로 자소서를 검색해 보세요." value="${param.keywordInput}">
					<button type="submit" class="submitBtn">검색</button>
				</form>
				<button type="button" class="submitBtn" id="registBtn">자기소개서 작성</button>
			</div>
		</div>
		<hr />
		<c:if test="${articlePage.content[0]==null}">
						<div style="display: flex; flex-direction: row; justify-content: center;">
							<div style="margin-top: 30px; ">
								<p style="font-size: 22px; ">검색 조건과 일치하는 자소서가 없습니다.</p>
							</div>
						</div>
					</c:if>
		<c:choose>
		<c:when test="${not empty articlePage.content}">
		<c:forEach var="VO" items="${articlePage.content}" varStatus="stut">
			<div class="row cvConBox" style="justify-content: space-between;">
				<div style="width: 800px;">
					<div class="title">
						${VO.clTtl }
					</div>
					<div class="con">
						${VO.clCn }
					</div>
					<div class="date">
					<c:choose>
						<c:when test="${VO.clEdtDt == null }">
							<fmt:formatDate value="${VO.clWrtDt }" pattern="yyyy.MM.dd hh:mm:ss"/> &nbsp;작성
						</c:when>
						<c:otherwise>
							<fmt:formatDate value="${VO.clEdtDt }" pattern="yyyy.MM.dd hh:mm:ss"/> &nbsp;수정
						</c:otherwise>
					</c:choose>
					</div>
				</div>
				<div style="margin-top: 45px;">
					<button type="button" data-cl-strg-no="${VO.clStrgNo}" class="submitBtn editBtn">수정</button>
					<button type="button" data-cl-strg-no="${VO.clStrgNo}" class="resetBtn deleteBtn">삭제</button>
				</div>
			</div>
		</c:forEach>
		</c:when>
			<c:otherwise>
				<tr>
					<td id="noSrc"colspan="4">검색 결과가 없습니다.</td>
				</tr>
			</c:otherwise>
		</c:choose>
		<c:if test="${not empty articlePage.content}">
		<div class="card-body table-responsive p-0" >
			<table class="table table-hover text-nowrap" style="border:none">
				<tfoot>
					<tr>
						<td colspan="4" style="text-align: center;border:none;">
							<div class="dataTables_paginate" id="example2_paginate"
								style="display: flex; justify-content: center; margin-top: 20px;border:none;">
								<br />
								<ul class="pagination">
									<!-- 맨 처음 페이지로 이동 버튼 -->
									<c:if test="${articlePage.currentPage gt 1}">
										<li class="paginate_button page-item first"><a
											href="/member/cover?currentPage=1&keywordInput=${param.keywordInput}&state=${param.state}"
											aria-controls="example2" data-dt-idx="0" tabindex="0"
											class="page-link">&lt;&lt;</a></li>
									</c:if>

									<!-- 이전 페이지 버튼 -->
									<c:if test="${articlePage.startPage gt 1}">
										<li class="paginate_button page-item previous"
											id="example2_previous"><a
											href="/member/cover?currentPage=${(articlePage.startPage - 1) lt 1 ? 1 : (articlePage.startPage - 1)}&keywordInput=${param.keywordInput}&state=${param.state}"
											aria-controls="example2" data-dt-idx="0" tabindex="0"
											class="page-link">&lt;</a></li>
									</c:if>

									<!-- 페이지 번호 -->
									<c:forEach var="pNo" begin="${articlePage.startPage}"
										end="${articlePage.endPage}">
										<li
											class="paginate_button page-item ${pNo == articlePage.currentPage ? 'active' : ''}">
											<a href="/member/cover?currentPage=${pNo}&keywordInput=${param.keywordInput}&state=${param.state}"
											aria-controls="example2" class="page-link">${pNo}</a>
										</li>
									</c:forEach>

									<!-- 다음 페이지 버튼 -->
									<c:if test="${articlePage.endPage lt articlePage.totalPages}">
										<li class="paginate_button page-item next" id="example2_next">
											<a
											href="/member/cover?currentPage=${articlePage.startPage+5}&keywordInput=${param.keywordInput}&state=${param.state}"
											aria-controls="example2" data-dt-idx="7" tabindex="0"
											class="page-link">&gt;</a>
										</li>
									</c:if>

									<!-- 맨 마지막 페이지로 이동 버튼 -->
									<c:if
										test="${articlePage.currentPage lt articlePage.totalPages}">
										<li class="paginate_button page-item last"><a
											href="/member/cover?currentPage=${articlePage.totalPages}&keywordInput=${param.keywordInput}&state=${param.state}"
											aria-controls="example2" data-dt-idx="7" tabindex="0"
											class="page-link">&gt;&gt;</a></li>
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
</div>
<style>
.cvConBox{
	padding: 30px 50px 50px 50px;
	border-bottom: 1px solid #d7dce5;
}
.title{
	color: #373f57;
    font-size: 20px;
    line-height: 28px;
    font-weight: 700;
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
    word-break: break-all;
}
.con{
    grid-column: 1 / 2;
    margin: 8px 0;
    height: 56px;
    color: #475067;
    font-size: 16px;
    line-height: 28px;
    display: -webkit-box;
    overflow: hidden;
    max-height: 56px;
    -webkit-line-clamp: 2;
    -webkit-box-orient: vertical;
}
.date{
	grid-column: 1 / 2;
    display: grid;
    grid-auto-flow: column;
    justify-content: start;
    align-items: center;
    gap: 10px;
    color: #96a0b5;
    font-size: 14px;
    line-height: 16px;
}
.editBtn{
    background: white;
    color: #24D59E;
    border: 1px solid #24D59E;
    transition: all 0.3s ease 0s;
    padding: 7px 40px 7px 40px;
    border-radius: 5px;
}
.resetBtn{
	background: white;
    color: #232323;
    border: 1px solid #B5B5B5;
    transition: all 0.3s ease 0s;
    padding: 7px 40px 7px 40px;
    border-radius: 5px;
}
</style>