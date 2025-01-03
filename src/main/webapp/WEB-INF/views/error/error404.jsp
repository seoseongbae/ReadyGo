<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<script type="text/javascript" src="/resources/js/jquery.min.js"></script>
<style>
.error-page{
	height: auto;
}
img{
	width: 600px;
}
</style>
<section class="content">
	<div class="error-page">
		<div class="error-content">
		<img src="/resources/images/404.jpg">
			<h3>
				<i class="fas fa-exclamation-triangle text-warning"></i> 
				Oops! Page Not Found.
			</h3>
			<p>
				요청한 문서를 찾지 못했습니다.
				<a href="/">return to main</a>
			</p>
		</div>
	</div>
</section>