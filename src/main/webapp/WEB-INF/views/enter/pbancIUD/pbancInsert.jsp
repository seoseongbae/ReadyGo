<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="sec"
   uri="http://www.springframework.org/security/tags"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script type="text/javascript"
   src="//dapi.kakao.com/v2/maps/sdk.js?appkey=eaad16168d2cb5b733bf76e1a41ced77&libraries=services"></script>
<link rel="stylesheet"
   href="<%=request.getContextPath()%>/resources/css/enter/pbancInsert.css" />
   <link rel="stylesheet" href="<%=request.getContextPath()%>/resources/css/alert.css" />
   <script src="https://cdn.jsdelivr.net/npm/sweetalert2@10"></script>
<script type="text/javascript" src="/resources/js/jquery.min.js"></script>
<script type="text/javascript" src="/resources/ckeditor5/ckeditor.js"></script>
<script type="text/javascript"
   src="/resources/ckeditor5/sample/css/sample.css"></script>
<style type="text/css">
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
</head>
<div style="position:fixed;bottom: 0; right: 0; display: flex; flex-direction: column; padding: 20px;">
	<button class="ddalkkack" id="mg">딸깍</button>
</div>
<body>
   <sec:authentication property="principal" var="prc" />
   <c:if test="${prc ne 'anonymousUser'}">
      <input type="hidden" id="hasRoleEnter" value="${prc.authorities}" />
   </c:if>
   <c:if test="${prc  ne 'anonymousUser'}">
      <c:if test="${prc.authorities eq '[ROLE_ENTER]'}">
         <h2>공고 등록</h2>
         <div class="background">
            <!-- 담 당자 정보 -->
            <section class="section">
               <h4>기업 정보</h4>
               <h5>먼저 기업 정보가 맞는지 확인해주세요</h5>
               <div class="flexPbanc">
                  <div>
                     <div class="form-group">
                        <label for="entRprsntvNm"><b>*</b> 대표자 성함</label>
                        <p class="enterInfo">${enterVO.entRprsntvNm}</p>
                     </div>
                     <div class="form-group">
                        <label for="tpbizCd"><b>*</b> 업종</label>
                        <p class="enterInfo">${enterVO.tpbizSeCd}</p>
                     </div>
                     <div class="form-group">
                        <label for="location"><b>*</b> 대표 근무지역</label>
                        <p class="enterInfo">(${enterVO.entZip})
                           ${location.entAddr}, ${location.entAddrDetail}</p>
                     </div>
                     <div id="staticMap" class="map"
                        style="width: 960px; height: 300px;"></div>
                  </div>


                  <div style="margin-left: -380px;">
                     <div class="form-group multi-input">
                        <label for="entFxnum"><b>*</b> 팩스번호</label>
                        <p class="enterInfo">${enterVO.entFxnum}</p>
                     </div>
                     <div class="form-group">
                        <label for="entMail"><b>*</b> 이메일 주소</label>
                        <p class="enterInfo">${enterVO.entMail}</p>
                     </div>
                  </div>
               </div>
               <div class="sec1-btn">
                  <a href="/enter/edit?entId=${prc.username}">
                     <button type="button" class="modalOk" id="up-btn">수정</button>
                  </a>
                  <button type="button" class="modalGo">확인</button>
               </div>
               <p class="sec1-p">기업 정보 수정 필요 시 '수정', 기업 정보가 모두 일치 시 '확인' 버튼을
                  클릭해주세요.</p>
            </section>

