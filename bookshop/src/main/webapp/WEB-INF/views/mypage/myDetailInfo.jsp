<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script type="text/javascript">
function execDaumPostcode() {
	new daum.Postcode({
		oncomplete : function(data) {
			document.getElementById('zipcode').value = data.zonecode;
			document.getElementById('roadAddress').value = data.roadAddress;
			document.getElementById('jibunAddress').value = data.jibunAddress;
			document.getElementById('namujiAddress').focus();
		}
	}).open();
}

// 항목별 수정: attribute 와 value 를 컨트롤러로 전송 (Ajax)
function fn_modify_member_info(attribute) {
	var value = "";
	var f = document.frmMember;

	if (attribute == 'member_pw') {
		value = f.member_pw.value;
	} else if (attribute == 'member_gender') {
		var radios = f.member_gender;
		for (var i = 0; i < radios.length; i++) {
			if (radios[i].checked) { value = radios[i].value; break; }
		}
	} else if (attribute == 'member_birth') {
		var gn = "";
		for (var j = 0; j < f.member_birth_gn.length; j++) {
			if (f.member_birth_gn[j].checked) { gn = f.member_birth_gn[j].value; break; }
		}
		value = f.member_birth_y.value + "," + f.member_birth_m.value + "," + f.member_birth_d.value + "," + gn;
	} else if (attribute == 'tel') {
		value = f.tel1.value + "," + f.tel2.value + "," + f.tel3.value;
	} else if (attribute == 'hp') {
		value = f.hp1.value + "," + f.hp2.value + "," + f.hp3.value + "," + (f.smssts_yn.checked ? "Y" : "N");
	} else if (attribute == 'email') {
		value = f.email1.value + "," + f.email2.value + "," + (f.emailsts_yn.checked ? "Y" : "N");
	} else if (attribute == 'address') {
		value = f.zipcode.value + "," + f.roadAddress.value + "," + f.jibunAddress.value + "," + f.namujiAddress.value;
	}

	if (value == "") {
		alert("수정할 값을 입력해 주세요.");
		return;
	}
	$.ajax({
		type : "post",
		async : false,
		url : "${contextPath}/mypage/modifyMyInfo.do",
		data : { attribute : attribute, value : value },
		success : function(data, textStatus) {
			if (data.trim() == 'mod_success') {
				alert("회원 정보를 수정했습니다.");
			} else if (data.trim() == 'failed') {
				alert("다시 시도해 주세요.");
			}
		},
		error : function(data, textStatus) {
			alert("에러가 발생했습니다. " + textStatus);
		}
	});
}

// 현재 저장된 값으로 셀렉트 박스 초기화
$(document).ready(function() {
	var f = document.frmMember;
	f.member_birth_y.value = "${memberInfo.member_birth_y}";
	f.member_birth_m.value = "${memberInfo.member_birth_m}";
	f.member_birth_d.value = "${memberInfo.member_birth_d}";
	f.tel1.value = "${memberInfo.tel1}";
	f.hp1.value = "${memberInfo.hp1}";
});
</script>

<h3>내 정보</h3>
<form name="frmMember">
	<div id="detail_table">
		<table class="form_table">
			<tbody>
				<tr>
					<td class="fixed_join">아이디</td>
					<td colspan="2">${memberInfo.member_id}</td>
				</tr>
				<tr>
					<td class="fixed_join">비밀번호</td>
					<td><input name="member_pw" type="password" size="20"></td>
					<td><input type="button" class="btn" value="수정하기" onClick="fn_modify_member_info('member_pw')"></td>
				</tr>
				<tr>
					<td class="fixed_join">이름</td>
					<td colspan="2">${memberInfo.member_name}</td>
				</tr>
				<tr>
					<td class="fixed_join">성별</td>
					<td>
						<input type="radio" name="member_gender" value="102" ${memberInfo.member_gender=='102' ? 'checked' : ''}> 여성
						&nbsp;&nbsp;&nbsp;
						<input type="radio" name="member_gender" value="101" ${memberInfo.member_gender=='101' ? 'checked' : ''}> 남성
					</td>
					<td><input type="button" class="btn" value="수정하기" onClick="fn_modify_member_info('member_gender')"></td>
				</tr>
				<tr>
					<td class="fixed_join">생년월일</td>
					<td>
						<select name="member_birth_y">
							<c:forEach var="i" begin="1" end="100">
								<c:set var="year" value="${2026 - i}" />
								<option value="${year}">${year}</option>
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
						&nbsp;&nbsp;
						<input type="radio" name="member_birth_gn" value="2" ${memberInfo.member_birth_gn=='2' ? 'checked' : ''}> 양력
						&nbsp;
						<input type="radio" name="member_birth_gn" value="1" ${memberInfo.member_birth_gn=='1' ? 'checked' : ''}> 음력
					</td>
					<td><input type="button" class="btn" value="수정하기" onClick="fn_modify_member_info('member_birth')"></td>
				</tr>
				<tr>
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
						- <input size="10" type="text" name="tel2" value="${memberInfo.tel2}">
						- <input size="10" type="text" name="tel3" value="${memberInfo.tel3}">
					</td>
					<td><input type="button" class="btn" value="수정하기" onClick="fn_modify_member_info('tel')"></td>
				</tr>
				<tr>
					<td class="fixed_join">휴대폰번호</td>
					<td>
						<select name="hp1">
							<option value="010">010</option>
							<option value="011">011</option>
							<option value="016">016</option>
							<option value="017">017</option>
							<option value="018">018</option>
							<option value="019">019</option>
						</select>
						- <input size="10" type="text" name="hp2" value="${memberInfo.hp2}">
						- <input size="10" type="text" name="hp3" value="${memberInfo.hp3}"><br><br>
						<input type="checkbox" name="smssts_yn" value="Y" ${memberInfo.smssts_yn=='Y' ? 'checked' : ''}> 쇼핑몰에서 발송하는 SMS 소식을 수신합니다.
					</td>
					<td><input type="button" class="btn" value="수정하기" onClick="fn_modify_member_info('hp')"></td>
				</tr>
				<tr>
					<td class="fixed_join">이메일<br>(e-mail)</td>
					<td>
						<input size="10" type="text" name="email1" value="${memberInfo.email1}"> @
						<input size="10" type="text" name="email2" value="${memberInfo.email2}"><br><br>
						<input type="checkbox" name="emailsts_yn" value="Y" ${memberInfo.emailsts_yn=='Y' ? 'checked' : ''}> 쇼핑몰에서 발송하는 e-mail을 수신합니다.
					</td>
					<td><input type="button" class="btn" value="수정하기" onClick="fn_modify_member_info('email')"></td>
				</tr>
				<tr>
					<td class="fixed_join">주소</td>
					<td>
						<input type="text" id="zipcode" name="zipcode" size="5" value="${memberInfo.zipcode}" readonly>
						<a href="javascript:execDaumPostcode()">우편번호검색</a><br><br>
						지번 주소: <input type="text" id="jibunAddress" name="jibunAddress" size="50" value="${memberInfo.jibunAddress}" readonly><br><br>
						도로명 주소: <input type="text" id="roadAddress" name="roadAddress" size="50" value="${memberInfo.roadAddress}" readonly><br><br>
						나머지 주소: <input type="text" id="namujiAddress" name="namujiAddress" size="50" value="${memberInfo.namujiAddress}">
					</td>
					<td><input type="button" class="btn" value="수정하기" onClick="fn_modify_member_info('address')"></td>
				</tr>
			</tbody>
		</table>
	</div>
	<div class="clear"></div>
</form>
