<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="sec"
	uri="http://www.springframework.org/security/tags"%>
<sec:authorize access="isAuthenticated()">
	<sec:authentication property="principal.memVO" var="priVO" />
</sec:authorize>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>기업 프로필</title>
<!-- 기업프로필 CSS 링크 -->
<link rel="stylesheet"
	href="<%=request.getContextPath()%>/resources/css/enter/profile.css" />
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@10"></script>

<link rel="stylesheet"
	href="<%=request.getContextPath()%>/resources/css/alert.css" />
<!-- chart.js -->
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script type="text/javascript" src="/resources/js/jquery.min.js"></script>
</head>
<body>
	<sec:authentication property="principal" var="prc" />
	<c:if test="${prc ne 'anonymousUser'}">
		<input type="hidden" id="hasRoleEnter" value="${prc.authorities}" />
	</c:if>
	<div class="title">
		<img src="${enterVO.entLogo}" alt="${enterVO.entLogo}" id="pImg"
			class="img" style="background-color: #ffffff" />
		<div id="titleGroup1">
			<h3>
				<strong>${enterVO.entNm}</strong>
			</h3>
			<p id="titleTpbizSeCd">${enterVO.tpbizSeCd}</p>
		</div>
		<input type="button" class="titleHpBtn" value="기업 홈페이지"
			onclick="window.open('${enterVO.entHmpgUrl}')" />
	</div>


	<div id="img2" style="display: block; top: 0px; left: 0px;">
		<img alt="" src="../resources/images/enter/enter.jpg"
			class="headerImg">
	</div>

	<div id="div1">
		<div id="div1-1">
			<h4>| 기업정보</h4>
		</div>
		<div id="div1-2">
			<div id="div1-2-1">
				<table>
					<tr>
						<th>업종</th>
						<td>${enterVO.tpbizSeCd}</td>
					</tr>
					<tr>
						<th>주소</th>
						<td>${enterVO.entAddr}</td>
					</tr>
					<tr>
						<th>사원수</th>
						<td>${enterVO.entEmpCnt}명</td>
					</tr>
					<tr>
						<th>기업형태</th>
						<td>${enterVO.entStleCd}</td>
					</tr>
				</table>
			</div>
			<div id="div1-2-2">
				<table>
					<tr>
						<th>설립일자</th>
						<td>${enterVO.entFndnYmd}</td>
					</tr>
					<tr>
						<th>대표자명</th>
						<td>${enterVO.entRprsntvNm}</td>
					</tr>
					<tr>
						<th>팩스번호</th>
						<td>${enterVO.entFxnum}</td>
					</tr>
					<tr>
						<th>홈페이지</th>
						<td><a href="${enterVO.entHmpgUrl}" target="_blank">${enterVO.entHmpgUrl}</a></td>
					</tr>
				</table>
			</div>
		</div>
	</div>

	<div id="div2">
		<div id="div2-1">
			<h4>| 재무정보</h4>
			<div style="display: flex;">
				<c:if test="${prc  ne 'anonymousUser'}">
					<c:if test="${prc.authorities eq '[ROLE_ENTER]'}">
						<button class="revenueBtn" onclick="openRevenueModal()">매출액
							관리</button>
						<button class="ycntBtn" onclick="openYcntModal()">입ㆍ퇴사자수
							관리</button>
					</c:if>
				</c:if>
			</div>
			<!-- 매출액 관리 모달 -->
			<div id="revenueModal" class="modal" style="display: none;">
				<div class="modal-content">
					<!-- 모달 제목 -->
					<h2 class="modal-title">매출액 관리</h2>
					<span class="close" onclick="closeRevenueModal()">&times;</span>

					<h4 class="modal-subtitle">작년부터 5년 전까지 총 6년의 매출액을 등록/수정할 수
						있습니다.</h4>
					<h3 class="modal-waring"></h3>
					<!-- 매출액 등록/수정 버튼 (초기 상태) -->
					<div id="modalButtons">
						<button id="registerButton" class="btn-primary"
							onclick="openRevenueForm()">등록</button>
						<button id="editButton" class="btn-primary"
							onclick="editRevenueForm()">수정</button>
					</div>

					<!-- 매출액 입력 폼 (숨겨진 상태) -->
					<form id="revenueForm1" style="display: none;">
						<table class="modal-table">
							<thead>
								<tr>
									<th class="center">매출년도</th>
									<th class="center">매출액</th>
								</tr>
							</thead>
							<tbody class="tbResult">

							</tbody>
						</table>
						<div class="modal-buttons">
							<button type="button" id="modalcan1" class="btn-secondary"
								onclick="closeRevenueForm()">취소</button>
							<button type="button" id="modalok1" class="btn-primary">확인</button>
						</div>
					</form>
					<!-- 매출액 입력 폼 (숨겨진 상태) -->
					<form id="revenueForm2" style="display: none;">
						<table class="modal-table">
							<thead>
								<tr>
									<th class="center">매출년도</th>
									<th class="center">매출액</th>
								</tr>
							</thead>
							<tbody>
								<c:forEach var="revenueVO" items="${revenueList}">
									<tr>
										<td class="center"><input type="hidden"
											value="${revenueVO.revenueNo}">
											${revenueVO.revenueYear}</td>
										<td><input type="number"
											value="${revenueVO.revenueAmount}" class="input-revenue2"
											data-year="${revenueVO.revenueYear}"
											data-no="${revenueVO.revenueNo}" placeholder="매출액 입력" /></td>
									</tr>
								</c:forEach>
							</tbody>
						</table>
						<div class="modal-buttons">
							<button type="button" id="modalcan2" class="btn-secondary"
								onclick="closeRevenueForm()">취소</button>
							<button type="button" id="modalok2" class="btn-primary">확인</button>
						</div>
						<sec:csrfInput />
					</form>
				</div>
			</div>

			<!-- 연도별입사자수 관리 모달 -->
			<div id="ycntModal" class="modal" style="display: none;">
				<div class="modal-content">
					<!-- 모달 제목 -->
					<h2 class="modal-title">연도별 입ㆍ퇴사자수 관리</h2>
					<!-- 닫기 버튼 -->
					<span class="close" onclick="closeYcntModal()">&times;</span>

					<h4 class="modal-subtitle">최근 12개월간 입ㆍ퇴사자수를 등록/수정할 수 있습니다.</h4>
					<h3 class="modal-waringy"></h3>
					<!-- 연도별입사자수 등록/수정 버튼 (초기 상태) -->
					<div id="ycntModalButtons">
						<button id="ycntRegisterButton" class="btn-primary"
							onclick="openYcntForm()">등록</button>
						<button id="ycntEditButton" class="btn-primary"
							onclick="editYcntForm()">수정</button>
					</div>

					<!-- 연도별입사자수 입력 폼 등록 (숨겨진 상태) -->
					<form id="ycntForm1" style="display: none;">
						<div class="scroll-div" style="overflow-y: scroll; height: 500px;">
						<table class="modal-table">
							<thead>
								<tr>
									<th class="center">입사년도/월</th>
									<th class="center">전체인원</th>
									<th class="center">입사자</th>
									<th class="center">퇴사자</th>
								</tr>
							</thead>
							<tbody class="tbResultYcnt">

							</tbody>
						</table>
						</div>
						<div class="modal-buttons">
							<button type="button" id="ycntModalCan" class="btn-secondary"
								onclick="closeYcntForm()">취소</button>
							<button type="button" id="ycntModalOk1" class="btn-primary">확인</button>
						</div>
					</form>

					<!-- 연도별입사자수 입력 폼 수정 (숨겨진 상태) -->
					<form id="ycntForm2" style="display: none;">
						<div class="scroll-div" style="overflow-y: scroll; height: 500px;">
							<table class="modal-table">
								<thead>
									<tr>
										<th class="center">입사년도/월</th>
										<th class="center">전체인원</th>
										<th class="center">입사자</th>
										<th class="center">퇴사자</th>
									</tr>
								</thead>
								<tbody>
									<c:forEach var="empYcntVO" items="${empYcntList}">
										<tr class="input-Ycnt2">
											<td class="center" id="ycntYm">${empYcntVO.entYm}</td>
											<td><input type="hidden" id="YcntNo"
												value="${empYcntVO.entEmpYcntNo}"><input
												type="number" class="input-ycnt" id="ycntTotal"
												value="${empYcntVO.entEmpYcnt}" placeholder="전체인원" /></td>
											<td><input type="number" class="input-ycnt" id="ycntNew"
												value="${empYcntVO.entNewemp}" placeholder="입사자" /></td>
											<td><input type="number" class="input-ycnt" id="ycntOut"
												value="${empYcntVO.entOutemp}" placeholder="퇴사자" /></td>
										</tr>
									</c:forEach>
								</tbody>
							</table>
						</div>
						<div class="modal-buttons">
							<button type="button" id="ycntModalCan" class="btn-secondary"
								onclick="closeYcntForm()">취소</button>
							<button type="button" id="ycntModalOk2" class="btn-primary">확인</button>
						</div>
					</form>

				</div>
			</div>

		</div>
		<div class="chartFlex">
			<div id="div2-2">
				<p class="font">매출액</p>
				<div style="width: 100%; margin-top: 20px;">
					<canvas id="canvas"></canvas>
				</div>
			</div>
			<div id="div2-3">
				<div id="btnParent">
					<p class="font">연도별 입사자수</p>
					<button class="chartbtn" onclick="fChgType()">타입 변경</button>
				</div>
				<!-- 차트 크기는 부모 크기를 조절하면 거기에 맞게 자동으로 생성됨 -->
				<div
					style="width: auto; height: auto; border: 2px solid none; background: white; border-radius: 9px;">
					<!-- 차트 그릴 위치 지정 -->
					<canvas id="myChart"></canvas>
				</div>
			</div>
		</div>
		<!-- 채용 공고 섹션 -->
		<c:choose>
			<c:when test="${not empty PbancVOList}">
				<div id="div4">
					<div id="atag">
						<h4>| 현재 채용 중인 공고</h4>
						<c:if test="${prc  ne 'anonymousUser'}">
							<c:if test="${prc.authorities eq '[ROLE_ENTER]'}">
								<a id="atag1" href="/enter/pbanc?entId=${enterVO.entId}">더보기
									></a>
							</c:if>
						</c:if>
						<c:if test="${prc  ne 'anonymousUser'}">
							<c:if test="${prc.authorities eq '[ROLE_MEMBER]'}">
								<a id="atag1"
									href="/common/pbancList?selCity=&selJob=&selKeyword=${enterVO.entNm}">더보기
									></a>
							</c:if>
						</c:if>
					</div>
						<div id="div4-1">
							<c:forEach var="pbanc" items="${PbancVOList}">
							<a href="/enter/pbancDetail?pbancNo=${pbanc.pbancNo}">
								<div class="entPbanc">
									<p class="font" id="pbanc">${pbanc.pbancTtl}</p>
									<p id="onePbanc">${pbanc.pbancRprsrgnNm}|
										${pbanc.rcritCareerNm} | ${pbanc.pbancWorkstleNm}</p>
									<p class="onePbanc1">시작일: ${pbanc.pbancBgngDts}</p>
									<p class="onePbanc1">마감일: ${pbanc.pbancDdlnDts}</p>
								</div>
							</a>
							</c:forEach>
						</div>
				</div>
			</c:when>
			<c:otherwise>
				<div id="div4">
					<p>
						<strong>현재 채용 중인 공고가 없습니다.</strong>
					</p>
				</div>
			</c:otherwise>
		</c:choose>

		<!-- 차트 스크립트 -->
		<script>
