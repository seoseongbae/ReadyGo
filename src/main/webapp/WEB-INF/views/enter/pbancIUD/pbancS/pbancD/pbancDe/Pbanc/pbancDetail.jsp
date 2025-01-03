<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<sec:authorize access="isAuthenticated()">
	<sec:authentication property="principal.memVO" var="priVO" />
</sec:authorize>	
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script type="text/javascript" 
	src="//dapi.kakao.com/v2/maps/sdk.js?appkey=eaad16168d2cb5b733bf76e1a41ced77&libraries=services"></script>	
<link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20,200,0,0" />
<link rel="stylesheet" href="<%=request.getContextPath()%>/resources/css/alert.css" />
<script type="text/javascript" src="/resources/js/sweetalert2.js"></script>
<script type="text/javascript" src="/resources/js/js.cookie.min.js"></script>
<script type="text/javascript" src="/resources/js/jquery.min.js"></script>
<script>
//sweetAlert 창 띄우기 변수
var Toast = Swal.mixin({
	    toast: true,
	    position: 'center',
	    showConfirmButton: false,
	    timer: 3000
	});
function handleImg(e){
	// e.target : <input type="file" id="uploadFile"..>
	let files = e.target.files; //선택한 파일들
	// fileArr = [a.jpg, b.jpg, c.jpg]
	let fileArr = Array.prototype.slice.call(files);
	// f : a.jpg객체
	let accumStr = "";
	fileArr.forEach(function(f){
		// 이미지가 아니면 
		if(!f.type.match("image.*")){ // MIME타입
//		if(!f.type.match("*.jpg")){ // JPG만
			alert("이미지 확정자만 가능합니다.")
			return; // 함수 자체가 종료됨
		}
		// 이미지가 맞다면
		let reader = new FileReader();
		// e : reader가 이미지 객체를 읽는 이벤트 
		
		reader.onload = function(e){
			accumStr += "<img src='"+e.target.result+"' style='width:20%;border:1px solid #D7DCE1;' />";		
			$("#companyImg").html(accumStr);
		}
		reader.readAsDataURL(f);
	});
	//요소.append : 누적, 요소.html : 새로고침, 요소.innerHTML : J/S에서 새로고침
}
$(document).ready(function() {

   // 쿠키에서 'pbancNoList' 값 가져오기 (없으면 빈 배열로 설정)
   let pbancNoList = Cookies.get('pbancNoList') ? JSON.parse(Cookies.get('pbancNoList')) : [];

   // 새로 조회한 pbancNo 값 추가
   let pbancNo = '${pbancDetailList.pbancNo}';
   console.log("현재 공고 번호:", pbancNo);

   // 이미 존재하는 번호가 아닐 경우에만 추가
   if (!pbancNoList.includes(pbancNo)) {
       pbancNoList.push(pbancNo);
   }
   
   // 쿠키에 저장된 최근 본 공고가 7개를 초과하면 가장 오래된 항목을 제거
   if (pbancNoList.length > 7) {
	    pbancNoList.shift();  // 배열의 첫 번째 항목(가장 오래된 항목)을 제거
	}

   // 쿠키에 업데이트된 pbancNo 리스트를 저장 (7일 동안 유지)
   Cookies.set('pbancNoList', JSON.stringify(pbancNoList), { expires: 7 });

   console.log("최근 본 공고 번호들:", pbancNoList);

	// hidden input에서 ROLE_ENTER 권한 여부 값을 가져옴
    let hasRoleEnter = $('#hasRoleEnter').val();
	console.log("hasRoleEnter", hasRoleEnter);
    // 문자열 "true" 또는 "false"로 넘어오는지 확인
    if (hasRoleEnter == "[ROLE_ENTER]") {
        $("#scrapBtn").prop('disabled', true);
        $("#applyBtn").prop('disabled', true);
    }
    // 모집인원 입력란에서 숫자만 입력 가능하도록 처리
    $('input[name="rcritCnt"]').on('keyup', function() {
        var inputVal = $(this).val();
        if (!/^\d*$/.test(inputVal)) { // 숫자가 아닐 경우
            alert('모집인원에는 숫자만 입력할 수 있습니다.');
            $(this).val(''); // 숫자가 아닌 값을 입력한 경우 입력란을 비움
        }
    });	
// 기본 모드에서 셀렉트 박스와 인풋 박스 비활성화, 배경색 및 글씨 색상 변경
$('.input-detail').css({
    'background-color': 'white', // 배경색 흰색으로 설정
    'color': '#232323', // 글씨 색상 #232323으로 설정
    'pointer-events': 'none', // 클릭 이벤트 방지
    'appearance': 'none', // 셀렉트 박스 화살표 숨기기
    '-webkit-appearance': 'none',
    '-moz-appearance': 'none'
}).attr('readonly', true); // readonly 속성 추가 (disabled 대신)


$('.detail-ta').css({
    'background-color': 'white', // 배경색 흰색으로 설정
    'color': '#232323', // 글씨 색상 #232323으로 설정
    'pointer-events': 'none', // 클릭 이벤트 방지
    'user-select': 'none' // 텍스트 선택 방지
});
// 기본 모드에서 textarea의 스크롤을 숨기고 글씨만 보이게 설정
$('.detail-ta').css({
    'overflow': 'hidden', // 스크롤 숨기기
    'resize': 'none', // 사용자가 크기를 조정하지 못하게 함
    'height': 'auto' // 기본 높이를 자동으로 설정
}).each(function () {
    // 각 textarea의 내용을 기준으로 높이를 자동 조정
    this.style.height = (this.scrollHeight) + 'px';
}).attr('readonly', true); // readonly 속성 추가

// textarea 입력 시 자동으로 높이 조정
$('.detail-ta').on('input', function() {
    this.style.height = 'auto'; // 높이를 자동으로 설정한 후
    this.style.height = (this.scrollHeight) + 'px'; // scrollHeight에 맞춰 높이를 조정
});

// 수정 버튼 클릭 시 수정 모드로 전환
$('.btnUp').click(function() {
	Swal.fire({
	    title: '수정하시겠습니까?',
	    icon: 'question',
	    showCancelButton: true,
	    confirmButtonColor: 'white',
	    cancelButtonColor: 'white',
	    confirmButtonText: '예',
	    cancelButtonText: '아니오'
	}).then((result) => {
	    if (result.isConfirmed) {
	// 셀렉트 박스와 인풋 박스 활성화 및 배경색, 글씨 색상 복원
    dateInput3 = $('#dateInput3').val();
    console.log("dataInput3 : " + dateInput3);
    dateInput3 = dateInput3.replaceAll('.', '-');
    dateInput4 = $('#dateInput4').val();
    console.log("dateInput4 : " + dateInput4);
    dateInput4 = dateInput4.replaceAll(".","-");
    console.log(dateInput3);
    console.log(dateInput4);
    $('#dateInput1').val(dateInput3);
    $("#dateInput2").val(dateInput4);
    $('.input-detail').css({
        'background-color': '', // 기본 배경색으로 복원
        'color': '#232323', // 글씨 색상 유지
        'pointer-events': 'auto', // 클릭 이벤트 가능
        'appearance': 'auto', // 셀렉트 박스 화살표 다시 보이기
        '-webkit-appearance': 'auto', // Webkit 브라우저에서 화살표 복원
        '-moz-appearance': 'auto' // Mozilla 브라우저에서 화살표 복원
    }).attr('readonly', false); // readonly 해제

    $('.detail-ta').css({
        'background-color': '', // 기본 배경색으로 복원
        'color': '#232323', // 글씨 색상 유지
        'pointer-events': 'auto',
        'user-select': 'auto'
    });
    $('.detail-ta').css({
        'overflow': 'auto', // 스크롤 다시 표시
        'resize': 'vertical' // 사용자가 수직으로 크기를 조정 가능하게 함
    }).attr('readonly', false); // 수정 가능하도록 설정
    
    // 수정 모드로 UI 전환
    $('.input-detail').addClass('input-active');
    $('.detail-ta').addClass('textarea-active');
    $('.up-del-btn').css('display', 'none');
    $('.can-sub-btn').css('display', 'block');
    $('#dateText').css('display', 'none');
    $('#dateInput1').css('display', 'block');
    $('#dateInput2').css('display', 'block');
    $('#RcptMthdCd').css('margin-top', '50px');
    $('.job-summary').addClass('hidden');
    $('.action-buttons').addClass('hidden');
    $('#ttlPbanc').css('display', 'block');
    $('#tpbizCd').css('display', 'block');
    $('#pbancTpbizCd').css('display', 'none');
    $('.div-favor').css('display', 'block');
    $('.con-right2').css('display', 'none');
    $('.favor-basic').css('display', 'none');
    $('#powkCd').css('display', 'block');
    $('#powk-input').css('display', 'none');
    $('.div-required').css('display', 'block');
    $('.required-basic').css('display', 'none');
    $('.prefer-basic').css('display', 'none');
    $('.div-prefer').css('display', 'block');
    
    document.querySelector('.contentr').style.cssText += 'min-height: 2600px !important;';
    $('.file-upload-section').css('display', 'block');
	    }
	})
});

// 취소 버튼 클릭 시 기본 모드로 전환
$('.btncan').click(function() {
    // 셀렉트 박스와 인풋 박스 비활성화 및 배경색, 글씨 색상 흰색으로 변경
    $('.input-detail').css({
        'background-color': 'white', // 배경색 흰색으로 설정
        'color': '#232323', // 글씨 색상 유지
        'pointer-events': 'none', // 클릭 이벤트 방지
        'appearance': 'none', // 화살표 숨기기
        '-webkit-appearance': 'none',
        '-moz-appearance': 'none'
    }).attr('readonly', true); // readonly 다시 추가

    $('.detail-ta').css({
        'background-color': 'white', // 배경색 흰색으로 설정
        'color': '#232323', // 글씨 색상 유지
        'pointer-events': 'none',
        'user-select': 'none'
    });
    $('.detail-ta').css({
        'overflow': 'hidden', // 스크롤 숨기기
        'resize': 'none', // 크기 조정 불가
        'height': 'auto' // 높이를 자동으로 설정
    }).each(function () {
        this.style.height = (this.scrollHeight) + 'px'; // 기본 텍스트에 맞게 높이 설정
    }).attr('readonly', true); // readonly 다시 추가


    // 기본 모드로 UI 전환
    $('.input-detail').removeClass('input-active');
    $('.detail-ta').removeClass('textarea-active');
    $('.up-del-btn').css('display', 'block');
    $('.can-sub-btn').css('display', 'none');
    $('.job-summary').removeClass('hidden');
    $('.action-buttons').removeClass('hidden');
    $('#ttlPbanc').css('display', 'none');
    $('#tpbizCd').css('display', 'none');
    $('#pbancTpbizCd').css('display', 'block');
    $('.div-favor').css('display', 'none');
    $('.con-right2').css('display', 'block');
    $('.favor-basic').css('display', 'block');
    $('#powkCd').css('display', 'none');
    $('#powk-input').css('display', 'block');
    $('.div-required').css('display', 'none');
    $('.required-basic').css('display', 'block');
    $('.prefer-basic').css('display', 'block');
    $('.div-prefer').css('display', 'none');
    document.querySelector('.contentr').style.removeProperty('min-height');
    $('.file-upload-section').css('display', 'none'); // 파일 선택 버튼 숨기기
});
// 상세 정보 버튼 클릭 시 공고 이미지로 이동
$('.tab-btn').eq(0).click(
		function() {
			document.querySelector('.company-img-header')
					.scrollIntoView({
						behavior : 'smooth'
					});
		});

// 접수기간 버튼 클릭 시 지원 접수 기간으로 이동
$('.tab-btn').eq(1).click(
		function() {
			document.getElementById('reception-period')
					.scrollIntoView({
						behavior : 'smooth'
					});
		});

// 기업정보 버튼 클릭 시 기업정보로 이동
$('.tab-btn').eq(2).click(function() {
	document.getElementById('company-info').scrollIntoView({
		behavior : 'smooth'
	});
});

// 스크롤 이벤트 감지하여 일정 높이 이상 스크롤되면 Top 버튼 표시
$(window).scroll(function() {
	if ($(this).scrollTop() > 200) {
		$('#topBtn').fadeIn();
	} else {
		$('#topBtn').fadeOut();
	}
});

// Top 버튼 클릭 시 페이지 상단으로 부드럽게 이동
$('#topBtn').click(function() {
	$('html, body').animate({
		scrollTop : 0
	}, 'slow');
	return false;
});

// 스크랩 버튼 클릭 시 처리
$('.bookmark-btn').click(function() {
	var pbancNo = '${param.pbancNo}';
	let scrapped = $('#scrapped').val();
	var mbrId = $("#mbrId").val();
	console.log(scrapped);
	console.log(pbancNo);
	console.log(mbrId);
	$.ajax({
		type : 'POST',
		url : '/enter/scrapPost',
		data : {
			pbancNo : pbancNo, 
			scrapped : scrapped,
			mbrId : mbrId
		},
		beforeSend : function(xhr) {
			xhr.setRequestHeader("${_csrf.headerName}","${_csrf.token}");
		},
		success : function(response) {
			console.log("response", response);
			console.log("response.scrapCount", response.scrapCount);
			$("#scrapped").val(response.scrapped);
			$("#scrapCount").text(response.scrapCount);
		},
		error : function(error) {
			console.log('Error:', error);
		}
	});
});


$("#headcont2-1").on("click",function(){
	  $("#uploadFile").click()
  })
 
  $("#uploadFile").on("change", function() {
      let fileName = $(this).val().split("\\").pop();
        $("#uploadFileName").val(fileName);
  });
  
$("#resumeSel").change(function() {
    let selectedResumeName = $("#resumeSel option:selected").text(); 
    $("#selectedResumeName").val(selectedResumeName);  
});


$("#selectOK").on("click", function() {
	  let selectedResumeNames = [];
	  let selectedResumeIds = [];
	  $(".resume-check:checked").each(function() {
	    selectedResumeNames.push($(this).val());
	    selectedResumeIds.push($(this).data("rsm-no"));
	  });

	  // 선택된 이력서 이름을 기존 모달의 input 필드와 select 요소에 표시
	  if (selectedResumeNames.length > 0) {
	    $("#resumeFile").val(selectedResumeNames.join(", ")); 
	    $("#selectedResumeName").val(selectedResumeNames[0]); 
	    $("#selectedResumeNo").val(selectedResumeIds[0]); // rsmNo도 함께 저장
	  } else {
	    $("#resumeFile").val("선택된 이력서가 없습니다."); 
	    $("#selectedResumeName").val("");
	    $("#selectedResumeNo").val("");
	  }

		console.log("닫혀!!!!!!!!!!")		  
		console.log("닫혀!!!!!!!!!!")		  
	    $('#selectResumeModal').modal('hide');
		console.log("닫혀!!!!!!!!!!")		  
}); 

//체크박스 선택 제한
$('.resume-check').on('change', function() {
  // 선택된 체크박스들의 개수를 확인
  var selectedCount = $('.resume-check:checked').length;
  
  if (selectedCount > 1) {
    Toast.fire({
                icon: 'warning',
                title: '이력서는 하나만 선택해주세요.'
            });
    
    $(this).prop('checked', false);
  }
});

//입사지원 버튼 클릭 시 폼 제출
$('#aplctSubmit').click(function(event) {
    console.log("입사지원 버튼 클릭됨");
    event.preventDefault(); 
    
    let formData = new FormData();
    let mbrId = "${priVO.mbrId}"; 
    let pbancNo = $("#pbancNo").val(); 
    let rsmFile = $("#selectedResumeName").val(); 
    let rsmNo = $("#selectedResumeNo").val(); 
    let uploadFile = $("#uploadFile")[0].files[0];  
    
    formData.append("mbrId", mbrId);
    formData.append("pbancNo", pbancNo);
    formData.append("rsmTtl", rsmFile); 
    formData.append("rsmNo", rsmNo); 


    // 파일 첨부 여부 확인하고 파일 추가
    if (uploadFile) {
        formData.append('uploadFile', uploadFile); 
        console.log("선택된 파일: ", uploadFile);  
    } else {
        formData.append('uploadFile', new Blob());  
        console.log("파일이 선택되지 않음.");
    }
    
    if (!rsmFile) {
	    Toast.fire({
	        icon: 'warning',
	        title: '이력서를 선택해주세요'
	    });
	    return;
	}


    console.log("mbrId:", mbrId);
    console.log("pbancNo:", pbancNo);
    console.log("rsmFile:", rsmFile);
    console.log("rsmNo:", rsmNo);
    console.log("uploadFile:", uploadFile);
    Swal.fire({
        title: '입사 지원하시겠습니까?',
        icon: 'question',
        showCancelButton: true,
        confirmButtonColor: 'white',
        cancelButtonColor: 'white',
        confirmButtonText: '예',
        cancelButtonText: '아니오',
        reverseButtons: false, // 버튼 순서 거꾸로
    }).then((result) => {
    	if (result.isConfirmed) {
    	    // AJAX 요청
    	    $.ajax({
    	        url: "/member/aplctAdd",
    	        processData: false,
    	        contentType: false,
    	        data: formData,
    	        type: "post",
    	        dataType: "json",
    	        beforeSend: function(xhr) {
    	            xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
    	        },
    	        success: function(result) {
    	        	if(result === -1 ){
    	        		Toast.fire({
        	                icon: 'error',
        	                title: '이미 지원한 공고입니다!'
        	            });
    	        	} else {
   	        		 console.log("result : ", result);
   	    	            Toast.fire({
   	    	                icon: 'success',
   	    	                title: '입사 지원 완료!'
   	    	            });
    	    	        $("#modalAplct").modal("hide");
    	        	}
    	           
    	        },
    	        error: function() {
    	            Toast.fire({
    	                icon: 'error',
    	                title: '입사 지원 실패!'
    	            });
    	        }
    	    });
    	}
    });
});



//미리보기 기능 (FileReader API)
$("#imageUpload").on("change", function() {
    var file = this.files[0];  // 선택된 파일
    console.log(file);  // 콘솔에서 파일 확인

    if (file) {
        var reader = new FileReader();
        reader.onload = function(e) {
            $("#companyImg").attr("src", e.target.result);  // 새로운 이미지 미리보기
        };
        reader.readAsDataURL(file);  // 파일을 읽어서 DataURL로 변환
    }
});

//공고 삭제 함수
//공고 삭제 함수
function deletePbanc(pbancNo, entId) {
    let obj = { entId: entId, pbancNo: pbancNo };
    let jsonObj = JSON.stringify(obj);
    let enterId = $("#mbrId").val();

    $.ajax({
        type: 'POST',
        url: '/enter/pbancDelete',
        data: jsonObj, // JSON으로 변환된 데이터를 사용
        contentType: "application/json;charset=UTF-8",
        beforeSend: function(xhr) {
            xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
        },
        success: function(result) {
            if (result > 0) { // 서버 응답이 0보다 크면 성공
          	    Toast.fire({
            	      icon: 'success',
            	      title: '공고 삭제 성공!'
            	    }).then(() => {
                location.href = "/enter/pbanc?entId=" + enterId;
            	    });
            } else {
          	    Toast.fire({
            	      icon: 'error',
            	      title: '공고 삭제 실패!'
            	    }).then(() => {
            	      location.reload(); // 실패 시 즉시 페이지 리로드
            	    });
            }
        },
        error: function(error) {
            console.log('Error:', error);
        }
    });
}

// 버튼 클릭 시 공고 삭제
$('#btnDel').on('click', function() {
    Swal.fire({
        title: '정말로 삭제하시겠습니까?',
        icon: 'error',
        showCancelButton: true,
        confirmButtonColor: 'white',
        cancelButtonColor: 'white',
        confirmButtonText: '예',
        cancelButtonText: '아니오',
        reverseButtons: false, // 버튼 순서 거꾸로
    }).then((result) => {
        if (result.isConfirmed) {
            var pbancNo = $('#pbancNo').val();
            var entId = $('#entId').val();
            console.log(pbancNo + " " + pbancNo);
            deletePbanc(pbancNo, entId);  // 확인 후에 삭제 함수 호출
        }
    });
});

});
//-------------------------복지 및 혜택 추가
$(document).ready(function() {
    let counter = 0; // unique identifier for hidden inputs
    
    $('.add-btn3').click(function() {
        var inputValue = $('#favor').val();
        
        // 중복 확인 로직
        var isDuplicate = false;
        $('#dynamicList3 div').each(function() {
            if ($(this).text().includes(inputValue)) {
                isDuplicate = true;
            }
        });

        if (isDuplicate) {
            alert('중복된 조건을 입력할 수 없습니다.');
            return;
        }

        if (inputValue) {
            var newDiv = $('<div></div>').text(inputValue);
            var removeBtn = $('<button class="delBtn"><img class="delImg" src="../resources/icon/delete.png"></button>').css({
                marginLeft: '10px',
                cursor: 'pointer'
            });

            removeBtn.click(function() {
                newDiv.remove();
                $('#hiddenFavor' + counter).remove();
            });

            newDiv.append(removeBtn);
            $('#dynamicList3').append(newDiv);

            $('<input>').attr({
                type: 'hidden',
                id: 'hiddenFavor' + counter,
                name: 'favorList',
                value: inputValue
            }).appendTo('#hiddenFavorList');

            counter++;

            // 입력 필드 초기화
            $('#favor').val('');
        } else {
            alert('복지 및 혜택을 입력하세요.');
        }
    });
});
$(document).ready(function() {
    // 'x' 버튼 클릭 시 해당 input과 div 삭제
    $(document).on('click', '.delBtn1', function() {
        $(this).closest('.favor-input-del').remove();
    });
});
//-------------------------필수조건추가
$(document).ready(function() {
    let counter = 0; 
    
    // 필수 조건 추가
    $('.add-btn1').click(function() {
        var inputValue = $('#requiredCn').val(); // 입력값 가져오기
        
        // 중복 확인 로직
        var isDuplicate = false;
        $('#dynamicList1 div').each(function() {
            if ($(this).text().includes(inputValue)) {
                isDuplicate = true;
            }
        });

        if (isDuplicate) {
            alert('중복된 조건을 입력할 수 없습니다.');
            return;
        }

        if (inputValue) {
            // 새로운 div 요소 생성
            var newDiv = $('<div></div>').text(inputValue);
            
            // 'x' 버튼 생성
            var removeBtn = $('<button class="delBtn2"><img class="delImg" src="../resources/icon/delete.png"></button>').css({
                marginLeft: '10px',
                cursor: 'pointer'
            });

            // 'x' 버튼 클릭 시 해당 div 삭제와 hidden input 삭제
            removeBtn.click(function() {
                newDiv.remove();
                $('#hiddenRequired' + counter).remove(); // 해당 hidden input도 삭제
            });

            // 입력된 값과 'x' 버튼을 'newDiv'에 추가
            newDiv.append(removeBtn);

            // 동적으로 생성한 div를 화면에 추가
            $('#dynamicList1').append(newDiv);

            // Hidden input 생성하여 값 저장
            $('<input>').attr({
                type: 'hidden',
                id: 'hiddenRequired' + counter,
                name: 'requiredCnList', // 서버로 전송될 name
                value: inputValue
            }).appendTo('#hiddenRequiredList');

            counter++; 


            // 입력 필드 초기화
            $('#requiredCn').val('');
        } else {
            alert('필수 조건을 입력하세요.');
        }
    });
});
$(document).ready(function() {
    // 'x' 버튼 클릭 시 해당 input과 div 삭제
    $(document).on('click', '.delBtn4', function() {
        $(this).closest('.required-input-del').remove();
    });
});
//-------------------------우대조건추가
$(document).ready(function() {
    let counter = 0; 
    
    $('.add-btn2').click(function() {
        var inputValue = $('#preferCn').val();
        
        // 중복 확인 로직
        var isDuplicate = false;
        $('#dynamicList2 div').each(function() {
            if ($(this).text().includes(inputValue)) {
                isDuplicate = true;
            }
        });

        if (isDuplicate) {
            alert('중복된 조건을 입력할 수 없습니다.');
            return;
        }

        if (inputValue) {
            var newDiv = $('<div></div>').text(inputValue);
            var removeBtn = $('<button class="delBtn3"><img class="delImg" src="../resources/icon/delete.png"></button>').css({
                marginLeft: '10px',
                cursor: 'pointer'
            });

            removeBtn.click(function() {
                newDiv.remove();
                $('#hiddenPrefer' + counter).remove();
            });

            newDiv.append(removeBtn);
            $('#dynamicList2').append(newDiv);

            $('<input>').attr({
                type: 'hidden',
                id: 'hiddenPrefer' + counter,
                name: 'preferCnList',
                value: inputValue
            }).appendTo('#hiddenPreferList');

            counter++; 

            // 입력 필드 초기화
            $('#preferCn').val('');
        } else {
            alert('우대 조건을 입력하세요.');
        }
    });
});
$(document).ready(function() {
    // 'x' 버튼 클릭 시 해당 input과 div 삭제
    $(document).on('click', '.delBtn5', function() {
        $(this).closest('.prefer-input-del').remove();
    });
});

