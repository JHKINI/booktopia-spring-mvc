<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<script type="text/javascript">
var cnt = 0; // 상세 이미지 개수

// 상세 이미지 첨부 칸 추가. 첫 번째 칸(main_image)은 메인 이미지 전용이다.
function fn_addFile() {
	if (cnt >= 9) {
		alert("상세 이미지는 최대 9개까지 첨부할 수 있습니다.");
		return;
	}
	cnt++;
	$("#d_file").append("<br>" + "<input type='file' name='detail_image" + cnt + "' id='detail_image" + cnt + "'/>");
}

function fn_check_form() {
	var f = document.frmNewGoods;
	if (f.goods_title.value == "") {
		alert("상품 이름을 입력해 주세요.");
		f.goods_title.focus();
		return false;
	}
	if (f.main_image.value == "") {
		alert("메인 이미지를 첨부해 주세요.");
		return false;
	}
	return true;
}
</script>

<h3>새상품 등록</h3>
<form name="frmNewGoods" action="${contextPath}/admin/goods/addNewGoods.do" method="post"
      enctype="multipart/form-data" onsubmit="return fn_check_form();">
	<div class="clear"></div>
	<div id="container">
		<ul class="tabs">
			<li><a href="#tab1">상품정보</a></li>
			<li><a href="#tab2">상품목차</a></li>
			<li><a href="#tab3">상품저자소개</a></li>
			<li><a href="#tab4">상품소개</a></li>
			<li><a href="#tab5">출판사 상품 평가</a></li>
			<li><a href="#tab6">추천사</a></li>
			<li><a href="#tab7">상품이미지</a></li>
		</ul>
		<div class="tab_container">
			<div class="tab_content" id="tab1">
				<table class="form_table">
					<tr>
						<td class="fixed_join">제품분류</td>
						<td>
							<select name="goods_sort">
								<option value="컴퓨터와 인터넷" selected>컴퓨터와 인터넷</option>
								<option value="디지털 기기">디지털 기기</option>
							</select>
						</td>
					</tr>
					<tr>
						<td class="fixed_join">제품종류</td>
						<td>
							<select name="goods_status">
								<option value="bestseller">베스트셀러</option>
								<option value="steadyseller">스테디셀러</option>
								<option value="newbook" selected>신간</option>
								<option value="on_sale">판매중</option>
								<option value="buy_out">품절</option>
								<option value="out_of_print">절판</option>
							</select>
						</td>
					</tr>
					<tr>
						<td class="fixed_join">제품이름</td>
						<td><input name="goods_title" type="text" size="40"></td>
					</tr>
					<tr>
						<td class="fixed_join">저자</td>
						<td><input name="goods_writer" type="text" size="40"></td>
					</tr>
					<tr>
						<td class="fixed_join">출판사</td>
						<td><input name="goods_publisher" type="text" size="40"></td>
					</tr>
					<tr>
						<td class="fixed_join">제품정가</td>
						<td><input name="goods_price" type="text" size="40"></td>
					</tr>
					<tr>
						<td class="fixed_join">제품판매가격</td>
						<td><input name="goods_sales_price" type="text" size="40"></td>
					</tr>
					<tr>
						<td class="fixed_join">제품구매포인트</td>
						<td><input name="goods_point" type="text" size="40"></td>
					</tr>
					<tr>
						<td class="fixed_join">제품출판일</td>
						<td><input name="goods_published_date" type="date"></td>
					</tr>
					<tr>
						<td class="fixed_join">제품총페이지수</td>
						<td><input name="goods_total_page" type="text" size="40"></td>
					</tr>
					<tr>
						<td class="fixed_join">ISBN</td>
						<td><input name="goods_isbn" type="text" size="40"></td>
					</tr>
					<tr>
						<td class="fixed_join">제품배송비</td>
						<td><input name="goods_delivery_price" type="text" size="40"></td>
					</tr>
					<tr>
						<td class="fixed_join">제품도착예정일</td>
						<td><input name="goods_delivery_date" type="date"></td>
					</tr>
				</table>
			</div>
			<div class="tab_content" id="tab2">
				<h4>책목차</h4>
				<p><textarea rows="20" cols="80" name="goods_contents_order"></textarea></p>
			</div>
			<div class="tab_content" id="tab3">
				<h4>저자소개</h4>
				<p><textarea rows="20" cols="80" name="goods_writer_intro"></textarea></p>
			</div>
			<div class="tab_content" id="tab4">
				<h4>책소개</h4>
				<p><textarea rows="20" cols="80" name="goods_intro"></textarea></p>
			</div>
			<div class="tab_content" id="tab5">
				<h4>출판사 상품 평가</h4>
				<p><textarea rows="20" cols="80" name="goods_publisher_comment"></textarea></p>
			</div>
			<div class="tab_content" id="tab6">
				<h4>추천사</h4>
				<p><textarea rows="20" cols="80" name="goods_recommendation"></textarea></p>
			</div>
			<div class="tab_content" id="tab7">
				<h4>상품 이미지</h4>
				<p>첫 번째 파일은 반드시 메인 이미지를 첨부하세요.</p>
				<input type="button" class="btn" value="파일 추가" onClick="fn_addFile()">
				<div id="d_file">
					<input type="file" name="main_image" id="main_image">
				</div>
			</div>
		</div>
	</div>
	<div class="clear"></div>
	<div class="btn_box">
		<input type="submit" class="btn" value="상품 등록하기">
	</div>
</form>
