<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<sec:authorize access="isAuthenticated()">
	<sec:authentication property="principal.memVO" var="priVO" />
</sec:authorize>
<script src="http://code.jquery.com/jquery-latest.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@10"></script>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<meta charset="UTF-8">
<!-- 회원프로필css -->
<link rel="stylesheet"
	href="<%=request.getContextPath()%>/resources/css/member/profile.css" />
<!-- 스위트 alert css -->
<link rel="stylesheet"
	href="<%=request.getContextPath()%>/resources/css/alert.css" />
<!-- 구글 아이콘 -->
<link rel="stylesheet"
	href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20,200,0,0" />
<link href="https://fonts.googleapis.com/css2?family=Material+Icons"
	rel="stylesheet">

<!-- 인터페이스 아이콘 -->
<link rel='stylesheet'
	href='https://cdn-uicons.flaticon.com/2.6.0/uicons-solid-rounded/css/uicons-solid-rounded.css'>
<script type="text/javascript" src="/resources/js/sweetalert2.js"></script>
<script>
//sweetAlert 창 띄우기 변수
var Toast = Swal.mixin({
	    toast: true,
	    position: 'center',
	    showConfirmButton: false,
	    timer: 3000
	});
	
//--------------------------------- 경력 추가
function addCareer() {
    // 추가할 <div> 요소 생성
    const newElement = document.createElement('div');

    // <div> 요소 안에 html 요소 추가
	newElement.innerHTML = `
              <form name="add_Form" id="add_Form" action="/member/careerAddAjax" method="post">
              <div id="addForm">
                 <h5 style="margin-left : -70px;">경력 추가</h5>
                 <br>
                 <input name="careerNo" class="del" type="hidden"/>
                 <input name="mbrId" class="add" type="hidden" value="${priVO.mbrId}"/>
                 
                 <label for="careerNm">역할<span class="required">*</span></label><input id="careerNm" name="careerNm" class="add carInp" type="text" placeholder="예) 대덕인재개발원" required/><br>
                 
                 <label for="careerEnt">기업명<span class="required">*</span></label><input id="careerEnt" name="careerEnt" class="add carInp"  type="text" placeholder="예) 풀스택 개발자" required/><br>
                 
                 <label for="careerBegYm">재직기간<span class="required">*</span></label>
                 <div style="display: flex; width: 110px">
                    <input name="careerBegYm" id="careerBegYm" class="add" type="month" placeholder="예) 202108" required/>
                    <p style="margin: 0px 10px 0px 10px;">-</p>
                    <input name="careerEndYm" id="careerEndYm" type="month" class="add" placeholder="퇴사년도"/><br>
                 </div>
	             	<span id="workChk">재직중&nbsp;&nbsp;<input id="workChkbox" type="checkbox"/></span>
	             	<br>
                 
	             	<div style="display: flex; justify-content: flex-end;">
                    <input id="cancelAjax" type="reset" value="취소"/><input id="addAjax" type="button" value="저장"/>
                 </div>
                 <hr style="width : 796px; margin-left: -70px;">
              </div> 
              <sec:csrfInput />
           </form>      
           `;
      
           
    // 생성된 <div> 요소를 추가할 부모요소(container div) 선택
    const container = document.getElementById('careerBox');
    const firstChild = container.firstChild;

    // 생성된 <div> 요소를 기존의 container div에 자식 요소로 추가
    container.insertBefore(newElement, firstChild);  

    
 // jQuery로 재직중 체크 여부 확인 후 '현재' 표시 (DB에는 null로 저장)
    $('#workChkbox').change(function() {
        const $careerEndYm = $('#careerEndYm');
        if ($(this).is(':checked')) {
            $careerEndYm.val('');  
            $careerEndYm.prop('disabled', true);  
            $careerEndYm.attr('placeholder', '현재');  
        } else {
            $careerEndYm.prop('disabled', false);
            $careerEndYm.attr('placeholder', '퇴사년도');  
        }
    });
 
    // 취소 버튼에 클릭 이벤트를 추가하여 해당 요소를 삭제
    $(newElement).find('#cancelAjax').on('click', function() {
        $(newElement).remove();
    });

}



$(function() {

    // 동적으로 추가된 경력 추가 버튼에 이벤트 연결 (이벤트 위임 사용)
    $(document).on("click", "#addAjax", function() {
    	var mbrId = "${priVO.mbrId}";
        var careerNm = $("#careerNm").val();
        var careerEnt = $("#careerEnt").val();
        var careerBegYm = $("#careerBegYm").val();
        var careerEndYm = $("#careerEndYm").val();

        if (!careerNm) {
        	Toast.fire({
				icon:'warning',
				title:'역할을 입력해주세요'
			});
            return;
        }
        if (!careerEnt) {
        	Toast.fire({
				icon:'warning',
				title:'기업명을 입력해주세요'
			});
            return;
        }
        if (!careerBegYm) {
        	Toast.fire({
				icon:'warning',
				title:'입사연월을 입력해주세요'
			});
            return;
        }
        
        let data={
                "mbrId": mbrId,
                "careerNm": careerNm,
                "careerEnt": careerEnt,
                "careerBegYm": careerBegYm,
                "careerEndYm": careerEndYm
        }

        Swal.fire({
            title: '추가 하시겠습니까?',
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
        	            url: '/member/careerAddAjax', 
        	            contentType: 'application/json',
        	            type: 'POST',
        	            dataType: 'json',
        	            data: JSON.stringify(data),
        	            beforeSend: function(xhr) {
        	                xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
        	            },
        	            success: function(result) {
        	            	console.log("result", result)
        	                	Toast.fire({
        						icon:'success',
        						title:'경력 추가 성공'
        					});

        	                location.reload();  // 등록 후 페이지 새로고침
        	            },
        	            error: function(xhr, status, error) {
        	            	console.error("추가 실패 : ", error)
        	              	Toast.fire({
        						icon:'warning',
        						title:'경력 추가 실패'
        					});
        	            }
        	        });
        	  }
          });
    });
    
    
//--------------------------------- 경력 수정 실행
$(document).on("click", ".careerSave", function(event) {
    event.preventDefault();
    var careerNo = $(this).closest("form").find('input[name="careerNo"]').val();
    var formSelector = "#edit_Form_" + careerNo;
    
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
            $(formSelector).submit();
            Toast.fire({
                icon: 'success',
                title: '수정 완료!'
            });
        } else {
            Toast.fire({
                icon: 'error',
                title: '수정 취소!'
            });
        }
    });
});

 	 // 취소 버튼 클릭 시 원래 목록으로 복원
 	 //동적으로 생성된 요소에 대한 이벤트 처리는 
	$(document).on("click",".cancelCareerAjax",function(){
		let careerNo = $(this).data("careerNo");
		let mbrId = $('input[name="mbrId"]').val();

        
        //수정 div을 식별(가려져있던  div를 보여줄것임)
        $("#editCARForm_"+careerNo).css("display","none");
        
	});
	
    $(document).on("click", ".editCareerAjax", function() {
		let careerNo = $(this).data("careerNo");
		let mbrId = $('input[name="mbrId"]').val();
	
        console.log("careerNo : ", careerNo);
        console.log("mbrId : ", mbrId);
        
        //수정 div을 식별(가려져있던  div를 보여줄것임)
        $("#editCARForm_"+careerNo).css("display","block");
    	

    var careerItem = $(this).closest('.career-item');
    var careerNm = careerItem.find('input[name="careerNm"]').val(); 
    var careerEnt = careerItem.find('input[name="careerEnt"]').val();  
    var careerBegYm = careerItem.find('input[name="careerBegYm"]').val();  
    var careerEndYm = careerItem.find('input[name="careerEndYm"]').val();  

    var isCurrentlyEmployed = (careerEndYm === '현재');

    
    $("#updateCareerAjax").on("click", function() {
        let data = {
            "careerNo": careerNo,
            "mbrId": mbrId,
            "careerNm": $('input[name="careerNm"]').val(),
            "careerEnt": $('input[name="careerEnt"]').val(),
            "careerBegYm": $('input[name="careerBegYm"]').val().replace('.', ''),
            // 재직중 체크가 되어 있으면 퇴사날짜는 null로 설정
            "careerEndYm": $('#workChkbox').is(':checked') ? null : $('input[name="careerEndYm"]').val().replace('.', '')
        };
    });
    
});

    
//--------------------------------- 경력 삭제 실행
	$(document).on("click", ".delCareerAjax", function() {

	    let careerNo = $(this).data("careerNo");
	    let mbrId = $(this).data("mbrId");
	    let $this = $(this);
    	
    let data={
            "mbrId": mbrId,
            "careerNo":careerNo
    }
    Swal.fire({
		title: '삭제 하시겠습니까?',
        icon: 'error',
        showCancelButton: true,
        confirmButtonColor: 'white',
        cancelButtonColor: 'white',
        confirmButtonText: '예',
        cancelButtonText: '아니오',
        reverseButtons: false, // 버튼 순서 거꾸로
        focusConfirm: false // "예" 버튼에 포커스 방지
        
      }).then((result) => {
    	  if (result.isConfirmed) {
    	    	$.ajax({
    	    		url:'/member/careerDelAjax',
    	    		contentType:'application/json;charset=utf-8',
    	    		data:JSON.stringify(data),
    	    		type:'POST',
    	    		dataType:'json',
    	    		beforeSend:function(xhr){
    					xhr.setRequestHeader("${_csrf.headerName}","${_csrf.token}");
    				},
    	    		success:function(result){
    	    			console.log("result : ", result);
    	             	Toast.fire({
    						icon:'success',
    						title:'경력 삭제 성공'
    					});
    	             	$this.closest('.career-item').remove();
    	    		},
    	    		error: function(xhr, status, error) {
    	             	Toast.fire({
    						icon:'warning',
    						title:'경력 삭제 실패'
    					});
    	            }
    	    	}) 
    	    }
        })
    })
});

</script>
<script>
//--------------------------------- 학력 추가
function addAcbg() {
    // 추가할 <div> 요소 생성
    const newElement = document.createElement('div');
    
    // <div> 요소 안에 html 요소 추가
    newElement.innerHTML = `            
        <form name="add_ACForm" id="add_ACForm" action="/member/acbgAddAjax" method="post">
            <div id="addForm">
                <h5 style="margin-left : -70px;">학력 추가</h5>
                <br>
                <input name="acbgNo" class="add" type="hidden"/>
                <input name="mbrId" class="add" type="hidden" value="${priVO.mbrId}"/>
                <div id="schoolBox">
                    <div style="margin-right:10px;">
                        <label for="prseSeCd">학교구분<span class="required">*</span></label><br>
                        <select name="prseSeCd" id="prseSeCd" required>
                            <option value="" selected disabled>학교 구분 선택</option>
                            <c:forEach var="prseSeCd" items="${prseList}">
                                <option value="${prseSeCd.comCode}">${prseSeCd.comCodeNm}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div>
                        <label for="acbgSchlNm">학교<span class="required">*</span></label><br>
                        <input id="acbgSchlNm" name="acbgSchlNm" class="add" type="text" placeholder="예) 대덕인재대학교" required/><br>
                    </div>
                </div>
                <br>
                <div id="spcBox">
                    <div style="margin-right:10px;">
                        <label for="acdeSeCd">학위<span class="required">*</span></label><br>
                        <select name="acdeSeCd" id="acdeSeCd">
                            <option value="" selected disabled>학위 선택</option>
                            <c:forEach var="acdeSeCd" items="${acdeList}">
                                <option value="${acdeSeCd.comCode}">${acdeSeCd.comCodeNm}</option>
                            </c:forEach>
                        </select>
                    </div>    
                    <div>
                        <label for="acbgMjrNm">전공<span class="required">*</span></label><br>
                        <input id="acbgMjrNm" name="acbgMjrNm" class="add" type="text" placeholder="예) 컴퓨터 공학과"/><br>
                    </div>                        
                </div>  
                <br>
                <label for="acbgMtcltnym">재학 기간<span class="required">*</span></label>
                <div style="display: flex; width: 110px">
                    <input name="acbgMtcltnym" id="acbgMtcltnym" class="add" type="month" placeholder="예) 202108" required/>
                    <p style="margin: 0px 10px 0px 10px;">-</p>
                    <input name="acbgGrdtnym" id="acbgGrdtnym" type="month" class="add" placeholder="졸업년도" required/><br>
                </div>
                <div style="display: flex; justify-content: flex-end; margin-right: 40px;">
                    <input id="cancelAcbglAjax" type="reset" value="취소"/>
                    <input id="addAcbgAjax" type="button" class="save" value="저장"/>
                </div>
                <hr style="width : 713px; margin-left: -22px;">
            </div> 
            <sec:csrfInput />
        </form>      
    `;
      
    // 생성된 <div> 요소를 추가할 부모요소(container div) 선택
    const container = document.getElementById('acbgBox');
    const firstChild = container.firstChild;

    // 생성된 <div> 요소를 기존의 container div에 자식 요소로 추가
    container.insertBefore(newElement, firstChild);  

    // 학교 구분 선택에 따른 동적 변경 처리
    const schoolTypeSelect = newElement.querySelector('#prseSeCd');
    const spcBox = newElement.querySelector('#spcBox');

    schoolTypeSelect.addEventListener('change', function() {
        if (schoolTypeSelect.value === 'PRSE02') {
            spcBox.innerHTML = `
                <div style="margin-right:10px;">
                    <label for="acspSeCd">전공계열*</label><br>
                    <select name="acspSeCd" id="acspSeCd">
                        <option value="" selected disabled>전공 계열 선택</option>
                        <c:forEach var="acspSeCd" items="${acspList}">
                            <option value="${acspSeCd.comCode}">${acspSeCd.comCodeNm}</option>
                        </c:forEach>
                    </select>
                </div>
            `;
        } else {
            spcBox.innerHTML = `
                <div style="margin-right:10px;">
                    <label for="acdeSeCd">학위*</label><br>
                    <select name="acdeSeCd" id="acdeSeCd">
                        <option value="" selected disabled>학위 선택</option>
                        <c:forEach var="acdeSeCd" items="${acdeList}">
                            <option value="${acdeSeCd.comCode}">${acdeSeCd.comCodeNm}</option>
                        </c:forEach>
                    </select>
                </div>    
                <div>
                    <label for="acbgMjrNm">전공*</label><br>
                    <input id="acbgMjrNm" name="acbgMjrNm" class="add" type="text" placeholder="예) 컴퓨터 공학과"/><br>
                </div>                        
            `;
        }
    });

    // 취소 버튼에 클릭 이벤트를 추가하여 해당 요소를 삭제
    $(newElement).find('#cancelAcbglAjax').on('click', function() {
        $(newElement).remove();
    });
}