//카카오맵 모달
document.addEventListener("DOMContentLoaded", function() {
    var modal = document.getElementById("distanceModal");
    var scoutButtons = document.querySelectorAll(".dis-btn");
    var closeBtn = document.querySelector(".close");

    // 모든 "위치보기" 버튼에 클릭 이벤트 추가
    scoutButtons.forEach(function(button) {
        button.addEventListener("click", function() {
            modal.style.display = "block";
                
                // 서버에서 받아온 주소를 자바스크립트 변수로 저장
                var address = '${pbancDetailList.entAddr}';
                
                // 카카오 지도 API Geocoder 사용
                var geocoder = new kakao.maps.services.Geocoder();

                // 주소로 좌표를 검색하는 함수
                geocoder.addressSearch(address, function(result, status) {
                    if (status === kakao.maps.services.Status.OK) {
                        var coords = new kakao.maps.LatLng(result[0].y, result[0].x);
                        var mapContainer = document.getElementById('staticMap'), 
                            mapOption = { 
                                center: coords, 
                                level: 3
                            };

                        var map = new kakao.maps.Map(mapContainer, mapOption);

                        var marker = new kakao.maps.Marker({
                            map: map,
                            position: coords
                        });
                        
                        // 인포윈도우로 장소에 대한 설명을 표시합니다
                        var infowindow = new kakao.maps.InfoWindow({
                            content: '<div style="width:150px;text-align:center;padding:6px 0;">${pbancDetailList.entNm}</div>'
                        });
                        infowindow.open(map, marker);

                        map.relayout();
                        // 지도의 중심을 결과값으로 받은 위치로 이동시킵니다
                        map.setCenter(coords);
                        map.setLevel();
                        
                    } else {
                        console.error('주소 변환 실패: ' + status); // 오류 로그 추가
                    }
                });
        });
    });

    // 닫기 버튼 클릭 시 모달 닫기
    closeBtn.onclick = function() {
        modal.style.display = "none";
    };

    // 모달 외부 클릭 시 모달 닫기
    window.onclick = function(event) {
        if (event.target == modal) {
            modal.style.display = "none";
        }
    };
});

