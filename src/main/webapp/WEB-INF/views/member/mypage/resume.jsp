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
		// 프로필 영역 클릭 시 메뉴를 보여주거나 숨김
		$(".vertImg").on("click", function(event) {
			event.preventDefault(); // 링크 기본 동작 막기
			$(this).parent().find(".downMenu").toggle();
		});

		// 메뉴 외부 클릭 시 메뉴 숨김 처리
		$(document).on("click", function(event) {
			if (!$(event.target).closest(".vertImg").length) {
				$(".downMenu").hide();
			}
		});

		$("#registBtn").on("click", function() {
			location.href = "/member/resumeRegist";
		});
		
		$(".edit").on("click", function(){
			let rsmNo = $(this).data("rsmNo");
			$("#edtRsmNo").val(rsmNo);
			$("#resumeEditgogo").submit();
		})
		$(".copy").on("click", function(){
			let rsmNo = $(this).data("rsmNo");
			$("#copyRsmNo").val(rsmNo);
			$("#resumeCopygogo").submit();
		})
		$(".delRsumeBtn").on("click", function(){
           	let rsmNo = $(this).data("rsmNo");
   			$("#delRsmNo").val(rsmNo);
   			let frm = $("#resumeDeletegogo");
   			Swal.fire({
   			  title: '이력서를 삭제하시겠습니까?',
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
        		
		 	    formData.append("rsmNo", rsmNo);
		 		
                
                $.ajax({
                    url: "/member/deleteResume",
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
        	                    title: '이력서 삭제 완료'
        	                });
        	                location.href = "/member/resume";
                    	}else{
        	                Toast.fire({
        	                    icon: 'warning',
        	                    title: '이력서 삭제 실패'
        	                });
        	                return;
                    	}
                    }
             	});
   			  }
   			})
		})
		
		$(".selRereReume").on("change", function(){
			let rsmNo = $(this).data("rsmNo");
			let rere = $(this).val();
			let formData = new FormData();
		    formData.append("rsmNo", rsmNo);
		    formData.append("rsmRlsscopeCd", rere);
		    
		    console.log(rsmNo)
		    console.log(rere)
		    $.ajax({
	            url: "/member/updateResumeRere",
	            processData: false,
	            contentType: false,
	            data: formData,
	            type: "post",
	            dataType: "text",
	            beforeSend: function(xhr) {
	                xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
	            },
	            success: function(result) {
	                Toast.fire({
	                    icon: 'success',
	                    title: '설정 완료'
	                });
	                location.reload();
	                
	            },
	            error: function(xhr, status, error) {
	                console.error("Ajax 요청 실패:", status, error);
	                Toast.fire({
	                    icon: 'error',
	                    title: 'Ajax 요청 실패'
	                });
	            }
	        });
		})
		
		$(".pdfDownBtn").on("click", function() {
		    var popup = window.open('', '이력서 보기', 'width=1,height=1');
		    let form = $(this).parents(".resumeDownForm");
		    let val = $(this).parents(".resumeDownForm").find(".rsmNo").val();
		    console.log(val)
		    // 폼 데이터를 전송
		    form.attr("target", '이력서 보기'); // 새 창의 이름을 설정
		    form.submit(); // 폼 제출
		});
		
		
		//pdf다운로드
		//data-rsm-no="24"
		//클래스 속성의 값이 pdfDownAlink인 요소들 중에서 클릭한 바로 그 요소(this)의 data
		$(".pdfDownAlink").on("click",function(){
			let rsmNo = $(this).data("rsmNo");
			var popup = window.open('', '이력서 보기', 'width=1,height=1');
			//밖으로 꺼낸 폼의 text박스의 값으로 대입
			$("#frmRsmNo").val(rsmNo);
			//<form id="frm"
			$("#frm").attr("target", '이력서 보기');
			$("#frm").submit();
		});
		
		$(".resumeReadBtn").on("click",function(){
			let rsmNo = $(this).data("rsmNo");
			 var popup = window.open('', '이력서 보기', 'width=1000,height=1440,top=' + (screen.height/2 - 720) + ',left=' + (screen.width/2 - 460));
			 $("#ReadRsmNo").val(rsmNo);
		    // 폼 데이터를 전송
		    $("#resumeReadForm").attr("target", '이력서 보기'); // 새 창의 이름을 설정
		    $("#resumeReadForm").submit(); // 폼 제출
		});
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
.intrvwSttusCd{
	padding: 4px 10px;
	border-radius: 100px;
}
#filter {
    display: flex;
    FLEX-DIRECTION: row;
    justify-content: flex-end;
    align-items: center;
    margin-right: -32px;
    width: 1028px;
    margin-bottom: 10px;
    position: unset;
}
#apstSel {
    top: 41px;
    right: 170px;
}
#filterForm{
	height: auto;
	width: auto;
	margin-top: -31px;
}
#keywordInput {
    width: 295px;
    padding: 13px;
    font-size: 14px;
    border: 1px solid #232323;
    border-radius: 5px;
    height: 40px;
    border: 1px solid #ddd;
    color: #757575;
    margin-right: 7px;
}
#totl{
	font-size: 18px;
    font-weight: 850;
}
</style>
<form id="frm" action="/member/resumeDownload" method="post">
	<input type="hidden" name="rsmNo" id="frmRsmNo" value="" />
	<sec:csrfInput/>
