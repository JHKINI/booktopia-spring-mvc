# 📚 booktopia-spring-mvc

> Spring MVC · MyBatis · Tiles · Oracle 기반 **도서 쇼핑몰** (회원 / 장바구니 / 주문 / 마이페이지 / 관리자)

『자바 웹을 다루는 기술』 31장 도서 쇼핑몰 실습을 바탕으로 구현한 프로젝트입니다.
누락된 JSP 화면을 직접 작성하고, 설정·매퍼의 버그를 찾아 수정해 동작하는 형태로 완성했습니다.
!(booktopia.png)
## 주요 기능

| 구분 | 기능 |
|---|---|
| 메인 | 베스트셀러 / 신간 / 스테디셀러 진열, 배너 슬라이더, 최근 본 상품(빠른 메뉴) |
| 상품 | 상품 상세(탭), 검색, Ajax 검색어 자동완성, 이미지 썸네일/다운로드 |
| 회원 | 로그인/로그아웃, 회원가입(ID 중복 체크, 우편번호 검색) |
| 장바구니 | 담기(중복 방지), 수량 수정, 삭제, 선택/전체 주문 |
| 주문 | 바로 구매, 장바구니 주문, 배송지·결제 정보 입력, 주문 결과 |
| 마이페이지 | 주문 내역(기간 조회), 주문 상세, 주문 취소, 회원 정보 수정 |
| 관리자 | 상품 등록/수정(이미지 Ajax 업로드), 주문 조회·배송 상태 변경, 회원 조회·수정·탈퇴 처리 |

## 기술 스택

- **Backend**: Java 8+, Spring MVC 4.1, MyBatis 3.1, Apache Tiles 2, AOP(로깅)
- **View**: JSP, JSTL, jQuery 1.6
- **DB**: Oracle
- **Build / Server**: Maven (WAR), Tomcat 8/9

## 프로젝트 구조

```
src/main
├─ java/com/bookshop01
│  ├─ main, goods, member, cart, order, mypage   # Controller → Service → DAO 계층
│  ├─ admin/{goods,member,order}                 # 관리자 기능
│  └─ common                                     # BaseController, 인터셉터, 파일 다운로드, 로깅
├─ resources
│  ├─ mybatis/{mappers,models}                   # SQL 매퍼, 타입 별칭
│  └─ tiles                                      # 화면 레이아웃 정의
└─ webapp
   ├─ WEB-INF/views                              # JSP (common, main, goods, member, cart, order, mypage, admin)
   ├─ WEB-INF/spring                             # mybatis-context.xml, servlet-context.xml
   ├─ WEB-INF/config/jdbc/jdbc.properties        # DB 접속 정보
   └─ resources                                  # css, jquery, image
```

## 실행 방법

1. **DB 준비**: 책 예제의 `shopping_table_schema.sql` 실행 (테이블 + 시퀀스 `seq_goods_id`, `seq_image_id`, `order_seq_num`, `seq_order_id`)
2. **접속 정보 수정**: `src/main/webapp/WEB-INF/config/jdbc/jdbc.properties`
   ```properties
   jdbc.driverClassName=oracle.jdbc.OracleDriver
   jdbc.url=jdbc:oracle:thin:@localhost:1521:testdb
   jdbc.username=YOUR_ID
   jdbc.password=YOUR_PASSWORD
   ```
3. **상품 이미지 폴더**: `C:\shopping\file_repo\{상품번호}\` 및 `C:\shopping\file_repo\temp` 생성
4. **빌드/실행**: `mvn clean package` 후 WAR를 Tomcat에 배포하거나 IDE에서 서버 등록
5. **접속**: `http://localhost:8090/bookshop/main/main.do` (포트·컨텍스트 경로는 환경에 따라 다름)
   - 관리자 메뉴는 `member_id = admin` 계정으로 로그인 시 표시

## 직접 수정/보완한 내용

- Java 소스 위치 정리(`src/main/java`) 및 인코딩 UTF-8 통일
- `component-scan` / 인터셉터 패키지 오류 수정 (`com.bookshop` → `com.bookshop01`)
- `web.xml` 서블릿 3.0 선언으로 변경 (JSP EL 활성화), UTF-8 필터 적용
- 매퍼 버그 수정: 테이블명 오타(`t_shoping_member`), 상품 수정 쿼리의 컬럼명 불일치, 날짜 `to_date` 처리
- DAO 매퍼 id 누락 수정
- 전체 JSP 화면 작성 및 공통 스타일 추가

## 한계 / TODO

- 비밀번호 평문 저장 → 해시(BCrypt 등) 적용 필요
- 이미지 저장 경로가 코드에 하드코딩(`C:\shopping\file_repo`) → 설정 파일로 분리
- 관리자 목록 페이징이 총 건수 없이 동작 → count 쿼리 추가
- 결제는 입력 정보 저장만 하는 모의 구현
