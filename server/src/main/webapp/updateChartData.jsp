<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="com.fasterxml.jackson.databind.ObjectMapper" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Map" %>

<%
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
                     "    SUM(CASE WHEN recyclingcode = 'plastic' THEN recyclingcount ELSE 0 END) AS plastic, " +
                     "    SUM(CASE WHEN recyclingcode = 'glass' THEN recyclingcount ELSE 0 END) AS glass, " +
                     "    SUM(CASE WHEN recyclingcode = 'can' THEN recyclingcount ELSE 0 END) AS can " +
                     "FROM " +
                     "    history " +
                     "WHERE " +
                     "    DATE(date) = ?";

        statement = connection.prepareStatement(sql);
        statement.setString(1, selectedDate);

        resultSet = statement.executeQuery();

        if (resultSet.next()) {
            int plasticCount = resultSet.getInt("plastic");
            int glassCount = resultSet.getInt("glass");
            int canCount = resultSet.getInt("can");

            responseData.put("plasticCount", plasticCount);
            responseData.put("glassCount", glassCount);
            responseData.put("canCount", canCount);
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