<!-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////// -->

            <form name="pbancInsert" id="pbancInsert" method="post"
               
               enctype="multipart/form-data">
               <!-- 모집 정보 -->
               <section class="section" hidden="hidden">
                  <input type="hidden" id="entId" name="entId"
                     value="${enterVO.entId}" />
                  <h4>모집 분야</h4>
                  <h5>어떤일을 담당할 직원을 찾으시나요?</h5>
                  <div class="flexPbanc">
                     <div>
                        <div class="form-group">
                           <label for="jobType"><b>*</b> 모집분야명</label> 
                           <input type="text"v id="jobType" name="rcritNm" placeholder="예: 앱개발자" required>
                           <input type="number" id="applicants" name="rcritCnt" min="0"
                              placeholder="0" required> 
                           <label for="applicants"><b>*</b> 명 모집</label>
                        </div>
                        <div class="form-group radio-group">
                           <label for="pbancCareerCd"><b>*</b> 경력여부</label>
                           <div>
                              <select class="input-detail" name="pbancCareerCd" required>
                                 <option value="" selected disabled>선택해주세요</option>
                                 <c:forEach var="pbancVO" items="${getRecruitmentCD}"
                                    varStatus="status">
                                    <option value="${pbancVO.comCode}">${pbancVO.comCodeNm}</option>
                                 </c:forEach>
                              </select>
                           </div>
                        </div>
                        <div class="form-group">
                           <label for="rcritJbttlCd"><b>*</b> 직급/직책</label> <select
                              class="input-detail" name="rcritJbttlCd" required>
                              <option value="" selected disabled>선택해주세요</option>
                              <c:forEach var="pbancVO" items="${getRcritJbttlCD}"
                                 varStatus="status">
                                 <option value="${pbancVO.comCode}">${pbancVO.comCodeNm}</option>
                              </c:forEach>
                           </select>
                        </div>
                     </div>
                     <div>
                        <div class="form-group">
                           <label for="rcritDept" class="noneStar">근무부서</label> <input
                              type="text" id="work" name="rcritDept" placeholder="예: 개발팀">
                        </div>
                        <div class="form-group">
                           <label for="rcritTask" class="noneStar">담당업무</label> <input
                              type="text" id="task" name="rcritTask"
                              placeholder="예: 앱 개발 및 유지보수">
                        </div>
                        <div class="form-group">
                           <label for="tpbizCd"><b>*</b> 모집업종</label> <select
                              class="input-detail" id="tpbizCd" name="tpbizCdList" multiple
                              size="5" required>
                              <option value="" selected disabled>선택해주세요</option>
                              <c:forEach var="pbancVO" items="${getTpbizCD}"
                                 varStatus="status">
                                 <option value="${pbancVO.comCode}">${pbancVO.comCodeNm}</option>
                              </c:forEach>
                           </select>
                        </div>
                        <div id="selectedOptionsDiv"></div>
                     </div>
                  </div>
					<h6>
						<b class="bb">추가</b>를 클릭하면 필수/우대 조건을 추가할 수 있습니다.
					</h6>
					<div class="flexPbanc">
						<div>
							<div class="form-group" id="ll">
								<label for="pvLtCn"><b>*</b> 필수 조건</label> 
								<input type="text" id="requiredCn" placeholder="예: 해당 직무 근무 경험">
								<button type="button" class="add-btn1">추가</button>
							</div>
							<div id="hiddenRequiredList"></div>
							<div id="dynamicList1"></div>
						</div>
						<div>
							<div class="form-group" id="rr">
								<label for="pvLtCn" class="noneStar"><b>*</b> 우대 조건</label> 
								<input type="text" id="preferCn" placeholder="예: 정보처리기사 자격증 ">
								<button type="button" class="add-btn2">추가</button>
							</div>
							<div id="hiddenPreferList"></div>
							<div id="dynamicList2"></div>
						</div>
					</div>	
                  <h6>
                     <b class="bb">추가</b>를 클릭하면 복지 및 혜택을 추가할 수 있습니다.
                  </h6>
                  <div class="flexPbanc">
                     <div>
                        <div class="form-group" id="ll">
                           <label for="pvLtCn" class="noneStar"><b>*</b> 복지 및 혜택</label> <input
                              type="text" id="favor"  placeholder="예: 점심시간 2시간">
                           <button type="button" class="add-btn3">추가</button>
                        </div>
                        <div id="dynamicList3"></div>
                        <div id="hiddenFavorList"></div>
                     </div>
                  </div>
               </section>

               <!-- 자격/조건 정보 -->
               <section class="section" hidden="hidden">
                  <h4>자격/조건</h4>
                  <h5>어떤일을 담당할 직원을 찾으시나요?</h5>
                  <div class="flexPbanc">
                     <div>
                        <div class="form-group">
                           <label for="pbancAplctEduCd"><b>*</b> 지원자 학력</label> <select
                              id="education" name="pbancAplctEduCd" required>
                              <option value="" selected disabled>선택해주세요</option>
                              <c:forEach var="pbancVO" items="${getPbancEduCD}"
                                 varStatus="status">
                                 <option value="${pbancVO.comCode}">${pbancVO.comCodeNm}</option>
                              </c:forEach>
                           </select>
                        </div>
                        <div class="form-group">
                           <label for="pbancSalary"><b>*</b> 연봉/급여</label> <select
                              id="salary-type">
                              <option value="연봉">연봉</option>
                              <option value="월급">월급</option>
                           </select> <select class="input-detail" id="salary-money"
                              name="pbancSalary" required>
                              <option value="" selected disabled>선택해주세요</option>
                              <c:forEach var="pbancVO" items="${getPbancSalaryCD}"
                                 varStatus="status">
                                 <option value="${pbancVO.comCode}">${pbancVO.comCodeNm}</option>
                              </c:forEach>
                           </select> <input type="text" id="additional-salary"
                              name="additional-salary" placeholder="기타 급여사항">
                        </div>
                        <p class="sal-standard">
                           최저시급 9,860원, 주 40시간 기준 최저연봉 2,060,740원 <a class="sal-line">최저임금제도
                              안내</a><br> 최저임금을 준수하지 않는 경우, 공고 강제 마감 및 행정처분을 받을 수 있습니다.
                        </p>
                     </div>
                     <!-- 최저임금제도 안내 모달 -->
                     <div id="salaryModal" class="modal">
                        <div class="modal-content">
                           <div class="flexPbancc">
                              <h2 id="salModal">최저임금제도 안내</h2>
                              <span class="close">&times;</span>
                           </div>
                           <div class="image-container">
                              <img src="../resources/images/enter/최저임금제도.jpg"
                                 alt="최저임금제도 이미지" style="width: 100%">
                           </div>

                           <p class="salModalCn">
                              <strong id="cnTitle">최저임금제도 목적</strong>
                              <button id="accordion-btn" class="accordion">보기</button>
                           </p>
                           <!-- 아코디언 내용 -->
                           <br>
                           <div id="accordion-content" class="accordion-content">
                              <p>최저임금제도는 근로자에 대하여 임금의 최저수준을 보장하여 근로자의 생활안정과 노동력의 질적 향상을
                                 꾀함으로써 국민경제의 건전한 발전에 이바지하게 함을 목적으로 함.(최저임금법 제1조)</p>
                              <p>최저임금제도의 실시로 최저임금액 미만의 임금을 받고 있는 근로자의 임금이 최저임금액 이상 수준으로
                                 인상되면서 다음과 같은 효과를 가져옴.</p>
                              <ul>
                                 <li>1. 저임금 해소로 임금격차가 완화되고 소득분배 개선에 기여</li>
                                 <li>2. 근로자에게 일정한 수준 이상의 생계를 보장해 줌으로써 근로자의 생활을 안정시키고 근로자의
                                    사기를 올려주어 노동생산성이 향상</li>
                                 <li>3. 저임금을 바탕으로 한 경쟁방식을 지양하고 적정한 임금을 지급토록 하여 공정한 경쟁을
                                    촉진하고 경영합리화를 기함.</li>
                              </ul>
                           </div>
                           <div class="modalBtn">
                              <button type="button" class="modalOk">확인</button>
                              <a
                                 href="https://www.minimumwage.go.kr/minWage/policy/decisionMain.do"
                                 target="_blank">
                                 <button type="button" class="modalGo">최저임금위원회</button>
                              </a>
                           </div>
                        </div>
                     </div>

                     <div style="margin-left: 80px;">
                        <div class="form-group">
                           <label for="pbancGenCd">지원자 성별</label> 
                           <select class="input-detail" id="gender" name="pbancGenCd">
                              <option value="" selected disabled>선택해주세요</option>
                              <c:forEach var="pbancVO" items="${getPbancGenCD}"
                                 varStatus="status">
                                 <option value="${pbancVO.comCode}">${pbancVO.comCodeNm}</option>
                              </c:forEach>
                           </select>
                        </div>
                        <div class="form-group">
                           <label for="pbancAgeCd">지원자 연령</label> <select
                              class="input-detail" id="age" name="pbancAgeCd">
                              <option value="" selected disabled>선택해주세요</option>
                              <c:forEach var="pbancVO" items="${getPbancAgeCD}"
                                 varStatus="status">
                                 <option value="${pbancVO.comCode}">${pbancVO.comCodeNm}</option>
                              </c:forEach>
                           </select>
                        </div>
                     </div>
                  </div>
                  <div class="flexPbanc">
                     <div>
                        <div class="form-group">
                           <label for="pbancWorkstleCd"><b>*</b> 근무형태</label>
                           <div class="checkbox-group">
                              <select class="input-detail" id="workstle"
                                 name="pbancWorkstleCd" required>
                                 <option value="" selected disabled>선택해주세요</option>
                                 <c:forEach var="pbancVO" items="${getPbancWorkstleCD}"
                                    varStatus="status">
                                    <option value="${pbancVO.comCode}">${pbancVO.comCodeNm}</option>
                                 </c:forEach>
                              </select>
                           </div>
                        </div>
                        <div class="form-group">
                           <label for="powkCd"><b>*</b> 근무지역</label>
                           <div class="powkCd">
                              <select class="input-detail" id="powkCd" name="powkList"
                                 multiple required>
                                 <option value="" selected disabled>선택해주세요</option>
                                 <c:forEach var="pbancVO" items="${powkCdList}"
                                    varStatus="status">
                                    <option value="${pbancVO.comCode}">${pbancVO.comCodeNm}</option>
                                 </c:forEach>
                              </select>
                           </div>
                        </div>
                     </div>
                     <div style="margin-left: 355px;">
                        <div class="form-group">
                           <label for="pbancWorkDayCd">근무요일</label> <select
                              class="input-detail" id="workday" name="pbancWorkDayCd">
                              <option value="" selected disabled>선택해주세요</option>
                              <c:forEach var="pbancVO" items="${getPbancWorkDayCD}"
                                 varStatus="status">
                                 <option value="${pbancVO.comCode}">${pbancVO.comCodeNm}</option>
                              </c:forEach>
                           </select>
                        </div>
                        <div class="form-group">
                           <label for="pbancWorkHrCd">근무시간</label> <select
                              class="input-detail" id="worktime" name="pbancWorkHrCd">
                              <option value="" selected disabled>선택해주세요</option>
                              <c:forEach var="pbancVO" items="${getPbancWorkHrCD}"
                                 varStatus="status">
                                 <option value="${pbancVO.comCode}">${pbancVO.comCodeNm}</option>
                              </c:forEach>
                           </select>
                        </div>
                     </div>
                  </div>
               </section>

               <!-- 채용절차 -->
               <section class="section" hidden="hidden">
                  <h4>채용 절차</h4>
                  <h5>채용 절차는 어떻게 되나요?</h5>
                  <div class="flexPbancc">
                     <div>
                        <div class="form-group">
                           <label for="pbancRprsDty"><b>*</b> 공고 대표 직무</label> <select
                              class="input-detail" id="pbancRprsDty" name="pbancRprsDty"
                              required>
                              <option value="" selected disabled>선택해주세요</option>
                              <c:forEach var="pbancVO" items="${getTpbizCD}"
                                 varStatus="status">
                                 <option value="${pbancVO.comCode}">${pbancVO.comCodeNm}</option>
                              </c:forEach>
                           </select>
                        </div>
                        <div class="form-group">
                           <label for="pbancRcptMthdCd"><b>*</b> 지원 접수 방법</label> <select
                              class="input-detail" id="pbancRcptMthdCd"
                              name="pbancRcptMthdCd" required>
                              <option value="" selected disabled>선택해주세요</option>
                              <c:forEach var="pbancVO" items="${getPbancRcptMthdCD}"
                                 varStatus="status">
                                 <option value="${pbancVO.comCode}">${pbancVO.comCodeNm}</option>
                              </c:forEach>
                           </select>
                        </div>
                        <div class="form-group">
                           <label for="pbancAppofeFormCd"><b>*</b> 지원서 양식</label> <select
                              class="input-detail" id="application-form"
                              name="pbancAppofeFormCd" required>
                              <option value="" selected disabled>선택해주세요</option>
                              <c:forEach var="pbancVO" items="${getPbancAppofeFormCD}"
                                 varStatus="status">
                                 <option value="${pbancVO.comCode}">${pbancVO.comCodeNm}</option>
                              </c:forEach>
                           </select>
                        </div>
                     </div>
                     <div>
                        <div class="form-group">
                           <label for="period"><b>*</b> 지원 접수 기간</label> <input
                              type="hidden" id="start-date" name="pbancBgngDt" required>
                           <input type="date" id="start-date" name="pbancBgngDts" required>
                           &nbsp; ~ &nbsp; <input type="hidden" id="end-date"
                              name="pbancDdlnDt" required> <input type="date"
                              id="end-date" name="pbancDdlnDts" required>
                        </div>
                        <div class="form-group">
                           <label for="procssCd"><b>*</b> 전형절차</label>
                           <div class="step-group">
                              <select class="input-detail" id="proc" name="procssCd"
                                 required>
                                 <option value="" selected disabled>선택해주세요</option>
                                 <c:forEach var="pbancVO" items="${getProcssCD}"
                                    varStatus="status">
                                    <option value="${pbancVO.comCode}">${pbancVO.comCodeNm}</option>
                                 </c:forEach>
                              </select>
                           </div>
                        </div>
                     </div>
                  </div>
               </section>

               <!-- 공고 내용 -->
               <section class="section" hidden="hidden">
                  <h4>공고 내용</h4>
                  <h5>공고 내용을 입력해주세요</h5>
                  <div class="form-group">
                     <div style="flex-direction: column;">
	                     <div>
		                     <label for="pbancTtl"><b>*</b> 공고 제목</label> 
	    	                 <input type="text" id="title" name="pbancTtl" placeholder="제목을 입력하세요" required>
	                     </div>
	                     <div>
	                     	<div class="error-msg"></div>
	                     </div>
                     </div>
                  </div>
                  <div class="form-group">
					<div style="flex-direction: column;">                     
	                     <div>
		                     <label for="pbancCn" class="con-pbanc-title"><b>*</b> 공고 내용</label>
		                     <textarea class="txtara" id="txtara" name="pbancCn" required></textarea>
	                     </div>
	                     <div>
		                     <div class="error-msg"></div>
	                     </div>
                     </div>
                  </div>
                  <div class="form-group" id="filegroup">
                     <label for="entPbancFile" class="con-pbanc-title"><b>*</b>
                        공고 파일</label> <input type="file" id="pbancFile" name="entPbancFile"
                        required />
                  </div>
                  <div class="flexPbanccc">
                     <img class="fileImg" src="../resources/icon/warning.png"
                        alt="exclamation" />
                     <p id="pFile">공고 상단에 보일 이미지 파일을 등록해주세요.</p>
                  </div>
               </section>
               <!-- 버튼 섹션 -->
               <section class="button-section" hidden="hidden">
                  <div class="btn-last1">
                     <button type="button" class="btn save-btn" id="tempPbancSave">임시 저장</button>
                  </div>
                  <div class="btn-last2">
                     <button type="button" class="btn cancel-btn"
                        onclick="location.href='/enter/pbanc?entId=${prc.username}'">취소</button>
                     <button type="submit" class="btn submit-btn" id="insert-btn">공고 등록</button>
                  </div>
               </section>
               <sec:csrfInput />
            </form>
         </div>
      </c:if>
      <c:if test="${prc.authorities ne '[ROLE_ENTER]'}">
         <script type="text/javascript">
            alert("접근 권한이 없습니다.");
            location.href = "/";
         </script>
      </c:if>
   </c:if>
