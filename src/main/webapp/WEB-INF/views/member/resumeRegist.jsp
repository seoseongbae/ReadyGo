<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/security/tags"
	prefix="sec"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<link rel="stylesheet" href="<%=request.getContextPath()%>/resources/css/alert.css" />
<link rel="stylesheet"
	href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200" />
<link rel="stylesheet"
	href="<%=request.getContextPath()%>/resources/css/member/aplctList.css" />
<link rel="stylesheet"
	href="<%=request.getContextPath()%>/resources/css/security/loginForm.css" />
<script
	src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script src="/resources/js/jquery.min.js"></script>
<script src="/resources/js/sweetalert2.js"></script>
<script>

function convertToDateFormat(yyyymm) {
    if (!yyyymm) return '';  // 값이 없으면 빈 문자열 반환
    let year = yyyymm.toString().substring(0, 4);  // yyyy 추출
    let month = yyyymm.toString().substring(4, 6); // MM 추출
    return year+`-`+month+`-01`; // yyyy-MM 형식으로 변환
}
function convertToDateFormat2(yyyymm) {
    if (!yyyymm) return '';  // 값이 없으면 빈 문자열 반환
    let year = yyyymm.toString().substring(0, 4);  // yyyy 추출
    let month = yyyymm.toString().substring(4, 6); // MM 추출
    let day = yyyymm.toString().substring(6, 8); // MM 추출
    return year+`-`+month+`-`+day; // yyyy-MM 형식으로 변환
}
function convertToDateFormat3(yyyymm) {
    if (!yyyymm) return '';  // 값이 없으면 빈 문자열 반환
    let year = yyyymm.toString().substring(0, 4);  // yyyy 추출
    let month = yyyymm.toString().substring(4, 6); // MM 추출
    return year+`-`+month; // yyyy-MM 형식으로 변환
}

function acbgTransForm(value){
	if(value===""){
		$('#acbgRcognacbgCd').parents(".form-group").attr("hidden", true);
		$('#acbgSchlNm').parents(".form-group").attr("hidden", true);
		$('#acbgMjrNm').parents(".form-group").attr("hidden", true);
		$('#acdmcrGrdtnSeCd').parents(".form-group").attr("hidden", true);
		$('#acbgMtcltnym').parents(".form-group").attr("hidden", true);
		$('#acbgGrdtnym').parents(".form-group").attr("hidden", true);
		$('#acbgPntCd').parents(".form-group").attr("hidden", true);
		$('#acbgPnt').parents(".form-group").attr("hidden", true);
		$('#acbgSeCd').val(null);
	}
	if(value==="ACSE001"){
		$('#acbgRcognacbgCd').parents(".form-group").attr("hidden", true);
		$('#acbgSchlNm').parents(".form-group").attr("hidden", false);
		$('#acbgMjrNm').parents(".form-group").attr("hidden", false);
		$('#acdmcrGrdtnSeCd').parents(".form-group").attr("hidden", false);
		$('#acbgMtcltnym').parents(".form-group").attr("hidden", false);
		$('#acbgGrdtnym').parents(".form-group").attr("hidden", false);
		$('#acbgPntCd').parents(".form-group").attr("hidden", true);
		$('#acbgPnt').parents(".form-group").attr("hidden", true);
		$('#acbgSchlNm').val(null);
		$('#acbgMjrNm').val(null);
		$('#acdmcrGrdtnSeCd').val(null);
		$('#acbgMtcltnym').val(null);
		$('#acbgGrdtnym').val(null);
		$('#acbgPntCd').val(null);
		$('#acbgPnt').val(null);
	}
	if(value==="ACSE002"){
		$('#acbgRcognacbgCd').parents(".form-group").attr("hidden", false);
		$('#acbgSchlNm').parents(".form-group").attr("hidden", false);
		$('#acbgMjrNm').parents(".form-group").attr("hidden", false);
		$('#acdmcrGrdtnSeCd').parents(".form-group").attr("hidden", false);
		$('#acbgMtcltnym').parents(".form-group").attr("hidden", false);
		$('#acbgGrdtnym').parents(".form-group").attr("hidden", false);
		$('#acbgPntCd').parents(".form-group").attr("hidden", false);
		$('#acbgPnt').parents(".form-group").attr("hidden", false);
		$('#acbgRcognacbgCd').val("ACRC000").attr('selected', true);
		$('#acbgSchlNm').val(null);
		$('#acbgMjrNm').val(null);
		$('#acdmcrGrdtnSeCd').val(null);
		$('#acbgMtcltnym').val(null);
		$('#acbgGrdtnym').val(null);
		$('#acbgPntCd').val(null);
		$('#acbgPnt').val(null);
	}
	if(value==="ACSE003"){
		$('#acbgRcognacbgCd').parents(".form-group").attr("hidden", false);
		$('#acbgSchlNm').parents(".form-group").attr("hidden", false);
		$('#acbgMjrNm').parents(".form-group").attr("hidden", false);
		$('#acdmcrGrdtnSeCd').parents(".form-group").attr("hidden", false);
		$('#acbgMtcltnym').parents(".form-group").attr("hidden", false);
		$('#acbgGrdtnym').parents(".form-group").attr("hidden", false);
		$('#acbgPntCd').parents(".form-group").attr("hidden", true);
		$('#acbgPnt').parents(".form-group").attr("hidden", true);
		$('#acbgRcognacbgCd').val("ACRC000").attr('selected', true);
		$('#acbgRcognacbgCd').val(null);
		$('#acbgSchlNm').val(null);
		$('#acbgMjrNm').val(null);
		$('#acdmcrGrdtnSeCd').val(null);
		$('#acbgMtcltnym').val(null);
		$('#acbgGrdtnym').val(null);
		$('#acbgPntCd').val(null);
		$('#acbgPnt').val(null);
	}
}
function crtfctTransForm(value){
	if(value===""){
		$('#crtfctNm').parents(".form-group").attr("hidden", true);
		$('#crtfctPblcnoffic').parents(".form-group").attr("hidden", true);
		$('#crtfctAcqsSe').parents(".form-group").attr("hidden", true);
		$('#crtfctAcqsYm').parents(".form-group").attr("hidden", true);
		$('#crtfctScr').parents(".form-group").attr("hidden", true);
		$('#crtfctLangCd').parents(".form-group").attr("hidden", true);
		$('#crtfctAcqsYn').parents(".form-group").attr("hidden", true);
		$('#crtfctNm').val(null);
		$('#crtfctPblcnoffic').val(null);
		$('#crtfctAcqsSe').val(null);
		$('#crtfctAcqsYm').val(null);
		$('#crtfctScr').val(null);
		$('#crtfctLangCd').val(null);
		$('#crtfctAcqsYn').val(null);
	}
	if(value==="CLW001"){
		$('#crtfctNm').parents(".form-group").attr("hidden", false);
		$('#crtfctPblcnoffic').parents(".form-group").attr("hidden", false);
		$('#crtfctAcqsSe').parents(".form-group").attr("hidden", false);
		$('#crtfctAcqsYm').parents(".form-group").attr("hidden", false);
		$('#crtfctScr').parents(".form-group").attr("hidden", false);
		$('#crtfctLangCd').parents(".form-group").attr("hidden", true);
		$('#crtfctAcqsYn').parents(".form-group").attr("hidden", true);
		$('#crtfctNm').val(null);
		$('#crtfctPblcnoffic').val(null);
		$('#crtfctAcqsSe').val(null);
		$('#crtfctAcqsYm').val(null);
		$('#crtfctScr').val(null);
		$('#crtfctLangCd').val(null);
		$('#crtfctAcqsYn').val(null);
	}
	if(value==="CLW002"){
		$('#crtfctNm').parents(".form-group").attr("hidden", false);
		$('#crtfctPblcnoffic').parents(".form-group").attr("hidden", true);
		$('#crtfctAcqsSe').parents(".form-group").attr("hidden", true);
		$('#crtfctAcqsYm').parents(".form-group").attr("hidden", false);
		$('#crtfctScr').parents(".form-group").attr("hidden", false);
		$('#crtfctLangCd').parents(".form-group").attr("hidden", false);
		$('#crtfctAcqsYn').parents(".form-group").attr("hidden", false);
		$('#crtfctNm').val(null);
		$('#crtfctPblcnoffic').val(null);
		$('#crtfctAcqsSe').val(null);
		$('#crtfctAcqsYm').val(null);
		$('#crtfctScr').val(null);
		$('#crtfctLangCd').val(null);
		$('#crtfctAcqsYn').val(null);
	}
	if(value==="CLW003"){
		$('#crtfctNm').parents(".form-group").attr("hidden", false);
		$('#crtfctPblcnoffic').parents(".form-group").attr("hidden", false);
		$('#crtfctAcqsSe').parents(".form-group").attr("hidden", true);
		$('#crtfctAcqsYm').parents(".form-group").attr("hidden", false);
		$('#crtfctScr').parents(".form-group").attr("hidden", true);
		$('#crtfctLangCd').parents(".form-group").attr("hidden", true);
		$('#crtfctAcqsYn').parents(".form-group").attr("hidden", true);
		$('#crtfctNm').val(null);
		$('#crtfctPblcnoffic').val(null);
		$('#crtfctAcqsSe').val(null);
		$('#crtfctAcqsYm').val(null);
		$('#crtfctScr').val(null);
		$('#crtfctLangCd').val(null);
		$('#crtfctAcqsYn').val(null);
	}
}
function prtTransForm(value){
	if(value===""){
		$('#uploadFile2').parents(".form-group").attr("hidden", true);
		$('#prtUrl').parents(".form-group").attr("hidden", true);
		$('#prtTtl').parents(".form-group").attr("hidden", true);
		$('#uploadFile2').val(null);
		$('#prtUrl').val(null);
		$('#prtTtl').val(null);
	}
	if(value==="POTY01"){
		$('#uploadFile2').parents(".form-group").attr("hidden", false);
		$('#prtUrl').parents(".form-group").attr("hidden", true);
		$('#prtTtl').parents(".form-group").attr("hidden", false);
		$('#uploadFile2').val(null);
		$('#prtUrl').val(null);
		$('#prtTtl').val(null);
	}
	if(value==="POTY02"){
		$('#uploadFile2').parents(".form-group").attr("hidden", true);
		$('#prtUrl').parents(".form-group").attr("hidden", false);
		$('#prtTtl').parents(".form-group").attr("hidden", false);
		$('#uploadFile2').val(null);
		$('#prtUrl').val(null);
		$('#prtTtl').val(null);
	}
}

