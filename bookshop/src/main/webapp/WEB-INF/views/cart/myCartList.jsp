<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<c:set var="myCartList" value="${cartMap.myCartList}" />
<c:set var="myGoodsList" value="${cartMap.myGoodsList}" />

<script type="text/javascript">
// 체크된 상품의 합계 금액 계산
function calcTotal() {
	var total = 0, count = 0;
	$("input.chk_goods").each(function() {
		if (this.checked) {
			var idx = $(this).attr("data-idx");
			var price = parseInt($("#price_" + idx).val(), 10);
			var qty = parseInt($("#qty_" + idx).val(), 10);
			total += price * qty;
			count += 1;
		}
	});
	$("#p_totalGoodsNum").text(count);
	$("#p_final_totalPrice").text(addComma(total));
}

function addComma(n) {
	return String(n).replace(/\B(?=(\d{3})+(?!\d))/g, ",");
}

function checkAll(master) {
	$("input.chk_goods").each(function() { this.checked = master.checked; });
	calcTotal();
}

// 수량 수정
function modify_cart_qty(goods_id, idx) {
	var qty = $("#qty_" + idx).val();
	if (isNaN(qty) || parseInt(qty, 10) < 1) {
		alert("수량은 1 이상의 숫자로 입력해 주세요.");
		return;
	}
	$.ajax({
		type : "post",
		async : false,
		url : "${contextPath}/cart/modifyCartQty.do",
		data : { goods_id : goods_id, cart_goods_qty : qty },
		success : function(data, textStatus) {
			if (data.trim() == 'modify_success') {
				alert("수량을 변경했습니다.");
				location.href = "${contextPath}/cart/myCartList.do";
			} else {
				alert("다시 시도해 주세요.");
			}
		},
		error : function(data, textStatus) {
			alert("에러가 발생했습니다. " + textStatus);
		}
	});
}

// 장바구니에서 삭제
function delete_cart_goods(cart_id) {
	if (!confirm("장바구니에서 삭제할까요?")) return;
	var form = document.createElement("form");
	var input = document.createElement("input");
	input.type = "hidden";
	input.name = "cart_id";
	input.value = cart_id;
	form.appendChild(input);
	document.body.appendChild(form);
	form.method = "post";
	form.action = "${contextPath}/cart/removeCartGoods.do";
	form.submit();
}

// 선택한 상품 주문: "상품번호:주문수량" 형식으로 cart_goods_qty 에 담아 전송
function fn_order_selected_goods() {
	var form = document.createElement("form");
	var count = 0;
	$("input.chk_goods").each(function() {
		if (this.checked) {
			var idx = $(this).attr("data-idx");
			var input = document.createElement("input");
			input.type = "hidden";
			input.name = "cart_goods_qty";
			input.value = this.value + ":" + $("#qty_" + idx).val();
			form.appendChild(input);
			count++;
		}
	});
	if (count == 0) {
		alert("주문할 상품을 선택해 주세요.");
		return;
	}
	document.body.appendChild(form);
	form.method = "post";
	form.action = "${contextPath}/order/orderAllCartGoods.do";
	form.submit();
}

function fn_order_all_goods() {
	$("input.chk_goods").each(function() { this.checked = true; });
	fn_order_selected_goods();
}

$(document).ready(function() {
	$("input.chk_goods").click(calcTotal);
	calcTotal();
});
</script>

<h3>장바구니</h3>
<table class="table_basic">
	<thead>
		<tr>
			<th><input type="checkbox" onclick="checkAll(this)" checked></th>
			<th colspan="2">상품명</th>
			<th>정가</th>
			<th>판매가</th>
			<th>수량</th>
			<th>합계</th>
			<th>주문</th>
		</tr>
	</thead>
	<tbody>
		<c:choose>
			<c:when test="${empty myCartList or empty myGoodsList}">
				<tr>
					<td colspan="8" style="padding:40px 0;">장바구니에 담긴 상품이 없습니다.</td>
				</tr>
			</c:when>
			<c:otherwise>
				<c:forEach var="item" items="${myGoodsList}" varStatus="cnt">
					<%-- 상품 목록과 장바구니 목록은 정렬 순서가 다를 수 있으므로 goods_id 로 매칭한다 --%>
					<c:set var="cart_id" value="0" />
					<c:set var="cart_goods_qty" value="1" />
					<c:forEach var="cartItem" items="${myCartList}">
						<c:if test="${cartItem.goods_id == item.goods_id}">
							<c:set var="cart_id" value="${cartItem.cart_id}" />
							<c:set var="cart_goods_qty" value="${cartItem.cart_goods_qty}" />
						</c:if>
					</c:forEach>
					<tr>
						<td>
							<input type="checkbox" class="chk_goods" data-idx="${cnt.index}" value="${item.goods_id}" checked>
							<input type="hidden" id="price_${cnt.index}" value="${item.goods_sales_price}">
						</td>
						<td style="width:80px;">
							<a href="${contextPath}/goods/goodsDetail.do?goods_id=${item.goods_id}">
								<img width="75" alt="${item.goods_title}"
								     src="${contextPath}/thumbnails.do?goods_id=${item.goods_id}&fileName=${item.goods_fileName}">
							</a>
						</td>
						<td class="left">
							<a href="${contextPath}/goods/goodsDetail.do?goods_id=${item.goods_id}"><strong>${item.goods_title}</strong></a>
						</td>
						<td><fmt:formatNumber value="${item.goods_price}" type="number" />원</td>
						<td><strong><fmt:formatNumber value="${item.goods_sales_price}" type="number" />원</strong></td>
						<td>
							<input type="text" id="qty_${cnt.index}" size="3" value="${cart_goods_qty}"><br>
							<a href="javascript:modify_cart_qty(${item.goods_id}, ${cnt.index});">
								<img width="25" alt="수량수정" src="${contextPath}/resources/image/btn_modify_qty.jpg">
							</a>
						</td>
						<td><strong><fmt:formatNumber value="${item.goods_sales_price * cart_goods_qty}" type="number" />원</strong></td>
						<td>
							<a href="javascript:delete_cart_goods(${cart_id});">삭제</a>
						</td>
					</tr>
				</c:forEach>
			</c:otherwise>
		</c:choose>
	</tbody>
</table>

<div class="sum_box">
	선택 상품 <strong id="p_totalGoodsNum">0</strong>개 &nbsp;|&nbsp;
	최종 결제 예정 금액 <strong id="p_final_totalPrice">0</strong>원
</div>

<div class="btn_box">
	<c:if test="${not empty myCartList}">
		<a href="javascript:fn_order_all_goods();">전체 주문하기</a>
		<a href="javascript:fn_order_selected_goods();">선택 상품 주문하기</a>
	</c:if>
	<a href="${contextPath}/main/main.do">쇼핑 계속하기</a>
</div>
<div class="clear"></div>
