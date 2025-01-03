<%@page import="kr.or.ddit.vo.PbancVO"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="kr.or.ddit.vo.EventVO"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec"
	uri="http://www.springframework.org/security/tags"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link rel="stylesheet"
	href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200" />
<link rel="stylesheet"
	href="<%=request.getContextPath()%>/resources/css/enter/main.css" />
<link rel="stylesheet" href="<%=request.getContextPath()%>/resources/css/alert.css" />
<script
	src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script
	src='https://cdn.jsdelivr.net/npm/fullcalendar@6.1.8/index.global.min.js'></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@10"></script>
<script type="text/javascript" src="/resources/js/jquery.min.js">
</script>
</head>
<body>
	<sec:authentication property="principal" var="prc" />
	<div id="maintop">
		<div id="mainleft">
			<!-- 캘린더 영역 -->
			<div id="Wrapper">
				<div id='calendar'></div>
			</div>

			<script>
			var Toast = Swal.mixin({
				toast: true,
				position: 'center',
				showConfirmButton: false,
				timer: 3000
				});
			
    document.addEventListener('DOMContentLoaded', function() {
    	
        const YrModal = document.querySelector("#yrModal");
        const calendarEl = document.querySelector('#calendar');
        const mySchStart = document.querySelector("#schStart");
        const mySchEnd = document.querySelector("#schEnd");
        const mySchTitle = document.querySelector("#schTitle");
        const mySchAllday = document.querySelector("#allDay");
        const mySchBColor = document.querySelector("#schBColor");
        const mySchFColor = document.querySelector("#schFColor");

        const headerToolbar = {
            left: 'prevYear,prev,next,nextYear today',
            center: 'title',
            right: 'dayGridMonth,dayGridWeek,timeGridDay'
        }
        
     	// 랜덤 색상 생성 함수 (20% 투명도)
        function getRandomColor() {
            const letters = '0123456789ABCDEF';
            let color = '#';
            for (let i = 0; i < 6; i++) {
                color += letters[Math.floor(Math.random() * 16)];
            }
            // RGBA 형식으로 변환, 알파 값은 0.2로 설정
            return `rgba(\${parseInt(color.slice(1, 3), 16)}, \${parseInt(color.slice(3, 5), 16)}, \${parseInt(color.slice(5, 7), 16)}, 0.2)`;
        }

        // 서버에서 전달된 이벤트 데이터를 JS에서 사용할 수 있도록 변환
       const eventsFromServer = [
    	   <c:forEach items="${pbancCalendarList}" var="pbancVO">
            	{
                	title: "${pbancVO.pbancTtl}",
    			    start: "${pbancVO.pbancBgngDts}",
    			    end: "${pbancVO.pbancDdlnDts}",
    			    allDay: true,
    			    backgroundColor: getRandomColor(),
    			    textColor: "black" 
                },
            </c:forEach>
        ];

        const today = new Date();
        const firstDayOfCurrentMonth = new Date(today.getFullYear(), today.getMonth(), 1); // 현재 월의 첫 번째 날

        const calendarOption = {
            height: '500px',
            expandRows: true,
            slotMinTime: '09:00',
            slotMaxTime: '18:00',
            headerToolbar: headerToolbar,
            initialView: 'dayGridMonth',
            initialDate: firstDayOfCurrentMonth, // 현재 월의 첫 번째 날을 초기 날짜로 설정
            locale: 'ko',
            selectable: true,
            selectMirror: true,
            navLinks: true,
//             weekNumbers: true,
            editable: true,
            dayMaxEventRows: true,
            nowIndicator: true,
            events: eventsFromServer  // 서버에서 가져온 이벤트 리스트 사용
        }

        const calendar = new FullCalendar.Calendar(calendarEl, calendarOption);
        calendar.render();

//         calendar.on("select", info => {
//             mySchStart.value = info.startStr;
//             mySchEnd.value = info.endStr;
//             YrModal.style.display = "block";
//         });

        function fCalAdd() {
            if (!mySchTitle.value) {
                alert("제목을 입력해주세요.");
                mySchTitle.focus();
                return;
            }
            let bColor = mySchBColor.value;
            let fColor = mySchFColor.value;
            if (fColor == bColor) {
                bColor = "black";
                fColor = "yellow";
            }

            let event = {
                start: mySchStart.value,
                end: mySchEnd.value,
                title: mySchTitle.value,
                allDay: mySchAllday.checked,
                backgroundColor: bColor,
                textColor: fColor
            };

            calendar.addEvent(event);
            fMClose();
        }
        
    });
    
    function fMClose() {
        yrModal.style.display = "none";
        mySchStart.value = "";
        mySchEnd.value = "";
        mySchTitle.value = "";
        mySchAllday.checked = false;
        mySchBColor.value = "#000000";
        mySchFColor.value = "#ffffff";
    };
    
    $(function(){
		console.log("${prc}");
		console.log("${pbancCalendarList}");
    });
    function alerttext(){
    	alert("로그인 후 이용하세요.");
    	location.href="/security/entLogin";
    }
    
 /* ---------------------빠른 메뉴관리 모달 스크립트 --------------------------*/   
    // 모달창 열기
    function openFastMenuModal() {
      document.getElementById("fastMenuModal").style.display = "block";
    }

    // 모달창 닫기
    function closeFastMenuModal() {
      document.getElementById("fastMenuModal").style.display = "none";
    }


    $(document).ready(function () {
        const maxChecked =7; // 최대 체크할 수 있는 개수

        function loadSettings() {
            const menuItems = [
                { checkbox: '#readyGo2', menu: '#readyGo1', storageKey: 'readyGoChecked' },
                { checkbox: '#addPost2', menu: '#addPost1', storageKey: 'addPostChecked' },
                { checkbox: '#applicants2', menu: '#applicants1', storageKey: 'applicantsChecked' },
                { checkbox: '#proposal2', menu: '#proposals1', storageKey: 'proposalChecked' },
                { checkbox: '#talent2', menu: '#talent1', storageKey: 'talentChecked' },
                { checkbox: '#authorization2', menu: '#authorization1', storageKey: 'authorizationChecked' }
            ];

            menuItems.forEach(item => {
                const isChecked = localStorage.getItem(item.storageKey) === 'true';
                $(item.checkbox).prop('checked', isChecked);

                if (isChecked) {
                    $(item.menu).css('display', 'block');
                } else {
                    $(item.menu).css('display', 'none');
                }
            });
        }

        function saveFastMenuSettings() {
            const menuItems = [
                { checkbox: '#readyGo2', menu: '#readyGo1', storageKey: 'readyGoChecked' },
                { checkbox: '#addPost2', menu: '#addPost1', storageKey: 'addPostChecked' },
                { checkbox: '#applicants2', menu: '#applicants1', storageKey: 'applicantsChecked' },
                { checkbox: '#proposal2', menu: '#proposals1', storageKey: 'proposalChecked' },
                { checkbox: '#talent2', menu: '#talent1', storageKey: 'talentChecked' },
                { checkbox: '#authorization2', menu: '#authorization1', storageKey: 'authorizationChecked' }
            ];

            menuItems.forEach(item => {
                const isChecked = $(item.checkbox).is(':checked');
                localStorage.setItem(item.storageKey, isChecked);

                if (isChecked) {
                    $(item.menu).css('display', 'block');
                } else {
                    $(item.menu).css('display', 'none');
                }
            });

            closeFastMenuModal();
        }

        // 체크된 체크박스 개수 확인 함수
        function getCheckedCount() {
            return $('input[type="checkbox"]:checked').length;
        }

        // 체크박스 변경 시 개수 확인 및 경고 처리
        $('input[type="checkbox"]').on('change', function () {
            const checkedCount = getCheckedCount();

            if ($(this).is(':checked')) {
                if (checkedCount > maxChecked) {
                    alert('최대 5개까지만 선택할 수 있습니다.');
                    $(this).prop('checked', false); // 체크박스 상태를 다시 해제
                } else {
                    const storageKey = $(this).attr('id') + 'Checked';
                    localStorage.setItem(storageKey, true); // 체크된 상태를 로컬 스토리지에 저장
                }
            } else {
                const storageKey = $(this).attr('id') + 'Checked';
                localStorage.setItem(storageKey, false); // 체크 해제 상태를 로컬 스토리지에 저장
            }
        });

        $('.save-fast-menu').on('click', saveFastMenuSettings);

        loadSettings();
    });


