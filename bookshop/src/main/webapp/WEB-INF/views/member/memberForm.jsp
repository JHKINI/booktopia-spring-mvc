<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script type="text/javascript">
// 다음(카카오) 우편번호 검색
function execDaumPostcode() {
	new daum.Postcode({
		oncomplete : function(data) {
			// 도로명 주소 / 지번 주소 구분해서 채우기
			var roadAddr = data.roadAddress;
			var jibunAddr = data.jibunAddress;
			document.getElementById('zipcode').value = data.zonecode;
			document.getElementById('roadAddress').value = roadAddr;
			document.getElementById('jibunAddress').value = jibunAddr;
			document.getElementById('namujiAddress').focus();
		}
	}).open();
}

// 아이디 중복 체크 (Ajax)
function fn_overlapped() {
	var _id = $("#_member_id").val();
	if (_id == '') {
		alert("ID를 입력하세요");
		return;
	}
	$.ajax({
		type : "post",
		async : false,
		url : "${contextPath}/member/overlapped.do",
		dataType : "text",
		data : { id : _id },
		success : function(data, textStatus) {
			if (data == 'false') {
				alert("사용할 수 있는 ID입니다.");
				$('#btnOverlapped').prop("disabled", true);
				$('#_member_id').prop("disabled", true);
				$('#member_id').val(_id);
			} else {
				alert("사용할 수 없는 ID입니다.");
			}
		},
		error : function(data, textStatus) {
			alert("에러가 발생했습니다.");
		}
	});
}

// 가입 전 검증
function fn_check_form() {
	var f = document.frmMember;
	if (f.member_id.value == '') {
		alert("ID 중복체크를 먼저 해주세요.");
		return false;
	}
	if (f.member_pw.value == '') {
		alert("비밀번호를 입력하세요.");
		f.member_pw.focus();
		return false;
	}
	if (f.member_name.value == '') {
		alert("이름을 입력하세요.");
		f.member_name.focus();
		return false;
	}
	return true;
}
</script>

<h3>필수입력사항</h3>
<form action="${contextPath}/member/addMember.do" method="post" name="frmMember" onsubmit="return fn_check_form();">
	<div id="detail_table">
		<table class="form_table">
			<tbody>
				<tr class="dot_line">
					<td class="fixed_join">아이디</td>
					<td>
						<input type="text" name="_member_id" id="_member_id" size="20">
						<input type="button" id="btnOverlapped" value="중복체크" onClick="fn_overlapped()">
						<input type="hidden" name="member_id" id="member_id">
					</td>
				</tr>
				<tr class="solid_line">
					<td class="fixed_join">비밀번호</td>
					<td><input name="member_pw" type="password" size="20"></td>
				</tr>
				<tr class="solid_line">
					<td class="fixed_join">이름</td>
					<td><input name="member_name" type="text" size="20"></td>
				</tr>
				<tr class="solid_line">
					<td class="fixed_join">성별</td>
					<td>
						<input type="radio" name="member_gender" value="102" checked> 여성
						&nbsp;&nbsp;&nbsp;
						<input type="radio" name="member_gender" value="101"> 남성
					</td>
				</tr>
				<tr class="solid_line">
					<td class="fixed_join">법정생년월일</td>
					<td>
						<select name="member_birth_y">
							<c:forEach var="i" begin="1" end="100">
								<c:set var="year" value="${2026 - i}" />
								<c:choose>
									<c:when test="${year == 1990}">
										<option value="${year}" selected>${year}</option>
									</c:when>
									<c:otherwise>
										<option value="${year}">${year}</option>
									</c:otherwise>
								</c:choose>
							</c:forEach>
						</select>년
						<select name="member_birth_m">
							<c:forEach var="i" begin="1" end="12">
								<option value="${i}">${i}</option>
							</c:forEach>
						</select>월
						<select name="member_birth_d">
							<c:forEach var="i" begin="1" end="31">
								<option value="${i}">${i}</option>
							</c:forEach>
						</select>일
						&nbsp;&nbsp;&nbsp;
						<input type="radio" name="member_birth_gn" value="2" checked> 양력
						&nbsp;&nbsp;&nbsp;
						<input type="radio" name="member_birth_gn" value="1"> 음력
					</td>
				</tr>
				<tr class="dot_line">
					<td class="fixed_join">전화번호</td>
					<td>
						<select name="tel1">
							<option value="02">02</option>
							<option value="031">031</option>
							<option value="032">032</option>
							<option value="033">033</option>
							<option value="041">041</option>
							<option value="042">042</option>
							<option value="043">043</option>
							<option value="051">051</option>
							<option value="052">052</option>
							<option value="053">053</option>
							<option value="054">054</option>
							<option value="055">055</option>
							<option value="061">061</option>
							<option value="062">062</option>
							<option value="063">063</option>
							<option value="064">064</option>
						</select>
						- <input size="10" type="text" name="tel2"> - <input size="10" type="text" name="tel3">
					</td>
				</tr>
				<tr class="dot_line">
					<td class="fixed_join">휴대폰번호</td>
					<td>
						<select name="hp1">
							<option value="010" selected>010</option>
							<option value="011">011</option>
							<option value="016">016</option>
							<option value="017">017</option>
							<option value="018">018</option>
							<option value="019">019</option>
						</select>
						- <input size="10" type="text" name="hp2"> - <input size="10" type="text" name="hp3"><br><br>
						<input type="checkbox" name="smssts_yn" value="Y" checked> 쇼핑몰에서 발송하는 SMS 소식을 수신합니다.
					</td>
				</tr>
				<tr class="dot_line">
					<td class="fixed_join">이메일<br>(e-mail)</td>
					<td>
						<input size="10" type="text" name="email1"> @ <input size="10" type="text" name="email2">
						<select name="select_email2" onChange="document.frmMember.email2.value = this.value;">
							<option value="non" selected>직접입력</option>
							<option value="hanmail.net">hanmail.net</option>
							<option value="naver.com">naver.com</option>
							<option value="yahoo.co.kr">yahoo.co.kr</option>
							<option value="hotmail.com">hotmail.com</option>
							<option value="paran.com">paran.com</option>
							<option value="nate.com">nate.com</option>
							<option value="google.com">google.com</option>
							<option value="gmail.com">gmail.com</option>
						</select><br><br>
						<input type="checkbox" name="emailsts_yn" value="Y" checked> 쇼핑몰에서 발송하는 e-mail을 수신합니다.
					</td>
				</tr>
				<tr class="dot_line">
					<td class="fixed_join">주소</td>
					<td>
						<input type="text" id="zipcode" name="zipcode" size="5" readonly>
						<a href="javascript:execDaumPostcode()">우편번호검색</a>
						<br>
						<p>
							지번 주소: <input type="text" id="jibunAddress" name="jibunAddress" size="50" readonly><br><br>
							도로명 주소: <input type="text" id="roadAddress" name="roadAddress" size="50" readonly><br><br>
							나머지 주소: <input type="text" id="namujiAddress" name="namujiAddress" size="50">
						</p>
					</td>
				</tr>
			</tbody>
		</table>
	</div>
	<div class="clear"></div>
	<br><br>
	<table align="center" style="margin:0 auto;">
		<tr>
			<td>
				<input type="submit" class="btn" value="회원 가입">
				<input type="reset" class="btn" value="다시입력">
			</td>
		</tr>
	</table>
</form>
