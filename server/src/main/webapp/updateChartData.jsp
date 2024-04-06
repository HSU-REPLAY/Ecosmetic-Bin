<%@ page language="java" contentType="application/json; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="org.json.*" %>

<%
    // 선택된 날짜 파라미터 가져오기
    String selectedDate = request.getParameter("date");

    // 데이터베이스 연결 정보
    String dbUrl = "jdbc:mysql://localhost:3306/ecosmeticbin";
    String dbUsername = "root";
    String dbPassword = "1234";

    // 데이터베이스 연결
    Connection connection = null;
    PreparedStatement statement = null;
    ResultSet resultSet = null;

    // 결과를 담을 JSON 객체 생성
    JSONObject responseData = new JSONObject();

    try {
        // 데이터베이스 연결
        connection = DriverManager.getConnection(dbUrl, dbUsername, dbPassword);

        // 쿼리 작성
        String sql = "SELECT " +
                     "    SUM(CASE WHEN recyclingcode = '플라스틱' THEN recyclingcount ELSE 0 END) AS plasticCount, " +
                     "    SUM(CASE WHEN recyclingcode = '유리' THEN recyclingcount ELSE 0 END) AS glassCount, " +
                     "    SUM(CASE WHEN recyclingcode = '캔' THEN recyclingcount ELSE 0 END) AS canCount " +
                     "FROM " +
                     "    history " +
                     "WHERE " +
                     "    date = ?";

        // PreparedStatement 설정
        statement = connection.prepareStatement(sql);
        statement.setString(1, selectedDate);

        // 쿼리 실행
        resultSet = statement.executeQuery();

        // 결과 처리
        if (resultSet.next()) {
            int plasticCount = resultSet.getInt("plasticCount");
            int glassCount = resultSet.getInt("glassCount");
            int canCount = resultSet.getInt("canCount");

            // JSON 객체에 결과 추가
            responseData.put("plasticCount", plasticCount);
            responseData.put("glassCount", glassCount);
            responseData.put("canCount", canCount);
        }
    } catch (SQLException e) {
        e.printStackTrace();
    } finally {
        // 연결 및 리소스 해제
        try { if (resultSet != null) resultSet.close(); } catch (SQLException e) { e.printStackTrace(); }
        try { if (statement != null) statement.close(); } catch (SQLException e) { e.printStackTrace(); }
        try { if (connection != null) connection.close(); } catch (SQLException e) { e.printStackTrace(); }
    }

    // JSON 형식으로 결과 전송
    response.setContentType("application/json");
    response.setCharacterEncoding("UTF-8");
    response.getWriter().write(responseData.toString());
%>

