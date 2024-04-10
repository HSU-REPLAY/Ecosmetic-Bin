<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>User Ranking</title>
    <style>
        body {
            background-color: #F5F5F5;
            font-weight: bold;
        }
        .table-container {
            background-color: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);
            margin-top: 20px;
        }
        table {
            width: 100%;
            border-collapse: collapse;
        }
        th, td {
            padding: 8px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }
        
        td span {
    		font-weight: normal;
		}
        
        .logged-in-user {
            border-radius: 10px;
            box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);
            background-color: #CDF8D6;
        }
        
        .rank-color {
            color: #55C595;
            font-weight: bold;
        }
    </style>
</head>
<body>
    <h3>실시간 차트</h3>
    <div class="table-container">
    <table>
        <tr>
            <th>순위</th>
            <th>ID</th>
            <th>마일리지 점수</th>
        </tr>
        <% 
            // 데이터베이스 연결 정보
            String url = "jdbc:mysql://localhost:3306/ecosmeticbin";
            String username = "root";
            String password = "1234";

            try {
                // 데이터베이스 연결
                Connection conn = DriverManager.getConnection(url, username, password);

                // 로그인한 사용자의 이름을 세션에서 가져옴
                String loggedInUser = (String) session.getAttribute("loggedInUser");
                
             // 랭킹 쿼리 실행
                String sql = "SELECT id, totalmileage, " +
                             "       FIND_IN_SET(totalmileage, (SELECT GROUP_CONCAT(totalmileage ORDER BY totalmileage DESC) FROM user)) AS `rank` " +
                             "FROM user " +
                             "ORDER BY totalmileage DESC";
                PreparedStatement pstmt = conn.prepareStatement(sql);
                ResultSet rs = pstmt.executeQuery();
                
                // 결과 처리
                while (rs.next()) {
                    int rank = rs.getInt("rank");
                    String id = rs.getString("id");
                    String totalmileage = rs.getString("totalmileage");

                    // 현재 로그인한 사용자와 현재 반복되고 있는 사용자의 이름을 비교하여 일치하는 경우
                    if (id.equals(loggedInUser)) {
        %>
                        <tr class="logged-in-user">
                            <td>
                                <% if (rank <= 3) { %>
                                    <img src="gold-medal.png" alt="Medal" width="20" height="20" style="margin-right: 5px;">
                                <% } else { %>
                                <span class="rank-color"><%= rank %></span>
                            <% } %>
                            </td>
                            <td><%= id %></td>
                            <td><span><%= totalmileage %> M</span></td>
                        </tr>
        <% 
                    } else {
                        String medalImage = "";
                        if (rank == 1) {
                            medalImage = "gold-medal.png";
                        } else if (rank == 2) {
                            medalImage = "silver-medal.png";
                        } else if (rank == 3) {
                            medalImage = "bronze-medal.png";
                        }
        %>
                        <tr>
                            <td>
                                <% if (rank <= 3) { %>
                                    <img src="<%= medalImage %>" alt="Medal" width="20" height="20" style="margin-right: 5px;">
                                <% } else { %>
                                	<span class="rank-color"><%= rank %></span>
                            	<% } %>
                            </td>
                            <td><%= id %></td>
                            <td><span><%= totalmileage %> M</span></td>
                        </tr>
        <%
                    }
                }

                // 리소스 해제
                rs.close();
                pstmt.close();
                conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        %>
        </table>
    </div>
</body>
</html>
