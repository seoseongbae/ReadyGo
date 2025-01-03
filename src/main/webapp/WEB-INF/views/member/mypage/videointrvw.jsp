<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec"%>   
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>   

<link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200" />
<link rel="stylesheet" href="<%=request.getContextPath() %>/resources/css/member/aplctList.css" />
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script> 
<script type="text/javascript" src="/resources/js/jquery.min.js"></script>
<script src="/resources/js/sweetalert2.js"></script>
<script>
var Toast = Swal.mixin({
	toast: true,
    position: 'center',
    showConfirmButton: false,
    timer: 3000
});
$(function(){
	$(".intrvwSttusCd").each(function() {
	    let aplctPrcsNm = $(this).text().trim(); 
	    console.log(aplctPrcsNm)
	    if (aplctPrcsNm === '면접진행전') {
	      $(this).css({
	        'color': '#666363',
	        'background-color': 'rgb(244 244 244)',
	        'display': 'inline-block',
	      });
	    } 
	    else if(aplctPrcsNm === '면접진행중'){
		  $(this).css({
	        'color': '#24D59E',
	        'background-color': '#e8faf8;',
		  });
	    }
	    else if(aplctPrcsNm === '면접완료'){
		  $(this).css({
		     'color': 'rgb(255 112 112)',
			 'background-color': 'rgb(255 150 150 / 29%)',
		  });
	    }
	  });
	
// 	$(".pbanc-ttl").on("click", function(){
// 		let pnancNo = $(this).data("pbancno");
// 		location.href = '/enter/pbancDetail?pbancNo=' + pnancNo; 
// 	})
	
	$(".videoGOGO").on("click", function(){
		let value = $(this).data("roomid");
		let pass = $(this).data("vcrPasswd");
		console.log(pass);
		entId = "123";
		var obj = {value : value,entId:entId};
		var jsonObj = JSON.stringify(obj);
		Swal.fire({
			  title: '회상면접에 입장 하시겠습니까? \n비밀번호 : '+pass,
			  icon: 'question',
			  showCancelButton: true,
			  confirmButtonColor: 'white',
			  cancelButtonColor: 'white',
			  confirmButtonText: '예',
			  cancelButtonText: '아니오',
			  reverseButtons: false, // 버튼 순서 거꾸로
			}).then((result) => {
			  if (result.isConfirmed) {
		          $.ajax({
					url : "/video/connectroom",
					type : "POST",
					data : jsonObj,
					contentType : "application/json;charset=UTF-8",
					dataType : "json",
					beforeSend:function(xhr){
						xhr.setRequestHeader("${_csrf.headerName}","${_csrf.token}");
					},
					success : function(res) {
						console.log(res)
						window.open(res.data.url);
					}
				})
			  }
			})
	})
})
</script>
<style>
.intrvwSttusCd{
	padding: 4px 10px;
	border-radius: 100px;
}
#filter{
	display: flex;
    FLEX-DIRECTION: row;
    justify-content: flex-end;
    align-items: center;
    margin-right: -32px;
    width: 1323px;
    margin-bottom: 10px;
    position: unset;
}
#apstSel {
    top: 41px;
    right: 145px;
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
    background: #24D59E;
    color: #ffffff;
    border: 1px solid #24D59E;
    transition: all 0.3s ease 0s;
    padding: 7px 40px 7px 40px;
    border-radius: 5px;
}
td.entNm {
    text-align: left;
    padding-left: 126px;
    font-size: 14px;
    font-weight: 550;
}
td{
	height: 75px;
}
.videoNONO{
	background: #ECECEC;
    color: #232323;
    border: 1px solid #B5B5B5;
    transition: all 0.3s ease 0s;
    padding: 7px 0;
    border-radius: 5px;
    width: 110px;
}
</style>
<div class="container"  style="position: relative; bottom: 35px;">
	<p id="h3">화상 면접</p>
	<br><br>
	<p id="count">전체&nbsp;&nbsp;<span id="total">${articlePage.total}</span></p><br>
	<div class="row" id="topbox">
		<div class="box" id="fir">면접대기<p class="num">${InstTotal1}</p></div>
		<div class="box" id="ing">면접중<p class="num2">${InstTotal2}</p></div>
		<div class="box" id="bad">면접 완료<p class="num4">${InstTotal3}</p></div>
	</div>
	<div id="filter">
		<form id="filterForm" action="/member/video" method="GET" >
		<select id="apstSel" name="state">
			<option value="" <c:if test="${param.state==''}">selected</c:if> selected>전체(면접상태)</option>
			<c:forEach var="codeVO" items="${codeList}">
				<option value="${codeVO.comCode}"
				 <c:if test="${param.state==codeVO.comCode}">selected</c:if>>${codeVO.comCodeNm}</option>
			</c:forEach>
		</select>
		<div style="position: relative; top: 1px;">
			<input type="text" id="keywordInput" name="keywordInput"
				placeholder="검색" value="${param.keywordInput}">
			<button class="search" type="submit">검색</button>
			<span class="material-symbols-outlined" id="sricon">search</span>
		</div>
		</form>
	</div>
	<div class="card-body table-responsive p-0">
				<table class="table table-hover text-nowrap">
				<thead>
					<tr>
						<th style="font-size:16px;">기업명</th>
						<th class="aplct" style="font-size:16px;">공고</th>
						<th class="entNm" style="font-size:16px;">면접일정</th>
						<th class="entNm" style="font-size:16px;">면접상태</th>
						<th></th>
					</tr>
				</thead>
				<tbody style="color:#232323; font-size:15px; font-weight: 500 ">
				<c:choose>
				<c:when test="${not empty articlePage.content}">
				<c:forEach var="interViewVO" items="${articlePage.content}" varStatus="stat">
					<tr style="border-bottom: 1px solid #dee2e6;">
						<td style="padding-left: 20px;">${interViewVO.entNm}</td>
						<td class="aplct">
						<span class="pbanc-ttl" data-pbancno="${interViewVO.pbancNo}">
						<a target="_blank" href="/enter/pbancDetail?pbancNo=${interViewVO.pbancNo}">
						<c:choose>
							<c:when test="${interViewVO.pbancTtl.length() > 35}">
								${interViewVO.pbancTtl.substring(0,32)}...
							</c:when>
							<c:otherwise>
								${interViewVO.pbancTtl}
							</c:otherwise>
						</c:choose>
						</a></span><br>
						</td>
						<td class="entNm" style="padding-left: 86px;">
							<p>  
								<c:if test="${interViewVO.intrvwStartDate==null}">
									<c:if test="${interViewVO.intrvwEndDate==null}">
									면접 일정이 등록되지 않았습니다.
									</c:if>
								</c:if>
								<c:if test="${interViewVO.intrvwStartDate!=null}">
									시작 : ${interViewVO.intrvwStartDate} <br />
								</c:if>
								<c:if test="${interViewVO.intrvwEndDate!=null}">
									마감 : ${interViewVO.intrvwEndDate}
								</c:if>
							</p>
						</td>
						<td class="entNm">
							<span id="intrvwSttusCd" class="intrvwSttusCd">${interViewVO.intrvwSttusCdNm}</span>
						</td>
						<td>
							<c:choose>
								<c:when test="${interViewVO.intrvwSttusCdNm == '면접진행중' }">
									<button class="submitBtn videoGOGO" data-vcr-passwd ="${interViewVO.vcrPasswd}" data-roomId="${interViewVO.vcrRoomid }" style="width: 110px; padding: 7px 0;">입장</button>
								</c:when>
								<c:otherwise>
									<button class="videoNONO" style="width: 110px">입장불가</button>
								</c:otherwise>
							</c:choose>
						</td>
					</tr>
					</c:forEach>
					</c:when>
				<c:otherwise>
					<tr>	
						<td id="noSrc"colspan="5">검색 결과가 없습니다.</td>
					</tr>
				</c:otherwise>
			</c:choose>
				</tbody>
				<c:if test="${not empty articlePage.content}">
				<tfoot>
					<tr>
						<td colspan="5" style="text-align: center; border-top: 1px solid #232323">
							<div class="dataTables_paginate" id="example2_paginate"
								style="display: flex; justify-content: center; margin-top:20px;">
								<ul class="pagination">
													<br>
								<!-- 맨 처음 페이지로 이동 버튼 -->
								<c:if test="${articlePage.currentPage gt 1}">
								    <li class="paginate_button page-item first">
								        <a href="/member/video?mbrId=${param.mbrId}&currentPage=1&keywordInput=${param.keywordInput}&state=${param.state}&dateInput1=${param.dateInput1}&dateInput2=${param.dateInput2}"
								           aria-controls="example2" data-dt-idx="0" tabindex="0" class="page-link">&lt;&lt;</a>
								    </li>
								</c:if>

									<!-- 이전 페이지 버튼 -->
									<c:if test="${articlePage.startPage gt 1}">
									    <li class="paginate_button page-item previous" id="example2_previous">
									         <a href="/member/video?mbrId=${param.mbrId}&currentPage=${(articlePage.startPage - 1) lt 1 ? 1 : (articlePage.startPage - 1)}&currentPage=1&keywordInput=${param.keywordInput}&state=${param.state}&dateInput1=${param.dateInput1}&dateInput2=${param.dateInput2}"
									           aria-controls="example2" data-dt-idx="0" tabindex="0" class="page-link">&lt;</a>
									    </li>
									</c:if>
									
									<!-- 페이지 번호 -->
									<c:forEach var="pNo" begin="${articlePage.startPage}" end="${articlePage.endPage}">
									    <li class="paginate_button page-item ${pNo == articlePage.currentPage ? 'active' : ''}">
									        <a href="/member/video?mbrId=${param.mbrId}&currentPage=${pNo}&currentPage=1&keywordInput=${param.keywordInput}&state=${param.state}&dateInput1=${param.dateInput1}&dateInput2=${param.dateInput2}" 
									        aria-controls="example2" class="page-link">${pNo}</a>
									    </li>
									</c:forEach>
									
									<!-- 다음 페이지 버튼 -->
									<c:if test="${articlePage.endPage lt articlePage.totalPages}">
									    <li class="paginate_button page-item next" id="example2_next">
									        <a href="/member/video?mbrId=${param.mbrId}&currentPage=${articlePage.startPage+5}&currentPage=1&keywordInput=${param.keywordInput}&state=${param.state}&dateInput1=${param.dateInput1}&dateInput2=${param.dateInput2}"
									           aria-controls="example2" data-dt-idx="7" tabindex="0" class="page-link">&gt;</a>
									    </li>
									</c:if>
									
									<!-- 맨 마지막 페이지로 이동 버튼 -->
								<c:if test="${articlePage.currentPage lt articlePage.totalPages}">
								    <li class="paginate_button page-item last">
								        <a href="/member/video?mbrId=${param.mbrId}&currentPage=${articlePage.totalPages}&currentPage=1&keywordInput=${param.keywordInput}&state=${param.state}&dateInput1=${param.dateInput1}&dateInput2=${param.dateInput2}"
								           aria-controls="example2" data-dt-idx="7" tabindex="0" class="page-link">&gt;&gt;</a>
								    </li>
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

