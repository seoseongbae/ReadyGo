<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec"%>
<sec:authorize access="isAuthenticated()">
	<sec:authentication property="principal.memVO" var="memVO" />
</sec:authorize>

<script src="https://cdn.jsdelivr.net/npm/sweetalert2@10"></script>
<link rel="stylesheet" href="<%=request.getContextPath()%>/resources/css/alert.css" />
<!-- 외주 css 파일 -->
<link rel="stylesheet"
	href="<%=request.getContextPath()%>/resources/css/outsou/regist.css" />
<!-- ckeditor -->
<script type="text/javascript" src="/resources/ckeditor5/ckeditor.js"></script> 
<script type="text/javascript" src="/resources/js/jquery.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sockjs-client@1/dist/sockjs.min.js"></script><!-- 웹소켓 -->
<script type="text/javascript">
var Toast = Swal.mixin({
	toast: true,
	position: 'center',
	showConfirmButton: false,
	timer: 3000
	});


//이미지 처리 함수 
function HandleImg(e, targetElement) {
    let files = e.target.files; // 선택한 파일들
    let fileArr = Array.prototype.slice.call(files); // 배열로 변환
    let accumStr = "";

    fileArr.forEach(function(f) {
        // 이미지가 아니면
        if (!f.type.match("image.*")) {
            alert("이미지 확장자만 가능합니다.");
            return;
        }

        // 이미지일 경우 처리
        let reader = new FileReader();
        reader.onload = function(e) {
            accumStr += "<img src='" + e.target.result + "' style='width: 220px; height:180px; border: 1px solid #CED4DA;'>";
            $(targetElement).html(accumStr); // targetElement로 지정된 곳에 이미지 표시
        };
        reader.readAsDataURL(f);
    });
}