//-----------------------------------------------validation 유효성검사    
$(document).ready(function() {

    // 공고 제목 실시간 유효성 검사
    $('#pbancTtl').on('keyup', function() {
        let pbancTtl = $(this).val();
        if (!pbancTtl || pbancTtl.length < 5 || pbancTtl.length > 100) {
            showError(this, '공고 제목은 5자 이상 100자 이하이어야 합니다.');
        } else {
            hideError(this);
        }
    });

    // 공고 내용 실시간 유효성 검사
    $('#pbancCn').on('keyup', function() {
        let pbancCn = $(this).val();
        if (!pbancCn || pbancCn.length < 30) {
            showError(this, '공고 내용은 30자 이상이어야 합니다.');
        } else {
            hideError(this);
        }
    });

    // 에러 메시지 표시 함수
    function showError(selector, message) {
        $(selector).addClass('input-error');  // input/textarea 필드에 빨간 테두리 추가
        $(selector).closest('div').siblings('div').find('.error-msg').text(message).show();  // error-msg를 부모 div의 형제 div에서 찾기
    }

    // 에러 메시지 숨기기 함수
    function hideError(selector) {
        $(selector).removeClass('input-error');  // 빨간 테두리 제거
        $(selector).closest('div').siblings('div').find('.error-msg').hide();  // error-msg를 부모 div의 형제 div에서 숨기기
    }
});