</body>
<script>
var Toast = Swal.mixin({
	toast: true,
	position: 'center',
	showConfirmButton: false,
	timer: 3000
	});
// -----------------------------------------------필수 조건 추가
$(document).ready(function() {
    let counter = 0; 
    $("#mg").on("click", function(){
    	$("#title").val("[대덕그룹] 데이터베이스 유지보수팀 DBA 경력직사원 채용");
    })
    
    
    
    // '추가' 버튼 클릭 이벤트
    $('.add-btn1').click(function() {
        var inputValue = $('#requiredCn').val(); // 입력값 가져오기
        
        // 중복 확인 로직
        var isDuplicate = false;
        $('#dynamicList1 div').each(function() {
            if ($(this).text().includes(inputValue)) {
                isDuplicate = true;
            }
        });

        if (isDuplicate) {
            alert('중복된 조건을 입력할 수 없습니다.');
            return;
        }

        if (inputValue) {
            // 새로운 div 요소 생성
            var newDiv = $('<div></div>').text(inputValue);
            
            // 'x' 버튼 생성
            var removeBtn = $('<button class="delBtn2"><img class="delImg" src="../resources/icon/delete.png"></button>').css({
                marginLeft: '10px',
                cursor: 'pointer'
            });

            // 'x' 버튼 클릭 시 해당 div 삭제와 hidden input 삭제
            removeBtn.click(function() {
                newDiv.remove();
                $('#hiddenRequired' + counter).remove(); // 해당 hidden input도 삭제
            });

            // 입력된 값과 'x' 버튼을 'newDiv'에 추가
            newDiv.append(removeBtn);
            $('#dynamicList1').append(newDiv);

            // Hidden input 생성하여 값 저장
            $('<input>').attr({
                type: 'hidden',
                id: 'hiddenRequired' + counter,
                name: 'requiredCnList', // 서버로 전송될 name
                value: inputValue
            }).appendTo('#hiddenRequiredList');

            counter++; 

            // 입력 필드 초기화
            $('#requiredCn').val('');
        } else {
            alert('필수 조건을 입력하세요.');
        }
    });
});
// -----------------------------------------------우대 조건 추가
$(document).ready(function() {
    let counter = 0; 
    
    $('.add-btn2').click(function() {
        var inputValue = $('#preferCn').val();
        
        // 중복 확인 로직
        var isDuplicate = false;
        $('#dynamicList2 div').each(function() {
            if ($(this).text().includes(inputValue)) {
                isDuplicate = true;
            }
        });

        if (isDuplicate) {
            alert('중복된 조건을 입력할 수 없습니다.');
            return;
        }

        if (inputValue) {
            var newDiv = $('<div></div>').text(inputValue);
            var removeBtn = $('<button class="delBtn3"><img class="delImg" src="../resources/icon/delete.png"></button>').css({
                marginLeft: '10px',
                cursor: 'pointer'
            });

            removeBtn.click(function() {
                newDiv.remove();
                $('#hiddenPrefer' + counter).remove();
            });

            newDiv.append(removeBtn);
            $('#dynamicList2').append(newDiv);

            $('<input>').attr({
                type: 'hidden',
                id: 'hiddenPrefer' + counter,
                name: 'preferCnList',
                value: inputValue
            }).appendTo('#hiddenPreferList');

            counter++; 
            $('#preferCn').val('');
        } else {
        	alert('우대 조건을 입력하세요.');
        }
    });
});

