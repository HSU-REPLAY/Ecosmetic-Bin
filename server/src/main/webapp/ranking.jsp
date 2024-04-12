<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Ranking</title>
    <style>
        body {
            background-color: #F5F5F5;
            font-weight: bold;
            padding-bottom: 75px;
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
        
        header {
		  position: fixed;
		  bottom: 0;
		  left: 0;
		  right: 0;
		  z-index: 2;
		  height: 60px;
		  padding: 1rem;
		  color: white;
		  background: #FFFFFF;
		  font-weight: bold;
		  display: flex;
		  justify-content: space-between;
		  align-items: center;
		}
    </style>
</head>
<body>
<header>
	<button type="button" id="homeButton" style="background-color: transparent; border: none; margin-left: 50px;">
	    <img src="home.png" alt="Home" style="width: 20px; height: 35px;">
	</button>
	<button type="button" id="rankingButton" style="background-color: transparent; border: none; margin-left: 30px">
	    <img src="rankcheck.png" alt="ranking" style="width: 35px; height: 35px;">
	</button>
	<button type="button" id="myButton" style="background-color: transparent; border: none; margin-left: 10px; margin-right: 50px;">
	    <img src="my.png" alt="mypage" style="width: 35px; height: 35px;">
	</button>
</header>
<script>
	document.getElementById("homeButton").addEventListener("click", function() {
	    // home.jsp로 이동하는 코드
	    window.location.href = "home.jsp";
	});
	document.getElementById("rankingButton").addEventListener("click", function() {
	    // ranking.jsp로 이동하는 코드
	    window.location.href = "ranking.jsp";
	});
	document.getElementById("myButton").addEventListener("click", function() {
	    // myPage.jsp로 이동하는 코드
	    window.location.href = "myPage.jsp";
	});
</script>
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

                String loggedInUser = (String) session.getAttribute("loggedInUser");
                
                String sql = "SELECT id, totalmileage, " +
                             "       FIND_IN_SET(totalmileage, (SELECT GROUP_CONCAT(totalmileage ORDER BY totalmileage DESC) FROM user)) AS `rank` " +
                             "FROM user " +
                             "ORDER BY totalmileage DESC";
                PreparedStatement pstmt = conn.prepareStatement(sql);
                ResultSet rs = pstmt.executeQuery();
                
                while (rs.next()) {
                    int rank = rs.getInt("rank");
                    String id = rs.getString("id");
                    String totalmileage = rs.getString("totalmileage");

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
