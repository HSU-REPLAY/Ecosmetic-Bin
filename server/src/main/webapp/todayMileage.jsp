<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.Date, java.text.SimpleDateFormat" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>오늘의 마일리지</title>
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

        table {
            border: 2px solid lightblue;
            border-collapse: collapse;
            margin-top: 30px;
            margin-left: auto;
            margin-right: auto;
        }

        th, td {
            border: 1px solid lightgray;
            padding: 10px;
        }
    </style>
</head>
<body>
<%
    // 데이터베이스 연결 정보
    String url = "jdbc:mysql://localhost:3306/ecosmeticbin";
    String username = "root";
    String password = "1234";

    // 마일리지 정보를 담을 변수
    String todayDate = ""; // 변수 이름 변경
    int plastic = 0;
    int glass = 0;
    int metal = 0;
    int total = 0;
    int mileage = 0;

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        // 데이터베이스 연결
        conn = DriverManager.getConnection(url, username, password);

        // 오늘의 날짜 가져오기
        String today = ""; // 변수 이름 변경
        Date currentDate = new Date(); // 변수 이름 변경
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        todayDate = sdf.format(currentDate); // 변수 이름 변경

        // 오늘의 마일리지 가져오기
        String sql = "SELECT * FROM mileage WHERE date = ?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, todayDate); // 변수 이름 변경
        rs = pstmt.executeQuery();

        // 결과 확인
        while (rs.next()) {
            int recyclingCode = rs.getInt("recyclingcode");
            int recyclingCount = rs.getInt("recyclingcount");
            switch (recyclingCode) {
                case 1:
                    plastic += recyclingCount;
                    break;
                case 2:
                    glass += recyclingCount;
                    break;
                case 3:
                    metal += recyclingCount;
                    break;
            }
            total += recyclingCount;
        }
        
        // 마일리지 계산
        // 각 재활용 종류에 따른 마일리지를 계산하여 합산
        mileage = plastic * 30 + glass * 20 + metal * 10;
        
    } catch (SQLException e) {
        out.println("오류 발생: " + e.getMessage());
    } finally {
        // 연결 및 리소스 해제
        try { if (rs != null) rs.close(); } catch (SQLException e) { e.printStackTrace(); }
        try { if (pstmt != null) pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
        try { if (conn != null) conn.close(); } catch (SQLException e) { e.printStackTrace(); }
    }
%>
<h1>오늘의 마일리지</h1>
<table>
    <tr>
        <th>날짜</th>
        <th>플라스틱</th>
        <th>유리</th>
        <th>캔/철</th>
        <th>총 개수</th>
        <th>마일리지</th>
    </tr>
    <tr>
        <td><%= todayDate %></td> <!-- 변수 이름 변경 -->
        <td><%= plastic %></td>
        <td><%= glass %></td>
        <td><%= metal %></td>
        <td><%= total %></td>
        <td><%= mileage %></td>
    </tr>
</table>

</body>
</html>
