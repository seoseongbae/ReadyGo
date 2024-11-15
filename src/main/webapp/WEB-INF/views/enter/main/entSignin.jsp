<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<script type="text/javascript" src="/resources/js/jquery.min.js"></script>
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script type="text/javascript" src="/resources/js/sweetalert2.js"></script>
<link rel="stylesheet" href="/resources/css/security/loginForm.css">

<style type="text/css">
.main{
	background-image: url("/resources/images/secucrity/기업 로그인.png");
}
.main .signFrom{
	border : solid 1px gray;

}
.idForm{
	justify-content: space-between;
	align-items: flex-end;
	max-width: 400px;
	margin-left: 0px;
}
.id{
	width: 260px;
}
.idForm .btn-sign{
margin-bottom: 4px;
}
.card{
	height: auto;
}
#authCount{
	color:#FF808C;
	position: absolute;
	right: 200px;
    bottom: 332px;
}
#brtxt{
	display: block;
    width: 100%;
    height: calc(3rem + 2px);
    padding: .75rem .75rem;
    font-size: 1rem;
    font-weight: 400;
    line-height: 1.5;
    color: #495057;
    background-color: #fff;
    background-clip: padding-box;
    border: 1px solid #ced4da;
    border-radius: .4rem;
    box-shadow: inset 0 0 0 transparent;
}
#pImg{
	width: 100px; 
	border:1px solid #D7D7D7;
}
.container-fluid{
	padding:0;
}
.content{
	padding:0;
}
.contentr{
    position: relative !important;
    top: -25px !important;
    margin-left: 0px !important;
    width: 1920px !important;
    height: 700px !important;
    background: white !important;
    min-height: 700px !important;

}
	</style>
