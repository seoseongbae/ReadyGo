<%@ page language="java" contentType="text/html;charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="sec"
	uri="http://www.springframework.org/security/tags"%>
<script type="text/javascript" src="/resources/js/jquery.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
<meta charset="utf-8">
<meta name="viewport"
	content="width=device-width, initial-scale=1, shrink-to-fit=no">

<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/gh/Project-Noonnu/noonfonts_2107@1.1/Pretendard.css">
<!-- 검색바 css -->
<link rel="stylesheet"
	href="<%=request.getContextPath()%>/resources/css/common/search.css" />
<link rel="stylesheet"
	href="/resources/css/alarm.css" />
<link rel="stylesheet" href="<%=request.getContextPath()%>/resources/css/alert.css" />
<title>메인 헤더</title>

<!-- Bootstrap core CSS -->
     <link href="../../resources/css/bootstrap.min.css" rel="stylesheet"> 
     <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
<!-- Additional CSS Files -->
<!--     <link rel="stylesheet" href="../resources/assets/css/fontawesome.css"> -->
<link rel="stylesheet"
	href="../../resources/assets/css/templatemo-cyborg-gaming.css">
<!--     <link rel="stylesheet" href="../resources/assets/css/owl.css"> -->
<!--     <link rel="stylesheet" href="../resources/assets/css/animate.css"> -->
<link rel="stylesheet"
	href="https://unpkg.com/swiper@7/swiper-bundle.min.css" />
<link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@24,200,0,0&icon_names=delete" />
<sec:authorize access="isAuthenticated()">
	<sec:authentication property="principal.memVO" var="memVO1" />
