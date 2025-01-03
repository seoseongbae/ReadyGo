<%@ page language="java" contentType="text/html;charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<script>
document.addEventListener('DOMContentLoaded', function () {
    var navMainLinks = document.querySelectorAll('.nav-item.nav_main .nav-link');
    var navSubLinks = document.querySelectorAll('.nav-item.nav_sub .nav-link');

    // nav_main 항목에 클릭 이벤트 리스너 추가
    navMainLinks.forEach(function (link) {
        link.addEventListener('click', function () {
            // 모든 nav_main 항목에서 'active' 클래스 제거
            navMainLinks.forEach(function (item) {
                item.parentNode.classList.remove('active');
            });

            // 모든 nav_sub 항목에서 'active' 클래스 제거
            navSubLinks.forEach(function (item) {
                item.parentNode.classList.remove('active');
            });

            // 클릭된 nav_main 항목에 'active' 클래스 추가
            this.parentNode.classList.add('active');
        });
    });

    // nav_sub 항목에 클릭 이벤트 리스너 추가
    navSubLinks.forEach(function (link) {
        link.addEventListener('click', function () {
            // 모든 nav_main 항목에서 'active' 클래스 제거
            navMainLinks.forEach(function (item) {
                item.parentNode.classList.remove('active');
            });

            // 모든 nav_sub 항목에서 'active' 클래스 제거
            navSubLinks.forEach(function (item) {
                item.parentNode.classList.remove('active');
            });

            // 클릭된 nav_sub 항목에 'active' 클래스 추가
            this.parentNode.classList.add('active');
        });
    });
});
</script>

<style>
.nav-item{
    font-family: pretendard;
}
/* 기본 사이드바 스타일 */
.main-sidebar {
    background-color: #ffffff !important;
}

.nav-sidebar .nav-link {
    color: #000000 !important;
}

.nav-treeview {
    background-color: #ffffff !important;
}

.nav-treeview .nav-link {
    color: #000000 !important;
}

.nav-sidebar .nav-link:hover {
    color: #FD5D6C !important; /* hover 상태 색상 */
}

/* 클릭된 nav_main 항목의 스타일 */
.nav-sidebar .nav-item.nav_main.active .nav-link {
    color: #FD5D6C !important; /* 클릭된 nav_main 항목의 글자색 */
    background-color: rgba(253, 93, 108, 0.15) !important; /* 클릭된 nav_main 항목의 배경색 */
}

/* 클릭된 nav_sub 항목의 스타일 */
.nav-sidebar .nav-item.nav_sub.active .nav-link {
    color: #FD5D6C !important; /* 클릭된 nav_sub 항목의 글자색 */
    background-color: rgba(253, 93, 108, 0.15) !important; /* 클릭된 nav_sub 항목의 배경색 */
}

/* 기본 nav_sub 항목의 스타일 */
.nav-sidebar .nav-item.nav_sub .nav-link {
    color: #000000 !important; /* 기본 글자색 */
    background-color: #ffffff !important; /* 기본 배경색 */
}

/* 기본 nav_main 항목의 스타일 */
.nav-sidebar .nav-item.nav_main .nav-link {
    color: #000000 !important; /* 기본 글자색 */
    background-color: #ffffff !important; /* 기본 배경색 */
}

.nav_sub{
	text-align: center;
}
</style>

<aside class="main-sidebar sidebar-dark-primary elevation-4">

	<!-- Sidebar -->
	<div class="sidebar">
		<!-- Sidebar user panel (optional) -->
		<div class=" mt-3 pb-3 ">
		</div>
			<div class="image">
				<img src="/resources/icon/ReadyGo-로고(핑크).png"
					alt="Logo">
			</div>

		<!-- Sidebar Menu -->
		<nav class="mt-2">
			<ul class="nav nav-pills nav-sidebar flex-column"
				data-widget="treeview" role="menu" data-accordion="false">
				<!-- Add icons to the links using the .nav-icon class
               with font-awesome or any other icon font library -->
				<li class="nav-item"><a href="#" class="nav-link"> 
					<img src="/resources/icon/회원관리.png" alt="icon">
						<p class="nav_main">
							회원 관리 <i class="fas fa-angle-left right"></i>
						</p>
				</a>
					<ul class="nav nav-treeview">
						<li class="nav-item nav_sub">
							<a href="#"class="nav-link">
								<p>일반회원 이용제한</p>
							</a>
						</li>
					</ul>
				</li>
				<li class="nav-item nav_main"><a href="#" class="nav-link"> 
					<img src="/resources/icon/기업승인관리.png" alt="icon">
						<p>
							기업 승인 관리
						</p>
					</a>
				</li>			
				<li class="nav-item nav_main"><a href="#" class="nav-link"> 
					<img src="/resources/icon/공통코드관리.png" alt="icon">
						<p>
							공통 코드 관리
						</p>
					</a>
				</li>				
				<li class="nav-item"><a href="#" class="nav-link"> 
					<img src="/resources/icon/커뮤니티 관리.png" alt="icon">
						<p class="nav_main">
							커뮤니티 관리 <i class="fas fa-angle-left right"></i>
						</p>
				</a>
					<ul class="nav nav-treeview">
						<li class="nav-item nav_sub">
							<a href="#"class="nav-link">
								<p>공지 게시판</p>
							</a>
						</li>
						<li class="nav-item nav_sub">
							<a href="#"class="nav-link">
								<p>자유 게시판</p>
							</a>
						</li>
						<li class="nav-item nav_sub">
							<a href="#"class="nav-link">
								<p>문의 게시판</p>
							</a>
						</li>
						<li class="nav-item nav_sub">
							<a href="#"class="nav-link">
								<p>FAQ 게시판</p>
							</a>
						</li>
						<li class="nav-item nav_sub">
							<a href="#"class="nav-link">
								<p>외주 리뷰 게시판</p>
							</a>
						</li>
						<li class="nav-item nav_sub">
							<a href="#"class="nav-link">
								<p>신고 게시판</p>
							</a>
						</li>		
					</ul>
				</li>
			</ul>
		</nav>
		<!-- /.sidebar-menu -->
	</div>
		<div class="nav-item"
			style="position: absolute; right: 0px; bottom: 0px;">
			<a href="#" style="color: #828282;"> 로그아웃 &nbsp;&nbsp;&nbsp;&nbsp;</a><br>
		</div>
	<!-- /.sidebar -->
</aside>