var Toast = Swal.mixin({
	toast: true,
    position: 'center',
    showConfirmButton: false,
    timer: 3000
});
function execDaumPostcode() {
	new daum.Postcode(
			{
				oncomplete : function(data) {
					var fullAddr = data.address;
					var extraAddr = '';

					if (data.addressType === 'R') {
						if (data.bname !== '') {
							extraAddr += data.bname;
						}
						if (data.buildingName !== '') {
							extraAddr += (extraAddr !== '' ? ', '
									+ data.buildingName : data.buildingName);
						}
						fullAddr += (extraAddr !== '' ? ' (' + extraAddr
								+ ')' : '');
					}

					$('#mbrZip').val(data.zonecode);
					$('#mbrAddr').val(fullAddr);
					$('#mbrAddrDtl').focus();
				}
			}).open();
}
function handleImg(e) {
	let files = e.target.files; // 선택한 파일들
	let fileArr = Array.prototype.slice.call(files);
	let accumStr = "";
	fileArr.forEach(function(f) {
		if (!f.type.match("image.*")) {
			alert("이미지 확장자만 가능합니다");
			return; // 함수 자체가 종료됨
		}
		let reader = new FileReader();
		reader.onload = function(e) {// "+e.target+result+" - 이미지를 다 읽었으면 결과를 가져와라 -> 그것을 누적
			accumStr += "<img src='"+e.target.result+"'/>"; // 누적 String
			$(".pImg").html(accumStr);
		}
		reader.readAsDataURL(f);

	});
}
$(function() {
	$(".warning").hide();
	 // 글자 수 실시간 업데이트
    $(".modalCont").on("input", function() {
        let currentLength = $(this).val().length;
        $(this).parent().find(".charCount").text(currentLength);
        if (currentLength > 2000) {
            $(this).parent().find(".warning").show();  // 경고 메시지 표시
            $(this).val($(this).val().substring(0, 2000));  // 글자 수 제한
            $(this).parent().find(".charCount").text(2000);  // 2000자까지만 표시
        } else {
        	 $(this).parent().find(".warning").hide();  // 경고 메시지 숨김
        }

    });

		
	$("#mbrAddr").on("click", function() {
		execDaumPostcode();
	})

	$(".pImg").on("click", function(e) {
		$("#uploadFile").click();
	})
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
	
	let skillListRaw = "${codeGrpVOMap.get('SK')}";
    let skillList = [];
	    
    function parseJavaObject(str) {
        let codeVORegex = /CodeVO\(([^)]+)\)/g;
        let codeVOMatches = str.match(codeVORegex);
        
        if (codeVOMatches) {
            skillList = $.map(codeVOMatches, function(match) {
                try {
                    var props = match.slice(7, -1).split(', ');
                    var obj = {};
                    $.each(props, function(i, prop) {
                        var parts = prop.split('=');
                        obj[$.trim(parts[0])] = $.trim(parts[1]);
                    });
                    return {
                        codeNm: obj.comCodeNm || "",  // 값이 없을 경우 빈 문자열 처리
                        codeNo: obj.comCode || ""     // 값이 없을 경우 빈 문자열 처리
                    };
                } catch (e) {
                    console.error("Error parsing CodeVO object:", e);
                    return null;  // 파싱 실패 시 null 리턴
                }
            });
            skillList = $.grep(skillList, function(item) {
                return item !== null;
            });
        }
    }

    try {
        parseJavaObject(skillListRaw);
    } catch (e) {
        console.error("Error parsing skill data:", e);
    }
	
	$("#skillSearch").on("input", function() {
        let searchStr = $("#skillSearch").val().toLowerCase();
        console.log(searchStr);
        if(searchStr==""){
        	$(".search-results").html("");
        	return;
        }
       	$(".search-results").html("");
       	let filteredSkills = [];
       	$.each(skillList, function(index, skill) {
       	    if (skill.codeNm.toLowerCase().indexOf(searchStr.toLowerCase()) !== -1) {
       	        filteredSkills.push(skill);
       	    }
       	});
        updateSearchResults(filteredSkills, searchStr);
    });

	function updateSearchResults(skills, searchStr) {
	    let searchResults = $(".search-results");
	    searchResults.empty();
	    let skillItem = "";

	    $.each(skills, function(index, skill) {
	        skillItem += '<a class="list-group-item" data-code-no="'
	                   + skill.codeNo 
	                   + '" data-code-nm="'
	                   + skill.codeNm
	                   + '"><div class="search-title">'
	                   + skill.codeNm 
	                   + '</div></a>';
	    });


	    // 검색 결과를 추가하고 나서 클릭 이벤트를 함께 바인딩
	    searchResults.html(skillItem);

	    // 리스트 아이템에 클릭 이벤트 핸들러 추가
	    $(".list-group-item").on("click", function() {
	        let codeNm = $(this).data("code-nm");
	        let codeNo = $(this).data("code-no");

	        console.log(codeNm);
	        console.log(codeNo);

	        addSelectedSkill({ codeNm: codeNm, codeNo: codeNo });
	    });
	}
	    
	function addSelectedSkill(skill) {
    	let selectedSkills = $("#selectedSkills"); // 선택된 스킬을 표시할 컨테이너

	    // 이미 선택된 스킬이 아닌 경우에만 추가
	   if ($("#skill-select-box").find('[data-code-no="' + skill.codeNo + '"]').length === 0) {
		    let skillTag = '<span class="selected-skill" data-code-no="'
		                 + skill.codeNo 
		                 + '">'
		                 + skill.codeNm 
		                 + '</span>';
		
		    let save = $("#skill-select-box").html();
		    save += skillTag;
		    $("#skill-select-box").html(save);
		}

    	// 입력 필드와 검색 결과 초기화
	    $("#skillSearch").val("").focus();  // 입력 필드 초기화 후 포커스
	    $(".search-results").empty();
	}
	$("#skill-select-box").on('click', '.selected-skill', function() {
	    $(this).remove(); // 선택된 스킬 삭제
	});
	$("#basInfoBtn").on("click", function(){
		if ($('#mbrNm').val().trim().length < 2 || $('#mbrNm').val().trim().length > 20) {
		    Toast.fire({
		        icon: 'warning',
		        title: '이름을 입력해 주세요.(2자 이상 20자 이하)'
		    });      
		    
		    $('#mbrNm').focus();
		    event.preventDefault();
		    return false;
		}
	    if ($('#mbrSexdstncd').val() == null) {
	    	Toast.fire({
				icon:'warning',
				title:'성별을 선택해 주세요.'
			});
	        $('#mbrSexdstncd').focus();
	        event.preventDefault();
	        return false;
	    }
	    if ($('#mbrBrdt').val().trim().length < 8 ||$('#mbrBrdt').val().trim().length > 8 ) {
	    	Toast.fire({
				icon:'warning',
				title:'생년월일을 입력해 주세요. ex) 20241022'
			});
	    	$('#mbrBrdt').focus();
	    	event.preventDefault();
	    	return false;
	    }
	    if ($('#mbrPhone').val().trim().length < 11 || $('#mbrPhone').val().trim().length > 11) {
	    	Toast.fire({
				icon:'warning',
				title:'휴대폰번호를 입력해 주세요. (-를 제외한 11자리)'
			});
	        $('#mbrPhone').focus();
	        event.preventDefault();
	        return false;
	    }
	    if ($('#mbrEml').val().trim() === "") {
	    	
	    	Toast.fire({
				icon:'warning',
				title:'이메일을 입력해 주세요.'
			});
	        $('#mbrEml').focus();
	        event.preventDefault();
	        return false;
	    }
	    if ($('#rsmCareerCd').val() == null) {
	    	Toast.fire({
				icon:'warning',
				title:'직무능력을 선택해 주세요.'
			});
	        $('#rsmCareerCd').focus();
	        event.preventDefault();
	        return false;
	    }
	    if ($('#mbrAddr').val().trim() === "") {
	    	Toast.fire({
				icon:'warning',

				title:'주소를 입력해 주세요.'
			});
	        $('#mbrAddr').focus();
	        event.preventDefault();
	        return false;
	    }
	    if ($('#mbrAddrDtl').val().trim() === "") {
	    	Toast.fire({
				icon:'warning',
				title:'상세 주소를 입력해 주세요.'
			});
	        $('#mbrAddrDtl').focus();
	        event.preventDefault();
	        return false;
	    }
	    if ($('#rsmCrdtCd').val() == null) {
	    	Toast.fire({
				icon:'warning',
				title:'희망하는 직무를 선택해 주세요.'
			});
	        $('#rsmCrdtCd').focus();
	        event.preventDefault();
	        return false;
	    }
	    if ($('#rsmSalCd').val() == null) {
	    	Toast.fire({
				icon:'warning',
				title:'희망하는 연봉을 선택해 주세요.'
			});
	        $('#rsmSalCd').focus();
	        event.preventDefault();
	        return false;
	    }
	    if ($('#rsmTtl').val().trim() === "" || $('#rsmTtl').val().trim().length > 100) {
	    	Toast.fire({
				icon:'warning',
				title:'제목을 입력해 주세요. (100자 이하)'
			});
	        $('#mbrAddrDtl').focus();
	        event.preventDefault();
	        return false;
	    }
	    
	    let mbrNm = $("#mbrNm").val();
		let mbrSexdstncd = $("#mbrSexdstncd").val();
		let mbrBrdt = $("#mbrBrdt").val();
		let mbrPhone = $("#mbrPhone").val();
		let mbrTelno = $("#mbrTelno").val();
		let mbrEml = $("#mbrEml").val();
		let rsmCareerCd = $("#rsmCareerCd").val();
		let mbrAddr = $("#mbrAddr").val();
		let mbrZip = $("#mbrZip").val();
		let mbrAddrDtl = $("#mbrAddrDtl").val();
		let rsmTtl = $("#rsmTtl").val();
		let rsmNo = $("#rsmNo").val();
		let rsmCrdtCd = $("#rsmCrdtCd").val();
		let rsmSalCd = $("#rsmSalCd").val();
		let rsmMemo = $("#rsmMemo").val();
		var uploadFile = $("#uploadFile")[0].files[0];
		// FormData 객체 생성 (필요한 경우)
		let formData = new FormData();

		// FormData에 값 추가
		formData.append("mbrNm", mbrNm);
		formData.append("mbrSexdstncd", mbrSexdstncd);
		formData.append("mbrBrdt", mbrBrdt);
		formData.append("mbrPhone", mbrPhone);
		if(mbrTelno !== null||$('#mbrTelno').val().trim() !== ""){
			formData.append("mbrTelno", mbrTelno);
		}
		formData.append("mbrEml", mbrEml);
		formData.append("rsmCareerCd", rsmCareerCd);
		formData.append("mbrAddr", mbrAddr);
		formData.append("mbrZip", mbrZip);
		formData.append("mbrAddrDtl", mbrAddrDtl);
		if(rsmTtl != null||$('#rsmTtl').val().trim() !== ""){
			formData.append("rsmTtl", rsmTtl);
		}
		if(rsmNo != null||$('#rsmNo').val().trim() !== ""){
			formData.append("rsmNo", rsmNo);
		}
		if(uploadFile != null){
			formData.append("uploadFile", uploadFile);
		}
		formData.append("rsmCrdtCd", rsmCrdtCd);
		formData.append("rsmSalCd", rsmSalCd);
		formData.append("rsmMemo", rsmMemo);
		$.ajax({
			url : "/member/resumebasInfoPost",
			processData : false,
			contentType : false,
			enctype: 'multipart/form-data',
			data : formData,
			type : "post",
			dataType: "json",
			beforeSend : function(xhr) {
				xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
			},
			success : function(result) {
				console.log("result : " + result.fileDetailVOList);
				// success, error, warning, info, question
				if (result == null) {
					Toast.fire({
						icon : 'error',
						title : '저장 실패'
					});
					return;
				}
				Toast.fire({
					icon : 'success',
					title : '저장 성공'
				});
				let age = calculateAge(result.mbrBrdt);
				code = ``;
				code += `<div class="row" id="basicInfo">
					<div class="basText-l" >
					<div class="font-15 bold-5 gray">
						<div class="resumeTop">
							<b class="basName">`+result.mbrNm+`</b> <span class="hili">`+result.rsmCareerCdNm+`</span>
						</div>
						<div class="hopepe" id="hopepe">
							`+result.mbrBrdt.substring(0,4)+` `+result.mbrSexdstncdNm+` (<b id="age">`+age+`</b>세)&nbsp;&nbsp; |&nbsp;&nbsp;
							 희망사항(`+result.rsmCrdtCdNm+` · `+result.rsmSalCdNm+`)
						</div>
						<div class="bold-4 margin-bottom-2" id="emlllll">
							이메일 &nbsp;&nbsp;<b class="black">`+result.mbrEml+`</b>&nbsp;&nbsp; |&nbsp;&nbsp; 휴대폰 &nbsp;&nbsp;<b class="black">`+result.mbrPhone.substring(0,3)+`-`+result.mbrPhone.substring(3,7)+`-`+result.mbrPhone.substring(7,11)+`</b>
						</div>
						<div class="bold-4" id="addddr">
							주소 &nbsp;&nbsp;<b class="black">(`+result.mbrZip+`) `+result.mbrAddr+`</b>
						</div>
					</div>
				</div>
				<div class="basImg">
					<img src="`+result.fileDetailVOList[0].filePathNm+`">
				</div>
			</div>
			<div class="row idForm btnForm">
				<button class="submitBtn" id="basInfoEditBtn">수정</button>
			</div>`;
			console.log(code);
				let rsmNo = result.rsmNo;
				let mbrId = result.mbrId;
				$("#rsmNo").val(rsmNo);
				$("#readRsmNo").val(rsmNo);
				$("#mbrId").val(mbrId);
				$(".basic .showBox").html(code);
				$(".basic .conBox").attr("hidden", true);
                $(".basic .showBox").attr("hidden", false);
			}
		})
	})
	$(document).on("click", "#basInfoEditBtn",function(){
		$(".basic .conBox").attr("hidden", false);
        $(".basic .showBox").attr("hidden", true);
	})
	$(document).on("click", "#basInforesetBtn",function(){
		$(".basic .conBox").attr("hidden", true);
        $(".basic .showBox").attr("hidden", false);
	})
// 	추가버튼 기능
	$(".addBtn").on("click",function(){
		$(this).parent().find(".conBox").attr("hidden", false);
		let skillShowBox = $(this).parent().find("#skill-show-box");
		if($(this).parents(".CL")){
			$("html, body").animate({
		        scrollTop: $(window).scrollTop() + 200
		    }, 200);
		}
		if(skillShowBox != null){
			let code = skillShowBox.html();
			$("#skill-select-box").html(code);
			$(this).parent().find(".showBox").attr("hidden", true);
		} 
	})
	//취소 버튼
	$(".resetBtn").on("click", function(){
		$(this).parents(".conBox").find('input[type="text"],input[type="number"], input[type="date"], select, textarea').val('');
		$(this).parents(".conBox").find('input[type="text"], input[type="number"], input[type="date"],  select, textarea').prop('selectedIndex', 0);
        acbgTransForm("")        
        crtfctTransForm("")
		$(this).parents(".conBox").attr("hidden", true);
		$(this).parents(".conBox").find("#skill-select-box").html(null);
		let skillShowBox = $(this).parent().find("#skill-show-box");
		$(this).parents(".registForm").find(".showBox").attr("hidden", false);
		if(skillShowBox != null){
			let code = skillShowBox.html();
			$("#skill-select-box").html(code);
		} 
	})
	//학력폼 변경 시작
	$("#acbgSeCd").on("change", function(){
		let val = $(this).val();
		acbgTransForm(val);
	})
	//학력폼 변경 끝
	//학력인서트 시작
	$("#acbgSaveBtn").on("click", function(){
		if ($('#rsmNo').val().trim()==="") {
	    	Toast.fire({
				icon:'warning',
				title:'기본정보를 먼저 저장해 주세요.'
			});
	        $('#rsmNo').focus();
	        event.preventDefault();
	        return false;
	    }
		if ($('#acbgSeCd').val() === "") {
	    	Toast.fire({
				icon:'warning',
				title:'학력 구분을 선택해 주세요.'
			});
	        $('#acbgSeCd').focus();
	        event.preventDefault();
	        return false;
	    }
		if ($('#acbgSeCd').val() == "ACSE002" ||$('#acbgSeCd').val() == "ACSE003") {
			if($('#acbgRcognacbgCd').val() == null){
		    	Toast.fire({
					icon:'warning',
					title:'인정 학력을 선택해 주세요.'
				});
		        $('#acbgSeCd').focus();
		        event.preventDefault();
		        return false;
			}
	    }
	    if ($('#acbgSchlNm').val().trim() ===	 "") {
	    	Toast.fire({
				icon:'warning',
				title:'학교명을 입력해 주세요.'
			});
	        $('#acbgSchlNm').focus();
	        event.preventDefault();
	        return false;
	    }
	    if ($('#acbgMjrNm').val().trim() === "") {
	    	Toast.fire({
				icon:'warning',
				title:'전공명을 입력해 주세요.'
			});
	        $('#acbgMjrNm').focus();
	        event.preventDefault();
	        return false;
	    }
	    if ($('#acdmcrGrdtnSeCd').val() == null) {
	    	Toast.fire({
				icon:'warning',
				title:'졸업 여부를 선택해 주세요.'
			});
	        $('#acdmcrGrdtnSeCd').focus();
	        event.preventDefault();
	        return false;
	    }
	    if ($('#acbgSeCd').val() == "ACSE002") {
	    	if ($('#acbgPntCd').val() != "") {
		    	if ($('#acbgPnt').val().trim() === "") {
		    		Toast.fire({
						icon:'warning',
						title:'점수를 입력해 주세요.'
					});
			        $('#acbgPnt').focus();
			        event.preventDefault();
			        return false;
			    }
		    }
	    }
	    if ($('#acbgSeCd').val() == "ACSE002") {
		    	console.log($('#acbgSeCd').val())
		    if ($('#acbgPnt').val().trim() !== "") {
		    	console.log($('#acbgPnt').val())
			    if ($('#acbgPntCd').val() == "") {
			    	Toast.fire({
						icon:'warning',
						title:'기준 학점을 선택해 주세요.'
					});
			        $('#acbgPntCd').focus();
			        event.preventDefault();
		    	    return false;
			    }
		    }
	    }
        // 학력 정보 추출
        let acbgNo = $("#acbgNo").val();
        let rsmNo = $("#rsmNo").val();
        let acbgSeCd = $("#acbgSeCd").val();
        let acbgRcognacbgCd = $("#acbgRcognacbgCd").val();
        let acbgSchlNm = $("#acbgSchlNm").val();
        let acbgMjrNm = $("#acbgMjrNm").val();
        let acdmcrGrdtnSeCd = $("#acdmcrGrdtnSeCd").val();
        let acbgMtcltnym = $("#acbgMtcltnym").val();
        let acbgGrdtnym = $("#acbgGrdtnym").val();
        let acbgPnt = $("#acbgPnt").val();
        let acbgPntCd = $("#acbgPntCd").val();
        // FormData 객체 생성
        let formData = new FormData();

        // 학력 정보 추가
        if($('#acbgNo').val().trim() !== ""||$('#acbgNo').val()!==null){
	        formData.append("acbgNo", acbgNo);
        }
        formData.append("rsmNo", rsmNo);
        formData.append("acbgSeCd", acbgSeCd);
        formData.append("acbgRcognacbgCd", acbgRcognacbgCd);
        formData.append("acbgSchlNm", acbgSchlNm);
        formData.append("acbgMjrNm", acbgMjrNm);
        formData.append("acdmcrGrdtnSeCd", acdmcrGrdtnSeCd);
        formData.append("acbgMtcltnym", acbgMtcltnym);
        formData.append("acbgGrdtnym", acbgGrdtnym);
        formData.append("acbgPntCd", acbgPntCd);
        formData.append("acbgPnt", acbgPnt);

        $.ajax({
            url: "/member/acbgRegistPost",
            processData: false,
            contentType: false,
            data: formData,
            type: "post",
            dataType: "json",
            beforeSend: function(xhr) {
                xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
            },
            success: function(result) {
                Toast.fire({
                    icon: 'success',
                    title: '학력 저장 완료'
                });
                let code = "";
                result.forEach(function(item, index) {
                	code += `<tr>
                        <td class="aplct">`+item.acbgSchlNm+`<br>`;
                    if(item.acbgRcognacbgCdNm!=null){
                    	code +=`<span class="aplcont">`+item.acbgRcognacbgCdNm;
                    }
                    if(item.acbgRcognacbgCdNm!=null && item.acbgRcognacbgCdNm !=null){
                    	code +=` | `;
                    }
                    if(item.acbgMjrNm!=null){
                    	code +=item.acbgMjrNm;
                    }
                    code +=`</span></td>
                        <td class="aplct">`;
                    if(item.acbgPnt!=null){
                    	code += `<span class="aplcont">인정 학점 :`+item.acbgPnt+`</span>&nbsp;&nbsp;&nbsp;`;
                    }
                    if(item.acbgPntCdNm!=null){
                    	code += `<span class="aplcont">기준 학점 : `+item.acbgPntCdNm+`</span>`;
                    }
                    code += `</td>
                        <td class="aplct">`+item.acdmcrGrdtnSeCdNm+`<br>`;
                    if(item.acbgMtcltnym!=null){
                    	code += `<span class="aplcont">입학 : `+item.acbgMtcltnym.substring(0,4)+`년 `+ item.acbgMtcltnym.substring(4,6)+`월</span><br />`;                    	
                    }    
                    if(item.acbgGrdtnym!=null){
	                    code += `<span class="aplcont">졸업 : `+item.acbgGrdtnym.substring(0,4)+`년 `+ item.acbgGrdtnym.substring(4,6)+`월</span>`;
                    } 
                    code += `</td>
                        <td>
                        	<button type="button" class="btn btn-default aplctCancel acbgDeleteBtn"
                        		data-acbg-no="`+item.acbgNo+`">삭제</button>
                            <button type="button" class="btn btn-default aplctCancel acbgEditBtn"
                               data-acbg-no="`+item.acbgNo+`"
                               data-acbg-se-cd="`+item.acbgSeCd+`" 
                               data-acbg-rcognacbg-cd="`+item.acbgRcognacbgCd+`" 
                               data-acbg-schl-nm="`+item.acbgSchlNm+`" 
                               data-acbg-mjr-nm="`+item.acbgMjrNm+`" 
                               data-acdmcr-grdtn-se-cd="`+item.acdmcrGrdtnSeCd+`" 
                               data-acbg-mtcltnym="`+item.acbgMtcltnym+`" 
                               data-acbg-grdtnym="`+item.acbgGrdtnym+`" 
                               data-acbg-pnt-cd="`+item.acbgPntCd+`" 
                               data-acbg-pnt="`+item.acbgPnt+`">수정</button>
                        </td>
                     </tr>`;
                });
                $(".acbgTo").text(result.length);
                $('#acbgTbody').html(code);
                // hidden 속성을 가진 요소의 초기화
                $('.acbg input[type="text"], .acbg input[type="number"], .acbg input[type="date"], .acbg select').val('');
                
                $('.acbg input[type="text"], .acbg input[type="number"], .acbg input[type="date"], .acbg select').prop('selectedIndex', 0);
                $('.acbg .form-group').attr("hidden", true);
                $('.acbg .nohide').attr("hidden", false); 
                $(".acbg .conBox").attr("hidden", true);
                $(".acbg .showBox").attr("hidden", false);
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
// 	학력 인서트 끝
// 학력 삭제
	$(document).on("click", ".acbgDeleteBtn", function() {
	    let acbgNo = $(this).data("acbgNo");
	    let rsmNo = $("#rsmNo").val();
	    let tr = $(this).closest("tr");
	    let formData = new FormData();
	    formData.append("acbgNo", acbgNo);
	    formData.append("rsmNo", rsmNo);
	    Swal.fire({
	  	  title: '삭제 하시겠습니까?',
	  	  icon: 'error',
	  	  showCancelButton: true,
	  	  confirmButtonColor: 'white',
	  	  cancelButtonColor: 'white',
	  	  confirmButtonText: '예',
	  	  cancelButtonText: '아니오',
	  	  reverseButtons: false, // 버튼 순서 거꾸로
	  	}).then((result) => {
	  	  if (result.isConfirmed) {
	  	    $.ajax({
	            url: "/member/acbgDeletePost",
	            processData: false,
	            contentType: false,
	            data: formData,
	            type: "post",
	            dataType: "json",
	            beforeSend: function(xhr) {
	                xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
	            },
	            success: function(result) {
	                Toast.fire({
	                    icon: 'success',
	                    title: '학력 삭제 완료'
	                });
	                tr.remove();
	                var total = $(".acbgTo").text();
	                total--;
	                $(".acbgTo").text(total);
	            },
	            error: function(xhr, status, error) {
	                console.error("Ajax 요청 실패:", status, error);
	                Toast.fire({
	                    icon: 'error',
	                    title: 'Ajax 요청 실패'
	                });
	            }
	        });
	  	  }
	  	})

	    
	});
// 	학력 수정
	$(document).on("click", ".acbgEditBtn", function(){
		let acbgSeCd = $(this).data("acbgSeCd");
		acbgTransForm(acbgSeCd);
		let acbgNo = $(this).data("acbgNo");
		let acbgRcognacbgCd = $(this).data("acbgRcognacbgCd");
		let acbgSchlNm = $(this).data("acbgSchlNm");
		let acbgMjrNm = $(this).data("acbgMjrNm");
		let acdmcrGrdtnSeCd = $(this).data("acdmcrGrdtnSeCd");
		let acbgMtcltnym = $(this).data("acbgMtcltnym");
		let acbgGrdtnym = $(this).data("acbgGrdtnym");
		let acbgPntCd = $(this).data("acbgPntCd");
		let acbgPnt = $(this).data("acbgPnt");
		console.log(convertToDateFormat(acbgMtcltnym));
		$("#acbgNo").val(acbgNo);
		$("#acbgSchlNm").val(acbgSchlNm);
		$("#acbgMjrNm").val(acbgMjrNm);
		$("#acbgMtcltnym").val(convertToDateFormat3(acbgMtcltnym));
		$("#acbgGrdtnym").val(convertToDateFormat3(acbgGrdtnym));
		$("#acbgPnt").val(acbgPnt);

		$("#acbgSeCd").val(acbgSeCd).attr('selected', true);
		$("#acbgRcognacbgCd").val(acbgRcognacbgCd).attr('selected', true);
		$("#acdmcrGrdtnSeCd").val(acdmcrGrdtnSeCd).attr('selected', true);
		$("#acbgPntCd").val(acbgPntCd).attr('selected', true);
		$(".acbg .conBox").attr("hidden", false);
		$(".acbg .showBox").attr("hidden", true);
	})
	
// 	경력 인서트 시작
	$("#careerSaveBtn").on("click", function(){
		if ($('#rsmNo').val().trim()==="") {
	    	Toast.fire({
				icon:'warning',
				title:'기본정보를 먼저 저장해 주세요.'
			});
	        $('#rsmNo').focus();
	        event.preventDefault();
	        return false;
	    }
		if ($('#careerEntNm').val().trim() === "") {
	    	Toast.fire({
				icon:'warning',
				title:'기업명을 입력해 주세요.'
			});
	        $('#careerEntNm').focus();
	        event.preventDefault();
	        return false;
	    }
		if ($('#careerJncmpYmd').val().trim() === "") {
	    	Toast.fire({
				icon:'warning',
				title:'입사일자를 입력해 주세요.'
			});
	        $('#careerJncmpYmd').focus();
	        event.preventDefault();
	        return false;
	    }
	    if ($('#careerDtyCd').val() === null) {
	    	Toast.fire({
				icon:'warning',
				title:'직무를 선택해 주세요.'
			});
	        $('#careerDtyCd').focus();
	        event.preventDefault();
	        return false;
	    }
	    if ($('#careerTask').val().trim() === "") {
	    	Toast.fire({
				icon:'warning',
				title:'담당업무 내용을 입력해 주세요.'
			});
	        $('#careerTask').focus();
	        event.preventDefault();
	        return false;
	    }
	   
        // 경력 정보 추출
        let careerNo = $("#careerNo").val();
        let rsmNo = $("#rsmNo").val();
        let careerEntNm = $("#careerEntNm").val();
        let careerJncmpYmd = $("#careerJncmpYmd").val();
        let careerRetireYmd = $("#careerRetireYmd").val();
        let careerDtyCd = $("#careerDtyCd").val();
        let careerDept = $("#careerDept").val();
        let careerJbgdCd = $("#careerJbgdCd").val();
        let careerTask = $("#careerTask").val();
        let careerAnslry = $("#careerAnslry").val();
        let careerWorkRgnCd = $("#careerWorkRgnCd").val();
        // FormData 객체 생성
        let formData = new FormData();

        if(careerAnslry.trim() === "" || careerAnslry.trim() === null){
        	careerAnslry = 0;
        }
        // 경력 정보 추가
        if($('#careerNo').val().trim() !== ""||$('#careerNo').val()!==null){
	        formData.append("careerNo", careerNo);
        }
        formData.append("rsmNo", rsmNo);
        formData.append("careerEntNm", careerEntNm);
        formData.append("careerJncmpYmd", careerJncmpYmd);
        formData.append("careerRetireYmd", careerRetireYmd);
        formData.append("careerDtyCd", careerDtyCd);
        formData.append("careerDept", careerDept);
        formData.append("careerJbgdCd", careerJbgdCd);
        formData.append("careerTask", careerTask);
        formData.append("careerAnslry", careerAnslry);
        formData.append("careerWorkRgnCd", careerWorkRgnCd);
		
        let pat = $(this).parents(".conBox");
        
        $.ajax({
            url: "/member/careerRegistPost",
            processData: false,
            contentType: false,
            data: formData,
            type: "post",
            dataType: "json",
            beforeSend: function(xhr) {
                xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
            },
            success: function(result) {
                Toast.fire({
                    icon: 'success',
                    title: '경력 저장 완료'
                });
                let code = "";
                result.forEach(function(item, index) {
                    code += `<tr>
                        <td class="aplct">`;
                    if(item.careerEntNm.length > 10){
                    	code += item.careerEntNm.substring(0,10)+`...`;
                    }else{
                    	code += item.careerEntNm;
                    } 
                    code +=`</td>
                        <td class="aplct">입사일자 : `+item.careerJncmpYmd.substring(0,4)+`-`+ item.careerJncmpYmd.substring(4,6)+`-`+ item.careerJncmpYmd.substring(6,8);
                    if(item.careerRetireYmd!=null){
                    	code += `<br />퇴사일자 : `+item.careerRetireYmd.substring(0,4)+`-`+ item.careerRetireYmd.substring(4,6)+`-`+ item.careerRetireYmd.substring(6,8);
                    }
                    code += `</td>
                        <td class="aplct">`+item.careerDtyCdNm+`<br>`;
                    if(item.careerDept!=null){
                    	   if(item.careerDept.length > 10){
                           	code += `<span class="aplcont">부서 : `+item.careerDept.substring(0,10)+`...</span>&nbsp;&nbsp;&nbsp;`;   
                           }else{
                           	code += `<span class="aplcont">부서 : `+item.careerDept+`</span>&nbsp;&nbsp;&nbsp;`;   
                           } 
                    }    
                    if(item.careerJbgdCdNm!=null){
	                    code += `<span class="aplcont">직급 : `+item.careerJbgdCdNm+`</span>`;
                    }    
                    code += `</td>
                        <td>
                        	<button type="button" class="btn btn-default aplctCancel careerDeleteBtn"
                        		data-career-no="`+item.careerNo+`">삭제</button>
                            <button type="button" class="btn btn-default aplctCancel careerEditBtn"
                               data-career-no="`+item.careerNo+`"
                               data-career-ent-nm="`+item.careerEntNm+`" 
                               data-career-jncmp-ymd="`+item.careerJncmpYmd+`" 
                               data-career-retire-ymd="`+item.careerRetireYmd+`" 
                               data-career-dty-cd="`+item.careerDtyCd+`" 
                               data-career-dept="`+item.careerDept+`" 
                               data-career-jbgd-cd="`+item.careerJbgdCd+`" 
                               data-career-task="`+item.careerTask+`" 
                               data-career-anslry="`+item.careerAnslry+`" 
                               data-career-work-rgn-cd="`+item.careerWorkRgnCd+`">수정</button>
                        </td>
                     </tr>`;
                });
                $(".careerTo").text(result.length);
                $('#careerTbody').html(code);
                // hidden 속성을 가진 요소의 초기화
                pat.find('input[type="text"],input[type="number"], input[type="date"], select, textarea').val('');
                pat.find('input[type="text"], input[type="number"], input[type="date"],  select, textarea').prop('selectedIndex', 0);
                $(".career .conBox").attr("hidden", true);
                $(".career .showBox").attr("hidden", false);
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
	// 경력 인서트 끝
	
	// 경력 삭제
	$(document).on("click", ".careerDeleteBtn", function() {
	    let careerNo = $(this).data("careerNo");
	    let rsmNo = $("#rsmNo").val();
	    let tr = $(this).closest("tr");
	    let formData = new FormData();
	    console.log(careerNo)
	    console.log(rsmNo)
	    formData.append("careerNo", careerNo);
	    formData.append("rsmNo", rsmNo);
	    
	    Swal.fire({
		  	  title: '삭제 하시겠습니까?',
		  	  icon: 'error',
		  	  showCancelButton: true,
		  	  confirmButtonColor: 'white',
		  	  cancelButtonColor: 'white',
		  	  confirmButtonText: '예',
		  	  cancelButtonText: '아니오',
		  	  reverseButtons: false, // 버튼 순서 거꾸로
		  	}).then((result) => {
		  	  if (result.isConfirmed) {
		  		$.ajax({
		            url: "/member/careerDeletePost",
		            processData: false,
		            contentType: false,
		            data: formData,
		            type: "post",
		            dataType: "json",
		            beforeSend: function(xhr) {
		                xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
		            },
		            success: function(result) {
		                Toast.fire({
		                    icon: 'success',
		                    title: '경력 삭제 완료'
		                });
		                tr.remove();
		                var total = $(".careerTo").text();
		                total--;
		                $(".careerTo").text(total);
		                
		            },
		            error: function(xhr, status, error) {
		                console.error("Ajax 요청 실패:", status, error);
		                Toast.fire({
		                    icon: 'error',
		                    title: 'Ajax 요청 실패'
		                });
		            }
		        });
		  	  }
		  	})
	    
	});
	//경력 삭제 끝
// 	경력 수정
	$(document).on("click", ".careerEditBtn", function(){
		let careerNo = $(this).data("careerNo");
		let careerEntNm = $(this).data("careerEntNm");
		let careerJncmpYmd = $(this).data("careerJncmpYmd");
		let careerRetireYmd = $(this).data("careerRetireYmd");
		let careerDtyCd = $(this).data("careerDtyCd");
		let careerDept = $(this).data("careerDept");
		let careerJbgdCd = $(this).data("careerJbgdCd");
		let careerTask = $(this).data("careerTask");
		let careerAnslry = $(this).data("careerAnslry");
		let careerWorkRgnCd = $(this).data("careerWorkRgnCd");
		$("#careerNo").val(careerNo);
		$("#careerEntNm").val(careerEntNm);
		$("#careerJncmpYmd").val(convertToDateFormat2(careerJncmpYmd));
		$("#careerRetireYmd").val(convertToDateFormat2(careerRetireYmd));
		$("#careerDept").val(careerDept);
		$("#careerTask").val(careerTask);
		$("#careerAnslry").val(careerAnslry);

		$("#careerDtyCd").val(careerDtyCd).attr('selected', true);
		$("#careerJbgdCd").val(careerJbgdCd).attr('selected', true);
		$("#careerWorkRgnCd").val(careerWorkRgnCd).attr('selected', true);
		$(".career .conBox").attr("hidden", false);
		$(".career .showBox").attr("hidden", true);
	})
	
// 	스킬 인서트 시작
	$("#skillSaveBtn").on("click", function(){
		if ($('#rsmNo').val().trim()==="") {
	    	Toast.fire({
				icon:'warning',
				title:'기본정보를 먼저 저장해 주세요.'
			});
	        $('#rsmNo').focus();
	        event.preventDefault();
	        return false;
	    }
		let skillCodes = $(".conBox .selected-skill").map(function() {
		    return $(this).attr('data-code-no');
		}).get().filter(function(code) {
		    return code;
		});

		// 중복 제거
		skillCodes = $.unique(skillCodes);
	
		// 쉼표로 구분된 문자열로 변환
		let skCd = skillCodes.join(',');
	
		// rsmNo 값 설정 (고정 값)
		let rsmNo = $("#rsmNo").val();
	
		// FormData 객체 생성
		let formData = new FormData();
	
		// FormData에 값 추가
		formData.append("skCd", skCd);
		formData.append("rsmNo", rsmNo);
		
		// FormData 내용 확인 (선택적)
        let pat = $(this).parents(".conBox");
        
        $.ajax({
            url: "/member/skillRegistPost",
            processData: false,
            contentType: false,
            data: formData,
            type: "post",
            dataType: "json",
            beforeSend: function(xhr) {
                xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
            },
            success: function(result) {
                Toast.fire({
                    icon: 'success',
                    title: '스킬 저장 완료'
                });
                var total = 0;
                let code = "";
                result.forEach(function(item, index) {
                	total++;
                    code += `<span class="selected-skill" data-code-no="`+item.skCd+`">`+item.skCdNm+`</span>`;
                });
                $(".skillTo").text(total);
                $('#skill-show-box').html(code);
                // hidden 속성을 가진 요소의 초기화
                pat.find('input[type="text"],input[type="number"], input[type="date"], select, textarea').val('');
                pat.find('input[type="text"], input[type="number"], input[type="date"],  select, textarea').prop('selectedIndex', 0);
                $(".skill .conBox").attr("hidden", true);
                $(".skill .showBox").attr("hidden", false);
                $("#skill-select-box").html("");
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
	// 스킬 인서트 끝
	
	// 	경험/활동/교육 인서트 시작
	$("#actSavaBtn").on("click", function(){
		if ($('#rsmNo').val().trim()==="") {
	    	Toast.fire({
				icon:'warning',
				title:'기본정보를 먼저 저장해 주세요.'
			});
	        $('#rsmNo').focus();
	        event.preventDefault();
	        return false;
	    }
		if ($('#actSeCd').val() === null) {
	    	Toast.fire({
				icon:'warning',
				title:'활동구분을 선택해 주세요.'
			});
	        $('#actSeCd').focus();
	        event.preventDefault();
	        return false;
	    }
		if ($('#actEngn').val().trim() === "") {
	    	Toast.fire({
				icon:'warning',
				title:'기관/장소명을 입력해 주세요.'
			});
	        $('#actEngn').focus();
	        event.preventDefault();
	        return false;
	    }
	    if ($('#actNm').val().trim() === "") {
	    	Toast.fire({
				icon:'warning',
				title:'활동명을 입력해 주세요.'
			});
	        $('#actNm').focus();
	        event.preventDefault();
	        return false;
	    }
	    if ($('#actBeginYmd').val().trim() === "") {
	    	Toast.fire({
				icon:'warning',
				title:'시작년월을 입력해 주세요.'
			});
	        $('#actBeginYmd').focus();
	        event.preventDefault();
	        return false;
	    }
	    if ($('#actEndYmd').val().trim() === "") {
	    	Toast.fire({
				icon:'warning',
				title:'종료년월을 입력해 주세요.'
			});
	        $('#actEndYmd').focus();
	        event.preventDefault();
	        return false;
	    }
	   
        // 경험/활동/교육 정보 추출
        let actNo = $("#actNo").val();
        let rsmNo = $("#rsmNo").val();
        let actSeCd = $("#actSeCd").val();
        let actNm = $("#actNm").val();
        let actEngn = $("#actEngn").val();
        let actBeginYmd = $("#actBeginYmd").val();
        let actEndYmd = $("#actEndYmd").val();
        let actCn = $("#actCn").val();
        
        // FormData 객체 생성
        let formData = new FormData();

        // 경험/활동/교육 정보 추가
        if($('#actNo').val().trim() !== ""||$('#actNo').val()!==null){
	        formData.append("actNo", actNo);
        }
        formData.append("rsmNo", rsmNo);
        formData.append("actSeCd", actSeCd);
        formData.append("actNm", actNm);
        formData.append("actEngn", actEngn);
        formData.append("actBeginYmd", actBeginYmd);
        formData.append("actEndYmd", actEndYmd);
        formData.append("actCn", actCn);
		
        let pat = $(this).parents(".conBox");
        
        $.ajax({
            url: "/member/actRegistPost",
            processData: false,
            contentType: false,
            data: formData,
            type: "post",
            dataType: "json",
            beforeSend: function(xhr) {
                xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
            },
            success: function(result) {
                Toast.fire({
                    icon: 'success',
                    title: '경험/활동/교육 저장 완료'
                });
                let code = "";
                result.forEach(function(item, index) {
                	code += '<tr>';
                	code +=     '<td class="aplct">';
                	// 활동 구분
                	code += item.actSeCdNm;
                	code += '</td>';
                	// 활동 명
                	 	if(item.actNm.length > 10){
                        	code += '<td class="aplct">'+item.actNm.substring(0,10)+'...';  
                        }else{
                        	code += '<td class="aplct">'+item.actNm;   
                        } 
                	// 활동 기관명
                	if (item.actEngn != null) {
                		if(item.actNm.length > 10){
                        	code += '<br><span class="aplcont">기관명 : '+item.actEngn.substring(0,10)+'...</span>';
                        }else{
                        	code += '<br><span class="aplcont">기관명 : '+item.actEngn+'</span>';
                        } 
                	}
                	// 활동기간
                    code +=  '<td class="aplct">시작일자 : '+item.actBeginYmd.substring(0,4)+'-'+ item.actBeginYmd.substring(4,6)+'-'+ item.actBeginYmd.substring(6,8);
                    code += '<br />종료일자 : '+item.actEndYmd.substring(0,4)+'-'+ item.actEndYmd.substring(4,6)+'-'+ item.actEndYmd.substring(6,8);
                	code += '</td>';
                	// 버튼들 추가
                	code += '<td>';
                	code +=     '<button type="button" class="btn btn-default aplctCancel actDeleteBtn"';
                	code +=     'data-act-no="' + item.actNo + '">삭제</button>';
                	code +=     '<button type="button" class="btn btn-default aplctCancel actEditBtn"';
                	code +=     'data-act-no="' + item.actNo + '"';
                	code +=     'data-act-se-cd="' + item.actSeCd + '"';
                	code +=     'data-act-nm="' + item.actNm + '"';
                	code +=     'data-act-engn="' + item.actEngn + '"';
                	code +=     'data-act-begin-ymd="' + item.actBeginYmd + '"';
                	if (item.actEndYmd != null) {
                	    code += 'data-act-end-ymd="' + item.actEndYmd + '"';
                	}
                	if (item.actCn != null) {
                	    code += 'data-act-cn="' + item.actCn + '"';
                	}
                	code += '>수정</button>';
                	code += '</td>';
                	code += '</tr>';
                });
                $(".actTo").text(result.length);
                $('#actTbody').html(code);
                // hidden 속성을 가진 요소의 초기화
                pat.find('input[type="text"],input[type="number"], input[type="date"], select, textarea').val('');
                pat.find('input[type="text"], input[type="number"], input[type="date"],  select, textarea').prop('selectedIndex', 0);
                $(".act .conBox").attr("hidden", true);
                $(".act .showBox").attr("hidden", false);
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
	// 경험/활동/교육 인서트 끝
	
	// 경험/활동/교육 삭제
	$(document).on("click", ".actDeleteBtn", function() {
	    let actNo = $(this).data("actNo");
	    let rsmNo = $("#rsmNo").val();
	    let tr = $(this).closest("tr");
	    let formData = new FormData();
	    console.log(careerNo)
	    console.log(rsmNo)
	    formData.append("actNo", actNo);
	    formData.append("rsmNo", rsmNo);
	    
	    Swal.fire({
		  	  title: '삭제 하시겠습니까?',
		  	  icon: 'error',
		  	  showCancelButton: true,
		  	  confirmButtonColor: 'white',
		  	  cancelButtonColor: 'white',
		  	  confirmButtonText: '예',
		  	  cancelButtonText: '아니오',
		  	  reverseButtons: false, // 버튼 순서 거꾸로
		  	}).then((result) => {
		  	  if (result.isConfirmed) {
		  		$.ajax({
		            url: "/member/actDeletePost",
		            processData: false,
		            contentType: false,
		            data: formData,
		            type: "post",
		            dataType: "json",
		            beforeSend: function(xhr) {
		                xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
		            },
		            success: function(result) {
		                Toast.fire({
		                    icon: 'success',
		                    title: '경력 삭제 완료'
		                });
		                tr.remove();
		                var total = $(".actTo").text();
		                total--;
		                $(".actTo").text(total);
		            },
		            error: function(xhr, status, error) {
		                console.error("Ajax 요청 실패:", status, error);
		                Toast.fire({
		                    icon: 'error',
		                    title: 'Ajax 요청 실패'
		                });
		            }
		        });
		  	  }
		  	})
	    
	});
	//경험/활동/교육 삭제 끝
// 	경험/활동/교육 수정
	$(document).on("click", ".actEditBtn", function(){
		let actNo = $(this).data("actNo");
		let actSeCd = $(this).data("actSeCd");
		let actNm = $(this).data("actNm");
		let actEngn = $(this).data("actEngn");
		let actBeginYmd = $(this).data("actBeginYmd");
		let actEndYmd = $(this).data("actEndYmd");
		let actCn = $(this).data("actCn");
		
		$("#actNo").val(actNo);
		$("#actNm").val(actNm);
		$("#actEngn").val(actEngn);
		$("#actBeginYmd").val(convertToDateFormat2(actBeginYmd));
		$("#actEndYmd").val(convertToDateFormat2(actEndYmd));
		$("#actCn").val(actCn);

		$("#actSeCd").val(actSeCd).attr('selected', true);
		$(".act .conBox").attr("hidden", false);
		$(".act .showBox").attr("hidden", true);
	})
	
	//자격증폼 변경 시작
	$("#crtfctAcqsSeCd").on("change", function(){
		let val = $(this).val();
		crtfctTransForm(val);
	})
	//자격증폼 변경 끝
	//자격증인서트 시작
	$("#crtfctSaveBtn").on("click", function(){
		if ($('#rsmNo').val().trim()==="") {
	    	Toast.fire({
				icon:'warning',
				title:'기본정보를 먼저 저장해 주세요.'
			});
	        $('#rsmNo').focus();
	        event.preventDefault();
	        return false;
	    }
		if ($('#crtfctAcqsSeCd').val() == null) {
	    	Toast.fire({
				icon:'warning',
				title:'자격·어학·수상 구분을 선택해 주세요.'
			});
	        $('#crtfctAcqsSeCd').focus();
	        event.preventDefault();
	        return false;
	    }
		if ($('#crtfctAcqsSeCd').val() == "CLW002") {
			if($('#crtfctLangCd').val() == null){
		    	Toast.fire({
					icon:'warning',
					title:'언어구분을 선택해 주세요.'
				});
		        $('#crtfctLangCd').focus();
		        event.preventDefault();
		        return false;
			}
			if($('#crtfctAcqsYn').val() == null){
		    	Toast.fire({
					icon:'warning',
					title:'합격여부를 선택해 주세요.'
				});
		        $('#crtfctAcqsYn').focus();
		        event.preventDefault();
		        return false;
			}
	    }
	    if ($('#crtfctNm').val().trim() ===	 "") {
	    	Toast.fire({
				icon:'warning',
				title:'자격·어학·수상명을 입력해 주세요.'
			});
	        $('#crtfctNm').focus();
	        event.preventDefault();
	        return false;
	    }
		if ($('#crtfctAcqsSeCd').val() == "CLW001"||$('#crtfctAcqsSeCd').val() == "CLW003") {
		   if ($('#crtfctPblcnoffic').val().trim() ===	 "") {
		    	Toast.fire({
					icon:'warning',
					title:'발행처·기관을 입력해 주세요.'
				});
		        $('#crtfctPblcnoffic').focus();
		        event.preventDefault();
		        return false;
		    }
	    }
		if ($('#crtfctAcqsSeCd').val() == "CLW001") {
			if($('#crtfctAcqsSe').val() == null){
		    	Toast.fire({
					icon:'warning',
					title:'합격구분을 선택해 주세요.'
				});
		        $('#crtfctAcqsSe').focus();
		        event.preventDefault();
		        return false;
			}
	    }
        // 자격증 정보 추출
        let crtfctNo = $("#crtfctNo").val();
        let rsmNo = $("#rsmNo").val();
        let crtfctAcqsSeCd = $("#crtfctAcqsSeCd").val();
        let crtfctNm = $("#crtfctNm").val();
        let crtfctPblcnoffic = $("#crtfctPblcnoffic").val();
        let crtfctAcqsSe = $("#crtfctAcqsSe").val();
        let crtfctAcqsYm = $("#crtfctAcqsYm").val();
        let crtfctScr = $("#crtfctScr").val();
        let crtfctLangCd = $("#crtfctLangCd").val();
        let crtfctAcqsYn = $("#crtfctAcqsYn").val();
        // FormData 객체 생성
        let formData = new FormData();
		
        if(crtfctScr == ""||crtfctScr ==null){
        	crtfctScr = 0;
        }
        // 자격증 정보 추가
        if($('#crtfctNo').val().trim() !== ""||$('#crtfctNo').val()!==null){
	        formData.append("crtfctNo", crtfctNo);
        }
        formData.append("rsmNo", rsmNo);
        formData.append("crtfctAcqsSeCd", crtfctAcqsSeCd);
        formData.append("crtfctNm", crtfctNm);
        formData.append("crtfctPblcnoffic", crtfctPblcnoffic);
        formData.append("crtfctAcqsSe", crtfctAcqsSe);
        formData.append("crtfctAcqsYm", crtfctAcqsYm);
        formData.append("crtfctScr", crtfctScr);
        formData.append("crtfctLangCd", crtfctLangCd);
        formData.append("crtfctAcqsYn", crtfctAcqsYn);

        $.ajax({
            url: "/member/crtfctRegistPost",
            processData: false,
            contentType: false,
            data: formData,
            type: "post",
            dataType: "json",
            beforeSend: function(xhr) {
                xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
            },
            success: function(result) {
                Toast.fire({
                    icon: 'success',
                    title: '자격증 저장 완료'
                });
                let code = "";
                result.forEach(function(item, index) {
                    code += `<tr>
                        <td class="aplct">` + item.crtfctAcqsSeCdNm + `</td>
                        <td class="aplct">` + item.crtfctNm;
                        
                    if (item.crtfctPblcnoffic != null) {
                        code += `<br><span class="aplcont">` + item.crtfctPblcnoffic + `</span>`;
                    }
                    code += `</td><td class="aplct">`;
                    if (item.crtfctAcqsSeNm != null) {
                        code += item.crtfctAcqsSeNm+`<br />`;
                    }
                    if (item.crtfctAcqsYnNm != null) {
                        code += item.crtfctAcqsYnNm+`<br />`;
                    }
                    if (item.crtfctAcqsYm != null) {
                        code += `<span class="aplcont">` + item.crtfctAcqsYm.substring(0, 4) + `-` + item.crtfctAcqsYm.substring(4, 6)+`</span>`;
                    }
                    code += `</td>
                        <td>
                            <button type="button"
                                class="btn btn-default aplctCancel crtfctDeleteBtn"
                                data-crtfct-no="` + item.crtfctNo + `">삭제</button>
                            <button type="button"
                                class="btn btn-default aplctCancel crtfctEditBtn"
                                data-crtfct-no="` + item.crtfctNo + `"
                                data-crtfct-acqs-se-cd="` + item.crtfctAcqsSeCd + `"
                                data-crtfct-nm="` + item.crtfctNm + `"
                                data-crtfct-pblcnoffic="` + item.crtfctPblcnoffic + `"
                                data-crtfct-Acqs-se="` + item.crtfctAcqsSe + `"
                       		    data-crtfct-acqs-ym="` + item.crtfctAcqsYm+ `"
                        		data-crtfct-scr="` + item.crtfctScr+ `"
                        		data-crtfct-lang-cd="` + item.crtfctLangCd+ `"
                        		data-crtfct-acqs-yn="` + item.crtfctAcqsYn+ `"
                    	>수정</button>
                        </td>
                    </tr>`;
                });
                $(".cartifctTo").text(result.length);
                $('#crtfctbody').html(code);
                // hidden 속성을 가진 요소의 초기화
                $('.crtfct input[type="text"], .crtfct input[type="number"], .crtfct input[type="date"], .crtfct select').val('');
                
                $('.crtfct input[type="text"], .crtfct input[type="number"], .crtfct input[type="date"], .crtfct select').prop('selectedIndex', 0);
                $('.crtfct .nohide').attr("hidden", false); 
                $(".crtfct .conBox").attr("hidden", true);
                $(".crtfct .showBox").attr("hidden", false);
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
// 	자격증 인서트 끝
// 자격증 삭제
	$(document).on("click", ".crtfctDeleteBtn", function() {
	    let crtfctNo = $(this).data("crtfctNo");
	    let rsmNo = $("#rsmNo").val();
	    console.log(crtfctNo)
	    let tr = $(this).closest("tr");
	    let formData = new FormData();
	    formData.append("crtfctNo", crtfctNo);
	    formData.append("rsmNo", rsmNo);
	    
	    console.log("딸깍!")
	    
	    Swal.fire({
	  	  title: '삭제 하시겠습니까?',
	  	  icon: 'error',
	  	  showCancelButton: true,
	  	  confirmButtonColor: 'white',
	  	  cancelButtonColor: 'white',
	  	  confirmButtonText: '예',
	  	  cancelButtonText: '아니오',
	  	  reverseButtons: false, // 버튼 순서 거꾸로
	  	}).then((result) => {
	  	  if (result.isConfirmed) {
	  		$.ajax({
	            url: "/member/crtfctDeletePost",
	            processData: false,
	            contentType: false,
	            data: formData,
	            type: "post",
	            dataType: "json",
	            beforeSend: function(xhr) {
	                xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
	            },
	            success: function(result) {
	                Toast.fire({
	                    icon: 'success',
	                    title: '자격증 삭제 완료'
	                });
	                tr.remove();
	                var total = $(".cartifctTo").text();
	                total--;
	                $(".cartifctTo").text(total);
	            },
	            error: function(xhr, status, error) {
	                console.error("Ajax 요청 실패:", status, error);
	                Toast.fire({
	                    icon: 'error',
	                    title: 'Ajax 요청 실패'
	                });
	            }
	        });
	  	  }
	  	})
	    
	    
	    
	});
// 	자격증 수정
	$(document).on("click", ".crtfctEditBtn", function(){
        let crtfctAcqsSeCd = $(this).data("crtfctAcqsSeCd");
		crtfctTransForm(crtfctAcqsSeCd);
		let crtfctNo = $(this).data("crtfctNo");
        let crtfctNm = $(this).data("crtfctNm");
        let crtfctPblcnoffic = $(this).data("crtfctPblcnoffic");
        let crtfctAcqsSe = $(this).data("crtfctAcqsSe");
        let crtfctAcqsYm = $(this).data("crtfctAcqsYm");
        let crtfctScr = $(this).data("crtfctScr");
        let crtfctLangCd = $(this).data("crtfctLangCd");
        let crtfctAcqsYn = $(this).data("crtfctAcqsYn");
		$("#crtfctNo").val(crtfctNo);
		$("#crtfctNm").val(crtfctNm);
		$("#crtfctPblcnoffic").val(crtfctPblcnoffic);
		$("#crtfctAcqsYm").val(convertToDateFormat3(crtfctAcqsYm));
		$("#crtfctScr").val(crtfctScr);

		$("#crtfctAcqsSeCd").val(crtfctAcqsSeCd).attr('selected', true);
		$("#crtfctAcqsSe").val(crtfctAcqsSe).attr('selected', true);
		$("#crtfctLangCd").val(crtfctLangCd).attr('selected', true);
		$("#crtfctAcqsYn").val(crtfctAcqsYn).attr('selected', true);
		$(".crtfct .conBox").attr("hidden", false);
		$(".crtfct .showBox").attr("hidden", true);
	})
	//포플폼 변경 시작
	$("#prtSeCd").on("change", function(){
		let val = $(this).val();
		prtTransForm(val);
	})
	//포플폼 변경 끝
	//포플인서트 시작
	$("#prtSaveBtn").on("click", function(){
		if ($('#rsmNo').val().trim()==="") {
	    	Toast.fire({
				icon:'warning',
				title:'기본정보를 먼저 저장해 주세요.'
			});
	        $('#rsmNo').focus();
	        event.preventDefault();
	        return false;
	    }
		if ($('#prtSeCd').val() == null) {
	    	Toast.fire({
				icon:'warning',
				title:'포트폴리오 구분을 선택해 주세요.'
			});
	        $('#prtSeCd').focus();
	        event.preventDefault();
	        return false;
	    }
	    if ($('#prtTtl').val().trim() ===	 "") {
	    	Toast.fire({
				icon:'warning',
				title:'제목을 입력해 주세요.'
			});
	        $('#prtTtl').focus();
	        event.preventDefault();
	        return false;
	    }
		if ($('#prtSeCd').val() == "POTY01") {
			if($("input[name='uploadFile2']").val() == null){
		    	Toast.fire({
					icon:'warning',
					title:'파일을 선택해 주세요.'
				});
		    	$("input[name='uploadFile2']").focus();
		        event.preventDefault();
		        return false;
			}
	    }
		if ($('#prtSeCd').val() == "POTY02") {
			if($('#prtUrl').val() == null){
		    	Toast.fire({
					icon:'warning',
					title:'URL주소를 입력해 주세요.'
				});
		        $('#prtUrl').focus();
		        event.preventDefault();
		        return false;
			}
	    }
        // 포플 정보 추출
        let prtNo = $("#prtNo").val();
        let rsmNo = $("#rsmNo").val();
        let prtSeCd = $("#prtSeCd").val();
        let prtTtl = $("#prtTtl").val();
        let prtUrl = $("#prtUrl").val();
        let uploadFile2 = $("input[name='uploadFile2']");
    	//이미지 파일들 (a001.jpg..)
    	let files =	uploadFile2[0].files;
        // FormData 객체 생성890-
        let formData = new FormData();
		
        // 포플 정보 추가
        if($('#prtNo').val().trim() !== ""||$('#prtNo').val()!==null){
	        formData.append("prtNo", prtNo);
        }
        formData.append("rsmNo", rsmNo);
        formData.append("prtSeCd", prtSeCd);
        formData.append("prtTtl", prtTtl);
        formData.append("prtUrl", prtUrl);
    	for(let i=0; i<files.length; i++){
	    	formData.append("uploadFile",files[i]);			
		}

        $.ajax({
            url: "/member/prtRegistPost",
            processData: false,
            contentType: false,
            data: formData,
            type: "post",
            dataType: "json",
            beforeSend: function(xhr) {
                xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
            },
            success: function(result) {
                Toast.fire({
                    icon: 'success',
                    title: '포트폴리오 저장 완료'
                });
                let code = "";
                result.forEach(function(item, index) {
                    code += `<tr>
                        <td class="aplct">` + item.prtSeCdNm + `</td>
                        <td class="aplct">` + item.prtTtl;
                        
                    code += `</td><td class="aplct">`;
                    if (item.prtUrl != null) {
                        code += `<button type="button"
        					class="btn btn-default aplctCancel prtURLBtn"
        					data-act-no="`+item.prtUrl+`"><a href="${rsmPortfolioVO.prtUrl}">홈페이지 가기</a></button>`;
                    }
                    if (item.prtFile != null) {
                        code += `<button type="button"
							class="btn btn-default aplctCancel prtDownloadBtn"
							data-toggle="modal" data-target="#downloadModal">다운로드</button>`;
                    }
                    code += `</td>
                        <td>
                            <button type="button"
                                class="btn btn-default aplctCancel prtDeleteBtn"
                                data-prt-no="` + item.prtNo + `">삭제</button>
                            <button type="button"
                                class="btn btn-default aplctCancel prtEditBtn"
                                data-prt-no="` + item.prtNo + `"
                                data-prt-se-cd="` + item.prtSeCd + `"
                                data-prt-ttl="` + item.prtTtl + `"
                                data-prt-file="` + item.prtFile + `"
                                data-prt-url="` + item.prtUrl + `"
                    	>수정</button>
                        </td>
                    </tr>`;
                });
                $(".prtTo").text(result.length);
                $('#prtbody').html(code);
                // hidden 속성을 가진 요소의 초기화
                $('.prt input[type="text"], .prt input[type="file"], .prt input[type="number"], .prt input[type="date"], .prt select').val('');
                
                $('.prt input[type="text"], .prt input[type="number"], .prt input[type="date"], .prt select').prop('selectedIndex', 0);
                $('.prt .nohide').attr("hidden", false); 
                $(".prt .conBox").attr("hidden", true);
                $(".prt .showBox").attr("hidden", false);
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
// 	포플 인서트 끝
// 포플 삭제
	$(document).on("click", ".prtDeleteBtn", function() {
	    let prtNo = $(this).data("prtNo");
	    let rsmNo = $("#rsmNo").val();
	    console.log(prtNo)
	    let tr = $(this).closest("tr");
	    let formData = new FormData();
	    formData.append("prtNo", prtNo);
	    formData.append("rsmNo", rsmNo);
	    
	    Swal.fire({
		  	  title: '삭제 하시겠습니까?',
		  	  icon: 'error',
		  	  showCancelButton: true,
		  	  confirmButtonColor: 'white',
		  	  cancelButtonColor: 'white',
		  	  confirmButtonText: '예',
		  	  cancelButtonText: '아니오',
		  	  reverseButtons: false, // 버튼 순서 거꾸로
		  	}).then((result) => {
		  	  if (result.isConfirmed) {
		  	    $.ajax({
		            url: "/member/prtDeletePost",
		            processData: false,
		            contentType: false,
		            data: formData,
		            type: "post",
		            dataType: "json",
		            beforeSend: function(xhr) {
		                xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
		            },
		            success: function(result) {
		                Toast.fire({
		                    icon: 'success',
		                    title: '포트폴리오 삭제 완료'
		                });
		                tr.remove();
		                var total = $(".prtTo").text();
		                total--;
		                $(".prtTo").text(total);
		            },
		            error: function(xhr, status, error) {
		                console.error("Ajax 요청 실패:", status, error);
		                Toast.fire({
		                    icon: 'error',
		                    title: 'Ajax 요청 실패'
		                });
		            }
		        });
		  	  }
		  	})
	    

	    
	});
// 	포플 수정
	$(document).on("click", ".prtEditBtn", function(){
        let prtSeCd = $(this).data("prtSeCd");
        prtTransForm(prtSeCd);
		let prtNo = $(this).data("prtNo");
        let prtFile = $(this).data("prtFile");
        let prtUrl = $(this).data("prtUrl");
        let prtTtl = $(this).data("prtTtl");
		$("#prtNo").val(prtNo);
		$("#prtFile").val(prtFile);
		$("#prtUrl").val(prtUrl);
		$("#prtTtl").val(prtTtl);

		$("#prtSeCd").val(prtSeCd).attr('selected', true);
		$(".prt .conBox").attr("hidden", false);
		$(".prt .showBox").attr("hidden", true);
	})
		
	// 	자소서 인서트 시작
	$("#CLSaveBtn").on("click", function(){
		if ($('#rsmNo').val().trim()==="") {
	    	Toast.fire({
				icon:'warning',
				title:'기본정보를 먼저 저장해 주세요.'
			});
	        $('#rsmNo').focus();
	        event.preventDefault();
	        return false;
	    }
		if ($('#clTtl').val().trim() === "") {
	    	Toast.fire({
				icon:'warning',
				title:'제목을 입력해 주세요.'
			});
	        $('#clTtl').focus();
	        event.preventDefault();
	        return false;
	    }
		if ($('#clCn').val().trim() === "") {
	    	Toast.fire({
				icon:'warning',
				title:'내용을 입력해 주세요.'
			});
	        $('#clCn').focus();
	        event.preventDefault();
	        return false;
	    }
	   	
		var today = new Date();

        // 년, 월, 일 추출
        var year = today.getFullYear();
        console.log(year);
        var month = today.getMonth() + 1; // 월은 0부터 시작하므로 +1 해줌
        console.log(month);
        if(month < 10){ 
        	month += ""+0+month;
        }
        var day = today.getDate();
        if(day < 10){
        	day = ""+0+day;
        }
        console.log(day);
        var formattedDate = ""+year+month+day;
        console.log(formattedDate);
		
        // 자소서 정보 추출
        let clNo = $("#clNo").val();
        let rsmNo = $("#rsmNo").val();
        let clTtl = $("#clTtl").val();
        let clCn = $("#clCn").val();
        // FormData 객체 생성
        let formData = new FormData();

        // 자소서 정보 추가
        if($('#clNo').val().trim() !== ""||$('#clNo').val()!==null){
	        formData.append("clNo", clNo);
        }
        formData.append("rsmNo", rsmNo);
        formData.append("clTtl", clTtl);
        formData.append("clCn", clCn);
        formData.append("clWritngYmd", formattedDate);
		
        let pat = $(this).parents(".conBox");
        
        $.ajax({
            url: "/member/CLRegistPost",
            processData: false,
            contentType: false,
            data: formData,
            type: "post",
            dataType: "json",
            beforeSend: function(xhr) {
                xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
            },
            success: function(result) {
                Toast.fire({
                    icon: 'success',
                    title: '자소서 저장 완료'
                });
                let code = "";
                result.forEach(function(item, index) {
                    code += `<tr>
                        <td class="aplct">`;
                    if(item.clCn.length > 10){
                    	code += item.clTtl.substring(0,10)+`...`;
                    }else{
                    	code += item.clTtl;
                    } 
                    code +=`</td>
                        <td class="aplct">`;
                    if(item.clCn.length > 10){
                    	code += item.clCn.substring(0,10)+`...`;
                    }else{
                    	code += item.clCn;
                    } 
                    code += `</td>
                        <td class="aplct">`+item.clWritngYmd.substring(0,4)+`-`+ item.clWritngYmd.substring(4,6)+`-`+ item.clWritngYmd.substring(6,8)
                    +`</td>
                        <td>
                        	<button type="button" class="btn btn-default aplctCancel CLDeleteBtn"
                        		data-cl-no="`+item.clNo+`">삭제</button>
                            <button type="button" class="btn btn-default aplctCancel CLEditBtn"
                               data-cl-no="`+item.clNo+`"
                               data-cl-ttl="`+item.clTtl+`" 
                               data-cl-cn="`+item.clCn+`" 
                               data-cl-writng-ymd="`+item.clWritngYmd+`" 
                               data-cl-sn="`+item.clSn+`">수정</button>
                        </td>
                     </tr>`;
                });
                $(".CLTo").text(result.length);
                $('#CLTbody').html(code);
                // hidden 속성을 가진 요소의 초기화
                pat.find('input[type="text"],input[type="number"], input[type="date"], select, textarea').val('');
                pat.find('input[type="text"], input[type="number"], input[type="date"],  select, textarea').prop('selectedIndex', 0);
                $(".CL .conBox").attr("hidden", true);
                $(".CL .showBox").attr("hidden", false);
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
	// 자소서 인서트 끝
	
	// 자소서 삭제
	$(document).on("click", ".CLDeleteBtn", function() {
	    let clNo = $(this).data("clNo");
	    let rsmNo = $("#rsmNo").val();
	    let tr = $(this).closest("tr");
	    let formData = new FormData();
	    formData.append("clNo", clNo);
	    formData.append("rsmNo", rsmNo);
	    
	    Swal.fire({
		  	  title: '삭제 하시겠습니까?',
		  	  icon: 'error',
		  	  showCancelButton: true,
		  	  confirmButtonColor: 'white',
		  	  cancelButtonColor: 'white',
		  	  confirmButtonText: '예',
		  	  cancelButtonText: '아니오',
		  	  reverseButtons: false, // 버튼 순서 거꾸로
		  	}).then((result) => {
		  	  if (result.isConfirmed) {
		  		 $.ajax({
		             url: "/member/CLDeletePost",
		             processData: false,
		             contentType: false,
		             data: formData,
		             type: "post",
		             dataType: "json",
		             beforeSend: function(xhr) {
		                 xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
		             },
		             success: function(result) {
		                 Toast.fire({
		                     icon: 'success',
		                     title: '자기소개서 삭제 완료'
		                 });
		                 tr.remove();
		                 var total = $(".CLTo").text();
		                 total--;
		                 $(".CLTo").text(total);
		                 
		             },
		             error: function(xhr, status, error) {
		                 console.error("Ajax 요청 실패:", status, error);
		                 Toast.fire({
		                     icon: 'error',
		                     title: 'Ajax 요청 실패'
		                 });
		             }
		         });
		  	  }
		  	})
	});
	//자소서 삭제 끝
// 	자소서 수정
	$(document).on("click", ".CLEditBtn", function(){
		let clNo = $(this).data("clNo");
		let clTtl = $(this).data("clTtl");
		let clCn = $(this).data("clCn");
		$("#clNo").val(clNo);
		$("#clTtl").val(clTtl);
		$("#clCn").val(clCn);
		$(".CL .conBox").attr("hidden", false);
		$(".CL .showBox").attr("hidden", true);
	})
	
	// 이력서 작성 끝!!!!!!!!
	$("#lastSaveBtn").on("click", function(){
		let rsmTtl = $("#rsmTtl").val();
	    let rsmNo = $("#rsmNo").val();
		let formData = new FormData();
		formData.append("rsmTtl", rsmTtl);
		formData.append("rsmNo", rsmNo);
		
		if ($('#rsmNo').val().trim()==="") {
	    	Toast.fire({
				icon:'warning',
				title:'기본정보를 먼저 저장해 주세요.'
			});
	        $('#rsmNo').focus();
	        event.preventDefault();
	        return false;
	    }
		$.ajax({
	           url: "/member/lastSavePost",
	           processData: false,
	           contentType: false,
	           data: formData,
	           type: "post",
	           dataType: "json",
	           beforeSend: function(xhr) {
	               xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
	           },
	           success: function(result) {
	               Toast.fire({
	                   icon: 'success',
	                   title: '이력서 작성 완료'
	               });
					location.href="/member/resume"	               
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
	$("#resumeReadBtn").on("click", function() {
		if ($('#rsmNo').val().trim()==="") {
	    	Toast.fire({
				icon:'warning',
				title:'기본정보를 먼저 저장해 주세요.'
			});
	        $('#rsmNo').focus();
	        event.preventDefault();
	        return false;
	    }
	    var popup = window.open('', '이력서 보기', 'width=1100,height=1440,top=' + (screen.height/2 - 720) + ',left=' + (screen.width/2 - 460));
	    
	    // 폼 데이터를 전송
	    $("#resumeReadForm").attr("target", '이력서 보기'); // 새 창의 이름을 설정
	    $("#resumeReadForm").submit(); // 폼 제출
	});
	

    // 선택 버튼 클릭 이벤트
    $(".CLCopyRegistBtn").on("click", function(){
        let clTtl = $(this).data("clTtl");
        let clCn = $(this).data("clCn");
        
        // 값 입력
        $("#clNo").val(null);
        $("#clTtl").val(clTtl);
        $("#clCn").val(clCn);
        
        // 모든 카드 닫기
        $('.card').prop("class", "card collapsed-card");
        
        // 스크롤을 맨 위로
        $('.modal-content').scrollTop(0);
        $(".CL .conBox").attr("hidden", false);
		$(".CL .showBox").attr("hidden", true);
        $("#CLSaveBtn").focus();
        // 모달 닫기
        $('#clCopyModal').modal('hide');
    });
    
    function calculateAge(birthdateNumber) {
        // 생년월일을 숫자로 받음 (예: 20240518)
        const birthdateString = birthdateNumber.toString();

        // 연, 월, 일을 추출
        const year = parseInt(birthdateString.substring(0, 4), 10);
        const month = parseInt(birthdateString.substring(4, 6), 10) - 1; // 월은 0부터 시작하므로 -1
        const day = parseInt(birthdateString.substring(6, 8), 10);

        // 생년월일을 Date 객체로 생성
        const birthdate = new Date(year, month, day);
        
        // 현재 날짜 가져오기
        const today = new Date();
        
        // 나이 계산
        let age = today.getFullYear() - birthdate.getFullYear();
        
        // 아직 생일이 지나지 않았으면 나이에서 1을 뺌
        const monthDiff = today.getMonth() - birthdate.getMonth();
        if (monthDiff < 0 || (monthDiff === 0 && today.getDate() < birthdate.getDate())) {
            age--;
        }

        return age;
    }
    let birth = ${memVO.mbrBrdt};
	let age = calculateAge(birth);
	$("#age").text(age);
	
	$(document).on("click", ".fileDwonloadtBtn",function(){
		console.log("ieuafhiwe");
		let filePath = $(this).data("filePath");
		location.href="/download?fileName="+filePath;
	})
	$("#mg1").on("click",function(){
		$("#rsmCareerCd").val("RSCA02").attr('selected', true);
		$("#rsmCrdtCd").val("CRDT007").attr('selected', true);
		$("#rsmSalCd").val("SAL14").attr('selected', true);
		$("#rsmMemo").val("405호 모두 화이팅!!!~~~");
	})
	$("#mg2").on("click",function(){
		$("#acbgSeCd").val("ACSE001").attr('selected', true);
		acbgTransForm("ACSE001")
		$("#acbgSchlNm").val("부여고등학교");
		$("#acbgMjrNm").val("이과");
		$("#acdmcrGrdtnSeCd").val("ACGD001").attr('selected', true);
		$("#acbgMtcltnym").val("2015-03");
		$("#acbgGrdtnym").val("2018-02");
		$(".acbg .conBox").attr("hidden", false);
		$(".acbg .showBox").attr("hidden", true);
	})
	$("#mg3").on("click",function(){
		$("#acbgSeCd").val("ACSE002").attr('selected', true);
		acbgTransForm("ACSE002")
		$("#acbgSchlNm").val("한남대학교");
		$("#acbgMjrNm").val("컴퓨터공학과");
		$("#acbgRcognacbgCd").val("ACRC002").attr('selected', true);
		$("#acdmcrGrdtnSeCd").val("ACGD004").attr('selected', true);
		$("#acbgMtcltnym").val("2018-03");
		$("#acbgPnt").val("3.6");
		$("#acbgPntCd").val("AGPN003").attr('selected', true);
		$(".acbg .conBox").attr("hidden", false);
		$(".acbg .showBox").attr("hidden", true);
	})
	$("#mg4").on("click",function(){
		$("#careerEntNm").val("대덕그룹");
		$("#careerJncmpYmd").val("2024-03-04");
		$("#careerRetireYmd").val("2024-10-22");
		$("#careerDept").val("405호 1팀");
		$("#careerTask").val("팀에서 DA를 맡아 데이터베이스 설계와 유지보수를 중심으로 업무를 맡아왔습니다. 공통으로 사용하는 클래스들의 모듈화 하여 사용하기 편하도록 하기위해 노력했습니다.");
		$("#careerAnslry").val("500");
		$("#careerDtyCd").val("CRDT020").attr('selected', true);
		$("#careerJbgdCd").val("CRBG08").attr('selected', true);
		$("#careerWorkRgnCd").val("WRGN04").attr('selected', true);
		$(".career .conBox").attr("hidden", false);
		$(".career .showBox").attr("hidden", true);
	})
})
</script>
<c:set var="formattedPhone"
	value="${fn:substring(resumeVO.mbrPhone, 0, 3)}-${fn:substring(resumeVO.mbrPhone, 3, 7)}-${fn:substring(resumeVO.mbrPhone, 7, 11)}" />
<div style="position:fixed;bottom: 80px; right: 0; display: flex; flex-direction: column; padding: 20px;">
	<button class="ddalkkack" id="mg1">딸깍</button>
	<button class="ddalkkack" id="mg2">딸깍</button>
	<button class="ddalkkack" id="mg3">딸깍</button>
	<button class="ddalkkack" id="mg4">딸깍</button>
</div>
<div style="zoom: 0.90; margin-bottom: 300px;">
	<div id="registMain">
		<!-- 	정렬순서 및 선택 사항 추가 창 -->
		<div class="registForm-sub" style="z-index: 1;">
			<div class="aBtn">
				<div>
					<a href="#1">기본정보</a>
				</div>
				<div>
					<p>필수</p>
				</div>
			</div>
			<div class="aBtn">
				<a href="#3">학력</a>
				<c:choose>
					<c:when test="${rsmAcademicVOList.size() > 0}">
						<span class="total acbgTo">${rsmAcademicVOList.size()}</span>
					</c:when>
					<c:otherwise>
						<span class="total acbgTo">0</span>
					</c:otherwise>
				</c:choose>
			</div>
			<div class="aBtn">
				<a href="#4">경력</a>
				<c:choose>
				<c:when test="${rsmCareerVOList.size() > 0}">
					<span class="total careerTo">${rsmCareerVOList.size()}</span>
				</c:when>
				<c:otherwise>
					<span class="total careerTo">0</span>
				</c:otherwise>
			</c:choose>
			</div>
			<div class="aBtn">
				<a href="#5">스킬</a>
				<c:choose>
				<c:when test="${rsmSkillVOList.size() > 0}">
					<span class="total skillTo">${rsmSkillVOList.size()}</span>
				</c:when>
				<c:otherwise>
					<span class="total skillTo">0</span>
				</c:otherwise>
			</c:choose>
			</div>
			
			<div class="aBtn">
				<a href="#6">경험/활동/교육</a>
				<c:choose>
				<c:when test="${rsmExpactEDCVOList.size() > 0}">
					<span class="total actTo">${rsmExpactEDCVOList.size()}</span>
				</c:when>
				<c:otherwise>
					<span class="total actTo">0</span>
				</c:otherwise>
			</c:choose>
			</div>
			
			<div class="aBtn">
				<a href="#7">자격/어학/수상</a>
				<c:choose>
				<c:when test="${rsmCertificateVOList.size() > 0}">
					<span class="total cartifctTo">${rsmCertificateVOList.size()}</span>
				</c:when>
				<c:otherwise>
					<span class="total cartifctTo">0</span>
				</c:otherwise>
			</c:choose>
			</div>
			
			<div class="aBtn">
				<a href="#8">포트폴리오 및 기타문서</a>
				<c:choose>
				<c:when test="${rsmPrtVOList.size() > 0}">
					<span class="total prtTo">${rsmPrtVOList.size()}</span>
				</c:when>
				<c:otherwise>
					<span class="total prtTo">0</span>
				</c:otherwise>
			</c:choose>
			</div>
			
			<div class="aBtn" style="margin-bottom: 25px;">
				<a href="#9">자기소개서</a>
				<c:choose>
				<c:when test="${rsmClVOList.size() > 0}">
					<span class="total CLTo">${rsmClVOList.size()}</span>
				</c:when>
				<c:otherwise>
					<span class="total CLTo">0</span>
				</c:otherwise>
			</c:choose>
			</div>
			
			<form action="/member/resumeRead" method="post"
				style="width: 100%" id="resumeReadForm">
				<input type="hidden" id="readRsmNo" name="rsmNo" value="${resumeVO.rsmNo }" />
				<button type="button" class="submitBtn" id="resumeReadBtn" style="width: 100%">이력서
					보기</button>
				<sec:csrfInput />
			</form>
		</div>
		<!-- 		이력서 제목및 저장 탭 -->
		<div class="registForm-bottom row">
			<div>
				<div class="form-group width-xl">
					<label for="rsmTtl" id="reg1label">제목*</label> <input type="text"
						class="form-control" placeholder="이력서 제목을 입력해주세요." name="rsmTtl"
						id="rsmTtl" value="${memVO.mbrNm }님의 이력서" required />
				</div>
			</div>
			<div>
				<button id="lastSaveBtn" class="submitBtn"
					style="margin: 35px 0px 0px 20px">저장</button>
			</div>
		</div>
		<!-- 	기본정보 입력창 -->
		<div class="registForm basic" id="1">
			<div>
				<p id="h3">
					기본정보 <span class="reqHint">필수*</span>
				</p>

			</div>
			<br />
			<div class="showBox" hidden="hidden">
				<div class="row" id="basicInfo">
					<div class="basText-l">
						<div class="font-15 bold-5 gray">
							<div class="resumeTop">
								<b class="basName">${resumeVO.mbrNm }</b> <span class="hili">${resumeVO.rsmCareerCdNm }</span>
							</div>
							<div class="hopepe" id="hopepe">
								${resumeVO.mbrBrdt.substring(0,4)} ${resumeVO.mbrSexdstncdNm } (<b
									id="age"></b>세)&nbsp;&nbsp; |&nbsp;&nbsp;
								희망사항(${resumeVO.rsmCrdtCdNm } · ${resumeVO.rsmSalCdNm })
							</div>
							<div class="bold-4 margin-bottom-2" id="emlllll">
								이메일 &nbsp;&nbsp;<b class="black">${resumeVO.mbrEml }</b>&nbsp;&nbsp;
								|&nbsp;&nbsp; 휴대폰 &nbsp;&nbsp;<b class="black">${formattedPhone }</b>
							</div>
							<div class="bold-4" id="addddr">
								주소 &nbsp;&nbsp;<b class="black">(${resumeVO.mbrZip})
									${resumeVO.mbrAddr }</b>
							</div>
						</div>
					</div>
					<div class="basImg">
						<img src="${resumeVO.fileDetailVOList[0].filePathNm }">
					</div>
				</div>
				<div class="row idForm btnForm">
					<button class="submitBtn" id="basInfoEditBtn" style="margin: 0px">수정</button>
				</div>
			</div>
			<div class="conBox">
				<div class="inputForm">
					<input type="text" class="form-control" name="rsmNo" id="rsmNo"
						value="${resumeVO.rsmNo }" hidden="hidden" required /> <input
						type="text" class="form-control" name="mbrId" id="mbrId"
						value="${memVO.mbrId }" hidden="hidden" required />
					<div class="row idForm">
						<div class="form-group width-l">
							<label for="mbrNm" id="reg1label">이름*</label> <input type="text"
								class="form-control" placeholder="이름을 입력하세요" name="mbrNm"
								id="mbrNm" value="${memVO.mbrNm }" maxlength='20' required />
						</div>
						<div class="form-group width-s">
							<label for="mbrSexdstncd" id="reg1label">성별*</label> <select
								class="form-control" name="mbrSexdstncd" id="mbrSexdstncd">
								<option value="" disabled selected>성별선택*</option>
								<c:forEach var="codeVO"
									items="${codeGrpVOMap.get('GEND').codeVOList }"
									varStatus="stus">
									<option value="${codeVO.comCode}"
										<c:if test="${memVO.mbrSexdstnCd==codeVO.comCode}"> selected</c:if>>${codeVO.comCodeNm}</option>
								</c:forEach>
							</select>
						</div>
						<div class="form-group width-s">
							<label for="mbrBrdt" id="reg1label">생년월일*</label> <input
								type="text" class="form-control" placeholder="ex)19990518"
								name="mbrBrdt" id="mbrBrdt" value="${memVO.mbrBrdt }"
								required />
						</div>
					</div>
					<div class="row imgForm">
						<!-- 					이력서 이미지 -->
						<input type="file" class="form-control" name="uploadFile"
							id="uploadFile" hidden="hidden" />
						<div class="form-group">
							<div class="imgCover" id="ivImg">
								<c:if test="${memVO.fileGroupSn ==null }">
									<img src="/resources/images/rsmImg.png" id="pImg" class="pImg"
										style="cursor: pointer;">
								</c:if>
								<c:if test="${memVO.fileGroupSn!=null }">
									<img src="${memVO.fileDetailVOList[0].filePathNm }"
										id="pImg" class="pImg" style="cursor: pointer;">
								</c:if>
							</div>
						</div>
					</div>
					<div class="row idForm">
						<div class="form-group width-l">
							<label for="mbrPhone" id="reg1label">휴대폰번호*</label> <input
								type="text" class="form-control"
								placeholder="-를 제외한 번호만 입력해주세요." name="mbrPhone" id="mbrPhone"
								value="${memVO.mbrTelno }" required />
						</div>
						<div class="form-group width-l">
							<label for="mbrTelno" id="reg1label">전화번호</label> <input
								type="text" class="form-control" value="${resumeVO.mbrTelno }"
								placeholder="-를 제외한 번호만 입력해주세요." name="mbrTelno" id="mbrTelno" />
						</div>
					</div>
					<div class="row idForm">
						<div class="form-group width-l">
							<label for="mbrEml" id="reg1label">이메일*</label> <input
								type="text" class="form-control" placeholder="이메일을 입력해주세요."
								name="mbrEml" id="mbrEml" value="${memVO.mbrEml }" required />
						</div>
						<div class="form-group width-lz">
							<label for="rsmCareerCd" id="reg1label">직무능력*</label> <select
								class="form-control" name="rsmCareerCd" id="rsmCareerCd">
								<option value="" disabled selected>직무능력 선택*</option>
								<c:forEach var="codeVO"
									items="${codeGrpVOMap.get('RSCA').codeVOList }"
									varStatus="stus">
									<option value="${codeVO.comCode}"
										<c:if test="${resumeVO.rsmCareerCd == codeVO.comCode}">selected</c:if>>${codeVO.comCodeNm}</option>
								</c:forEach>
							</select>
						</div>
					</div>

					<div class="row idForm" style="margin-bottom: -32px;">
						<div class="form-group width-l">
							<label for="mbrAddr" id="reg1label">주소*</label> <input
								type="text" class="form-control" placeholder="주소를 입력해주세요."
								name="mbrAddr" id="mbrAddr" readonly="readonly"
								value="${memVO.mbrAddr }" required /> <input type="text"
								class="form-control" placeholder="주소를 입력해주세요." name="mbrZip"
								id="mbrZip" readonly="readonly" value="${memVO.mbrZip }"
								hidden="hidden" required />
							<p style="margin-top: -12px;">*주소를 클릭하면 주소를 검색할 수 있습니다.</p>
						</div>
						<div class="form-group width-l">
							<label for="mbrAddrDtl" id="reg1label">상세주소*</label> <input
								type="text" class="form-control" placeholder="상세주소를 입력해주세요."
								name="mbrAddrDtl" id="mbrAddrDtl"
								value="${memVO.mbrAddrDtl }" required />
						</div>
					</div>
					<div class="row idForm">
						<div class="form-group width-l">
							<label for="rsmCrdtCd" id="reg1label">희망·직무·직업*</label> <select
								class="form-control" name="rsmCrdtCd" id="rsmCrdtCd">
								<option value="" disabled selected>희망 직무·직업선택*</option>
								<c:forEach var="codeVO"
									items="${codeGrpVOMap.get('CRDT').codeVOList }"
									varStatus="stus">
									<option value="${codeVO.comCode}"
										<c:if test="${resumeVO.rsmCrdtCd== codeVO.comCode}">selected</c:if>>${codeVO.comCodeNm}</option>
								</c:forEach>
							</select>
						</div>
						<div class="form-group width-l">
							<label for="rsmSalCd" id="reg1label">희망 연봉*</label> <select
								class="form-control" name="rsmSalCd" id="rsmSalCd">
								<option value="" disabled selected>희망 연봉선택*</option>
								<c:forEach var="codeVO"
									items="${codeGrpVOMap.get('SAL').codeVOList }" varStatus="stus">
									<option value="${codeVO.comCode}"
										<c:if test="${resumeVO.rsmSalCd==codeVO.comCode}">selected</c:if>>${codeVO.comCodeNm}</option>
								</c:forEach>
							</select>
						</div>
					</div>
					<div class="row idForm">
						<div class="form-group width-xl">
							<label for="rsmMemo" id="reg1label">메모</label> <input type="text"
								value="${resumeVO.rsmMemo }" class="form-control"
								placeholder="메모 내용을 입력해주세요." name="rsmMemo" id="rsmMemo" />
						</div>
					</div>
				</div>

				<div class="row idForm btnForm">
					<button class="" id="basInforesetBtn">취소</button>
					<button class="submitBtn" id="basInfoBtn">저장</button>
				</div>
			</div>
		</div>

		<!-- 	학력 입력 창 -->
		<div class="registForm acbg" id="3">
			<div class="registForm" id="basInfo">
				<p id="h3">
					학력 <span class="reqHint">필수*</span>
				</p>
				<img src="/resources/images/addBtn.png" class="addBtn"> <br />
				<div class="showBox">
					<table class="table table-hover text-nowrap">
						<thead>
							<tr>
								<th class="aplct">학교</th>
								<th class="aplct">전공</th>
								<th class="aplct">재학상태</th>
								<th></th>
							</tr>
						</thead>
						<tbody id="acbgTbody">
							<c:forEach var="rsmAcademicVO" items="${rsmAcademicVOList}"
								varStatus="stat">
								<tr>
									<td class="aplct">${rsmAcademicVO.acbgSchlNm}<br> <span
										class="aplcont">${rsmAcademicVO.acbgRcognacbgCdNm}</span>
									</td>
									<td class="aplct">${rsmAcademicVO.acbgMjrNm}<br> <c:if
											test="${rsmAcademicVO.acbgPnt!=null }">
											<span class="aplcont">인정 학점 : ${rsmAcademicVO.acbgPnt}</span>&nbsp;&nbsp;&nbsp;
									</c:if> <c:if test="${rsmAcademicVO.acbgPntCdNm!=null }">
											<span class="aplcont">기준 학점 :
												${rsmAcademicVO.acbgPntCdNm}</span>
										</c:if>
									</td>
									<td class="aplct">${rsmAcademicVO.acdmcrGrdtnSeCdNm}<br>
										<c:if test="${rsmAcademicVO.acbgMtcltnym!=null }">
											<span class="aplcont">입학년도 :
												${rsmAcademicVO.acbgMtcltnym.substring(0,4)}년
												${rsmAcademicVO.acbgMtcltnym.substring(4,6)}월</span>&nbsp;&nbsp;&nbsp;
										</c:if> <c:if test="${rsmAcademicVO.acbgGrdtnym!=null }">
											<span class="aplcont">졸업년도 :
												${rsmAcademicVO.acbgGrdtnym.substring(0,4)}년
												${rsmAcademicVO.acbgGrdtnym.substring(4,6)}월</span>
										</c:if>
									</td>
									<td>
										<button type="button"
											class="btn btn-default aplctCancel acbgDeleteBtn"
											data-acbg-no="${rsmAcademicVO.acbgNo}">삭제</button>
										<button type="button"
											class="btn btn-default aplctCancel acbgEditBtn"
											data-acbg-no="${rsmAcademicVO.acbgNo}"
											data-acbg-se-cd="${rsmAcademicVO.acbgSeCd}"
											data-acbg-rcognacbg-cd="${rsmAcademicVO.acbgRcognacbgCd}"
											data-acbg-schl-nm="${rsmAcademicVO.acbgSchlNm}"
											data-acbg-mjr-nm="${rsmAcademicVO.acbgMjrNm}"
											data-acdmcr-grdtn-se-cd="${rsmAcademicVO.acdmcrGrdtnSeCd}"
											data-acbg-mtcltnym="${rsmAcademicVO.acbgMtcltnym}"
											data-acbg-grdtnym="${rsmAcademicVO.acbgGrdtnym}"
											data-acbg-pnt-cd="${rsmAcademicVO.acbgPntCd}"
											data-acbg-pnt="${rsmAcademicVO.acbgPnt}">수정</button>
									</td>
								</tr>
							</c:forEach>
						</tbody>
					</table>
				</div>
				<div class="conBox" hidden="hidden">
					<div class="inputForm">
						<div class="row idForm">
							<input type="text" class="form-control" name="acbgNo" id="acbgNo"
								hidden="hidden" />
							<div class="form-group width-l nohide">
								<label for="acbgSeCd" id="reg1label">학력 구분*</label> <select
									class="form-control" name="acbgSeCd" id="acbgSeCd">
									<option value="" selected>학력 구분 선택*</option>
									<c:forEach var="codeVO"
										items="${codeGrpVOMap.get('ACSE').codeVOList }"
										varStatus="stus">
										<option value="${codeVO.comCode}">${codeVO.comCodeNm}</option>
									</c:forEach>
								</select>
							</div>
							<div class="form-group width-s" hidden="hidden">
								<label for="acbgRcognacbgCd" id="reg1label">인정학력*</label> <select
									class="form-control" name="acbgRcognacbgCd"
									id="acbgRcognacbgCd">
									<option value="ACRC000" selected>인정학력선택*</option>
									<c:forEach var="codeVO"
										items="${codeGrpVOMap.get('ACRC').codeVOList}"
										varStatus="stus">
										<option value="${codeVO.comCode}">${codeVO.comCodeNm}</option>
									</c:forEach>
								</select>
							</div>
							<div class="form-group width-l" hidden="hidden">
								<label for="acbgSchlNm" id="reg1label">학교명*</label> <input
									type="text" class="form-control" placeholder="학교명*"
									name="acbgSchlNm" id="acbgSchlNm" required />
							</div>
						</div>
						<div class="row idForm">
							<div class="form-group width-l" hidden="hidden">
								<label for="acbgMjrNm" id="reg1label">전공*</label> <input
									type="text" class="form-control" placeholder="전공*"
									name="acbgMjrNm" id="acbgMjrNm" required />
							</div>
							<div class="form-group width-s" hidden="hidden">
								<label for="acdmcrGrdtnSeCd" id="reg1label">졸업여부*</label> <select
									class="form-control" name="acdmcrGrdtnSeCd"
									id="acdmcrGrdtnSeCd">
									<option value="" disabled selected>졸업여부선택*</option>
									<c:forEach var="codeVO"
										items="${codeGrpVOMap.get('ACGD').codeVOList}"
										varStatus="stus">
										<option value="${codeVO.comCode}">${codeVO.comCodeNm}</option>
									</c:forEach>
								</select>
							</div>
							<div class="form-group width-s" hidden="hidden">
								<label for="acbgMtcltnym" id="reg1label">입학년월</label> <input
									type="month" class="form-control" placeholder="입학년월"
									name="acbgMtcltnym" id="acbgMtcltnym" />
							</div>
							<div class="form-group width-s" hidden="hidden">
								<label for="acbgGrdtnym" id="reg1label">졸업년월</label> <input
									type="month" class="form-control" placeholder="입학년월"
									name="acbgGrdtnym" id="acbgGrdtnym" />
							</div>
						</div>
						<div class="row idForm">
							<div class="row idForm sub">
								<div class="form-group width-s" hidden="hidden">
									<label for="acbgPnt" id="reg1label">학점</label> <input
										type="number" class="form-control" placeholder="학점"
										name="acbgPnt" id="acbgPnt" />
								</div>
								<div class="form-group width-s" hidden="hidden">
									<label for="acbgPntCd" id="reg1label">기준학점</label> <select
										class="form-control" name="acbgPntCd" id="acbgPntCd">
										<option value="" selected>기준학점선택*</option>
										<c:forEach var="codeVO"
											items="${codeGrpVOMap.get('AGPN').codeVOList}"
											varStatus="stus">
											<option value="${codeVO.comCode}">${codeVO.comCodeNm}</option>
										</c:forEach>
									</select>
								</div>
							</div>
						</div>
						<div class="row idForm btnForm">
							<button class="resetBtn">취소</button>
							<button class="submitBtn" id="acbgSaveBtn">저장</button>
						</div>
					</div>
				</div>
			</div>
		</div>
		<!-- 	경력 입력 창 -->
		<div class="registForm career" id="4">
			<p id="h3">경력</p>
			<img src="/resources/images/addBtn.png" class="addBtn"> <br />
			<div class="showBox">
				<table class="table table-hover text-nowrap">
					<thead>
						<tr>
							<th class="aplct">회사명</th>
							<th class="aplct">입/퇴사 일자</th>
							<th class="aplct">직무</th>
							<th></th>
						</tr>
					</thead>
					<tbody id="careerTbody">
						<c:forEach var="rsmCareerVO" items="${rsmCareerVOList}"
							varStatus="stat">
							<tr>
								<td class="aplct"><c:if
										test="${rsmCareerVO.careerEntNm.length() > 10}">
	                    					${rsmCareerVO.careerEntNm.substring(0,10)}...
	                       			</c:if> <c:if
										test="${rsmCareerVO.careerEntNm.length() <= 10}">
	                        				${rsmCareerVO.careerEntNm}
	                        		</c:if></td>
								<td class="aplct">입사일자 :
									${rsmCareerVO.careerJncmpYmd.substring(0,4)}-${rsmCareerVO.careerJncmpYmd.substring(4,6)}-${rsmCareerVO.careerJncmpYmd.substring(6,8)}
									<c:if test="${rsmCareerVO.careerRetireYmd!=null}">
										<br />퇴사일자 : ${rsmCareerVO.careerRetireYmd.substring(0,4)}-${rsmCareerVO.careerRetireYmd.substring(4,6)}-${rsmCareerVO.careerRetireYmd.substring(6,8)}
                        			</c:if>
								</td>
								<td class="aplct">${rsmCareerVO.careerDtyCdNm}<br> <c:if
										test="${rsmCareerVO.careerDept!=null}">
										<span class="aplcont">직무 : ${rsmCareerVO.careerDtyCdNm}</span>&nbsp;&nbsp;&nbsp;
			                        </c:if> <c:if
										test="${rsmCareerVO.careerJbgdCdNm!=null}">
										<c:choose>
											<c:when test="${rsmCareerVO.careerDept.length() > 10}">
												<span class="aplcont">부서 :
													${rsmCareerVO.careerDept.substring(0,10)}...</span>&nbsp;&nbsp;&nbsp;
			                        		</c:when>
											<c:otherwise>
												<span class="aplcont">부서 : ${rsmCareerVO.careerDept}</span>&nbsp;&nbsp;&nbsp;
			                        		</c:otherwise>
										</c:choose>
									</c:if>
								</td>
								<td>
									<button type="button"
										class="btn btn-default aplctCancel careerDeleteBtn"
										data-career-no="${rsmCareerVO.careerNo}">삭제</button>
									<button type="button"
										class="btn btn-default aplctCancel careerEditBtn"
										data-career-no="${rsmCareerVO.careerNo}"
										data-career-ent-nm="${rsmCareerVO.careerEntNm}"
										data-career-jncmp-ymd="${rsmCareerVO.careerJncmpYmd}"
										data-career-retire-ymd="${rsmCareerVO.careerRetireYmd}"
										data-career-dty-cd="${rsmCareerVO.careerDtyCd}"
										data-career-dept="${rsmCareerVO.careerDept}"
										data-career-jbgd-cd="${rsmCareerVO.careerJbgdCd}"
										data-career-task="${rsmCareerVO.careerTask}"
										data-career-anslry="${rsmCareerVO.careerAnslry}"
										data-career-work-rgn-cd="${rsmCareerVO.careerWorkRgnCd}">수정</button>
								</td>
							</tr>
						</c:forEach>
					</tbody>
				</table>
			</div>
			<div class="conBox" hidden="hidden">
				<div class="inputForm">
					<div class="row idForm">
						<input type="text" class="form-control" name="careerNo"
							id="careerNo" hidden="hidden" />
						<div class="form-group width-l">
							<label for="careerEntNm" id="reg1label">회사명*</label> <input
								type="text" class="form-control" placeholder="회사명을 입력해주세요."
								name="careerEntNm" id="careerEntNm" required />
						</div>
						<div class="form-group width-s">
							<label for="careerJncmpYmd" id="reg1label">입사년월*</label> <input
								type="date" class="form-control" name="careerJncmpYmd"
								id="careerJncmpYmd" required />
						</div>
						<div class="form-group width-s">
							<label for="careerRetireYmd" id="reg1label">퇴사년월</label> <input
								type="date" class="form-control" name="careerRetireYmd"
								id="careerRetireYmd" />
						</div>
					</div>
					<div class="row idForm">
						<div class="form-group width-l">
							<label for="careerdtyCd" id="reg1label">직무*</label> <select
								class="form-control" name="careerDtyCd" id="careerDtyCd"
								required="required">
								<option value="" disabled selected>직무선택*</option>
								<c:forEach var="codeVO"
									items="${codeGrpVOMap.get('CRDT').codeVOList}" varStatus="stus">
									<option value="${codeVO.comCode}">${codeVO.comCodeNm}</option>
								</c:forEach>
							</select>
						</div>
						<div class="form-group width-l">
							<label for="careerDept" id="reg1label">근무부서</label> <input
								type="text" class="form-control" placeholder="근무부서를 입력하세요."
								name="careerDept" id="careerDept" />
						</div>
						<div class="form-group width-l">
							<label for="careerjbgdCd" id="reg1label">직급/직책</label> <select
								class="form-control" name="careerJbgdCd" id="careerJbgdCd">
								<option value="" disabled selected>직급/직책선택</option>
								<c:forEach var="codeVO"
									items="${codeGrpVOMap.get('CRBG').codeVOList}" varStatus="stus">
									<option value="${codeVO.comCode}">${codeVO.comCodeNm}</option>
								</c:forEach>
							</select>
						</div>
					</div>
					<div class="row idForm">
						<div class="form-group width-xl">
							<label for="careerTask" id="reg1label">담당업무*</label>
							<textarea class="form-control modalCont"
								placeholder="
	담당업무를 입력해주세요.

		- 진행한 업무를 다 적기 보다는 경력사항 별로 주요한 내용만 엄선해서 작성하는 것이 중요합니다!
		- 담당한 업무 내용을 요약해서 작성해보세요!
		- 경력별 프로젝트 내용을 적을 경우, 역할/팀구성/기여도/성과를 기죽으로 요약해서 작성해보세요!"
								name="careerTask" id="careerTask" style="height: 300px;"
								required></textarea>
							<div style="display: flex;">
								<p id="countp" class="countp">
									글자 수&nbsp;(&nbsp;<span id="charCount" class="charCount">0</span>&nbsp;/&nbsp;2000&nbsp;)
								</p>
								<p id="warning" class="warning">글자 수가 2000자를 넘었습니다!</p>
							</div>

						</div>
					</div>
					<div class="row idForm">
						<div class="form-group width-s">
							<label for="careerAnslry" id="reg1label">연봉</label> <input
								type="number" class="form-control" placeholder="연봉을 입력하세요."
								name="careerAnslry" id="careerAnslry" />
						</div>
						<p
							style="font-size: 19px; font-weight: bold; padding: 39px 23px 0px 2px;">만원</p>
						<div class="form-group width-s">
							<label for="careerWorkRgnCd" id="reg1label">근무지역</label> <select
								class="form-control" name="careerWorkRgnCd" id="careerWorkRgnCd">
								<option value="" disabled selected>근무지역선택*</option>
								<c:forEach var="codeVO"
									items="${codeGrpVOMap.get('WRGN').codeVOList}" varStatus="stus">
									<c:if test="${fn:length(codeVO.comCode) < 7}">
										<option value="${codeVO.comCode}">${codeVO.comCodeNm}</option>
									</c:if>
								</c:forEach>
							</select>
						</div>
					</div>
					<div class="row idForm btnForm">
						<button class="resetBtn">취소</button>
						<button class="submitBtn" id="careerSaveBtn">저장</button>
					</div>
				</div>
			</div>
		</div>
		<!-- 	스킬 입력 창 -->
		<div class="registForm skill" id="5">
			<p id="h3">스킬</p>
			<img src="/resources/images/addBtn.png" class="addBtn"> <br />
			<div class="showBox skillBox" style="margin-top: 35px;">
				<div class="inputForm">
					<div class="row idForm">
						<div class="form-group width-xl ">
							<label for="" id="reg1label">스킬</label>
							<div class="selectedSkills" id="skill-show-box">
								<c:forEach var="rsmSkillVO" items="${rsmSkillVOList }"
									varStatus="stut">
									<span class="selected-skill" data-code-no="${rsmSkillVO.skCd}">
										${rsmSkillVO.skCdNm} </span>
								</c:forEach>
							</div>
						</div>
					</div>
				</div>
			</div>
			<div class="conBox" hidden="hidden" style="margin-top: 35px;">
				<div class="inputForm">
					<div class="row idForm">
						<div class="form-group width-xl">
							<label for="skillSearch" id="reg1label">스킬 검색</label> <input
								type="text" class="form-control"
								placeholder="툴/직무역량/소프트스킬을 입력해주세요." name="skillSearch"
								id="skillSearch" value="" />
						</div>
					</div>
					<div class="row idForm">
						<div class="form-group width-xl search-results"
							style="height: 100xp; overflow: scroll;"></div>
					</div>
					<div class="row idForm">
						<div class="form-group width-xl ">
							<label for="" id="reg1label">스킬</label>
							<div class="selectedSkills" id="skill-select-box"></div>
						</div>
					</div>
					<div class="row idForm btnForm">
						<button class="resetBtn">취소</button>
						<button class="submitBtn" id="skillSaveBtn">저장</button>
					</div>
				</div>
			<p>*스킬 아이콘을 클릭하면 스킬이 삭제됩니다.</p>
			</div>
		</div>
		<!-- 	경험/활동/교육 입력 창 -->
		<div class="registForm act" id="6">
			<p id="h3">경험/활동/교육</p>
			<img src="/resources/images/addBtn.png" class="addBtn"> <br />
			<div class="showBox">
				<table class="table table-hover text-nowrap">
					<thead>
						<tr>
							<th class="aplct">활동</th>
							<th class="aplct">활동명</th>
							<th class="aplct">활동 기간</th>
							<th></th>
						</tr>
					</thead>
					<tbody id="actTbody">
						<c:forEach var="rsmExpactEDCVO" items="${rsmExpactEDCVOList}"
							varStatus="stat">
							<tr>
								<td class="aplct">${rsmExpactEDCVO.actSeCdNm}</td>
								<td class="aplct">${rsmExpactEDCVO.actNm}<c:if
										test="${rsmExpactEDCVO.actEngn != null }">
										<br>
										<span class="aplcont">${rsmExpactEDCVO.actEngn}</span>
									</c:if>
								<td class="aplct">시작일자 :
									${rsmExpactEDCVO.actBeginYmd.substring(0,4)}-${rsmExpactEDCVO.actBeginYmd.substring(4,6)}-${rsmExpactEDCVO.actBeginYmd.substring(6,8)}
									<br /> 종료일자 :
									${rsmExpactEDCVO.actEndYmd.substring(0,4)}-${rsmExpactEDCVO.actEndYmd.substring(4,6)}-${rsmExpactEDCVO.actEndYmd.substring(6,8)}
								</td>
								<td>
									<button type="button"
										class="btn btn-default aplctCancel actDeleteBtn"
										data-act-no="${rsmExpactEDCVO.actNo}">삭제</button>
									<button type="button"
										class="btn btn-default aplctCancel actEditBtn"
										data-act-no="${rsmExpactEDCVO.actNo}"
										data-act-se-cd="${rsmExpactEDCVO.actSeCd}"
										data-act-nm="${rsmExpactEDCVO.actNm}"
										data-act-engn="${rsmExpactEDCVO.actEngn}"
										data-act-begin-ymd="${rsmExpactEDCVO.actBeginYmd}"
										<c:if test="${rsmExpactEDCVO.actEndYmd != null}">
                	    data-act-end-ymd="${rsmExpactEDCVO.actEndYmd}"
                	</c:if>
										<c:if test="${rsmExpactEDCVO.actCn != null}">
                	    data-act-cn="${rsmExpactEDCVO.actCn}"
                	</c:if>>수정</button>
								</td>
							</tr>
						</c:forEach>
					</tbody>
				</table>
			</div>
			<div class="conBox" hidden="hidden">
				<div class="inputForm">
					<div class="row idForm">
						<div class="form-group width-l">
							<input type="text" class="form-control" placeholder="횔동번호"
								name="actNo" id="actNo" hidden="hidden" /> <label for="actSeCd"
								id="reg1label">활동구분*</label> <select class="form-control"
								name="actSeCd" id="actSeCd">
								<option value="" disabled selected>활동구분선택*</option>
								<c:forEach var="codeVO"
									items="${codeGrpVOMap.get('ACTS').codeVOList}" varStatus="stus">
									<option value="${codeVO.comCode}">${codeVO.comCodeNm}</option>
								</c:forEach>
							</select>
						</div>
						<div class="form-group width-l">
							<label for="actEngn" id="reg1label">기관/장소명*</label> <input
								type="text" class="form-control" placeholder="기관/장소명을 입력해주세요."
								name="actEngn" id="actEngn" required />
						</div>
					</div>
					<div class="row idForm">
						<div class="form-group width-l">
							<label for="actNm" id="reg1label">활동명*</label> <input type="text"
								class="form-control" placeholder="활동명을 입력해주세요." name="actNm"
								id="actNm" required />
						</div>
						<div class="form-group width-s">
							<label for="actBeginYmd" id="reg1label">시작년월일*</label> <input
								type="date" class="form-control" placeholder="기관/장소명을 입력해주세요."
								name="actBeginYmd" id="actBeginYmd" required />
						</div>
						<div class="form-group width-s">
							<label for="actEndYmd" id="reg1label">종료년월일*</label> <input
								type="date" class="form-control" placeholder="기관/장소명을 입력해주세요."
								name="actEndYmd" id="actEndYmd" required />
						</div>
					</div>
					<div class="row idForm">
						<div class="form-group width-xl">
							<label for="actCn" id="reg1label">활동내용</label>
							<textarea class="form-control modalCont"
								placeholder="
	경험/활동 상세내용 입력" name="actCn" id="actCn"
								style="height: 300px;" required></textarea>
							<div style="display: flex;">
								<p id="countp" class="countp">
									글자 수&nbsp;(&nbsp;<span id="charCount" class="charCount">0</span>&nbsp;/&nbsp;2000&nbsp;)
								</p>
								<p id="warning" class="warning">글자 수가 2000자를 넘었습니다!</p>
							</div>
						</div>
					</div>
					<div class="row idForm btnForm">
						<button class="resetBtn">취소</button>
						<button class="submitBtn" id="actSavaBtn">저장</button>
					</div>
				</div>
			</div>
		</div>
		<!-- 	자격/어학/수상 입력 창 -->
		<div class="registForm crtfct" id="7">
			<p id="h3">자격/어학/수상</p>
			<img src="/resources/images/addBtn.png" class="addBtn"> <br />
			<div class="showBox">
				<table class="table table-hover text-nowrap">
					<thead>
						<tr>
							<th class="aplct">자격·어학·수상</th>
							<th class="aplct">자격·어학·수상명</th>
							<th class="aplct">취득상태</th>
							<th></th>
						</tr>
					</thead>
					<tbody id="crtfctbody">
						<c:forEach var="rsmCertificateVO" items="${rsmCertificateVOList}"
							varStatus="stat">
							<tr>
								<td class="aplct">${rsmCertificateVO.crtfctAcqsSeCdNm}</td>
								<td class="aplct">${rsmCertificateVO.crtfctNm}<c:if
										test="${rsmCertificateVO.crtfctPblcnoffic != null }">
										<br>
										<span class="aplcont"> <c:choose>
												<c:when
													test="${rsmCertificateVO.crtfctPblcnoffic.length() > 10}">
											     		 ${fn:substring(rsmCertificateVO.crtfctPblcnoffic, 0, 10)}...
											    	</c:when>
												<c:otherwise>
											     		 ${rsmCertificateVO.crtfctPblcnoffic}
											    	</c:otherwise>
											</c:choose>
										</span>
									</c:if>
								<td class="aplct"><c:if
										test="${rsmCertificateVO.crtfctAcqsSeNm != null }">
												${rsmCertificateVO.crtfctAcqsSeNm}
										</c:if> <c:if test="${rsmCertificateVO.crtfctAcqsYnNm != null }">
												${rsmCertificateVO.crtfctAcqsYnNm}
										</c:if> <c:if test="${rsmCertificateVO.crtfctAcqsYm!=null}">
										<br />일자 : ${rsmCertificateVO.crtfctAcqsYm.substring(0,4)}-${rsmCertificateVO.crtfctAcqsYm.substring(4,6)}
                						</c:if></td>
								<td>
									<button type="button"
										class="btn btn-default aplctCancel crtfctDeleteBtn"
										data-crtfct-no="${rsmCertificateVO.crtfctNo}">삭제</button>
									<button type="button"
										class="btn btn-default aplctCancel crtfctEditBtn"
										data-crtfct-no="${rsmCertificateVO.crtfctNo}"
										data-crtfct-acqs-se-cd="${rsmCertificateVO.crtfctAcqsSeCd}"
										data-crtfct-nm="${rsmCertificateVO.crtfctNm}"
										data-crtfct-pblcnoffic="${rsmCertificateVO.crtfctPblcnoffic}"
										data-crtfct-acqs-se="${rsmCertificateVO.crtfctAcqsSe}"
										data-crtfct-acqs-ym="${rsmCertificateVO.crtfctAcqsYm}"
										data-crtfct-scr="${rsmCertificateVO.crtfctScr}"
										data-crtfct-lang-cd="${rsmCertificateVO.crtfctLangCd}"
										data-crtfct-acqs-yn="${rsmCertificateVO.crtfctAcqsYn}">수정</button>
								</td>
							</tr>
						</c:forEach>
					</tbody>
				</table>
			</div>
			<div class="conBox" hidden="hidden">
				<div class="inputForm">
					<div class="row idForm">
						<input type="text" class="form-control" placeholder="자격증번호"
							name="crtfctNo" id="crtfctNo" hidden="hidden" />
						<div class="form-group width-l">
							<label for="crtfctAcqsSeCd" id="reg1label">자격·어학·수상*</label> <select
								class="form-control" name="crtfctAcqsSeCd" id="crtfctAcqsSeCd">
								<option value="" disabled selected>자격·어학·수상구분선택*</option>
								<c:forEach var="codeVO"
									items="${codeGrpVOMap.get('CLW').codeVOList}" varStatus="stus">
									<option value="${codeVO.comCode}">${codeVO.comCodeNm}</option>
								</c:forEach>
							</select>
						</div>
						<div class="form-group width-s" hidden="hidden">
							<label for="crtfctLangCd" id="reg1label">언어 구분*</label> <select
								class="form-control" name="crtfctLangCd" id="crtfctLangCd">
								<option value="" disabled selected>언어선택*</option>
								<c:forEach var="codeVO"
									items="${codeGrpVOMap.get('LSLN').codeVOList}" varStatus="stus">
									<option value="${codeVO.comCode}">${codeVO.comCodeNm}</option>
								</c:forEach>
							</select>
						</div>
						<div class="form-group width-l" hidden="hidden">
							<label for="crtfctNm" id="reg1label">자격·어학·수상명*</label> <input
								type="text" class="form-control" placeholder="자격증명을 입력해주세요."
								name="crtfctNm" id="crtfctNm" required />
						</div>
					</div>
					<div class="row idForm">
						<div class="form-group width-l" hidden="hidden">
							<label for="crtfctPblcnoffic" id="reg1label">발행처·기관*</label> <input
								type="text" class="form-control" placeholder="발행처·기관을 입력해주세요."
								name="crtfctPblcnoffic" id="crtfctPblcnoffic" required />
						</div>
						<div class="form-group width-s" hidden="hidden">
							<label for="crtfctAcqsSe" id="reg1label">합격구분*</label> <select
								class="form-control" name="crtfctAcqsSe" id="crtfctAcqsSe">
								<option value="" disabled selected>합격구분선택*</option>
								<c:forEach var="codeVO"
									items="${codeGrpVOMap.get('ACQS').codeVOList}" varStatus="stus">
									<option value="${codeVO.comCode}">${codeVO.comCodeNm}</option>
								</c:forEach>
							</select>
						</div>
						<div class="form-group width-s" hidden="hidden">
							<label for="crtfctAcqsYn" id="reg1label">합격여부*</label> <select
								class="form-control" name="crtfctAcqsYn" id="crtfctAcqsYn">
								<option value="" disabled selected>합격여부선택*</option>
								<c:forEach var="codeVO"
									items="${codeGrpVOMap.get('LSYN').codeVOList}" varStatus="stus">
									<option value="${codeVO.comCode}">${codeVO.comCodeNm}</option>
								</c:forEach>
							</select>
						</div>
						<div class="form-group width-s" hidden="hidden">
							<label for="crtfctScr" id="reg1label">점수</label> <input
								type="number" class="form-control" name="crtfctScr"
								placeholder="점수 입력." id="crtfctScr" />
						</div>
						<div class="form-group width-s" hidden="hidden">
							<label for="crtfctAcqsYm" id="reg1label">합격·수상 년월</label> <input
								type="month" class="form-control" name="crtfctAcqsYm"
								id="crtfctAcqsYm" />
						</div>
					</div>
					<div class="row idForm btnForm">
						<button class="resetBtn">취소</button>
						<button class="submitBtn" id="crtfctSaveBtn">저장</button>
					</div>
				</div>
			</div>

		</div>
		<!-- 	포트폴리오 및 기타문서 입력 창 -->
		<div class="registForm prt" id="8">
			<p id="h3">포트폴리오 및 기타문서</p>
			<img src="/resources/images/addBtn.png" class="addBtn"> <br />
			<div class="showBox">
				<table class="table table-hover text-nowrap">
					<thead>
						<tr>
							<th class="aplct">포토폴리오 타입</th>
							<th class="aplct">제목</th>
							<th class="aplct">다운로드/홈페이지</th>
							<th></th>
						</tr>
					</thead>
					<tbody id="prtbody">
						<c:forEach var="rsmPortfolioVO" items="${rsmPrtVOList}"
							varStatus="stat">
							<tr>
								<td class="aplct">${rsmPortfolioVO.prtSeCdNm}</td>
								<td class="aplct"><c:choose>
										<c:when test="${rsmPortfolioVO.prtTtl.length() > 10}">
									     		 ${fn:substring(rsmPortfolioVO.prtTtl, 0, 10)}...
									    	</c:when>
										<c:otherwise>
									     		 ${rsmPortfolioVO.prtTtl}
									    	</c:otherwise>
									</c:choose></td>
								<td class="aplct"><c:if
										test="${rsmPortfolioVO.prtUrl != null }">
										<a class="btn btn-default aplctCancel prtURLBtn" href="${rsmPortfolioVO.prtUrl}">홈페이지 가기</a>
									</c:if> <c:if test="${rsmPortfolioVO.prtFile!=null}">
										<button type="button"
											class="btn btn-default aplctCancel prtDownloadBtn"
											data-toggle="modal" data-target="#downloadModal">다운로드</button>
									</c:if></td>
								<td>
									<button type="button"
										class="btn btn-default aplctCancel prtDeleteBtn"
										data-prt-no="${rsmPortfolioVO.prtNo}">삭제</button>
									<button type="button"
										class="btn btn-default aplctCancel prtEditBtn"
										data-prt-no="${rsmPortfolioVO.prtNo}"
										data-prt-se-cd="${rsmPortfolioVO.prtSeCd}"
										data-prt-ttl="${rsmPortfolioVO.prtTtl}"
										data-prt-file="${rsmPortfolioVO.prtFile}"
										data-prt-url="${rsmPortfolioVO.prtUrl}">수정</button>
								</td>
							</tr>
						</c:forEach>
					</tbody>
				</table>
			</div>
			<div class="conBox" hidden="hidden">
				<div class="inputForm">
					<div>
						<p style="padding-top: 10px; font-size: 16px;">
							포트폴리오 및 기타문서 <span style="font-size: 14px">내 포트폴리오 및 추가로
								제출할 문서를 첨부해보세요.</span>
						</p>
					</div>
					<div class="row idForm">
						<input type="text" class="form-control" placeholder="포플 번호"
							name="prtNo" id="prtNo" hidden="hidden" />
						<div class="form-group width-s">
							<label for="prtSeCd" id="reg1label">형식 구분*</label> <select
								class="form-control" name="prtSeCd" id="prtSeCd">
								<option value="" disabled selected>형식 구분 선택*</option>
								<c:forEach var="codeVO"
									items="${codeGrpVOMap.get('POTY').codeVOList}" varStatus="stus">
									<option value="${codeVO.comCode}">${codeVO.comCodeNm}</option>
								</c:forEach>
							</select>
						</div>
						<div class="form-group width-l" hidden="hidden">
							<label for="prtTtl" id="reg1label">제목*</label> <input type="text"
								class="form-control" placeholder="제목을 입력해주세요." name="prtTtl"
								id="prtTtl" required />
						</div>
					</div>
					<div class="row idForm">
						<div class="form-group width-xl" hidden="hidden">
							<label for="uploadFile2" id="reg1label">파일*</label> <input
								type="file" class="form-control" placeholder="파일을 선택해주세요."
								name="uploadFile2" id="uploadFile2" multiple="multiple" />
						</div>
						<div class="form-group width-xl" hidden="hidden">
							<label for="prtUrl" id="reg1label">URL*</label> <input
								type="text" class="form-control" placeholder="URL주소를 입력해주세요."
								name="prtUrl" id="prtUrl" />
						</div>
					</div>
					<div class="row idForm btnForm">
						<button class="resetBtn">취소</button>
						<button class="submitBtn" id="prtSaveBtn">저장</button>
					</div>
				</div>
			</div>
		</div>
		<!-- 	자기소개서 입력 창 -->
		<div class="registForm CL" id="9">
			<p id="h3">자기소개서</p>
			<img src="/resources/images/addBtn.png" class="addBtn">
			<button type="button" class="clCopyBtn" style="margin-right: 20px;"
				data-toggle="modal" data-target="#clCopyModal">자소서 관리에서
				불러오기</button>
			<div class="showBox">
				<table class="table table-hover text-nowrap">
					<thead>
						<tr>
							<th class="aplct">제목</th>
							<th class="aplct">내용</th>
							<th class="aplct">작성일자</th>
							<th></th>
						</tr>
					</thead>
					<tbody id="CLTbody">
						<c:forEach var="RsmClVO" items="${rsmClVOList}" varStatus="stat">
							<tr>
								<td class="aplct"><c:choose>
										<c:when test="${RsmClVO.clTtl.length() > 10}">
								     		 ${fn:substring(RsmClVO.clTtl, 0, 10)}...
								    	</c:when>
										<c:otherwise>
								     		 ${RsmClVO.clTtl}
								    	</c:otherwise>
									</c:choose></td>
								<td class="aplct"><c:choose>
										<c:when test="${RsmClVO.clCn.length() > 10}">
								      ${fn:substring(RsmClVO.clCn, 0, 10)}...
								    </c:when>
										<c:otherwise>
								      ${RsmClVO.clCn}
								    </c:otherwise>
									</c:choose></td>

								<td class="aplct">${RsmClVO.clWritngYmd.substring(0,4)}-${RsmClVO.clWritngYmd.substring(4,6)}-${RsmClVO.clWritngYmd.substring(6,8)}
								</td>
								<td>
									<button type="button"
										class="btn btn-default aplctCancel CLDeleteBtn"
										data-cl-no="${RsmClVO.clNo}">삭제</button>
									<button type="button"
										class="btn btn-default aplctCancel CLEditBtn"
										data-cl-no="${RsmClVO.clNo}" data-cl-ttl="${RsmClVO.clTtl}"
										data-cl-cn="${RsmClVO.clCn}"
										data-cl-writng-tmd="${RsmClVO.clWritngYmd}"
										data-cl-sn="${RsmClVO.clSn}">수정</button>
								</td>
							</tr>
						</c:forEach>
					</tbody>
				</table>
			</div>
			<div class="conBox" hidden="hidden" style="margin-top: 62px;">
				<div class="inputForm">
					<div class="row idForm">
						<input type="text" class="form-control" placeholder="자소서 번호"
							name="clNo" id="clNo" hidden="hidden" />
						<div class="form-group width-xl" style="margin-right: 10px;">
							<label for="clTtl" id="reg1label">제목*</label> <input type="text"
								class="form-control" placeholder="특별한 제목으로 자신을 어필해보세요."
								name="clTtl" id="clTtl" required />
						</div>
					</div>
					<div class="row idForm">
						<div class="form-group width-xl">
							<label for="clCn" id="reg1label">내용*</label>
							<textarea class="form-control modalCont"
								placeholder="
	자신을 소개해 주세요." name="clCn" id="clCn"
								style="height: 300px;" required></textarea>
							<div style="display: flex;">
								<p id="countp" class="countp">
									글자 수&nbsp;(&nbsp;<span id="charCount" class="charCount">0</span>&nbsp;/&nbsp;2000&nbsp;)
								</p>
								<p id="warning" class="warning">글자 수가 2000자를 넘었습니다!</p>
							</div>
						</div>
					</div>
					<div class="row idForm btnForm">
						<button class="resetBtn">취소</button>
						<button class="submitBtn" id="CLSaveBtn">저장</button>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
<div class="modal fade" id="clCopyModal">
	<div class="modal-dialog">
		<div class="modal-content modal-CLCopy">
			<h4 class="Tit">
				자소서 관리에서 불러오기 <span class="Txt" id="subscribe">자소서 관리에서 불러올
					자소서를 선택해주세요.</span>
			</h4>
			<div class="itemlist">
				<c:forEach var="CLVO" items="${CLVOList }" varStatus="stut">
				<div class="itemBox">
					<div class="card collapsed-card">
						<div class="card-header">
							<div>
								<p class="tit_letter">${CLVO.clTtl }</p>
								<p class="date_letter">
									<c:choose>
										<c:when test="${CLVO.clEdtDt == null }">
											<fmt:formatDate value="${CLVO.clWrtDt }" pattern="yyyy.MM.dd hh:mm:ss"/> &nbsp;작성
										</c:when>
										<c:otherwise>
											<fmt:formatDate value="${CLVO.clEdtDt }" pattern="yyyy.MM.dd hh:mm:ss"/> &nbsp;수정
										</c:otherwise>
									</c:choose>
								</p>
							</div>
							<div class="row card-tools">
								<button type="button" class="btn btn-tool"
									data-card-widget="collapse">
									<i class="fas fa-angle-down"></i>
								</button>
							</div>
						</div>
						<div class="card-body" style="display: none;">
							<div class="hide_area" id="introContents0" style="margin-bottom: 20px;">
								<p class="cont_letter">${CLVO.clCn }</p>
							</div>
							<button type="button"
								data-cl-ttl="${CLVO.clTtl}"
								data-cl-cn="${CLVO.clCn}"
							 	class="submitBtn CLCopyRegistBtn">선택</button>
						</div>
					</div>
				</div>
				</c:forEach>
			</div>
			<!-- /.modal-content -->
		</div>
	</div>
</div>
		<!-- /.modal-dialog -->
<div class="modal fade" id="downloadModal">
	<div class="modal-dialog">
		<div class="modal-content modal-CLCopy">
			<h4 class="Tit">
				포트폴리오 파일 다운로드 <span class="Txt" id="subscribe">다운받을 파일을 선택해주세요.</span>
			</h4>
			<div class="itemlist">
				<c:forEach var="rsmPrtVO" items="${rsmPrtVOList }" varStatus="stut">
					<c:if test="${rsmPrtVO.prtSeCd == 'POTY01' }">
						<div class="itemBox">
							<div class="card collapsed-card">
								<div class="card-header">
									<div>
										<p class="tit_letter">${rsmPrtVO.prtTtl }</p>
									</div>
									<div class="row card-tools">
										<button type="button" class="btn btn-tool"
											data-card-widget="collapse">
											<i class="fas fa-angle-down"></i>
										</button>
									</div>
								</div>
								<div class="card-body" style="display: none;">
									<c:forEach var="fileVO" items="${rsmPrtVO.fileDetailVOList }" varStatus="stut2">
									<div class="hide_area row" id="introContents0" style="margin-bottom: 20px; justify-content: space-between;">
										<p class="cont_letter">${fileVO.orgnlFileNm }</p>
										<button type="button"
											data-file-path="${fileVO.filePathNm}"
										 	class="submitBtn fileDwonloadtBtn">선택</button>
									</div>
									</c:forEach>
								</div>
							</div>
						</div>
					</c:if>
				</c:forEach>
			</div>
			<!-- /.modal-content -->
		</div>
	</div>
</div>
		<!-- /.modal-dialog -->
<style>
.itemlist::-webkit-scrollbar {
   width: 10px;
 }
 .itemlist::-webkit-scrollbar-thumb {
   background-color: #24D59E;
   border-radius: 10px;
   background-clip: padding-box;
   border: 2px solid transparent;
 }
 .itemlist::-webkit-scrollbar-track {
   background-color: #b6ffe9;
   border-radius: 10px;
   box-shadow: inset 0px 0px 5px white;
 }
.date_letter{
	font-size: 13px;
	font-weight: 500;
	color: ##475067;
}
.tit_letter{
	font-size: 15px;
	font-weight: 700;
	color: #292e41;
}
.CLCopyRegistBtn{
	float: right;
}
.card-body::after, .card-footer::after, .card-header::after {
    all: initial;
  * {
      all: unset;
  }
}
.card-body{
	padding: 15px 30px 0px 30px;
}
.card-header{
	display: flex;
	flex-direction: row;
	justify-content: space-between;
	padding: 0px 20px 0px 20px;
}
.itemlist{
	overflow: hidden;
	overflow: overlay;
    height: 90%;
}
.card {
	width: 100%;
	height: auto;
	position: unset;
	border: 1px solid #24D59E;
	box-shadow: unset;
	border-radius: 6px;
}

.itemlist {
	padding: 0px 30px 30px 30px;
}

.Txt {
	display: block;
	margin-top: 8px;
	color: #475067; font-size : 14px;
	font-weight: normal;
	line-height: 20px;
	font-size: 14px;
}

.Tit {
	padding: 0 40px;
	margin-bottom: 24px;
	color: #292e41;
	font-size: 20px;
	font-weight: bold;
	line-height: 28px;
}

.modal-CLCopy {
	display: block;
	width: 800px;
	height: 600px;
	padding: 40px 0;
	position: fixed;
	top: 50%;
	left: 50%;
	z-index: 110;
	border-radius: 16px;
	box-sizing: border-box;
	background-color: #fff;
	box-shadow: 0 0 5px 0 rgba(0, 0, 0, 0.15);
	transform: translateY(-50%) translateX(-50%) translateZ(0);
}

}
::placeholder {
	color: #b4b4b4;
	font-weight: 300;
}

#registMain {
	padding: 30px 198px 30px 400px;
	display: flex;
	justify-content: center;
	flex-direction: column;
	max-width: 100%;
	min-width: 100%;
	scrollbar-width: none;
	overflow: auto;
}

.registForm {
	max-width: 1030px;
	min-width: 1030px;
	height: auto;
}

.registForm-bottom {
	width: 100%;
	height: 107px;
	position: fixed;
	left: 0px;
	bottom: 0px;
	background-color: rgb(241 255 254);
	z-index: 1;
	border-top: solid 2px #24D59E;
	justify-content: center;
	min-width: 1200px;
}

#h3 {
	font-size: 22px;
	padding: 0px 0px 0px 40px;
	position: absolute;
}
.registForm-sub .reqHint, .registForm .reqHint {
	color: red;
	font-size: 16px;
	font-weight: bold;
}

.registForm .conBox {
	border: solid 1px #efefef;
	box-shadow: 0px 12px 10px -3px rgba(0, 0, 0, .05), 11px 9px 10px -1px
		rgba(0, 0, 0, .05);
	border-top: solid 3px #24D59E;
	border-radius: 0px 0px 12px 12px;
	height: auto;
	max-width: 1030px;
	min-width: 1030px;
	width: 100%;
	padding: 0px 42px 100px 55px;
	margin: 20px 0px 30px 0px;
}

.form-control {
	border-color: #24D59E;
	height: calc(2rem + 14px);
}

label {
	position: relative;
	top: 20px;
	left: 13px;
	background-color: white;
	padding: 0px 6px 0px 6px;
	font-size: 14px;
}

.form-group {
	margin-bottom: auto;
}

.sub {
	margin-left: 0px;
	width: 308.5px;
}

.imgForm {
	margin-top: -129px;
	position: relative;
	right: -827px;
	top: 85px;
}

.imgCover {
	border: 1px solid #0080003d;
	height: 130px;
	width: 100px;
	border-radius: 8px;
}

#selIvImg {
	height: 130px;
	width: 100px;
	border: none;
	background-color: transparent;
}

#pImg {
	height: 130px;
	width: 100px;
	border-radius: 8px;
	object-fit: cover;
}

.btnForm {
	float: right;
	margin: 30px 0px 0px 0px;
}

.width-l {
	width: 300px;
	margin-right: 10px;
}

.width-s {
	width: 145px;
	margin-right: 10px;
}

.width-xl {
	width: 920px;
}

.addBtn {
	cursor: pointer;
	float: right;
	padding: 10px 10px 10px 10px;
	border-radius: 8px;
	margin-bottom: 10px;
}

.addBtn:hover {
	background-color: #6c757d1c;
}

.inputForm .row {
	margin-right: 0px;
	margin-left: 0px;
}

.resetBtn, .submitBtn {
	margin-right: 10px;
}

.search-results {
	overflow: auto; /* 또는 scroll */
	-ms-overflow-style: none; /* IE and Edge */
	scrollbar-width: none;
	height: auto;
	max-height: 250px;
	border-bottom: 1px solid rgba(0, 0, 0, .125);
}

.search-results::-webkit-scrollbar {
	display: none; /* Chrome, Safari, Opera */
}

.selected-skill {
	float: left;
	padding: 2px 10px 2px 10px;
	background-color: rgba(44, 207, 195, 0.11);
	border: solid 1px #0080003d;
	width: auto;
	height: 32px;
	border-radius: 40px;
	margin: 0px 10px 10px 0px;
	cursor: pointer;
}

.selectedSkills {
	border: solid 1px #24D59E;
	border-radius: 8px;
	height: 250px;
	overflow: auto; /* 또는 scroll */
	-ms-overflow-style: none; /* IE and Edge */
	scrollbar-width: none;
	padding: 10px 0px 10px 10px;
}

.charCount {
	color: #24D59E;
}

.countp {
	color: #232323;
	font-size: 14px;
}

.warning {
	color: red;
	display: none;
	margin-left: 20px;
}

table {
	box-shadow: 0px 12px 10px -3px rgba(0, 0, 0, .05), 11px 9px 10px -1px
		rgba(0, 0, 0, .05);
	border: none;
	border-top: solid 3px #24D59E;
	border-radius: 0px 0px 12px 12px;
	height: auto;
	max-width: 1030px;
	min-width: 1030px;
	width: 100%;
	padding: 0px 42px 100px 55px;
	margin: 20px 0px 30px 0px;
}

.skillBox {
	box-shadow: 0px 12px 10px -3px rgba(0, 0, 0, .05), 11px 9px 10px -1px
		rgba(0, 0, 0, .05);
	border: none;
	border-top: solid 3px #24D59E;
	border-radius: 0px 0px 12px 12px;
	height: auto;
	max-width: 1030px;
	min-width: 1030px;
	width: 100%;
	padding: 0px 42px 42px 55px;
	margin: 20px 0px 30px 0px;
}

.table th {
	padding: 15px;
}

th {
	text-align: center;
	font-size: 16px;
	width: 150px;
}

thead {
	border-top: none;
	border-bottom: none;
}

.table thead th {
	vertical-align: bottom;
	border-bottom: none;
}

.card-body.table-responsive.p-0 {
	margin-left: 61px;
	width: 1230px;
}

tbody {
	text-align: center;
	font-size: 14px;
	color: #232323;
}

th.aplct {
	text-align: left;
	padding-left: 80px;
}

td.aplct {
	text-align: left;
	padding-left: 80px;
	font-size: 14px;
	font-weight: 700;
}

th.entNm {
	text-align: left;
	padding-left: 137px;
}

td.entNm {
	text-align: left;
	padding-left: 137px;
	font-size: 14px;
	font-weight: 550;
	padding-top: 23px;
}

td.appymd {
	font-size: 14px;
	font-weight: 500;
	padding-top: 23px;
}

td.aplcont {
	color: #2125298a;
	font-size: 13px;
}
/* table hover */
.table-hover tbody tr:hover {
	color: #212529;
	background: none;
}

.anheBtn {
	background: white;
	color: #232323;
	border: 1px solid #B5B5B5;
	transition: all 0.3s ease 0s;
	padding: 7px 40px 7px 40px;
	margin-right: 20px;
	border-radius: 5px;
	margin-right: 10px;
}

.anheBtn:hover {
	background: #ECECEC;
	border: 1px solid #B5B5B5;
}

.registForm-sub {
	width: 295px;
	height: 535px;
	position: fixed;
	left: 1468px;
	top: 135px;
	background-color: white;
	border-radius: 0px 0px 12px 12px;
	border: solid 1px #efefef;
	border-top: solid 4px #24D59E;
	box-shadow: 0px 12px 10px -3px rgba(0, 0, 0, .05), 11px 9px 10px -1px
		rgba(0, 0, 0, .05);
	padding: 28px 20px 0px 20px;
}

.aBtn a {
	color: #666363;
	height: auto;
}
.aBtn div p {
    font-size: 15px;
    color: #666;
    line-height: 24px;
    margin-bottom: 0px;
}
.aBtn div{
	height: 23px;
}

.aBtn {
	display:flex;
	flex-direction:row;
	margin-bottom: 25px; 
	justify-content: space-between; 
	background-color: #00bc8c1f;
	width: 100%;
	font-size: 16px;
	font-weight: bold;
	border-radius: 6px;
	margin-top: -5px;
	padding: 5px 10px 5px 10px;
}

.total {
	background: transparent;
	color: #24D59E;
	font-size: 16px;
	padding: 0;
}
.table td {
    border-top: 1px solid #80808042;
}

.basic .showBox {
	border: solid 1px #efefef;
	box-shadow: 0px 12px 10px -3px rgba(0, 0, 0, .05), 11px 9px 10px -1px
		rgba(0, 0, 0, .05);
	border-top: solid 3px #24D59E;
	border-radius: 0px 0px 12px 12px;
	height: auto;
	max-width: 1030px;
	min-width: 1030px;
	width: 100%;
	padding: 30px 42px 70px 55px;
	margin: 20px 0px 30px 0px;
}

.basic .showBox .row {
	margin: 0px;
	padding: 0px;
	display: flex;
	flex-direction: row;
	justify-content: space-between;
}

.basic .showBox .row Img {
	height: 130px;
	width: 100px;
	border-radius: 8px;
	object-fit: cover;
}

.basic .showBox .row .resumeTop {
	margin-bottom: 8px;
}

.basic .showBox .row .basName {
	color: #151822;
	font-size: 24px;
	font-weight: 700;
}

.basic .showBox .row .hili {
	background-color: #475067;
	color: #ffffff;
	border-radius: 32px;
	line-height: 24px;
	letter-spacing: normal;
	display: inline-block;
	margin-left: 8px;
	padding: 1px 8px 0px 8px;
	height: 24px;
	font-size: 14px;
	font-weight: 700;
}

.basic .showBox .row .hopepe {
	color: #67738e;
	font-size: 15px;
	font-weight: 500;
	margin-bottom: 28px;
}

.basic .showBox .row .bold-4 {
	margin-bottom: 14px;
	font-weight: 400;
	color: #67738e;
	font-size: 15px;
}

.basic .showBox .row .black {
	color: #151822;
	font-size: 15px;
}

#basInforesetBtn {
	background: white;
	color: #232323;
	border: 1px solid #B5B5B5;
	transition: all 0.3s ease 0s;
	padding: 7px 40px 7px 40px;
	margin-right: 10px;
	border-radius: 5px;
}

#basInforesetBtn:hover {
	background: #ECECEC;
	border: 1px solid #B5B5B5;
}

.clCopyBtn {
	font-size: 17px;
	border: 0;
	background-color: #fff;
	color: #6f6d6d;
	cursor: pointer;
	float: right;
	padding: 10px 10px 10px 10px;
	border-radius: 8px;
	margin-bottom: 10px;
	font-weight: 800;
	cursor: pointer;
	color: #6f6d6d;
}

.clCopyBtn:hover {
	background-color: #eff0f1;
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