$(function() {
    // 학력 추가 버튼 클릭 시 필수값 체크
    $(document).on("click", "#addAcbgAjax", function() {    	

    	
    	//로그인 아이디(memVO == priVO(JSTL변수))
        var mbrId = "${priVO.mbrId}";
        //학교구분
        //1. 대학교, 2. 고등학교
        var prseSeCd = $('#prseSeCd').val();
        //학교
        var acbgSchlNm = $('#acbgSchlNm').val();
        //학위(1. 대학교)
        var acdeSeCd = $('#acdeSeCd').val();
        //전공(1. 대학교)
        var acbgMjrNm = $('#acbgMjrNm').val();
        //전공계열(2. 고등학교)
        var acspSeCd = $('#acspSeCd').val();
        var acbgMtcltnym = $('#acbgMtcltnym').val();
        var acbgGrdtnym = $('#acbgGrdtnym').val();

        let data = {
                "mbrId":mbrId,
                "prseSeCd":prseSeCd,
                "acbgSchlNm":acbgSchlNm,
                "acdeSeCd":acdeSeCd, 
                "acspSeCd":acspSeCd,
                "acbgMjrNm":acbgMjrNm,
                "acbgMtcltnym":acbgMtcltnym,
                "acbgGrdtnym":acbgGrdtnym
            };
    	
    	if (!prseSeCd ) {
        	Toast.fire({
				icon:'warning',
				title:'학교구분을 선택해주세요'
			});
            return;
        }
    	if (!acbgSchlNm ) {
        	Toast.fire({
				icon:'warning',
				title:'학교명을 입력해주세요'
			});
            return;
        }
    	if (!acbgMtcltnym ) {
        	Toast.fire({
				icon:'warning',
				title:'입학연월을 입력해주세요'
			});
            return;
        }
    	if (!acbgGrdtnym ) {
        	Toast.fire({
				icon:'warning',
				title:'졸업연월을 입력해주세요'
			});
            return;
        }

        
        Swal.fire({
            title: '추가 하시겠습니까?',
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
        	            url: '/member/acbgAddAjax',
        	            contentType: 'application/json;charset=utf-8',
        	            type: 'POST',
        	            dataType: 'json',
        	            data: JSON.stringify(data),
        	            beforeSend:function(xhr){
        					xhr.setRequestHeader("${_csrf.headerName}","${_csrf.token}");
        				},
        	            success: function(result) {
        	            	Toast.fire({
        						icon:'success',
        						title:'추가 성공'
        					});
        	                location.reload();  // 등록 후 페이지 새로고침
        	            },
        	            error: function(xhr, status, error) {
        	            	Toast.fire({
        						icon:'warning',
        						title:'추가 실패'
        					});
        	            }
        	        });
        	 	}
       		 })
   		 });
    
 //--------------------------------- 학력 수정 실행
 $(document).on("click", ".acbgSave", function(event) {
	 event.preventDefault(); // 기본 폼 전송 방지

	 var acbgNo = $(this).closest("form").find('input[name="acbgNo"]').val();
	 var formSelector = "#edit_ACForm_" + acbgNo;

    // Swal.fire 사용하여 수정 확인창 표시
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
            // 수정 확인 시 폼 전송
            $(formSelector).submit();
            Toast.fire({
                icon: 'success',
                title: '수정 완료!'
            });
        } else {
            // 수정 취소 시
            Toast.fire({
                icon: 'error',
                title: '수정 취소!'
            });
        }
    });
});
 	 // 취소 버튼 클릭 시 원래 목록으로 복원
 	 //동적으로 생성된 요소에 대한 이벤트 처리는 
    $(document).on('click','.cancelAcbgAjax', function() {
    	let acbgNo = $(this).data("acbgNo");
        let mbrId = $('input[name="mbrId"]').val();

        console.log("acbgNo : ", acbgNo);
        console.log("mbrId : ", mbrId);
        
        //수정 div을 식별(가려져있던  div를 보여줄것임)
        $("#editACForm_"+acbgNo).css("display","none");
    });
 
    $(document).on("click", ".editAcbgAjax", function() {
	
	let acbgNo = $(this).data("acbgNo");
    let mbrId = $('input[name="mbrId"]').val();

    console.log("acbgNo : ", acbgNo);
    console.log("mbrId : ", mbrId);
    
    //수정 div을 식별(가려져있던  div를 보여줄것임)
    $("#editACForm_"+acbgNo).css("display","block");
    
});

    
    
//--------------------------------- 학력 삭제
	$(document).on("click", ".delAcbgAjax", function() {
	    
	let acbgNo = $(this).data("acbgNo");
    let mbrId = $(this).data("mbrId");
    let $this = $(this);

    console.log("acbgNo : ", acbgNo);
    console.log("mbrId : ", mbrId);
    	
    let data={
            "mbrId": mbrId,
            "acbgNo":acbgNo
    };
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
    	    		url:'/member/acbgDelAjax',
    	    		contentType:'application/json;charset=utf-8',
    	    		data:JSON.stringify(data),
    	    		type:'POST',
    	    		dataType:'json',
    	    		beforeSend:function(xhr){
    					xhr.setRequestHeader("${_csrf.headerName}","${_csrf.token}");
    				},
    	    		success:function(result){
    	    			console.log("result : ", result);
    	    			Toast.fire({
    						icon:'success',
    						title:'삭제 성공'
    					});
    	    			$this.closest('.acbg-item').remove();
    	    		},
    	    		error: function(xhr, status, error) {
    	    			Toast.fire({
    						icon:'warning',
    						title:'삭제 실패'
    					});
    	            }
    	    	});
    	    }
        });   	
    });
    
	  $('.prseSeCdSelect').on('change', function() {
          var selectedValue = $(this).val();
          var formIdSuffix = $(this).attr('id').split('_').pop(); // acbgNo 추출
          var acspSeCdBox = $('#acspSeCdBox_' + formIdSuffix);

          if (selectedValue === 'PRSE02') { // 고등학교 선택 시
              // 학위와 전공 필드를 숨기고 전공계열 필드를 표시
              $('#acdeSeCd_' + formIdSuffix).closest('div').hide();
              $('#acbgMjrNm_' + formIdSuffix).closest('div').hide();
              acspSeCdBox.show();
          } else {
              // 전공계열 필드를 숨기고 학위와 전공 필드를 표시
              acspSeCdBox.hide();
              $('#acdeSeCd_' + formIdSuffix).closest('div').show();
              $('#acbgMjrNm_' + formIdSuffix).closest('div').show();
          }
      });

      // 페이지 로드 시 선택된 값에 따라 필드 표시 상태 설정
      $('.prseSeCdSelect').each(function() {
          $(this).trigger('change');
      });
    
});

</script>
<script>
//--------------------------------- 수상 추가
function addWnpz() {
    // 추가할 <div> 요소 생성
    const newElement = document.createElement('div');

    // <div> 요소 안에 html 요소 추가
	newElement.innerHTML = `
              <form name="add_WnpzForm" id="add_WnpzForm" action="/member/WnpzAddAjax" method="post">
              <div id="addWnpzForm">
                 <h5 style="margin-left : -70px;">수상 추가</h5>
                 <br>
                 <input name="wnpzNo" class="del" type="hidden"/>
                 <input name="mbrId" class="add" type="hidden" value="${priVO.mbrId}"/>
                 <div style="display:flex; flex-direction: column; margin-top: 10px; margin-left: -25px;">
	                 <label for="wnpzCntstNm">수상명<span class="required">*</span></label>
	                 <input id="wnpzCntstNm" name="wnpzCntstNm" class="wnzInp" type="text" placeholder="예) 유니버셜디자인 공모전 특선" required/><br>
	                 
	                 <label for="wnpzAuspcengn">주최기관<span class="required">*</span></label>
	                 <input id="wnpzAuspcengn" name="wnpzAuspcengn" class="wnzInp"  type="text" placeholder="예) 한국장애인인권포럼" required/><br>
	                 
	                 <label for="wnpzPssrpYm">취득일자<span class="required">*</span></label>
	                 <div style="display: flex; width: 110px">
	                    <input name="wnpzPssrpYm" id="wnpzPssrpYm" class="add" type="month" placeholder="예) 202108" required/>
	                 </div>  
                 </div>
	             	<div style="margin-left: 90px; margin-top: 10px; margin-top: 26px;">
                    <input id="cancelWnpzAjax" type="reset" value="취소"/><input id="addWnpzAjax" type="button" class="save" value="저장"/>
                 </div>
                 <hr style="width: 320px; margin-left: -75px;">
              </div> 
              <sec:csrfInput />
           </form>      
           `;
      
           
    // 생성된 <div> 요소를 추가할 부모요소(container div) 선택
    const container = document.getElementById('wnpzBox');
    const firstChild = container.firstChild;

    // 생성된 <div> 요소를 기존의 container div에 자식 요소로 추가
    container.insertBefore(newElement, firstChild);  

    // 취소 버튼에 클릭 이벤트를 추가하여 해당 요소를 삭제
    $(newElement).find('#cancelWnpzAjax').on('click', function() {
        $(newElement).remove();
    });

}

