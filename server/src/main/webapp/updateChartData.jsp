<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.*, java.util.*, java.sql.*" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.text.SimpleDateFormat" %>

<%
    // 클라이언트에서 전달된 날짜 가져오기
    String selectedDate = request.getParameter("date");

    // 데이터베이스 연결 정보
    String dbUrl = "jdbc:mysql://localhost:3306/ecosmeticbin";
    String dbUsername = "root";
    String dbPassword = "1234";

    Connection connection = null;
    PreparedStatement statement = null;
    ResultSet resultSet = null;

    try {
        // 데이터베이스 연결
        connection = DriverManager.getConnection(dbUrl, dbUsername, dbPassword);

        // 쿼리 작성
        String sql = "SELECT recyclingcode, SUM(recyclingcount) AS total_count FROM history WHERE date = ? GROUP BY recyclingcode";

        // PreparedStatement 설정
        statement = connection.prepareStatement(sql);
        statement.setString(1, selectedDate);

        // 쿼리 실행
        resultSet = statement.executeQuery();

        // JSON 문자열 생성
        StringBuilder jsonBuilder = new StringBuilder();
        jsonBuilder.append("{");
        jsonBuilder.append("\"data\": [");

        boolean isFirst = true;
        while (resultSet.next()) {
            if (!isFirst) {
                jsonBuilder.append(",");
            }
            jsonBuilder.append("{");
            jsonBuilder.append("\"recyclingcode\": \"" + resultSet.getString("recyclingcode") + "\",");
            jsonBuilder.append("\"recyclingcount\": " + resultSet.getInt("total_count"));
            jsonBuilder.append("}");
            isFirst = false;
        }

        jsonBuilder.append("]");
        jsonBuilder.append("}");

        // JSON 형식의 응답 생성
        out.print(jsonBuilder.toString());
    } catch (SQLException e) {
        out.println("오류 발생: " + e.getMessage());
    } finally {
        // 연결 및 리소스 해제
        try { if (resultSet != null) resultSet.close(); } catch (SQLException e) { e.printStackTrace(); }
        try { if (statement != null) statement.close(); } catch (SQLException e) { e.printStackTrace(); }
        try { if (connection != null) connection.close(); } catch (SQLException e) { e.printStackTrace(); }
    }
%>