</sec:authorize>
<script src="https://cdn.jsdelivr.net/npm/sockjs-client@1/dist/sockjs.min.js"></script><!-- 웹소켓 -->
<script>
$(function() {
	$.ajax({
        url: '/notification/getAlramCnt',  // 서버에서 알림 목록을 가져오는 API
        method: 'GET',
        dataType: 'json',
        success: function(result) {
            var notificationCount = result;
	
            // 알림 갯수 표시
            if (notificationCount > 0) {
            	$('#notificationBadge').show().text(notificationCount);
            } else {
            	$('#notificationBadge').hide().text(0);
            }
        },
        error: function() {
            console.error('알림 갯수를 가져오는 데 실패했습니다.');
        }
    });
	
	
    $('#modalPbanc').on('hidden.bs.modal', function () {
        $(this).find('ul#pbancList').empty(); 
        $('#pbancCount').text(''); 
    });
    
    // 모달 닫기 버튼 클릭 이벤트 확인
    $('.close.cbt').on('click', function() {
        $('#modalPbanc').modal('hide');
    });
    
	var mbrId = "${memVO1.mbrId}";
	var socket = null;

    if(mbrId){
        connectWs();
    }


function connectWs(){
    console.log("WebSocket 연결 시작");
    var ws = new SockJS("/alarm");
    ws.onopen = function() {
    };
    ws.onmessage = function(event) {
        let $socketAlert = $('#socketAlert');
        
        // 메시지 내용 업데이트
        $socketAlert.html(event.data);

        // 알림 표시 (CSS 클래스를 통한 애니메이션 효과)
        $socketAlert.removeClass('hidden').addClass('visible');
        
        // 3초 후 알림 숨기기
        setTimeout(function(){
            $socketAlert.removeClass('visible').addClass('hidden');
        }, 3000);
        // 배지 갱신 로직
        updateNotificationBadgeDisplay();
    };

    ws.onclose = function() {
    };
    socket = ws;  // 웹소켓을 저장
}
// 알림 배지 갱신 (실시간으로 서버에서 가져옴)
function refreshNotificationCount() {
    $.ajax({
        url: '/notification/list',  // 서버에서 알림 목록을 가져오는 API
        method: 'GET',
        dataType: 'json',
        success: function(response) {
            var notificationCount = response.length;

            // 알림 갯수 표시
            if (notificationCount > 0) {
                $('#notificationBadge').show().text(notificationCount);
            } else {
            	$('#notificationBadge').hide().text(0);  // 알림이 없으면 숨기기
            }
        },
        error: function() {
            console.error('알림 갯수를 갱신하는 데 실패했습니다.');
        }
    });
}
function updateNotificationBadgeDisplay() {
    var badge = $('#notificationBadge');

    // 배지의 현재 값 가져오기 (숫자로 변환)
    var currentCount = parseInt(badge.text()) || 0;

    // 알림이 왔을 때마다 배지 숫자를 증가
    currentCount += 1;
    badge.show().text(currentCount); // 갱신된 숫자로 표시
}
$('#input_text').on('click',function() {
		console.log("mbrId : " + mbrId);
		// 로그인 되어 있는 지 확인
	    if (!mbrId) {
	        return; // AJAX 요청을 수행하지 않고 함수 종료
	    }
	 	// 자동완성이 보일 경우 최근검색기록을 숨김
	    if ($('.SearchContent').is(':visible')) {
	        return; // 자동완성이 보이는 경우 아무 작업도 하지 않음
	    }
	    loadSearchHistory(mbrId);
	});
	
	//검색 기록 불러오기 함수
	function loadSearchHistory(mbrId) {
	    $.ajax({
	        url: '/member/searchHistory',
	        method: 'GET',
	        data: {
	            mbrId: mbrId
	        },
	        success: function(response) {
	            // 검색 기록 표시
	            $('.SearchHistory tbody').empty().show();
	            $.each(response, function(index, item) {
	                const date = new Date(item.searchDate);
	                const formattedDate = String(date.getMonth() + 1).padStart(2, '0')
	                    + '/' + String(date.getDate()).padStart(2, '0');
	                $('.SearchHistory tbody').append(
	                    '<tr>' +
	                    '<td class="icon"><div class="customIcon"><i class="fa fa-search"></div></i></td>' +
	                    '<td class="record">' + item.searchNm + '</td>' +
	                    '<td class="date">' + formattedDate + '</td>' +
	                    '<td class="delete"><button class="btn-close" data-value="' + item.searchNo + '"></button></td>' +
	                    '</tr>'
	                );
	            });
	            $('.SearchHistory').show();
	        },
	        error: function() {
	            console.error('검색 기록을 불러오는 데 실패했습니다.');
	        }
	    });
	}

	//     검색 기록을 클릭했을 때 입력 필드에 값 넣기
	$(document).on('click', '.SearchHistory td', function() {
		if ($(this).index() === 1) {
			$('#input_text').val($(this).text());
			console.log($(this).text());
			$('.SearchHistory').hide();
			 // mbrId가 null인 경우 폼을 즉시 제출
	        if (mbrId === null || mbrId === "") {
	            $('#search').submit(); // 폼 제출
	            return; // 함수 종료
	        }
			 
	     // 폼 데이터 수집
	        var formData = {
	            mbrId: mbrId,
	            searchNm: $('#input_text').val()
	        };
	
	        // AJAX 요청
	        $.ajax({
	            url: '/member/searchInsert',
	            method: 'GET',
	            data: formData,
	            success: function(response) {
	           	 if (response === 1) { // result 값이 1일 경우
	                    console.log('AJAX 요청 성공');
	                    $('#search').submit(); // 폼 제출
	                } else {
	                    console.log('AJAX 요청 실패');
	                    // 실패 처리 로직
	                }
	            }
	        });
		};
	});
	
	//최근검색기록 창닫기
	$('.close-div').on('click',function(event) {
		event.preventDefault();
		 $('.SearchHistory').hide();
	});
	
	//검색기록 저장
	 $('#search').on('keypress', function(event) {
		// 엔터 키가 눌렸을 때
	    if (event.which === 13) {
	        event.preventDefault(); // 기본 폼 제출 방지
		 
	     // mbrId가 null인 경우 폼을 즉시 제출
	        if (mbrId === null || mbrId === "") {
	            $('#search').submit(); // 폼 제출
	            return; // 함수 종료
	        }
	     
         // 폼 데이터 수집
         var formData = {
             mbrId: mbrId,
             searchNm: $('#input_text').val()
         };

         // AJAX 요청
         $.ajax({
             url: '/member/searchInsert',
             method: 'GET',
             data: formData,
             success: function(response) {
            	 if (response === 1) { // result 값이 1일 경우
                     console.log('AJAX 요청 성공');
                     $('#search').submit(); // 폼 제출
                 } else {
                     console.log('AJAX 요청 실패');
                     // 실패 처리 로직
                 }
             }
         });
	    }
 	});

	//검색기록 선택 삭제
	$(document).on('click', '.btn-close', function(event) {
		event.preventDefault();
		
		let searchNo = $(this).data('value');
		console.log(searchNo);
		// AJAX 요청으로 검색 기록 삭제하기
		$.ajax({
			url : '/member/searchDelete',
			method : 'GET',
			 data: {
				 searchNo: searchNo, // 삭제할 검색 기록의 번호
		    },
			success : function(response) {
				if (response === 1) { // result 값이 1일 경우
                    console.log('AJAX 요청 성공');
                    $(event.target).closest('tr').remove();
                } else {
                	console.error('삭제 실패: ', response.message); // 서버에서 실패 메시지 반환 시 처리
                }
			}
		});
		
	});
	//검색 기록 전체 삭제
	$(document).on('click', '.close-all', function(event) {
			event.preventDefault();
			
			console.log(mbrId);
			// AJAX 요청으로 검색 기록 삭제하기
			$.ajax({
				url : '/member/searchDeleteAll',
				method : 'GET',
				 data: {
					 mbrId: mbrId, // 삭제할 검색 기록의 회원아이디
			    },
				success : function(response) {
					if (response > 0) { // result 값이 1일 경우
	                    console.log('AJAX 요청 성공');
	                    $('.SearchHistory tbody').empty();
	                } else {
	                	console.error('삭제 실패: ', response.message); // 서버에서 실패 메시지 반환 시 처리
	                }
				},
				error : function() {
					console.error('검색 기록 삭제 실패');
	
				}
			});
			
		});
	
	//자동 완성
	document.cookie = "safeCookie1=foo; SameSite=Lax";
	document.cookie = "safeCookie2=foo";
	document.cookie = "crossCookie=bar; SameSite=None; Secure";
	$('#input_text').keyup(function() {
		$('.SearchHistory').hide();
						
	const query = $('#input_text').val();

	if (query.length === 0) {
		$('.SearchContent').empty().hide(); // 입력이 없으면 목록 숨기기
		loadSearchHistory(mbrId);
		return;
	}

	$.ajax({
		url : "https://suggestqueries.google.com/complete/search?output=chrome&hl=ko&q="
				+ query,
		dataType : "jsonp",
		method : "GET"
		}).done(
			function(json) {
				$('.SearchContent').empty(); // 기존 목록 비우기
				const maxSuggestions = 5;
				for (var i = 0; i < Math.min(
						json[1].length,
						maxSuggestions); i++) {
					$('.SearchContent').append('<li>' + json[1][i]+ '</li>');
				}
	
				if (json[1].length > 0) {
					$('.SearchContent').show(); // 결과가 있을 경우 목록 표시
				} else {
					$('.SearchContent').hide(); // 결과가 없으면 목록 숨기기
					loadSearchHistory(mbrId);
				}
			});
	});
	
	// 클릭 이벤트를 추가하여 목록 숨기기
	$(document).on('click', function(event) {
	    const $target = $(event.target);
	    // 검색창이나 리스트가 아닌 곳을 클릭했을 때
	    if (!$target.closest('#input_text').length && !$target.closest('.SearchContent').length) {
	        $('.SearchContent').hide(); // 목록 숨기기
	    }
	});

	// 목록 항목 클릭 시 입력 필드에 선택한 값 넣기
	$('.SearchContent').on('click', 'li', function() {
		$('#input_text').val($(this).text());
		$('.SearchContent').empty().hide(); // 선택 후 목록 숨기기
	     // mbrId가 null인 경우 폼을 즉시 제출
	        if (mbrId === null || mbrId === "") {
	            $('#search').submit(); // 폼 제출
	            return; // 함수 종료
	        }
	     
         // 폼 데이터 수집
         var formData = {
             mbrId: mbrId,
             searchNm: $('#input_text').val()
         };

         // AJAX 요청
         $.ajax({
             url: '/member/searchInsert',
             method: 'GET',
             data: formData,
             success: function(response) {
            	 if (response === 1) { // result 값이 1일 경우
                     console.log('AJAX 요청 성공');
                     $('#search').submit(); // 폼 제출
                 } else {
                     console.log('AJAX 요청 실패');
                     // 실패 처리 로직
                 }
             }
         });
	});
	// 프로필 영역 클릭 시 메뉴를 보여주거나 숨김
	$("#headerUser").on("click", function(event) {
		event.preventDefault(); // 링크 기본 동작 막기
		$("#userMenu").toggle(); // 메뉴 토글
	});

	// 메뉴 외부 클릭 시 메뉴 숨김 처리
	$(document).on("click", function(event) {
		if (!$(event.target).closest("#headerUser").length) {
			$("#userMenu").hide();
		}
	});

});