$(function() {
    // 동적으로 추가된 수상 추가 버튼에 이벤트 연결 (이벤트 위임 사용)
    $(document).on("click", "#addWnpzAjax", function() {
    	var mbrId = "${priVO.mbrId}";
        var wnpzCntstNm = $("#wnpzCntstNm").val();
        var wnpzAuspcengn = $("#wnpzAuspcengn").val();
        var wnpzPssrpYm = $("#wnpzPssrpYm").val();

        if (!wnpzCntstNm ) {
        	Toast.fire({
				icon:'warning',
				title:'수상명을 입력해주세요'
			});
            return;
        }
        if (!wnpzAuspcengn) {
        	Toast.fire({
				icon:'warning',
				title:'주최기관을 입력해주세요'
			});
            return;
        }
        if (!wnpzPssrpYm) {
        	Toast.fire({
				icon:'warning',
				title:'취득연월을 입력해주세요'
			});
            return;
        }
        
        
        let data={
                "mbrId": mbrId,
                "wnpzCntstNm": wnpzCntstNm,
                "wnpzAuspcengn": wnpzAuspcengn,
                "wnpzPssrpYm": wnpzPssrpYm
        }
        Swal.fire({
            title: '추가 하시겠습니까?',
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
        	            url: '/member/WnpzAddAjax', 
        	            contentType: 'application/json',
        	            type: 'POST',
        	            dataType: 'json',
        	            data: JSON.stringify(data),
        	            beforeSend: function(xhr) {
        	                xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
        	            },
        	            success: function(result) {
        	            	console.log("result", result)
        	                Toast.fire({
        						icon:'success',
        						title:'추가 성공'
        					});
        	                location.reload();  // 등록 후 페이지 새로고침
        	            },
        	            error: function(xhr, status, error) {
        	            	console.error("추가 실패 : ", error)
        	            	Toast.fire({
        						icon:'warning',
        						title:'추가 실패'
        					});
        	            }
        	        });
        	     }
             });
        });
    //--------------------------------- 수상 수정
     $(document).on("click", ".wnpzSave", function(event) {
	 event.preventDefault(); // 기본 폼 전송 방지
     var wnpzNo = $(this).closest("form").find('input[name="wnpzNo"]').val();
     var formSelector = "#edit_WnpzForm_" + wnpzNo;

    // Swal.fire 사용하여 수정 확인창 표시
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
            // 수정 확인 시 폼 전송
            $(formSelector).submit();
            Toast.fire({
                icon: 'success',
                title: '수정 완료!'
            });
        } else {
            // 수정 취소 시
            Toast.fire({
                icon: 'error',
                title: '수정 취소!'
            });
        }
    });
});
    
    $(document).on("click", ".cancelWnpzAjax", function() {
		let wnpzNo = $(this).data("wnpzNo");
		let mbrId = $('input[name="mbrId"]').val();
	
        console.log("wnpzNo : ", wnpzNo);
        console.log("mbrId : ", mbrId);
        
        
        //수정 div을 식별(가려져있던  div를 보여줄것임)
        $("#editWNPZForm_"+wnpzNo).css("display","none");
        
    });    
    $(document).on("click", ".updateWnpzAjax", function() {
		let wnpzNo = $(this).data("wnpzNo");
		let mbrId = $('input[name="mbrId"]').val();
	
        console.log("wnpzNo : ", wnpzNo);
        console.log("mbrId : ", mbrId);
        
        
        //수정 div을 식별(가려져있던  div를 보여줄것임)
        $("#editWNPZForm_"+wnpzNo).css("display","block");
        
    });  
    
    
    
//--------------------------------- 수상 삭제
	$(document).on("click", ".DelWnpzAjax", function() {
	    
	    let wnpzNo = $(this).data("wnpzNo");
	    let mbrId = $(this).data("mbrId");
	    let $this = $(this);
	    
	    
    	let data={
                "mbrId": mbrId,
                "wnpzNo":wnpzNo
    	}
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
        	    		url:'/member/WnpzDelAjax',
        	    		contentType:'application/json;charset=utf-8',
        	    		data:JSON.stringify(data),
        	    		type:'POST',
        	    		dataType:'json',
        	    		beforeSend:function(xhr){
        					xhr.setRequestHeader("${_csrf.headerName}","${_csrf.token}");
        				},
        	    		success:function(result){
        	    			console.log("result : ", result);
        	    			Toast.fire({
        						icon:'success',
        						title:'삭제 성공'
        					});
        	    			$this.closest('.wnpz-item').remove(); // 삭제할 요소 선택
        	    		},
        	    		error: function(xhr, status, error) {
        	    			Toast.fire({
        						icon:'warning',
        						title:'삭제 실패'
        					});
        	            }
        	    	})
        	    }
          });
      })
  });


</script>
<script>
//--------------------------------- 활동 추가
function addAct() {
    // 추가할 <div> 요소 생성
    const newElement = document.createElement('div');

    // <div> 요소 안에 html 요소 추가
	newElement.innerHTML = `
              <form name="add_ActForm" id="add_ActForm" action="/member/actAddAjax" method="post">
              <div id="addActForm">
                 <h5 style="margin-left : -70px;">활동 추가</h5>
                 <br>
                 <input name="actNo" class="del" type="hidden"/>
                 <input name="mbrId" class="add" type="hidden" value="${priVO.mbrId}"/>
                 
                 <label for="actNm">활동명<span class="required">*</span></label><input id="actNm" name="actNm" class="add carInp" type="text" placeholder="예) Highthon(하이톤)브랜딩" required/><br>
                 
                 <label for="actAuspcengn">주최기관<span class="required">*</span></label><input id="actAuspcengn" name="actAuspcengn" class="add carInp"  type="text" placeholder="예) Highthon" required/><br>
                 
                 <label for="actBeginYm">활동 일자<span class="required">*</span></label>
                 <div style="display: flex; width: 110px">
                     <input name="actBeginYm" id="actBeginYm" class="add" type="month" placeholder="예) 202108" required/>
                     <p style="margin: 0px 10px 0px 10px;">-</p>
                     <input name="actEndYm" id="actEndYm" type="month" class="add" placeholder="종료일자" required/><br>
                 </div>  
                 <br>
                 <div>
                   <label for="actNc">간단 활동 설명<span class="required">*</span></label><br>
             		<textarea rows="2" cols="66" id="actNc" name="actNc"></textarea>
                 </div>
	             	<div style="display: flex; justify-content: flex-end;">
                    <input id="cancelActAjax" type="reset" value="취소"/><input id="addActAjax" type="button" class="save" value="저장"/>
                 </div>
                 
                 <hr style="width : 796px; margin-left: -70px;">
              </div> 
              <sec:csrfInput />
           </form>      
           `;
      
           
    // 생성된 <div> 요소를 추가할 부모요소(container div) 선택
    const container = document.getElementById('actBox');
    const firstChild = container.firstChild;

    // 생성된 <div> 요소를 기존의 container div에 자식 요소로 추가
    container.insertBefore(newElement, firstChild);  

    // 취소 버튼에 클릭 이벤트를 추가하여 해당 요소를 삭제
    $(newElement).find('#cancelActAjax').on('click', function() {
        $(newElement).remove();
    });

}

$(function() {
    // 동적으로 추가된 경력 추가 버튼에 이벤트 연결 (이벤트 위임 사용)
    $(document).on("click", "#addActAjax", function() {
    	var mbrId = "${priVO.mbrId}";
        var actNm = $('input[name="actNm"]').val();
        var actAuspcengn = $('input[name="actAuspcengn"]').val();
        var actBeginYm = $('input[name="actBeginYm"]').val();
        var actEndYm = $('input[name="actEndYm"]').val();
        var actNc = $('textarea[name="actNc"]').val();

        if (!actNm) {
        	Toast.fire({
				icon:'warning',
				title:'활동명을 입력해주세요'
			});
            return;
        }
        if (!actAuspcengn) {
        	Toast.fire({
				icon:'warning',
				title:'주최기관을 입력해주세요'
			});
            return;
        }

        if (!actBeginYm) {
        	Toast.fire({
				icon:'warning',
				title:'시작연월을 입력해주세요'
			});
            return;
        }
        if (!actEndYm) {
        	Toast.fire({
				icon:'warning',
				title:'종료연월을 입력해주세요'
			});
            return;
        }
        if (!actNc) {
        	Toast.fire({
				icon:'warning',
				title:'활동설명을 입력해주세요'
			});
            return;
        }
        let data={
                "mbrId": mbrId,
                "actNm": actNm,
                "actAuspcengn": actAuspcengn,
                "actBeginYm": actBeginYm,
                "actEndYm": actEndYm,
                "actNc": actNc
        }
        
        Swal.fire({
            title: '추가 하시겠습니까?',
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
        	            url: '/member/actAddAjax', 
        	            contentType: 'application/json',
        	            type: 'POST',
        	            dataType: 'json',
        	            data: JSON.stringify(data),
        	            beforeSend: function(xhr) {
        	                xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
        	            },
        	            success: function(result) {
        	                Toast.fire({
        						icon:'success',
        						title:'추가 성공'
        					});
        	                location.reload();  // 등록 후 페이지 새로고침
        	            },
        	            error: function(xhr, status, error) {
        	            	Toast.fire({
        						icon:'warning',
        						title:'추가 실패'
        					});
        	            }
        	        });
        	  }     
          });
    });


  //--------------------------------- 활동 수정
 $(document).on("click", ".actSave", function(event) {
	 event.preventDefault(); // 기본 폼 전송 방지
    var actNo = $(this).closest("form").find('input[name="actNo"]').val();
    var formSelector = "#edit_ACTForm_" + actNo;

    // Swal.fire 사용하여 수정 확인창 표시
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
            // 수정 확인 시 폼 전송
            $(formSelector).submit();
            Toast.fire({
                icon: 'success',
                title: '수정 완료!'
            });
        } else {
            // 수정 취소 시
            Toast.fire({
                icon: 'error',
                title: '수정 취소!'
            });
        }
    });
});
    $(document).on("click", ".cancelActAjax", function() {
    	
    		let actNo = $(this).data("actNo");
    		let mbrId = $('input[name="mbrId"]').val();
    	
            console.log("actNo : ", actNo);
            console.log("mbrId : ", mbrId);
            
            //수정 div을 식별(가려져있던  div를 보여줄것임)
            $("#editACTForm_"+actNo).css("display","none");
    });    
         	
    $(document).on("click", ".updateActAjax", function() {
    	
    		let actNo = $(this).data("actNo");
    		let mbrId = $('input[name="mbrId"]').val();
    	
            console.log("actNo : ", actNo);
            console.log("mbrId : ", mbrId);
            
            //수정 div을 식별(가려져있던  div를 보여줄것임)
            $("#editACTForm_"+actNo).css("display","block");
    });    
         	
//--------------------------------- 활동 삭제
	$(document).on("click", ".DelActAjax", function() {
	    
	    let actNo = $(this).data("actNo");
	    let mbrId = $(this).data("mbrId");
	    let $this = $(this);
    	
    let data={
            "mbrId": mbrId,
            "actNo":actNo
    }
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
    	    		url:'/member/actDelAjax',
    	    		contentType:'application/json;charset=utf-8',
    	    		data:JSON.stringify(data),
    	    		type:'POST',
    	    		dataType:'json',
    	    		beforeSend:function(xhr){
    					xhr.setRequestHeader("${_csrf.headerName}","${_csrf.token}");
    				},
    	    		success:function(result){
    	    			console.log("result : ", result);
    	    			Toast.fire({
    						icon:'success',
    						title:'삭제 성공'
    					});
    	    			$this.closest('.act-item').remove(); // 삭제할 요소 선택
    	    		},
    	    		error: function(xhr, status, error) {
    	    			Toast.fire({
    						icon:'warning',
    						title:'삭제 실패'
    					});
    	            }
    	    	})
    	    }
        })
    })
});

