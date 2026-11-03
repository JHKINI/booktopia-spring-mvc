<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<c:set var="goods" value="${goodsMap.goods}" />
<c:set var="imageFileList" value="${goodsMap.imageFileList}" />

<script type="text/javascript">
// 상품 정보 항목 하나를 수정 (Ajax)
// 입력 칸의 id 는 "<attribute>" 와 동일하게 맞춰 두었다.
function fn_modify_goods(goods_id, attribute) {
	var value = $("#" + attribute).val();
	$.ajax({
		type : "post",
		async : false,
		url : "${contextPath}/admin/goods/modifyGoodsInfo.do",
		data : { goods_id : goods_id, attribute : attribute, value : value },
		success : function(data, textStatus) {
			if (data.trim() == 'mod_success') {
				alert("상품 정보를 수정했습니다.");
			} else {
				alert("다시 시도해 주세요.");
			}
		},
		error : function(data, textStatus) {
			alert("에러가 발생했습니다. " + textStatus);
		}
	});
}

// 기존 이미지 수정: FormData 로 파일을 Ajax 업로드
// fileType 은 main_image / detail_image1 ... 형태이며 업로드 필드 이름으로 사용된다.
function fn_modify_image(goods_id, image_id, fileType) {
	var input = document.getElementById("file_" + image_id);
	if (!input.files || input.files.length == 0) {
		alert("수정할 이미지를 먼저 선택해 주세요.");
		return;
	}
	var formData = new FormData();
	formData.append("goods_id", goods_id);
	formData.append("image_id", image_id);
	formData.append(fileType, input.files[0]);
	$.ajax({
		url : "${contextPath}/admin/goods/modifyGoodsImageInfo.do",
		processData : false,
		contentType : false,
		data : formData,
		type : "post",
		success : function(result) {
			alert("이미지를 수정했습니다.");
			location.reload();
		},
		error : function() {
			alert("이미지 수정 중 오류가 발생했습니다.");
		}
	});
}

// 새 상세 이미지 추가
var newImageCnt = 0;
function fn_add_image_input() {
	newImageCnt++;
	$("#d_new_file").append("<br><input type='file' name='detail_new" + newImageCnt + "' class='new_file'>");
}

function fn_add_new_images(goods_id) {
	var formData = new FormData();
	formData.append("goods_id", goods_id);
	var count = 0;
	$("input.new_file").each(function() {
		if (this.files && this.files.length > 0) {
			// 서버는 필드 이름을 fileType 으로 저장하므로 detail_image + 번호 형태로 만든다.
			formData.append("detail_image" + (count + 1), this.files[0]);
			count++;
		}
	});
	if (count == 0) {
		alert("추가할 이미지를 선택해 주세요.");
		return;
	}
	$.ajax({
		url : "${contextPath}/admin/goods/addNewGoodsImage.do",
		processData : false,
		contentType : false,
		data : formData,
		type : "post",
		success : function(result) {
			alert("이미지를 추가했습니다.");
			location.reload();
		},
		error : function() {
			alert("이미지 추가 중 오류가 발생했습니다.");
		}
	});
}

// 이미지 삭제
function fn_remove_image(goods_id, image_id, fileName) {
	if (!confirm("이미지를 삭제할까요?")) return;
	$.ajax({
		type : "post",
		async : false,
		url : "${contextPath}/admin/goods/removeGoodsImage.do",
		data : { goods_id : goods_id, image_id : image_id, imageFileName : fileName },
		success : function(data, textStatus) {
			alert("이미지를 삭제했습니다.");
			location.reload();
		},
		error : function(data, textStatus) {
			alert("에러가 발생했습니다. " + textStatus);
		}
	});
}
</script>

