<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<c:set var="goods" value="${goodsMap.goodsVO}" />
<c:set var="imageList" value="${goodsMap.imageList}" />

<script type="text/javascript">
var isLogOn = ${isLogOn == true ? 'true' : 'false'};

// 장바구니에 담기 (Ajax)
function add_cart(goods_id) {
	if (!isLogOn) {
		alert("로그인 후 이용해 주세요.");
		location.href = "${contextPath}/member/loginForm.do";
		return;
	}
	$.ajax({
		type : "post",
		async : false,
		url : "${contextPath}/cart/addGoodsInCart.do",
		data : { goods_id : goods_id },
		success : function(data, textStatus) {
			if (data.trim() == 'add_success') {
				alert("장바구니에 추가했습니다.");
			} else if (data.trim() == 'already_existed') {
				alert("이미 카트에 등록된 상품입니다.");
			}
		},
		error : function(data, textStatus) {
			alert("에러가 발생했습니다. " + textStatus);
		}
	});
}

// 바로 구매: 주문 정보를 hidden 태그로 만들어 컨트롤러로 전송
function fn_order_each_goods() {
	// 제목에 따옴표가 있어도 깨지지 않도록 hidden 값에서 읽어온다
	var goods_id = document.getElementById("h_goods_id").value;
	var goods_title = document.getElementById("h_goods_title").value;
	var goods_sales_price = document.getElementById("h_goods_sales_price").value;
	var fileName = document.getElementById("h_goods_fileName").value;
	var order_goods_qty = document.getElementById("order_goods_qty");

	var formObj = document.createElement("form");
	var i_goods_id = document.createElement("input");
	var i_goods_title = document.createElement("input");
	var i_goods_sales_price = document.createElement("input");
	var i_fileName = document.createElement("input");
	var i_order_goods_qty = document.createElement("input");

	i_goods_id.name = "goods_id";
	i_goods_title.name = "goods_title";
	i_goods_sales_price.name = "goods_sales_price";
	i_fileName.name = "goods_fileName";
	i_order_goods_qty.name = "order_goods_qty";

	i_goods_id.value = goods_id;
	i_order_goods_qty.value = order_goods_qty.value;
	i_goods_title.value = goods_title;
	i_goods_sales_price.value = goods_sales_price;
	i_fileName.value = fileName;

	formObj.appendChild(i_goods_id);
	formObj.appendChild(i_goods_title);
	formObj.appendChild(i_goods_sales_price);
	formObj.appendChild(i_fileName);
	formObj.appendChild(i_order_goods_qty);

	document.body.appendChild(formObj);
	formObj.method = "post";
	formObj.action = "${contextPath}/order/orderEachGoods.do";
	formObj.submit();
}
</script>

<hgroup>
	<h1>컴퓨터와 인터넷</h1>
	<h2>국내외 도서 &gt; 컴퓨터와 인터넷 &gt; ${goods.goods_sort}</h2>
	<h3>${goods.goods_title}</h3>
	<h4>${goods.goods_writer} 저 | ${goods.goods_publisher} |
		<fmt:formatDate value="${goods.goods_published_date}" pattern="yyyy-MM-dd" /></h4>
</hgroup>

<div id="goods_image">
	<figure>
		<img alt="${goods.goods_title}"
		     src="${contextPath}/thumbnails.do?goods_id=${goods.goods_id}&fileName=${goods.goods_fileName}">
	</figure>
</div>

