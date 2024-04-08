<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %> 
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Ecosmetic Bin</title>
    <style>
        body {
            margin: 0;
            height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            color: #666666;
        }

        .container {
            text-align: center;
            display: flex;
            flex-direction: column;
            position: relative;
            width: 80%;
            margin: 10vh auto;
        }

        input[type="text"],
        input[type="submit"],
        input[type="button"] {
            width: 90%;
            max-width: 400px;
            height: 2.5em;
            margin: 5px;
            border-radius: 10px;
            border: 2px solid #55C595;
            padding: 10px;
            font-size: 20px;
        }

        input[type="submit"] {
            background-color: #55C595;
            color: white;
            height: 3em;
            width: 330px;
        }

        .search-container {
            display: flex;
            align-items: center;
            flex-direction: column;
            position: relative;
        }
        
        .error-message {
            position: absolute;
            top: 80px;
            left: 50%;
            transform: translateX(-50%);
            color: red;
        }
        
        @media only screen and (max-width: 600px) {
            input[type="text"] {
                width: 90%;
                max-width: none;
                height: 10vw;
                font-size: 5vw;
            }
        }
    </style>
</head>

<%
    String url = "jdbc:mysql://localhost:3306/ecosmeticbin";
    String username = "root";
    String password = "1234";
    
    String userId = request.getParameter("id");
    session.setAttribute("loggedInUser", userId);
    
    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(url, username, password);

        String sql = "SELECT * FROM user WHERE id=?;";
        stmt = conn.prepareStatement(sql);
        stmt.setString(1, userId);

        rs = stmt.executeQuery();

        if (rs.next()) {
            out.println("로그인 성공!");
            String loggedInUser = rs.getString("id");
            session.setAttribute("loggedInUser", loggedInUser);
            response.sendRedirect("home.jsp");
        } else if (userId != null && !userId.isEmpty() && request.getMethod().equals("POST")) {
            
        }
        
        String updateMileageQuery = "UPDATE history h JOIN recycling r ON h.recyclingcode = r.recyclingcode SET h.result = h.recyclingcount * r.mileage";
        stmt.executeUpdate(updateMileageQuery);

        String updateUserTotalMileageQuery = "UPDATE user u JOIN (SELECT id, SUM(result) AS total_mileage FROM history GROUP BY id) h ON u.id = h.id SET u.totalmileage = h.total_mileage";
        stmt.executeUpdate(updateUserTotalMileageQuery);

        
    } catch (SQLException | ClassNotFoundException e) {
        e.printStackTrace();
    } finally {
        try { if (rs != null) rs.close(); } catch (SQLException e) { e.printStackTrace(); }
        try { if (stmt != null) stmt.close(); } catch (SQLException e) { e.printStackTrace(); }
        try { if (conn != null) conn.close(); } catch (SQLException e) { e.printStackTrace(); }
    }
%>
<body class="container">
    <div style="text-align: center;">
        <img src="logo.png" style="width: 200px; height: auto;">
        <p style="font-size: 25px;">안녕하세요.<br>Ecosmetic Bin 입니다.</p>
        <p style="font-size: 10px;">회원 서비스 이용을 위해 로그인 해주세요. </p>
        <br><br>
    </div>
    <form action="" method="post">
    <div class="search-container">
        <input type="text" name="id" placeholder="아이디">
        <br><br><div>
        <% 
            if (userId != null && !userId.isEmpty() && request.getMethod().equals("POST")) {
                out.println("<p class='error-message'>잘못된 아이디 입니다.</p>");
            }
        %>
        </div><br>
        <input type="submit" value="로그인">
    </div> <br> <br> <br> <br>
</form>
</body>
</html>