</script>
<script>
//--------------------------------- 자격증 추가
function addCrtfct() {
    // 추가할 <div> 요소 생성
    const newElement = document.createElement('div');

    // <div> 요소 안에 html 요소 추가
   newElement.innerHTML = `
               <form name="add_CrtForm" id="add_CrtForm" action="/member/crtfctAddAjax" method="post">
                    <div id="addCrtForm">
                       <h5 style="margin-left:-60px; ">자격증 추가</h5>
                       <br>
                       <input name="crtfctNo" id="crtfctNo" class="del" type="hidden"/>
                       <input name="mbrId" id="mbrId" class="add" type="hidden" value="${priVO.mbrId}"/>
                       <div style="margin-left: -25px; display: flex; flex-direction: column;">
                          <label class="slabel" for="crtfctNm">자격증명<span class="required">*</span></label>
                          <input id="crtfctNm" name="crtfctNm" class="add crtInp" type="text" placeholder="예) 정보처리기사" required/><br>
                          
                          <label class="slabel" for="crtfctPblcnoffic">주최기관<span class="required">*</span></label>
                          <input id="crtfctPblcnoffic" name="crtfctPblcnoffic" class="add crtInp"  type="text" placeholder="예) 한국산업인력공단" required/><br>
                          
                          <label class="slabel" for="crtfctAcqsDate">취득 일자<span class="required">*</span></label>
                          <div style="display: flex; width: 110px">
                              <input name="crtfctAcqsDate" id="crtfctAcqsDate" class="add" type="month" placeholder="예) 202108" required/>
                          </div>  
                       </div>
                          <div style="margin-left: 90px; margin-top: 26px;">
                          <input id="cancelCrtAjax" type="reset" value="취소"/><input id="addCrtAjax" type="button" class="save" value="저장"/>
                       </div>
                       
                       <hr style="width: 320px; margin-left: -75px;">
                    </div> 
                    <sec:csrfInput />
              </form>   
           `;
      
           
    // 생성된 <div> 요소를 추가할 부모요소(container div) 선택
    const container = document.getElementById('crtfctBox');
    const firstChild = container.firstChild;

    // 생성된 <div> 요소를 기존의 container div에 자식 요소로 추가
    container.insertBefore(newElement, firstChild);  

    // 취소 버튼에 클릭 이벤트를 추가하여 해당 요소를 삭제
    $(newElement).find('#cancelCrtAjax').on('click', function() {
        $(newElement).remove();
    });

}
$(function() {
    // 동적으로 추가된 경력 추가 버튼에 이벤트 연결 (이벤트 위임 사용)
    $(document).on("click", "#addCrtAjax", function() {
    	var mbrId = "${priVO.mbrId}";
        var crtfctNm = $('input[name="crtfctNm"]').val();
        var crtfctPblcnoffic = $('input[name="crtfctPblcnoffic"]').val();
        var crtfctAcqsDate = $('input[name="crtfctAcqsDate"]').val();

        if (!crtfctNm) {
        	Toast.fire({
				icon:'warning',
				title:'자격증명을 입력해주세요'
			});
            return;
        }
        if (!crtfctPblcnoffic) {
        	Toast.fire({
				icon:'warning',
				title:'주최기관을 입력해주세요'
			});
            return;
        }
        
        if (!crtfctAcqsDate) {
        	Toast.fire({
				icon:'warning',
				title:'취득연월을 입력해주세요'
			});
            return;
        }
        
        let data={
               "mbrId": mbrId,
                 "crtfctNm": crtfctNm,
                 "crtfctPblcnoffic": crtfctPblcnoffic,
                 "crtfctAcqsDate": crtfctAcqsDate
        }
            Swal.fire({
              title: '추가 하시겠습니까?',
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
                      url: '/member/crtfctAddAjax', 
                      contentType: 'application/json',
                      type: 'POST',
                      dataType: 'json',
                      data: JSON.stringify(data),
                      beforeSend: function(xhr) {
                          xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
                      },
                      success: function(result) {
                         console.log("result", result)
                          Toast.fire({
          					icon:'success',
          					title:'추가 성공'
          				});
                          location.reload();  // 등록 후 페이지 새로고침
                      },
                      error: function(xhr, status, error) {
                         console.error("추가 실패 : ", error)
                         Toast.fire({
          					icon:'warning',
          					title:'추가 실패'
          				});
                      }
                  });
              }
          });
    });
    
  //--------------------------------- 자격증 수정
   	 $(document).on("click", ".saveCrtfct", function(event) {
	 event.preventDefault(); // 기본 폼 전송 방지
	 
	 var crtfctNo = $(this).closest("form").find('input[name="crtfctNo"]').val();
	 var formSelector = "#edit_CRTForm_" + crtfctNo;

    // Swal.fire 사용하여 수정 확인창 표시
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
            // 수정 확인 시 폼 전송
           $(formSelector).submit();
            Toast.fire({
                icon: 'success',
                title: '수정 완료!'
            });
        } else {
            // 수정 취소 시
            Toast.fire({
                icon: 'error',
                title: '수정 취소!'
            });
        }
    });
});
 	 
    $(document).on("click", ".cancelCrtfctAjax", function() {
		let crtfctNo = $(this).data("crtfctNo");
		let mbrId = $('input[name="mbrId"]').val();
	
        console.log("crtfctNo : ", crtfctNo);
        console.log("mbrId : ", mbrId);
        
        //수정 div을 식별(가려져있던  div를 보여줄것임)
        $("#editCRTForm_"+crtfctNo).css("display","none")
        
    }); 
  
    $(document).on("click", ".updateCrtfctAjax", function() {
		let crtfctNo = $(this).data("crtfctNo");
		let mbrId = $('input[name="mbrId"]').val();
	
        console.log("crtfctNo : ", crtfctNo);
        console.log("mbrId : ", mbrId);
        
        //수정 div을 식별(가려져있던  div를 보여줄것임)
        $("#editCRTForm_"+crtfctNo).css("display","block")    
    }); 

//--------------------------------- 자격증 삭제
   $(document).on("click", ".DelCrtAjax ", function() {
       
       let crtfctNo = $(this).data("crtfctNo");
       let mbrId = $(this).data("mbrId");
       // 현재 클릭된 요소를 저장
       let $this = $(this);
       let data={
                "mbrId": mbrId,
                "crtfctNo":crtfctNo
       }
       
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
        	          url:'/member/crtfctDelAjax',
        	  		  contentType:'application/json;charset=utf-8',
        	          data:JSON.stringify(data),
        	          type:'POST',
        	          dataType:'json',
        	          beforeSend:function(xhr){
        	            xhr.setRequestHeader("${_csrf.headerName}","${_csrf.token}");
        	         },
        	          success:function(result){
        	             console.log("result : ", result);
        	             Toast.fire({
        						icon:'success',
        						title:'삭제 성공'
        					});
        	             $this.closest('.crtfct-item').remove(); // 삭제할 요소 선택
        	          },
        	          error: function(xhr, status, error) {
        	        	  Toast.fire({
        						icon:'warning',
        						title:'삭제 실패'
        					});
        	            }
        	       })
        	 }
         })
    })
})
<!-- ////////////////////////////////////////////////////////////////////////////////////// -->    

</script>

<!-- ////////////////////////////////////////////////////////////////////////////////////// -->
<script>
$(function(){
    $(".prfConEdit").on("click", function() {
        let proflContent = $(this).data("profl-content");
        let mbrId = $(this).data("mbr-id");

        console.log("proflContent:", proflContent); 
        console.log("mbrId:", mbrId);  
        
        $("#modalCont").val(proflContent);
        $("#modalMbrId").val(mbrId);
        
        // 글자 수 업데이트
        $("#charCount").text(proflContent.length);

        $('#modalContent').modal('show');
    });

	 // 글자 수 실시간 업데이트
	    $("#modalCont").on("input", function() {
	        let currentLength = $(this).val().length;
	        $("#charCount").text(currentLength);
	        
	        if (currentLength > 100) {
	            $("#warning").show();  // 경고 메시지 표시
	            $(this).val($(this).val().substring(0, 100));  // 글자 수 제한
	            $("#charCount").text(100);  // 100자까지만 표시
	        } else {
	            $("#warning").hide();  // 경고 메시지 숨김
	        }
	        
	    });
 
	//id="submit" 요소들이 많이 있어서 
    $("#submitCont").on("click", function(event){
        event.preventDefault(); 
        
        let updatedContent = $("#modalCont").val();
        let mbrId = $("#modalMbrId").val();
        
        let data = {
            "mbrId": mbrId,
            "proflContent": updatedContent
        };
        
        /*
        {
		    "mbrId": "test1",
		    "proflContent": "안녕하세요, 저는 Java 웹 개발자입니다. Spring Framework와 RESTful API에 능숙합니덩2"
		}
        */
        Swal.fire({
            title: '저장 하시겠습니까?',
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
                    url: '/member/prfUpdateAjax',
                    contentType: "application/json;charset=utf-8",
                    data: JSON.stringify(data),
                    type: "POST",
                    dataType: "json",
                    beforeSend: function(xhr){
                        xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
                    },
                    success: function(result){
                            $("#proflContent").val(updatedContent);
                            Toast.fire({
            					icon:'success',
            					title:'저장 성공'
            				});
                            $('#modalContent').modal('hide');  // 모달 닫기
                            location.reload();  // 등록 후 페이지 새로고침
                    },
                    error: function(xhr, status, error) {
                    	Toast.fire({
        					icon:'warning',
        					title:'저장 실패'
        				});
                    }
                });//end ajax
        	}
        });
        
    });
});

</script>

<!-- 프로필 이미지 -->
<script>
$(function(){
	  // e : onchange 이벤트
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
				Toast.fire({
					icon:'warning',
					title:'이미지 확장자만 가능합니다.'
				});
				return; // 함수 자체가 종료됨
			}
			// 이미지가 맞다면 => 파일을 읽어주는 객체 생성
			let reader = new FileReader();
			// 파일을 읽자
			// e : reader가 이미지 객체를 읽는 이벤트
			reader.onload = function(e){// "+e.target+result+" - 이미지를 다 읽었으면 결과를 가져와라 -> 그것을 누적
				accumStr += "<img src='"+e.target.result+"' style='width:40%; border:1px solid #D7D7D7;'/>";  // 누적 String
				$(".pImg").html(accumStr);
			}
			reader.readAsDataURL(f);
			
		});
		// 요소.append : 누적, 요소.html : 새로고침, 요소.innerHTML : J/S에서 새로고침
	}
})

$(function(){
    // 이미지 클릭 시 파일 입력창 열기
	    $(".pImg").on("click",function(){
	  	  $("#uploadFile").click()
	    })
    
    // 파일 선택 후 이미지 미리보기
    $("#uploadFile").on("change", function(e) {
        let file = e.target.files[0];
        if(!file){
        	return;
        }
        
        if (!file.type.match("image.*")) {
        	Toast.fire({
				icon:'warning',
				title:'이미지 파일만 업로드 가능합니다.'
			});
            return;
        }

        let reader = new FileReader();
        reader.onload = function(e) {
            $(".pImg").attr("src", e.target.result);
        }
        reader.readAsDataURL(file);
    });
    // 카메라 클릭하면
    $("#camera").on("click",function(){
    	$("#camera").css("display","none");
    	$("#IChange2").css("display","block");
    	$("#uploadFile").attr("disabled",false);
    	
    	pImg = $("img[name='pImg']").attr("src");
    })
    $("#Icancel").on("click",function(){
    	$("#camera").css("display","block");    	
    	$("#IChange2").css("display","none");
    	$("#uploadFile").attr("disabled",true);
    	
    	$("img[name='pImg']").attr("src",pImg);
    })


});