document.addEventListener('DOMContentLoaded', function () {
    var currentPath = window.location.pathname;

    $('.colorBtn').each(function() {
        var alinkElement = $(this);
        var linkPath = alinkElement.attr('href').split('?')[0];
        if (currentPath === linkPath) {
        	alinkElement.addClass('active2');
        }
        alinkElement.closest('li').find('.menuDetaild a').each(function() {
            var hrefValue = $(this).attr('href').split('?')[0];

            if (currentPath === hrefValue) {
            	alinkElement.addClass('active2');
            }
        });
    });

   
});
</script>

<!-- ***** Header Area Start ***** -->
<header class="header-area header-sticky">
	<div class="container">
		<div class="headerRow">
			<div class="col-8">
				<nav class="main-nav" style="padding: 8px 0px;">
					<!-- ***** Logo Start ***** -->
					<a href="/" class="logo"> <img src="/resources/images/찐레디고.gif" style="width: 127px; height: 70px; margin-left: 11px;">
					</a>
					<!-- ***** Logo End ***** -->
					<!-- ***** Search End ***** -->
					<div class="search-input">
						<form id="search" action="/common/commonList" method="get">
							<input type="text" id="input_text" name="keyword" placeholder="검색어를 입력하세요" value="${param.keyword}">
							<i id="inputIcon" class="fa fa-search"></i>
							<div class="SearchHistory" style="display: none;">
							    <p>&nbsp;&nbsp;<b>최근 검색어</b><button class="close-all">전체삭제</button></p>
							    <table style="width:100%;">
							    <tbody></tbody>
							    </table>
							    <hr>
							    <button class="close-div">닫기</button>
							</div>
							<ul class="SearchContent" style="display: none;"></ul>
						</form>
					</div>
					<!-- ***** Search End ***** -->
					<!-- ***** Menu Start ***** -->
					<ul class="navGen">
						<sec:authorize access="isAnonymous()">
							<li class="iconSize"><a href="#"> <img
									src="../../resources/images/Chat.png" alt="채팅 아이콘" />
							</a></li>
							<li class="iconSize"><a href="#"> <img
									src="../../resources/images/inform.png" alt="알림 아이콘" />
						        <span class="alert-message"></span> <!-- 실제 알림 메시지 -->
						    </a></li>
							<li><a href="/security/login">로그인</a></li>| 
							<li><a href="/security/memSignin">회원가입</a></li>|
							<li><a href="/enter/main">기업서비스</a></li>
						</sec:authorize>
						<sec:authorize access="isAuthenticated()">
							<p style="color: white; overflow: auto;">
								<sec:authentication property="principal.memVO" var="memVO" />
							</p>
							<!-- 웹소켓알림 -->
							<!-- 웹소켓알림 -->
							<li class="iconSize dropdown">
							    <a href="#" id="notificationIcon" class="nav-link" aria-expanded="false">
							        <img src="../../resources/images/inform.png" alt="알림 아이콘" />
							        <c:if test="${not empty alramList}">
							            <span class="badge badge-warning navbar-badge" id="notificationBadge">띵</span>
							        </c:if>
							    </a>
							    <div class="dropdown-menu dropdown-menu-lg dropdown-menu-right" id="notificationDropdown" >
									<c:forEach var="alram" items="${alramList}">
									    <div class="notification-item">
									    	<div class="alarmTitle">알림</div>
									    	<div class="alarmDate"><span class="dat"></span><fmt:formatDate value="${alram.ntcnYmd}" pattern="yyyy.MM.dd hh:mm:ss"/></div>
									        <a href="${alram.ntcnUrl}" class="dropdown-item notify-link">
									            ${alram.ntcnCn}
									        </a>
									        <button class="alramDel">x</button>
									        <input type="hidden" class="ntcnNo" value="${alram.ntcnNo}" />
									    </div>
									</c:forEach>
							    </div>
							</li>

							<!-- 웹소켓 알림끝 -->
							<!-- 웹소켓 알림끝 -->
							<form action="/logout" method="post">
								<button type="submit">로그아웃</button>
								<sec:csrfInput />
							</form>
							<li id="headerUser"><a
								href="/member/detail?mbrId=${memVO.mbrId}">${memVO.mbrNm} <c:if
										test="${memVO.fileDetailVOList[0].filePathNm==null}">
										<img src="/resources/images/member/기본프로필.png" alt="기본프로필.png"
											id="pImg" />
									</c:if> <c:if test="${memVO.fileDetailVOList[0].filePathNm!=null}">
										<img src="${memVO.fileDetailVOList[0].filePathNm}"
											alt="${memVO.fileDetailVOList[0].orgnlFileNm}" />
									</c:if>
							</a></li>
							<!-- 알림받는곳 넣어야함 -->
						    <div id="socketAlert" class="socket-alert hidden"></div>
						    	<div class="socket-alert-content"></div>							
					   <!-- 프로필 메뉴 -->
	                    	<li>
							    <ul id="userMenu">
							        <li><a href="/member/profile?mbrId=${memVO.mbrId}" class="menulist" href="/mypage">내 프로필</a></li>
							        <li><a class="menulist" href="/member/resume">마이페이지</a></li>
							        <li><a class="menulist" href="/member/scrap?mbrId=${memVO.mbrId}">스크랩</a></li><br>
							        <li><a class="menulist" href="/member/recentViewList">최근 본 공고</a></li> 
							        <li><a class="menulist" href="/outsou/main">레디Up</a></li>
							    </ul>
							</li>
							
							<li><a href="/enter/main">기업서비스</a></li>
						</sec:authorize>

					</ul>
					<!-- ***** Menu End ***** -->
				</nav>
			</div>
		</div>
		<nav>
			<ul id="nav2">
				<li class="menuDetail"><a href="/common/pbancList" class="colorBtn">채용정보</a></li>
				<li class="menuDetail"><a href="/common/enterList"  class="colorBtn">기업정보</a></li>
				<li class="menuDetail"><a href="/common/jobTools/spellingCheck" class="colorBtn">취업TOOL</a>
					<ul class="nav2-innav">
						<li class="menuDetaild"><a class="menuDt" href="/common/jobTools/spellingCheck">글자수세기</a></li>
						<li class="menuDetaild"><a class="menuDt" href="/common/jobTools/salaryCal">연봉계산기</a></li>
						<li class="menuDetaild"><a class="menuDt" href="/common/jobTools/netPayCal">실수령액계산기</a></li>
						<li class="menuDetaild"><a class="menuDt" href="/common/jobTools/creditTrans">학점변환기</a></li>
						<li class="menuDetaild"><a class="menuDt" href="/common/jobTools/languageTrans">어학점수변환기</a></li>
					</ul></li>
				<li class="menuDetail"><a href="/common/freeBoard/freeList" class="colorBtn">커뮤니티</a>
					<ul class="nav2-innav">
						<li class="menuDetaild"><a href="/common/notice/noticeList">공지게시판</a></li>
						<li class="menuDetaild"><a href="/common/faqBoard/faqList">FAQ게시판</a></li>
						<li class="menuDetaild"><a href="/common/freeBoard/freeList">자유게시판</a></li>
						<li class="menuDetaild"><a href="/common/inquiryBoard/inquiryList">문의게시판</a></li>
					</ul></li>
				<li class="menuDetail"><a href="/member/injae" class="colorBtn">인재</a></li>
				<li class="menuDetail"><a href="/outsou/main" class="colorBtn">레디Up</a></li>
				<li>가능성은 무한, 준비는 Ready Go!</li>
			</ul>
		</nav>
	</div>