</form>
<form id="resumeReadForm" action="/member/resumeRead" method="post">
	<input type="hidden" name="rsmNo" id="ReadRsmNo" value="" />
	<sec:csrfInput/>
</form>
<form id="resumeEditgogo" action="/member/resumeEdit" method="post">
	<input type="hidden" name="rsmNo" id="edtRsmNo" value="" />
	<sec:csrfInput/>
</form>
<form id="resumeCopygogo" action="/member/resumeCopy" method="post">
	<input type="hidden" name="rsmNo" id="copyRsmNo" value="" />
	<sec:csrfInput/>
</form>
<!-- <form id="resumeDeletegogo" action="/member/deleteResume" method="post"> -->
<!-- 	<input type="hidden" name="rsmNo" id="delRsmNo" value="" /> -->
<%-- 	<sec:csrfInput/> --%>
<!-- </form> -->
<div style="zoom:0.9; display: flex; justify-content: center;position: relative; bottom: 10px;">
	<div class="container headBox">
		<p id="h3"style="font-size: 33.33px;">이력서 관리</p>
		<br>
		<br>
		<c:if test="${openResume != null }">
			<div class="col" id="topbox">
					<div class="row setBtnForm">
						<p class="headerP" style="color: white; font-size: 14px;">
							<span class="asdf">${openResume.rsmRlsscopeCdNm}</span>&nbsp;&nbsp;<span
								style="font-size: 12px; font-weight:500;">
							<c:choose>
								<c:when test="${openResume.rsmMdfcnYmd==null }">
								${openResume.rsmWrtYmd.substring(0,19)}에 작성
								</c:when>
								<c:otherwise>
								${openResume.rsmMdfcnYmd.substring(0,19)}에 수정
								</c:otherwise>
							</c:choose>
							</span>
						</p>
					<div>
							<ul class="downMenu">
								<li><a class="menulist pdfDownAlink" data-rsm-no="${openResume.rsmNo}" href="#">pdf로 저장</a></li>
								<li><a data-rsm-no="${openResume.rsmNo}" class="menulist resumeReadBtn" href="#">이력서 보기</a></li>
								<li><a class="menulist delRsumeBtn" data-rsm-no="${openResume.rsmNo }" href="#">삭제</a></li>
							</ul>
							<img src="/resources/icon/more_vert.png" class="vertImg">
						</div>
					</div>
					<div class="row" style="margin-top: 10px;">
						<p style="color: white; font-size: 24px; font-weight: bold;">${openResume.rsmTtl}</p>
					</div>
					<br>
					<div class="row">
						<div class="topboxContent row" style="margin-right: 100px;">
							<img src="/resources/icon/work_white.png">
							<p class="headerP" style="color: white; font-weight: bold;">
								&nbsp;&nbsp;<span class="asdf">직무 능력 :
									${openResume.rsmCareerCdNm}</span>
							</p>
						</div>
						<div class="topboxContent row">
							<img src="/resources/icon/heartPlus_white.png">
							<p class="headerP" style="color: white; font-weight: bold;">
								&nbsp;&nbsp;<span class="asdf">희망 직무·직업 :
									${openResume.rsmCrdtCdNm}</span>
							</p>
						</div>
					</div>
					<div class="row" style="margin-top: 20px;">
						<div class="topboxContent row" style="margin-right: 100px;">
							<img style="color: white;" src="/resources/icon/pig_white.png">
							<p class="headerP" style="color: white; font-weight: bold;">
								&nbsp;&nbsp;<span class="asdf">희망 연봉 :
									${openResume.rsmSalCdNm}</span>
							</p>
						</div>
					</div>
					<div class="row setBtnForm" style="margin-top: 20px;">
						<div class="row">
							<div class="aBtn">
								<a href="/member/memPro">받은 제안 현황</a><span id="total">${propototal }</span>
							</div>
							<div class="aBtn">
								<a href="/member/aplctList">입사 지원 내역</a><span id="total">${apltotal }</span>
							</div>
							<div class="aBtn">
								<a href="/member/scrap" style="padding-right: 20px;">내 공고 활동 보러가기
									&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i
									class="fas fa-angle-right"></i>
								</a>
							</div>
						</div>
						<div class="row" style="margin-bottom: 20px;">
							<button type="button" class="editBtn edit" data-rsm-no="${openResume.rsmNo}">수정</button>
							<button type="button" class="editBtn copy" data-rsm-no="${openResume.rsmNo}">복사</button>
						</div>
					</div>
			</div>
		</c:if>
		<br>


		<div class="card-body table-responsive p-0">
			<div class="row setBtnForm"
				style="margin: 0; align-items: center; margin-bottom: 23px;">
				<p style="color: #0000008a; font-size: 18px;">전체 <span id="totl">${total}</span></p>
				<div id="filter">
					<form id="filterForm" action="/member/resume" method="GET" >
					<select id="apstSel" name="state">
						<option value="" <c:if test="${param.state==''}">selected</c:if> selected>정렬선택</option>
							<option value="new"
							 <c:if test="${param.state=='new'}">selected</c:if>>최신순</option>
							<option value="old"
							 <c:if test="${param.state=='old'}">selected</c:if>>오래된순</option>
					</select>
					<div style="position: relative; top: 1px;">
						<input type="text" id="keywordInput" name="keywordInput"
							placeholder="제목으로 이력서를 검색해 보세요." value="${param.keywordInput}">
						<button class="search" type="submit">검색</button>
						<span class="material-symbols-outlined" id="sricon">search</span>
					</div>
					</form>
				</div>
				<button type="button" class="submitBtn" id="registBtn">이력서
					작성</button>
			</div>

			<hr>
			         <table class="table table-hover text-nowrap">
            <thead>
            <c:choose>
            <c:when test="${not empty articlePage.content}">
               <c:forEach var="resumeVO" items="${resumeVOList}" varStatus="stut">
                  <div id="conbox" class="col">
                     <div class="row setBtnForm" style="margin-top: 10px;">
                        <div>
                           <p style="color: #292e41;width: 560px; font-size: 22px; font-weight: bold;">${resumeVO.rsmTtl }</p>
                        </div>
                        <div>
                        <select class="selRereReume" data-rsm-no="${resumeVO.rsmNo}"
                           style="color: #232323; border: none;">
                           <option value="" selected="selected" disabled="disabled">대표 이력서 선택</option>
                           <c:forEach var="codeVO" items="${codeVOList}"
                              varStatus="stut2">
                              <option value="${codeVO.comCode}"
                                 <c:if test="${codeVO.comCode==resumeVO.rsmRlsscopeCd}">selected</c:if>>${codeVO.comCodeNm }</option>
                           </c:forEach>
                        </select>
                        </div>
                           <ul class="downMenu">
                              <li><a class="menulist pdfDownAlink" data-rsm-no="${resumeVO.rsmNo}" href="#">pdf로 저장</a></li>
                              <li><a data-rsm-no="${resumeVO.rsmNo}" class="menulist resumeReadBtn" href="#">이력서 보기</a></li>
                              <li><a class="menulist delRsumeBtn" data-rsm-no="${resumeVO.rsmNo}" href="#">삭제</a></li>
                           </ul>
                        <img src="/resources/icon/more_vert_1.png" class="vertImg" />
                     </div>
                     <div class="row" style="margin-top: 10px;">
                        <div class="topboxContent row" style="margin-right: 100px;">
                           <img src="/resources/icon/work.png" />
                           <p style="font-weight: bold;">&nbsp;&nbsp;직무 경험 :
                              ${resumeVO.rsmCareerCdNm }</p>
                        </div>
                        <div class="topboxContent row">
                           <img src="/resources/icon/heartPlus.png" />
                           <p style="font-weight: bold;">&nbsp;&nbsp;희망 직무·직업 :
                              ${resumeVO.rsmCrdtCdNm }</p>
                        </div>
                     </div>
                     <div class="row" style="margin-top: 10px;">
                        <div class="topboxContent row" style="margin-right: 100px;">
                           <img src="/resources/icon/pig.png" />
                           <p style="font-weight: bold;">&nbsp;&nbsp;희망 연봉 :
                              ${resumeVO.rsmSalCdNm }</p>
                        </div>
                     </div>
                     <div class="row setBtnForm" style="margin-top: 20px;">
                        <div class="row">
                           <div class="aBtn" style="align-items: center; margin-top: 38px;">
                              <a href="/member/aplctList">입사 지원 내역&nbsp;&nbsp;<span
                                 style="color: #24D59E;">${resumeVO.rsmCnt }건 <img
                                    src="/resources/icon/꺽쇠.png" style="width: 19px;" /></span></a>
                           </div>
                        </div>
                        <div class="row">
                           <div>
                              <p class="headerP" style="color: #575757; font-size: 14px; ">
                                 <c:choose>
                                    <c:when test="${resumeVO.rsmMdfcnYmd==null }">
                                    ${resumeVO.rsmWrtYmd.substring(0,19)}에 작성
                                    </c:when>
                                    <c:otherwise>
                                    ${resumeVO.rsmMdfcnYmd.substring(0,19)}에 수정
                                    </c:otherwise>
                                 </c:choose>
                              </p>
                              <div class="row">
                              <button type="button" class="submitBtn conBtn edit"
                                 style="margin-right: 20px;" data-rsm-no="${resumeVO.rsmNo}">수정</button>
                              <button type="button" class="submitBtn conBtn copy" data-rsm-no="${resumeVO.rsmNo}">복사</button>
                              </div>
                           </div>
                        </div>
                     </div>
                     <div class="memo">
                        <p class="memoP"
                           style="font-weight: 500; background-color: rgba(44, 207, 195, 0.11); align-items: center; color: #575757; border-radius: 3px;">
                           <img src="/resources/icon/note_alt.png"
                              style="width: 25px; margin: 5px 15px 5px 15px;">
                              <c:choose>
                                    <c:when test="${resumeVO.rsmMemo.length() > 140}">
                                 ${resumeVO.rsmMemo.substring(0,140)}...
                                    </c:when>
                                    <c:otherwise>
                                 ${resumeVO.rsmMemo}
                                    </c:otherwise>
                               </c:choose>
                        </p>
                     </div>
                  </div>
                  <hr />
               </c:forEach>
               </c:when>
               <c:otherwise>
                  <tr>
                     <td id="noSrc"colspan="4">검색 결과가 없습니다.</td>
                  </tr>
               </c:otherwise>
            </c:choose>
            </thead>
            <c:if test="${not empty articlePage.content}">
            <tfoot>
               <tr>
                  <td colspan="4" style="text-align: center;">
                     <div class="dataTables_paginate" id="example2_paginate"
                        style="display: flex; justify-content: center; margin-top: 20px;">
                        <br />
                        <ul class="pagination">
                           <!-- 맨 처음 페이지로 이동 버튼 -->
                           <c:if test="${articlePage.currentPage gt 1}">
                              <li class="paginate_button page-item first"><a
                                 href="/member/resume?currentPage=1&keywordInput=${param.keywordInput}&state=${param.state}"
                                 aria-controls="example2" data-dt-idx="0" tabindex="0"
                                 class="page-link">&lt;&lt;</a></li>
                           </c:if>

                           <!-- 이전 페이지 버튼 -->
                           <c:if test="${articlePage.startPage gt 1}">
                              <li class="paginate_button page-item previous"
                                 id="example2_previous"><a
                                 href="/member/resume?currentPage=${(articlePage.startPage - 1) lt 1 ? 1 : (articlePage.startPage - 1)}&keywordInput=${param.keywordInput}&state=${param.state}"
                                 aria-controls="example2" data-dt-idx="0" tabindex="0"
                                 class="page-link">&lt;</a></li>
                           </c:if>

                           <!-- 페이지 번호 -->
                           <c:forEach var="pNo" begin="${articlePage.startPage}"
                              end="${articlePage.endPage}">
                              <li
                                 class="paginate_button page-item ${pNo == articlePage.currentPage ? 'active' : ''}">
                                 <a href="/member/resume?currentPage=${pNo}&keywordInput=${param.keywordInput}&state=${param.state}"
                                 aria-controls="example2" class="page-link">${pNo}</a>
                              </li>
                           </c:forEach>

                           <!-- 다음 페이지 버튼 -->
                           <c:if test="${articlePage.endPage lt articlePage.totalPages}">
                              <li class="paginate_button page-item next" id="example2_next">
                                 <a
                                 href="/member/resume?currentPage=${articlePage.startPage+5}&keywordInput=${param.keywordInput}&state=${param.state}"
                                 aria-controls="example2" data-dt-idx="7" tabindex="0"
                                 class="page-link">&gt;</a>
                              </li>
                           </c:if>

                           <!-- 맨 마지막 페이지로 이동 버튼 -->
                           <c:if
                              test="${articlePage.currentPage lt articlePage.totalPages}">
                              <li class="paginate_button page-item last"><a
                                 href="/member/resume?currentPage=${articlePage.totalPages}&keywordInput=${param.keywordInput}&state=${param.state}"
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

