<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<c:set var="period" value="${empty param.fixedSearchPeriod ? '' : param.fixedSearchPeriod}" />

<h3>상품 관리</h3>
<div class="search_box">
	조회기간:
	<a href="${contextPath}/admin/goods/adminGoodsMain.do?fixedSearchPeriod=one_week">
		<img src="${contextPath}/resources/image/btn_search_one_week.jpg" alt="1주일"></a>
	<a href="${contextPath}/admin/goods/adminGoodsMain.do?fixedSearchPeriod=two_week">
		<img src="${contextPath}/resources/image/btn_search_2_week.jpg" alt="2주일"></a>
	<a href="${contextPath}/admin/goods/adminGoodsMain.do?fixedSearchPeriod=one_month">
		<img src="${contextPath}/resources/image/btn_search_1_month.jpg" alt="1개월"></a>
	<a href="${contextPath}/admin/goods/adminGoodsMain.do?fixedSearchPeriod=two_month">
		<img src="${contextPath}/resources/image/btn_search_2_month.jpg" alt="2개월"></a>
	<a href="${contextPath}/admin/goods/adminGoodsMain.do?fixedSearchPeriod=three_month">
		<img src="${contextPath}/resources/image/btn_search_3_month.jpg" alt="3개월"></a>
	<a href="${contextPath}/admin/goods/adminGoodsMain.do?fixedSearchPeriod=four_month">
		<img src="${contextPath}/resources/image/btn_search_4_month.jpg" alt="4개월"></a>
	&nbsp;&nbsp;
	<strong>${beginYear}-${beginMonth}-${beginDay} ~ ${endYear}-${endMonth}-${endDay}</strong>
</div>

<table class="table_basic">
	<thead>
		<tr>
			<th>상품번호</th>
			<th>상품이름</th>
			<th>저자</th>
			<th>출판사</th>
			<th>상품가격</th>
			<th>입고일자</th>
			<th>출판일</th>
		</tr>
	</thead>
	<tbody>
		<c:choose>
			<c:when test="${empty newGoodsList}">
				<tr>
					<td colspan="7" style="padding:40px 0;">등록된 상품이 없습니다.</td>
				</tr>
			</c:when>
			<c:otherwise>
				<c:forEach var="item" items="${newGoodsList}">
					<tr>
						<td><strong>${item.goods_id}</strong></td>
						<td class="left">
							<a href="${contextPath}/admin/goods/modifyGoodsForm.do?goods_id=${item.goods_id}">
								<strong>${item.goods_title}</strong>
							</a>
						</td>
						<td>${item.goods_writer}</td>
						<td>${item.goods_publisher}</td>
						<td><fmt:formatNumber value="${item.goods_sales_price}" type="number" />원</td>
						<td><fmt:formatDate value="${item.goods_credate}" pattern="yyyy-MM-dd" /></td>
						<td><fmt:formatDate value="${item.goods_published_date}" pattern="yyyy-MM-dd" /></td>
					</tr>
				</c:forEach>
			</c:otherwise>
		</c:choose>
		<tr>
			<td colspan="7" style="text-align:right; border-bottom:none;">
				<a href="${contextPath}/admin/goods/addNewGoodsForm.do"><strong>상품 등록하기</strong></a>
			</td>
		</tr>
	</tbody>
</table>

<%-- 페이징: 한 페이지 10건, 한 섹션 10페이지(100건) --%>
<div class="btn_box" style="font-size:0.75em;">
	<c:if test="${section > 1}">
		<a href="${contextPath}/admin/goods/adminGoodsMain.do?section=${section-1}&pageNum=1&fixedSearchPeriod=${period}">pre</a>
	</c:if>
	<c:forEach var="page" begin="1" end="10" step="1">
		<c:choose>
			<c:when test="${page == pageNum}">
				<strong><a href="${contextPath}/admin/goods/adminGoodsMain.do?section=${section}&pageNum=${page}&fixedSearchPeriod=${period}">${(section-1)*10 + page}</a></strong>
			</c:when>
			<c:otherwise>
				<a href="${contextPath}/admin/goods/adminGoodsMain.do?section=${section}&pageNum=${page}&fixedSearchPeriod=${period}">${(section-1)*10 + page}</a>
			</c:otherwise>
		</c:choose>
	</c:forEach>
	<a href="${contextPath}/admin/goods/adminGoodsMain.do?section=${section+1}&pageNum=1&fixedSearchPeriod=${period}">next</a>
</div>
<div class="clear"></div>