</header>
<!-- ***** Header Area End ***** -->
<script>
function formatDate(timestamp) {
    const date = new Date(timestamp);
    const year = date.getFullYear();
    const month = String(date.getMonth() + 1).padStart(2, '0');
    const day = String(date.getDate()).padStart(2, '0');
    const hours = String(date.getHours()).padStart(2, '0');
    const minutes = String(date.getMinutes()).padStart(2, '0');
    const seconds = String(date.getSeconds()).padStart(2, '0');

    return year+`.`+month+`.`+day+` `+ hours+`:`+minutes+`:`+seconds;
}
// 클릭할 때 알림 목록을 토글하는 스크립트
$(document).ready(function() {
    // 알림 아이콘 클릭 시 열고 닫기 기능
    $('#notificationIcon').on('click', function(e) {
        e.preventDefault();
        var dropdown = $('#notificationDropdown');

        $.ajax({
            url: '/notification/list',  // 서버에서 알림 목록을 반환하는 API
            method: 'GET',
            dataType: 'json',
            beforeSend: function(xhr) {
                xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
            },
            success: function(response) {
                var dropdown = $('#notificationDropdown');
                dropdown.empty();  // 기존 알림 목록 비우기
                if (response.length > 0) {
                    // 알림이 있을 경우 배지를 보여줌
                    dropdown.append('<div class="alarmTitle">알림</div>');
                    dropdown.append('<div class="alarm-actions" style="display: flex; justify-content: space-between;">' + 
                            '<a href="#" class="dropdown-item dropdown-footer" id="alramAllDel">전체삭제</a>' +
                            '<a href="/member/memAlram?mbrId=" class="dropdown-item dropdown-footer" id="alramList" style="text-align:right;">알림목록</a>' +
                            '</div>');
                    var notificationCount = response.length;
                    $('#notificationBadge').show().text(notificationCount);
                    $.each(response, function(index, alram) {
                        dropdown.append(
                            	'<div class="alarmDate"><span class="dat"></span> '+formatDate(alram.ntcnYmd) +'</div>'+
                                '<div class="boxbox"><div><a data-ntcn-no="'+alram.ntcnNo+'" href="'+alram.ntcnUrl+'" class="dropdown-item dropdown-footer notify-link">' + 
                                alram.ntcnCn + 
                                '<input type="hidden" id="ntcnNo" name="ntcnNo" value="' + alram.ntcnNo + '" />' +
                                '</div><div><button data-ntcn-no="'+alram.ntcnNo+'" id="alramDel">x</button></div>' + 
                                '</a></div>'
                        );
                    });
                } else {
                    // 알림이 없을 경우 배지를 숨김
                    $('#notificationBadge').hide().text(0);
                    dropdown.append('<a href="#" class="dropdown-item dropdown-footer">알림이 없습니다.</a>');
                }
                // 알림 목록을 열고 닫기 토글
                dropdown.toggleClass('show');
            },
            error: function() {
                console.error('알림 목록을 불러오는 데 실패했습니다.');
            }
        });
    });

    // 드롭다운 외부 클릭 시 닫기 기능
    $(document).on('click', function(e) {
        var dropdown = $('#notificationDropdown');

        if (!$(e.target).closest('#notificationIcon').length && !$(e.target).closest('#notificationDropdown').length) {
            dropdown.removeClass('show');
        }
    });
    $(document).on('click', '.notify-link', function(e) {
        e.preventDefault(); // 기본 동작 막기 (바로 이동되지 않도록)

        // 알림의 ntcnNo 값 가져오기
        var ntcnNo = $(this).data('ntcnNo');
        var targetUrl = $(this).attr('href');
        // AJAX 요청으로 알림 삭제하기
        $.ajax({
            url: '/notification/alramLinkClick',  
            method: 'POST',
            data: {
                ntcnNo: ntcnNo  // 삭제할 알림 번호 전달
            },
            beforeSend: function(xhr) {
                xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");  // CSRF 토큰 설정
            },
            success: function(response) {
                if (response === 'success') {
                    $(e.target).closest('a').remove();
                    // 알림 삭제 후 해당 URL로 이동
                    window.location.href = targetUrl;
                } else {
                    alert('알림 삭제 중 오류가 발생했습니다.');
                }
            },
            error: function() {
                alert('알림 삭제 중 오류가 발생했습니다.');
            }
        });
    });
    $(document).on('click', '#alramDel', function(e) {
    	e.stopPropagation();
        e.preventDefault();
        
        // 클릭된 버튼의 해당 알림 번호 가져오기
//         var ntcnNo = $(this).siblings('input#ntcnNo').val();
		var ntcnNo = $(this).data("ntcnNo");
        $.ajax({
            url: '/notification/alramDel',  // 알림 삭제 처리하는 API 엔드포인트
            method: 'POST',
            data: {
                ntcnNo: ntcnNo  // 삭제할 알림 번호 전달
            },
            beforeSend: function(xhr) {
                xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");  // CSRF 토큰 설정
            },
            success: function(response) {
                if (response === 'success') {
                    // 성공적으로 삭제한 후 해당 알림 항목 제거
                    $(e.target).closest('a').remove();

                    // 남은 알림 목록을 다시 불러와서 갯수 확인
                    $.ajax({
                        url: '/notification/list',  // 서버에서 알림 목록을 반환하는 API
                        method: 'GET',
                        dataType: 'json',
                        success: function(response) {
                            var dropdown = $('#notificationDropdown');
                            dropdown.empty();  // 기존 알림 목록 비우기
                            
                            if (response.length > 0) {
                            	 // 전체 삭제 버튼 추가
			                    dropdown.append('<div class="alarmTitle">알림</div>');
			                    dropdown.append('<div class="alarm-actions" style="display: flex; justify-content: space-between;">' + 
			                            '<a href="#" class="dropdown-item dropdown-footer" id="alramAllDel">전체삭제</a>' +
			                            '<a href="/member/memAlram?mbrId=" class="dropdown-item dropdown-footer" id="alramList" style="text-align:right;">알림목록</a>' +
			                            '</div>');

                                // 알림이 있으면 알림 목록을 추가하고 배지 표시
                                var notificationCount = response.length;
                                $('#notificationBadge').show().text(notificationCount);
                                $.each(response, function(index, alram) {
                                    dropdown.append(
                                        	'<div class="alarmDate"><span class="dat"></span> '+formatDate(alram.ntcnYmd) +'</div>'+
                                        '<div class="boxbox"><div><a data-ntcn-no="'+alram.ntcnNo+'" href="'+alram.ntcnUrl+'" class="dropdown-item dropdown-footer notify-link">' + 
                                        alram.ntcnCn + 
                                        '<input type="hidden" id="ntcnNo" name="ntcnNo" value="' + alram.ntcnNo + '" />' +
                                        '</div><div><button data-ntcn-no="'+alram.ntcnNo+'" id="alramDel">x</button></div>' + 
                                        '</a></div>'
                                    );
                                });
                            } else {
                                // 알림이 없으면 배지를 숨기고 "알림이 없습니다" 메시지 추가
                                $('#notificationBadge').hide().text(0);
                                dropdown.append('<a href="#" class="dropdown-item dropdown-footer">알림이 없습니다.</a>');
                            }
                        },
                        error: function() {
                            console.error('알림 목록 갱신 중 오류가 발생했습니다.');
                        }
                    });
                } else {
                    alert('알림 삭제 중 오류가 발생했습니다.');
                }
            },
            error: function() {
                alert('알림 삭제 중 오류가 발생했습니다.');
            }
        });
    });

    $(document).on('click', '#alramAllDel', function(e) {
        e.preventDefault(); // 기본 동작 막기
		
        $.ajax({
            url: '/notification/alramAllDel',
            type: 'POST',
            beforeSend: function(xhr) {
                xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");  // CSRF 토큰 설정
            },
            success: function(response) {
                if (response === "success") {
                    $('#notificationDropdown').empty().append(
                            '<a href="#" class="dropdown-item dropdown-footer">알림이 없습니다.</a>'
                        );
                    $('#notificationBadge').hide().text(0); // 배지 숨기기
                } else if (response === "fail") {
                    alert("알림 삭제에 실패했습니다.");
                } else {
                    alert("오류가 발생했습니다.");
                }
            },
            error: function(xhr, status, error) {
                alert("서버와 통신 중 오류가 발생했습니다. " + error);
            }
        });
    });


});
</script>
<style>
#alramAllDel,#alramList {
    color: #2f2f2f;
    text-decoration: none; 
    padding: 5px;
    display: inline-block;
    background-color: transparent;
}

