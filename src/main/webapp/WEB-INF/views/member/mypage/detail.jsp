<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/security/tags"
	prefix="sec"%>
<sec:authorize access="isAuthenticated()">
	<sec:authentication property="principal.memVO" var="priVO" />
</sec:authorize>
<link rel="stylesheet" href="<%=request.getContextPath()%>/resources/css/member/detail.css" />
<link rel="stylesheet" href="<%=request.getContextPath()%>/resources/css/alert.css" />
<script
	src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script type="text/javascript" src="/resources/js/jquery.min.js"></script>
<script type="text/javascript" src="/resources/js/sweetalert2.js"></script>
<script>
var Toast = Swal.mixin({
	toast : true,
	position : 'center',
	showConfirmButton : false,
	timer : 3000
});
// e : onchange 이벤트
function handleImg(e) {
	// 	e.target : <input type="file" class="custom-file-input" id="uploadFile" ... /> 
	let files = e.target.files; // 선택한 파일들
	// 파일들을 잘라서 배열로 만든다
	// fileArr = [토낑.gif,굿.gif,라쿤.gif]
	let fileArr = Array.prototype.slice.call(files);
	// f : 토낑.gif 객체
	let accumStr = "";
	fileArr.forEach(function(f) {
		// 이미지가 아니면
		if (!f.type.match("image.*")) {
			alert("이미지 확장자만 가능합니다");
			return; // 함수 자체가 종료됨
		}
		// 이미지가 맞다면 => 파일을 읽어주는 객체 생성
		let reader = new FileReader();
		// 파일을 읽자
		// e : reader가 이미지 객체를 읽는 이벤트
		reader.onload = function(e) {// "+e.target+result+" - 이미지를 다 읽었으면 결과를 가져와라 -> 그것을 누적
			accumStr += "<img src='" + e.target.result
					+ "' style='width:40%; border:1px solid #D7D7D7;'/>"; // 누적 String
			$(".pImg").html(accumStr);
		}
		reader.readAsDataURL(f);

	});
	// 요소.append : 누적, 요소.html : 새로고침, 요소.innerHTML : J/S에서 새로고침
}
$(function() {
	$("#detailChkBtn").on("click", function(e){
		let formData = new FormData();
		let mbrId = $("#mbrId").val();
		let mbrPswd = $("#mbrPswd").val();
		console.log("mbrId : " + mbrId);
		console.log("mbrPswd : " + mbrPswd);
		formData.append("mbrId", mbrId);
		formData.append("mbrPswd", mbrPswd);
		$.ajax({
			url : "/member/detailChk",
			processData : false,
			contentType : false,
			data : formData,
			type : "post",
			dataType : "text",
			beforeSend : function(xhr) {
				xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
			},
			success : function(result) {
				console.log("result : " + result);
				// success, error, warning, info, question
				if (result == "false") {
					Toast.fire({
						icon : 'error',
						title : '비밀번호 불일치!'
					});
					return;
				}
				Toast.fire({
					icon : 'success',
					title : '비밀번호 일치!'
				});

				$("#chkchk").css("display", "none");
				$(".container").attr("hidden", false);
			}
		})
	});

	$("#btnPost").on("click", function() {
		console.log("우편번호 검색!")
		new daum.Postcode({

			// 다음 창에서 검색이 완료되어 클릭하면 콜백함수에 의해
			// 결과 데이터(JSON string)가 data 객체로 들어온당
			oncomplete : function(data) {
				//data{"zoncode":"12345", "address":"대전 중구", "buildingName":"123-123ㅁ"}
				$("#mbrZip").val(data.zonecode);
				$("#mbrAddr").val(data.address);
				$("#mbrAddrDtl").val(data.buildingName);
				// focus : 테두리와 커서 잡힘
				$("#mbrAddrDtl").focus();
			}
		}).open();
	});

	// 수정 버튼 클릭
	$("#edit").on("click", function() {
		$("#spn1").css("display", "none");
		$("#spn2").css("display", "block");
		$("#btnPost").css("display", "block");
		$("#mbrPswdCh").css("pointer-events","auto");
		$("#mbrPswdCh").css({
			'color':'#24D59E',
			'font-weight':'600',
			'cursor':'pointer',
			'font-size':'14px',
			'display':'inline-block',
			'position':'relative',
			'top':'3px',
			'left':'-2px'
		})
		$("#mbrZip").css('background','rgba(44, 207, 195, 0.11)');
		$("#mbrAddr").css('background','rgba(44, 207, 195, 0.11)');
		

		$('.edit-control').removeAttr("readonly");
		$("#uploadFile").attr("disabled", false);

		// 데이터 백업
		pImg = $("img[name='pImg']").attr("src");
		mbrNm = $("input[name='mbrNm']").val();
		mbrBrdt = $("input[name='mbrBrdt']").val();
		mbrTelno = $("input[name='mbrTelno']").val();
		mbrEml = $("input[name='mbrEml']").val();
		mbrZip = $("input[name='mbrZip']").val();
		mbrAddr = $("input[name='mbrAddr']").val();
		mbrAddrDtl = $("input[name='mbrAddrDtl']").val();
		
	});

	// 취소 -> 일반모드 전환
	$("#cancel").on("click", function() {
		$("#spn1").css("display", "block");
		$("#spn2").css("display", "none");
		$("#btnPost").css("display", "none");
		$("#mbrPswdCh").css("pointer-events","none");
		$("#mbrPswdCh").css({
			'color':'#232323',
			'font-size':'14px',
			'display':'inline-block',
			'position':'relative',
			'top':'3px',
			'left':'-2px'
		})
		$('.edit-control').attr("readonly", true);
		$("#uploadFile").attr("disabled", true);

		// 데이터 백업
		$("img[name='pImg']").attr("src",pImg);
		$("input[name='mbrNm']").val(mbrNm);
		$("input[name='mbrBrdt']").val(mbrBrdt);
		$("input[name='mbrTelno']").val(mbrTelno);
		$("input[name='mbrEml']").val(mbrEml);
		$("input[name='mbrZip']").val(mbrZip);
		$("input[name='mbrAddr']").val(mbrAddr);
		$("input[name='mbrAddrDtl']").val(mbrAddrDtl);

	});

	$("#btnDelete").on("click", function() {
	    // 폼 액션 설정
	    $("#editDTForm").attr("action", "/member/deletePost");

	    // Swal.fire 사용하여 확인창 표시
	    Swal.fire({
	        title: '정말로 회원탈퇴를 하시겠습니까?',
	        icon: 'error',
	        showCancelButton: true,
	        confirmButtonColor: 'white',
	        cancelButtonColor: 'white',
	        confirmButtonText: '예',
	        cancelButtonText: '아니오',
	        reverseButtons: false // 버튼 순서 거꾸로
	    }).then((result) => {
	        if (result.isConfirmed) {
	            // 회원탈퇴 확인 시 폼 전송
	            $("#editDTForm").submit();
	            Toast.fire({
	                icon: 'success',
	                title: '탈퇴 성공!'
	            });
	        } else {
	            // 회원탈퇴 취소 시
	            Toast.fire({
	                icon: 'error',
	                title: '탈퇴 취소!'
	            });
	        }
	    });
	});
	$("#save").on("click", function() {
	    event.preventDefault();
	    
	 // 입력된 이름과 비밀번호 가져오기
	    let mbrNm = $("input[name='mbrNm']").val();
	    let mbrBrdt = $("input[name='mbrBrdt']").val();
		let mbrTelno = $("input[name='mbrTelno']").val();
		let mbrEml = $("input[name='mbrEml']").val();
		let mbrAddrDtl = $("input[name='mbrAddrDtl']").val();
		
		
		if (!/^[가-힣]{2,5}$/.test(mbrNm.trim())) {
		    Toast.fire({
		        icon: 'warning',
		        title: '이름은 2~5자의 한글만 입력해주세요'
		    });
		    return;
		}
		if (!mbrBrdt) {
		    Toast.fire({
		        icon: 'warning',
		        title: '생년월일을 선택해주세요'
		    });
		    return;
		}
		if (!/^010-\d{4}-\d{4}$/.test(mbrTelno.trim())) {
		    Toast.fire({
		        icon: 'warning',
		        title: '전화번호 010-****-**** 형식으로 입력해주세요.'
		    });
		    return;
		}
		
		if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(mbrEml.trim())) {
		    Toast.fire({
		        icon: 'warning',
		        title: '이메일 형식에 맞게 입력해주세요'
		    });
		    return;
		}
		if (!mbrAddrDtl) {
        	Toast.fire({
				icon:'warning',
				title:'상세주소를 입력해주세요'
			});
            return;
        }
	    
	    // 폼 액션 설정
	    $("#editDTForm").attr("action", "/member/editPost");

	    Swal.fire({
	        title: '수정 하시겠습니까?',
	        icon: 'question',
	        showCancelButton: true,
	        confirmButtonColor: 'white',
	        cancelButtonColor: 'white',
	        confirmButtonText: '예',
	        cancelButtonText: '아니오',
	        reverseButtons: false // 버튼 순서 거꾸로
	    }).then((result) => {
	        if (result.isConfirmed) {
	            Toast.fire({
	                icon: 'success',
	                title: '수정 성공!'
	            });
	         	// 1초 후에 submit 실행
	            setTimeout(() => {
	                $("#editDTForm").submit();
	            }, 1000);
	        } else {
	            // 회원탈퇴 취소 시
	            Toast.fire({
	                icon: 'error',
	                title: '수정 실패!'
	            });
	        }
	    });
	});

	// 이미지 클릭 시 파일 입력창 열기
	$(".pImg").on("click", function() {
		$("#uploadFile").click()
	})

	// 파일 선택 후 이미지 미리보기
	$("#uploadFile").on("change", function(e) {
		let file = e.target.files[0];
		if (!file) {
			return;
		}

		if (!file.type.match("image.*")) {
			alert("이미지 파일만 업로드 가능합니다.");
			return;
		}

		let reader = new FileReader();
		reader.onload = function(e) {
			$(".pImg").attr("src", e.target.result);
		}
		reader.readAsDataURL(file);
	});
	
	
});
</script>
<script>
$(document).ready(function() {
     $(document).on("click", "#submitPwd", function(e) {
        e.preventDefault(); // 기본 동작 방지

        let currentPwd = $("#currentPwd").val();
        let newPwd = $("#newPwd").val();
        let confirmNewPwd = $("#confirmNewPwd").val();
        let mbrId = $("#mbrId").val();  // mbrId가 hidden 필드나 다른 방식으로 있어야 합니다.

        if (!currentPwd) {
            Toast.fire({
                icon: 'warning',
                title: '현재 비밀번호를 입력해주세요'
            });
            return;
        }
        if (!newPwd) {
            Toast.fire({
                icon: 'warning',
                title: '새 비밀번호를 입력해주세요'
            });
            return;
        }
        if (!/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*])[A-Za-z\d!@#$%^&*]{8,16}$/.test(newPwd)) {
            Toast.fire({
                icon: 'warning',
                title: '비밀번호는 8~16자의 영문(대소문자), 숫자, 특수문자를 혼합하여 입력해주세요'
            });
            return;
        }
        
        if (newPwd !== confirmNewPwd) {
            Toast.fire({
                icon: 'warning',
                title: '새 비밀번호가 일치하지 않습니다!'
            });
            return;
        }

        // 현재 비밀번호 확인
        let formData = new FormData();
        formData.append("mbrId", mbrId);
        formData.append("mbrPswd", currentPwd);

        Swal.fire({
			title: '변경 하시겠습니까?',
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
        	            url: "/member/detailChk",  // 현재 비밀번호 확인 URL
        	            processData: false,
        	            contentType: false,
        	            data: formData,
        	            type: "post",
        	            dataType: "text",
        	            beforeSend: function(xhr) {
        	                xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
        	            },
        	            success: function(result) {
        	                if (result == "false") {
        	                    Toast.fire({
        	                        icon: 'warning',
        	                        title: '현재 비밀번호가 일치하지 않습니다!'
        	                    });
        	                    return;
        	                }

        	                // 현재 비밀번호가 일치하면, 비밀번호 변경 요청을 보냄
        	                let changeFormData = new FormData();
        	                changeFormData.append("mbrId", mbrId);
        	                changeFormData.append("mbrPswd", newPwd);  // 새 비밀번호를 서버로 전송

        	                $.ajax({
        	                    url: "/member/updatePswd",  // 비밀번호 변경 URL
        	                    processData: false,
        	                    contentType: false,
        	                    data: changeFormData,
        	                    type: "post",
        	                    dataType: "text",
        	                    beforeSend: function(xhr) {
        	                        xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
        	                    },
        	                    success: function(result) {
        	                        Toast.fire({
        	                            icon: 'success',
        	                            title: '비밀번호가 변경되었습니다!'
        	                        });
        	                        
        	                        $("#modalPwdCh").modal('hide');  // 모달 닫기
        	                    },
        	                    error: function() {
        	                        Toast.fire({
        	                            icon: 'error',
        	                            title: '비밀번호 변경에 실패했습니다!'
        	                        });
        	                    }
        	                });
        	            },
        	            error: function() {
        	                Toast.fire({
        	                    icon: 'error',
        	                    title: '비밀번호 확인 중 오류가 발생했습니다!'
        	                });
        	            }
        	        });
        	  }
          })

    });
    $('#modalPwdCh').on('hidden.bs.modal', function () {
        $(this).find('input[type="password"]').val('');
    });
    
});
</script>

