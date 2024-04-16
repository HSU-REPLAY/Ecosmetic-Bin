<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="com.fasterxml.jackson.databind.ObjectMapper" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Map" %>

<%
	String loggedInUserId=request.getParameter("id");
	String selectedDate = request.getParameter("selectedDate");    

    String dbUrl = "jdbc:mysql://localhost:3306/ecosmeticbin";
    String dbUsername = "root";
    String dbPassword = "1234";

    Map<String, Integer> responseData = new HashMap<>();

    Connection connection = null;
    PreparedStatement statement = null;
    ResultSet resultSet = null;

    try {
        Class.forName("com.mysql.jdbc.Driver");
        connection = DriverManager.getConnection(dbUrl, dbUsername, dbPassword);
        
        String sql = "SELECT " +
                "    SUM(CASE WHEN h.recyclingcode = 'plastic' THEN h.recyclingcount ELSE 0 END) AS plasticCount, " +
                "    SUM(CASE WHEN h.recyclingcode = 'glass' THEN h.recyclingcount ELSE 0 END) AS glassCount, " +
                "    SUM(CASE WHEN h.recyclingcode = 'can' THEN h.recyclingcount ELSE 0 END) AS canCount, " +
                "    SUM(h.result) AS totalResult, " +
                "    SUM(h.recyclingcount) AS recyclingCount " + // 추가된 부분
                "FROM " +
                "    history h " +
                "JOIN " +
                "    user u ON h.id = u.id " +
                "WHERE " +
                "    DATE(h.date) = ? AND u.id = ?";

        statement = connection.prepareStatement(sql);
        statement.setString(1, selectedDate);
        statement.setString(2, loggedInUserId);

        resultSet = statement.executeQuery();

        if (resultSet.next()) {
            int plasticCount = resultSet.getInt("plasticCount");
            int glassCount = resultSet.getInt("glassCount");
            int canCount = resultSet.getInt("canCount");
            int totalResult = resultSet.getInt("totalResult");
            int recyclingCount = plasticCount + glassCount + canCount;

            responseData.put("plasticCount", plasticCount);
            responseData.put("glassCount", glassCount);
            responseData.put("canCount", canCount);
            responseData.put("result", totalResult);
            responseData.put("recyclingCount", recyclingCount); 
        } else {
            response.setStatus(404);
            response.getWriter().write("Data not found for selected date");
            return;
        }
    } catch (ClassNotFoundException | SQLException e) {
        e.printStackTrace();
        response.setStatus(500);
        response.getWriter().write("Internal server error");
        return;
    } finally {
        try { if (resultSet != null) resultSet.close(); } catch (SQLException e) { e.printStackTrace(); }
        try { if (statement != null) statement.close(); } catch (SQLException e) { e.printStackTrace(); }
        try { if (connection != null) connection.close(); } catch (SQLException e) { e.printStackTrace(); }
    }

    String jsonResponse = new ObjectMapper().writeValueAsString(responseData);

    response.setContentType("application/json");
    response.setCharacterEncoding("UTF-8");
    response.getWriter().write(jsonResponse);
%>