<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>대시보드</title>
    <style>
        body {
            background-color: #97C1A9;
            font-family: Arial, sans-serif;
            text-align: center;
        }

        #user-info {
            margin-top: 50px;
            font-size: 32px;
            color: #333;
        }

        #user-level {
            font-size: 18px;
            color: #555;
        }

        input[type="text"] {
            width: 500px;
            height: 50px;
            margin: 5px;
        }

        input[type="button"] {
            width: 150px;
            height: 50px;
            margin: 0 5px;
            font-size: 20px;
            background-color: #D4F0F0;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }

        input[type="button"]:hover {
            background-color: #AEE5E5;
        }

        input[type="submit"] {
            width: 150px;
            height: 50px;
            margin: 0 5px;
            font-size: 20px;
            background-color: #D4F0F0;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }

        input[type="submit"]:hover {
            background-color: #AEE5E5;
        }

        .buttons-container {
            margin-top: 20px;
            display: flex;
            justify-content: space-evenly;
        }


        hr {
            height: 15px;
            background-color: #ABDEE6;
            border: none;
            margin-top: 20px;
            margin-bottom: 20px;
        }

        @media only screen and (max-width: 600px) {
            input[type="text"],
            input[type="button"] {
                width: 100%;
                max-width: 300px;
            }
        }
    </style>
</head>
<body>
<%
    String id = (String) session.getAttribute("loggedInUser");

    // 데이터베이스 연결 정보
    String url = "jdbc:mysql://localhost:3306/ecosmeticbin";
    String username = "root";
    String password = "1234";

    // 사용자 정보를 담을 변수
    String name = "";
    String level = "";
    String levelname = "";

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        // 데이터베이스 연결
        conn = DriverManager.getConnection(url, username, password);

        // SQL 쿼리 준비
        String sql = "SELECT u.name, u.level, l.levelname " +
                     "FROM user u " +
                     "JOIN level l ON u.level = l.level " +
                     "WHERE u.name = ?";
        pstmt = conn.prepareStatement(sql);

        pstmt.setString(1, id);

        // 쿼리 실행
        rs = pstmt.executeQuery();

        // 결과 확인
        if (rs.next()) {
            // 사용자 정보 추출
            name = rs.getString("name");
            level = rs.getString("level");
            levelname = rs.getString("levelname");
        }
    } catch (SQLException e) {
        out.println("오류 발생: " + e.getMessage());
    } finally {
        // 연결 및 리소스 해제
        try { if (rs != null) rs.close(); } catch (SQLException e) { e.printStackTrace(); }
        try { if (pstmt != null) pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
        try { if (conn != null) conn.close(); } catch (SQLException e) { e.printStackTrace(); }
    }
%>
<div id="user-info" style="display: flex; align-items: center; justify-content: center;">
    <img src="./user.png" alt="User Image" style="width: 100px; height: 100px; border-radius: 50%; margin-right: 50px;" />
    <%= name %> 님, 안녕하세요!<br>
    Lv <%= level %> <%= levelname %>
</div><br>
<hr>
<div class="buttons-container">
    <form action="todayMileage.jsp" method="post">
        <input type="hidden" name="id" value="<%= id %>">
        <input type="submit" value="오늘의 적립">
    </form>
    <form action="mileageCalendar.jsp" method="post">
        <input type="hidden" name="id" value="<%= id %>">
        <input type="submit" value="적립 현황">
    </form>
    <form action="ranking.jsp" method="post">
        <input type="hidden" name="id" value="<%= id %>">
        <input type="submit" value="실시간 차트">
    </form>
</div>
<br>
</body>
</html>
