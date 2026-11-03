<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<%-- myOrderList: 주문 완료된 상품 목록, myOrderInfo: 배송/결제 입력값(Map), orderer: 세션의 주문자 --%>

<h3>주문이 완료되었습니다.</h3>
<br>
<h4>최종 주문 내역</h4>
<table class="table_basic">
	<thead>
		<tr>
			<th>주문번호</th>
			<th colspan="2">주문상품명</th>
			<th>수량</th>
			<th>주문금액</th>
			<th>배송비</th>
			<th>예상적립금</th>
			<th>주문금액합계</th>
		</tr>
	</thead>
	<tbody>
		<c:set var="totalPrice" value="0" />
		<c:forEach var="item" items="${myOrderList}">
			<tr>
				<td>${item.order_id}</td>
				<td style="width:80px;">
					<a href="${contextPath}/goods/goodsDetail.do?goods_id=${item.goods_id}">
						<img width="75" alt="${item.goods_title}"
						     src="${contextPath}/thumbnails.do?goods_id=${item.goods_id}&fileName=${item.goods_fileName}">
					</a>
				</td>
				<td class="left"><strong>${item.goods_title}</strong></td>
				<td>${item.order_goods_qty}개</td>
				<td><fmt:formatNumber value="${item.goods_sales_price}" type="number" />원</td>
				<td>0원</td>
				<td><fmt:formatNumber value="${item.goods_sales_price * item.order_goods_qty * 0.01}" type="number" maxFractionDigits="0" />원</td>
				<td><strong><fmt:formatNumber value="${item.goods_sales_price * item.order_goods_qty}" type="number" />원</strong></td>
			</tr>
			<c:set var="totalPrice" value="${totalPrice + item.goods_sales_price * item.order_goods_qty}" />
		</c:forEach>
	</tbody>
</table>
<div class="sum_box">
	최종 결제금액 <strong><fmt:formatNumber value="${totalPrice}" type="number" />원</strong>
</div>

<h4 style="margin-top:20px;">받으시는 분 정보</h4>
<table class="form_table">
	<tbody>
		<tr>
			<td class="fixed_join">배송방법</td>
			<td>${myOrderInfo.delivery_method}</td>
		</tr>
		<tr>
			<td class="fixed_join">받으시는 분</td>
			<td>${myOrderInfo.receiver_name}</td>
		</tr>
		<tr>
			<td class="fixed_join">휴대폰</td>
			<td>${myOrderInfo.receiver_hp1}-${myOrderInfo.receiver_hp2}-${myOrderInfo.receiver_hp3}</td>
		</tr>
		<tr>
			<td class="fixed_join">유선전화</td>
			<td>${myOrderInfo.receiver_tel1}-${myOrderInfo.receiver_tel2}-${myOrderInfo.receiver_tel3}</td>
		</tr>
		<tr>
			<td class="fixed_join">주소</td>
			<td>${myOrderInfo.delivery_address}</td>
		</tr>
		<tr>
			<td class="fixed_join">배송 메시지</td>
			<td><c:out value="${myOrderInfo.delivery_message}" /></td>
		</tr>
		<tr>
			<td class="fixed_join">선물 포장</td>
			<td>${myOrderInfo.gift_wrapping}</td>
		</tr>
	</tbody>
</table>

<h4 style="margin-top:20px;">결제 정보</h4>
<table class="form_table">
	<tbody>
		<tr>
			<td class="fixed_join">결제방법</td>
			<td>${myOrderInfo.pay_method}</td>
		</tr>
		<c:if test="${not empty myOrderInfo.card_com_name}">
			<tr>
				<td class="fixed_join">결제 카드</td>
				<td>${myOrderInfo.card_com_name} (${myOrderInfo.card_pay_month})</td>
			</tr>
		</c:if>
		<c:if test="${not empty myOrderInfo.pay_orderer_hp_num and myOrderInfo.pay_method == '휴대폰결제'}">
			<tr>
				<td class="fixed_join">결제 휴대폰</td>
				<td>${myOrderInfo.pay_orderer_hp_num}</td>
			</tr>
		</c:if>
	</tbody>
</table>

<div class="btn_box">
	<a href="${contextPath}/main/main.do">쇼핑 계속하기</a>
	<a href="${contextPath}/mypage/myPageMain.do">주문내역 보기</a>
</div>
<div class="clear"></div>