</script>
<script>
$(function(){
    let maxChecked = 3;  // 최대 선택 가능한 체크박스 수

    // 체크박스 선택 시마다 실행되는 함수
    $('.busiChk').on('change', function() {
        // 선택된 체크박스 개수
        let checkedCount = $('.busiChk:checked').length;
        
        // 체크박스가 3개 초과로 선택되면 경고하고 선택을 취소함
        if (checkedCount > maxChecked) {
//             alert('최대 ' + maxChecked + '개까지만 선택 가능합니다.');
        	Toast.fire({
				icon:'warning',
				title:'최대 ' + maxChecked + '개까지만 선택 가능합니다.'
			});
            $(this).prop('checked', false);
        }
    });
    $(document).on("click", "#busiSave", function(event) {
   	 event.preventDefault(); // 기본 폼 전송 방지
   	 $("#EditForm").attr("action", "/member/BusinessAdd");

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
               $("#EditForm").submit();
               Toast.fire({
                   icon: 'success',
                   title: '수정 완료!'
               });
           } else {
               // 수정 취소 시
               Toast.fire({
                   icon: 'error',
                   title: '수정 취소!'
               });
           }
       });
   });

    let hiddenPrfRlsscopeCd = $("#hiddenPrfRlsscopeCd").val();
    console.log("hiddenPrfRlsscopeCd 값: ", hiddenPrfRlsscopeCd);

    // scout 버튼 CSS 
    $("#scout").css({
        'background': '#ECECEC',
        'color': '#232323',
        'border': '1px solid #B5B5B5',
        'pointer-events': 'none'
    }).attr("disabled", true); // 기본적으로 비활성화

    // scoutSel이 존재하는 경우에만 스타일 변경
    if ($('#scoutSel').length > 0) {
        console.log("scoutSel 요소가 존재합니다.");

        $("#scoutSel").change(function() {
            let prfRlsscopeCd = $(this).val();
            console.log("선택된 prfRlsscopeCd 값: ", prfRlsscopeCd);

            if (prfRlsscopeCd === 'RLSC01') {  // '입사제안을 받지 않을래요'
                $("#scout").css({
                    'background': '#ECECEC',
                    'color': '#232323',
                    'border': '1px solid #B5B5B5',
                    'pointer-events': 'none'
                }).attr("disabled", true); // 버튼 비활성화
            } else if (prfRlsscopeCd === 'RLSC02') {  // '입사제안을 받을래요'
                $("#scout").css({
                    'background': '#24D59E',
                    'color': 'white',
                    'border': '1px solid #24D59E',
                    'pointer-events': 'auto'
                }).attr("disabled", false); // 버튼 활성화
            }
        });

        // 페이지가 로드될 때 scoutSel 값을 기반으로 버튼 초기화
        let prfRlsscopeCd = $("#scoutSel").val();
        
        if (prfRlsscopeCd === 'RLSC01') {  // '입사제안을 받지 않을래요'
            $("#scout").css({
                'background': '#ECECEC',
                'color': '#232323',
                'border': '1px solid #B5B5B5',
                'pointer-events': 'none'
            }).attr("disabled", true); // 버튼 비활성화
        } else if (prfRlsscopeCd === 'RLSC02') {  // '입사제안을 받을래요'
            $("#scout").css({
                'background': '#24D59E',
                'color': 'white',
                'border': '1px solid #24D59E',
                'pointer-events': 'auto'
            }).attr("disabled", false); // 버튼 활성화
        }
    } else {
        
        if (hiddenPrfRlsscopeCd === 'RLSC01') {  // '입사제안을 받지 않을래요'
            $("#scout").css({
                'background': '#ECECEC',
                'color': '#232323',
                'border': '1px solid #B5B5B5',
                'pointer-events': 'none'
            }).attr("disabled", true); // 버튼 비활성화
        } else if (hiddenPrfRlsscopeCd === 'RLSC02') {  // '입사제안을 받을래요'
            $("#scout").css({
                'background': '#24D59E',
                'color': 'white',
                'border': '1px solid #24D59E',
                'pointer-events': 'auto'
            }).attr("disabled", false); // 버튼 활성화
        }
    }
     
    $("#scoutSel").change(function(){
    	let prfRlsScopeCd = $('#scoutSel').val();
    	let mbrId = $("#mbrId").val();
    	
    	console.log("선택한 scoutSel 값:", prfRlsScopeCd);
        console.log("mbrId 값:", mbrId);
    
	    let data = {
	   	       "mbrId": mbrId,
	   	       "prfRlsscopeCd": prfRlsScopeCd
	    }
	    
	    /*
	    {
		    "mbrId": "test1",
		    "prfRlsscopeCd": "RLSC01"
		}
	    */
	    console.log("data : ", data);
	    
	    $.ajax({
	    	url:'/member/prfUpdateScout',
	    	contentType:'application/json;charset=utf-8',
	    	data:JSON.stringify(data),
	    	type: 'POST', 
	    	dataType:'json',
	    	beforeSend: function(xhr) {
	    	      xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
	    	   },
	         success: function(result){
	        	 	 console.log("scoutSel->result : ", result);
	                 Toast.fire({
	 					icon:'success',
	 					title:'수정 성공'
	 				});
	
	                    // location.reload();  //새로고침
	                
	              // 'RLSC01'일 때 스타일 적용
                 if ($('#scoutSel').val() === 'RLSC01') {
                     $("#scout").css({
                         'background': '#ECECEC',
                         'color': '#232323',
                         'border': '1px solid #B5B5B5',
                         'pointer-events': 'none'
                     }).attr("disabled", true); // 버튼 비활성화
                 } else if ($('#scoutSel').val() === 'RLSC02'){
                     // 다른 값일 때 기본 스타일로 복구
                     $("#scout").css({
                         'background': '#24D59E',
                         'color': 'white',
                         'border': '1px solid #24D59E',
                         'pointer-events': 'auto'
                     }).attr("disabled", false); // 버튼 활성화
                 }
	         },
	         error: function(xhr, status, error) {
	         	Toast.fire({
						icon:'warning',
						title:'수정 실패'
					});
	         }
	    });//end ajax

	 });//end scoutSel
	 
  //스크롤 이벤트 감지하여 일정 높이 이상 스크롤되면 Top 버튼 표시
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
	 
});
</script>
<script>
$(function(){

//스킬 script
let skillListRaw = "${codeGrpVOMap.get('SK')}";
let skillList = [];

function parseJavaObject(str) {
    let codeVORegex = /CodeVO\(([^)]+)\)/g;
    let codeVOMatches = str.match(codeVORegex);
    
    if (codeVOMatches) {
        skillList = codeVOMatches.map(match => {
            try {
                let props = match.slice(7, -1).split(', ');
                let obj = {};
                props.forEach(prop => {
                    let [key, value] = prop.split('=');
                    obj[key.trim()] = value.trim(); // 공백 제거
                });
                return {
                    codeNm: obj.comCodeNm || "",  // 값이 없을 경우 빈 문자열 처리
                    codeNo: obj.comCode || ""     // 값이 없을 경우 빈 문자열 처리
                };
            } catch (e) {
                console.error("Error parsing CodeVO object:", e);
                return null;  // 파싱 실패 시 null 리턴
            }
        }).filter(item => item !== null); // null 값 제거
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
    let filteredSkills = skillList.filter(skill => 
        skill.codeNm.toLowerCase().includes(searchStr)
    );

    updateSearchResults(filteredSkills, searchStr);
});

function updateSearchResults(skills, searchStr) {
    let searchResults = $(".search-results");
    searchResults.empty();
    let skillItem = "";

    skills.forEach(skill => {
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
                 + '&nbsp;&nbsp;</span>';

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

$(".submitBtn").on("click", function() {
	let skillCodes = $("#skill-select-box .selected-skill").map(function() {
	    return $(this).data('code-no');
	}).get().filter(function(code) {
	    return code;
	});

	// 중복 제거
	skillCodes = $.unique(skillCodes);

	// 쉼표로 구분된 문자열로 변환
	let skCd = skillCodes.join(',');

	console.log("ewkjabfak : "+ skillCodes);
	// FormData 객체 생성
	let formData = new FormData();

	// FormData에 값 추가
	formData.append("skCd", skCd);
	 Swal.fire({
         title: '저장 하시겠습니까?',
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
    		        url: "/member/skillAdd",
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
    		            location.reload();
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
       });
});
	
//스킬 추가 버튼 클릭 시 기존 선택된 스킬을 유지
$(document).on("click", "#addSkBtn", function() {
    $(".addSkBox").css("display", "block");
    let code = $("#realSkillBox").html();
    
    $("#skill-select-box").html(code);

});
	
	// 취소 버튼 클릭
	$(document).on("click", ".resetBtn", function() {
	    $(".addSkBox").css("display", "none");
	});
	
		
})

//  -----------------------------------------스카우트 모달 (기업 -> 회원) 시작 -----------------------------------------------
document.addEventListener("DOMContentLoaded", function() {
    var modal = document.getElementById("scoutModal");
    var closeBtn = document.querySelector(".close1");
    var cancelButton = document.getElementById("cancel-btn");

    // "스카우트" 버튼 클릭 시 모달 열기
    document.getElementById("scout").addEventListener("click", function() {
        let mbrId = "${param.mbrId}";
        let mbrEml = $('#mbrEml').val();
        let entId = $('#entId').val();
        console.log('Member ID: ' + mbrId);
        console.log('Member Email: ' + mbrEml);
        console.log("entId : " + entId);
        $("#mbrIdForm").val(mbrId);
        $("#mbrEmlForm").val(mbrEml);
        data = { entId: entId };
        let code = "";
        code += "<option value='' disabled selected>공고를 선택해주세요.</option>";
        
        $.ajax({
            url: '/member/profilePbanc',
            contentType: 'application/json;charset=utf-8',
            data: JSON.stringify(data),
            type: 'POST',
            dataType: 'json',
            beforeSend: function(xhr) {
                xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
            },
            success: function(result) {
                console.log("scoutSel->result : ", result[0].pbancTtl);
                $.each(result, function(index, item) {
                    console.log(item.pbancTtl);
                    code += "<option value='" + item.pbancTtl + "'>" + item.pbancTtl + "</option>";
                });
                $('#jobPost').html(code);
            },
        }); // end ajax
        
        // 모달 열기
        modal.style.display = "block";
    });

    // 닫기 버튼 클릭 시 모달 닫기
    closeBtn.onclick = function() {
        modal.style.display = "none";
    };

    // 취소 버튼 클릭 시 모달 닫기
    cancelButton.onclick = function() {
        modal.style.display = "none";
    };

    // 스카우트 폼 제출 처리
    document.getElementById('submit-btn').addEventListener('click', function(e) {
        e.preventDefault();
        var formData = new FormData(document.getElementById('scoutForm'));
        let mbrEml = $('#mbrEmlForm').val();
        formData.append('recipientEmail', mbrEml);  // 수신자 이메일 추가
        
        Swal.fire({
            title: '스카우트 제안하시겠습니까?',
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
                    url: '/enter/sendScoutEmail',
                    type: 'POST',
                    data: formData,
                    processData: false,
                    contentType: false,
                    beforeSend: function(xhr) {
                        xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
                    },
                    success: function(response) {
                        Toast.fire({
                            icon: 'success',
                            title: '스카우트 제안 성공'
                        });
                        document.getElementById('scoutModal').style.display = 'none';
                    },
                    error: function() {
                        Toast.fire({
                            icon: 'error',
                            title: '스카우트 제안 실패'
                        });
                    }
                });
            }
        });
    });
});
//-----------------------------------------스카우트 모달 (기업 -> 회원) 끝 -----------------------------------------------
//-----------------------------------------채팅 생성 시작 -----------------------------------------------
$(document).on('click', '.chatGo', function() {
    const senderUser = $(this).data('sender');
    const receiveUser = $(this).data('receiver');
	console.log("여긴왔니?")
    // AJAX 요청으로 채팅방 생성
    $.ajax({
        url: '/chat/createChatRoom',
        type: 'POST',
        data: {
            senderUser: senderUser,
            receiveUser: receiveUser
        },
        beforeSend: function(xhr) {
            xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
        },
        success: function(response) {
		 if (response === 'success') {
                Toast.fire({
                    icon: 'success',
                    title: '채팅방이 생성되었습니다.'
                }).then(() => {
                    // Toast가 사라진 후 채팅 목록으로 이동
                    window.location.href = '/chat/memChatList';
                });
            } else {
            	Toast.fire({
                    icon: 'info',
                    title: '현재 채팅중인 회원입니다.'
                })
            }
        },
        error: function(xhr, status, error) {
            alert('서버 오류: ' + error);
        }
    });
});
//-----------------------------------------채팅 생성 시작 -----------------------------------------------
</script>
	<sec:authentication property="principal" var="prc" />
<div class="content-wrapper">
	<c:if test="${prc ne 'anonymousUser'}">