<h3>상품 수정</h3>
<form name="frmModifyGoods">
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
							<select id="goods_sort">
								<option value="컴퓨터와 인터넷" ${goods.goods_sort=='컴퓨터와 인터넷' ? 'selected' : ''}>컴퓨터와 인터넷</option>
								<option value="디지털 기기" ${goods.goods_sort=='디지털 기기' ? 'selected' : ''}>디지털 기기</option>
							</select>
						</td>
						<td><input type="button" class="btn" value="수정반영" onClick="fn_modify_goods('${goods.goods_id}', 'goods_sort')"></td>
					</tr>
					<tr>
						<td class="fixed_join">제품종류</td>
						<td>
							<select id="goods_status">
								<option value="bestseller" ${goods.goods_status=='bestseller' ? 'selected' : ''}>베스트셀러</option>
								<option value="steadyseller" ${goods.goods_status=='steadyseller' ? 'selected' : ''}>스테디셀러</option>
								<option value="newbook" ${goods.goods_status=='newbook' ? 'selected' : ''}>신간</option>
								<option value="on_sale" ${goods.goods_status=='on_sale' ? 'selected' : ''}>판매중</option>
								<option value="buy_out" ${goods.goods_status=='buy_out' ? 'selected' : ''}>품절</option>
								<option value="out_of_print" ${goods.goods_status=='out_of_print' ? 'selected' : ''}>절판</option>
							</select>
						</td>
						<td><input type="button" class="btn" value="수정반영" onClick="fn_modify_goods('${goods.goods_id}', 'goods_status')"></td>
					</tr>
					<tr>
						<td class="fixed_join">제품이름</td>
						<td><input id="goods_title" type="text" size="40" value="<c:out value='${goods.goods_title}'/>"></td>
						<td><input type="button" class="btn" value="수정반영" onClick="fn_modify_goods('${goods.goods_id}', 'goods_title')"></td>
					</tr>
					<tr>
						<td class="fixed_join">저자</td>
						<td><input id="goods_writer" type="text" size="40" value="<c:out value='${goods.goods_writer}'/>"></td>
						<td><input type="button" class="btn" value="수정반영" onClick="fn_modify_goods('${goods.goods_id}', 'goods_writer')"></td>
					</tr>
					<tr>
						<td class="fixed_join">출판사</td>
						<td><input id="goods_publisher" type="text" size="40" value="<c:out value='${goods.goods_publisher}'/>"></td>
						<td><input type="button" class="btn" value="수정반영" onClick="fn_modify_goods('${goods.goods_id}', 'goods_publisher')"></td>
					</tr>
					<tr>
						<td class="fixed_join">제품정가</td>
						<td><input id="goods_price" type="text" size="40" value="${goods.goods_price}"></td>
						<td><input type="button" class="btn" value="수정반영" onClick="fn_modify_goods('${goods.goods_id}', 'goods_price')"></td>
					</tr>
					<tr>
						<td class="fixed_join">제품판매가격</td>
						<td><input id="goods_sales_price" type="text" size="40" value="${goods.goods_sales_price}"></td>
						<td><input type="button" class="btn" value="수정반영" onClick="fn_modify_goods('${goods.goods_id}', 'goods_sales_price')"></td>
					</tr>
					<tr>
						<td class="fixed_join">제품구매포인트</td>
						<td><input id="goods_point" type="text" size="40" value="${goods.goods_point}"></td>
						<td><input type="button" class="btn" value="수정반영" onClick="fn_modify_goods('${goods.goods_id}', 'goods_point')"></td>
					</tr>
					<tr>
						<td class="fixed_join">제품출판일</td>
						<td><input id="goods_published_date" type="date" value="<fmt:formatDate value='${goods.goods_published_date}' pattern='yyyy-MM-dd'/>"></td>
						<td><input type="button" class="btn" value="수정반영" onClick="fn_modify_goods('${goods.goods_id}', 'goods_published_date')"></td>
					</tr>
					<tr>
						<td class="fixed_join">제품총페이지수</td>
						<td><input id="goods_total_page" type="text" size="40" value="${goods.goods_total_page}"></td>
						<td><input type="button" class="btn" value="수정반영" onClick="fn_modify_goods('${goods.goods_id}', 'goods_total_page')"></td>
					</tr>
					<tr>
						<td class="fixed_join">ISBN</td>
						<td><input id="goods_isbn" type="text" size="40" value="<c:out value='${goods.goods_isbn}'/>"></td>
						<td><input type="button" class="btn" value="수정반영" onClick="fn_modify_goods('${goods.goods_id}', 'goods_isbn')"></td>
					</tr>
					<tr>
						<td class="fixed_join">제품배송비</td>
						<td><input id="goods_delivery_price" type="text" size="40" value="<c:out value='${goods.goods_delivery_price}'/>"></td>
						<td><input type="button" class="btn" value="수정반영" onClick="fn_modify_goods('${goods.goods_id}', 'goods_delivery_price')"></td>
					</tr>
					<tr>
						<td class="fixed_join">제품도착예정일</td>
						<td><input id="goods_delivery_date" type="date" value="<fmt:formatDate value='${goods.goods_delivery_date}' pattern='yyyy-MM-dd'/>"></td>
						<td><input type="button" class="btn" value="수정반영" onClick="fn_modify_goods('${goods.goods_id}', 'goods_delivery_date')"></td>
					</tr>
				</table>
			</div>
			<div class="tab_content" id="tab2">
				<h4>책목차</h4>
				<p><textarea rows="20" cols="80" id="goods_contents_order"><c:out value="${goods.goods_contents_order}" /></textarea></p>
				<input type="button" class="btn" value="수정반영" onClick="fn_modify_goods('${goods.goods_id}', 'goods_contents_order')">
			</div>
			<div class="tab_content" id="tab3">
				<h4>저자소개</h4>
				<p><textarea rows="20" cols="80" id="goods_writer_intro"><c:out value="${goods.goods_writer_intro}" /></textarea></p>
				<input type="button" class="btn" value="수정반영" onClick="fn_modify_goods('${goods.goods_id}', 'goods_writer_intro')">
			</div>
			<div class="tab_content" id="tab4">
				<h4>책소개</h4>
				<p><textarea rows="20" cols="80" id="goods_intro"><c:out value="${goods.goods_intro}" /></textarea></p>
				<input type="button" class="btn" value="수정반영" onClick="fn_modify_goods('${goods.goods_id}', 'goods_intro')">
			</div>
			<div class="tab_content" id="tab5">
				<h4>출판사 상품 평가</h4>
				<p><textarea rows="20" cols="80" id="goods_publisher_comment"><c:out value="${goods.goods_publisher_comment}" /></textarea></p>
				<input type="button" class="btn" value="수정반영" onClick="fn_modify_goods('${goods.goods_id}', 'goods_publisher_comment')">
			</div>
			<div class="tab_content" id="tab6">
				<h4>추천사</h4>
				<p><textarea rows="20" cols="80" id="goods_recommendation"><c:out value="${goods.goods_recommendation}" /></textarea></p>
				<input type="button" class="btn" value="수정반영" onClick="fn_modify_goods('${goods.goods_id}', 'goods_recommendation')">
			</div>
			<div class="tab_content" id="tab7">
				<h4>상품 이미지</h4>
				<table class="table_basic">
					<thead>
						<tr>
							<th>이미지</th>
							<th>구분</th>
							<th>수정할 파일</th>
							<th>관리</th>
						</tr>
					</thead>
					<tbody>
						<c:forEach var="image" items="${imageFileList}">
							<tr>
								<td>
									<img width="100" alt=""
									     src="${contextPath}/download.do?goods_id=${goods.goods_id}&fileName=${image.fileName}">
								</td>
								<td>${image.fileType == 'main_image' ? '메인 이미지' : '상세 이미지'}<br>(${image.fileType})</td>
								<td><input type="file" id="file_${image.image_id}"></td>
								<td>
									<input type="button" class="btn" value="수정"
									       onClick="fn_modify_image('${goods.goods_id}', '${image.image_id}', '${image.fileType}')">
									<%-- 메인 이미지는 수정만 가능하고 삭제할 수 없다 --%>
									<c:if test="${image.fileType != 'main_image'}">
										<input type="button" class="btn" value="삭제"
										       onClick="fn_remove_image('${goods.goods_id}', '${image.image_id}', '${image.fileName}')">
									</c:if>
								</td>
							</tr>
						</c:forEach>
					</tbody>
				</table>
				<h4 style="margin-top:20px;">새 상세 이미지 추가</h4>
				<input type="button" class="btn" value="파일 추가" onClick="fn_add_image_input()">
				<input type="button" class="btn" value="이미지 등록" onClick="fn_add_new_images('${goods.goods_id}')">
				<div id="d_new_file"></div>
			</div>
		</div>
	</div>
	<div class="clear"></div>
	<div class="btn_box">
		<a href="${contextPath}/admin/goods/adminGoodsMain.do">상품 목록으로</a>
	</div>
</form>