<br>
<div id="chkchk">
	<div>
		<div>
			<img class="chkImg" src="../resources/images/logo.png"/>
			<p id="pwalert">&nbsp;&nbsp;회원님의 정보를 안전하게 보호하기 위해<br> 다시 한 번 인증을 진행해 주시기 바랍니다.</p>
		</div>
		<div>
			<input type="password" placeholder="비밀번호를 입력해주세요" id="mbrPswd" name="mbrPswd" />
		</div>
		<div>
			<button type="button" class="chkbtn" id="detailChkBtn">확인</button>
		</div>
		<sec:csrfInput />
	</div>
</div>

<div class="container" hidden="hidden">
	<form name="editDTForm" id="editDTForm"
		action="/member/editPost?${_csrf.parameterName}=${_csrf.token}"
		method="post" enctype="multipart/form-data">
		<p id="h3">개인정보 수정</p>
		<br>
		<br>
		<div class="row">
			<div class="col-left">
				<div class="profile-edit">
					<br>
					<!--                     <p id="editImg">[프로필 이미지]</p> -->
					<br>
					<div class="profile-photo">
						<%-- 	                    <img src="${memberVO.fileDetailVOList[0].filePathNm}" alt="${memberVO.fileDetailVOList[0].orgnlFileNm}" class="pImg" id="pImg" /> --%>
						<img src="${memberVO.fileDetailVOList[0].filePathNm}" alt="${memberVO.fileDetailVOList[0].orgnlFileNm}" class="pImg" name="pImg" id="pImg" /> 
							<input class="custom-file-input" type="file" id="uploadFile" name="uploadFile" multiple style="display: none;"
							disabled /> <br>
						<br> <input type="hidden" name="mbrId" id="mbrId"
							value="${memberVO.mbrId}" />
						<p id="mbrId">${memberVO.mbrId}</p>
					</div>
				</div>
			</div>

			<div class="col-right">
				<p class="h4">기본정보</p>
				<br>
				<div class="form-group">
					<label for="mbrNm" style="font-weight: 700;">이름</label> <input
						type="text" id="mbrNm" name="mbrNm" class="edit-control2"
						placeholder="이름" value="${memberVO.mbrNm}" readonly>
				</div>

				<div class="form-group">
					<label for="mbrBrdt" style="font-weight: 700;">생년월일</label> <input
						type="date" id="mbrBrdt" name="mbrBrdt" class="edit-control2"
						value="${memberVO.mbrBrdt.substring(0,4)}-${memberVO.mbrBrdt.substring(4,6)}-${memberVO.mbrBrdt.substring(6,8)}"
						readonly placeholder="생년월일">
				</div>
				<div class="form-group">
					<label for="mbrPswd" style="font-weight: 700;">비밀번호</label> 
					<span id="mbrPswdCh" data-toggle="modal" data-target="#modalPwdCh"
						  data-mbr-pswd="${priVO.mbrPswd}">비밀번호 변경</span>
				</div>

				<br>
				<p class="h4">연락처 정보</p>
				<br>
				<div class="form-group" style="font-weight: 700;">
					<label for="mbrTelno">전화번호<span class="required">*</span></label><input type="text" id="mbrTelno"
						name="mbrTelno" class="edit-control" placeholder="전화번호"
						value="${memberVO.mbrTelno.substring(0, 3)}-${memberVO.mbrTelno.substring(3, 7)}-${memberVO.mbrTelno.substring(7)}"
						readonly>
				</div>

				<div class="form-group">
					<label for="mbrEml" style="font-weight: 700;">이메일<span class="required">*</span></label> <input
						type="text" id="mbrEml" name="mbrEml" class="edit-control"
						placeholder="이메일" value="${memberVO.mbrEml}" readonly>
				</div>

				<div class="form-group">
					<label for="mbrZip" style="font-weight: 700;">우편번호<span class="required">*</span></label> <input
						type="text" id="mbrZip" name="mbrZip" class="edit-control2"
						value="${memberVO.mbrZip}" readonly> <input type="button"
						class="btn btn-primary" id="btnPost" placeholder="우편번호"
						value="주소 검색" style="display: none;" />
				</div>

				<div class="form-group">
					<label for="mbrAddr" style="font-weight: 700;">주소<span class="required">*</span></label> <input
						style="width: 250px;" type="text" id="mbrAddr" name="mbrAddr"
						class="edit-control2" placeholder="주소" value="${memberVO.mbrAddr}"
						readonly>
				</div>

				<div class="form-group">
					<label for="mbrAddrDtl" style="font-weight: 700;">상세주소<span class="required">*</span></label> <input
						type="text" id="mbrAddrDtl" name="mbrAddrDtl" placeholder="상세주소"
						class="edit-control" value="${memberVO.mbrAddrDtl}" readonly>
				</div>

				<sec:csrfInput />
			</div>
			<!-- 폼 페이지에는 csrf써줘야함 -->

			<!-- 일반 모드 시작 -->
			<div id="editBox">
				<span id="spn1" class="button-group">
					<p>
						<input type="button" id="edit" value="수정" /> <input type="button"
							id="btnDelete" value="회원 탈퇴" />
					</p>
				</span>
				<!-- 일반 모드 끝 -->

				<!-- 수정 모드 시작 -->
				<span id="spn2" class="button-group" style="display: none;">
					<p>
						<input type="button" id="cancel" value="취소" /> <input
							type="submit" id="save" value="저장" />
					</p>
				</span>
			</div>
		</div>
	</form>
	
	
