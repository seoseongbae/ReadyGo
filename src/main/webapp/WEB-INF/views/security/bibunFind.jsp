<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<script type="text/javascript" src="/resources/js/jquery.min.js"></script>
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script type="text/javascript" src="/resources/js/sweetalert2.js"></script>
<style>
.container-fluid{
	padding-right: 0;
    padding-left: 0;
}
.main{
	background-image: url("/resources/images/secucrity/login.png");
	display: flex;
	flex-direction: row;
	justify-content: center;
	height: auto;
	min-height: 1000px;
}
.frame{
	display: flex;
	flex-direction: column;
	padding-top: 100px;
}
.findForm{
	border: solid 1px #efefef;
    box-shadow: 0px 12px 10px -3px rgba(0, 0, 0, .05), 11px 9px 10px -1px rgba(0, 0, 0, .05);
	padding: 45px 38px 35px 38px;
	background-color: #ffffff;
	width: 480px;
	height: auto;
	border-radius: 25px;
}
.topContent{
	display: flex;
	flex-direction: row;
	justify-content: space-between;
	text-align: left;
	margin-bottom: 30px;
} 
.middleContent{
	display: flex;
	flex-direction: column;
	text-align: left;
} 
.gray{
	color : #475067;
	-webkit-transition: all 0.3s ease 0s;
	-webkit-text-size-adjust: 100%;
    -webkit-tap-highlight-color: transparent;
    transition: all 0.3s ease 0s;
}
.black{
	color : #151822;
	-webkit-transition: all 0.3s ease 0s;
	-webkit-text-size-adjust: 100%;
    -webkit-tap-highlight-color: transparent;
    transition: all 0.3s ease 0s;
}
.green{
	color : #24D59E;
	-webkit-transition: all 0.3s ease 0s;
	-webkit-text-size-adjust: 100%;
    -webkit-tap-highlight-color: transparent;
    transition: all 0.3s ease 0s;
}
.font-15{
	font-size: 15px;
}
.font-32{
	font-size: 32px;
}
.font-700{
	font-weight: 700;
}
.font-400{
	font-weight: 400;
}
.font-300{
	font-weight: 300;
}
.margin-bottom-1{
	margin-bottom: 20px;
}
.margin-bottom-2{
	margin-bottom: 40px;
}
.margin-top-1{
	margin-top: 35px;
}
.margin-top-2{
	margin-top: 10px;
}
.green:hover {
	color : #151822;
}
.width-1{
 	width: 260px; 
}
.width-2{
 	width: 130px; 
}
.po{
	position: relative;
}
.row{
	margin: 0;
	justify-content: space-between;
}
.btn{
	background-color: #24D59E;
    color: #ffffff;
    box-shadow: 0 14px 28px rgba(0, 0, 0, 0.05), 0 10px 10px rgba(0, 0, 0, 0.05);
    transition: all 0.3s ease 0s;
    height: 50px;
    border-radius: 8px;
}
.btn:hover{
	border: solid 1px #24D59E;
    background-color: #ffffff;
    color: #24D59E;
}
btn:active{
	none;
}
#authCount{
	position: relative;
	top: 21px;
    left: 196px;
    width: 60px;
}
#sendAuthNumBtnNo {
	background: white;
    color: #232323;
    border: 1px solid #B5B5B5;
    transition: all 0.3s ease 0s;
    padding: 7px 40px 7px 40px;
    margin-right: 10px;
    border-radius: 5px;
}
</style>
<script type="text/javascript">
var Toast = Swal.mixin({
	toast: true,
    position: 'center',
    showConfirmButton: false,
    timer: 3000
});

let saveNum;
let countTime = 0;
let intervalCall;
let memcon = "";
let chkNum = "";

