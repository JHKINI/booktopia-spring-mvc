<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<script type="text/javascript">
var quickIdx = 0;                       // 현재 표시 중인 최근 본 상품 인덱스
var quickTotal = ${empty quickGoodsListNum ? 0 : quickGoodsListNum};

function showQuick(idx) {
	$(".quick_item").hide();
	$("#quick_item_" + idx).show();
	$("#quick_page").text((idx + 1) + "/" + quickTotal);
}
function quickPrev() {
	if (quickTotal == 0) return;
	if (quickIdx > 0) quickIdx--;
	showQuick(quickIdx);
}
function quickNext() {
	if (quickTotal == 0) return;
	if (quickIdx < quickTotal - 1) quickIdx++;
	showQuick(quickIdx);
}
$(document).ready(function() {
	if (quickTotal > 0) showQuick(0);
});
</script>

<div id="sticky">
	<ul>
		<li><a href="#">즐겨찾기</a></li>
		<li><a href="#">고객센터</a></li>
		<li><a href="${contextPath}/cart/myCartList.do">장바구니</a></li>
		<li><a href="${contextPath}/mypage/myPageMain.do">마이페이지</a></li>
	</ul>
	<div class="recent">
		<h3>최근 본 상품</h3>
		<ul>
			<c:choose>
				<c:when test="${empty quickGoodsList}">
					<li><strong>&nbsp;상품이 없습니다.</strong></li>
				</c:when>
				<c:otherwise>
					<c:forEach var="item" items="${quickGoodsList}" varStatus="itemNum">
						<li class="quick_item" id="quick_item_${itemNum.index}" style="display:none;">
							<a href="${contextPath}/goods/goodsDetail.do?goods_id=${item.goods_id}">
								<img width="75" height="95" alt="${item.goods_title}"
								     src="${contextPath}/thumbnails.do?goods_id=${item.goods_id}&fileName=${item.goods_fileName}">
							</a>
						</li>
					</c:forEach>
				</c:otherwise>
			</c:choose>
		</ul>
	</div>
	<div>
		<c:if test="${not empty quickGoodsList}">
			<a href="javascript:quickPrev();">이전</a>
			<span id="quick_page">1/${quickGoodsListNum}</span>
			<a href="javascript:quickNext();">다음</a>
		</c:if>
	</div>
</div>