<!-- 비밀번호 변경 모달 ///////////////////////////////// -->
<div class="modal fade" id="modalPwdCh"> 
  <div class="modal-dialog" style="margin-top: 300px;">
    <div class="modal-content">
     <form id="changeForm" action="/member/updatePswd?${_csrf.parameterName}=${_csrf.token}" method="post"> <!-- form 시작 -->
      <div class="modal-header"><span id="title" style="color:#232323">비밀번호 재설정</span>
      </div>
      <div class="modal-body">
			<div class="pwdBox">
			    <div style="margin-bottom: 10px;">
			        <input id="mbrId" type="hidden" name="mbrId" value="${priVO.mbrId}"/>
			        <label class="pwlb">현재 비밀번호</label>
			        <input class="pwInp" id="currentPwd" type="password" placeholder="현재 비밀번호 입력" required/>
			    </div>
			    <div style="margin-bottom: 10px;">
			        <label class="pwlb">새 비밀번호</label>
			        <input class="pwInp" id="newPwd" type="password" placeholder="새 비밀번호 입력" required/>
			    </div>
			    <div>
			        <label class="pwlb">새 비밀번호 확인</label>
			        <input class="pwInp" id="confirmNewPwd" type="password" placeholder="새 비밀번호 확인" required/>
			    </div>
			</div>
      </div>
      <div id="control">
        <button type="button" id="close" class="EditCont" data-dismiss="modal">취소</button>
        <button type="submit" id="submitPwd" class="ChangePwd save">변경</button>
      </div>
		<sec:csrfInput />
      </form>
    </div>
    <!-- /.modal-content -->
  </div>
  <!-- /.modal-dialog -->
</div>
<!-- /.modal -->

</div>

