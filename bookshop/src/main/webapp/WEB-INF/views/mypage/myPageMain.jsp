<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<c:if test="${message == 'cancel_order'}">
	<script type="text/javascript">
		window.onload = function() { alert("주문을 취소했습니다."); };
	</script>
</c:if>

<script type="text/javascript">
// 주문 취소 (배송준비중인 주문만 가능)
function fn_cancel_order(order_id) {
	if (!confirm("주문을 취소하시겠습니까?")) return;
	var form = document.createElement("form");
	var input = document.createElement("input");
	input.type = "hidden";
	input.name = "order_id";
	input.value = order_id;
	form.appendChild(input);
	document.body.appendChild(form);
	form.method = "post";
	form.action = "${contextPath}/mypage/cancelMyOrder.do";
	form.submit();
}
</script>

<h3>최근 주문 내역</h3>
<table class="table_basic">
	<thead>
		<tr>
			<th>주문번호</th>
			<th>주문일자</th>
			<th>주문상품</th>
			<th>수량</th>
			<th>주문금액</th>
			<th>배송상태</th>
			<th>주문자</th>
			<th>수령자</th>
			<th>주문취소</th>
		</tr>
	</thead>
	<tbody>
		<c:choose>
			<c:when test="${empty myOrderList}">
				<tr>
					<td colspan="9" style="padding:40px 0;">주문한 상품이 없습니다.</td>
				</tr>
			</c:when>
			<c:otherwise>
				<c:set var="pre_order_id" value="" />
				<c:forEach var="item" items="${myOrderList}">
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
						<td><c:if test="${isFirst}">${item.orderer_name}</c:if></td>
						<td><c:if test="${isFirst}">${item.receiver_name}</c:if></td>
						<td>
							<c:if test="${isFirst and item.delivery_state=='delivery_prepared'}">
								<input type="button" class="btn" value="주문취소" onClick="fn_cancel_order('${item.order_id}')">
							</c:if>
						</td>
					</tr>
					<c:set var="pre_order_id" value="${item.order_id}" />
				</c:forEach>
			</c:otherwise>
		</c:choose>
	</tbody>
</table>
<div class="clear"></div>
