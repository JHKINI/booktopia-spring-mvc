<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<script type="text/javascript">
var isLogOn = ${isLogOn == true ? 'true' : 'false'};

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
</script>

<hgroup>
	<h1>검색 결과</h1>
	<h2>"<c:out value="${param.searchWord}" />" 검색 결과: ${fn:length(goodsList)}건</h2>
</hgroup>

<table class="list_view">
	<tbody>
		<c:choose>
			<c:when test="${empty goodsList}">
				<tr>
					<td colspan="4" style="text-align:center; padding:40px 0;">검색된 상품이 없습니다.</td>
				</tr>
			</c:when>
			<c:otherwise>
				<c:forEach var="item" items="${goodsList}">
					<tr>
						<td class="goods_image">
							<a href="${contextPath}/goods/goodsDetail.do?goods_id=${item.goods_id}">
								<img width="75" alt="${item.goods_title}"
								     src="${contextPath}/thumbnails.do?goods_id=${item.goods_id}&fileName=${item.goods_fileName}">
							</a>
						</td>
						<td class="goods_description">
							<h2><a href="${contextPath}/goods/goodsDetail.do?goods_id=${item.goods_id}">${item.goods_title}</a></h2>
							<div class="writer_press">${item.goods_writer} 저 | ${item.goods_publisher} |
								<fmt:formatDate value="${item.goods_published_date}" pattern="yyyy-MM-dd" /></div>
						</td>
						<td class="price">
							<span><fmt:formatNumber value="${item.goods_price}" type="number" />원</span><br>
							<strong><fmt:formatNumber value="${item.goods_sales_price}" type="number" />원</strong><br>
							(<fmt:formatNumber value="${(item.goods_price - item.goods_sales_price) / item.goods_price}" type="percent" /> 할인)
						</td>
						<td class="buy_btns">
							<ul>
								<li><a href="javascript:add_cart('${item.goods_id}');">장바구니</a></li>
								<li><a href="${contextPath}/goods/goodsDetail.do?goods_id=${item.goods_id}">상세보기</a></li>
							</ul>
						</td>
					</tr>
				</c:forEach>
			</c:otherwise>
		</c:choose>
	</tbody>
</table>
<div class="clear"></div>