var Toast = Swal.mixin({
	toast: true,
	position: 'center',
	showConfirmButton: false,
	timer: 3000
	});


// 차트 타입 변경 함수
let isToggle = false;
function fChgType() {
    if (isToggle) {
        mChart.data.datasets[0].type = "bar";
        mChart.data.datasets[1].type = "line";
        mChart.data.datasets[2].type = "line";
    } else {
        mChart.data.datasets[0].type = "line";
        mChart.data.datasets[1].type = "bar";
        mChart.data.datasets[2].type = "bar";
    }
    mChart.update();
    isToggle = !isToggle;
}

const ctx = document.querySelector('#myChart');

const mChart = new Chart(ctx, {
    type: 'bar',
    data: {
        labels: ${entYmList},
        datasets: [
            {
                label: '전체인원',
                data: ${entEmpYcntList},
                borderWidth: 1,
            },
            {
                label: '입사자',
                data: ${entNewEmpList},
                borderWidth: 1,
            },
            {
                label: '퇴사자',
                data: ${entOutEmpList},
                borderWidth: 1
            }
        ]
    },
    options: {
        scales: {
            y: {
                beginAtZero: true
            }
        }
    }
});

new Chart(document.getElementById("canvas"), {
    type: 'line',
    data: {
        labels: ${revenueYearList},
        datasets: [{
            label: '매출액',
            data: ${revenueAmountList},
            borderColor: "rgba(255, 201, 14, 1)",
            backgroundColor: "rgba(255, 201, 14, 0.5)",
            fill: true,
            lineTension: 0
        }]
    },
    options: {
        responsive: true,
        scales: {
            x: {
                display: true,
                scaleLabel: {
                    display: true,
                    labelString: '연도'
                }
            },
            y: {
                display: true,
                beginAtZero: true,
                scaleLabel: {
                    display: true,
                    labelString: '매출액'
                }
            }
        }
    }
});