#alramAllDel:hover, #alramList:hover {
    color: #24D59E;
    background-color: transparent; 
    text-decoration: none; 
}

#alramAllDel:active, #alramList:active {
    color: #24D59E; 
    background-color: transparent; 
    text-decoration: none; 
}

/* focus 상태에서도 동일한 스타일 적용 */
#alramAllDel:focus, #alramList:focus {
    color: #24D59E; 
    background-color: transparent; 
    text-decoration: none; 
}

.boxbox{
	display: flex;
	flex-direction: row;
	justify-content: space-between;
	background-color: #00bc8c0a;
	border-radius: 8px;
	margin-bottom: 15px;

}
.notify-link:hover{
	border-radius: 8px;
}
.notify-link{
	display: flex;
	flex-direction: row;
	justify-content: space-between;
	border-radius: 8px;
}
.dat{
	display: inline-block;
    top: 7px;
    left: 0;
    width: 7px;
    height: 7px;
    border: 2px solid #96a0b5;
    border-radius: 50%;
    box-sizing: border-box;
    content: "";
}
.alarmDate{
	font-size: 12px;
	font-weight: 500;
	color: #96a0b5;
}
/*  알림 내용 */
.alarmCon{
	display: flex;
	flex-direction: column;
	margin-bottom: 15px;
}
#alramAllDel:hover{
	background-color: #fff;
}
/* 알림 제목 텍스트 */
.alarmTitle{
	font-size: 24px;
	font-weight: 600;
	margin-bottom: 20px;
}
/* 알림 창 */
.dropdown-menu-right{
	overflow: hidden;
    position: absolute;
    top: 49px;
    right: -319px;
    padding: 23px 26px 23px 26px;
    max-width: 400px;
    width: 376px;
    height: 720px;
    border: 1px solid #d7dce5;
    border-radius: 16px;
    box-sizing: border-box;
    background-color: #fff;
    box-shadow: 2px 6px 16px 0 rgba(17, 42, 128, 0.08);
    text-align: left;
    overflow: overlay;
}
 .dropdown-menu-right::-webkit-scrollbar {
    width: 10px;
  }
  .dropdown-menu-right::-webkit-scrollbar-thumb {
    background-color: #24D59E;
    border-radius: 10px;
    background-clip: padding-box;
    border: 2px solid transparent;
  }
  .dropdown-menu-right::-webkit-scrollbar-track {
    background-color: #eaeaea;
    border-radius: 10px;
    box-shadow: inset 0px 0px 5px white;
  }


