<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<script type="text/javascript">
function checkLogin() {
	var f = document.frmLogin;
	if (f.member_id.value == "") {
		alert("아이디를 입력해 주세요.");
		f.member_id.focus();
		return false;
	}
	if (f.member_pw.value == "") {
		alert("비밀번호를 입력해 주세요.");
		f.member_pw.focus();
		return false;
	}
	return true;
}
</script>

<c:if test="${not empty message}">
	<script type="text/javascript">
		window.onload = function() { alert("${message}"); };
	</script>
</c:if>

<h3>회원 로그인 창</h3>
<form action="${contextPath}/member/login.do" method="post" name="frmLogin" onsubmit="return checkLogin();">
	<table class="form_table" style="width:60%; margin:20px auto;">
		<tr>
			<td class="fixed_join">아이디</td>
			<td><input name="member_id" type="text" size="20"></td>
		</tr>
		<tr>
			<td class="fixed_join">비밀번호</td>
			<td><input name="member_pw" type="password" size="20"></td>
		</tr>
	</table>
	<div class="btn_box">
		<input type="submit" class="btn" value="로그인">
		<input type="reset" class="btn" value="초기화">
	</div>
	<div class="btn_box" style="font-size:0.75em;">
		<a href="${contextPath}/member/memberForm.do">회원가입</a>
		<a href="#">아이디 찾기</a>
		<a href="#">비밀번호 찾기</a>
	</div>
</form>