$(document).ready(function() {

	// 공고 수정 -> 공고 저장 버튼 sweet alert 적용 시작 ------------------------------------------------------
	$(document).on("click", "#btnsub", function(event) {
		event.preventDefault(); // 기본 폼 전송 방지
		$("#pbancUpdate").attr("action", "/enter/pbancUpdate?${_csrf.parameterName}=${_csrf.token}");

		// Swal.fire 사용하여 수정 확인창 표시
		Swal.fire({
		    title: '저장하시겠습니까?',
		    icon: 'question',
		    showCancelButton: true,
		    confirmButtonColor: 'white',
		    cancelButtonColor: 'white',
		    confirmButtonText: '예',
		    cancelButtonText: '아니오'
		}).then((result) => {
		    if (result.isConfirmed) {
		        // 수정 확인 시 폼 전송
		        $("#pbancUpdate").submit();
		        Toast.fire({
		            icon: 'success',
		            title: '등록 완료!',
                    customClass: {
                        popup: 'my-custom-popup' // CSS에서 정의한 클래스 이름
                    }
                }).then(() => {
                	location.href = "/enter/pbanc?entId=" + entId;
		        });
		    } else {
		        // 수정 취소 시
		        Toast.fire({
		            icon: 'error',
		            title: '등록 취소!'
		        });
		    }
		});
    });
	// 공고 수정 -> 공고 저장 버튼 sweet alert 적용 끝 ------------------------------------------------------


})
function loginAlert(){
	alert("로그인 후 이용가능합니다.");
	location.href="/security/login";
}
</script>

</head>
<link rel="stylesheet"
	href="<%=request.getContextPath()%>/resources/css/enter/pbancDetail.css" />
