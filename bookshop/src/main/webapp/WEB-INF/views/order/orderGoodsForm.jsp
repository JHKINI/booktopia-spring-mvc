<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<%-- myOrderList, orderer 는 컨트롤러가 세션에 저장해 둔 값 --%>

<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script type="text/javascript">
function execDaumPostcode() {
	new daum.Postcode({
		oncomplete : function(data) {
			document.getElementById('zipcode').value = data.zonecode;
			document.getElementById('roadAddress').value = data.roadAddress;
			document.getElementById('jibunAddress').value = data.jibunAddress;
			document.getElementById('namujiAddress').focus();
		}
	}).open();
}

// 배송지: 주문자와 동일 / 새로 입력
function restore_all() {
	$("#receiver_name").val("");
	$("#receiver_hp2").val("");
	$("#receiver_hp3").val("");
	$("#receiver_tel2").val("");
	$("#receiver_tel3").val("");
	$("#zipcode").val("");
	$("#roadAddress").val("");
	$("#jibunAddress").val("");
	$("#namujiAddress").val("");
}

function reset_all() {
	$("#receiver_name").val("${orderer.member_name}");
	$("#receiver_hp1").val("${orderer.hp1}");
	$("#receiver_hp2").val("${orderer.hp2}");
	$("#receiver_hp3").val("${orderer.hp3}");
	$("#receiver_tel1").val("${orderer.tel1}");
	$("#receiver_tel2").val("${orderer.tel2}");
	$("#receiver_tel3").val("${orderer.tel3}");
	$("#zipcode").val("${orderer.zipcode}");
	$("#roadAddress").val("${orderer.roadAddress}");
	$("#jibunAddress").val("${orderer.jibunAddress}");
	$("#namujiAddress").val("${orderer.namujiAddress}");
}

// 결제 방법에 따라 필요한 입력 영역만 보여주기
function fn_pay_phone() {
	$("#tr_pay_card").hide();
	$("#tr_pay_phone").show();
}
function fn_pay_card() {
	$("#tr_pay_card").show();
	$("#tr_pay_phone").hide();
}
function fn_pay_etc() {
	$("#tr_pay_card").hide();
	$("#tr_pay_phone").hide();
}

// 결제하기: 배송지 주소를 하나로 합쳐서 전송
function fn_show_order_detail() {
	var f = document.frmOrder;
	if (f.receiver_name.value == "") {
		alert("수령인 이름을 입력해 주세요.");
		f.receiver_name.focus();
		return;
	}
	if ($("#zipcode").val() == "") {
		alert("배송 주소를 입력해 주세요.");
		return;
	}
	var address = "우편번호:" + $("#zipcode").val()
	            + "<br>도로명 주소:" + $("#roadAddress").val()
	            + "<br>[지번 주소:" + $("#jibunAddress").val() + "]"
	            + "<br>나머지 주소:" + $("#namujiAddress").val();
	$("#delivery_address").val(address);
	if (!confirm("최종 결제하시겠습니까?")) return;
	f.method = "post";
	f.action = "${contextPath}/order/payToOrderGoods.do";
	f.submit();
}

$(document).ready(function() {
	// 기본값: 주문자 정보와 동일
	reset_all();
	fn_pay_card();
});
</script>

<h3>주문확인</h3>
<table class="table_basic">
	<thead>
		<tr>
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
		<c:set var="totalDelivery" value="0" />
		<c:forEach var="item" items="${myOrderList}">
			<tr>
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
	총 상품금액 <fmt:formatNumber value="${totalPrice}" type="number" />원 + 배송비 0원 =
	최종 결제금액 <strong><fmt:formatNumber value="${totalPrice}" type="number" />원</strong>
</div>

