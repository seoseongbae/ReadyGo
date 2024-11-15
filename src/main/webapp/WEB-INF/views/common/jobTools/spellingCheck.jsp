<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<script type="text/javascript" src="../resources/js/jquery.min.js"></script>
<script>
$(document).ready(function() {
    $('#textInput').on('input', function() {
        const text = $(this).val();
        const textSpaces = text.replace(/ /g, '');
        
        $('#InSpacesCount').text(text.length); // 공백 포함
        $('#NoSpacesCount').text(textSpaces.length); // 공백 미포함
        $('#InSpacesByte').text(new Blob([text]).size); // 공백 포함 바이트 수
        $('#NoSpacesByte').text(new Blob([textSpaces]).size); // 공백 미포함 바이트 수
    });
});	
</script>


<!-- 1행 영역 -->
<h3>취업TOOL</h3>
<div class="row">
	<!-- /// 리스트 시작 /// -->
	<div class="col-md-8" style="width: 100%;">
		<div class="card2">
			<div class="card2-body">

				<div id="categoryTap">
					<input type="button" id="spelling" value="글자수세기" onclick="location.href='/common/jobTools/spellingCheck'"> 
					<input type="button" id="salary" value="연봉 계산기" onclick="location.href='/common/jobTools/salaryCal'">
					<input type="button" id="netPay" value="실수령액 계산기" onclick="location.href='/common/jobTools/netPayCal'">
					<input type="button" id="credit" value="학점 변환기" onclick="location.href='/common/jobTools/creditTrans'">
					<input type="button" id="language" value="어학점수 변환기" onclick="location.href='/common/jobTools/languageTrans'">
				</div>
				
				<!-- 맞춤법검사, 글자수세기 시작 -->
				<div id="spellingPage">
					<!-- 텍스트 입력 Div -->
					<div id="inputDiv">
						 <textarea id="textInput" placeholder="내용을 입력해주세요"></textarea>
						<hr>
							<div id="textCount">
							 <p>공백 포함 : <span id="InSpacesCount">0</span>자 <span style="color:#D9D9D9;">|</span>
							 <span id="InSpacesByte">0</span>byte</p>
    						 <p>공백 미포함 : <span id="NoSpacesCount">0</span>자 <span style="color:#D9D9D9;">|</span>
    						 <span id="NoSpacesByte">0</span>byte</p>
							</div>
					</div>
				</div> <!-- 맞춤법검사, 글자수세기 끝  -->
			</div>
		</div>
	</div>
</div>

<style> 


#categoryTap {
	display: flex;
	align-items: center;
	border-top: 1px solid #ccc; 
	justify-content: center;
}

#spelling, #salary, #netPay, #credit, #language{
	width: 100%;
	height: 70px;
	font-size : 14px;
	border: none; 
    background: none; 
    cursor: pointer;
	transition: background-color 0.3s;
	
}
#spelling{
	text-decoration: underline;
	color : #24D59E;
}

#categoryTap input[type="button"]:hover {
    color: #24D59E;
    text-decoration: underline;
}

.row {
	margin: 0px 24% 0px 24%;
 	min-height : 650px;
}

h3 {
margin : 50px 0px 15px 26%;
}

#spellingPage{
	height : 480px;
}
#inputDiv{
	width : 100%;
	height : 480px;
	border : 1px solid #ccc; 
	background-color: rgba(245, 255, 255, 1);
}

#inputDiv textarea {
    margin: 30px 40px 20px 45px;
    width: 90%;
    height: 35vh;
    border: 1px solid #D9D9D9;
    resize: none;
}
#inputDiv textarea:focus {
     outline: none; /* 기본 아웃라인 제거 */ 
}
hr {
	height: 1px;
	color : #D9D9D9;
	background-color: #D9D9D9;
	margin: 10px 0;
}

#textCount p{
	font-size: 12px;
	margin-left : 30px;
}

#checkBtn {
color: white;
background-color: #24D59E;
border: 1px solid #EBEBEB;
border-radius: 5px;
width: 120px;
padding: 8px 20px 8px 20px;
transition: all 0.3s ease 0s;
}

#checkBtn:hover {
background-color: #24D59E;
color: white;
}
#InSpacesCount, #NoSpacesCount{
color : #FF511C;
font-weight: bold;
}
#InSpacesByte, #NoSpacesByte{
	color : black;
	font-weight: bold;
}

</style>