<%-- 		<input type="hidden" id="hasRoleEnter" value="${prc.authorities}" /> --%>
	</c:if>
	<div id="topPro">
		<br>
		<div id="nav">
			<!-- 			<img style="width: 100%;" alt="" src="../resources/images/배경2.png" class="배경2.png"> -->
			<img style="width: 100%;" alt="" src="../resources/images/배경.png"
				class="배경2.png">
			<!-- 이미지 수정 -->
			<form id="editPrfImg"
				action="/member/profile/editPrfImg?${_csrf.parameterName}=${_csrf.token}"
				method="post" enctype="multipart/form-data">
				<div class="profile-edit">
					<div class="profile-photo">

						<img
							src="${memberVO.fileDetailVOList[0].filePathNm}?version=${imageVersion}"
							alt="${memberVO.fileDetailVOList[0].orgnlFileNm}"
							class="pImg img" name="pImg" id="pImg"> <br>
						<c:if test="${isOwner}">
							<span class="material-icons" id="camera">photo_camera</span>
						</c:if>
						<input class="custom-file-input" type="file" id="uploadFile"
							name="uploadFile" multiple style="display: none;" disabled />
					</div>
					<c:if test="${isOwner}">
						<span id="IChange2" class="button-group" style="display: none;">
							<input type="submit" id="Isave" value="저장" /> <input
							type="button" id="Icancel" value="취소" />
						</span>
					</c:if>
				</div>
				<sec:csrfInput />
			</form>
		</div>
		<br>
		<p id="mbrNm">${memberVO.mbrNm}</p>
		<br>
		<div class="scoutYN">
			<sec:authorize access="hasRole('ROLE_ENTER') or hasRole('ROLE_MEMENTER')">
				<input type="button" id="scout" class="scout-button" value="스카우트"/>
			</sec:authorize>

			<c:if test="${isOwner}">
				<select id="scoutSel">
					<option value="" disabled>입사제안 여부 선택*</option>
					<c:forEach var="codeVO" items="${rlscVOList}">
						<option value="${codeVO.comCode}"
							<c:if test="${codeVO.comCode == prfVO.prfRlsscopeCd}">selected</c:if>>
							${codeVO.comCodeNm}
					</c:forEach>
				</select>
				<input type="hidden" id="mbrId" value="${prfVO.mbrId}" />
			</c:if>
			<!-- 채팅테스트중 -->
			<!-- 채팅테스트중 -->
			<c:if test="${prc ne 'anonymousUser'}">
			<sec:authorize access="hasRole('ROLE_MEMBER')">
				<c:if test="${!isOwner}">
					<button type="button" class="chatGo" data-sender="${prc.username}" data-receiver="${memberVO.mbrId}">채팅</button>
				</c:if>
			</sec:authorize>
			</c:if>
			<!-- 로그인 안될떄 alert 띄우셈 -->
			<c:if test="${prc eq 'anonymousUser'}">
			</c:if>
			<!-- prfRlsscopeCd 값 전달 (scoutSel이 없을 때 사용할 값) -->
			<input type="hidden" id="hiddenPrfRlsscopeCd"
				value="${prfVO.prfRlsscopeCd}" />
				<input type="hidden" id="mbrEml" class="mbrEml" value="${prfVO.mbrEml}" />
		</div>

		<div id="introduce">
			<c:choose>
				<c:when test="${not empty prfVO.proflContent}">
					<textarea name="proflContent" id="proflContent" readonly>${prfVO.proflContent}</textarea>
				</c:when>
				<c:otherwise>
					<textarea name="proflContent" id="proflContent" readonly>자기소개를 등록해보세요</textarea>
				</c:otherwise>
			</c:choose>
			<c:if test="${isOwner}">
				<span class="material-symbols-outlined prfConEdit"
					class="btn btn-default prfConEdit" data-toggle="modal"
					data-target="#modalContent" id="btnEdit"
					style="position: relative; bottom: 26px; left: 10px;"
					data-mbr-id="${prfVO.mbrId}"
					data-profl-content="${prfVO.proflContent}"> edit </span>
			</c:if>
		</div>

		<hr style="width: 1240px; position: relative; right: 15px;">
		<div id="introduce2">
			<span style="margin-left:330px;">
				<c:choose>
					<c:when test="${not empty prfVO.careerNm}">
						<span style="font-weight: 600; margin-right: 5px;">경력 :</span> ${prfVO.careerNm}
				    </c:when>
					<c:otherwise>
				       	<span style="font-weight: 600; margin-right: 5px;">경력 : </span>
				       	<span>신입</span>
					</c:otherwise>
				</c:choose>
				<c:if test="${isOwner}">
					<span class="material-symbols-outlined prfCarEdit"
						data-toggle="modal" data-target="#modalBusiness"
						style="position: relative; top: 30px; left: 600px;">edit</span>
				</c:if>
				<br>
			</span>
			<span style="margin-left:330px;">
				<span style="font-weight: 600;">업종 :</span>
				<c:choose>
					<c:when test="${not empty prfBusinessVOList}">
						<c:forEach var="businessVO" items="${prfBusinessVOList}">
							<span>&nbsp;${businessVO.tpbizNm}</span>
						</c:forEach>
					</c:when>
					<c:otherwise>
						<span>&nbsp;없음</span>
					</c:otherwise>
				</c:choose>
			</span>
		</div>
	</div>