/*알림 버튼 링크 분리*/
.notification-item {
    display: flex;                  /* flexbox로 일렬 정렬 */
    align-items: center;            /* 세로 중앙 정렬 */
    justify-content: space-between; /* 양쪽 끝으로 정렬 */
    padding: 5px 10px;
    border-bottom: 1px solid #eee;  /* 항목 간의 구분선 */
}

.notification-item a {
    flex: 1;                        /* 링크가 가능한 넓이만큼 차지하도록 */
    text-decoration: none;          /* 링크 밑줄 제거 */
    color: #333;                    /* 링크 색상 */
    padding-right: 10px;            /* 링크와 삭제 버튼 사이에 여백 추가 */
}

.notification-item button {
    background: none;               /* 배경 없애기 */
    border: none;                   /* 테두리 없애기 */
    color: red;                     /* 버튼 색상 (원하는 색상으로 변경 가능) */
    cursor: pointer;                /* 클릭 가능한 마우스 포인터 */
    font-size: 16px;                /* 버튼 크기 설정 */
    padding: 0;
}

/* 알림 박스 스타일 */
.socket-alert {
    position: fixed;
    top: 20px;
    right: 20px;
    z-index: 9999;
    background-color: #24D59E; /* 알림 배경색 (초록색) */
    color: #fff; /* 텍스트 색상 */
    padding: 15px 20px;
    border-radius: 8px;
    box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1); /* 그림자 효과 */
    font-size: 16px;
    font-family: 'Pretendard', sans-serif;
    opacity: 0;
    transition: opacity 0.3s ease, transform 0.3s ease;
    transform: translateY(-20px);
}

