<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %> 
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
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
            margin-left: auto;
            margin-right: auto;
            margin-top: 10vh;
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
        }

        .search-container {
            display: flex;
            align-items: center;
            flex-direction: column;
        }
        
        @media only screen and (max-width: 600px) {
			input[type="text"], input[type="submit"] {
                width: 90%;
                max-width: none;
                height: 10vw;
                font-size: 5vw;
                width: 90%;
            }
        }
    </style>
</head>
<body class="container">
	<div>
    	<img src="logo.png">
    		<p style="font-size: 25px;">안녕하세요.<br>Ecosmetic Bin 입니다.</p>
    		<p style="font-size: 10px;">회원 서비스 이용을 위해 로그인 해주세요. </p>
    	<br><br>
    </div>
    <form action="" method="post">
        <div class="search-container">
            <input type="text" name="id" placeholder="아이디"> <br>
            <input type="submit" value="로그인">
        </div> <br> <br> <br> <br>
    </form>

<%
    // 데이터베이스 연결 정보
    String url = "jdbc:mysql://localhost:3306/ecosmeticbin";
    String username = "root";
    String password = "1234";
    
    // 사용자가 입력한 ID 가져오기
    String userId = request.getParameter("id");
    session.setAttribute("loggedInUser", userId);
    
    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;

    try {
        // MySQL 드라이버 로드
        Class.forName("com.mysql.cj.jdbc.Driver");

        // 데이터베이스 연결
        conn = DriverManager.getConnection(url, username, password);

        // SQL 쿼리 준비
        String sql = "SELECT * FROM user WHERE id=?;";
        stmt = conn.prepareStatement(sql);
        stmt.setString(1, userId);

        // 쿼리 실행
        rs = stmt.executeQuery();

        // 결과 확인
        if (rs.next()) {
            // 로그인 성공
            out.println("로그인 성공!");
            String loggedInUser = rs.getString("id"); // 여기를 "name"에서 "id"로 수정
            session.setAttribute("loggedInUser", loggedInUser);
            response.sendRedirect("dashboard.jsp");
        } else {
        	
        }
        
        // 마일리지 업데이트 쿼리
        String updateMileageQuery = "UPDATE history h JOIN recycling r ON h.recyclingcode = r.recyclingcode SET h.result = h.recyclingcount * r.mileage";
        stmt.executeUpdate(updateMileageQuery);

        // 사용자의 총 마일리지 업데이트 쿼리
        String updateUserTotalMileageQuery = "UPDATE user u JOIN (SELECT id, SUM(result) AS total_mileage FROM history GROUP BY id) h ON u.id = h.id SET u.totalmileage = h.total_mileage";
        stmt.executeUpdate(updateUserTotalMileageQuery);

        
    } catch (SQLException | ClassNotFoundException e) {
        e.printStackTrace();
    } finally {
        // 연결 및 리소스 해제
        try { if (rs != null) rs.close(); } catch (SQLException e) { e.printStackTrace(); }
        try { if (stmt != null) stmt.close(); } catch (SQLException e) { e.printStackTrace(); }
        try { if (conn != null) conn.close(); } catch (SQLException e) { e.printStackTrace(); }
    }
%>
    
</body>
</html>