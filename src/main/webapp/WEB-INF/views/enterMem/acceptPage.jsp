<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/security/tags"
	prefix="sec"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<sec:authorize access="isAuthenticated()">
	<sec:authentication property="principal.memVO" var="priVO" />
</sec:authorize>
<link rel="stylesheet"
	href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200" />
<link rel="stylesheet"
	href="<%=request.getContextPath()%>/resources/css/member/scrap.css" />
<script
	src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script type="text/javascript" src="/resources/js/jquery.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@10"></script> 
<link rel="stylesheet" href="<%=request.getContextPath()%>/resources/css/alert.css" />
<script>
	//sweetAlert 창 띄우기 변수
	var Toast = Swal.mixin({
		toast : true,
		position : 'center',
		showConfirmButton : false,
		timer : 3000
	});
// 	//비밀번호 체크
// 	$(function() {
// 		$("#detailChkBtn").on(
// 				"click",
// 				function(e) {
// 					let formData = new FormData();
// 					let mbrId = "${param.mbrId}";
// 					let mbrPswd = $("#mbrPswd").val();
// 					console.log("mbrId : " + mbrId);
// 					console.log("mbrPswd : " + mbrPswd);
// 					formData.append("mbrId", mbrId);
// 					formData.append("mbrPswd", mbrPswd);
// 					$.ajax({
// 						url : "/member/detailChk",
// 						processData : false,
// 						contentType : false,
// 						data : formData,
// 						type : "post",
// 						dataType : "text",
// 						beforeSend : function(xhr) {
// 							xhr.setRequestHeader("${_csrf.headerName}",
// 									"${_csrf.token}");
// 						},
// 						success : function(result) {
// 							console.log("result : " + result);
// 							// success, error, warning, info, question
// 							if (result == "false") {
// 								Toast.fire({
// 									icon : 'error',
// 									title : '비밀번호 불일치!'
// 								});
// 								return;
// 							}
// 							Toast.fire({
// 								icon : 'success',
// 								title : '비밀번호 일치!'
// 							});

// 							$("#chkchk").css("display", "none");
// 							$(".container").attr("hidden", false);
// 						}
// 					})
// 				});
// 	});
$(function(){
// 	$("#submitbtn").on('click',function(){
// 		event.preventDefault();
// 		$("#acceptForm").attr("action","/enterMem/acceptSuccess")
// 	 	$('#acceptForm').submit();
// 	})
// 	$("#delbtn").on('click',function(){
// 		event.preventDefault();
// 		$("#acceptForm").attr("action","/enterMem/acceptDel")
		
// 	 	$('#acceptForm').submit();
// 	})
	
	
	$(document).on("click", "#submitbtn", function(event) {
		event.preventDefault(); // 기본 폼 전송 방지
		$("#acceptForm").attr("action","/enterMem/acceptSuccess");

		// Swal.fire 사용하여 수정 확인창 표시
		Swal.fire({
		    title: '수락하시겠습니까?',
		    icon: 'question',
		    showCancelButton: true,
		    confirmButtonColor: 'white',
		    cancelButtonColor: 'white',
		    confirmButtonText: '예',
		    cancelButtonText: '아니오'
		}).then((result) => {
		    if (result.isConfirmed) {
		        // 수정 확인 시 폼 전송
		        $("#acceptForm").submit();
		        Toast.fire({
		            icon: 'success',
		            title: '수락 완료!'
		        });
		    } else {
		        // 수정 취소 시
		        Toast.fire({
		            icon: 'error',
		            title: '수락 취소!'
		        });
		    }
		});
		});
	
	$(document).on("click", "#delbtn", function(event) {
		event.preventDefault(); // 기본 폼 전송 방지
		$("#acceptForm").attr("action","/enterMem/acceptSuccess");

		// Swal.fire 사용하여 수정 확인창 표시
		Swal.fire({
		    title: '거절하시겠습니까?',
		    icon: 'error',
		    showCancelButton: true,
		    confirmButtonColor: 'white',
		    cancelButtonColor: 'white',
		    confirmButtonText: '예',
		    cancelButtonText: '아니오'
		}).then((result) => {
		    if (result.isConfirmed) {
		        // 수정 확인 시 폼 전송
		        $("#acceptForm").submit();
		        Toast.fire({
		            icon: 'success',
		            title: '거절 완료!'
		        });
		    } else {
		        // 수정 취소 시
		        Toast.fire({
		            icon: 'error',
		            title: '거절 취소!'
		        });
		    }
		});
		});
	
	
	
	
})


