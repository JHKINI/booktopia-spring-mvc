<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<h3>주문내역/배송 조회</h3>
<div class="search_box">
	조회기간:
	<a href="${contextPath}/mypage/listMyOrderHistory.do?fixedSearchPeriod=one_week">
		<img src="${contextPath}/resources/image/btn_search_one_week.jpg" alt="1주일"></a>
	<a href="${contextPath}/mypage/listMyOrderHistory.do?fixedSearchPeriod=two_week">
		<img src="${contextPath}/resources/image/btn_search_2_week.jpg" alt="2주일"></a>
	<a href="${contextPath}/mypage/listMyOrderHistory.do?fixedSearchPeriod=one_month">
		<img src="${contextPath}/resources/image/btn_search_1_month.jpg" alt="1개월"></a>
	<a href="${contextPath}/mypage/listMyOrderHistory.do?fixedSearchPeriod=two_month">
		<img src="${contextPath}/resources/image/btn_search_2_month.jpg" alt="2개월"></a>
	<a href="${contextPath}/mypage/listMyOrderHistory.do?fixedSearchPeriod=three_month">
		<img src="${contextPath}/resources/image/btn_search_3_month.jpg" alt="3개월"></a>
	<a href="${contextPath}/mypage/listMyOrderHistory.do?fixedSearchPeriod=four_month">
		<img src="${contextPath}/resources/image/btn_search_4_month.jpg" alt="4개월"></a>
	&nbsp;&nbsp;
	<strong>${beginYear}-${beginMonth}-${beginDay} ~ ${endYear}-${endMonth}-${endDay}</strong>
</div>

<table class="table_basic">
	<thead>
		<tr>
			<th>주문번호</th>
			<th>주문일자</th>
			<th>주문상품</th>
			<th>수량</th>
			<th>주문금액</th>
			<th>배송상태</th>
			<th>수령자</th>
		</tr>
	</thead>
	<tbody>
		<c:choose>
			<c:when test="${empty myOrderHistList}">
				<tr>
					<td colspan="7" style="padding:40px 0;">조회된 주문 내역이 없습니다.</td>
				</tr>
			</c:when>
			<c:otherwise>
				<c:set var="pre_order_id" value="" />
				<c:forEach var="item" items="${myOrderHistList}">
					<c:set var="isFirst" value="${pre_order_id != item.order_id}" />
					<tr>
						<td>
							<c:if test="${isFirst}">
								<a href="${contextPath}/mypage/myOrderDetail.do?order_id=${item.order_id}"><span>${item.order_id}</span></a>
							</c:if>
						</td>
						<td><c:if test="${isFirst}">${fn:substring(item.pay_order_time, 0, 16)}</c:if></td>
						<td class="left">
							<a href="${contextPath}/goods/goodsDetail.do?goods_id=${item.goods_id}">${item.goods_title}</a>
						</td>
						<td>${item.order_goods_qty}개</td>
						<td><fmt:formatNumber value="${item.goods_sales_price * item.order_goods_qty}" type="number" />원</td>
						<td>
							<c:if test="${isFirst}">
								<c:choose>
									<c:when test="${item.delivery_state=='delivery_prepared'}">배송준비중</c:when>
									<c:when test="${item.delivery_state=='delivering'}">배송중</c:when>
									<c:when test="${item.delivery_state=='finished_delivering'}">배송완료</c:when>
									<c:when test="${item.delivery_state=='cancel_order'}">주문취소</c:when>
									<c:when test="${item.delivery_state=='returning_goods'}">반품</c:when>
									<c:otherwise>${item.delivery_state}</c:otherwise>
								</c:choose>
							</c:if>
						</td>
						<td><c:if test="${isFirst}">${item.receiver_name}</c:if></td>
					</tr>
					<c:set var="pre_order_id" value="${item.order_id}" />
				</c:forEach>
			</c:otherwise>
		</c:choose>
	</tbody>
</table>
<div class="clear"></div>