// -----------------------------------------------복지 및 혜택 추가 
$(document).ready(function() {
    let counter = 0;

    $('.add-btn3').click(function() {
        var inputValue = $('#favor').val();
        
        // 중복 확인 로직
        var isDuplicate = false;
        $('#dynamicList3 div').each(function() {
            if ($(this).text().includes(inputValue)) {
                isDuplicate = true;
            }
        });

        if (isDuplicate) {
            alert('중복된 조건을 입력할 수 없습니다.');
            return;
        }

        if (inputValue) {
            var newDiv = $('<div></div>').text(inputValue);
            var removeBtn = $('<button class="delBtn"><img class="delImg" src="../resources/icon/delete.png"></button>').css({
                marginLeft: '10px',
                cursor: 'pointer'
            });

            removeBtn.click(function() {
                newDiv.remove();
                $('#hiddenFavor' + counter).remove();
            });

            newDiv.append(removeBtn);
            $('#dynamicList3').append(newDiv);

            $('<input>').attr({
                type: 'hidden',
                id: 'hiddenFavor' + counter,
                name: 'favorList',
                value: inputValue
            }).appendTo('#hiddenFavorList');

            counter++;
            $('#favor').val('');
        } else {
            alert('복지 및 혜택을 입력하세요.');
        }
    });
});

   /*최저임금제도 모달창*/
   $(document).ready(function() {
      // 모달 열기
      $('.sal-line').click(function() {
         $('#salaryModal').css('display', 'block');
         $('body').css('overflow', 'hidden'); // 배경 스크롤 비활성화
      });

      // 모달 닫기
      $('.close').click(function() {
         $('#salaryModal').css('display', 'none');
         $('body').css('overflow', 'auto'); // 배경 스크롤 다시 활성화
      });

      // 아코디언 버튼 클릭 이벤트
      $('#accordion-btn').click(function() {
         $('#accordion-content').slideToggle();
         $(this).text($(this).text() === '보기' ? '접기' : '보기');
      });

      // 확인 버튼 클릭 시 모달 닫기
      $('.modalOk').click(function() {
         $('#salaryModal').css('display', 'none');
         $('body').css('overflow', 'auto'); // 배경 스크롤 다시 활성화
      });

      // 확인 버튼 클릭 시 히든 제거
      $('.modalGo').click(function() {
         // 히든 섹션 보이도록 설정
         $('section[hidden="hidden"]').attr("hidden", false);
         // 모집 분야로 스크롤
         document.getElementById("pbancInsert").scrollIntoView({
            behavior : 'smooth'
         });
      });

   });