/*매출액 관리 모달창*/
//모달 창 열기 함수
function openRevenueModal() {
    document.getElementById('revenueModal').style.display = 'block';
    document.body.style.overflow = 'hidden';  // 배경 스크롤을 막음
    
    
    // 두 버튼을 항상 보이게 설정
    document.getElementById('registerButton').style.display = 'inline';
    document.getElementById('editButton').style.display = 'inline';

    
}

// 모달 창 닫기 함수
function closeRevenueModal() {
    document.getElementById('revenueForm1').style.display = 'none';
    document.getElementById('revenueForm2').style.display = 'none';
    document.getElementById('modalButtons').style.display = 'block'; // 등록/수정 버튼 다시 보이기
    document.getElementById('revenueModal').style.display = 'none';
    document.body.style.overflow = 'auto';  // 배경 스크롤을 다시 활성화
}


// 매출액 입력 폼 열기 (등록 버튼 클릭 시)
function openRevenueForm() {
    document.getElementById('revenueForm1').style.display = 'block';
    document.getElementById('modalButtons').style.display = 'none'; // 등록/수정 버튼 숨기기
}

// 매출액 수정 폼 열기 (수정 버튼 클릭 시)
function editRevenueForm() {
    document.getElementById('revenueForm2').style.display = 'block';
    document.getElementById('modalButtons').style.display = 'none'; // 등록/수정 버튼 숨기기
}

