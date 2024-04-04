<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*" %> 
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>적립 현황</title>
    <style>
        body {
            background-color: #97C1A9;
            font-family: Arial, sans-serif;
            text-align: center;
        }

        h1 {
            margin-top: 50px;
            font-size: 32px;
            color: #333;
        }

        .month-container {
            margin-top: 30px;
            display: flex;
            flex-wrap: wrap;
            justify-content: center;
            gap: 20px;
        }

        .month {
            width: 300px;
            background-color: #fff;
            padding: 20px;
            border-radius: 10px;
        }

        .month-title {
            font-size: 24px;
            font-weight: bold;
            margin-bottom: 10px;
        }

        .trash-type {
            font-size: 18px;
            margin-bottom: 5px;
        }

        .total-mileage {
            font-size: 20px;
            font-weight: bold;
            margin-top: 10px;
        }

        .navigation {
            margin-top: 20px;
        }
    </style>
    <script>
    function showPreviousMonth() {
        var currentDate = new Date();
        var year = currentDate.getFullYear();
        var month = currentDate.getMonth() + 1; // 현재 월

        // 이전 달 계산
        var prevMonth = month === 1 ? 12 : month - 1;
        var prevYear = month === 1 ? year - 1 : year;

        var xhr = new XMLHttpRequest();
        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE) {
                if (xhr.status === 200) {
                    document.getElementById("month-container").innerHTML = xhr.responseText;
                } else {
                    console.error("요청 실패: " + xhr.status);
                }
            }
        };
        xhr.open("GET", "mileageCalendar.jsp?year=" + prevYear + "&month=" + prevMonth, true);
        xhr.send();
    }

    function showNextMonth() {
        var currentDate = new Date();
        var year = currentDate.getFullYear();
        var month = currentDate.getMonth() + 1; // 현재 월

        // 다음 달 계산
        var nextMonth = month === 12 ? 1 : month + 1;
        var nextYear = month === 12 ? year + 1 : year;

        var xhr = new XMLHttpRequest();
        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE) {
                if (xhr.status === 200) {
                    document.getElementById("month-container").innerHTML = xhr.responseText;
                } else {
                    console.error("요청 실패: " + xhr.status);
                }
            }
        };
        xhr.open("GET", "mileageCalendar.jsp?year=" + nextYear + "&month=" + nextMonth, true);
        xhr.send();
    }

    </script>
</head>
<body>
<h1>적립 현황</h1>
<div class="month-container">
<%
    // 데이터베이스 연결 정보
    String url = "jdbc:mysql://localhost:3306/ecosmeticbin";
    String username = "root";
    String password = "1234";

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    // 세션에서 사용자 ID 가져오기
    String userId = (String) session.getAttribute("id");

    try {
        // 데이터베이스 연결
        conn = DriverManager.getConnection(url, username, password);

        // URL에서 연도와 월 정보 가져오기
        String yearStr = request.getParameter("year");
        String monthStr = request.getParameter("month");

        // URL에서 가져온 연도와 월 정보가 숫자가 아닌 경우에 대한 예외 처리 추가
        int year = 0;
        int month = 0;

        try {
            year = (yearStr != null && !yearStr.isEmpty()) ? Integer.parseInt(yearStr) : Calendar.getInstance().get(Calendar.YEAR);
        } catch (NumberFormatException e) {
            // URL에서 가져온 연도 정보가 잘못된 경우에 대한 처리
            // 기본값으로 현재 연도를 사용
            year = Calendar.getInstance().get(Calendar.YEAR);
        }

        try {
            month = (monthStr != null && !monthStr.isEmpty()) ? Integer.parseInt(monthStr) : Calendar.getInstance().get(Calendar.MONTH) + 1;
        } catch (NumberFormatException e) {
            // URL에서 가져온 월 정보가 잘못된 경우에 대한 처리
            // 기본값으로 현재 월을 사용
            month = Calendar.getInstance().get(Calendar.MONTH) + 1;
        }

        // 쿼리를 통해 특정 사용자의 해당 연월의 쓰레기 버린 개수와 총 마일리지를 가져옵니다.
        String sql = "SELECT " +
                     "SUM(CASE WHEN recyclingcode = 1 THEN recyclingcount ELSE 0 END) AS plastic_count, " +
                     "SUM(CASE WHEN recyclingcode = 2 THEN recyclingcount ELSE 0 END) AS glass_count, " +
                     "SUM(CASE WHEN recyclingcode = 3 THEN recyclingcount ELSE 0 END) AS metal_count, " +
                     "SUM(recyclingcount) AS total_count, " +
                     "SUM(user_totalmileage) AS total_mileage " +
                     "FROM mileage " +
                     "WHERE user_id = ? " +
                     "AND YEAR(date) = ? AND MONTH(date) = ?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, userId);
        pstmt.setInt(2, year);
        pstmt.setInt(3, month);
        rs = pstmt.executeQuery();

        // 결과를 출력합니다.
        if (rs.next()) {
            int plasticCount = rs.getInt("plastic_count");
            int glassCount = rs.getInt("glass_count");
            int metalCount = rs.getInt("metal_count");
            int totalCount = rs.getInt("total_count");
            int totalMileage = rs.getInt("total_mileage");

            // 해당 월 정보를 출력합니다.
            out.println("<div class=\"month\">");
            out.println("<div class=\"month-title\">" + year + "년 " + month + "월</div>");
            out.println("<div class=\"trash-type\">플라스틱: " + plasticCount + "개</div>");
            out.println("<div class=\"trash-type\">유리: " + glassCount + "개</div>");
            out.println("<div class=\"trash-type\">금속: " + metalCount + "개</div>");
            out.println("<div class=\"trash-type\">총: " + totalCount + "개</div>");
            out.println("<div class=\"total-mileage\">총 마일리지: " + totalMileage + "점</div>");
            out.println("</div>");
        } else {
            out.println("<div class=\"month\">");
            out.println("<div class=\"month-title\">" + year + "년 " + month + "월</div>");
            out.println("<div class=\"trash-type\">해당 월 데이터가 없습니다.</div>");
            out.println("</div>");
        }
    } catch (SQLException e) {
        out.println("오류 발생: " + e.getMessage());
    } catch (NumberFormatException e) {
        out.println("숫자 변환 오류: " + e.getMessage());
    } finally {
        // 연결 및 리소스 해제
        try { if (rs != null) rs.close(); } catch (SQLException e) { e.printStackTrace(); }
        try { if (pstmt != null) pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
        try { if (conn != null) conn.close(); } catch (SQLException e) { e.printStackTrace(); }
    }
%>
</div>
<div class="navigation">
    <button onclick="showPreviousMonth()">&#60;</button> <!-- 이전 달로 이동하는 버튼 -->
    <button onclick="showNextMonth()">&#62;</button> <!-- 다음 달로 이동하는 버튼 -->
</div>
</body>
</html>