</script>
		</div>

		<div id="mainright">
			<div id="fast">
				<div id="pbanc">
					<p class="fmtitle">진행중 공고</p>
					<p class="num">
						<c:choose>
							<c:when test="${pbCount==null}">0</c:when>
							<c:when test="${pbCount!=null}">${pbCount}</c:when>
						</c:choose>
					</p>
				</div>
				<div class='v-line'></div>
				<div id="prf">
					<p class="fmtitle">입사 지원자</p>
					<p class="num">
						<c:choose>
							<c:when test="${openCount==null}">0</c:when>
							<c:when test="${openCount!=null}">${openCount}</c:when>
						</c:choose>
					</p>
				</div>
				<div class='v-line'></div>
				<div id="applicant">
					<p class="fmtitle">미열람 지원자</p>
					<p class="num">
						<c:choose>
							<c:when test="${closeCount==null}">0</c:when>
							<c:when test="${closeCount!=null}">${closeCount}</c:when>
						</c:choose>
					</p>
				</div>
				<div class='v-line'></div>
				<div id="proposal">
					<p class="fmtitle">스카우트 제안</p>
					<p class="num">
						<c:choose>
							<c:when test="${ppCount==null}">0</c:when>
							<c:when test="${ppCount!=null}">${ppCount}</c:when>
						</c:choose>
					</p>
				</div>
			</div>
			<div id="fastmenu">
				<div class="fast-title">
					<div>
						<h5 id="fmenu">빠른 메뉴</h5>
					</div>
					<div>
						<button type="button" id="fast-btn" onclick="openFastMenuModal()">
							<img class="fast-img" src="../resources/icon/menu.png"/>
						</button>
					</div>
				</div>
				<div id="fastmenubtn">
					
					<!-- readyGo -->				
					<div id="readyGo1" style="display: none;">
						<div class="div-flex">
							<button type="button" id="readyGo" class="readyGo" onClick="window.open('/')">
								<img class="readyGoImg" src="../resources/icon/home.png"/>
							</button>
							<p class="p-title">Ready Go</p>
						</div>	
					</div>	
				
					<!-- 공고등록 -->
					<c:if test="${prc ne 'anonymousUser'}">
					<div id="addPost1" style="display: none;">
						<div class="div-flex">
							<button type="button" id="addPost" onClick="window.open('/enter/pbancInsert?entId=${prc.username}')">
								<img class="addImg" src="../resources/icon/add_post.png"/>
							</button>
							<p class="p-title">공고 등록</p>
						</div>					
					</div>
					</c:if>
					<c:if test="${prc eq 'anonymousUser'}">
					<div class="div-flex">
						<button type="button" id="pb" onClick="alerttext()">
							<img class="addImg" src="../resources/icon/add_post.png"/>
						</button>
						<p class="p-title">공고 등록</p>
					</div>			
					</c:if>		
				
					<!-- 지원자관리 -->
					<c:if test="${prc ne 'anonymousUser'}">
					<div id="applicants1" style="display: none;">
						<div class="div-flex">
							<button type="button" id="applicants" onClick="window.open('/enter/listAplct?entId=${prc.username}')">
								<img class="appImg" src="../resources/icon/applicant.png"/>
							</button>
							<p class="p-title">지원자 관리</p>
						</div>					
					</div>
					</c:if>
					<c:if test="${prc eq 'anonymousUser'}">
					<div class="div-flex">
						<button type="button" id="ap" onClick="alerttext()">
							<img class="appImg" src="../resources/icon/applicant.png"/>
						</button>
						<p class="p-title">지원자 관리</p>					
					</div>
					</c:if>
					
					<!-- 스카우트 제안 -->
					<c:if test="${prc ne 'anonymousUser'}">
					<div id="proposals1" style="display: none;">
						<div class="div-flex">
							<button type="button" id="proposals" onClick="window.open('/enter/scout?entId=${prc.username}')">
								<img class="proImg" src="../resources/icon/scout.png"/>
							</button>
							<p class="p-title">스카우트</p>					
						</div>					
					</div>
					</c:if>
					<c:if test="${prc eq 'anonymousUser'}">
					<div class="div-flex">
						<button type="button" id="pro" onClick="alerttext()">
							<img class="proImg" src="../resources/icon/scout.png"/>
						</button>
						<p class="p-title">스카우트</p>					
					</div>						
					</c:if>
					
					<!-- 인재 -->
					<c:if test="${prc ne 'anonymousUser'}">
					<div id="talent1" style="display: none;">
						<div class="div-flex">
							<button type="button" id="talent" onClick="window.open('/enter/injae?entId=${prc.username}')">
								<img class="proImg" src="../resources/icon/talent.png"/>
							</button>
							<p class="p-title">인재</p>					
						</div>					
					</div>
					</c:if>
					<c:if test="${prc eq 'anonymousUser'}">
					<div class="div-flex" style="display: none;">
						<button type="button" id="tal" onClick="alerttext()">
							<img class="proImg" src="../resources/icon/talent.png"/>
						</button>
						<p class="p-title">인재</p>					
					</div>						
					</c:if>					
					
					<!-- 기업회원 권한 부여 -->
					<c:if test="${prc ne 'anonymousUser'}">
					<div id="authorization1" style="display: none;">
						<div class="div-flex">
							<button type="button" id="authorization" onClick="window.open('/enter/entaddmem?entId=${prc.username}')">
								<img class="proImg" src="../resources/icon/manage.png"/>
							</button>
							<p class="p-title">기업회원 추가</p>					
						</div>					
					</div>
					</c:if>
					<c:if test="${prc eq 'anonymousUser'}">
					<div class="div-flex">
						<button type="button" id="auth" onClick="alerttext()">
							<img class="proImg" src="../resources/icon/manage.png"/>
						</button>
						<p class="p-title">기업회원 추가</p>					
					</div>						
					</c:if>					
					
					
					
					
				</div>
			</div>
			<div id="pbancmenu">
				<div id="pbanctitle">
					<h5>우리 기업이 등록한 공고</h5>
					<c:if test="${prc ne 'anonymousUser'}">
						<p class="add_list"><a class="addList" href="/enter/pbanc?entId=${prc.username}">더보기 ></a></p>
					</c:if>
					<c:if test="${prc eq 'anonymousUser'}">
						<p class="add_list"><a class="addList" onClick="alerttext()" >더보기 ></a></p>
					</c:if>
				</div>
				<div id="pbancex">
					<div id="pbanclist">
						<c:if test="${prc eq 'anonymousUser'}">
							<p id="notlogin">로그인 후 이용 가능합니다.</p>
						</c:if>
						<c:if test="${prc ne 'anonymousUser'}">
							<c:if test="${not empty pbancList}">
							<c:forEach var="pbancVO" varStatus="stat" items="${pbancList}">
								<div id="pblist">
									<div class="pblso">
										<div class="fbig">${pbancVO.enterVO.entNm}</div>
										<div class="fmid">${pbancVO.entStleNm}</div>
									</div>
	
									<div class="pblso1">
										<div>
											<p class="fbigtt"><a href="/enter/pbancDetail?pbancNo=${pbancVO.pbancNo}">${pbancVO.pbancTtl}</a>
											<p>
										</div>
										<div class="fmid">${pbancVO.pbancTpbizNm}</div>
									</div>
	
									<div class="pblso2">
										<div class="fsmall">${pbancVO.pbancRprsrgnNm}</div>
										<div class="fsmall">${pbancVO.rcritCareerNm}</div>
										<div class="fsmall">${pbancVO.pbancAplctEdu}</div>
									</div>
	
									<div class="pbl">
										<div class="fsmall">${pbancVO.pbancDlnDt}까지</div>
										<div class="fsmall">${pbancVO.pbancBeforeWrt}일전 등록</div>
									</div>
								</div>
							</c:forEach>
							</c:if>
							<c:if test="${empty pbancList}">
								<p >현재 채용중인 공고가 없습니다.</p>
							</c:if>
						</c:if>
					</div>
				</div>
			</div>
		</div>
	</div>
	<div>
		<h5>인재 추천</h5>
		<br>
		<div class="prfmaintitle">
			<p>
		</div>
		<div id="mainbtm">
			<div>
				<p>
					<strong>신입</strong>
				</p>
				<div id="newbie">
				<c:forEach var="memberVO"  items="${injaeNewList}">
					<button class="prfmenu" onClick="location.href='/member/profile?mbrId=${memberVO.mbrId}'">
						<div class="info">
							<img class="circle" alt="" src="${memberVO.fileGroupSn}">
							<div>
								<p class="injae">
									<strong>${memberVO.mbrNm}</strong>
								</p>
								<p class="injae">${memberVO.tpbizSeNm}</p>
							</div>
						</div>
						<p class="skill">${memberVO.skCd }</p>
					</button>
				</c:forEach>
				</div>
			</div>
			<div class='p-line'></div>
			<div class="old">
				<p>
					<strong>경력</strong>
				</p>
				<div id="personal">
					<c:forEach var="memberVO" items="${injaeOldList}">
						<button class="prfmenu" onClick="location.href='/member/profile?mbrId=${memberVO.mbrId}'">
							<div class="info">
								<img class="circle" alt="" src="${memberVO.fileGroupSn}">
								<div>
									<p class="injae">
										<strong>${memberVO.mbrNm}</strong>
									</p>
									<p class="injae">${memberVO.tpbizSeNm}</p>
								</div>
							</div>
							<p class="skill">${memberVO.skCd }</p>
						</button>
					</c:forEach>
				</div>
			</div>
		</div>
	</div>
	<br>
	
