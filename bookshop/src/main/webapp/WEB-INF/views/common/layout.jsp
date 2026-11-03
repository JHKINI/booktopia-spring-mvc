<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" isELIgnored="false" %>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title><tiles:insertAttribute name="title" /></title>
<link href="${contextPath}/resources/css/main.css" rel="stylesheet" type="text/css" media="screen">
<link href="${contextPath}/resources/css/basic-jquery-slider.css" rel="stylesheet" type="text/css" media="screen">
<script src="${contextPath}/resources/jquery/jquery-1.6.2.min.js"></script>
<script src="${contextPath}/resources/jquery/basic-jquery-slider.js"></script>
<script src="${contextPath}/resources/jquery/tabs.js"></script>
</head>
<body>
<div id="outer_wrap">
	<div id="wrap">
		<header>
			<tiles:insertAttribute name="header" />
		</header>
		<div class="clear"></div>
		<aside>
			<tiles:insertAttribute name="side" />
		</aside>
		<article>
			<tiles:insertAttribute name="body" />
		</article>
		<div class="clear"></div>
		<footer>
			<tiles:insertAttribute name="footer" />
		</footer>
	</div>
	<div>
		<tiles:insertAttribute name="quickMenu" />
	</div>
</div>
</body>
</html>