$(function(){
	$.time = function(time){
	    countTime = time;
	    intervalCall = setInterval(alertFunc, 1000);
	}
	
	$.closeTime = function(){
	    clearInterval(intervalCall);
	}
	
	function alertFunc() {
	    let min = Math.floor(countTime/60);
	    let sec = countTime - (60 * min);
	    if(sec > 9){
	        $('#authCount').text(min + ':' + sec + '');
	    }else {
	        $('#authCount').text(min + ':0' + sec + '');
	    }
	    if(countTime <= 0){
	        clearInterval(intervalCall);
	        $("#sendAuthNumBtn").prop("disabled", false);
            $("#sendAuthNumBtn").css({
                "opacity": "1",
                "cursor": "pointer"
            });
	    }
	    countTime--;
	};
	
	$("#sendAuthNumBtn").on("click", function(){
		function validatePhoneNumber(phoneNumber) {
		    // 11자리 숫자만 허용하는 정규식
		    const phoneNumberPattern = /^\d{11}$/;
		    return phoneNumberPattern.test(phoneNumber);
		}

		if ($('#phoneNum').val().trim() === "") {
		    Toast.fire({
		        icon: 'warning',
		        title: '휴대폰 번호를 입력해 주세요.(-를 제외한 11자의 숫자)'
		    });
		    $('#phoneNum').focus();
		    event.preventDefault();
		    return false;
		} else if (!validatePhoneNumber($('#phoneNum').val().trim())) {
		    Toast.fire({
		        icon: 'warning',
		        title: '유효하지 않은 휴대폰 번호입니다. 11자리 숫자만 입력해 주세요.'
		    });
		    $('#phoneNum').focus();
		    event.preventDefault();
		    return false;
		}
		$("#authNumForm").attr("hidden", false);
		$("#authCount").attr("hidden", false);
		$.time(179);
		let formData = new FormData();
		let memto = $("#phoneNum").val();
		let memsend = "010-3067-4663";
// 		let memsend = "";
		chkNum = ""
		memcon = "인증번호는 [";
		for (let i = 0; i < 6; i++) {
			chkNum += Math.floor(Math.random() * 10);
		}
		console.log(chkNum);
		memcon += chkNum;
		memcon += "] 입니다.";
		
		
		formData.append("memto",memto);
		formData.append("memsend",memsend);
		formData.append("memcon",memcon);
		$.ajax({
	        url : "/api/sendOne",
	        processData:false,
	        contentType:false,
	        data:formData,
	        type:"post",
	        dataType:"text",
	        beforeSend:function(xhr){
	            xhr.setRequestHeader("${_csrf.headerName}","${_csrf.token}");
	            // 버튼 비활성화
	            $("#sendAuthNumBtn").prop("disabled", true);
	        },
	        success : function(result) {
	            console.log("result : " + result);
	            Toast.fire({
	                icon:'success',
	                title:'인증번호가 전송 되었습니다.'
	            });
	            
	            // 선택적: 비활성화된 버튼의 스타일 변경
	            $("#sendAuthNumBtn").css({
	                "opacity": "0.5",
	                "cursor": "pointer"
	            });
	            
	        }
	    })
	})
	
	$("#authChkBtn").on("click", function(){
		if ($('#authCount').text().trim() === "0:00") {
			Toast.fire({
				icon:'question',
				title:'인증 시간이 만료 되었습니다.'
			});
	        $('#mbrTelno').focus();
	        event.preventDefault();
	        return false;
	    }
		if ($('#authNum').val().trim() !== chkNum) {
			Toast.fire({
				icon:'warning',
				title:'인증번호 불일치.'
			});
	        $('#mbrTelno').focus();
	        event.preventDefault();
	        return false;
	    }
		Toast.fire({
			icon:'success',
			title:'인증성공.'
		});
		$.closeTime();
		$("#authCount").css("color", "green");
		$("#authCount").text("인증성공");
		
	})
	
	$("#bibunChangeBtn").on("click", function(){
		if ($('#authCount').text().trim() !== "인증성공") {
	    	Toast.fire({
				icon:'warning',
				title:'휴대폰인증을 해주세요.'
			});
	        $('#authCount').focus();
	        event.preventDefault();
	        return false;
	    }
		
		let userId = $("#userId").val();
		let userName = $("#userName").val();
		let phoneNum = $("#phoneNum").val();
		
		let formData = new FormData();
		
		formData.append("userId",userId);
		formData.append("userName",userName);
		formData.append("phoneNum",phoneNum);
		
		$.ajax({
			url : "/security/bibunFindPostAjax",
			processData:false,
			contentType:false,
			enctype: 'multipart/form-data',
			data:formData,
			type:"post",
			dataType:"text",
			beforeSend:function(xhr){
				xhr.setRequestHeader("${_csrf.headerName}","${_csrf.token}");
			},
			success : function(result) {
				let code = "";
				if(!result.trim()){
					code += `<p class="message" style="font-size: 18px; color: #666; line-height: 30px; margin-top: 40px;font-weight: 700;">등록된 회원 정보가 없습니다. 회원가입을 하시겠습니까?</p><br/>
						<a class="green " href="/security/memSignin">일반 회원가입</a> <br />
						<a class="green " href="/security/entSignin">기업 회원가입</a> `;
					$("#session3").html(code);
					$("#session1").attr("hidden", true);
					$("#session3").attr("hidden", false);
				}else{
					$("#asdf").text("비밀번호 재설정");
					$("#session1").attr("hidden", true);
					$("#session2").attr("hidden", false);
				}
			}
		})
	})
	$("#bibunChangeBtn2").on("click", function(){
// 		 // 비밀번호 유효성 검사 함수
// 	    function validatePassword(mbrPswd) {
// 	        // 8~16자의 영문 대/소문자, 숫자, 특수문자를 포함하는 정규식
// 	        const passwordPattern = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*])[A-Za-z\d!@#$%^&*]{8,16}$/;
// 	        return passwordPattern.test(mbrPswd);
// 	    }
	
// 	    if ($('#password').val().trim() === "") {
// 	        Toast.fire({
// 	            icon: 'warning',
// 	            title: '비밀번호를 입력해 주세요. (8~16자의 영문 대/소문자, 숫자, 특수문자 포함)'
// 	        });
// 	        $('#password').focus();
// 	        event.preventDefault();
// 	        return false;
// 	    } else if (!validatePassword($('#password').val().trim())) {
// 	        Toast.fire({
// 	            icon: 'warning',
// 	            title: '유효하지 않은 비밀번호입니다. 8~16자의 영문 대/소문자, 숫자, 특수문자를 포함해 주세요.'
// 	        });
// 	        $('#password').focus();
// 	        event.preventDefault();
// 	        return false;
// 	    }
	
// 	    if($("#passwordChk").val().trim() === "" || $("#password").val().trim() !== $("#passwordChk").val().trim()){
// 	    	Toast.fire({
// 				icon:'warning',
// 				title:'비밀번호와 비밀번호 확인이 다릅니다. 다시 확인하세요.'
// 			});
// 	        $('#passwordChk').focus();
// 	        event.preventDefault(); // 폼 제출을 막음
// 	        return false;   // 서버로 전송을 하지 않는다.
// 	    }
	    let userId = $("#userId").val();
	    let password = $("#password").val();
		
		let formData = new FormData();
		
		formData.append("userId",userId);
		formData.append("password",password);
		$.ajax({
			url : "/security/bibunChangePostAjax",
			processData:false,
			contentType:false,
			enctype: 'multipart/form-data',
			data:formData,
			type:"post",
			dataType:"text",
			beforeSend:function(xhr){
				xhr.setRequestHeader("${_csrf.headerName}","${_csrf.token}");
			},
			success : function(result) {
				if(result < 1){
					Toast.fire({
	                    icon: 'error',
	                    title: '재설정 실패'
	                });
					return;					
				}
                Toast.fire({
                    icon: 'success',
                    title: '비밀번호가 재설정 되었습니다.'
                });
             // 3초 후에 이동
				setTimeout(function(){
					location.href="/security/login";
				},2000)
				
			},error: function(xhr, status, error) {
                Toast.fire({
                    icon: 'error',
                    title: '재설정 실패'
                });
            }
		})
		
	})
})
</script>
<div class="main">
	<div class=frame>
		<div class="findForm">
			<div class="topContent">
				<div class="gray font-15 font-400">
					<p class="margin-bottom-1">Welcome to ReadyGo</p>
					<h2 class="black font-32 font-700" id="asdf">비밀번호 찾기</h2>
				</div>
				<div class="black font-15 font-400">
					<p class="black font-15 font-400">비밀번호가 기억나셨나요?<br />
					<a class="green " href="/security/login">로그인</a> <br />
					<a class="green " href="/security/idFind">아이디 찾기</a></p>
				</div>
			</div>
			<div class="black font-15 middleContent" id="session1">
				<div class="form-group mb-2 id">
					<label for="userId" class="margin-top-2">아이디</label>
					<input type="text" class="form-control" 
						placeholder="아이디를 입력하세요." 
						name="userId" id="userId" required />
				</div>
				<div class="form-group mb-2 id">
					<label for="userName" class="margin-top-2">이름</label>
					<input type="text" class="form-control" 
						placeholder="이름을 입력하세요." 
						name="userName" id="userName" required />
				</div>
					<label class="po margin-top-2" for="phoneNum">전화번호</label>
				<div class="form-group mb-2 id row">
					<input type="text" class="form-control width-1" 
						placeholder="전화번호를 입력하세요." 
						name="phoneNum" id="phoneNum" required />
					<button class="form-control width-2 btn" type="button" id="sendAuthNumBtn" >인증번호 전송</button>
				</div>
				<span id="authCount" hidden="hidden" style="color : #f67f8a;'">03:00</span>
				<div class="form-group row margin-bottom-2" id="authNumForm" style="margin-top: -17px;" hidden="hidden">
					<input type="text" class="form-control width-1" 
						placeholder="인증번호를 입력하세요." 
						name="authNum" id="authNum" required />
					<button class="form-control width-2 btn" type="button" id="authChkBtn">확인</button>
				</div>
				<div class="form-group mb-2 margin-top-1">
					<button class="form-control btn" type="button" id="bibunChangeBtn">비밀번호 재설정</button>
				</div>
			</div>
			<div class="black font-15 middleContent" id="session2" hidden="hidden">
				<div class="form-group mb-2 id">
					<label for="password" class="margin-top-2">비밀번호 입력</label>
					<input type="text" class="form-control" 
						placeholder="비밀번호를 입력하세요." 
						name="password" id="password" required />
				</div>
				<div class="form-group mb-2 id">
					<label for="passwordChk" class="margin-top-2">비밀번호 확인</label>
					<input type="text" class="form-control" 
						placeholder="비밀번호 확인." 
						name="passwordChk" id="passwordChk" required />
				</div>
				<div class="form-group mb-2 margin-top-1">
					<button class="form-control btn" type="button" id="bibunChangeBtn2">확인</button>
				</div>
			</div>
			<div class="black font-15 middleContent" id="session3" hidden="hidden">
			</div>
		</div>
	</div>
</div>