$(function(){
	console.log("개똥이");
	
	
	//이미지  미리보기 시작///
	$("#mainFile").on('change', function(e) {
    HandleImg(e, "#mainpImg");
	});
	
	$("#detailFile").on('change', function(e) {
	    HandleImg(e, "#detpImg");
	});
	//이미지 미리보기 끝///
	
	//1차 선택에 따라 2차 카테고리 가져오기 시작 
	$("select[name='outordLclsf']").on("change", function(){
		let category1 = $(this).val(); // 선택한 1차 카테고리 값
	    console.log("category1 : ", category1);
		
	 // 1차 카테고리 값이 'OUCL01'인 경우에 특정 폼 그룹을 보여주고 숨김
	    if (category1 == 'OULC01') {
	    	$(".form-group4").show();//IT
	        $(".form-group3").hide();//자기소개서
	        $(".category2_3").show();//작업기간
	        $(".category2_4").show();//작업기간
	        
		} else {
			$(".form-group4").hide();//IT
	        $(".form-group3").show();//자기소개서
	        $(".category2_3").hide();//작업기간
	        $(".category2_4").hide();//작업기간
		} 
	 	
	 	// 보낼 데이터 (JSON 형식)
	    let data = {
	        "comCode": category1 // 선택한 1차 카테고리 값을 'comCode'로 서버에 보냄
	    };
	 	
	 // 2차 카테고리를 가져오기 위한 AJAX 요청 시작
	    $.ajax({
	        url: "/outsou/category2",  // 2차 카테고리 데이터를 가져오는 컨트롤러 메소드의 URL
	        contentType: "application/json;charset=utf-8",  // 보내는 데이터의 타입
	        data: JSON.stringify(data),  // JSON 데이터를 문자열로 변환해서 전송
	        type: "POST",  // POST 요청 방식
	        dataType: "json",  // 서버에서 받을 데이터 타입을 JSON으로 지정
	        beforeSend: function(xhr) {
	            // CSRF 토큰 전송 (보안 관련)
	            xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
	        },
	        success: function(result) {
	            // 서버에서 받은 2차 카테고리 데이터를 처리
	            console.log("result : ", result);
	            
	            // 2차 카테고리 select 박스를 초기화
	            $("#outordMlsfc").html("<option value='' selected disabled>선택해주세요</option>");
	            
	            // 서버에서 받은 데이터로 2차 카테고리 옵션을 동적으로 생성하여 추가
	            $.each(result, function(idx, codeVO) {
	                let option = "<option value='" + codeVO.comCode + "'>" + codeVO.comCodeNm + "</option>";
	                $("#outordMlsfc").append(option);
	            });
	        },
	        error: function(error) {
	            console.log("Error:", error);  // 에러 처리
	        }
	    });
	 
	})
	//1차 선택에 따라 2차 카테고리 가져오기 끝 
	
	//카워드 추가하는 부분 시작 
	var maxKeywords = 5;

	// 키워드 추가 로직
	$(".Keyword__add").on("click", function() {
	    let keyword = $("#kwrdtext").val().trim();  // 입력 필드에서 키워드를 가져옴
	    let currentKeywordsCount = $('.keywordItem').length;  // 현재 추가된 키워드 개수 확인
	    
	    if (currentKeywordsCount >= maxKeywords) {
	    	Toast.fire({
                icon: 'error',
                title: '최대 ' + maxKeywords + '개의 키워드만 추가할 수 있습니다'
            });
	        return;  // 키워드가 최대 개수를 초과하면 추가하지 않음
	    }
	
	    if (keyword !== "") {
	        // 중복 키워드 방지
	        let existingKeywords = $('.keywordItem').map(function() {
	            return $(this).find('input[name="kwrdNm"]').val();
	        }).get();
	
	        if (existingKeywords.includes(keyword)) {
	        	Toast.fire({
	                icon: 'error',
	                title: '중복된 키워드입니다.'
	            });
	            return;
	        }
	
	        // 키워드 추가
	        var keywordElement = '<div class="keywordItem" style="margin: 5px;">' +
	                             '<input type="text" name="kwrdNm" value="' + keyword + '" style="display : none;" />' +
	                             '<span class="kwrdNm">' + keyword + '</span>' +
	                             '<button type="button" class="deleteKeyword">x</button>' +
	                             '</div>';
	        $('.KeywordtextAdd').append(keywordElement);
	
	        // 입력 필드 초기화
	        $("#kwrdtext").val('');
	    } else {
	        alert('키워드를 입력해주세요.');
	    }
	});
	
	// 키워드 삭제 로직
	$(document).on('click', '.deleteKeyword', function() {
	    $(this).closest('.keywordItem').remove();  // 화면에서 해당 키워드 삭제
	});


	//카워드 추가하는 부분 끝
	
	//언어, 클라우드, 데이터베이스 부분 어떤 걸 선택했느지 보기 시작 
	
	//언어
    $('#osDevalVO\\.osdeLangVOList\\.srvcLangCd').on('change', function() {
        let selected = $(this).find('option:selected').map(function() {
            return $(this).text(); // 선택된 옵션의 텍스트 가져오기
        }).get().join(', ');

        if (selected) {
            $("#Lang").text(selected).show(); // 선택한 항목을 표시하고 영역을 보여줌
        } else {
            $("#Lang").hide(); // 선택된 값이 없으면 숨김
        }
    });
	
	
  //데이터 베이스
    $('#osDevalVO\\.osdeDatabaseVOList\\.srvcDatabaseCd').on('change', function() {
        let selected = $(this).find('option:selected').map(function() {
            return $(this).text(); // 선택된 옵션의 텍스트 가져오기
        }).get().join(', ');

        if (selected) {
            $("#Database").text(selected).show(); // 선택한 항목을 표시하고 영역을 보여줌
        } else {
            $("#Database").hide(); // 선택된 값이 없으면 숨김
        }
    });
  
  //쿨라우드
    $('#osDevalVO\\.osdeCludVOList\\.srvcCludCd').on('change', function() {
        let selected = $(this).find('option:selected').map(function() {
            return $(this).text(); // 선택된 옵션의 텍스트 가져오기
        }).get().join(', ');

        if (selected) {
            $("#Clud").text(selected).show(); // 선택한 항목을 표시하고 영역을 보여줌
        } else {
            $("#Clud").hide(); // 선택된 값이 없으면 숨김
        }
    });
	
	
	//언어, 클라우드, 데이터베이스 부분 어떤 걸 선택했느지 보기 끝
	
	
	
	//저장하기 시작 
	$("#savebtn").on("click",function(){
		console.log("왔다.");
		
		//유효성 검사 시작
		//제목 검사
		if($("#outordTtl").val().trim().length < 1 || $("#outordTtl").val().trim().length > 30 ){
			Toast.fire({
		        icon: 'warning',
		        title: '제목을 입력해주세요.'
		    });
			$('#outordTtl').focus();
		    event.preventDefault();
		    return false;
		}
		
		// 대분류 -> select box
		if (!$("#outordLclsf").val()) {  // 선택된 값이 없으면
		    Toast.fire({
		        icon: 'warning',
		        title: '대분류를 선택해주세요'
		    });
		    $('#outordLclsf').focus();
		    event.preventDefault();
		    return false;
		}
		
		
		//중분류 
		if(!$("#outordMlsfc").val() ){
		   Toast.fire({
		        icon: 'warning',
		        title: '중분류를 선택해주세요'
		    });
		    $('#outordMlsfc').focus();
		    event.preventDefault();
		    return false;
		}
		
		//금액
		if ($("#outordAmt").val().trim() < 10000) {
		    Toast.fire({
		        icon: 'warning',
		        title: '금액은 10,000원 이상입력해주세요.'
		    });
		    $('#outordAmt').focus();
		    event.preventDefault();
		    return false;
		}
		
		//금액 설명
// 		if (¡$("#outordAmtExpln").val()) {
// 		    Toast.fire({
// 		        icon: 'warning',
// 		        title: '금액 설명을 입력해주세요.'
// 		    });
// 		    $('#outordAmtExpln').focus();
// 		    event.preventDefault();
// 		    return false;
// 		}
		
		//서비스 설명
		if (!$("#outordExpln").val()) {
		    Toast.fire({
		        icon: 'warning',
		        title: '서비스 설명을 입력해주세요.'
		    });
		    $('#outordExpln').focus();
		    event.preventDefault();
		    return false;
		}
		
		//서비스 제공절차
		if (!$("#outordProvdprocss").val()) {
		    Toast.fire({
		        icon: 'warning',
		        title: '서비스 제공절차를 입력해주세요.'
		    });
		    $('#outordProvdprocss').focus();
		    event.preventDefault();
		    return false;
		}
		
		//환불규정
		if (!$("#outordRefndregltn").val()) {
		    Toast.fire({
		        icon: 'warning',
		        title: '환불규정을 입력해주세요.'
		    });
		    $('#outordRefndregltn').focus();
		    event.preventDefault();
		    return false;
		}
		
		
		//메인 이미지
		if ($("#mainFile")[0].files.length === 0) { 
		    Toast.fire({
		        icon: 'warning',
		        title: '메인이미지를 등록해주세요.'
		    });
		    $('#mainFile').focus();
		    event.preventDefault();
		    return false;
		}
		
		//작업전 요청사항
		if (!$("#outordDmndmatter").val()) {
		    Toast.fire({
		        icon: 'warning',
		        title: '환불규정을 입력해주세요.'
		    });
		    $('#outordDmndmatter').focus();
		    event.preventDefault();
		    return false;
		}
		//유효성 검사 끝
		
		
		
		let formData = new FormData();
		
		//데이터 정보 불러오기 및 저장하시 시작 
		
		let mbrId = $("input[value='${memVO.mbrId}']").val();
    	console.log("아이디:",mbrId);
    	//제목
    	let outordTtl = $("input[name='outordTtl']").val();
    	console.log("제목:",outordTtl);
    	//대분류
    	let outordLclsf = $("select[name='outordLclsf']").val();
    	console.log("대분류:",outordLclsf);
    	//중분류
    	let outordMlsfc = $("select[name='outordMlsfc']").val(); // 중분류 값 가져오기
    	console.log("중분류:",outordMlsfc);
    	//기술수준 
    	let srvcLevelCd = $("select[name='osDevalVO.srvcLevelCd']").val();
    	console.log("기술수준:",srvcLevelCd);
    	//팀 규모
    	let srvcTeamscaleCd = $("select[name='osDevalVO.srvcTeamscaleCd']").val();
    	console.log("팀규모:",srvcTeamscaleCd);
    	//개발언어 
        $("select[name='osDevalVO.osdeLangVOList.srvcLangCd'] option:selected").each(function(index){
        	console.log("선택된 언어 의 value : " + $(this).attr('value'));
		//this : select 자식들인 선택된 option들 중에서 반복  된 바로 그 option
        	 formData.append("osDevalVO.osdeLangVOList["+index+"].srvcLangCd", $(this).attr('value'));  // 하나씩 저장
       	});
      	//데이터 베이스
        $("select[name='osDevalVO.osdeDatabaseVOList.srvcDatabaseCd'] option:selected").each(function(index){
        	console.log("선택된 데이터베이스 의 value : " + $(this).attr('value'));
		//this : select 자식들인 선택된 option들 중에서 반복  된 바로 그 option
       	 formData.append("osDevalVO.osdeDatabaseVOList["+index+"].srvcDatabaseCd", $(this).attr('value'));  // 하나씩 저장
       	});
      	//클라우드 
    	$("select[name='osDevalVO.osdeCludVOList.srvcCludCd'] option:selected").each(function(index){
        	console.log("선택된 클라우드 의 value : " + $(this).attr('value'));
		//this : select 자식들인 선택된 option들 중에서 반복  된 바로 그 option
            formData.append("osDevalVO.osdeCludVOList["+index+"].srvcCludCd", $(this).attr('value'));  // 하나씩 저장
       	});
    	//카테고리
    	// .keywordItem 내의 키워드들을 추출하여 배열에 담음
	    $("input[name='kwrdNm']").each(function(index, element) {
	        let keyword = $(element).val().trim();  // input 내 value 값을 추출
	        console.log("키워드의 value: " + keyword);
	        
	        if (keyword !== "") {
	            formData.append('kwrdNm', keyword);  // 각각의 키워드를 FormData에 추가
	        }
	    });
    	//직업분야
    	let srvcFld = $("select[name='osClVO.srvcFld']").val();
    	console.log("직업분야:"+srvcFld);
    	//기업종류
    	let srvcKnd = $("select[name='osClVO.srvcKnd']").val();
    	console.log("기업종류:"+srvcKnd);
    	//지원전형
    	let srvcArctype = $("select[name='osClVO.srvcArctype']").val();
    	console.log("지원전형:"+srvcArctype);
    	//금액 
    	let outordAmt = $("#outordAmt").val();
    	console.log("금액:"+outordAmt);
    	//금액 설명
    	let outordAmtExpln = $("#outordAmtExpln").val();
    	console.log("금액설명:"+outordAmtExpln);
    	//작업기간 
    	let srvcJobpd = $("select[name='osDevalVO.srvcJobpd']").val();
    	console.log("작업기간:"+srvcJobpd);
    	//수정 횟수
    	let srvcUpdtnmtm = $("select[name='osDevalVO.srvcUpdtnmtm']").val();
    	console.log("수정횟수:"+srvcUpdtnmtm);
    	//수정가능 파일 제공 
    	let srvcFileprovdyn = $("input[name='osDevalVO.srvcFileprovdyn']").val();
    	console.log("파일제공:"+srvcFileprovdyn);
    	//기능추가
    	let srvcSklladit = $("input[name='osDevalVO.srvcSklladit']").val();
    	console.log("기능추가:"+srvcSklladit);
    	//서비스 설명 
    	let outordExpln = $("#outordExpln").val();
    	console.log("설명:"+outordExpln);
    	//제공절차 
    	let outordProvdprocss = $("#outordProvdprocss").val();
    	console.log("절차:"+outordProvdprocss);
    	//환불규정 
    	let outordRefndregltn = $("#outordRefndregltn").val();
    	console.log("규정:"+outordRefndregltn);
    	//메인 이미지 
    	let mainFile = $("input[name='mainFile']");
    	console.log(mainFile);
    	//.files : 그 안에 들어온 파일객체들
    	let files =mainFile[0].files;
     	for(let i=0; i<files.length; i++){//[0],[1]
 			//<input type="file" name="uploadFile"..
 			//<input type="file" name="uploadFile"..
	    	formData.append("mainFile",files[0]);			// 메인이미지
 		}
    	
    	//상세이미지 
    	let detailFile = $("input[name='detailFile']");
    	//이미지 파일들 (a001.jpg..)
    	let files2 =	detailFile[0].files;
    	console.log(files2);
    	for(let i=0; i<files2.length; i++){//[0],[1]
			//<input type="file" name="uploadFile"..
			//<input type="file" name="uploadFile"..
	    	formData.append("detailFile",files2[i]);			// 상세이미지	
		}
    	
    	//작업전 요청사항 
    	let outordDmndmatter = $("#outordDmndmatter").val();
    	console.log("요청사항:"+outordDmndmatter);
    	
    	formData.append("mbrId",mbrId);									// 회원 아이디
    	formData.append("outordTtl",outordTtl);							// 제목	
    	formData.append("outordLclsf",outordLclsf);						// 대분류
    	formData.append("outordMlsfc",outordMlsfc);						// 중분류
    	formData.append("osDevalVO.srvcLevelCd",srvcLevelCd);			// 기술수준
    	formData.append("osDevalVO.srvcTeamscaleCd",srvcTeamscaleCd);	// 팀규모
    	formData.append("osClVO.srvcFld",srvcFld);						// 직업분야
    	formData.append("osClVO.srvcKnd",srvcKnd);						// 기업종류
    	formData.append("osClVO.srvcArctype",srvcArctype);				// 지원전형	
    	formData.append("outordAmt",outordAmt);							// 금액
    	formData.append("outordAmtExpln",outordAmtExpln);				// 금액 설명	 
    	formData.append("osDevalVO.srvcJobpd",srvcJobpd);				// 작업기간	
    	formData.append("osDevalVO.srvcUpdtnmtm",srvcUpdtnmtm);			// 수정횟수
    	formData.append("osDevalVO.srvcFileprovdyn",srvcFileprovdyn);	// 수정가능 파일 제공	
    	formData.append("osDevalVO.srvcSklladit",srvcSklladit);			// 기능추가
    	formData.append("outordExpln",outordExpln);						// 서비스 설명
    	formData.append("outordProvdprocss",outordProvdprocss);			// 제공절차
    	formData.append("outordRefndregltn",outordRefndregltn);			// 환불규정
    	formData.append("outordDmndmatter",outordDmndmatter);			// 작업전 요청사항
    	
		//데이터 정보 불러오기 및 저장하시 끝

		//ajax 시작 
		$.ajax({
    		url:"/outsou/registPostAjax",
    		processData:false,
    		contentType:false,
    		data:formData,
    		type:"post",
    		dataType:"json",
    		beforeSend:function(xhr){
				xhr.setRequestHeader("${_csrf.headerName}","${_csrf.token}");
			},
    		success:function(result){
    			console.log("result : ", result);
    		
    			if (result>0) {  // result.success가 true면 성공으로 간주
//     		        alert("등록이 완료되었습니다.");
    				
  				
	  				Toast.fire({
	  					icon:'success',
	  					title:'등록이 완료되었습니다. '
	  				});
	  				
	  				//3초 후 이동 
	  				setTimeout(function(){
	  					 window.location.href = "/outsou/detail?outordNo=" + result;
	  				},3000);  			
	    			
    		    } else {
    		        alert("등록에 실패했습니다.");
    		    }
    		}
    	});
		
		//ajax 끝
	})
	//저장하기 끝
	
	//글자수 제한 시작 
	// 글자 수 실시간 업데이트
    $("#outordTtl").on("input", function() {
        let currentLength = $(this).val().length;
        $("#charCount").text(currentLength);

        if (currentLength > 30) {
            $("#warning").show();  // 경고 메시지 표시
            $(this).val($(this).val().substring(0, 30));  // 글자 수 제한
            $("#charCount").text(30);  // 100자까지만 표시
        } else {
            $("#warning").hide();  // 경고 메시지 숨김
        }

    });
	//금액 설명부분 
   $("#outordAmtExpln").on("input", function() {
	    let currentLength2 = $(this).val().length;
	    $("#charCount2").text(currentLength2);
	
	    if (currentLength2 > 30) {
	        $("#warning2").show();  // 경고 메시지 표시
	        $(this).val($(this).val().substring(0, 30));  // 글자 수 제한
	        $("#charCount2").text(30);  // 60자까지만 표시
	    } else {
	        $("#warning2").hide();  // 경고 메시지 숨김
	    }
	});
	//글자수 제한 끝
	
	//취소 시 
   $(".cancel").on("click", function() {
	    Swal.fire({
	        title: '취소하시겠습니까? \n 작성한 내용은 저장되지 않습니다.',
	        icon: 'question',
	        showCancelButton: true,
	        confirmButtonColor: 'white',
	        cancelButtonColor: 'white',
	        confirmButtonText: '예',
	        cancelButtonText: '아니오'
	    }).then((result) => {
	        // 사용자가 "예"를 선택했을 경우에만 동작
	        if (result.isConfirmed) {
	            // 외주 번호를 URL 파라미터로 함께 전달
	            window.location.href = "/outsou/main";
	        }
	    });
	});
   $("#mg").on("click", function(){
	   $("#outordTtl").val("독립형 웹사이트로 온라인 성공을 보장합니다 ");
	   $("#kwrdtext").val("홈페이지 제작");
	   $("#outordAmt").val("3000000");
	   $("#outordAmtExpln").val("가격이 부담스럽다고 느껴지실 수 있지만 결과물을 받으신다면 진작에 이용할껄 이라는 후회가 드실거에요!");
	})
	
})//function 끝

