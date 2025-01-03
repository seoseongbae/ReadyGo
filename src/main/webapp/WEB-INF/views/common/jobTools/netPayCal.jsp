<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<script type="text/javascript" src="../resources/js/jquery.min.js"></script>
<script>
$(document).ready(function() {
	// 연봉 입력값 포맷팅
    $('#inputSalary').on('input', function() {
        const value = $(this).val().replace(/,/g, ''); // 콤마 제거
        $(this).val(value.replace(/\B(?=(\d{3})+(?!\d))/g, ',')); // 콤마 추가
    });

    // 비과세액 입력값 포맷팅
    $('#nonTaxable').on('input', function() {
        const value = $(this).val().replace(/,/g, ''); // 콤마 제거
        $(this).val(value.replace(/\B(?=(\d{3})+(?!\d))/g, ',')); // 콤마 추가
    });
	
	$('.plus').on('click', function() {
        const inputId = $(this).siblings('input').attr('id'); // 입력 필드의 ID 가져오기
        const input = $('#' + inputId); // 해당 ID의 입력 필드 선택
        let value = parseInt(input.val()) || 0; // 현재 값 가져오기
        value = Math.min(value + 1, 99); // 0~99 범위 제한
        input.val(value); // 값 업데이트
        calculateSalary(); 
    });

    $('.minus').on('click', function() {
        const inputId = $(this).siblings('input').attr('id'); // 입력 필드의 ID 가져오기
        const input = $('#' + inputId); // 해당 ID의 입력 필드 선택
        let value = parseInt(input.val()) || 0; // 현재 값 가져오기
        value = Math.max(value - 1, 0); // 0 이하로 떨어지지 않도록 제한
        input.val(value); // 값 업데이트
        calculateSalary(); 
    });
    
    
    $('#inputSalary, #nonTaxable, input[name="severance"], #family, #children').on('input change', calculateSalary);
    $('.plus, .minus').on('click', calculateSalary);
    
    function calculateSalary() {
        const inputSalary = parseFloat($('#inputSalary').val().replace(/,/g, '')) || 0;  // 실수령액
        const severance = $('input[name="severance"]:checked').val(); // 퇴직금 포함 여부
        const nonTaxable = parseFloat($('#nonTaxable').val().replace(/,/g, '')) || 200000; // 비과세액
        const family = parseInt($('#family').val()) || 1; // 부양 가족 수
        const children = parseInt($('#children').val()) || 0; // 20세 이하 자녀 수

        // 예상 과세표준 계산
        let monthlySalary = inputSalary + nonTaxable; // 사용자가 입력하는 실수령액
        let yearlySalary = monthlySalary * 12; // 연봉

        // 각종 사회보험료 계산
        const nationalPension = Math.min(Math.max(16650, monthlySalary * 0.045), 265500); // 국민연금
        const healthInsurance = Math.max(9890, monthlySalary * 0.03545); //건강보험
        const longTermCare = Math.max(1280, healthInsurance * 0.1295);
        const employmentInsurance = Math.max(0, monthlySalary * 0.009);

        // 총 공제액 계산
        const totalDeductions = nationalPension + healthInsurance + longTermCare + employmentInsurance; 

        // 세전 소득 계산
        const taxableIncome = Math.max(0, yearlySalary - totalDeductions * 12);

        // 소득세 계산
        const yearlyTax = calculateTax(taxableIncome, family, children, severance);
        const monthlyTax = yearlyTax / 12;
        const localIncomeTax = monthlyTax * 0.1;

        // 총 공제액 업데이트
        const finalDeductions = totalDeductions + monthlyTax + localIncomeTax;

        // 예상 실제 연봉 계산
        const estimatedYearlySalary = Math.max(0, (yearlySalary - finalDeductions * 12));

        // 결과 업데이트
        $('#nationalPension').text(Math.floor(nationalPension).toLocaleString());
        $('#healthInsurance').text(Math.floor(healthInsurance).toLocaleString());
        $('#longTermCare').text(Math.floor(longTermCare).toLocaleString());
        $('#employmentInsurance').text(Math.floor(employmentInsurance).toLocaleString());
        $('#incomeTax').text(Math.floor(monthlyTax).toLocaleString());
        $('#localIncomeTax').text(Math.floor(localIncomeTax).toLocaleString());
        $('#totalDeductions').text(Math.floor(finalDeductions).toLocaleString());
        $('#yearSalary').text(Math.floor(estimatedYearlySalary).toLocaleString());
    };
    
    function calculateTax(yearlyTaxableIncome, family, children) {
        let deduction = 0;
        const baseAmount = 30000000; // 3천만원

     	// 공제 대상 가족 수에 따른 공제액 계산
        if (family === 1) {
        if (yearlyTaxableIncome <= baseAmount) {
            deduction = yearlyTaxableIncome * 0.04;
        } else if (yearlyTaxableIncome <= 45000000) {
            deduction = baseAmount * 0.04 + (yearlyTaxableIncome - baseAmount) * 0.05;
        } else if (yearlyTaxableIncome <= 70000000) {
            deduction = baseAmount * 0.015;
        } else {
            deduction = baseAmount * 0.005;
        }
        } else if (family === 2) {
            if (yearlyTaxableIncome <= baseAmount) {
                deduction = 360000 + yearlyTaxableIncome * 0.04;
            } else if (yearlyTaxableIncome <= 45000000) {
                deduction = 360000 + yearlyTaxableIncome * 0.04 - (yearlyTaxableIncome - baseAmount) * 0.05;
            } else if (yearlyTaxableIncome <= 70000000) {
                deduction = 360000 + yearlyTaxableIncome * 0.02;
            } else {
                deduction = 360000 + yearlyTaxableIncome * 0.01;
            }
        } else { // family >= 3
            if (yearlyTaxableIncome <= baseAmount) {
                deduction = 500000 + yearlyTaxableIncome * 0.07 + Math.max(0, yearlyTaxableIncome - 40000000) * 0.04;
            } else if (yearlyTaxableIncome <= 45000000) {
                deduction = 500000 + yearlyTaxableIncome * 0.07 - (yearlyTaxableIncome - baseAmount) * 0.05 + Math.max(0, yearlyTaxableIncome - 40000000) * 0.04;
            } else if (yearlyTaxableIncome <= 70000000) {
                deduction = 500000 + yearlyTaxableIncome * 0.05 + Math.max(0, yearlyTaxableIncome - 40000000) * 0.04;
            } else {
                deduction = 500000 + yearlyTaxableIncome * 0.03 + Math.max(0, yearlyTaxableIncome - 40000000) * 0.04;
            }
        }

        // 인적공제
        const personalDeduction = 1500000 * family; // 기본공제: 1인당 150만원
        const childDeduction = children * 1500000; // 자녀공제: 20세 이하 자녀 1인당 150만원

        // 과세표준
        const taxableIncome = Math.max(0, yearlyTaxableIncome - deduction - personalDeduction - childDeduction);

        // 세액 계산 (누진세 적용)
        let tax = 0;
        if (taxableIncome <= 12000000) {
            tax = taxableIncome * 0.06;
        } else if (taxableIncome <= 46000000) {
            tax = 720000 + (taxableIncome - 12000000) * 0.15;
        } else if (taxableIncome <= 88000000) {
            tax = 5820000 + (taxableIncome - 46000000) * 0.24;
        } else if (taxableIncome <= 150000000) {
            tax = 15900000 + (taxableIncome - 88000000) * 0.35;
        } else if (taxableIncome <= 300000000) {
            tax = 37600000 + (taxableIncome - 150000000) * 0.38;
        } else if (taxableIncome <= 500000000) {
            tax = 94600000 + (taxableIncome - 300000000) * 0.40;
        } else if (taxableIncome <= 1000000000) {
            tax = 174600000 + (taxableIncome - 500000000) * 0.42;
        } else {
            tax = 384600000 + (taxableIncome - 1000000000) * 0.45;
        }

        // 세액공제 (근로소득세액공제)
        let taxCredit = (tax <= 1300000) ? (tax * 0.55) : (715000 + (tax - 1300000) * 0.30);

        // 자녀세액공제
        let childTaxCredit = 0;
        if (children === 1) {
            childTaxCredit = 12500;
        } else if (children === 2) {
            childTaxCredit = 29160;
        } else if (children > 2) {
            childTaxCredit = 29160 + (children - 2) * 25000;
        }

        return Math.max(0, Math.floor(tax - taxCredit - childTaxCredit));
    };
    
 	// 초기화 버튼 동작 추가
    $('#reset').on('click', function() {
        $('#inputSalary').val('');
        $('#nonTaxable').val('200,000');
        $('#family').val('1');
        $('#children').val('0');
        $('#netSalary').text('0');
        $('#nationalPension').text('0');
        $('#healthInsurance').text('0');
        $('#longTermCare').text('0');
        $('#employmentInsurance').text('0');
        $('#incomeTax').text('0');
        $('#localIncomeTax').text('0');
        $('#totalDeductions').text('0');

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
				<div id="netPayCalPage">
					<!-- 텍스트 입력 Div -->
					<div id="inputText">
						<p>필수입력</p>

					        <label class="title">퇴직금</label>
					        <div class="flex-container">
					        <div class="btnDiv">
					            <div class="btn-group btn-group-toggle custom-btn-group" data-toggle="buttons">
					                <label class="btn btn-secondary">
					                    <input type="radio" name="severance" id="option_a3" autocomplete="off" checked="" value="N"> 별도
					                </label>
					                <label class="btn btn-secondary">
					                    <input type="radio" name="severance" id="option_a4" autocomplete="off"  value="Y"> 포함
					                </label>
					            </div>
					        </div>
					    	</div>
					    <label class="title">월 실수령액</label>
						<input type="text" id="inputSalary" value=""pattern="[0-9]*" oninput="this.value = this.value.replace(/[^0-9]/g, '')">&nbsp;<span style="font-weight: 600 !important; font-size: 14px;">원</span>
						
						<hr>
						<p>선택입력</p>
							<label class="subtitle">부양 가족 수(본인포함)</label><label class="subtitle">20세 이하 자녀수</label>
					        <div class="flex-container">
						        <div class="btnDiv">
						            <button type="button" class="minus">-</button>
									<input type="text" id="family" value="1" maxlength="2" style="text-align: center;">
									<button type="button" class="plus" >+</button>
						        </div>
						        <div class="btnDiv">
						             <button type="button" class="minus">-</button>
									 <input type="text" id="children" value="0" maxlength="2" style="text-align: center;">
									 <button type="button" class="plus">+</button>
						    	</div>
					    	</div>
					    <label class="subtitle">비과세액</label><br>
						<input type="text" id=nonTaxable value="200,000"pattern="[0-9]*" oninput="this.value = this.value.replace(/[^0-9]/g, '')">&nbsp;<span style="font-weight: 400 !important; font-size: 12px;">원</span>
					</div>
					<!-- 결과출력 Div -->
					<div id="result">
						<div id="topDiv">
						<p id="topText">예상 연봉</p>
						<p><span id="yearSalary">0</span> 원</p>
						</div>
						<div id="resultBox">
						<p>한 달 기준 공제액</p>
						<table class="table table-bordered custom-table">
							<tbody>
							<tr>
							<td>국민연금</td><td class="text-right"><span id="nationalPension">0</span>원</td>
							</tr>
							<tr>
							<td>건강보험</td><td class="text-right"><span id="healthInsurance">0</span>원</td>
							</tr>
							<tr>
							<td>장기요양</td><td class="text-right"><span id="longTermCare">0</span>원</td>
							</tr>
							<tr>
							<td>고용보험</td><td class="text-right"><span id="employmentInsurance">0</span>원</td>
							</tr>
							<tr>
							<td>소득세</td><td class="text-right"><span id="incomeTax">0</span>원</td>
							</tr>
							<tr>
							<td>지방소득세</td><td class="text-right"><span id="localIncomeTax">0</span>원</td>
							</tr>
							<tr>
							<td><b>공제액 합계</b></td><td class="text-right"><b><span id="totalDeductions">0</span>원</b></td>
							</tr>
							</tbody>
						</table>
						</div>
						<button id="reset" type="button">초기화</button>
					</div>
				</div> <!-- 실수령액 계산기 끝  -->
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

#netPay{
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

#netPayCalPage{
	height : 450px;
	display : flex;
}
 #inputText{ 
 	width : 60%; 
 	height : 450px; 
 	border : 1px solid #ccc;  
 	background-color: rgba(245, 255, 255, 1); 
 	padding : 5px;
 } 

#result{
	width : 40%;
	height : 450px;
	border : 1px solid #ccc;
	border-left : none;
	display: flex; 
    flex-direction: column; /* 세로 방향으로 쌓이도록 설정 */
    align-items: center;  
}
hr {
	height: 1px;
	color : #D9D9D9;
	background-color: #D9D9D9;
	margin: 10px 0;
}

#topDiv{
	width : 100%;
	background: linear-gradient(to right, #2CCFC3, #24D59E);
	height: 60px;
	align-items: center;
	padding: 10px 15px 10px 15px;
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
margin-top: 10px;

}

#reset:hover {
background-color: #24D59E;
color: white;
}
#resultBox {
	margin: 10px 0;
    width: 100%;
    display: flex;
    flex-direction: column;
    height: 300px;
    padding: 0px 10px 0px 10px;

}
#resultBox p {
    font-size: 12px;
}
#resultBox table{
	width : 100%;
}
.custom-table {
    border-collapse: collapse; /* 테두리 겹침 방지 */
     border-left: none; /* 세로선 제거 */
    border-right: none; /* 세로선 제거 */
}

