
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/security/tags"
	prefix="sec"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<sec:authorize access="isAuthenticated()">
	<sec:authentication property="principal.memVO" var="memVO" />
</sec:authorize>
<script src="https://cdn.jsdelivr.net/npm/sockjs-client@1/dist/sockjs.min.js"></script><!-- 웹소켓 -->

<!-- 외주 css 파일 -->
<link rel="stylesheet"
	href="<%=request.getContextPath()%>/resources/css/outsou/payok.css" />


<div class="payokPage">


	<div class="okimg">

		<div class="imgBox">
			<img src="../resources/icon/buy.png" alt="buy.png"
				 class="buyImg"/>
		</div>



		<div class="oktext">
			<h3 class="text">신청 완료</h3>
			<h5 class="text">신청이 완료되었습니다.</h5>
			<h5 class="text">결제내역은 Ready Go마이페이지를 통해 확인할 수 있습니다.</h5>
		</div>

		<div class="hr"></div>
			<div class="prodOk" >
					<p> 상  품  명 : ${title} </p>
					<div class="hr2"></div>
					<p> 주문 날짜 : ${orderDate} </p>
			</div>

		<div id="editBox">
			
			<p>
				<a href="#"><input type="button" class="okbtn" id="paycont"
					value="결제내역" /></a> <a href="/"><input type="button" class="okbtn"
					id="goMainbtn" value="Ready Go" /></a> <a href="../outsou/main"><input
					type="button" class="okbtn" id="upMainbtn" value="Ready Up" /></a>
			</p>

		</div>

	</div>

</div>
