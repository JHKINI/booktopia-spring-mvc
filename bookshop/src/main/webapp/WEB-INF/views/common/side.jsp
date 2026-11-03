<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<nav>
<ul>
	<c:choose>
		<%-- 관리자 메뉴 --%>
		<c:when test="${side_menu=='admin_mode'}">
			<li>
				<h3>주요기능</h3>
				<ul>
					<li><a href="${contextPath}/admin/goods/adminGoodsMain.do">상품관리</a></li>
					<li><a href="${contextPath}/admin/order/adminOrderMain.do">주문관리</a></li>
					<li><a href="${contextPath}/admin/member/adminMemberMain.do">회원관리</a></li>
					<li><a href="#">배송관리</a></li>
					<li><a href="#">게시판관리</a></li>
				</ul>
			</li>
		</c:when>
		<%-- 마이페이지 메뉴 --%>
		<c:when test="${side_menu=='my_page'}">
			<li>
				<h3>주문내역</h3>
				<ul>
					<li><a href="${contextPath}/mypage/listMyOrderHistory.do">주문내역/배송 조회</a></li>
					<li><a href="#">반품/교환 신청 및 조회</a></li>
					<li><a href="#">취소 주문 내역</a></li>
					<li><a href="#">세금계산서/현금영수증</a></li>
				</ul>
			</li>
			<li>
				<h3>정보내역</h3>
				<ul>
					<li><a href="${contextPath}/mypage/myDetailInfo.do">회원정보관리</a></li>
					<li><a href="#">나의 주소록</a></li>
					<li><a href="#">개인정보동의내역</a></li>
					<li><a href="#">회원탈퇴</a></li>
				</ul>
			</li>
		</c:when>
		<%-- 일반 사용자 메뉴 --%>
		<c:otherwise>
			<li>
				<h3>국내외 도서</h3>
				<ul>
					<li><a href="#">경제경영</a></li>
					<li><a href="#">공학/컴퓨터</a></li>
					<li><a href="#">자연과학</a></li>
					<li><a href="#">외국어</a></li>
					<li><a href="#">여행/레저</a></li>
				</ul>
			</li>
			<li>
				<h3>어린이 도서</h3>
				<ul>
					<li><a href="#">유아/놀이책</a></li>
					<li><a href="#">초등학습</a></li>
					<li><a href="#">어린이문학</a></li>
				</ul>
			</li>
			<li>
				<h3>문구/GIFT</h3>
				<ul>
					<li><a href="#">문구/필기구</a></li>
					<li><a href="#">캐릭터상품</a></li>
					<li><a href="#">포토/앨범</a></li>
				</ul>
			</li>
		</c:otherwise>
	</c:choose>
</ul>
</nav>

<div id="banner">
	<a href="#"><img width="190" alt="" src="${contextPath}/resources/image/side_banner1.jpg"></a>
</div>
<div id="notice">
	<h2>공지사항</h2>
	<ul>
		<li><a href="#">공지사항 입니다.1</a></li>
		<li><a href="#">공지사항 입니다.2</a></li>
		<li><a href="#">공지사항 입니다.3</a></li>
		<li><a href="#">공지사항 입니다.4</a></li>
		<li><a href="#">공지사항 입니다.5</a></li>
	</ul>
</div>
<div id="banner">
	<a href="#"><img width="190" height="auto" alt="" src="${contextPath}/resources/image/call_center_logo.jpg"></a>
</div>
<div id="banner">
	<a href="#"><img width="190" height="auto" alt="" src="${contextPath}/resources/image/QnA_logo.jpg"></a>
</div>