.custom-table td {
	padding : 10px 20px 10px 20px;
    border-left: none; /* 세로선 제거 */
    border-right: none; /* 세로선 제거 */
    font-size: 12px;
}

.custom-btn-group .btn {
    background-color: white; 
    color: #6B6B6B; 
    border-radius: 1px;
    border: 1px solid #D9D9D9;
    font-size: 14px;
    font-weight: 400;
    padding: 10px 15px;
}

.custom-btn-group .btn.active {
    background-color: #6B6B6B; /* 활성화된 버튼 색상 */
     color: white;
}

.custom-btn-group .btn:hover {
    background-color: #6B6B6B; /* 호버 시 색상 */
     color: white;
}
#inputText p{
	font-size: 12px;
	font-weight: bold;
}

.flex-container {
display : flex;
    align-items: center; /* 수직 정렬 */
}


.title {
	margin: 0px 11% 10px 15%;
	font-weight: 600 !important;
	font-size: 14px;
}

.btnDiv{
	margin: 0px 1% 20px 15%;
}

.btnDiv #family, #children, .minus, .plus{
    margin: 0; /* 버튼의 기본 마진 제거 */
    border: 1px solid #D9D9D9;
    color : #6B6B6B;
    
}
#inputSalary{
	margin : 0 0 10px 15%;
	width : 60%;
	height: 50px;
	font-size: 16px;
	text-align: right;
	border: 1px solid #D9D9D9;
}
#nonTaxable{
	margin : 0 0 10px 15%;
	width : 30%;
	height: 30px;
	font-size: 12px;
	text-align: right;
	border: 1px solid #D9D9D9;
}
#family, #children, .minus, .plus{
	width: 35px;
    height: 35px;
    margin: 0;
}
.subtitle{
	margin: 0px 2.5% 10px 15%;
	font-weight: 400 !important;
	font-size: 12px;
}

#topDiv p{
	color : white;
	font-size: 12px;
	font-weight: bold;
	line-height: 20px;
}
#yearSalary{
	color : white;
	font-size: 18px;
	font-weight: bold;
}
.text-right {
        text-align: right;
    }

</style>