<!-- //////////////////////////////////////빠른 메뉴 관리 모달창(민주)////////////////////////////////////// -->
<div id="fastMenuModal" class="modal">
  <div class="modal-content">
    <div class="modal-fast">
	   	<div>
	    	<p class="fast-list">빠른 메뉴 관리</p>
	   	</div>
	   	<div>
	    	<span class="close" onclick="closeFastMenuModal()"></span>
	   	</div>
    </div>
    <p class="fast-menu-content">빠른 메뉴는 최대 5개까지 설정할 수 있습니다.</p>
    <!-- 메뉴 아이콘들 시작 -->
    <div id="fastMenuOptions">
		<div class="up-fast-menu"> <!-- 위쪽 -->
		      <!-- 모달창에서 관리할 빠른 메뉴 항목들 -->
		        <div class="div-flex2">
			    <input type="checkbox" id="readyGo2">
		          <button type="button" id="ready2">
		            <img class="readyGoImg" src="../resources/icon/home.png" />
		          </button>
		          <p class="p-title">Ready Go</p>
		        </div>
		
		      <div class="div-flex2">
		        <input type="checkbox" id="addPost2">
		          <button type="button" id="add2">
		            <img class="addImg" src="../resources/icon/add_post.png" />
		          </button>
		          <p class="p-title">공고 등록</p>
		      </div>
		
		      <div class="div-flex2">
		        <input type="checkbox" id="applicants2">
		          <button type="button" id="ap2">
		            <img class="appImg" src="../resources/icon/applicant.png" />
		          </button>
		          <p class="p-title">지원자 관리</p>
		      </div>
		
	      	</div>
	    <div class="down-fast-menu"> <!-- 아래쪽 -->
			<div class="div-flex2">
			  <input type="checkbox" id="proposal2">
			    <button type="button" id="pro2">
			      <img class="proImg" src="../resources/icon/scout.png" />
			    </button>
			    <p class="p-title">스카우트</p>
			</div>
			<div class="div-flex2">
			  <input type="checkbox" id="talent2">
			    <button type="button" id="tal2">
			      <img class="proImg" src="../resources/icon/talent.png" />
			    </button>
			    <p class="p-title">인재</p>
			</div>
			<div class="div-flex2">
			  <input type="checkbox" id="authorization2">
			    <button type="button" id="auth2">
			      <img class="proImg" src="../resources/icon/manage.png" />
			    </button>
			    <p class="p-title">기업회원 추가</p>
			</div>
	    
	    </div>
    </div>
    <div class="modal-btn">
	    <button class="save-fast-menu">저장</button>
    </div>
  </div>
</div>

</body>
</html>