// 매출액 폼 닫기
function closeRevenueForm() {
    document.getElementById('revenueForm1').style.display = 'none';
    document.getElementById('revenueForm2').style.display = 'none';
    document.getElementById('modalButtons').style.display = 'block'; // 등록/수정 버튼 다시 보이기
}   


/*연도별입사자수 모달*/
//연도별입사자수 모달 열기
function openYcntModal() {
    document.getElementById('ycntModal').style.display = 'block'; // 모달 열기
    document.body.style.overflow = 'hidden'; // 배경 스크롤 막기
}

//연도별입사자수 모달 닫기 함수
function closeYcntModal() {
    document.getElementById('ycntForm1').style.display = 'none'; // 입력 폼 숨기기
    document.getElementById('ycntForm2').style.display = 'none'; // 입력 폼 숨기기
    document.getElementById('ycntModalButtons').style.display = 'block'; // 등록/수정 버튼 다시 보이기
    document.getElementById('ycntModal').style.display = 'none'; // 모달 닫기
    document.body.style.overflow = 'auto'; // 배경 스크롤 다시 활성화
}

//연도별입사자수 입력 폼 열기 (등록 버튼 클릭 시)
function openYcntForm() {
    document.getElementById('ycntForm1').style.display = 'block'; // 입력 폼 보이기
    document.getElementById('ycntModalButtons').style.display = 'none'; // 등록/수정 버튼 숨기기
}
//연도별입사자수 입력 폼 열기 (수정 버튼 클릭 시)
function editYcntForm() {
    document.getElementById('ycntForm2').style.display = 'block'; // 입력 폼 보이기
    document.getElementById('ycntModalButtons').style.display = 'none'; // 등록/수정 버튼 숨기기
}