</script>
<style>
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
	<button class="ddalkkack" id="mg">딸깍</button>
</div>
<div class="registAll">
	<!-- 등록 정보 전체 -->
	<div class="regist">
		<div class="registTitle">
			<h2>재능 등록</h2>
		</div>
		<div class="smRegust">
   		<form name="registForm" id="registForm"  	action="/outsou/registPostAjax" method="post" >
				<input type="text" value="${memVO.mbrId}" style="display: none;" />
				<!-- 기본정보 -->
				<div>
					<div class="GigFormInput1">
						<div class="GigFormInput_title">
							<p>기본 정보</p>
						</div>
						<div class="FormInput1">
							<div class="form-group1">
								<label class="label1">제목<span class="required">*</span></label> 
								<input type="text" 
										name="outordTtl" id="outordTtl" class="title_1"
										placeholder="서비스를 잘 드러낼 수 있는 제목을 입력해주세요" maxlength="30" 
										required />
								<div style="display: flex;">
						           <p id="countp">&nbsp;&nbsp;(&nbsp;<span id="charCount">0</span>&nbsp;/&nbsp;30&nbsp;)</p>
						        </div>
							  </div>
									 <p id="warning">글자 수가 30자를 넘었습니다!</p>

							<!-- 카테고리 form-group2 -->
							<div class="form-group2">
								<div class="form-sub-group">
									<div class="category">
										<!-- 1차 카테고리 (category1) 선택 -->
										<label class="label2_1">대분류<span class="required">*</span></label> 
										<select id="outordLclsf" name="outordLclsf" class="title_2" required >
											<option value="" selected disabled>선택해주세요</option>
											<c:forEach var="CodeVO" items="${codeGrpVOMap.get('OULC').codeVOList}">
												<option value="${CodeVO.comCode}">${CodeVO.comCodeNm}</option>
											</c:forEach>
										</select>
									</div>
									<div class="category">
										<!-- 2차 카테고리 (category2) 선택 -->
										<label class="label2_1">중분류<span class="required">*</span></label> 
										<select id="outordMlsfc" name="outordMlsfc" class="title_2" required>
											<option value="" selected disabled>선택해주세요</option>
											<c:forEach var="CodeVO" items="${codeGrpVOMap.get('OUML').codeVOList}">
												<option value="${CodeVO.comCode}">${CodeVO.comCodeNm}</option>
											</c:forEach>
										</select>
									</div>
								</div>
							</div>
							<!-- 카테고리 끝 -->	
							<!-- 자소서 서비스 타입 form-group3 -->
							<div class="form-group3" style="display: none">
								<div class="form-group3_cont">
									<p>서비스 타입에 항목들을 선택 및 입력해 주세요.</p>
								</div>
								<div class="form-group3_1">
									<div class="form-sub-group">
										<div class="category">
											<label class="label2_1">직업분야</label> 
											<select id="osClVO.srvcFld"  name="osClVO.srvcFld" class="title_2" >
												<option value="" selected disabled>선택해주세요</option>
												<c:forEach var="CodeVO" items="${codeGrpVOMap.get('RCCA').codeVOList}">
													<option value="${CodeVO.comCode}">${CodeVO.comCodeNm}</option>
												</c:forEach>
											</select>
										</div>
										<div class="category">
											<label class="label2_1">기업종류</label> 
											<select	 id="osClVO.srvcKnd" name="osClVO.srvcKnd" class="title_2" >
												<option value="" selected disabled>선택해주세요</option>
												<c:forEach var="CodeVO" items="${codeGrpVOMap.get('SRKN').codeVOList}">
													<option value="${CodeVO.comCode}">${CodeVO.comCodeNm}</option>
												</c:forEach>
											</select>
										</div>
										<div class="category">
											<label class="label2_1">지원전형</label> 
											<select id="osClVO.srvcArctype" name="osClVO.srvcArctype" class="title_2" >
												<option value="" selected disabled>선택해주세요</option>
												<c:forEach var="CodeVO" items="${codeGrpVOMap.get('SRAR').codeVOList}">
													<option value="${CodeVO.comCode}">${CodeVO.comCodeNm}</option>
												</c:forEach>
											</select>
										</div>
									</div>
								</div>
							</div>
							<!-- 자소서 서비스 타입 끝 -->
							<!-- 개발 서비스 타입  -->
							<div class="form-group4" style="display: none">
								<div class="form-group3_cont">
									<p>서비스 타입에 항목들을 선택 및 입력해 주세요.</p>
								</div>
								<div class="form-group4_1">
									<div class="form-sub-group">
										<div class="category">
											<label class="label2_1">기술수준<span class="required">*</span></label> 
											<select id="osDevalVO.srvcLevelCd" 
													name="osDevalVO.srvcLevelCd" class="title_2" required>
												<option value="" selected disabled>선택해주세요</option>
												<c:forEach var="CodeVO" items="${codeGrpVOMap.get('SRLE').codeVOList}">
													<option value="${CodeVO.comCode}">${CodeVO.comCodeNm}</option>
												</c:forEach>
											</select>
										</div>
										<div class="category">
											<label class="label2_1">팀 규모<span class="required">*</span></label> 
											<select id="osDevalVO.srvcTeamscaleCd"
													name="osDevalVO.srvcTeamscaleCd" class="title_2" required>
												<option value="" selected disabled>선택해주세요</option>
												<c:forEach var="CodeVO" items="${codeGrpVOMap.get('SRTE').codeVOList}">
													<option value="${CodeVO.comCode}">${CodeVO.comCodeNm}</option>
												</c:forEach>
											</select>
										</div>
										<div class="category3">
											<label class="label2_1">개발언어</label> 
											<div>
												<div>
													<select  id="osDevalVO.osdeLangVOList.srvcLangCd" 
															name="osDevalVO.osdeLangVOList.srvcLangCd" class="form-control title_5" style="height: auto;"   multiple>
														<c:forEach var="CodeVO" items="${codeGrpVOMap.get('SRLA').codeVOList}">
															<option value="${CodeVO.comCode}">${CodeVO.comCodeNm}</option>
														</c:forEach>
													</select>
												</div>
												<div id="Lang"></div>
											</div>
										</div>
										<div class="category3">
											<label class="label2_1">데이터베이스</label>
											<div>
												<div>
													 <select id="osDevalVO.osdeDatabaseVOList.srvcDatabaseCd"
															name="osDevalVO.osdeDatabaseVOList.srvcDatabaseCd" class="form-control title_5"  multiple>
														<c:forEach var="CodeVO" items="${codeGrpVOMap.get('SRDB').codeVOList}">
															<option value="${CodeVO.comCode}">${CodeVO.comCodeNm}</option>
														</c:forEach>
													</select>
												</div>
												<div id="Database"></div>
											</div>
										</div>
										<div class="category3">
											<label class="label2_1">클라우드</label> 
											<div>
												<div>
													<select id="osDevalVO.osdeCludVOList.srvcCludCd"
															name="osDevalVO.osdeCludVOList.srvcCludCd" class="form-control title_5" multiple>
														<c:forEach var="CodeVO" items="${codeGrpVOMap.get('SRCL').codeVOList}">
															<option value="${CodeVO.comCode}">${CodeVO.comCodeNm}</option>
														</c:forEach>
													</select>
												</div>
												<div id="Clud"></div>
											</div>
										</div>
									</div>
								</div>
							</div>
							<div class="form-group4" style="display: none">
								<div class="form-group-3_cont">
									<p>검색 키워드는 서비스 설명에 노출되지 않지만  검색 대상으로 사용됩니다.</p>
									<p>동일한 키워드 중복 입력은 검색 결과와 무관합니다.</p>
									<p>키워드는 5개까지만 입력이 가능합니다.</p>
								</div>
								<div class="category_2">
									<div>
										<label class="label2_1">검색 키워드 </label>
									</div>
									<div class="kwrdADDALL">
										<div class="kwrdADD">
											<input type="text" name="kwrdtext" id="kwrdtext" class="kwtitle_2"
												placeholder="키워드 입력 "/>
										</div>
										<button type="button" class="Keyword__add">추가</button>
										<div class="KeywordtextAdd"></div>
									</div>
								</div>
							</div>
							<!-- 개발 서비스 타입 끝  -->
						</div>
					</div>
				</div>
				<!-- 기본정보 끝 -->
				<!-- 가격정보 -->
				<div>
					<div class="GigFormInput2">
						<div class="GigFormInput_title">
							<p>가격정보</p>
						</div>
						<div class="FormInput2">
							<div class="form-group5">
								<div class="form-sub-group2_1">
									<div class="category2_1">
										<label class="label2_1">금액(VAT포함)<span class="required">*</span></label> 
										<input type="number" id="outordAmt" name="outordAmt"
												class="title_2" placeholder="최소 10,000원 이상 입력해주세요" required/>
									</div>
									<div class="category2_2">
										<div>
											<label class="label2_1">금액 설명<span class="required">*</span>  </label>
										</div>
										<textarea  id="outordAmtExpln" name="outordAmtExpln"
										class="title_3" placeholder="금액에 대한 상세설명을 입력해주세요"  wrap="hard" required></textarea>
									</div>
									<div class="category2_3" style="display:none;">
										<label class="label2_1">작업 기간</label> 
										<select id="osDevalVO.srvcJobpd"
												name="osDevalVO.srvcJobpd" class="title_2" >
											<option value="" selected disabled>선택해주세요</option>
											<c:forEach var="CodeVO" items="${codeGrpVOMap.get('SRJP').codeVOList}">
												<option value="${CodeVO.comCode}">${CodeVO.comCodeNm}</option>
											</c:forEach>
										</select>
									</div>
									<div class="category2_3" style="display:none;">
										<label class="label2_1">수정 횟수</label> 
										<select id="osDevalVO.srvcUpdtnmtm"
											name="osDevalVO.srvcUpdtnmtm" class="title_2" >
											<option value="" selected disabled>선택해주세요</option>
											<c:forEach var="CodeVO" items="${codeGrpVOMap.get('SRUM').codeVOList}">
												<option value="${CodeVO.comCode}">${CodeVO.comCodeNm}</option>
											</c:forEach>
										</select>
									</div>
									<div class="category2_4" style="display:none;">
										<label class="label2_1">수정가능 파일 제공</label>
										<p>의뢰인에게 소스파일을 제공할 경우 체크해주세요</p>
										<input type="checkbox" class="title_4" 
											id="osDevalVO.srvcFileprovdyn" name="osDevalVO.srvcFileprovdyn" value="1"  />
									</div>
									<div class="category2_3" style="display:none;">
										<label class="label2_1">기능 추가</label> 
										<input type="text"  
												id="osDevalVO.srvcSklladit" name="osDevalVO.srvcSklladit"
											class="title_2" placeholder="추가하고 싶은 기능의 수량을 작성해주세요" />
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
				<!--  가격 정보 끝 -->
				<!--  서비스 설명 -->
				<div class="GigFormInput3">
					<div>
						<div class="GigFormInput_title">
							<p>서비스 설명<span class="required">*</span></p>
						</div>
						<div class="form-group6">
							<label for="outordExpln"></label>
							<div id="perDetTemp1"></div>
							<textarea rows="3" cols="30" class="form-control" name="outordExpln"
								id="outordExpln" style="display: none;"  ></textarea>
						</div>
						<div class="GigFormInput_title">
							<p>서비스 제공절차<span class="required">*</span></p>
						</div>
						<div class="form-group6">
							<label for="outordProvdprocss"></label>
							<div id="perDetTemp2"></div>
							<textarea rows="3" cols="30" class="form-control" name="outordProvdprocss"
								id="outordProvdprocss" style="display: none;" ></textarea>
						</div>
						<div class="GigFormInput_title">
							<p>환불규정<span class="required">*</span></p>
						</div>
						<div class="form-group6">
							<label for="outordRefndregltn"></label>
							<div id="perDetTemp3"></div>
							<textarea rows="3" cols="30" class="form-control" name="outordRefndregltn"
								id="outordRefndregltn" style="display: none;"></textarea>
						</div>
						
						
					</div>
				</div>
				<!--  서비스 설명  끝-->
				<!--  이미지 등록 시작  -->
				<div class="GigFormInput4">
						<!-- 메인 이미지 등록 -->
						<div class="GigFormInput_title">
							<p>이미지 파일</p>
						</div>
						<div class="mainimg">
							<div class="form-group7">
								<div>
									<p>메인 이미지 등록<span class="required">*</span></p>
								</div>
								<div class="category4">
					                <!-- 이미지 클릭 시 파일 업로드 -->
					                <div class="imgupload">
					                    <label for="mainFile"> 
					                        <img id="mainImagePreview" src="../resources/images/이미지 등록.png" alt="메인 이미지">
					                    </label>
					                </div>
					                <input type="file" id="mainFile" name="mainFile" class="real-upload" accept="image/*" required/>
					            </div>
							</div>
							<div class="form-group7">
								<div id="mainpImg"></div>
							</div>
						</div>
					<div class="detailImg">
						<!-- 상세 이미지 등록 -->
						<div class="form-group7">
							<div>
								<p>상세 이미지 등록(선택)</p>
							</div>
							<div class="form-sub-group7">
								<div class="category4">
				                <!-- 이미지 클릭 시 파일 업로드 -->
				                <div class="imgupload">
				                    <label for="detailFile"> 
				                        <img id="mainImagePreview" src="../resources/images/이미지 등록.png" alt="메인 이미지">
				                    </label>
				                </div>
				                <input type="file" id="detailFile" name="detailFile" class="real-upload" accept="image/*" multiple/>
           					 </div>
							</div>
						</div>
							<div class="form-group7">
								<div id="detpImg"></div>
							</div>
					</div>
				</div>
				<!--  이미지 등록 끝  -->
				<!-- 요청사항 -->
				<div class="GigFormInput5">
					<div>
						<div class="GigFormInput_title">
							<p>작업 전 요청사항<span class="required">*</span></p>
						</div>
						<div class="form-group8">
							<label for="outordDmndmatter"></label>
							<div id="perDetTemp4"></div>
							<textarea rows="3" cols="30" class="form-control" name="outordDmndmatter"
								id="outordDmndmatter" style="display: none;" ></textarea>
						</div>
					</div>
					<div id="editBox">
						<p>
							<input type="button" class="cancel" value="취소" />
							<input type="button" id="savebtn" value="저장" />
						</p>
					</div>
				</div>
				<!-- 요청사항  끝 -->
				<sec:csrfInput />
				</form>
		</div>
	</div>
