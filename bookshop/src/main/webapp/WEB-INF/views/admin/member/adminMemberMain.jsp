<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<c:set var="period" value="${empty param.fixedSearchPeriod ? '' : param.fixedSearchPeriod}" />

<h3>회원 관리</h3>
<div class="search_box">
	가입기간:
	<a href="${contextPath}/admin/member/adminMemberMain.do?fixedSearchPeriod=one_week">
		<img src="${contextPath}/resources/image/btn_search_one_week.jpg" alt="1주일"></a>
	<a href="${contextPath}/admin/member/adminMemberMain.do?fixedSearchPeriod=two_week">
		<img src="${contextPath}/resources/image/btn_search_2_week.jpg" alt="2주일"></a>
	<a href="${contextPath}/admin/member/adminMemberMain.do?fixedSearchPeriod=one_month">
		<img src="${contextPath}/resources/image/btn_search_1_month.jpg" alt="1개월"></a>
	<a href="${contextPath}/admin/member/adminMemberMain.do?fixedSearchPeriod=two_month">
		<img src="${contextPath}/resources/image/btn_search_2_month.jpg" alt="2개월"></a>
	<a href="${contextPath}/admin/member/adminMemberMain.do?fixedSearchPeriod=three_month">
		<img src="${contextPath}/resources/image/btn_search_3_month.jpg" alt="3개월"></a>
	<a href="${contextPath}/admin/member/adminMemberMain.do?fixedSearchPeriod=four_month">
		<img src="${contextPath}/resources/image/btn_search_4_month.jpg" alt="4개월"></a>
	&nbsp;&nbsp;
	<strong>${beginYear}-${beginMonth}-${beginDay} ~ ${endYear}-${endMonth}-${endDay}</strong>
</div>

<table class="table_basic">
	<thead>
		<tr>
			<th>회원아이디</th>
			<th>회원이름</th>
			<th>휴대폰번호</th>
			<th>주소</th>
			<th>가입일</th>
			<th>탈퇴여부</th>
		</tr>
	</thead>
	<tbody>
		<c:choose>
			<c:when test="${empty member_list}">
				<tr>
					<td colspan="6" style="padding:40px 0;">조회된 회원이 없습니다.</td>
				</tr>
			</c:when>
			<c:otherwise>
				<c:forEach var="item" items="${member_list}">
					<tr>
						<td>
							<a href="${contextPath}/admin/member/memberDetail.do?member_id=${item.member_id}">
								<strong>${item.member_id}</strong>
							</a>
						</td>
						<td>${item.member_name}</td>
						<td>${item.hp1}-${item.hp2}-${item.hp3}</td>
						<td class="left">${item.roadAddress}<br>${item.jibunAddress}</td>
						<td>${fn:substring(item.joinDate, 0, 10)}</td>
						<td>
							<c:choose>
								<c:when test="${item.del_yn == 'Y'}">탈퇴</c:when>
								<c:otherwise>-</c:otherwise>
							</c:choose>
						</td>
					</tr>
				</c:forEach>
			</c:otherwise>
		</c:choose>
	</tbody>
</table>

<div class="btn_box" style="font-size:0.75em;">
	<c:if test="${section > 1}">
		<a href="${contextPath}/admin/member/adminMemberMain.do?section=${section-1}&pageNum=1&fixedSearchPeriod=${period}">pre</a>
	</c:if>
	<c:forEach var="page" begin="1" end="10" step="1">
		<c:choose>
			<c:when test="${page == pageNum}">
				<strong><a href="${contextPath}/admin/member/adminMemberMain.do?section=${section}&pageNum=${page}&fixedSearchPeriod=${period}">${(section-1)*10 + page}</a></strong>
			</c:when>
			<c:otherwise>
				<a href="${contextPath}/admin/member/adminMemberMain.do?section=${section}&pageNum=${page}&fixedSearchPeriod=${period}">${(section-1)*10 + page}</a>
			</c:otherwise>
		</c:choose>
	</c:forEach>
	<a href="${contextPath}/admin/member/adminMemberMain.do?section=${section+1}&pageNum=1&fixedSearchPeriod=${period}">next</a>
</div>
<div class="clear"></div>
