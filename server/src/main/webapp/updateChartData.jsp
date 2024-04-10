<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="com.fasterxml.jackson.databind.ObjectMapper" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Map" %>

<%--이 코드는 사용자가 달력을 클릭했을때 각 recyclingcode가 변경되는 것--%>
<%
    String selectedDate = request.getParameter("selectedDate");
    String loggedInUserId = (String) session.getAttribute("loggedInUser");

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
                "    SUM(CASE WHEN h.recyclingcode = 'plastic' THEN h.recyclingcount ELSE 0 END) AS plastic, " +
                "    SUM(CASE WHEN h.recyclingcode = 'glass' THEN h.recyclingcount ELSE 0 END) AS glass, " +
                "    SUM(CASE WHEN h.recyclingcode = 'can' THEN h.recyclingcount ELSE 0 END) AS can, " +
                "    SUM(h.result) AS totalResult " +
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
            int plasticCount = resultSet.getInt("plastic");
            int glassCount = resultSet.getInt("glass");
            int canCount = resultSet.getInt("can");
            int totalResult = resultSet.getInt("totalResult");

            responseData.put("plasticCount", plasticCount);
            responseData.put("glassCount", glassCount);
            responseData.put("canCount", canCount);
            responseData.put("result", totalResult);
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
--%>