<script type="text/javascript" src="/resources/js/jquery.min.js"></script>
<body>
		<sec:authentication property="principal" var="prc" />
	<c:if test="${prc ne 'anonymousUser'}">
		<input type="hidden" id="hasRoleEnter" value="${prc.authorities}" />
	</c:if>
	<div class="pbancDetailContainer">
		<!-- 채용 정보 헤더 -->
		<header class="job-header">
			<h2>채용정보</h2>
			<c:if test="${prc  ne 'anonymousUser'}">
				<c:if test="${prc.authorities eq '[ROLE_ENTER]'}">
					<div class="up-del-btn">
						<button type="button" class="btnDel" id="btnDel">공고 삭제</button>
						<button type="button" class="btnUp" id="update-btn">공고 수정</button>
					</div>
				</c:if>
			</c:if>
		</header>
		<!-- 채용 정보 요약 -->
		<section class="job-summary">
			<hr class="hr">
			<input type="hidden" id="pbancNo" value="${pbancDetailList.pbancNo}" />
			<input type="hidden" id="entId" value="${pbancDetailList.entId}" />
			<h5>${pbancDetailList.entNm}</h5>
			<h4>${pbancDetailList.pbancTtl}</h4>
			<hr class="hrhr">
			<div class="summary">
				<div class="form-group">
					<div class="left-1">
						<p class="left">지원자격</p>
					</div>
					<div class="left-2">
						<p class="p-size-left">경력</p>
						<p class="p-size-right">${pbancDetailList.pbancCareerCdNm}</p>
					</div>
					<div class="left-2">
						<p class="p-size-left">학력</p>
						<p class="p-size-right">${pbancDetailList.pbancAplctEduCdNm}</p>
					</div>
					<div class="left-2">
						<p class="p-size-left">성별</p>
						<p class="p-size-right">${pbancDetailList.pbancGenCdNm}</p>
					</div>
				</div>
				<div class="form-group">
					<div class="left-1">
						<p class="left">근무조건</p>
					</div>
					<div class="left-2">
						<p class="p-size-left">지역</p>
						<p class="p-size-right">${pbancDetailList.powkNm}</p>
					</div>
					<div class="left-2">
						<p class="p-size-left">급여</p>
						<p class="p-size-right">${pbancDetailList.pbancSalaryNm}</p>
					</div>
					<div class="left-2">
						<p class="p-size-left">근무형태</p>
						<p class="p-size-right">${pbancDetailList.pbancWorkstleCdNm}</p>
					</div>
					<div class="left-2">
						<p class="p-size-left">근무시간</p>
						<p class="p-size-right">${pbancDetailList.pbancWorkHrCdNm}</p>
					</div>
				</div>
				<div class="form-group">
					<div class="left-1">
						<p class="left">채용 절차</p>
					</div>
					<div class="left-2">
						<p class="p-size-left">전형절차</p>
						<p class="p-size-right">${pbancDetailList.procssCdNm}</p>
					</div>
					<div class="left-2">
						<p class="p-size-left">지원서 양식</p>
						<p class="p-size-right">${pbancDetailList.pbancAppofeFormCdNm}</p>
					</div>
					<div class="left-2">
						<p class="p-size-left">지원 접수 방법</p>
						<p class="p-size-right">${pbancDetailList.pbancRcptMthdCdNm}</p>
					</div>
					<div class="left-2">
						<p class="p-size-left">지원 접수 기간</p>
						<p class="p-size-right">${pbancDetailList.pbancBgngDts} ~
							${pbancDetailList.pbancDdlnDts}</p>
					</div>
				</div>
			</div>
			<hr class="hr">
		</section>

		<!-- 지원 버튼 -->
		<div class="action-buttons">
			<c:if test="${prc ne 'anonymousUser'}">
				<input type="hidden" id="mbrId" name="mbrId" value="${prc.username}">
			</c:if>

			<!-- 스크랩 버튼 -->
			<input type="hidden" name="scrapped" id="scrapped"
				value="${scraped}" />
			<c:if test="${prc  ne 'anonymousUser'}">
			<button type="button" class="btn bookmark-btn" id="scrapBtn">
				<div>스크랩</div>
				<div id="scrapCount" style="text-align: center; font-size: 12px;">${scrapCount}</div>
			</button>
			<!-- 입사지원 버튼 -->
			<button type="button" class="btn apply-btn" id="applyBtn"
			data-toggle="modal" data-target="#modalAplct"
			data-pbanc-no="${pbancDetailList.pbancNo}"
                     	data-mbr-id="${applicantVO.mbrId}"
                     	data-ent-nm="${pbancDetailList.entNm}"
                     	data-pbanc-ttl="${pbancDetailList.pbancTtl}"
			>입사지원</button>
			</c:if>
			<c:if test="${prc  eq 'anonymousUser'}">
			<button type="button" class="btn bookmark-btn" id="scrapBtn" onclick="loginAlert()">
				<div>스크랩</div>
				<div id="scrapCount" style="text-align: center; font-size: 12px;">${scrapCount}</div>
			</button>
			<!-- 입사지원 버튼 -->
			<button type="button" class="btn apply-btn" id="applyBtn" onclick="loginAlert()"
			data-toggle="modal" data-target="#modalAplct"
			data-pbanc-no="${pbancDetailList.pbancNo}"
                     	data-mbr-id="${applicantVO.mbrId}"
                     	data-ent-nm="${pbancDetailList.entNm}"
                     	data-pbanc-ttl="${pbancDetailList.pbancTtl}"
			>입사지원</button>
			</c:if>
		</div>
		<button id="topBtn" class="top-btn" style="display:none; position:fixed; bottom:20px; right:260px;">TOP ▲</button>		
		<!-- 탭 메뉴 -->
		<nav class="tab-menu">
			<button type="button" class="tab-btn">상세정보</button>
			<button type="button" class="tab-btn">접수기간</button>
			<button type="button" class="tab-btn">기업정보</button>
		</nav>
		
		<form name="pbancUpdate" id="pbancUpdate" method="post" enctype="multipart/form-data">
		
		 <input type="hidden" name="pbancNo" value="${pbancDetailList.pbancNo}">
		<!-- 상세 정보 섹션 -->
		<section class="job-details">
			<!-- 이미지 미리보기 -->
			<c:if test="${pbancDetailList.pbancImgFile==null}">
				<img id="companyImg" class="company-img-header"
					src="/resources/images/member/기본프로필.png" alt="공고"/>
			</c:if>
			<c:if test="${pbancDetailList.pbancImgFile!=null}">
				<img id="companyImg" class="company-img-header"
					src="${pbancDetailList.pbancImgFilePath}" alt="${pbancDetailList.pbancImgFile}" name="pbancImgFile"/>
				</c:if>
			<!-- 파일 업로드 요소 -->
			<div class="upload">
				<div class="file-upload-section" style="display: none;">
	    			<input type="file" id="imageUpload"  name="entPbancFile"/>
	    			<input type="hidden" name="pbancImgFile" value="${pbancDetailList.pbancImgFile}"/>
				</div>
			</div>

			
			<div class="detail-content" >
				<div id="ttlPbanc">
					<h6 class="job-det-h7">
						<img class="check-img" src="../resources/icon/check_circle.png">&nbsp;공고 제목
					</h6>
					<div style="flex-direction: column;">   
						<div>
							<input type="text" value="${pbancDetailList.pbancTtl}"	class="detail-ta" name="pbancTtl" id="pbancTtl" required/>
						</div>
						<div>
							<div class="error-msg"></div>
						</div>
					</div>
				</div>
				<h6 class="job-det-h7">
					<img class="check-img" src="../resources/icon/check_circle.png">&nbsp;공고 내용
				</h6>
					<div style="flex-direction: column;">   
						<div>				
							<textarea name="pbancCn" rows="auto" cols="110" class="detail-ta" id="pbancCn" required>${pbancDetailList.pbancCn}</textarea>
						</div>
						<div>
							<div class="error-msg"></div>
						</div>
					</div>
				
				<h6 class="job-det-h7">
					<img class="check-img" src="../resources/icon/check_circle.png">&nbsp;모집분야 및 담당 업무
				</h6>
				<div class="con-flex">
					<div class="con-left1">
						<div class="det-content">
							<p class="detail-p">ㆍ 경력여부</p>
								<select class="input-detail" name="pbancCareerCd" required>
									<c:forEach var="pbancVO" items="${getRecruitmentCD}" varStatus="status">
										<option value="${pbancVO.comCode}"
											<c:if test="${pbancVO.comCodeNm eq pbancDetailList.pbancCareerCdNm}">selected</c:if>										
										>${pbancVO.comCodeNm}</option>
									</c:forEach>
								</select>	
						</div>
						<div class="det-content">
							<p class="detail-p">ㆍ 모집분야명</p>
							<input type="text" value="${pbancDetailList.rcritNm}" class="input-detail" name="rcritNm" required/>
						</div>
						<div class="det-content">
							<p class="detail-p">ㆍ 모집인원</p>
							<input type="text" value="${pbancDetailList.rcritCnt}" class="input-detail" name="rcritCnt" required/>
						</div>
						<div class="det-content">
							<p class="detail-p">ㆍ 모집업종</p>
								
								<!-- 기본/취소모드에서 보이는 모집업종 -->
								<div id="pbancTpbizCd">
									<input type="text" value="${pbancDetailList.tpbizCd}" class="input-detail"/>
								</div>
								
								<!-- 수정모드에서 보이는 모집업종 -->
								<select class="input-detail" id="tpbizCd" name="tpbizCdList" multiple required>
									<c:forEach var="pbancVO" items="${getTpbizCD}" varStatus="status">
										<option value="${pbancVO.comCode}"
										<c:forEach var="tpbizCd" items="${tpbizCdList}">
											<c:if test="${pbancVO.comCodeNm eq tpbizCd}">selected</c:if>
										</c:forEach>
										>${pbancVO.comCodeNm}</option>
									</c:forEach>
								</select>	
						</div>

					</div>
					<div class="con-right1">
						<div class="det-content">
							<p class="detail-p">ㆍ 담당업무</p>
							<input type="text" value="${pbancDetailList.rcritTask}" class="input-detail" name="rcritTask"/>
						</div>
						<div class="det-content">
							<p class="detail-p">ㆍ 직급/직책</p>
							<select class="input-detail" name="rcritJbttlCd" required>
								<c:forEach var="pbancVO" items="${getRcritJbttlCD}" varStatus="status">
									<option value="${pbancVO.comCode}"
										<c:if test="${pbancVO.comCodeNm eq pbancDetailList.rcritJbttlCdNm}">selected</c:if>
									>${pbancVO.comCodeNm}</option>
								</c:forEach>
							</select>								
						</div>
						<div class="det-content">
							<p class="detail-p">ㆍ 근무부서</p>
							<input type="text" value="${pbancDetailList.rcritDept}" class="input-detail" name="rcritDept"/>
						</div>
						<div class="det-content">
							<p class="detail-p">ㆍ 근무지역</p>
							<!-- 기본모드에서 보이는 근무지역 -->
							<input type="text" value="${pbancDetailList.powkNm}" id="powk-input" class="input-detail"/>
							<!-- 수정모드에서 보이는 근무지역 -->
							<select class="input-detail" id="powkCd" name="powkList" multiple required>
								<c:forEach var="pbancVO" items="${powkCdList}" varStatus="status">
									<option value="${pbancVO.comCode}"
									<c:forEach var="powkCd" items="${powkList}">
										<c:if test="${pbancVO.comCodeNm eq powkCd}">selected</c:if>
									</c:forEach>
									>${pbancVO.comCodeNm}</option>
								</c:forEach>
							</select>							
						</div>						
						
					</div>
				</div>

				<h6 class="job-det-h7">
					<img class="check-img" src="../resources/icon/check_circle.png">&nbsp;자격/조건
				</h6>
				<div class="con-flex">
					<div class="con-left1">
						<div class="det-content">
							<p class="detail-p">ㆍ 지원자 학력</p>
							<select class="input-detail" name="pbancAplctEduCd" required>
								<c:forEach var="pbancVO" items="${getPbancEduCD}" varStatus="status">
									<option value="${pbancVO.comCode}"
										<c:if test="${pbancVO.comCodeNm eq pbancDetailList.pbancAplctEduCdNm}">selected</c:if>
									>${pbancVO.comCodeNm}</option>
								</c:forEach>
							</select>									
						</div>
						<div class="det-content">
							<p class="detail-p">ㆍ 지원자 성별</p>
							<select class="input-detail" name="pbancGenCd">
								<c:forEach var="pbancVO" items="${getPbancGenCD}" varStatus="status">
									<option value="${pbancVO.comCode}"
										<c:if test="${pbancVO.comCodeNm eq pbancDetailList.pbancGenCdNm}">selected</c:if>
									>${pbancVO.comCodeNm}</option>
								</c:forEach>
							</select>						
						</div>
						<div class="det-content">
							<p class="detail-p">ㆍ 지원자 연령</p>
							<select class="input-detail" name="pbancAgeCd">
								<c:forEach var="pbancVO" items="${getPbancAgeCD}" varStatus="status">
									<option value="${pbancVO.comCode}"
										<c:if test="${pbancVO.comCodeNm eq pbancDetailList.pbancAgeCdNm}">selected</c:if>
									>${pbancVO.comCodeNm}</option>
								</c:forEach>
							</select>						
						</div>
					</div>
					<div class="con-right1">
						<div class="det-content">
							<p class="detail-p">ㆍ 연봉/급여</p>
							<select class="input-detail" name="pbancSalary" required>
								<c:forEach var="pbancVO" items="${getPbancSalaryCD}" varStatus="status">
									<option value="${pbancVO.comCode}"
										<c:if test="${pbancVO.comCodeNm eq pbancDetailList.pbancSalaryNm}">selected</c:if>
									>${pbancVO.comCodeNm}</option>
								</c:forEach>
							</select>						
						</div>
						<div class="det-content">
							<p class="detail-p">ㆍ 근무형태</p>
							<select class="input-detail" name="pbancWorkstleCd" required>
								<c:forEach var="pbancVO" items="${getPbancWorkstleCD}" varStatus="status">
									<option value="${pbancVO.comCode}"
										<c:if test="${pbancVO.comCodeNm eq pbancDetailList.pbancWorkstleCdNm}">selected</c:if>
									>${pbancVO.comCodeNm}</option>
								</c:forEach>
							</select>								
						</div>
						<div class="det-content">
							<p class="detail-p">ㆍ 근무요일</p>
							<select class="input-detail" name="pbancWorkDayCd">
								<c:forEach var="pbancVO" items="${getPbancWorkDayCD}" varStatus="status">
									<option value="${pbancVO.comCode}"
										<c:if test="${pbancVO.comCodeNm eq pbancDetailList.pbancWorkDayCdNm}">selected</c:if>
									>${pbancVO.comCodeNm}</option>
								</c:forEach>
							</select>							
						</div>
						<div class="det-content">
							<p class="detail-p">ㆍ 근무시간</p>
							<select class="input-detail" name="pbancWorkHrCd">
								<c:forEach var="pbancVO" items="${getPbancWorkHrCD}" varStatus="status">
									<option value="${pbancVO.comCode}"
										<c:if test="${pbancVO.comCodeNm eq pbancDetailList.pbancWorkHrCdNm}">selected</c:if>
									>${pbancVO.comCodeNm}</option>
								</c:forEach>
							</select>									
						</div>
					</div>
				</div>
				<div>
					<h6 class="job-det-h7">
						<img class="check-img" src="../resources/icon/check_circle.png">&nbsp;필수/우대 조건
					</h6>
					<!-- /////////////////////////////필수조건//////////////////////////////// -->
					<div class="con-flex">
						<div class="con-left10">
							<div>
								<p class="detail-p">ㆍ 필수 조건</p>
							</div>
							<!-- 기본모드에서 보이는 필수조건 -->
							<div class="required-basic">
								<c:forEach var="requiredCn" items="${requiredList}">
									<div id="required" style="display: flex;align-items: center;">
										<div>-</div>
										<div>
										<input type="text" id="reCn" value="${requiredCn}" class="input-detail"/>
										</div>
									</div>
								</c:forEach>								
							</div>
							
							
							<!-- 수정모드에서 보이는 필수조건 -->
							<div class="div-required" style="display: none;">
								<div>
									<div style="display: flex;align-items: center;">
										<input type="text" id="requiredCn" class="input-detail" placeholder="예: 해당 직무 근무 경험">
										<button type="button" class="add-btn1">추가</button>
									</div>
										
									<div class="column3">
										<c:forEach var="requiredCn" items="${requiredList}">
											<div class="required-input-del">
											<input type="text" value="${requiredCn}" id="required-foreach" name="requiredCnList" class="input-detail" required/>
											<button class="delBtn4"><img class="delImg" src="../resources/icon/delete.png"></button>
											</div>
										</c:forEach>
									</div>								
									<div id="hiddenRequiredList"></div>
									<div id="dynamicList1"></div> 
								</div>
							</div>								
						</div>
						
						<!-- /////////////////////////////우대조건//////////////////////////////// -->
						<div class="con-right3">
								<div>
									<p class="detail-p" style="width: 180px;">ㆍ 우대 조건</p>
								</div>
								
								<!-- 기본모드에서 보이는 우대조건 -->
								<div class="prefer-basic"> 
									<c:forEach var="preferCn" items="${preferList}">
										<div id="prefer" style="display: flex;align-items: center;">
											<div>-</div>
											<div>
											<input type="text" id="prCn" value="${preferCn}" class="input-detail"/>
											</div>
										</div>
									</c:forEach>						
								</div>
								
		
								<!-- 수정모드에서 보이는 우대조건  -->
								<div class="div-prefer" style="display: none;">
									<div>
										<div style="display: flex;align-items: center;">
											<input type="text" id="preferCn" class="input-detail" placeholder="예: 해당 직무 근무 경험">
											<button type="button" class="add-btn2">추가</button>
										</div>
											
										<div class="column4">
											<c:forEach var="preferCn" items="${preferList}">
												<div class="prefer-input-del">
												<input type="text" value="${preferCn}" id="prefer-foreach" name="preferCnList" class="input-detail"/>
												<button class="delBtn5"><img class="delImg" src="../resources/icon/delete.png"></button>
												</div>
											</c:forEach>
										</div>								
										<div id="hiddenPreferList"></div>
										<div id="dynamicList2"></div> 
									</div>
								</div>					
		
		
						</div>
					</div>
				</div>
				
				
				
			<div>
				<h6 class="job-det-h7" style="margin-top: 50px;">
					<img class="check-img" src="../resources/icon/check_circle.png">&nbsp;채용절차
				</h6>

				<div class="con-flex">
					<div class="con-left1">
						<div class="det-content">
							<p class="detail-p">ㆍ 공고 대표 직무</p>
							<select class="input-detail" name="pbancRprsDty" required>
								<c:forEach var="pbancVO" items="${getTpbizCD}" varStatus="status">
									<option value="${pbancVO.comCode}"
										<c:if test="${pbancVO.comCodeNm eq pbancDetailList.pbancRprsDtyNm}">selected</c:if>
									>${pbancVO.comCodeNm}</option>
								</c:forEach>
							</select>						
						</div>
						<div id="reception-period" class="det-content">
							<p class="detail-p">ㆍ 지원 접수 기간</p>
							<input type="text"
								value="${pbancDetailList.pbancBgngDts} ~ ${pbancDetailList.pbancDdlnDts}"
								class="input-detail" id="dateText"/>
							<!-- 수정모드 시 지원 접수기간 : 시작일 -->
							<div class="dateInput"> 
								<input type="hidden" value="${pbancDetailList.pbancBgngDts}" name="pbancBgngDt" id="dateInput3" class="input-detail" style="display: none;"/>
								<input type="date" value="${pbancDetailList.pbancBgngDts}" name="pbancBgngDts" id="dateInput1" class="input-detail" style="display: none;" required/>
								<input type="hidden" value="${pbancDetailList.pbancDdlnDts}" name="pbancDdlnDt" id="dateInput4" class="input-detail" style="display: none;"/>
								<input type="date" value="${pbancDetailList.pbancDdlnDts}" name="pbancDdlnDts" id="dateInput2" class="input-detail" style="display: none;" required/>
							</div>
						</div>
						<div class="det-content" id="RcptMthdCd">
							<p class="detail-p">ㆍ 지원 접수 방법</p>
							<select class="input-detail" name="pbancRcptMthdCd" required>
								<c:forEach var="pbancVO" items="${getPbancRcptMthdCD}" varStatus="status">
									<option value="${pbancVO.comCode}"
										<c:if test="${pbancVO.comCodeNm eq pbancDetailList.pbancRcptMthdCdNm}">selected</c:if>
									>${pbancVO.comCodeNm}</option>
								</c:forEach>
							</select>								
						</div>
					</div>
					<div class="con-right1">
						<div class="det-content">
							<p class="detail-p">ㆍ 지원서 양식</p>
							<select class="input-detail" name="pbancAppofeFormCd" required>
								<c:forEach var="pbancVO" items="${getPbancAppofeFormCD}" varStatus="status">
									<option value="${pbancVO.comCode}"
										<c:if test="${pbancVO.comCodeNm eq pbancDetailList.pbancAppofeFormCdNm}">selected</c:if>
									>${pbancVO.comCodeNm}</option>
								</c:forEach>
							</select>								
						</div>
						<div class="det-content">
							<p class="detail-p">ㆍ 전형절차</p>
							<select class="input-detail" name="procssCd" required>
								<c:forEach var="pbancVO" items="${getProcssCD}" varStatus="status">
									<option value="${pbancVO.comCode}"
										<c:if test="${pbancVO.comCodeNm eq pbancDetailList.procssCdNm}">selected</c:if>
									>${pbancVO.comCodeNm}</option>
								</c:forEach>
							</select>								
						</div>
						<p class="detail-content"
							style="margin-left: 55px; margin-top: 30px; font-size: 16px;">
							* &nbsp;면접일정은 추후 통보됩니다.</p>
					</div>
				</div>
			</div>
				<div class="con-flex">
					<div class="con-left2">
						<h6 class="job-det-h7">
							<img class="check-img" src="../resources/icon/check_circle.png">&nbsp;복지
							및 혜택
						</h6>
						<!-- 기본모드에서 보이는 복지 및 혜택 -->
						<div class="favor-basic">
							<c:forEach var="favorCn" items="${favorList}">
								<div style="display: flex;align-items: center;">
									<div>-</div>
									<div>
									<input type="text" value="${favorCn}" class="input-detail"/>
									</div>
								</div>
							</c:forEach>
						</div>
						
						<!-- 수정모드에서 보이는 복지 및 혜택 -->
						<div class="div-favor" style="display: none;">
							<div>
								<div style="display: flex;align-items: center;">
									<input type="text" id="favor" class="input-detail" placeholder="예: 점심시간 3시간">
									<button type="button" class="add-btn3">추가</button>
								</div>
									
								<div class="column1">
									<c:forEach var="favorCn" items="${favorList}">
										<div class="favor-input-del">
										<input type="text" value="${favorCn}" id="favor-foreach" name="favorList" class="input-detail"/>
										<button class="delBtn1"><img class="delImg" src="../resources/icon/delete.png"></button>
										</div>
									</c:forEach>
								</div>								
										
								<div id="dynamicList3"></div> 
								<div id="hiddenFavorList"></div>
							</div>
						</div>						
					</div>
					<div class="con-right2">
						<h6 class="job-det-h7">
							<img class="check-img" src="../resources/icon/check_circle.png">&nbsp;유의사항
						</h6>
						<p class="detail-content" style="font-size: 16px;">* 허위 사실이
							발견될 경우 채용이 취소될 수 있습니다.</p>
					</div>
				</div>
			</div>
		</section>


		<!-- 기업 정보 요약 -->
		<section class="job-summary">
			<hr class="hr">
			<div class="summary">
				<div class="form-group2">
					<div class="sum-flex">
						<div>
							<div class="left-1" style="display: flex; justify-content: space-between;align-items: center;">
								<div>
									<p class="left">${pbancDetailList.entNm}</p>
								</div>
								<div>
									<button type="button" class="dis-btn">
									  <img class="distance-img" src="../resources/icon/distance.png"/>위치보기
									</button>
								</div>
							</div>
							<div class="left-2">
								<img class="sum-img" src="${pbancDetailList.entLogo}" />
							</div>
						</div>

					</div>
				</div>
				<div class="form-group3">
					<div id="company-info" class="left-1">
						<p class="left">기업정보</p>
					</div>
					<div class="all-all">
						<div class="all">
							<div class="left-com">
								<div class="left-2">
									<p class="p-size-left">업종</p>
									<p class="p-size-right">${pbancDetailList.tpbizSeCdNm}</p>
								</div>
								<div class="left-2">
									<p class="p-size-left">사원 수</p>
									<p class="p-size-right">${pbancDetailList.entEmpCnt}명</p>
								</div>
								<div class="left-2">
									<p class="p-size-left">기업형태</p>
									<p class="p-size-right">${pbancDetailList.entStleCdNm}</p>
								</div>
								<div class="left-2">
									<p class="p-size-left">설립일자</p>
									<p class="p-size-right">${pbancDetailList.entFndnYmd}</p>
								</div>
							</div>
							<div class="right-com">
								<div class="left-2">
									<p class="p-size-left">홈페이지</p>
									<p class="p-size-right">${pbancDetailList.entHmpgUrl}</p>
								</div>
								<div class="left-2">
									<p class="p-size-left">대표자명</p>
									<p class="p-size-right">${pbancDetailList.entRprsntvNm}</p>
								</div>
								<div class="left-2">
									<p class="p-size-left">팩스번호</p>
									<p class="p-size-right">${pbancDetailList.entFxnum}</p>
								</div>
							</div>
						</div>
						<div class="form-group4">
							<a href="/enter/profile?entId=${pbancDetailList.entId}" class="pro-btn"><img class="company-img"
								src="../resources/icon/profile.png">profile</a> <a href="${pbancDetailList.entHmpgUrl}"
								class="pro-btn1"><img class="company-img"
								src="../resources/icon/homepage.png">homepage</a>
						</div>
					</div>
				</div>
			</div>
			<hr class="hr">
		</section>
		<div style="display: flex; justify-content: flex-end;">
			<div class="can-sub-btn" style="display: none;">
				<button type="button" class="btncan">취소</button>
				<button type="submit" class="btnsub" id="btnsub">저장</button>
			</div>
		</div>
		<sec:csrfInput />
	</form>
	</div>