//-----------------------------------------------공고 카카오맵
   $(function() {
      var marker = {
         position : new kakao.maps.LatLng(33.450701, 126.570667),
         text : "${enterVO.entNm}"
      };

      var staticMapContainer = document.getElementById('staticMap'), // 이미지 지도를 표시할 div
      staticMapOption = {
         center : new kakao.maps.LatLng(33.450701, 126.570667), // 이미지 지도의 중심좌표
         level : 3, // 이미지 지도의 확대 레벨
         marker : marker
      // 이미지 지도에 표시할 마커
      };

      // 이미지 지도를 생성합니다
      var staticMap = new kakao.maps.StaticMap(staticMapContainer,
            staticMapOption);
   });
   // 서버에서 받아온 주소를 자바스크립트 변수로 저장
   var address = '${location.entAddr}';

   // 카카오 지도 API Geocoder 사용
   var geocoder = new kakao.maps.services.Geocoder();

   // 주소로 좌표를 검색하는 함수
   geocoder
         .addressSearch(
               address,
               function(result, status) {
                  if (status === kakao.maps.services.Status.OK) {
                     var coords = new kakao.maps.LatLng(result[0].y,
                           result[0].x);
                     var mapContainer = document
                           .getElementById('staticMap'), mapOption = {
                        center : coords,
                        level : 3
                     };

                     var map = new kakao.maps.Map(mapContainer,
                           mapOption);

                     var marker = new kakao.maps.Marker({
                        map : map,
                        position : coords
                     });

                     // 인포윈도우로 장소에 대한 설명을 표시합니다
                     var infowindow = new kakao.maps.InfoWindow(
                           {
                              content : '<div style="width:150px;text-align:center;padding:6px 0;">${enterVO.entNm}</div>'
                           });
                     infowindow.open(map, marker);

                     // 지도의 중심을 결과값으로 받은 위치로 이동시킵니다
                     map.setCenter(coords);

                  } else {
                     console.error('주소 변환 실패: ' + status); // 오류 로그 추가
                  }
               });
 //-----------------------------------------------공고 임시저장 버튼 실행
