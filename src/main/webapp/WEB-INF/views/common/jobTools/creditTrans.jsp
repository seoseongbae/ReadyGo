<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<script type="text/javascript" src="../resources/js/jquery.min.js"></script>
<script>
function calculateGrade() {
    let averageGrade = parseFloat($('.inputStyle[type=text]').val());
    let currentScale = parseFloat($('#gradeScale').val()); // 현재 기준
    let newScale = [4.0, 4.3, 4.5, 5.0, 7.0, 100]; // 변환할 기준
    let results = [];
    
 // 입력값이 현재 기준 학점을 넘는지 확인
    if (averageGrade > currentScale) {
        alert(`입력된 평균 학점(\${averageGrade})이 기준 학점(\${currentScale})을 초과합니다.`);
        return; // 계산 중지
    }

    if (!isNaN(averageGrade)) {
        newScale.forEach(scale => {
            let convertedScore = (averageGrade / currentScale) * scale;
            if (scale === 100) {
            	results.push(Math.round(convertedScore)  + '&nbsp;&nbsp;<b>/&nbsp;' + scale);
            }else{
            	results.push(convertedScore.toFixed(2) + '&nbsp;&nbsp;<b>/&nbsp;' + scale.toFixed(1));
            }
        });

        // 결과를 두 개씩 나란히 출력
        let resultHtml = `
            <div class="resultRow">
                <div>\${results[0]}만점</b></div>
                <div>\${results[2]}만점</b></div>
                <div>\${results[4]}만점</b></div>
            </div>
            <div class="resultRow">
                <div>\${results[1]}만점</b></div>
                <div>\${results[3]}만점</b></div>
                <div>\${results[5]}점만점</b></div>
            </div>
        `;
        $('#resultBox').html(resultHtml);
    } else {
        $('#resultBox').html('<p>유효한 학점을 입력해주세요.</p>');
    }
}
$(document).ready(function() {
	$('#reset').on('click', function() {
	    $('.inputStyle[type=text]').val(''); // 평균 학점 입력 필드 비우기
	    $('#gradeScale').val('4.5'); // 학점 기준 초기화
	    $('#resultBox').html('<p>학점을 입력해주세요</p>'); // 결과 박스 초기화
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
				<div id="creditTransPage">
					<!-- 텍스트 입력 Div -->
					<div id="inputText">
					<label class="title">나의 평균 학점</label><br>
						<div id="inputDiv">
							<input class="inputStyle" type="text" placeholder="0.00"
							 oninput="this.value = this.value.replace(/[^0-9.]/g, ''); 
                                          if (this.value.split('.').length > 2) this.value = this.value.replace(/\.+$/, ''); 
                                          if (parseFloat(this.value) > 100) this.value = 100;
                                          calculateGrade();"> /
							<select class="inputStyle"  id="gradeScale" onchange="calculateGrade();" style="font-weight:bold;">
								<option>4.0</option>
								<option>4.3</option>
								<option selected>4.5</option>
								<option>5.0</option>
								<option>7.0</option>
								<option>100</option>
							</select>
							&nbsp;<span style="font-weight: 400 !important; font-size: 12px;">기준</span>
						</div>
					</div>
					<!-- 결과출력 Div -->
					<div id="result">
						<div id="topDiv">
						<p>변환 결과</p>
						</div>
						<div id="resultBox">
						<p>학점을 입력해주세요</p>
						</div>
						<button id="reset" type="button">초기화</button>
					</div>
				</div>
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

#credit{
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

#creditTransPage{
	height : 280px;
	display : flex;
}
#inputText{
	width : 60%;
	height : 280px;
	border : 1px solid #ccc; 
	background-color: rgba(245, 255, 255, 1);
}

#result{
	width : 40%;
	height : 280px;
	border : 1px solid #ccc;
	border-left : none;
	display: flex; 
    flex-direction: column; /* 세로 방향으로 쌓이도록 설정 */
    align-items: center;  
}

.title {
	margin: 70px 11% 10px 15%;
	font-weight: 600 !important;
	font-size: 14px;
}

#textCount p{
	font-size: 12px;
}

#topDiv{
	width : 100%;
	background: linear-gradient(to right, #2CCFC3, #24D59E);
	height: 60px;
	align-items: center;
	padding: 15px;
}

#topDiv p{
	color : white;
	font-size: 17px;
}

#reset {
float: right;
color: white;
background-color: #24D59E;
border: 1px solid #EBEBEB;
border-radius: 5px;
width: 120px;
padding: 8px 20px 8px 20px;
transition: all 0.3s ease 0s;
}

#reset:hover {
background-color: #24D59E;
color: white;
}
#resultBox {
	width : 100%;
	display : flex;
	justify-content: center; /* 가로 방향 중앙 정렬 */
    align-items: center; 
    height : 140px;
    margin : 10px;
}
.inputStyle{
	height : 40px;
	width : 110px;
	border: 1px solid #D9D9D9;
}
#inputDiv{
	margin : 2% 0 0 15%;
}
.resultRow {
    display: block; /* Flexbox 사용 */ 
/*     margin : 10px 10px ; */
}
.resultRow > div { 
    margin: 10px 10px; /* 좌우 간격을 10픽셀로 설정 */
} 
</style>