/* 알림 박스 표시할 때 */
.socket-alert.visible {
    opacity: 1;
    transform: translateY(0);
}

/* 알림 박스 숨길 때 */
.socket-alert.hidden {
    opacity: 0;
    transform: translateY(-20px);
    transition: opacity 0.3s ease, transform 0.3s ease;
}
/*알림여기까지*/
.headerRow {
	display: flex;
	justify-content: center;
}

.logo img {
	height: 70px;
}

nav.main-nav, ul {
	align-items: center; /* 수직 중앙 정렬 */
}

#nav2 > li:last-child {
	border-left: 2px solid #D6D6D6;
	padding-left: 55px;
	color: #24D59E;
}

.iconSize img {
	width: 30px;
	height: 30px;
}

.navGen li {
	display: flex;
	justify-content: flex-end;
}

#nav2 {
	position: relative;
	padding-top: 5px;
	padding-bottom: 5px;
    text-align: center; /* 중앙 정렬 */
    border-top: 1px solid #D6D6D6; /* 상단 경계선 */
    border-bottom: 1px solid #D6D6D6; /* 하단 경계선 */
}

#nav2 li {
	
    display: inline-block; /* 가로 정렬 */
    position: relative; /* 서브 메뉴 위치 설정을 위해 필요 */
}