</div>
<!-- 서비스 설명 부분에 해당하는 스크립트 -->
<script type="text/javascript">
// CKEditor 인스턴스를 저장할 객체
let editors = {}; // 각 CKEditor 인스턴스를 저장하기 위한 객체 생성

// 서비스 설명 CKEditor5 적용
ClassicEditor.create(document.querySelector('#perDetTemp1'), {ckfinder: { uploadUrl: '/image/upload?${_csrf.parameterName}=${_csrf.token}' }}) //// CKFinder로 파일 업로드 기능 추가
.then(editor => {editors['perDetTemp1'] = editor; // 'perDetTemp1'에 해당하는 CKEditor 인스턴스를 editors 객체에 저장

    // CKEditor의 데이터 변경 시 실행
    editor.model.document.on('change:data', () => {
        $('#outordExpln').val(editor.getData()); // 서비스 설명 데이터를 텍스트 영역에 저장
    });
})
.catch(err => { console.error(err.stack); }); // 에디터 생성 중 오류 발생 시 콘솔에 오류 출력

// 서비스 제공 절차 CKEditor5 적용
ClassicEditor.create(document.querySelector('#perDetTemp2'), {ckfinder: { uploadUrl: '/image/upload?${_csrf.parameterName}=${_csrf.token}' }})
.then(editor => {editors['perDetTemp2'] = editor; // 'perDetTemp2'에 해당하는 CKEditor 인스턴스를 editors 객체에 저장

    // CKEditor의 데이터 변경 시 실행
    editor.model.document.on('change:data', () => {
        $('#outordProvdprocss').val(editor.getData());
    });
})
.catch(err => { console.error(err.stack); });

// 환불 규정 CKEditor5 적용
ClassicEditor.create(document.querySelector('#perDetTemp3'), {ckfinder: { uploadUrl: '/image/upload?${_csrf.parameterName}=${_csrf.token}' }})
.then(editor => {editors['perDetTemp3'] = editor;

    // CKEditor의 데이터 변경 시 실행
    editor.model.document.on('change:data', () => {
        $('#outordRefndregltn').val(editor.getData());
    });
})
.catch(err => { console.error(err.stack); });

// 요청 사항 CKEditor5 적용
ClassicEditor.create(document.querySelector('#perDetTemp4'), {ckfinder: { uploadUrl: '/image/upload?${_csrf.parameterName}=${_csrf.token}' }})
.then(editor => {editors['perDetTemp4'] = editor; 

    // CKEditor의 데이터 변경 시 실행
    editor.model.document.on('change:data', () => {
        $('#outordDmndmatter').val(editor.getData());
    });
})
.catch(err => { console.error(err.stack); });
</script>