<!-- ////////////////// 카카오맵 모달 시작 //////////////////// -->
<!-- 위치보기 모달 -->
<div id="distanceModal" class="modal" style="display: none; z-index: 999;">
	<div class="modal-content">
		<div style="display: flex; justify-content: space-between; margin-bottom: 30px;">
			<h2>${pbancDetailList.entNm}</h2>
			<span class="close">&times;</span>
		</div>

			<label for="title">${pbancDetailList.entAddr}</label>
			<div id="staticMap" class="map" style="width: 650px; height: 330px;"></div>
	</div>
</div>



	<!-- ////////////////// 입사지원 모달 시작 //////////////////// -->
<div class="modal fade" id="modalAplct">
  <div class="modal-dialog" style="bottom: -27px; right: 50px;top:unset;left:unset;">
    <div class="modal-content modal-aplcontent" style="border:none; border-radius: 20px 20px 0px 0px;
				padding: 0px 5px 0px 5px; margin:0px; width:450px; height:800px;">
     <form id="OkForm" action="/member/aplctAdd?${_csrf.parameterName}=${_csrf.token}" method="post" enctype="multipart/form-data"> <!-- form 시작 -->
      <div class="modal-aplheader">
      	<div class="pbancInfo">
	      	<input type="text" name="entNm" id="aplModalEntNm" value="${pbancDetailList.entNm}"readonly/>
	      	<input type="text" name="propseTtl" id="aplModalpbnTtl" value="${pbancDetailList.pbancTtl}" readonly/>
	    	<div style="font-size: 12px; color: #666363;">	
		    	<span id="pbancCareerCdNm" style="margin-left: 3px;">${pbancDetailList.pbancCareerCdNm}</span>&nbsp;&nbsp;|&nbsp;&nbsp;
		    	<span id="pbancAplctEduCdNm">${pbancDetailList.pbancAplctEduCdNm}↑</span>&nbsp;&nbsp;|&nbsp;&nbsp;
		    	<span id="pbancWorkstleCdNm">${pbancDetailList.pbancWorkstleCdNm}</span>
		    	<span id="pbancCityNm">${pbancDetailList.pbancCityNm}</span>
		    	<span id="pbancRprsrgnNm">${pbancDetailList.pbancRprsrgnNm}</span>
      		</div>
      	</div>
      </div>
      <hr style="width: 90%;">
	      <button type="button" class="close" data-dismiss="modal" aria-label="Close" 
	      style="position: relative; bottom: 120px;right: 20px;cursor: pointer;">
          	<span aria-hidden="true">&times;</span>
          </button>
      <div class="modal-body" style="max-height:432px; margin:0px;">
        <p id="propseBox">
           <input type="hidden" id="aplModalMbrId" value="${priVO.mbrId}"/>
           <input type="hidden" id="aplModalpbancNo" value="${pbancDetailList.pbancNo}"/>
           <input type="hidden" id="selectedResumeName" id="rsmTtl" name="rsmTtl" />   
           <input type="hidden" id="selectedResumeNo" name="rsmNo" />   
               <div class="file" style="margin:0px;">
               	<div style="margin-left: 2px;">
               		<label for="rcritNm" id="rcritNmLb">지원분야</label>
               		<input type="text" id="rcritNm" value="${pbancDetailList.rcritNm}" readonly/>
                </div>		
               		<br>
               	<div class="fileHead">
               		<p id="headcont1">선택된 이력서</p>
               		<p id="headcont1-1" data-toggle="modal" data-target="#selectResumeModal">불러오기 ></p>
               	</div>      
               	<div class="box_inner">
	  				    <input type="text" id="resumeFile" name="resumeFile" placeholder="선택된 이력서가 없습니다." readonly />
               		<br>
               		<div id="paper">
                		<span class="material-symbols-outlined papericon">clinical_notes</span>
                		<p class="miniInfo">이력서 수정은 이력서 관리페이지에서 가능합니다.</p>
               		</div>
               	</div>  
               	        
               </div>
               <div class="file" style="margin-top: 10px;">
               	<div class="fileHead">
               		<p id="headcont2">파일 첨부</p><p id="headcont2-1">파일 첨부 +</p>
               		<input class="custom-file-input" type="file" id="uploadFile" name="uploadFile" multiple style="display:none;"/>
               	
               	</div>      
               	<div class="box_inner">
		  				<input type="text" id="uploadFileName" name="uploadFileName" placeholder="선택된 파일이 없습니다." readonly />
               		<br>
               		<div id="paper">
                		<span class="material-symbols-outlined papericon">clinical_notes</span>
                		<p class="miniInfo">추가 파일을 첨부해주세요.</p>
               		</div>
               	</div>  
               	        
               </div>
              <br>
           <p id="info">제출서류는 90일까지 지원기업에게 제공됩니다. </p><br>
		   <p style="font-size: 12px; color: #666; 
		      margin-top: -15px; padding: 0px 10px 0px 10px;">채용절차법상, Ready Go 홈페이지로 제출한 경우이므로 채용 서류는 별도로 반환하지 않으며, 구인사는 채용이 종료되는 경우 개인정보보호법을 준수하여 채용 서류를 즉시 파기합니다.</p>
      </div>
        <button type="submit" id="aplctSubmit">서류 제출(수락)</button>
		<sec:csrfInput />
      </form>
    </div>
    <!-- /.modal-content -->
  </div>
  <!-- /.modal-dialog -->