</script>

<br>
<!-- <div id="chkchk"> -->
<!-- 	<div> -->
<!-- 		<div> -->
<!-- 			<img class="chkImg" src="../resources/images/logo.png" /> -->
<!-- 			<p id="pwalert"> -->
<!-- 				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;본인 확인을 위해 비밀번호 인증을 <br> -->
<!-- 				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; -->
<!-- 				진행해 주시기 바랍니다.</p> -->
<!-- 		</div> -->
<!-- 		<div> -->
<!-- 			<input type="password" placeholder="비밀번호를 입력해주세요" id="mbrPswd" -->
<!-- 				name="mbrPswd" /> -->
<!-- 		</div> -->
<!-- 		<div> -->
<!-- 			<button type="button" class="chkbtn" id="detailChkBtn">확인</button> -->
<!-- 		</div> -->
<%-- 		<sec:csrfInput /> --%>
<!-- 	</div> -->
<!-- </div> -->
<div class="container" >
	<img class="chkImg" src="../resources/images/logo.png" />
	<div id="contentBox">
	<div id="topDiv">
 		<p>ReadyGo 기업 멤버 초대</p> 
	</div>
		<div id="content">
		<form id="acceptForm" action="" method="post">
			<p>기업명 : <span id="entNm">대덕건설</span></p>
			<p>해당 기업에서 보내온 인사 담당 멤버 초대를 수락하시겠습니까?</p>
			<div id="btnDiv">
				<input type="hidden" name="entNm"value="${param.entNm}">
				<input type="hidden" name="mbrId"value="${param.mbrId}">
				<button type="button" id="submitbtn" data-cl-strg-no="${VO.clStrgNo}" 
					class="acceptBtn">수락</button>
				<button type="button" id="delbtn" data-cl-strg-no="${VO.clStrgNo}"
					class="refuseBtn">거절</button>
			</div>
			<sec:csrfInput />
		</form>
		</div>
	</div>
</div>

<style>
#btnDiv{
	margin-top : 30px;
	display : flex;
	justify-content: center;
	align-items: center;
}
#content{
padding-top : 32px;
	text-align : center;
	
}
#entNm {
	color : #24D59E;
	font-size: 30px;
    font-weight: bold;
}
#topDiv{
	padding-top :  22px;
	color : white;
	font-size : 20px;
	font-weight : 600;
	text-align : center;
	width : 500px;
	height : 74px;
	background: linear-gradient(to right, #2CCFC3, #24D59E);
	border-radius: 10px;
}
#contentBox{
	margin-left: 120px;
 	box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1); /* 그림자 추가 */
	width : 500px;
	height : 300px;
	border-radius: 10px;
}
.refuseBtn{
	background: white;
    color: #232323;
    border: 1px solid #B5B5B5;
    transition: all 0.3s ease 0s;
    padding: 7px 40px 7px 40px;
    border-radius: 5px;
}

.refuseBtn:hover {
	background: #ECECEC;
	border: 1px solid #B5B5B5;
}

.acceptBtn {
	background: white;
	color: #24D59E;
	border: 1px solid #24D59E;
	transition: all 0.3s ease 0s;
	padding: 7px 40px 7px 40px;
	border-radius: 5px;
	margin-right : 10px;
}
.acceptBtn:hover {
	background-color: #24D59E;
	color: white;
}
.chkImg {
	margin-left: 180px;
	width: 380px;
	height: 140px;
}

#pwalert {
	margin-left: 240px;
	margin-bottom: 50px;
}

#mbrPswd, .chkbtn {
	border-left: 2px solid white;
	border-right: 2px solid white;
	border-top: 2px solid #24D59E;
	border-bottom: 2px solid white;
	border-radius: 5px;
	height: 50px;
	width: 300px;
	text-align: center;
	box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
	margin-left: 220px;
}

#chkchk {
	margin: 10% 0 0 30%;
}

.container {
	margin: 5% 0 0 30%;
}

.swal2-styled:focus {
outline: 0 !important;
box-shadow: 0 0 0 0px !important;
}

</style>