<div id="detail_table">
	<table>
		<tbody>
			<tr>
				<td class="fixed">정가</td>
				<td class="active"><span><fmt:formatNumber value="${goods.goods_price}" type="number" var="goods_price" />${goods_price}원</span></td>
			</tr>
			<tr class="dot_line">
				<td class="fixed">판매가</td>
				<td class="active">
					<span><fmt:formatNumber value="${goods.goods_sales_price}" type="number" var="sales_price" />${sales_price}원</span>
					(<fmt:formatNumber value="${(goods.goods_price - goods.goods_sales_price) / goods.goods_price}" type="percent" /> 할인)
				</td>
			</tr>
			<tr>
				<td class="fixed">포인트적립</td>
				<td class="active">${goods.goods_point}P (10%)</td>
			</tr>
			<tr class="dot_line">
				<td class="fixed">포인트 추가적립</td>
				<td>만원 이상 구매시 1,000P, 5만원 이상 구매시 2,000P 추가적립 / 편의점 포인트 추가적립</td>
			</tr>
			<tr>
				<td class="fixed">발행일</td>
				<td><fmt:formatDate value="${goods.goods_published_date}" pattern="yyyy-MM-dd" /></td>
			</tr>
			<tr class="dot_line">
				<td class="fixed">페이지 수</td>
				<td>${goods.goods_total_page}쪽</td>
			</tr>
			<tr class="dot_line">
				<td class="fixed">ISBN</td>
				<td>${goods.goods_isbn}</td>
			</tr>
			<tr>
				<td class="fixed">배송료</td>
				<td class="active"><strong>${goods.goods_delivery_price}원</strong></td>
			</tr>
			<tr>
				<td class="fixed">도착예정일</td>
				<td class="active">
					<fmt:formatDate value="${goods.goods_delivery_date}" pattern="yyyy-MM-dd" /> 이내 발송 예정
				</td>
			</tr>
			<tr>
				<td class="fixed">수량</td>
				<td>
					<select style="width: 60px;" id="order_goods_qty">
						<option>1</option>
						<option>2</option>
						<option>3</option>
						<option>4</option>
						<option>5</option>
					</select>
				</td>
			</tr>
		</tbody>
	</table>
	<ul>
		<li><a class="buy"
		       href="javascript:fn_order_each_goods();">구매하기</a></li>
		<li><a class="cart" href="javascript:add_cart('${goods.goods_id}')">장바구니</a></li>
		<li><a class="wish" href="#">위시리스트</a></li>
	</ul>
</div>
<div class="clear"></div>

<!-- 내용 들어 가는 곳 -->
<div id="container">
	<ul class="tabs">
		<li><a href="#tab1">책소개</a></li>
		<li><a href="#tab2">저자소개</a></li>
		<li><a href="#tab3">책목차</a></li>
		<li><a href="#tab4">출판사서평</a></li>
		<li><a href="#tab5">추천사</a></li>
		<li><a href="#tab6">리뷰</a></li>
	</ul>
	<div class="tab_container">
		<div class="tab_content" id="tab1">
			<h4>책소개</h4>
			<p>${goods.goods_intro}</p>
			<c:forEach var="image" items="${imageList}">
				<c:if test="${not empty image.fileName and image.fileType != 'main_image'}">
					<img src="${contextPath}/download.do?goods_id=${goods.goods_id}&fileName=${image.fileName}">
				</c:if>
			</c:forEach>
		</div>
		<div class="tab_content" id="tab2">
			<h4>저자소개</h4>
			<p>
				<div class="writer">저자 : ${goods.goods_writer}</div>
				<p>${goods.goods_writer_intro}</p>
			</p>
		</div>
		<div class="tab_content" id="tab3">
			<h4>책목차</h4>
			<p>${goods.goods_contents_order}</p>
		</div>
		<div class="tab_content" id="tab4">
			<h4>출판사서평</h4>
			<p>${goods.goods_publisher_comment}</p>
		</div>
		<div class="tab_content" id="tab5">
			<h4>추천사</h4>
			<p>${goods.goods_recommendation}</p>
		</div>
		<div class="tab_content" id="tab6">
			<h4>리뷰</h4>
			<p>아직 등록된 리뷰가 없습니다.</p>
		</div>
	</div>
</div>
<div class="clear"></div>

<input type="hidden" id="isLogOn" value="${isLogOn}" />
<input type="hidden" id="h_goods_id" value="<c:out value='${goods.goods_id}'/>" />
<input type="hidden" id="h_goods_title" value="<c:out value='${goods.goods_title}'/>" />
<input type="hidden" id="h_goods_sales_price" value="<c:out value='${goods.goods_sales_price}'/>" />
<input type="hidden" id="h_goods_fileName" value="<c:out value='${goods.goods_fileName}'/>" />