$(function() {
    document.getElementById('tempPbancSave').addEventListener('click', function(e) {
        e.preventDefault();
        $('#pbancInsert input').each(function() {
            $(this).prop('required', false);
        });
        $('#pbancInsert select').each(function() {
            $(this).prop('required', false);
        });
        $('#txtara').prop('required', false);
        $('#title').attr('required','true');
        Swal.fire({
            title: '임시저장하시겠습니까?',
            icon: 'question',
            showCancelButton: true,
            confirmButtonColor: 'white',
            cancelButtonColor: 'white',
            confirmButtonText: '예',
            cancelButtonText: '아니오',
            reverseButtons: false, // 버튼 순서 거꾸로
        }).then((result) => {
            if (result.isConfirmed) {
                var entId = $('#entId').val();
                var formData = new FormData(document.getElementById('pbancInsert'));
                console.log("formData : ", formData);
                console.log("entId : ", entId);

                $.ajax({
                    type: 'POST',
                    url: '/enter/tempPbancSavePost',
                    data: formData,
                    processData: false,
                    contentType: false,
                    beforeSend: function(xhr) {
                        xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
                    },
                    success: function(response) {
                        console.log("response", response);
                        Toast.fire({
                            icon: 'success',
                            title: '임시저장 완료!',
                            customClass: {
                                popup: 'my-custom-popup' // CSS에서 정의한 클래스 이름
                            }
                        }).then(() => {
                            location.href = "/enter/tempPbanc?entId=" + entId;
                        });
                    },
                    error: function(error) {
                        Toast.fire({
                            icon: 'error',
                            title: '임시저장 실패!',
                            customClass: {
                                popup: 'my-custom-popup' // CSS에서 정의한 클래스 이름
                            }
                        });
                    }
                });
            }
        });
    });
});

 
// --------------------------------------------공고 등록 
$(function() {
 
	$(document).on("click", "#insert-btn", function(event) {
		event.preventDefault(); // 기본 폼 전송 방지
		$("#pbancInsert").attr("action", "/enter/pbancInsertPost?${_csrf.parameterName}=${_csrf.token}");

		// Swal.fire 사용하여 수정 확인창 표시
		Swal.fire({
		    title: '등록하시겠습니까?',
		    icon: 'question',
		    showCancelButton: true,
		    confirmButtonColor: 'white',
		    cancelButtonColor: 'white',
		    confirmButtonText: '예',
		    cancelButtonText: '아니오'
		}).then((result) => {
		    if (result.isConfirmed) {
		        // 수정 확인 시 폼 전송
		        $("#pbancInsert").submit();
		        Toast.fire({
		            icon: 'success',
		            title: '등록 완료!',
                    customClass: {
                        popup: 'my-custom-popup' // CSS에서 정의한 클래스 이름
                    }
                }).then(() => {
                	location.href = "/enter/pbanc?entId=" + entId;
		        });
		    } else {
		        // 수정 취소 시
		        Toast.fire({
		            icon: 'error',
		            title: '등록 취소!'
		        });
		    }
		});
		});	
	
});
 
 
   // 모집업종
   $(document).ready(function() {
      // 모집업종 select box에서 선택한 값을 <div>에 넣기
      $('#tpbizCd').change(function() {
         var selectedOptions = [];
         $('#tpbizCd option:selected').each(function() {
            selectedOptions.push($(this).text()); // 선택된 옵션의 텍스트 값을 배열에 추가
         });

         var selectedText = selectedOptions.join(', '); // 여러 개 선택 시 콤마로 구분
         $('#selectedOptionsDiv').text(selectedText); // ID로 지정된 <div>에 선택된 텍스트 값 추가
      });
   });
   
   