<button id="topBtn" class="top-btn" style="display:none; position:fixed; bottom:20px; right:200px;">TOP ▲</button>		
	<div class="container">
		<div class="row">
			<div class="col-left">

				<!-- ------------------------------------------------------------------------------------------------ -->
				<div id="acbgBox">
					<h5 style="margin-bottom: 10px;">
					<img class="titleIcon" src="/resources/icon/학력.png">학력</h5>
					<c:if test="${isOwner}">
						<input class="tool edit" type="button" onclick="addAcbg()"
							id="addBtn" value="+추가" />
						<br>
					</c:if>
					<div id="acbg">
						<c:if test="${not empty prfAcbgVOList}">
							<c:forEach var="acbgVO" items="${prfAcbgVOList}">
								<!-- ///// 보여주는 부분 시작 ///////// -->
								<div>
									<div class="acbg-item">
										<!-- 제목과 아이콘을 flexbox로 우측 정렬 -->
										<div
											style="display: flex; justify-content: space-between; align-items: center;">
											<!-- 학력 번호 -->
											<input type="hidden" name="acbgNo" value="${acbgVO.acbgNo}" />
											<input type="hidden" name="prseSeCd"
												value="${acbgVO.prseSeCd}" />

											<!-- 회원 아이디 -->
											<input type="hidden" name="mbrId" value="${acbgVO.mbrId}" />

											<!-- 학교 명 -->
											<input type="text" class="edit-control title"
												name="acbgSchlNm" value="${acbgVO.acbgSchlNm}" readonly
												style="flex: 1;">

											<!-- Edit/Delete 아이콘
							private String acspSeCd;	// 전공계열 구분 코드
							private String acdeSeCd;	// 학위항목 구분 코드
							 -->
											<div style="display: flex; margin-right: -40px;">
												<c:if test="${isOwner}">
													<span data-acbg-no="${acbgVO.acbgNo}"
														data-mbr-id="${priVO.mbrId}"
														class="material-symbols-outlined edit editAcbgAjax">edit</span>
													<span data-acbg-no="${acbgVO.acbgNo}"
														data-mbr-id="${priVO.mbrId}"
														class="material-symbols-outlined edit delAcbgAjax">delete</span>
												</c:if>
											</div>
										</div>
										<c:choose>
											<c:when test="${acbgVO.prseSeCd == 'PRSE02'}">
												<!-- 전공 계열 -->
												<input type="text" class="edit-control acspSeCd"
													name="acspSeCd" value="${acbgVO.acspSeNm}" readonly>
												<br>
											</c:when>
											<c:otherwise>
												<!-- 전공명 및 학위 -->
												<input type="text" class="edit-control acbgMjrNm"
													name="acbgMjrNm"
													value="${acbgVO.acbgMjrNm}(${acbgVO.acdeSeNm})" readonly>
												<br>
											</c:otherwise>
										</c:choose>
										<!-- 입학년도 -->
										<input type="text" class="edit-control acbgMtcltnym"
											name="acbgMtcltnym"
											value="${acbgVO.acbgMtcltnym.substring(0, 4)}.${acbgVO.acbgMtcltnym.substring(4, 6)}"
											readonly>-&nbsp;
										<!-- 졸업년도 -->
										<input type="text" class="edit-control acbgGrdtnym"
											name="acbgGrdtnym"
											value="${acbgVO.acbgGrdtnym.substring(0, 4)}.${acbgVO.acbgGrdtnym.substring(4, 6)}"
											readonly> <br>
									</div>
								</div>
								<!-- ///// 보여주는 부분 끝 ///// -->
								<!-- ///// 변경하는 부분 시작 ///// -->
								<div id="editACForm_${acbgVO.acbgNo}" style="display: none;">
									<h5 style="width: 240px; margin-left: -40px;">학력 수정</h5>
									<br>
									<form name="edit_ACForm" id="edit_ACForm_${acbgVO.acbgNo}" action="/member/acbgUpdatePost" method="post">
										<input name="acbgNo" class="add" type="hidden" value="${acbgVO.acbgNo}" /> 
											<input name="mbrId" class="add" type="hidden" value="${priVO.mbrId}" />
										<div id="schoolBox">
											<div style="margin-right: 10px;">
												<label for="prseSeCd_${acbgVO.acbgNo}">학교구분<span
													class="required">*</span></label><br> <select name="prseSeCd"
													id="prseSeCd_${acbgVO.acbgNo}" class="prseSeCdSelect"
													required>
													<option value="" selected disabled>학교 구분 선택</option>
													<c:forEach var="prseSeCd" items="${prseList}">
														<option value="${prseSeCd.comCode}"
															<c:if test="${prseSeCd.comCode eq acbgVO.prseSeCd}">selected</c:if>>${prseSeCd.comCodeNm}
														</option>
													</c:forEach>
												</select>
											</div>
											<div>
												<label for="acbgSchlNm">학교<span class="required">*</span></label><br>
												<input id="acbgSchlNm" name="acbgSchlNm"
													value="${acbgVO.acbgSchlNm}" class="add" type="text"
													required /><br>
											</div>
										</div>
										<br>
										<!-- 학위 및 전공 필드 -->
										<div id="spcBox_${acbgVO.acbgNo}" class="spcBox">
											<div style="margin-right: 10px;">
												<label for="acdeSeCd_${acbgVO.acbgNo}">학위<span class="required">*</span>
												</label><br> <select name="acdeSeCd"
													id="acdeSeCd_${acbgVO.acbgNo}" class="prseSeCdSelect"
													required>
													<option value="" selected disabled>학위 구분 선택</option>
													<c:forEach var="acdeSeCd" items="${acdeList}">
														<option value="${acdeSeCd.comCode}"
															<c:if test="${acdeSeCd.comCode eq acbgVO.acdeSeCd}">selected</c:if>>${acdeSeCd.comCodeNm}</option>
													</c:forEach>
												</select>
											</div>
											<div>
												<label for="acbgMjrNm_${acbgVO.acbgNo}">전공
												<span class="required">*</span></label><br> <input
													id="acbgMjrNm_${acbgVO.acbgNo}" name="acbgMjrNm"
													value="${acbgVO.acbgMjrNm}" class="add" type="text"
													style="width: 360px;" required /><br>
											</div>
										</div>
										<!-- 전공계열 필드 (초기에는 숨김) -->
										<div id="acspSeCdBox_${acbgVO.acbgNo}"
											style="display: none; margin-right: 10px;">
											<label for="acspSeCd_${acbgVO.acbgNo}">전공계열<span class="required">*</span></label><br>
											<select name="acspSeCd" id="acspSeCd_${acbgVO.acbgNo}"
												class="acspSeCdSelect">
												<option value="" selected disabled>전공 계열 선택</option>
												<c:forEach var="acspSeCd" items="${acspList}">
													<option value="${acspSeCd.comCode}"
														<c:if test="${acspSeCd.comCode eq acbgVO.acspSeCd}">selected</c:if>>${acspSeCd.comCodeNm}</option>
												</c:forEach>
											</select>
										</div>
										<br> <label for="acbgMtcltnym">재학 기간<span
											class="required">*</span></label>
										<div style="display: flex; width: 110px">
											<input name="acbgMtcltnym" id="acbgMtcltnym" class="add"
												type="month"
												value="${acbgVO.acbgMtcltnym.substring(0, 4)}-${acbgVO.acbgMtcltnym.substring(4, 6)}"
												required />
											<p style="margin: 0px 10px 0px 10px;">-</p>
											<input name="acbgGrdtnym" id="acbgGrdtnym" type="month"
												class="add"
												value="${acbgVO.acbgGrdtnym.substring(0, 4)}-${acbgVO.acbgGrdtnym.substring(4, 6)}"
												placeholder="졸업연월" required /><br>
										</div>
										<div class="viewEnd">
											<input data-acbg-no="${acbgVO.acbgNo}"
												data-mbr-id="${priVO.mbrId}" class="cancelAcbgAjax"
												type="button" value="취소" /> 
												<input type="submit" class="save acbgSave" value="저장" />
										</div>
										<sec:csrfInput />
									</form>
								</div>
								<!-- ///// 변경하는 부분 끝 ///// -->
							</c:forEach>
						</c:if>
					</div>
				</div>

				<!-- --------------------------------------------------------------------------------------------------------------- -->
				<div id="careerBox">
					<h5 style="margin-bottom: 10px;"><img class="titleIcon" src="/resources/icon/경력.png">경력</h5>
					<c:if test="${isOwner}">
						<input class="tool edit" type="button" onclick="addCareer()"
							id="addBtn" value="+추가" />
						<br>
					</c:if>
					<div id="career">
						<c:if test="${not empty prfCareerVOList}">
							<c:forEach var="careerVO" items="${prfCareerVOList}">

								<!-- ///// 보여주는 부분 시작 ///////// -->
								<div class="career-item"
									style="border-bottom: 1px solid #ccc; padding-bottom: 10px; margin-bottom: 20px;">
									<!-- 제목과 아이콘을 flexbox로 우측 정렬 -->
									<div
										style="display: flex; justify-content: space-between; align-items: center;">
										<!-- 경력 번호 -->
										<input type="hidden" name="careerNo"
											value="${careerVO.careerNo}" />
										<!-- 회원 아이디 -->
										<input type="hidden" name="mbrId" value="${careerVO.mbrId}" />

										<!-- 경력 제목 -->
										<input type="text" class="edit-control title" name="careerNm"
											value="${careerVO.careerNm}" readonly style="flex: 1;">

										<!-- Edit/Delete 아이콘 -->
										<div style="display: flex; margin-right: -40px;">
											<c:if test="${isOwner}">
												<span data-career-no="${careerVO.careerNo}"
													data-mbr-id="${priVO.mbrId}"
													class="material-symbols-outlined edit editCareerAjax">edit</span>
												<span data-career-no="${careerVO.careerNo}"
													data-mbr-id="${priVO.mbrId}"
													class="material-symbols-outlined edit delCareerAjax">delete</span>
											</c:if>
										</div>
									</div>

									<!-- 기업명 -->
									<input type="text" class="edit-control careerEnt"
										name="careerEnt" value="${careerVO.careerEnt}" readonly
										required><br>

									<!-- 입사년도 -->
									<input type="text" class="edit-control careerBegYm"
										name="careerBegYm"
										value="${careerVO.careerBegYm.substring(0, 4)}.${careerVO.careerBegYm.substring(4, 6)}"
										readonly required>-&nbsp;
									<!-- 퇴사년도가 없으면 "현재"로 표시 -->
									<c:choose>
										<c:when test="${empty careerVO.careerEndYm}">
											<input type="text" class="edit-control careerEndYm"
												value="현재" name="careerEndYm" readonly>
										</c:when>
										<c:otherwise>
											<input type="text" class="edit-control careerEndYm"
												name="careerEndYm"
												value="${careerVO.careerEndYm.substring(0, 4)}.${careerVO.careerEndYm.substring(4, 6)}"
												readonly>
										</c:otherwise>
									</c:choose>
									<br>
								</div>
								<!-- ///// 보여주는 부분 끝 ///////// -->
								<!-- ///// 변경하는 부분 시작 ///////// -->
								<div id="editCARForm_${careerVO.careerNo}" style="display: none;">
									<h5 style="width: 240px; margin-left: -40px;">경력 수정</h5>
									<br>
									<form name="edit_Form" id="edit_Form_${careerVO.careerNo}" action="/member/careerUpdatePost" method="post">
										<input name="careerNo" class="del" type="hidden"
											value="${careerVO.careerNo}" /> <input name="mbrId"
											class="add" type="hidden" value="${priVO.mbrId}" required />
										<div class="formsize">
											<label for="careerNm">역할<span class="required">*</span></label>
											<input name="careerNm" id="careerNm" class="add carInp"
												type="text" value="${careerVO.careerNm}" required /><br>
											<label for="careerEnt">기업명<span class="required"
												required>*</span></label> <input id="careerEnt" name="careerEnt"
												class="add carInp" type="text" value="${careerVO.careerEnt}"
												required /><br> <label for="careerBegYm">재직기간<span
												class="required">*</span></label>
											<div style="display: flex; width: 110px">
												<input name="careerBegYm" id="careerBegYm" class="add"
													type="month"
													value="${careerVO.careerBegYm.substring(0, 4)}-${careerVO.careerBegYm.substring(4, 6)}"
													required required />
												<p style="margin: 0px 10px 0px 10px;">-</p>
												<input name="careerEndYm" id="careerEndYm" type="month"
													class="add"
													value="${careerVO.careerEndYm.substring(0, 4)}-${careerVO.careerEndYm.substring(4, 6)}" /><br>
											</div>
											<br>
										</div>
										<div class="viewEnd">
											<input data-career-no="${careerVO.careerNo}"
												data-mbr-id="${priVO.mbrId}" class="cancelCareerAjax"
												type="button" value="취소" /> 
												<input type="submit" class="save careerSave" value="저장" />
										</div>
										<sec:csrfInput />
									</form>
								</div>
								<!-- ///// 변경하는 부분 끝 ///////// -->

							</c:forEach>
						</c:if>
					</div>
				</div>
				<!-- ----------------------------------------------------------------------------------------------- -->

				<div id="actBox">
					<h5 style="margin-bottom: 10px;"><img class="titleIcon" src="/resources/icon/활동.png">활동</h5>
					<c:if test="${isOwner}">
						<input class="tool edit" type="button" onclick="addAct()"
							id="addBtn" value="+추가" />
						<br>
					</c:if>
					<div id="act">
						<c:if test="${not empty prfActVOList}">
							<c:forEach var="actVO" items="${prfActVOList}">
								<div class="act-item">
									<!-- 제목과 아이콘을 flexbox로 우측 정렬 -->
									<div
										style="display: flex; justify-content: space-between; align-items: center;">
										<!-- 활동 번호 -->
										<input type="hidden" name="actNo" value="${actVO.actNo}" />

										<!-- 회원 아이디 -->
										<input type="hidden" name="mbrId" value="${actVO.mbrId}" />

										<!-- 활동 명 -->
										<input type="text" class="edit-control title" name="actNm"
											value="${actVO.actNm}" readonly style="flex: 1;" required>

										<!-- Edit/Delete 아이콘 -->
										<div style="display: flex; margin-right: -40px;">
											<c:if test="${isOwner}">
												<span data-act-no="${actVO.actNo}"
													data-mbr-id="${priVO.mbrId}"
													class="material-symbols-outlined edit updateActAjax">edit</span>
												<span data-act-no="${actVO.actNo}"
													data-mbr-id="${priVO.mbrId}"
													class="material-symbols-outlined edit DelActAjax">delete</span>
											</c:if>
										</div>
									</div>

									<!-- 주최기관 -->
									<input type="text" class="edit-control actAuspcengn"
										name="actAuspcengn" value="${actVO.actAuspcengn}" readonly
										required><br>

									<!-- 시작일자 -->
									<input type="text" class="edit-control actBeginYm"
										name="actBeginYm"
										value="${actVO.actBeginYm.substring(0, 4)}.${actVO.actBeginYm.substring(4, 6)}"
										readonly required>-&nbsp;
									<!-- 종료일자 -->
									<input type="text" class="edit-control actEndYm"
										name="actEndYm"
										value="${actVO.actEndYm.substring(0, 4)}.${actVO.actEndYm.substring(4, 6)}"
										readonly required> <br>
									<!-- 활동 설명 -->
									<textarea class="edit-control actNc" name="actNc" readonly>${actVO.actNc}</textarea>
									<br>
								</div>
								<!-- 보여주는 부분 끝 -->
								<!-- 변경되는 부분 시작 -->
								<div id="editACTForm_${actVO.actNo}" style="display: none;">
									<h5 style="width: 240px; margin-left: -40px;">활동 수정</h5>
									<br>
									<form name="edit_ACTForm" id="edit_ACTForm_${actVO.actNo}" class="edit_ACTForm" action="/member/actUpdatePost" method="post">
										<input name="actNo" class="del" type="hidden"
											value="${actVO.actNo}" /> <input name="mbrId" class="add"
											type="hidden" value="${priVO.mbrId}" /> <label for="actNm">활동명<span
											class="required">*</span></label> <input name="actNm" id="actNm"
											class="add carInp" type="text" value="${actVO.actNm}"
											required /><br> <label for="actAuspcengn">주최기관<span
											class="required">*</span></label> <input name="actAuspcengn"
											id="actAuspcengn" class="add carInp" type="text"
											value="${actVO.actAuspcengn}" required /><br> <label
											for="actBeginYm">활동 일자<span class="required">*</span></label>
										<div style="display: flex; width: 110px">
											<input name="actBeginYm" id="actBeginYm" class="add"
												type="month"
												value="${actVO.actBeginYm.substring(0, 4)}-${actVO.actBeginYm.substring(4, 6)}"
												required />
											<p style="margin: 0px 10px 0px 10px;">-</p>
											<input name="actEndYm" id="actEndYm" type="month" class="add"
												value="${actVO.actEndYm.substring(0, 4)}-${actVO.actEndYm.substring(4, 6)}"
												required /><br>
										</div>
										<br>
										<div>
											<label for="actNc">간단 활동 설명<span class="required">*</span></label><br>
											<textarea rows="2" cols="66" id="actNc" name="actNc">${actVO.actNc}</textarea>
										</div>
										<div class="viewEnd">
											<input data-act-no="${actVO.actNo}"
												data-mbr-id="${priVO.mbrId}" class="cancelActAjax"
												type="button" value="취소" /> 
												<input type="submit" class="save actSave" value="저장" />
										</div>
										<sec:csrfInput />
									</form>
								</div>
								<!-- 변경되는 부분 끝 -->
							</c:forEach>
						</c:if>
					</div>
				</div>
			</div>
			<!-- ////////////////////////////////////////////////////////////////////////////////////// -->
			<div class="col-right">
				<!-- 오른쪽 영역 시작 -->
				<!-- ////////////////////////////////////////////////////////////////////////////////////// -->
				<div id="skillBox">
					<h5 style="margin-bottom: 10px;"><img class="titleIcon" src="/resources/icon/스킬.png">스킬</h5>
					<c:if test="${isOwner}">
						<input class="tool2 edit" type="button" id="addSkBtn" value="+추가" />
					</c:if>
					<!-- 보여주는 부분 시작 -->
					<div id="skillForm">
						<form name="edit_SKForm" id="edit_SKForm"
							action="/member/skillAdd" method="post">
							<div id="realSkillBox" style="padding: -2px 15px;">
								<input type="hidden" name="mbrId" value="${skillVO.mbrId}"
									hidden="hidden" />
								<c:if test="${not empty skillVOList}">
									<c:forEach var="skillVO" items="${skillVOList}">
										<span class="selected-skill" id="skNm"
											data-code-no="${skillVO.skCd}">${skillVO.skNm}</span>
									</c:forEach>
								</c:if>
							</div>
							<!-- 								<hr style="width: 320px;"/> -->
							<!-- 보여주는 부분 끝 -->
							<!-- 추가하는 부분 시작 -->
							<div class="conBox addSkBox" style="display: none;">

								<!-- 
										from
										
										<input type="text" name="skill" value="SK0004">
										<input type="text" name="skill" value="SK0011">
										
										to
										
										private String[] skill; 
										 -->
								<div class="inputForm">
									<br>
									<div class="row idForm">
										<div class="form-group width-xl">
											<label for="skillSearch" id="reg1label">스킬 검색</label> <span
												class="material-symbols-outlined" id="searic">search</span>
											<input type="text" class="form-control"
												placeholder="툴/직무역량/소프트스킬을 입력해주세요." name="skillSearch"
												id="skillSearch" value="" />
										</div>
									</div>
									<div class="row idForm ">
										<div class="form-group width-xl search-results scBox"></div>
									</div>
									<div class="row idForm">
										<div class="form-group width-xl ">
											<label for="" id="reg1label">나의 스킬</label>
											<div class="selectedSkills" id="skill-select-box"></div>
										</div>
									</div>
									<div class="viewskEnd">
										<button type="reset" class="resetBtn">취소</button>
										<button type="button" class="submitBtn">저장</button>
									</div>
								</div>
							</div>
							<sec:csrfInput />
						</form>
					</div>
					<!-- 추가하는 부분 끝 -->
				</div>

				<!-- ////////////////////////////////////////////////////////////////////////////////////// -->
				<div id="crtfctBox">
					<h5 style="margin-bottom: 10px;"><img class="titleIcon" src="/resources/icon/자격.png">자격</h5>
					<c:if test="${isOwner}">
						<input class="tool2 edit" type="button" onclick="addCrtfct()"
							id="addBtn" value="+추가" />
					</c:if>
					<div id="crtfct">
						<c:if test="${not empty prfCrtfctVOList}">
							<c:forEach var="crtfctVO" items="${prfCrtfctVOList}">
								<div class="crtfct-item">
									<!-- 자격 번호 -->
									<input type="hidden" name="crtfctNo"
										value="${crtfctVO.crtfctNo}" />
									<!-- 회원 아이디 -->
									<input type="hidden" name="mbrId" value="${crtfctVO.mbrId}" />

									<!-- 자격증 명 -->
									<input type="text" class="edit-control title" name="crtfctNm"
										value="${crtfctVO.crtfctNm}" readonly style="flex: 1;"
										required>

									<!-- Edit/Delete 아이콘 -->
									<div style="display: flex; margin-right: -40px;">
										<c:if test="${isOwner}">
											<span data-crtfct-no="${crtfctVO.crtfctNo}"
												data-mbr-id="${priVO.mbrId}"
												class="material-symbols-outlined edit updateCrtfctAjax sedit">edit</span>
											<span data-crtfct-no="${crtfctVO.crtfctNo}"
												data-mbr-id="${priVO.mbrId}"
												class="material-symbols-outlined edit DelCrtAjax sdel">delete</span>
										</c:if>
									</div>

									<!-- 주최기관 -->
									<input type="text" class="edit-control crtfctPblcnoffic"
										name="crtfctPblcnoffic" value="${crtfctVO.crtfctPblcnoffic}"
										readonly required><br>

									<!-- 취득연월 -->
									<input type="text" class="edit-control crtfctAcqsDate"
										name="crtfctAcqsDate"
										value="${crtfctVO.crtfctAcqsDate.substring(0, 4)}.${crtfctVO.crtfctAcqsDate.substring(4, 6)}&nbsp;&nbsp;취득"
										readonly required>
								</div>
								<!-- 보여주는 부분 끝 -->
								<!-- 변경되는 부분 시작 -->
								<div id="editCRTForm_${crtfctVO.crtfctNo}" style="display: none;">
									<h5 style="width: 240px;">자격증 수정</h5>
									<br>
									<form name="edit_CRTForm" id="edit_CRTForm_${crtfctVO.crtfctNo}" action="/member/crtfctUpdatePost" method="post">
										<input name="crtfctNo" class="del" id="crtfctNo" type="hidden"
											value="${crtfctVO.crtfctNo}" /> <input name="mbrId"
											class="add" id="mbrId" type="hidden" value="${priVO.mbrId}" />

										<div style="margin-left: 20px;">
											<label class="slabel" for="crtfctNm">자격증명 <span
												class="required">*</span></label> <input name="crtfctNm"
												class="add crtInp" type="text" value="${crtfctVO.crtfctNm}" /><br>
											<br> <label class="slabel" for="crtfctPblcnoffic"
												required>발행처<span class="required">*</span></label> <input
												name="crtfctPblcnoffic" class="add crtInp" type="text"
												value="${crtfctVO.crtfctPblcnoffic}" required /><br> <br>
											<label class="slabel" for="crtfctAcqsDate">취득 일자<span
												class="required">*</span></label>
											<div style="display: flex; width: 110px">
												<input name="crtfctAcqsDate" id="crtfctAcqsDate" class="add"
													type="month"
													value="${crtfctVO.crtfctAcqsDate.substring(0, 4)}-${crtfctVO.crtfctAcqsDate.substring(4, 6)}"
													required />
											</div>
										</div>
										<br>
										<div class="viewEnd2">
											<input data-crtfct-no="${crtfctVO.crtfctNo}"
												data-mbr-id="${priVO.mbrId}" class="cancelCrtfctAjax"
												type="button" value="취소" /> 
												<input type="submit" class="save saveCrtfct" value="저장" />
										</div>
										<sec:csrfInput />
									</form>
								</div>
								<!-- 변경되는 부분 끝 -->
							</c:forEach>
						</c:if>
					</div>
				</div>
				<!-- ////////////////////////////////////////////////////////////////////////////////////// -->
				<div id="wnpzBox">
					<h5 style="margin-bottom: 10px;"><img class="titleIcon" src="/resources/icon/수상.png">수상</h5>
					<c:if test="${isOwner}">
						<input class="tool2 edit" type="button" onclick="addWnpz()"
							id="addBtn" value="+추가" />
						<br>
					</c:if>
					<div id="wnpz">
						<c:if test="${not empty prfWnpzVOList}">
							<c:forEach var="wnpzVO" items="${prfWnpzVOList}">
								<div class="wnpz-item">
									<!-- 제목과 아이콘을 flexbox로 우측 정렬 -->
									<div
										style="display: flex; justify-content: space-between; align-items: center;">
										<!-- 수상 번호 -->
										<input type="hidden" id="wnpzNo" name="wnpzNo"
											value="${wnpzVO.wnpzNo}" />

										<!-- 회원 아이디 -->
										<input type="hidden" id="mbrId" name="mbrId"
											value="${wnpzVO.mbrId}" />

										<!-- 수상 명 -->
										<input type="text" class="edit-control title"
											name="wnpzCntstNm" id="wnpzCntstNm"
											value="${wnpzVO.wnpzCntstNm}" readonly style="flex: 1;"
											required>

										<!-- Edit/Delete 아이콘 -->
										<div style="display: flex;">
											<c:if test="${isOwner}">
												<span data-wnpz-no="${wnpzVO.wnpzNo}"
													data-mbr-id="${priVO.mbrId}"
													class="material-symbols-outlined edit updateWnpzAjax sedit"
													style="margin-left: -13px; margin-top: 0px;">edit</span>
												<span data-wnpz-no="${wnpzVO.wnpzNo}"
													data-mbr-id="${priVO.mbrId}"
													class="material-symbols-outlined edit DelWnpzAjax sdel"
													style="margin-top: 0px;">delete</span>
											</c:if>
										</div>
									</div>

									<!-- 주최기관 -->
									<input type="text" class="edit-control wnpzAuspcengn"
										id="wnpzAuspcengn" name="wnpzAuspcengn"
										value="${wnpzVO.wnpzAuspcengn}" readonly required><br>

									<!-- 취득년도 -->
									<input type="text" class="edit-control wnpzPssrpYm"
										id="wnpzPssrpYm" name="wnpzPssrpYm"
										value="${wnpzVO.wnpzPssrpYm.substring(0, 4)}.${wnpzVO.wnpzPssrpYm.substring(4, 6)}&nbsp;&nbsp;수상"
										readonly> <br>
								</div>
								<!-- 보여주는 부분 끝 -->
								<!-- 변경하는 부분 시작  -->
								<div id="editWNPZForm_${wnpzVO.wnpzNo}" style="display: none;">
									<h5 style="width: 240px;">수상 수정</h5>
									<br>
									<form name="edit_WnpzForm" id="edit_WnpzForm_${wnpzVO.wnpzNo}" action="/member/wnpzUpdatePost" method="post">
										<input name="wnpzNo" class="del" type="hidden"
											value="${wnpzVO.wnpzNo}" /> <input name="mbrId" class="add"
											type="hidden" value="${priVO.mbrId}" />
										<div style="margin-left: 20px;">
											<label for="wnpzCntstNm">수상명<span class="required">*</span></label>
											<input name="wnpzCntstNm" id="wnpzCntstNm" class="wnzInp"
												type="text" value="${wnpzVO.wnpzCntstNm}" required /><br>
											<br> <label for="wnpzAuspcengn">주최기관 <span
												class="required">*</span></label> <input name="wnpzAuspcengn"
												id="wnpzAuspcengn" class="wnzInp" type="text"
												value="${wnpzVO.wnpzAuspcengn}" /><br> <br> <label
												for="wnpzPssrpYm">취득연월<span class="required">*</span></label>
											<div>
												<input name="wnpzPssrpYm" id="wnpzPssrpYm" class="add"
													type="month"
													value="${wnpzVO.wnpzPssrpYm.substring(0, 4)}-${wnpzVO.wnpzPssrpYm.substring(4, 6)}"
													required />
												<p style="margin: 0px 10px 0px 10px;">
											</div>
										</div>
										<br>
										<div class="viewEnd2">
											<input data-wnpz-no="${wnpzVO.wnpzNo}"
												data-mbr-id="${priVO.mbrId}" class="cancelWnpzAjax"
												type="button" value="취소" />
												<input type="submit" class="save wnpzSave" value="저장" />
										</div>
										<sec:csrfInput />
									</form>
								</div>
								<!-- 변경하는 부분 부분 끝 -->
							</c:forEach>
						</c:if>
					</div>
				</div>
			</div>
		</div>
	</div>
	<!-- 자기소개 수정 모달 ///////////////////////////////// -->
	<div class="modal fade" id="modalContent">
		<div class="modal-dialog" style="margin-top: 270px;">
			<div class="modal-content">
				<form id="EditITForm"
					action="/member/prfUpdateAjax?${_csrf.parameterName}=${_csrf.token}"
					method="post">
					<!-- form 시작 -->
					<div class="modal-header">
						<span id="title" style="color: #232323;">자기 소개 변경</span>
					</div>
					<div class="modal-body">
						<div>
							<p style="display: flex; flex-direction: column;">
								<label style="font-weight: 500; font-size: 14px;">자기소개</label>
								<textarea name="modalCont" id="modalCont"
									style="overflow: auto;"></textarea>

								<input type="hidden" name="mbrId" id="modalMbrId" />

							</p>
							<!-- 글자 수 카운트를 표시할 영역 -->
							<div style="display: flex;">
								<p id="countp">
									글자 수&nbsp;(&nbsp;<span id="charCount">0</span>&nbsp;/&nbsp;100&nbsp;)
								</p>
								<p id="warning">글자 수가 100자를 넘었습니다!</p>
							</div>
						</div>
					</div>
					<div id="control">
						<button type="button" id="close" class="EditCont"
							data-dismiss="modal">취소</button>
						<button type="submit" id="submitCont" class="UpdateCont save">저장</button>
					</div>
					<sec:csrfInput />
				</form>
			</div>
			<!-- /.modal-content -->
		</div>
		<!-- /.modal-dialog -->
	</div>
	<!-- /.modal -->

	<!-- ///////////////////////////////// 업종 선택 모달 ///////////////////////////////// -->
	<div class="modal fade" id="modalBusiness">
		<div class="modal-dialog"
			style="margin-top: 270px; margin-right: 640px;">
			<div class="modal-business">
				<form id="EditForm" action="/member/BusinessAdd" method="post">
					<!-- form 시작 -->
					<div class="modal-header">
						<span id="title" style="color: #232323;">업종 선택</span>
					</div>
					<div class="modal-body">
						<div id="chkBox">
							<input type="hidden" name="mbrId" value="${priVO.mbrId}">
							<c:forEach var="businessVO" items="${inseVOList}">
								<label id="busiNm"> <input type="checkbox"
									class="resume-check busiChk" name="business"
									id="busiChk${businessVO.comCode}" value="${businessVO.comCode}"
									<c:forEach var="selectedVO" items="${prfBusinessVOList}">
                    <c:if test="${selectedVO.tpbizSeCd eq businessVO.comCode}">checked</c:if>
                  </c:forEach>>${businessVO.comCodeNm}
								</label>
								<br>
							</c:forEach>
						</div>
					</div>
					<div id="controlBusi">
						<button type="button" id="close" class="EditBusi"
							data-dismiss="modal">취소</button>
						<button type="submit" id="busiSave" class="UpdateBusi">저장</button>
					</div>
					<sec:csrfInput />
				</form>
			</div>
			<!-- /.modal-content -->
		</div>
		<!-- /.modal-dialog -->
	</div>
	<!-- /.modal -->