#nav2 > li{
	margin: 10px;
	margin-left: 40px;
	margin-right: 40px;
}

.nav2-innav {
	width : 120px;
	padding-top: 10px;
	padding-bottom: 10px;
    display: none; /* 기본적으로 숨김 */
    position: absolute; /* 서브 메뉴 위치 설정 */
    top: 100%; /* 부모 메뉴 아래에 위치 */
    left: -28px; /* 부모 메뉴와 같은 위치에 시작 */
    list-style: none; /* 기본 목록 스타일 제거 */
    background-color: white; /* 배경색 설정 */
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1); /* 그림자 추가 */
    z-index: 10;
}

#nav2 li:hover .nav2-innav {
    display: block; /* 마우스 오버 시 보이도록 설정 */
}

.nav2-innav li {
    display: block; /* 세로 정렬 */
    font-size: 0.9em;
    margin: 10px 10px;
}
/* 프로필 메뉴 css */
#userMenu{
	margin-top: 28px;
    margin-left: -124px;
    width: 130px;
    display:none; 
    position:absolute; 
    background-color: white; 
    list-style: none; 
    padding: 4px; 
    border: 1px solid #ccc;
    text-align:center;
    border-radius :5px;

}
#userMenu li a{
	color: #2f2f2f; 
	font-size: 12px; 
	font-family: pretendard; 
	font-weight: 500;

}
.navGen li a{
	display: block;
    font-weight: 400;
    font-size: 12px;
    text-transform: capitalize;
    color: #666;
    -moz-transition: all 0.3s ease 0s;
    -o-transition: all 0.3s ease 0s;
    transition: all 0.3s ease 0s;
    border: transparent;
    padding: 13px 10px;
    border-radius: 18px;
    letter-spacing: .3px;
}
.navGen li a:hover{
  color: #2f2f2f;
  background-color: none;
}

.menuDetail a.active2 {
    color: #24D59E; /* 활성화된 링크 색상 */
    font-weight: bold; /* 글꼴 두께 조정 */
}
.colorBtn:hover{
	text-decoration:none;
}
.menuDetaild{
	text-decoration:none;
}
a:hover{
	text-decoration:none;
}
</style>