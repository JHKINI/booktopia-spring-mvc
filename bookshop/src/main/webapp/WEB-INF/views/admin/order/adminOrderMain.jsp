<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<c:set var="period" value="${empty param.fixedSearchPeriod ? '' : param.fixedSearchPeriod}" />

<script type="text/javascript">
// 배송 상태 수정 (Ajax): 주문번호와 선택한 배송 상태를 전송
function fn_modify_order_state(order_id, select_id) {
	var delivery_state = $("#" + select_id).val();
	$.ajax({
		type : "post",
		async : false,
		url : "${contextPath}/admin/order/modifyDeliveryState.do",
		data : { order_id : order_id, delivery_state : delivery_state },
		success : function(data, textStatus) {
			if (data.trim() == 'mod_success') {
				alert("주문 정보를 수정했습니다.");
				location.reload();
			} else {
				alert("다시 시도해 주세요.");
			}
		},
		error : function(data, textStatus) {
			alert("에러가 발생했습니다. " + textStatus);
		}
	});
}
</script>

<h3>주문 관리</h3>
<div class="search_box">
	조회기간:
	<a href="${contextPath}/admin/order/adminOrderMain.do?fixedSearchPeriod=one_week">
		<img src="${contextPath}/resources/image/btn_search_one_week.jpg" alt="1주일"></a>
	<a href="${contextPath}/admin/order/adminOrderMain.do?fixedSearchPeriod=two_week">
		<img src="${contextPath}/resources/image/btn_search_2_week.jpg" alt="2주일"></a>
	<a href="${contextPath}/admin/order/adminOrderMain.do?fixedSearchPeriod=one_month">
		<img src="${contextPath}/resources/image/btn_search_1_month.jpg" alt="1개월"></a>
	<a href="${contextPath}/admin/order/adminOrderMain.do?fixedSearchPeriod=two_month">
		<img src="${contextPath}/resources/image/btn_search_2_month.jpg" alt="2개월"></a>
	<a href="${contextPath}/admin/order/adminOrderMain.do?fixedSearchPeriod=three_month">
		<img src="${contextPath}/resources/image/btn_search_3_month.jpg" alt="3개월"></a>
	<a href="${contextPath}/admin/order/adminOrderMain.do?fixedSearchPeriod=four_month">
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
			<th>주문자</th>
			<th>수령자</th>
			<th>수령자 휴대폰</th>
			<th>배송상태</th>
			<th>배송수정</th>
		</tr>
	</thead>
	<tbody>
		<c:choose>
			<c:when test="${empty newOrderList}">
				<tr>
					<td colspan="9" style="padding:40px 0;">조회된 주문이 없습니다.</td>
				</tr>
			</c:when>
			<c:otherwise>
				<c:forEach var="item" items="${newOrderList}" varStatus="i">
					<tr>
						<td>
							<a href="${contextPath}/admin/order/orderDetail.do?order_id=${item.order_id}">
								<strong>${item.order_id}</strong>
							</a>
						</td>
						<td>${fn:substring(item.pay_order_time, 0, 16)}</td>
						<td class="left">${item.goods_title}</td>
						<td>${item.order_goods_qty}개</td>
						<td>${item.orderer_name}</td>
						<td>${item.receiver_name}</td>
						<td>${item.receiver_hp1}-${item.receiver_hp2}-${item.receiver_hp3}</td>
						<td>
							<select id="delivery_state_${i.index}">
								<option value="delivery_prepared" ${item.delivery_state=='delivery_prepared' ? 'selected' : ''}>배송준비중</option>
								<option value="delivering" ${item.delivery_state=='delivering' ? 'selected' : ''}>배송중</option>
								<option value="finished_delivering" ${item.delivery_state=='finished_delivering' ? 'selected' : ''}>배송완료</option>
								<option value="cancel_order" ${item.delivery_state=='cancel_order' ? 'selected' : ''}>주문취소</option>
								<option value="returning_goods" ${item.delivery_state=='returning_goods' ? 'selected' : ''}>반품</option>
							</select>
						</td>
						<td>
							<input type="button" class="btn" value="배송수정"
							       onClick="fn_modify_order_state('${item.order_id}', 'delivery_state_${i.index}')">
						</td>
					</tr>
				</c:forEach>
			</c:otherwise>
		</c:choose>
	</tbody>
</table>

<div class="btn_box" style="font-size:0.75em;">
	<c:if test="${section > 1}">
		<a href="${contextPath}/admin/order/adminOrderMain.do?section=${section-1}&pageNum=1&fixedSearchPeriod=${period}">pre</a>
	</c:if>
	<c:forEach var="page" begin="1" end="10" step="1">
		<c:choose>
			<c:when test="${page == pageNum}">
				<strong><a href="${contextPath}/admin/order/adminOrderMain.do?section=${section}&pageNum=${page}&fixedSearchPeriod=${period}">${(section-1)*10 + page}</a></strong>
			</c:when>
			<c:otherwise>
				<a href="${contextPath}/admin/order/adminOrderMain.do?section=${section}&pageNum=${page}&fixedSearchPeriod=${period}">${(section-1)*10 + page}</a>
			</c:otherwise>
		</c:choose>
	</c:forEach>
	<a href="${contextPath}/admin/order/adminOrderMain.do?section=${section+1}&pageNum=1&fixedSearchPeriod=${period}">next</a>
</div>
<div class="clear"></div>