<form name="frmOrder">
	<h3 style="margin-top:20px;">배송지 정보</h3>
	<table class="form_table">
		<tbody>
			<tr>
				<td class="fixed_join">배송방법</td>
				<td>
					<input type="radio" name="delivery_method" value="일반택배" checked> 일반택배
					&nbsp;&nbsp;
					<input type="radio" name="delivery_method" value="편의점택배"> 편의점택배
					&nbsp;&nbsp;
					<input type="radio" name="delivery_method" value="해외배송"> 해외배송
				</td>
			</tr>
			<tr>
				<td class="fixed_join">배송지 선택</td>
				<td>
					<input type="radio" name="addr_type" onClick="reset_all()" checked> 기본배송지
					&nbsp;&nbsp;
					<input type="radio" name="addr_type" onClick="restore_all()"> 새로입력
				</td>
			</tr>
			<tr>
				<td class="fixed_join">받으실 분</td>
				<td><input id="receiver_name" name="receiver_name" type="text" size="20"></td>
			</tr>
			<tr>
				<td class="fixed_join">휴대폰</td>
				<td>
					<select id="receiver_hp1" name="receiver_hp1">
						<option value="010">010</option>
						<option value="011">011</option>
						<option value="016">016</option>
						<option value="017">017</option>
						<option value="018">018</option>
						<option value="019">019</option>
					</select>
					- <input size="10" type="text" id="receiver_hp2" name="receiver_hp2">
					- <input size="10" type="text" id="receiver_hp3" name="receiver_hp3">
				</td>
			</tr>
			<tr>
				<td class="fixed_join">유선전화</td>
				<td>
					<select id="receiver_tel1" name="receiver_tel1">
						<option value="02">02</option>
						<option value="031">031</option>
						<option value="032">032</option>
						<option value="033">033</option>
						<option value="041">041</option>
						<option value="042">042</option>
						<option value="043">043</option>
						<option value="051">051</option>
						<option value="052">052</option>
						<option value="053">053</option>
						<option value="054">054</option>
						<option value="055">055</option>
						<option value="061">061</option>
						<option value="062">062</option>
						<option value="063">063</option>
						<option value="064">064</option>
					</select>
					- <input size="10" type="text" id="receiver_tel2" name="receiver_tel2">
					- <input size="10" type="text" id="receiver_tel3" name="receiver_tel3">
				</td>
			</tr>
			<tr>
				<td class="fixed_join">주소</td>
				<td>
					<input type="text" id="zipcode" size="5" readonly>
					<a href="javascript:execDaumPostcode()">우편번호검색</a><br><br>
					지번 주소: <input type="text" id="jibunAddress" size="50" readonly><br><br>
					도로명 주소: <input type="text" id="roadAddress" size="50" readonly><br><br>
					나머지 주소: <input type="text" id="namujiAddress" size="50">
					<input type="hidden" id="delivery_address" name="delivery_address">
				</td>
			</tr>
			<tr>
				<td class="fixed_join">배송 메시지</td>
				<td><input id="delivery_message" name="delivery_message" type="text" size="60" placeholder="택배 기사님께 전달할 메시지를 입력해 주세요."></td>
			</tr>
			<tr>
				<td class="fixed_join">선물 포장</td>
				<td>
					<input type="radio" name="gift_wrapping" value="yes"> 선물 포장
					&nbsp;&nbsp;
					<input type="radio" name="gift_wrapping" value="no" checked> 선물 포장 안 함
				</td>
			</tr>
		</tbody>
	</table>

	<h3 style="margin-top:20px;">주문고객</h3>
	<table class="form_table">
		<tbody>
			<tr>
				<td class="fixed_join">이름</td>
				<td>${orderer.member_name}</td>
			</tr>
			<tr>
				<td class="fixed_join">핸드폰</td>
				<td>${orderer.hp1}-${orderer.hp2}-${orderer.hp3}</td>
			</tr>
			<tr>
				<td class="fixed_join">이메일</td>
				<td>${orderer.email1}@${orderer.email2}</td>
			</tr>
		</tbody>
	</table>

	<h3 style="margin-top:20px;">결제정보</h3>
	<table class="form_table">
		<tbody>
			<tr>
				<td class="fixed_join">결제방법</td>
				<td>
					<input type="radio" name="pay_method" value="신용카드" onClick="fn_pay_card()" checked> 신용카드 &nbsp;&nbsp;
					<input type="radio" name="pay_method" value="제휴 신용카드" onClick="fn_pay_card()"> 제휴 신용카드 &nbsp;&nbsp;
					<input type="radio" name="pay_method" value="무통장입금" onClick="fn_pay_etc()"> 무통장입금 &nbsp;&nbsp;
					<input type="radio" name="pay_method" value="휴대폰결제" onClick="fn_pay_phone()"> 휴대폰결제
				</td>
			</tr>
			<tr id="tr_pay_card">
				<td class="fixed_join">카드 선택</td>
				<td>
					<select name="card_com_name">
						<option value="삼성" selected>삼성</option>
						<option value="하나SK">하나SK</option>
						<option value="현대">현대</option>
						<option value="KB">KB</option>
						<option value="신한">신한</option>
						<option value="롯데">롯데</option>
						<option value="BC">BC</option>
						<option value="시티">시티</option>
						<option value="NH농협">NH농협</option>
					</select>
					&nbsp;&nbsp;할부기간:
					<select name="card_pay_month">
						<option value="일시불" selected>일시불</option>
						<option value="2개월">2개월</option>
						<option value="3개월">3개월</option>
						<option value="4개월">4개월</option>
						<option value="5개월">5개월</option>
						<option value="6개월">6개월</option>
					</select>
				</td>
			</tr>
			<tr id="tr_pay_phone" style="display:none;">
				<td class="fixed_join">휴대폰 번호</td>
				<td>
					<input type="text" name="pay_orderer_hp_num" size="15" value="${orderer.hp1}-${orderer.hp2}-${orderer.hp3}">
				</td>
			</tr>
		</tbody>
	</table>
</form>

<div class="btn_box">
	<a href="javascript:fn_show_order_detail();">
		<img width="75" alt="결제하기" src="${contextPath}/resources/image/btn_order_final.jpg" style="width:120px;">
	</a>
	<a href="${contextPath}/main/main.do">
		<img alt="쇼핑 계속하기" src="${contextPath}/resources/image/btn_shoping_continue.jpg" style="width:100px;">
	</a>
</div>
<div class="clear"></div>