</div>
<!-- /.modal -->


<!-- ////////////////// 이력서 선택 모달 //////////////////// -->
<div class="modal fade" id="selectResumeModal" tabindex="-1" role="dialog" aria-labelledby="selectResumeModalLabel" aria-hidden="true">
  <div class="modal-dialog" style="position: fixed;bottom: 172px;right: 50px;top:unset;left:unset;">
    <div class="modal-content mini-content" style="width:450px; height:600px; margin:0px; border:none; padding:0px; border-radius: 20px 20px 0px 0px;">
      <div class="modal-header mini-header">
        <h5 class="modal-title" id="selectResumeModalLabel">이력서 선택</h5>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <div class="modal-body mini-body">
        <form id="resumeSelectForm">
          <div id="resumeCheckList">
            <c:forEach var="resumeVO" items="${selectResumeVOList}">
              <div class="form-check">
              		<div id="rsmDate">
					    <c:if test="${resumeVO.rsmRlsscopeCd == 'RERE01'}">
				       		 <span class="firRsume">대표 이력서</span><br>
				        </c:if>
						<fmt:parseDate value="${resumeVO.rsmWrtYmd}" var="rsmWrtYmd" pattern="yyyy-MM-dd HH:mm:ss.S" />
						<fmt:formatDate value="${rsmWrtYmd}" pattern="yyyy.MM.dd (EEE) HH:mm 작성" /><br>
					</div>
				<input class="form-check-input resume-check" name="rsmTtl" type="checkbox" value="${resumeVO.rsmTtl}" data-rsm-no="${resumeVO.rsmNo}">
                <span class="material-symbols-outlined papericon minicon">clinical_notes</span>
                <label class="form-check-label" for="resume-${resumeVO.rsmNo}">
                  ${resumeVO.rsmTtl}
                </label>
              </div>
            </c:forEach>
          </div>
        </form>
      </div>
        <button type="button" class="btn btn-primary mini-Btn" id="selectOK">선  택</button>
      </div>
    </div>
  </div>
  
</body>
</html>