// -----------------------------------------------validation 유효성검사    
$(document).ready(function() {

    // 공고 제목 실시간 유효성 검사
    $('#title').on('keyup', function() {
        let pbancTtl = $(this).val();
        if (!pbancTtl || pbancTtl.length < 5 || pbancTtl.length > 100) {
            showError(this, '공고 제목은 5자 이상 100자 이하이어야 합니다.');
        } else {
            hideError(this);
        }
    });

    // 공고 내용 실시간 유효성 검사
    $('textarea[name="pbancCn"]').on('keyup', function() {
        let pbancCn = $(this).val();
        if (!pbancCn || pbancCn.length < 30) {
            showError(this, '공고 내용은 30자 이상이어야 합니다.');
        } else {
            hideError(this);
        }
    });

    // 에러 메시지 표시 함수
    function showError(selector, message) {
        $(selector).addClass('input-error');  // input 필드에 빨간 테두리 추가
        $(selector).closest('.form-group').find('.error-msg').text(message).show();  // 같은 form-group 내의 error-msg를 찾아서 경고 메시지 표시
    }

    // 에러 메시지 숨기기 함수
    function hideError(selector) {
        $(selector).removeClass('input-error');  // 빨간 테두리 제거
        $(selector).closest('.form-group').find('.error-msg').hide();  // 같은 form-group 내의 error-msg 숨기기
    }
});
</script>
</html>
