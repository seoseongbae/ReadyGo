<%@page import="java.net.URLDecoder"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<script type="text/javascript" src="/resources/js/jquery-3.6.0.js"></script>
<script type="text/javascript" src="/resources/js/js.cookie.min.js"></script>
<link rel="stylesheet" href="/resources/css/security/loginForm.css">
<script type="text/javascript" src="/resources/js/sweetalert2.js"></script>
<script src="https://developers.kakao.com/sdk/js/kakao.js"></script>

<script type="text/javascript">
var Toast = Swal.mixin({
	toast: true,
    position: 'center',
    showConfirmButton: false,
    timer: 3000
});
$(function(){
	if (Cookies.get('username') != null) {
        // 쿠키 값을 이용해 사용자 이름 입력 필드를 채우기
        let username = Cookies.get('username');
        $("#username").val(username);
        $("#remember_us").attr("checked", true);
    }else{
        $("#username").val();
    	
    }
	$("#loginBtn").on("click", function(){
		let username = $("#username").val();
        let password = $("#password").val();
		
        // 'remember me' 체크박스가 체크되어 있는지 확인
        if ($("input[name='remember_us']:checked").val()) {
            // 7일 동안 만료되는 쿠키 설정
            Cookies.set('username', username, { expires: 7});
        } else {
            // 'username' 쿠키 제거
            Cookies.remove('username');
        }
        
        $("#login").submit();
	})
	
	$(".fa-eye").on("click", function() {
	    console.log("showing password");
	    $(".fa-eye-slash").attr("hidden", false);
	    $(this).attr("hidden", true);
	    $("#password").attr("type", "text");
	});

	$(".fa-eye-slash").on("click", function() {
	    console.log("hiding password");
	    $(".fa-eye").attr("hidden", false);
	    $(this).attr("hidden", true);
	    $("#password").attr("type", "password");
	});
	
	$("#kakao-logout-btn").on("click",function() {
	    Kakao.Auth.logout(function() {
	        console.log('로그아웃 성공');
	    });
	});
	
	
	$("#sb").on("click", function(){
		$("#username").val("minjoo1");
		$("#password").val("1234");
		$("#login").submit();
	})
	$("#mg").on("click", function(){
		$("#username").val("test1");
		$("#password").val("1234");
		$("#login").submit();
	})
	$("#giup").on("click", function(){
		$("#username").val("dd1021");
		$("#password").val("1234");
		$("#login").submit();
	})
	
})
//강제로 연결을 끊기위함
function unlinkApp() {
    Kakao.API.request({
      url: '/v1/user/unlink',
    })
      .then(function(res) {
        alert('success: ' + JSON.stringify(res));
        deleteCookie();
      })
      .catch(function(err) {
        alert('fail: ' + JSON.stringify(err));
      });
  }

  // 아래는 데모를 위한 UI 코드입니다.
  function deleteCookie() {
    document.cookie = 'authorize-access-token=; Path=/; Expires=Thu, 01 Jan 1970 00:00:01 GMT;';
  }

  
// 카카오 초기화
Kakao.init('55629d4100b1ddb5eabe5c5b4e28c441');
console.log(Kakao.isInitialized()); // 초기화 판단여부
if (Kakao.Auth.getAccessToken()) {
    console.log("이미 카카오 로그인이 되어 있습니다.");
    // 자동 로그인을 방지하고 싶다면 여기에 Kakao.Auth.logout()을 호출하거나
    // 카카오 로그인 버튼을 숨길 수 있습니다.
    Kakao.Auth.logout(); // 이걸 호출하면 기존 토큰이 제거됨.
} else {
    console.log("카카오 로그인이 필요합니다.");
}

//카카오 로그인 후 토근 값 저장.
function loginWithKakao() {
    Kakao.Auth.login({
        success: function (authObj) {
            console.log(authObj); // access토큰 값
            Kakao.Auth.setAccessToken(authObj.access_token); // access토큰값 저장

            getInfo();
        },
        fail: function (err) {
            console.log(err);
        }
    });
}


//엑세스 토큰을 발급받고, 아래 함수를 호출시켜서 사용자 정보를 받아옴.
function getInfo() {
    Kakao.API.request({
        url: '/v2/user/me',
        success: function (res) {
            console.log(res);
            // 이메일, 성별, 닉네임, 프로필이미지
            var email = res.kakao_account.email;
            var profile_nickname = res.kakao_account.profile.nickname;

            console.log(email,profile_nickname);
            sendEmailToServer(email);
        },
        fail: function (error) {
            alert('카카오 로그인에 실패했습니다. 관리자에게 문의하세요.' + JSON.stringify(error));
        }
    });
}

