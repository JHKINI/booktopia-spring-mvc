<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<script type="text/javascript">
// 검색어 자동 완성 (Ajax)
function keywordSearch() {
	var _keyword = $("#searchGoods").val();
	if (_keyword == null || _keyword == "") {
		$("#suggest").hide();
		return;
	}
	$.ajax({
		type : "get",
		async : true,
		url : "${contextPath}/goods/keywordSearch.do",
		data : { keyword : _keyword },
		success : function(data, textStatus) {
			if (data == null || data == "") {
				$("#suggest").hide();
				return;
			}
			var jsonInfo = $.parseJSON(data);
			displayResult(jsonInfo);
		},
		error : function(xhr, status, err) {
			console && console.log && console.log("keywordSearch error", status, err);
		}
	});
}

function displayResult(jsonInfo) {
	var count = jsonInfo.keyword.length;
	if (count > 0) {
		var html = "";
		for (var i in jsonInfo.keyword) {
			html += "<a href=\"javascript:select('" + jsonInfo.keyword[i].replace(/'/g, "\\'") + "')\">"
			      + jsonInfo.keyword[i] + "</a><br/>";
		}
		$("#suggestList").html(html);
		$("#suggest").show();
	} else {
		$("#suggest").hide();
	}
}

function select(selectedKeyword) {
	$("#searchGoods").val(selectedKeyword);
	$("#suggest").hide();
}
</script>

<a href="${contextPath}/main/main.do">
	<img class="link" alt="Booktopia" src="${contextPath}/resources/image/Booktopia_Logo.jpg"
	     style="position:static; width:238px; height:94px; margin-left:10px; float:left;">
</a>

<div id="head_link">
	<ul>
		<c:choose>
			<c:when test="${isLogOn==true and not empty memberInfo}">
				<li><a href="${contextPath}/member/logout.do">로그아웃</a></li>
				<li><a href="${contextPath}/mypage/myPageMain.do">마이페이지</a></li>
				<li><a href="${contextPath}/cart/myCartList.do">장바구니</a></li>
				<li><a href="#">주문배송</a></li>
			</c:when>
			<c:otherwise>
				<li><a href="${contextPath}/member/loginForm.do">로그인</a></li>
				<li><a href="${contextPath}/member/memberForm.do">회원가입</a></li>
			</c:otherwise>
		</c:choose>
		<li><a href="#">고객센터</a></li>
		<c:if test="${isLogOn==true and memberInfo.member_id=='admin'}">
			<li class="no_line"><a href="${contextPath}/admin/goods/adminGoodsMain.do">관리자</a></li>
		</c:if>
	</ul>
</div>

<br>
<div id="search">
	<form name="frmSearch" action="${contextPath}/goods/searchGoods.do" method="get">
		<input name="searchWord" class="main_input" type="text" id="searchGoods"
		       onKeyUp="keywordSearch()" autocomplete="off">
		<input type="submit" name="search" class="btn1" value="검 색">
	</form>
</div>
<div id="suggest">
	<div id="suggestList"></div>
</div>