<script type="text/javascript">
function execDaumPostcode() {
    new daum.Postcode({
        oncomplete: function(data) {
            var fullAddr = data.address;
            var extraAddr = '';

            if (data.addressType === 'R') { 
                if (data.bname !== '') {
                    extraAddr += data.bname;
                }
                if (data.buildingName !== '') {
                    extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
                }
                fullAddr += (extraAddr !== '' ? ' (' + extraAddr + ')' : '');
            }

            $('#entZip').val(data.zonecode);
            $('#entAddr').val(fullAddr);
            $('#entAddrDtl').focus();
        }
    }).open();
}
let saveNum;
let countTime = 0;
let intervalCall;
let memcon = "";
let chkNum = "";
var Toast = Swal.mixin({
	toast: true,
    position: 'center',
    showConfirmButton: false,
    timer: 3000
});
function handleImg(e){
	// 	e.target : <input type="file" class="custom-file-input" id="uploadFile" ... /> 
	let files = e.target.files; // 선택한 파일들
	// 파일들을 잘라서 배열로 만든다
	// fileArr = [토낑.gif,굿.gif,라쿤.gif]
	let fileArr = Array.prototype.slice.call(files);
	// f : 토낑.gif 객체
	let accumStr = ""; 
	fileArr.forEach(function(f){
		// 이미지가 아니면
		if(!f.type.match("image.*")){
			alert("이미지 확장자만 가능합니다");
			return; // 함수 자체가 종료됨
		}
		// 이미지가 맞다면 => 파일을 읽어주는 객체 생성
		let reader = new FileReader();
		// 파일을 읽자
		// e : reader가 이미지 객체를 읽는 이벤트
		reader.onload = function(e){// "+e.target+result+" - 이미지를 다 읽었으면 결과를 가져와라 -> 그것을 누적
			accumStr += "<img src='"+e.target.result+"'/>";  // 누적 String
			$("#pImg").html(accumStr);
		}
		reader.readAsDataURL(f);
		
	});
	// 요소.append : 누적, 요소.html : 새로고침, 요소.innerHTML : J/S에서 새로고침
}
$(function(){
	$("#imgBtn").on("click",function(){
		$("#entLogoFile").click()
		$("#imgForm").attr("hidden", false);
	})
	// 파일 선택 후 이미지 미리보기
    $("#entLogoFile").on("change", function(e) {
        let file = e.target.files[0];
        if(!file){
        	return;
        }
        
        if (!file.type.match("image.*")) {
            alert("이미지 파일만 업로드 가능합니다.");
            return;
        }

        let reader = new FileReader();
        reader.onload = function(e) {
            $("#pImg").attr("src", e.target.result);
        }
        reader.readAsDataURL(file);
    });
	$("#brBtn").on("click",function(){
		$("#entBrFileFile").click()
		$("#brFileForm").attr("hidden", false);
	})
	$("#entBrFileFile").on("change", function(e) {
		let str = $("#entBrFileFile").val();
        if(!str){
        	return;
        }
        
        $("#brtxt").text(str);
    });
	
	$("#authChk").on("click", function(){
		if ($('#authCount').text().trim() === "0:00") {
			Toast.fire({
				icon:'question',
				title:'인증 시간이 만료 되었습니다.'
			});
	        $('#authNum').focus();
	        event.preventDefault();
	        return false;
	    }
		if ($('#authNum').val().trim() !== chkNum) {
			Toast.fire({
				icon:'warning',
				title:'인증번호 불일치.'
			}); 
	        $('#authNum').focus();
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
	        $('.certificationTime').text(min + ':' + sec + '');
	    }else {
	        $('.certificationTime').text(min + ':0' + sec + '');
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

		if ($('#entManagerTelno').val().trim() === "") {
		    Toast.fire({
		        icon: 'warning',
		        title: '휴대폰 번호를 입력해 주세요.(-를 제외한 11자의 숫자)'
		    });
		    $('#entManagerTelno').focus();
		    event.preventDefault();
		    return false;
		} else if (!validatePhoneNumber($('#entManagerTelno').val().trim())) {
		    Toast.fire({
		        icon: 'warning',
		        title: '유효하지 않은 휴대폰 번호입니다. 11자리 숫자만 입력해 주세요.'
		    });
		    $('#entManagerTelno').focus();
		    event.preventDefault();
		    return false;
		}
		$("#authNumForm").attr("hidden", false);
		$("#authCount").attr("hidden", false);
		$.time(179);
		let formData = new FormData();
		let memto = $("#entManagerTelno").val();
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
	
	$("#idchk").on("click", function(){
		let entId = $("#entId").val();
		// 아이디 유효성 검사 함수
		function validateUsername(entId) {
		    // 5~20자의 영문 소문자, 숫자, 특수기호 _와 -만 허용하는 정규식
		    const usernamePattern = /^[a-z0-9_-]{5,20}$/;
		    return usernamePattern.test(entId);
		}

		if ($('#entId').val().trim() === "") {
		    Toast.fire({
		        icon: 'warning',
		        title: '아이디를 입력해 주세요. (5~20자의 영문 소문자, 숫자, 특수기호 _와 -만 허용)'
		    });
		    $("#idChkResult").html("유효하지 않은 아이디").css('color', 'red');
		    $('#entId').focus();
		    event.preventDefault();
		    return false;
		} else if (!validateUsername($('#entId').val().trim())) {
		    Toast.fire({
		        icon: 'warning',
		        title: '유효하지 않은 아이디입니다. 5~20자의 영문 소문자, 숫자, 특수기호 _와 -만 입력해 주세요.'
		    });
		    $("#idChkResult").html("유효하지 않은 아이디").css('color', 'red');
		    $('#entId').focus();
		    event.preventDefault();
		    return false;
		}
		$.ajax({
			url : "/security/idChkAjax",
			contentType:"text/plain;charset=utf-8", 
			data : entId,
			type : 'post',
			dataType : 'text',
			beforeSend:function(xhr){
				xhr.setRequestHeader("${_csrf.headerName}","${_csrf.token}");
			},
			success : function(result) {
				if(result == 'true') {
                    $("#idChkResult").html("사용 가능").css('color', 'green');
                } if(result == 'false') {
                    $("#idChkResult").html("ID 중복 - 사용불가").css('color', 'red');
                }
				
			}
		})
	})
	
	$('#signinBtn').on('click', function(event){
	    var idchk = $('#idChkResult').html().trim();
	    
	    if ($('#entBrno').val().trim() === "") {
	    	Toast.fire({
				icon:'warning',
				title:'사업자번호를 입력해 주세요.'
			});
	    	$('#entBrno').focus();
	    	event.preventDefault();
	    	return false;
	    }
	    if ($('#entNm').val().trim() === "") {
	    	Toast.fire({
				icon:'warning',
				title:'기업명을 입력해 주세요.'
			});
	    	$('#entNm').focus();
	    	event.preventDefault();
	    	return false;
	    }
	    if ($('#tpbizSeCd').val() === null) {
	    	Toast.fire({
				icon:'warning',
				title:'업종을 선택해 주세요.'
			});
	    	$('#tpbizSeCd').focus();
	    	event.preventDefault();
	    	return false;
	    }
	    if ($('#entFndnYmd').val().trim() === "") {
	    	Toast.fire({
				icon:'warning',
				title:'설립일을 입력해 주세요.'
			});
	    	$('#entFndnYmd').focus();
	    	event.preventDefault();
	    	return false;
	    }
	    if ($('#entEmpCnt').val().trim() === "") {
	    	Toast.fire({
				icon:'warning',
				title:'사원수를 입력해 주세요.'
			});
	    	$('#entEmpCnt').focus();
	    	event.preventDefault();
	    	return false;
	    }
	    if ($('#entStleCd').val() === null) {
	    	Toast.fire({
				icon:'warning',
				title:'기업형태를 선택해 주세요.'
			});
	    	$('#entStleCd').focus();
	    	event.preventDefault();
	    	return false;
	    }
	 // 팩스 번호 유효성 검사 함수
	    function validateFaxNumber(faxNumber) {
	        // 숫자만 허용하는 정규식 (팩스 번호 형식에 따라 자릿수는 조정 가능)
	        const faxNumberPattern = /^\d+$/;
	        return faxNumberPattern.test(faxNumber);
	    }

	    if ($('#entFxnum').val().trim() === "") {
	        Toast.fire({
	            icon: 'warning',
	            title: '팩스번호를 입력해 주세요.'
	        });
	        $('#entFxnum').focus();
	        event.preventDefault();
	        return false;
	    } else {
	        // 입력된 값에서 '-' 제거
	        const cleanedFaxNumber = $('#entFxnum').val().trim().replace(/-/g, '');
	        
	        // 팩스 번호 유효성 검사
	        if (!validateFaxNumber(cleanedFaxNumber)) {
	            Toast.fire({
	                icon: 'warning',
	                title: '유효하지 않은 팩스번호입니다. 숫자만 입력해 주세요.'
	            });
	            $('#entFxnum').focus();
	            event.preventDefault();
	            return false;
	        }
	    }

	 // URL 유효성 검사 함수
	    function validateURL(url) {
	        // URL 형식을 검사하는 정규식
	        const urlPattern = /^(https?:\/\/)?([a-zA-Z0-9-]+\.)+[a-zA-Z]{2,}.*$/;
	        return urlPattern.test(url);
	    }

	    if ($('#entHmpgUrl').val().trim() === "") {
	        Toast.fire({
	            icon: 'warning',
	            title: '기업홈페이지를 입력해 주세요.'
	        });
	        $('#entHmpgUrl').focus();
	        event.preventDefault();
	        return false;
	    } else {
	        // URL 유효성 검사
	        const enteredURL = $('#entHmpgUrl').val().trim();
	        if (!validateURL(enteredURL)) {
	            Toast.fire({
	                icon: 'warning',
	                title: '유효하지 않은 URL입니다. 올바른 형식의 홈페이지 주소를 입력해 주세요. ex)example.com'
	            });
	            $('#entHmpgUrl').focus();
	            event.preventDefault();
	            return false;
	        }
	    }

	    if ($('#entRprsntvNm').val().trim() === "") {
	    	Toast.fire({
				icon:'warning',
				title:'대표자이름을 입력해 주세요.'
			});
	    	$('#entRprsntvNm').focus();
	    	event.preventDefault();
	    	return false;
	    }
	    if(idchk !== "사용 가능"){
	    	Toast.fire({
				icon:'warning',
				title:'ID 중복되거나 중복체크를 하지 않았습니다.'
			});
	        event.preventDefault();
	        return false;
	    }
	 	// 비밀번호 유효성 검사 함수
	    function validatePassword(entPswd) {
	        // 8~16자의 영문 대/소문자, 숫자, 특수문자를 포함하는 정규식
	        const passwordPattern = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*])[A-Za-z\d!@#$%^&*]{8,16}$/;
	        return passwordPattern.test(entPswd);
	    }

	    if ($('#entPswd').val().trim() === "") {
	        Toast.fire({
	            icon: 'warning',
	            title: '비밀번호를 입력해 주세요. (8~16자의 영문 대/소문자, 숫자, 특수문자 포함)'
	        });
	        $('#entPswd').focus();
	        event.preventDefault();
	        return false;
	    } else if (!validatePassword($('#entPswd').val().trim())) {
	        Toast.fire({
	            icon: 'warning',
	            title: '유효하지 않은 비밀번호입니다. 8~16자의 영문 대/소문자, 숫자, 특수문자를 포함해 주세요.'
	        });
	        $('#entPswd').focus();
	        event.preventDefault();
	        return false;
	    }
	    if($("#entPswdChk").val().trim() === "" || $("#entPswd").val().trim() !== $("#entPswdChk").val().trim()){
	    	Toast.fire({
				icon:'warning',
				title:'비밀번호와 비밀번호 확인이 다릅니다. 다시 확인하세요.'
			});
	        event.preventDefault(); // 폼 제출을 막음
	        return false;   // 서버로 전송을 하지 않는다.
	    }
	    // 이메일 유효성 검사 함수
	    function validateEmail(email) {
	        // 이메일 형식을 검사하는 정규식
	        const emailPattern = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
	        return emailPattern.test(email);
	    }

	    if ($('#entMail').val().trim() === "") {
	        Toast.fire({
	            icon: 'warning',
	            title: '이메일을 입력해 주세요.'
	        });
	        $('#entMail').focus();
	        event.preventDefault();
	        return false;
	    } else if (!validateEmail($('#entMail').val().trim())) {
	        Toast.fire({
	            icon: 'warning',
	            title: '유효하지 않은 이메일 형식입니다. 올바른 이메일 주소를 입력해 주세요. ex) test@test.com'
	        });
	        $('#entMail').focus();
	        event.preventDefault();
	        return false;
	    }
	    if ($('#entManagerTelno').val().trim() === "") {
	    	Toast.fire({
				icon:'warning',
				title:'담당자연락처를 입력해 주세요.'
			});
	    	$('#entManagerTelno').focus();
	    	event.preventDefault();
	    	return false;
	    }
	    if ($('#entAddr').val().trim() === "") {
	    	Toast.fire({
				icon:'warning',
				title:'기본주소를 입력해 주세요.'
			});
	        $('#entAddr').focus();
	        event.preventDefault();
	        return false;
	    }
	    if ($('#entAddrDetail').val().trim() === "") {
	    	Toast.fire({
				icon:'warning',
				title:'상세주소를 입력해 주세요.'
			});
	        $('#entAddrDetail').focus();
	        event.preventDefault();
	        return false;
	    }
	    if ($('#entZip').val().trim() === "") {
	    	Toast.fire({
				icon:'warning',
				title:'우편번호를 입력해 주세요.'
			});
	        $('#entZip').focus();
	        event.preventDefault();
	        return false;
	    }
	    if ($('#authCount').text().trim() !== "인증성공") {
	    	Toast.fire({
				icon:'warning',
				title:'휴대폰인증을 해주세요.'
			});
	        $('#authCount').focus();
	        event.preventDefault();
	        return false;
	    }

//	    if ($('#chk input[type="checkbox"]:not(:checked)').length > 0) {
//	        alert("이용 약관을 모두 동의 해주세요");
//	        event.preventDefault(); // 폼 제출을 막음
//	        return false;
// 	    }

	    let formData = new FormData();
		let entBrno = $("#entBrno").val();
		let entNm = $("#entNm").val();
		let entFndnYmd = $("#entFndnYmd").val();
		let entEmpCnt = $("#entEmpCnt").val();
		let entStleCd = $("#entStleCd").val();
		let entFxnum = $("#entFxnum").val();
		let entHmpgUrl = $("#entHmpgUrl").val();
		let entRprsntvNm = $("#entRprsntvNm").val();
		let entId = $("#entId").val();
		let entPswd = $("#entPswd").val();
		let entMail = $("#entMail").val();
		let entManagerTelno = $("#entManagerTelno").val();
		let entAddr = $("#entAddr").val();
		let entAddrDetail = $("#entAddrDetail").val();
		let entZip = $("#entZip").val();
		let tpbizSeCd = $("#tpbizSeCd").val();
		var entLogoFile = $("#entLogoFile")[0].files[0];
		var entBrFileFile = $("#entBrFileFile")[0].files[0];
		
		formData.append("entBrno",entBrno);
		formData.append("entNm",entNm);
		formData.append("entFndnYmd",entFndnYmd);
		formData.append("entEmpCnt",entEmpCnt);
		formData.append("entStleCd",entStleCd);
		formData.append("entFxnum",entFxnum);
		formData.append("entHmpgUrl",entHmpgUrl);
		formData.append("entRprsntvNm",entRprsntvNm);
		formData.append("entId",entId);
		formData.append("entPswd",entPswd);
		formData.append("entMail",entMail);
		formData.append("entManagerTelno",entManagerTelno);
		formData.append("entAddr",entAddr);
		formData.append("entAddrDetail",entAddrDetail);
		formData.append("entZip",entZip);
		formData.append("tpbizSeCd",tpbizSeCd);
		if(entLogoFile!=null){
			formData.append("entLogoFile",entLogoFile);
		}
		if(entBrFileFile!=null){
			formData.append("entBrFileFile",entBrFileFile);
		}
		
		$.ajax({
			url : "/security/entSigninPostAjax",
			processData:false,
			contentType:false,
			data:formData,
			type:"post",
			dataType:"text",
			beforeSend:function(xhr){
				xhr.setRequestHeader("${_csrf.headerName}","${_csrf.token}");
			},
			success : function(result) {
				console.log("result : " + result);
				// success, error, warning, info, question
				Toast.fire({
					icon:'success',
					title:'회원가입 되었습니다.'+result
				});
				// 3초 후에 이동
				setTimeout(function(){
					location.href="/security/entLogin";
				},3000)
			}
		})
	})
	
	$("#entId").on("input", function(){
		$("#idChkResult").text("");
	})
	$("#entManagerTelno").on("input", function(){
		let val = $("#authCount").text();
		if(val == "인증성공"){
			$("#authCount").text("");
		}		
	})
})
</script>
<div class="main">
	<div class="login-box">
		<div class="card">
			<div class="login-logo row">
				<div>
					<p>Welcome to ReadyGo</p>
					<h2>기업 회원가입</h2>
				</div>
				<div>
					<p>계정이 있으신가요?<br />
					<a id="signin" href="/security/entLogin" style="font-size: 14px;">로그인</a></p>
				</div>
			</div>
			<div class="card-body login-card-body">
				<!-- 
				[스프링 시큐리티 로그인 폼 규칙]
				1. 아이디   : name속성값이 username
				2. 비밀번호 : name속성값이 password
				3. form태그의 action속성값이 /login, method속성값이 post
				4. csrf 처리
				5. submit 버튼
				 -->
				<form id="mf" action="/security/memSignInPost" method="post">
					<div class="form-group mb-3">
						<label for="entBrno">사업자 등록번호</label>
						<input type="text" class="form-control" 
							placeholder="사업자 등록번호를 입력하세요. (10자리)" 
							name="entBrno" id="entBrno" required />
					</div>
					<div class="col-12">
						<button type="button" id="brBtn" class="btn btn-block btn-login" style="margin-bottom: 20px;">사업자등록증 파일 추가</button>
					</div>
					<div class="form-group nb" id="brFileForm" hidden="hidden">
						<label for="brFile">사업자등록증 파일</label><br />
						<p id="brtxt"></p>
					</div>
					<div class="form-group nb" hidden="hidden">
						<input type="file" class="form-control"
							name="entBrFileFile" id="entBrFileFile" />
					</div>
					<div class="col-12" style="margin-bottom: 20px;">
						<button type="button" id="imgBtn" class="btn btn-block btn-login">로고 사진 추가</button>
					</div>
					<div class="form-group nb" id="imgForm" hidden="hidden">
						<label for="pImg">로고 사진</label><br />
						<img id="pImg" />
					</div>
					<div class="form-group nb" hidden="hidden">
						<input type="file" class="form-control"
							name="entLogoFile" id="entLogoFile" />
					</div>
					<div class="form-group mb-3">
						<label for="entNm">기업명</label>
						<input type="text" class="form-control" 
							placeholder="기업명을 입력하세요." 
							name="entNm" id="entNm" required />
					</div>
					<div class="row idForm">
						<div class="form-group nb">
							<label for="tpbizSeCd" id="reg1label">업종</label>
							<select class="form-control" name=tpbizSeCd id="tpbizSeCd">
								<option value="" disabled selected>업종*</option>
								<c:forEach var="codeVO2" items="${codeVOList2}" varStatus="stus">
									<option value="${codeVO2.comCode}">${codeVO2.comCodeNm}</option>
								</c:forEach>
							</select> 
						</div>
						<div class="form-group nb">
							<label for="entFndnYmd" id="reg1label">설립일</label>
							<input type="date" class="form-control" 
								placeholder="설립일을 입력하세요." 
								name="entFndnYmd" id="entFndnYmd" required /> 
						</div>
					</div>
					<div class="row idForm">
						<div class="form-group nb">
							<label for="entEmpCnt" id="reg1label">사원수</label>
							<input type="text" class="form-control" 
								placeholder="사원수를 입력하세요." 
								name="entEmpCnt" id="entEmpCnt" required />
						</div>
						<div class="form-group nb">
							<label for="entStleCd" id="reg1label">기업형태</label>
							<select class="form-control" name="entStleCd" id="entStleCd">
								<option value="" disabled selected>기업형태*</option>
								<c:forEach var="codeVO" items="${codeVOList }" varStatus="stus">
									<option value="${codeVO.comCode}">${codeVO.comCodeNm}</option>
								</c:forEach>
							</select> 
						</div>
					</div>
						<div class="row idForm">
						<div class="form-group nb">
							<label for="entFxnum" id="reg1label">팩스번호</label>
							<input type="text" class="form-control" 
								placeholder="팩스번호를 입력하세요." 
								name="entFxnum" id="entFxnum" required />
						</div>
						<div class="form-group nb">
							<label for="entHmpgUrl" id="reg1label">홈페이지URL</label>
							<input type="text" class="form-control" 
								placeholder="홈페이지URL을 입력하세요" 
								name="entHmpgUrl" id="entHmpgUrl" required /> 
						</div>
					</div>
					<div class="form-group mb-3">
						<label for="entRprsntvNm">대표자명</label>
						<input type="text" class="form-control" 
							placeholder="대표자명을 입력하세요." 
							name="entRprsntvNm" id="entRprsntvNm" required />
					</div>
					<div class="row idForm">
						<div class="form-group mb-2 id">
							<label for="entId">아이디&nbsp;&nbsp;&nbsp;&nbsp;<span id="idChkResult"></span></label>
							<input type="text" class="form-control" 
								placeholder="아이디를 입력하세요" 
								name="entId" id="entId" required />
						</div>
						<div class="form-group mb-1">
							<button type="button" class="btn btn-block btn-sign" id="idchk">아이디 중복검사</button>
						</div>
					</div>
					<div class="form-group mb-3">
						<label for="entPswd">비밀번호</label>
						<input type="password" class="form-control" 
							placeholder="비밀번호를 입력하세요." 
							name="entPswd" id="entPswd" required />
					</div>
					<div class="form-group mb-3">
						<label for="entPswdChk">비밀번호 확인</label>
						<input type="password" class="form-control" 
							placeholder="비밀번호를 입력하세요." 
							name="entPswdChk" id="entPswdChk" required />
					</div>
					<div class="form-group mb-3">
						<label for="entMail">이메일</label>
						<input type="text" class="form-control" 
							placeholder="이메일을 입력하세요" 
							name="entMail" id="entMail" required />
					</div>
					<div class="row idForm">
						<div class="form-group mb-2 id">
							<label for="entManagerTelno">휴대폰번호 및 인증</label>
							<input type="text" class="form-control" 
								placeholder="전화번호를 입력하세요" 
								name="entManagerTelno" id="entManagerTelno" required />
						</div>
						<div class="form-group mb-1">
							<button type="button" class="btn btn-block btn-sign" id="sendAuthNumBtn">인증번호 전송</button>
						</div>
					</div>
					<div class="row idForm" id="authNumForm" hidden="hidden">
						<div class="form-group mb-2 id">
							<input type="text" class="form-control" 
								placeholder="인증번호를 입력하세요." 
								name="authNum" id="authNum" required />
							<span class="certificationTime" id="authCount">03:00</span>
						</div>
						<div class="form-group mb-1">
							<button type="button" class="btn btn-block btn-sign" id="authChk">확인</button>
						</div>
					</div>
					<div class="row idForm">
						<div class="form-group mb-2 id">
							<label for="entAddr">근무지 기본 주소</label>
							<input type="text" class="form-control" 
								placeholder="우편번호" 
								name="entZip" id="entZip" readonly="readonly" required />
						</div>
						<div class="form-group mb-1">
							<button type="button" class="btn btn-block btn-sign" onclick="execDaumPostcode();">주소 찾기</button>
						</div>
					</div>
					<div class="form-group mb-3">
						<input type="text" class="form-control" 
								placeholder="기본 주소" 
								name="entAddr" id="entAddr" readonly="readonly" required />
						
					</div>
					<div class="form-group mb-3">
						<input type="text" class="form-control" 
							placeholder="상세 주소" 
							name="entAddrDetail" id="entAddrDetail" required />
					</div>
					<div class="col-12">
						<button type="button" id="signinBtn" class="btn btn-block btn-login">회원가입</button>
					</div>
					<!-- csrf : Cross Site(크로스 사이트) Request(요청) Forgery(위조) -->
					<sec:csrfInput/>
				</form>
			</div>
		</div>
	</div>
</div>