function sendEmailToServer(email) {
    $.ajax({
        url: '/security/kakaoLogin', // Spring Boot 백엔드의 URL
        type: 'POST',                // HTTP 메소드 (POST 요청)
        data: { email: email },      // 서버로 전송할 데이터 (자동으로 x-www-form-urlencoded로 변환됨)
        success: function (data) {
            // 요청이 성공했을 때 실행되는 콜백 함수
            if (data === "success") {
                alert("로그인 성공");
                window.location.href = '/home';  //로그인 성공ㄱ시
            } else {
                alert("로그인 실패: 이메일이 일치하지 않습니다.");
            }
        },
        error: function (error) {
            // 요청이 실패했을 때 실행되는 콜백 함수
            console.log('Error:', error);
            alert('로그인 처리 중 오류가 발생했습니다.');
        }
    });
}

//로그아웃 기능 - 카카오 서버에 접속하는 엑세스 토큰을 만료, 사용자 어플리케이션의 로그아웃은 따로 진행.
function kakaoLogout() {
    if (!Kakao.Auth.getAccessToken()) {
        alert('Not logged in.');
        return;
    }
    Kakao.Auth.logout(function() {
        alert('logout ok\naccess token -> ' + Kakao.Auth.getAccessToken());
    });
}  
</script>
<style type="text/css">
.container-fluid{
	padding-right: 0;
    padding-left: 0;
}
.main{
	background-image: url("/resources/images/secucrity/login.png");
	display: flex;
	justify-content: center;
	padding-top: 110px;
	min-height: 1100px;
	height:100%;
	width: 100%;
}
.login-box{
	width: 100%;
    display: flex;
    justify-content: center;
    height: 100%;
    margin-bottom: 50px;
}
.login-box .card{
	margin-bottom: 0;
	border: solid 1px #efefef;
	box-shadow: 0px 12px 10px -3px rgba(0, 0, 0, .05), 11px 9px 10px -1px rgba(0, 0, 0, .05); 
	height: auto
}
.login-logo{
	display: flex;
	justify-content: space-between;
	padding-left: 30px;
	padding-right: 30px;
	padding-top:20px;
	text-align: left;
	color: #000000;
	
}
.login-logo p, .login-logo h2{
	color: #000000;
	margin-top:0px;
}
.login-logo h2{
margin-top:20px;
}
.fa-user{
	position: absolute;
    right: 58px;
    top: 216px;
}
.fa-eye{
	position: absolute;
	right:55px;
	top: 316px;
	cursor: pointer;
}
.fa-eye-slash{
	position: absolute;
	right:55px;
	top: 316px;
	cursor: pointer;
}
label:not(.form-check-label):not(.custom-file-label){
	font-weight: 400;
}
#signin{
	color: #24D59E;
    text-decoration: none;
    text-transform: capitalize;
    -webkit-transition: all 0.3s ease 0s;
    transition: all 0.3s ease 0s;
}
#signin:hover{
	color: #000000;
    text-decoration: none;
}
.btn-sign{
	background-color: #24D59E;
	color: #ffffff;
	box-shadow: 0 14px 28px rgba(0,0,0,0.05), 0 10px 10px rgba(0,0,0,0.05);
	transition: all 0.3s ease 0s;
	height: 50px;
	border-radius:8px;
	width: 130px;
}
.btn-sign:hover{
	border: solid 1px #24D59E;
	background-color: #ffffff;
	color:#24D59E;
}
.btn-login{
	background-color: #24D59E;
	color: #ffffff;
	box-shadow: 0 14px 28px rgba(0,0,0,0.05), 0 10px 10px rgba(0,0,0,0.05);
	transition: all 0.3s ease 0s;
	height: 50px;
	border-radius:8px;
}
.btn-login:hover{
	border: solid 1px #24D59E;
	background-color: #ffffff;
	color:#24D59E;
}


/* The container */
.chkbox .container {
  width:100px;
  display: block;
  position: relative;
  padding-left: 25px;
  cursor: pointer;
  font-size: 12px;
  font-weight: 500;
  -webkit-user-select: none;
  -moz-user-select: none;
  -ms-user-select: none;
   user-select: none;
   bottom:10px;
   color: #24D59E; 
}

/* Hide the browser's default checkbox */
.chkbox .container input {
  position: absolute;
  opacity: 0;
  cursor: pointer;
  height: 0;
  width: 0;
}

/* Create a custom checkbox */
.checkmark {
  position: absolute;
  top: 2px;
  left: 0;
  height: 14px;
  width: 14px;
  border-radius:4px;
  background-color: #FFFFFF;
  border:1px solid #24D59E;
}

/* On mouse-over, add a grey background color */
.chkbox .container:hover input ~ .checkmark {
  background-color: #ffffff;
  border:1px solid #015163;
}

/* When the checkbox is checked, add a blue background */
.chkbox .container input:checked ~ .checkmark {
  background-color: #24D59E;
}

/* Create the checkmark/indicator (hidden when not checked) */
.checkmark:after {
  content: "";
  position: absolute;
  display: none;
}