<!-- /////////////////////////////////스카우트 제안 모달 시작///////////////////////////////// -->
<div id="scoutModal" class="modal1" style="display: none; z-index: 999;">
    <div class="modal-content1">
            <div style="display: flex;justify-content: space-between;margin-bottom: 30px;
            background: linear-gradient(to right, #2CCFC3, #24D59E);height: 80px;border-top-left-radius: 8px; border-top-right-radius: 8px; ">
            	<h2>스카우트 제안</h2>
            	<span class="close1">&times;</span>
          	</div>
        <form id="scoutForm" enctype="multipart/form-data">
            <div class="scout-div">
                <input type="text" id="title1" name="title" placeholder="제안 시 해당 인재에게 보여지므로, 신중히 작성해주세요.">
                <input type="hidden" id="mbrIdForm" name="mbrId">
                <input type="hidden" id="mbrEmlForm" name="mbrEml">
                <c:if test="${prc ne 'anonymousUser'}">
	                <input type="hidden" id="entId" name="entId" value="${prc.username}">
                </c:if>
            </div>
            
            <div class="scout-div">
                <label for="jobPost" class="scout-title">&nbsp;&nbsp;&nbsp;스카우트 제안 공고 </label>
                <select id="jobPost" name="jobPost">
                
                    
                    <!-- 공고 리스트를 JSP에서 동적으로 추가 -->
                </select>
            </div>

            <div class="scout-div">
                <label for="content" class="scout-title"><span style="color: red;">*</span> 스카우트 제안 내용</label>
                <textarea id="content" name="content" placeholder="해당 인재에게 전달하고자 하는 주요 제안 정보를 작성해주세요.&#13;&#10;예시) 회사 정보, 직급 및 직책, 연봉 등"></textarea>
            </div>

            <div class="scout-div">
                <label for="file" class="scout-title">&nbsp;&nbsp;&nbsp;스카우트 제안 첨부파일</label>
                <input type="file" id="file" name="file">
            </div>

            <div style="display: flex; justify-content: space-evenly; margin-top: 30px;">
                <button type="button" id="cancel-btn">취소</button>
                <button type="submit" id="submit-btn">제안</button>
            </div>
        </form>
    </div>
</div>	
<!-- /////////////////////////////////스카우트 제안 모달 끝///////////////////////////////// -->
</div>
</body>