//연도별입사자수 폼 닫기
function closeYcntForm() {
    document.getElementById('ycntForm1').style.display = 'none'; // 입력 폼 숨기기
    document.getElementById('ycntForm2').style.display = 'none'; // 입력 폼 숨기기
    document.getElementById('ycntModalButtons').style.display = 'block'; // 등록/수정 버튼 다시 보이기
}

$(function(){
	// 현재 연도를 가져와서 1을 뺌
    var currentYear = new Date().getFullYear() - 1;
    // 해당 값을 HTML 요소에 삽입
    $('#lastYear').text(currentYear);
    var list =[];
    <c:forEach var="revenue" items="${revenueList}">
		list.push("${revenue.revenueYear}");
	</c:forEach>
	console.log(list);
	let code="";
	let count=0;
	console.log(list.indexOf('2018'));
    for(let i=currentYear-5;i<=currentYear;i++){
    		console.log(i.toString());
    		if(list.indexOf(i.toString())>=0){
    			console.log("???");
    			continue;
    		}
    		else{
    			code+="<tr><td class='center'  id='lastYear'>"+i+"</td>";
    			code+="<td><input type='number' class='input-revenue' data-year="+i+" id='revenue' placeholder='매출액 입력' /></td></tr>"
    		}
    	
    }
    console.log(code);
   	if(code ===""){
   		$("#registerButton").prop('disabled',true);
   		$(".modal-waring").text("*이미 년도 별 등록이 완료되어 수정만 가능합니다.")
   	}
    $(".tbResult").html(code);
    //-------------------------------------------------------------------
    
 	// 현재 날짜 가져오기
    let currentDate = new Date();

 	// 연도와 월을 "YYYY.MM" 형식으로 가져오는 함수
    function formatDate(date) {
        let year = date.getFullYear();
        let month = (date.getMonth() + 1).toString().padStart(2, '0');
        return year + '.' + month;
    }

    // 현재 연도와 월
    let formattedDate = formatDate(currentDate);
    console.log("현재 날짜:", formattedDate);  // "2024.10"
	
    var listYcnt =[];
    <c:forEach var="empYcnt" items="${empYcntList}">
    	listYcnt.push("${empYcnt.entYm}");
	</c:forEach>
	console.log(listYcnt);
    
    let codeycnt="";
    // 비교할 12개월 목록을 생성 (현재 월부터 12개월 전까지)
    for (let i = 0; i < 12; i++) {
        // i개월씩 감소한 날짜 생성
        let previousDate = new Date(currentDate.getFullYear(), currentDate.getMonth()-1 - i);
        let previousFormattedDate = formatDate(previousDate);
        
        console.log("비교 날짜:", previousFormattedDate);
        
        // 여기서 원하는 비교 작업 수행
        // 예시: listYcnt 배열과 비교
        if (listYcnt.indexOf(previousFormattedDate) >= 0) {
            console.log(previousFormattedDate + " 값이 존재합니다.");
        } else {
            console.log(previousFormattedDate + " 값이 존재하지 않습니다.");
            // 존재하지 않으면 코드 추가
            codeycnt+="<tr class='input-Ycnt'>"
            codeycnt+="<td class='center' id='ycntYm'>"+previousFormattedDate+"</td>";
            codeycnt+="<td><input type='number' class='input-ycnt' id='ycntTotal' placeholder='전체인원' /></td>";
           	codeycnt+="<td><input type='number' class='input-ycnt' id='ycntNew'  placeholder='입사자' /></td>";
           	codeycnt+="<td><input type='number' class='input-ycnt' id='ycntOut' placeholder='퇴사자' /></td></tr>";
    	
            
        }
    }
    console.log(codeycnt);
   	if(codeycnt ===""){
   		$("#ycntRegisterButton").prop('disabled',true);
   		$(".modal-waringy").text("*이미 년도 별 등록이 완료되어 수정만 가능합니다.")
   	}
    // 생성된 코드를 DOM에 추가
    $(".tbResultYcnt").html(codeycnt);
    
    
    
    
    
    $("#modalok1").on('click',function(){
    	const revenues = [];
    	// 모든 input-revenue 클래스를 가진 요소들의 값을 리스트로 수집하여 배열에 저장
        $(".input-revenue").each(function() {
        	const year = $(this).data("year");
            const value = $(this).val();
            revenues.push({ entId:'${param.entId}',revenueYear: parseInt(year), revenueAmount: parseFloat(value) });
        });
    	console.log(revenues);
    	
    	
    	Swal.fire({
    		  title: '등록하시겠습니까?',
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
    		            url: '/enter/insertRevenues',
    		            method: 'POST',
    		            contentType: 'application/json',
    		            data: JSON.stringify(revenues),  // 데이터를 JSON 형식으로 전송
    		            beforeSend:function(xhr){
    						xhr.setRequestHeader("${_csrf.headerName}","${_csrf.token}");
    					},
    		            success: function(response) {
    		            	Toast.fire({
    		    				icon:'success',
    		    				title:'등록 성공',
    		    				customClass: {
    						        popup: 'my-custom-popup'  // CSS에서 정의한 클래스 이름
    						    } 
    		    			}).then((result) => {
    		    				location.reload();
    				    	});
    		              
    		            },
    		            error: function(error) {
    		            	Toast.fire({
    				            icon: 'error',
    				            title: '등록 실패!',
    				            customClass: {
    						        popup: 'my-custom-popup'  // CSS에서 정의한 클래스 이름
    						    } 
    				        });
    		            }
    		          });
    		  } else {
  		        // 수정 취소 시
  		        Toast.fire({
  		            icon: 'error',
  		            title: '등록 취소!',
  		            customClass: {
  				        popup: 'my-custom-popup'  // CSS에서 정의한 클래스 이름
  				    } 
  		        });
  		    }
    		})
    	
    	
    	
        
    })
    $("#modalok2").on('click',function(){
    	const revenues = [];
    	// 모든 input-revenue 클래스를 가진 요소들의 값을 리스트로 수집하여 배열에 저장
        $(".input-revenue2").each(function() {
        	const year = $(this).data("year");
            const value = $(this).val();
            const no = $(this).data('no');
            revenues.push({ revenueNo:parseInt(no),entId:'${param.entId}',revenueYear: parseInt(year), revenueAmount: parseFloat(value) });
        });
    	console.log(revenues);
    	
    	Swal.fire({
    		  title: '수정하시겠습니까?',
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
    		            url: '/enter/updateRevenues',
    		            method: 'POST',
    		            contentType: 'application/json',
    		            data: JSON.stringify(revenues),  // 데이터를 JSON 형식으로 전송
    		            beforeSend:function(xhr){
    						xhr.setRequestHeader("${_csrf.headerName}","${_csrf.token}");
    					},
    		            success: function(response) {
    		            	Toast.fire({
    		    				icon:'success',
    		    				title:'수정 성공',
    		    				customClass: {
    						        popup: 'my-custom-popup'  // CSS에서 정의한 클래스 이름
    						    } 
    		    			}).then((result) => {
    		    				location.reload();
    				    	});
    		            },
    		            error: function(error) {
    		            	Toast.fire({
    				            icon: 'error',
    				            title: '수정 실패!',
    				            customClass: {
    						        popup: 'my-custom-popup'  // CSS에서 정의한 클래스 이름
    						    } 
    				        });
    		            }
    		          });
    	          
    		  } else {
    		        // 수정 취소 시
    		        Toast.fire({
    		            icon: 'error',
    		            title: '수정 취소!',
    		            customClass: {
    				        popup: 'my-custom-popup'  // CSS에서 정의한 클래스 이름
    				    } 
    		        });
    		    }
    		})
    	
    	
        
    })
    
    $("#ycntModalOk1").on('click',function(){
    	const revenues = [];
    	// 모든 input-revenue 클래스를 가진 요소들의 값을 리스트로 수집하여 배열에 저장
        $(".input-Ycnt").each(function() {
        	 const ycntTotal = $(this).find("#ycntTotal").val();
             const ycntNew = $(this).find("#ycntNew").val();
             const ycntOut = $(this).find("#ycntOut").val();
             const ycntNm = $(this).find("#ycntYm").text();
            revenues.push({ entEmpYcnt:ycntTotal,entId:'${param.entId}',entNewemp: ycntNew, 
            			entOutemp: ycntOut,entYm:ycntNm });
        });
    	console.log(revenues);
    	
    	
    	Swal.fire({
  		  title: '등록하시겠습니까?',
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
  	            url: '/enter/insertYcnt',
  	            method: 'POST',
  	            contentType: 'application/json',
  	            data: JSON.stringify(revenues),  // 데이터를 JSON 형식으로 전송
  	            beforeSend:function(xhr){
  					xhr.setRequestHeader("${_csrf.headerName}","${_csrf.token}");
  				},
  	            success: function(response) {
  	            	Toast.fire({
		    				icon:'success',
		    				title:'등록 성공',
		    				customClass: {
						        popup: 'my-custom-popup'  // CSS에서 정의한 클래스 이름
						    } 
		    			}).then((result) => {
		    				location.reload();
				    	});
  	            },
  	            error: function(error) {
  	            	Toast.fire({
				            icon: 'error',
				            title: '등록 실패!',
				            customClass: {
						        popup: 'my-custom-popup'  // CSS에서 정의한 클래스 이름
						    } 
				        });
  	            }
  	          });
  		  } else {
		        // 수정 취소 시
		        Toast.fire({
		            icon: 'error',
		            title: '등록 취소!',
		            customClass: {
				        popup: 'my-custom-popup'  // CSS에서 정의한 클래스 이름
				    } 
		        });
		    }
  		})
    	
    })
    
    $("#ycntModalOk2").on('click',function(){
    	const revenues = [];
    	// 모든 input-revenue 클래스를 가진 요소들의 값을 리스트로 수집하여 배열에 저장
        $(".input-Ycnt2").each(function() {
        	 const ycntTotal = $(this).find("#ycntTotal").val();
             const ycntNew = $(this).find("#ycntNew").val();
             const ycntOut = $(this).find("#ycntOut").val();
             const ycntNo = $(this).find('#YcntNo').val();
             const ycntNm = $(this).find("#ycntYm").text();
            revenues.push({ entEmpYcnt:ycntTotal,entId:'${param.entId}',entNewemp: ycntNew, 
            			entOutemp: ycntOut,entEmpYcntNo:ycntNo,entYm:ycntNm });
        });
    	console.log(revenues);
    	
    	
    	Swal.fire({
  		  title: '수정하시겠습니까?',
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
  	            url: '/enter/updateYcnt',
  	            method: 'POST',
  	            contentType: 'application/json',
  	            data: JSON.stringify(revenues),  // 데이터를 JSON 형식으로 전송
  	            beforeSend:function(xhr){
  					xhr.setRequestHeader("${_csrf.headerName}","${_csrf.token}");
  				},
  	            success: function(response) {
  	            	Toast.fire({
		    				icon:'success',
		    				title:'수정 성공',
		    				customClass: {
						        popup: 'my-custom-popup'  // CSS에서 정의한 클래스 이름
						    } 
		    			}).then((result) => {
		    				location.reload();
				    	});
  	            },
  	            error: function(error) {
  	            	Toast.fire({
				            icon: 'error',
				            title: '수정 실패!',
				            customClass: {
						        popup: 'my-custom-popup'  // CSS에서 정의한 클래스 이름
						    } 
				        });
  	            }
  	          }); 
  		  } else {
		        // 수정 취소 시
		        Toast.fire({
		            icon: 'error',
		            title: '수정 취소!',
		            customClass: {
				        popup: 'my-custom-popup'  // CSS에서 정의한 클래스 이름
				    } 
		        });
		    }
  		})
    	
    })
})
</script>
</body>
</html>