/* Show the checkmark when checked */
.chkbox .container input:checked ~ .checkmark:after {
  display: block;
}

/* Style the checkmark/indicator */
.chkbox .container .checkmark:after {
  left: 4px;
  top: 1px;
  width: 4px;
  height: 8px;
  border: solid white;
  border-width: 0 2px 2px 0;
  -webkit-transform: rotate(45deg);
  -ms-transform: rotate(45deg);
  transform: rotate(45deg);
}
.chkbox{
   display: flex;
   flex-direction: row;
}
#find{
	position:relative;
	bottom: 15px;
	left:80px;
}
.socialLogin{
	margin-top:35px;
	padding-right: 8px;
    padding-left: 7px;
    justify-content: space-between;	
    
}
.soBtn{
	background-color: #fde400;
    margin-top: 22px;
    height: 50px;
    padding: 0px;
    border-radius: 8px;
    box-shadow: 0 14px 28px rgba(0, 0, 0, 0.05), 0 10px 10px rgba(0, 0, 0, 0.05);
}
.idForm .nb{
	width: 49%;
}
.birForm .nb{
	width: 46%;
}

.idForm .form-group p{
	width: auto;
	padding: 10px;
}
#reg1{
	width: 60%;
}
#reg2{
	width: 18%;
}
.row #reg1label{
	margin-right: 48px;
}
.resetBtn {
	background: white;
	color: #232323;
	border: 1px solid #B5B5B5;
	transition: all 0.3s ease 0s;
	padding: 7px 40px 7px 40px;
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
.ddalkkack{
	font-size: 6px;
	width: 25px;
	height: 25px;
	border: 1px solid #24D59E;
	border-radius: 100%;
	background-color: #ffffff;
	color: #24D59E;
	margin-bottom: 10px;
}
</style>
<div style="position:fixed;bottom: 0; right: 0; display: flex; flex-direction: column; padding: 20px;">
	<button class="ddalkkack" id="mg">민구</button>
	<button class="ddalkkack" id="sb">민주</button>
	<button class="ddalkkack" id="giup">기업</button>
</div>
<div class="main">
	<div class="login-box">
		<div class="card">
			<div class="login-logo row">
				<div>
					<p>Welcome to ReadyGo</p>
					<h2>로그인</h2>
				</div>
				<div>
					<p>계정이 없으신가요?<br />
					<a id="signin" href="/security/memSignin" style="font-size: 14px;">회원가입</a><br />
					<a id="signin" href="/security/entLogin" style="font-size: 14px; ">기업 로그인</a></p>
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
				<form id="login" action="/login" method="post">
					<div class="form-group mb-3">
						<label for="username">Enter you ID &nbsp;&nbsp;&nbsp;<span style="color:#ff0018; font-size: 18px; font-weight: 600;">${error }</span></label>
						<input type="text" class="form-control" 
							placeholder="아이디" 
							name="username" id="username" value="" />
						<div class="form-group-append">
							<div class="form-group-text">
								<span class="fas fa-user"></span>
							</div>
						</div>
					</div>
					<div class="form-group mb-3">
						<label for="username">Enter you Password</label>
						<input type="password" class="form-control" 
							placeholder="비밀번호" 
							name="password" id="password" />
						<div class="form-group-append">
							<div class="form-group-text">
								<span class="fas fa-eye"></span>
								<span class="fas fa-eye-slash" hidden="hidden"></span>
							</div>
						</div>
					</div>
					<div class="col-12">
						<div class="icheck-primary">
							<!-- 로그인 상태 유지 체크박스
							체크 시 : PERSISTENT_LOGINS에 로그인 로그 정보가 insert
							 -->
						    <div class="userChkBox">
							   <div class="chkbox">
							   		<div id="rememberID">
							      		<label class="container">아이디저장<input type="checkbox" id="remember_us" name="remember_us"><span class="checkmark"></span></label>
							   		</div>
							   		<div id="autoLogin">
							      		<label class="container">자동로그인<input type="checkbox" id="remember-me" name="remember-me"><span class="checkmark"></span></label>
							   		</div>
							   		<div id="find">
										<p style="font-size: 12px; color: #24D59E;">
											<a id="signin" href="/security/idFind" >아이디찾기</a> | 
											<a id="signin" href="/security/bibunFind" >비밀번호찾기</a>
										</p>
							   		</div>
							   </div>
							</div>
						</div>
						<div class="col-12">
							<button type="button" class="btn btn-block btn-login" id="loginBtn">로그인</button>
						</div>
<!-- 						<a id="kakao-login-btn" href="javascript:loginWithKakao()"><button type="button" class="btn btn-block soBtn"><img src="/resources/images/secucrity/kakaoLoginBtn.png"></button></a> -->
						
					</div>
					<!-- csrf : Cross Site(크로스 사이트) Request(요청) Forgery(위조) -->
					<sec:csrfInput/>
				</form>
			</div>
		</div>
	</div>
</div>
