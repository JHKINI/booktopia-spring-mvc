<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<c:set var="orderList" value="${orderMap.orderList}" />
<c:set var="info" value="${orderMap.deliveryInfo}" />
<c:set var="orderer" value="${orderMap.orderer}" />

<script type="text/javascript">
// 배송 상태 수정 (Ajax)
function fn_modify_order_state(order_id) {
	var delivery_state = $("#delivery_state").val();
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

<h3>주문 상세 정보</h3>
<table class="table_basic">
	<thead>
		<tr>
			<th>주문번호</th>
			<th colspan="2">주문상품명</th>
			<th>수량</th>
			<th>주문금액</th>
			<th>주문금액합계</th>
		</tr>
	</thead>
	<tbody>
		<c:set var="totalPrice" value="0" />
		<c:forEach var="item" items="${orderList}">
			<tr>
				<td>${item.order_id}</td>
				<td style="width:80px;">
					<img width="75" alt="${item.goods_title}"
					     src="${contextPath}/thumbnails.do?goods_id=${item.goods_id}&fileName=${item.goods_fileName}">
				</td>
				<td class="left"><strong>${item.goods_title}</strong></td>
				<td>${item.order_goods_qty}개</td>
				<td><fmt:formatNumber value="${item.goods_sales_price}" type="number" />원</td>
				<td><strong><fmt:formatNumber value="${item.goods_sales_price * item.order_goods_qty}" type="number" />원</strong></td>
			</tr>
			<c:set var="totalPrice" value="${totalPrice + item.goods_sales_price * item.order_goods_qty}" />
		</c:forEach>
	</tbody>
</table>
<div class="sum_box">
	최종 결제금액 <strong><fmt:formatNumber value="${totalPrice}" type="number" />원</strong>
</div>

<h4 style="margin-top:20px;">배송 상태</h4>
<table class="form_table">
	<tbody>
		<tr>
			<td class="fixed_join">배송상태</td>
			<td>
				<select id="delivery_state">
					<option value="delivery_prepared" ${info.delivery_state=='delivery_prepared' ? 'selected' : ''}>배송준비중</option>
					<option value="delivering" ${info.delivery_state=='delivering' ? 'selected' : ''}>배송중</option>
					<option value="finished_delivering" ${info.delivery_state=='finished_delivering' ? 'selected' : ''}>배송완료</option>
					<option value="cancel_order" ${info.delivery_state=='cancel_order' ? 'selected' : ''}>주문취소</option>
					<option value="returning_goods" ${info.delivery_state=='returning_goods' ? 'selected' : ''}>반품</option>
				</select>
				<input type="button" class="btn" value="배송수정" onClick="fn_modify_order_state('${info.order_id}')">
			</td>
		</tr>
	</tbody>
</table>

<h4 style="margin-top:20px;">주문자 정보</h4>
<table class="form_table">
	<tbody>
		<tr>
			<td class="fixed_join">아이디</td>
			<td>${orderer.member_id}</td>
		</tr>
		<tr>
			<td class="fixed_join">이름</td>
			<td>${orderer.member_name}</td>
		</tr>
		<tr>
			<td class="fixed_join">휴대폰</td>
			<td>${orderer.hp1}-${orderer.hp2}-${orderer.hp3}</td>
		</tr>
		<tr>
			<td class="fixed_join">이메일</td>
			<td>${orderer.email1}@${orderer.email2}</td>
		</tr>
	</tbody>
</table>

<h4 style="margin-top:20px;">배송지 정보</h4>
<table class="form_table">
	<tbody>
		<tr>
			<td class="fixed_join">배송방법</td>
			<td>${info.delivery_method}</td>
		</tr>
		<tr>
			<td class="fixed_join">받으시는 분</td>
			<td>${info.receiver_name}</td>
		</tr>
		<tr>
			<td class="fixed_join">휴대폰</td>
			<td>${info.receiver_hp1}-${info.receiver_hp2}-${info.receiver_hp3}</td>
		</tr>
		<tr>
			<td class="fixed_join">유선전화</td>
			<td>${info.receiver_tel1}-${info.receiver_tel2}-${info.receiver_tel3}</td>
		</tr>
		<tr>
			<td class="fixed_join">주소</td>
			<td>${info.delivery_address}</td>
		</tr>
		<tr>
			<td class="fixed_join">배송 메시지</td>
			<td><c:out value="${info.delivery_message}" /></td>
		</tr>
		<tr>
			<td class="fixed_join">선물 포장</td>
			<td>${info.gift_wrapping}</td>
		</tr>
	</tbody>
</table>

<h4 style="margin-top:20px;">결제 정보</h4>
<table class="form_table">
	<tbody>
		<tr>
			<td class="fixed_join">결제방법</td>
			<td>${info.pay_method}</td>
		</tr>
		<c:if test="${not empty info.card_com_name}">
			<tr>
				<td class="fixed_join">결제 카드</td>
				<td>${info.card_com_name} (${info.card_pay_month})</td>
			</tr>
		</c:if>
		<tr>
			<td class="fixed_join">결제일시</td>
			<td>${fn:substring(info.pay_order_time, 0, 16)}</td>
		</tr>
	</tbody>
</table>

<div class="btn_box">
	<a href="${contextPath}/admin/order/adminOrderMain.do">주문 목록으로</a>
</div>
<div class="clear"></div>
