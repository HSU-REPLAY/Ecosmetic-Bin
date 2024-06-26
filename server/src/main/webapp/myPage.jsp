<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %> 
<%@ page import="java.text.NumberFormat" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>마이페이지</title>
    <style>
        body {
            background-color: #F5F5F5;
            padding-bottom: 75px;
        }
        
        .level-info, .rest, .logout {
            background-color: white;
            padding: 20px;
            max-width: 900px; /* 너비 수정 */
        }
        .range-bar {
            width: 60%;
            height: 13px;
            background-color: #E5E5E5;
            border-radius: 30px;
            margin-bottom: 10px;
            position: relative;
        }
        
        .range-fill {
            height: 100%;
            background-color: #55C595;
            border-radius: 30px;
            position: absolute;
            top: 0;
            left: 0;
        }
        .range-label {
        	font-size: 18px;
        	top: 15px;
            position: absolute;
            transform: translateX(2px);
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
		
		.logout {
			margin-bottom: 15px;
		}

    </style>
</head>
<body>
	<header>
		<button type="button" id="homeButton" style="background-color: transparent; border: none; margin-left: 50px;">
		    <img src="home.png" alt="Home" style="width: 20px; height: 35px;">
		</button>
		<button type="button" id="rankingButton" style="background-color: transparent; border: none; margin-left: 30px">
		    <img src="rank.png" alt="ranking" style="width: 35px; height: 35px;">
		</button>
		<button type="button" id="myButton" style="background-color: transparent; border: none; margin-left: 10px; margin-right: 50px;">
		    <img src="mycheck.png" alt="mypage" style="width: 35px; height: 35px;">
		</button>
	</header>
	<script>
	    var loggedInUserId = "<%= request.getParameter("id") %>"; // JSP 변수를 JavaScript 변수로 전달
	
	    document.getElementById("homeButton").addEventListener("click", function() {
	        // home.jsp로 이동하는 코드
	        window.location.href = "home(center-align version).jsp?id=" + loggedInUserId;
	    });
	
	    document.getElementById("rankingButton").addEventListener("click", function() {
	        // ranking.jsp로 이동하는 코드
	        window.location.href = "ranking.jsp?id=" + loggedInUserId;
	    });
	
	    document.getElementById("myButton").addEventListener("click", function() {
	        // myPage.jsp로 이동하는 코드
	        window.location.href = "myPage.jsp?id=" + loggedInUserId;
	    });
	</script>
	<%
	    //String loggedInUserId = (String) session.getAttribute("loggedInUser");
		String loggedInUserId = request.getParameter("id");
	    // 데이터베이스 연결 정보
	    String url = "jdbc:mysql://localhost:3306/ecosmeticbin";
	    String username = "root";
	    String password = "1234";
		
	    String userId = "";
	    int level = 0;
	    String levelname = "";
	    int totalmileage = 0;
	    int result = 0;
	
	    Connection conn = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
		
	    try {
	        // 데이터베이스 연결
	        conn = DriverManager.getConnection(url, username, password);
	
	        String sql = "SELECT u.id, u.level, u.totalmileage, l.levelname, h.result " +
	                "FROM user u " +
	                "JOIN history h ON u.id = h.id " +
	                "JOIN level l ON u.level = l.level " +
	                "WHERE u.id = ?";
	
	        pstmt = conn.prepareStatement(sql);
	
	        pstmt.setString(1, loggedInUserId);
	
	        // 쿼리 실행
	        rs = pstmt.executeQuery();
	
	        // 결과 확인
	        if (rs.next()) {
	            // 사용자 정보 추출
	            userId = rs.getString("id");
	            level = rs.getInt("level");
	            levelname = rs.getString("levelname");
	            totalmileage = rs.getInt("totalmileage");
	            result = rs.getInt("result");
	            
	            System.out.println(userId + "님의 마이페이지 접속");
	        }
	    } catch (SQLException e) {
	        out.println("오류 발생: " + e.getMessage());
	    } finally {
	        // 연결 및 리소스 해제
	        try { if (rs != null) rs.close(); } catch (SQLException e) { e.printStackTrace(); }
	        try { if (pstmt != null) pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
	        try { if (conn != null) conn.close(); } catch (SQLException e) { e.printStackTrace(); }
	    }
	    
	    String currentLevel = levelname;
	    String currentLevelImage = "";
	    String nextLevel = "";
	    String nextLevelImage = "";
	  
	    int nextLevelMileageThreshold = 0;
	
	    if (totalmileage >= 0 && totalmileage < 5000) {
	        nextLevel = "Silver";
	        nextLevelMileageThreshold = 5000;
	        nextLevelImage = "Silver.png"; 
	        currentLevelImage = "Bronze.png";
	    } else if (currentLevel.equals("Silver")) {
	        nextLevel = "Gold";
	        nextLevelMileageThreshold = 20000;
	        nextLevelImage = "Gold.png"; 
	        currentLevelImage = "Silver.png"; 
	    } else if (currentLevel.equals("Gold")) {
	        nextLevel = "Platinum";
	        nextLevelMileageThreshold = 50000;
	        nextLevelImage = "Platinum.png"; 
	        currentLevelImage = "Gold.png";
	    } else {
	        nextLevel = "Diamond";
	        nextLevelMileageThreshold = 50000;
	        nextLevelImage = "Diamond.png";
	        currentLevelImage = "Platinum.png"; 
	    }
	
	    int requiredMileageForNextLevel = nextLevelMileageThreshold - totalmileage;
	
	    int remainingMileage = requiredMileageForNextLevel > 0 ? requiredMileageForNextLevel : 0;
	    String formattedRemainingMileage = String.format("%,d", remainingMileage);
	    
	    double rangePercentage = (double) totalmileage / nextLevelMileageThreshold * 100;
	    double rangePerUnit = 100.0 / nextLevelMileageThreshold;
	    
	    request.setAttribute("currentLevelImage", currentLevelImage);
	    request.setAttribute("nextLevelImage", nextLevelImage);
	    request.setAttribute("nextLevelname", nextLevel);
	    request.setAttribute("remainingMileage", remainingMileage);
	%>
		<div class="rest" style="display: flex; flex-direction: column;">
		    <span style="font-size: 38px; text-align: center; margin-bottom: 20px; font-weight: bold;">마이 페이지</span>
		    <div style="margin-top: 10px;">
		    <img src="<%= currentLevelImage %>" style="width:80px; height:80px; display: inline-block;" alt="<%= currentLevel %>">
		    	<div style="font-weight: bold; font-size: 20px; display: inline-block; margin-left: 10px; margin-bottom: 10px; vertical-align: top;">
		        	<span style = "font-size:50px; font-weight: bold;"><%= loggedInUserId %> 님 </span>
		    	</div>
			</div>
		<div style="margin-top: 15px; text-align: left; font-size: 30px;">
		    <%= nextLevel %> 등급까지 마일리지 <br> <span style="color: #55C595; font-weight: bold;"><%= formattedRemainingMileage %>M </span>남음
		    <div style="display: flex; align-items: center; margin-top: 10px; position: relative;">
		        <div class="range-bar" style="flex-grow: 1; position: relative;">
		            <div class="range-fill" style="width: <%= rangePercentage %>%;"></div>
		            <div class="range-label" style="left: 0;"><%= (int) (totalmileage - totalmileage % nextLevelMileageThreshold) %>M</div>
		            <div class="range-label" style="right: 0;"><%= nextLevelMileageThreshold %>M</div>
		        </div>
		        <img src="<%= nextLevelImage %>" alt="<%= nextLevel %>" style="width:70px; height:70px; margin-left: 20px;">
		    </div>
		</div>
		</div>
		
		<br>

    	<div class ="level-info">
    	<span style="font-weight: bold; font-size: 35px;">등급 안내</span>
    		<div style="display: flex; align-items: center; margin-top: 30px; margin-right: 30px; margin-bottom: 30px;">
    			<img src="Bronze.png" alt="브론즈" width="60px" height="60px" style="margin-right: 30px;">
    				<div>
        	<div style="font-size: 25px; font-weight: bold; margin-bottom: 5px;">Bronze</div>
        	<div style="font-size: 20px; font-weight: bold; color: #888888;">1,000M 미만의 마일리지 적립 시 등급</div>
    				</div>
			</div>
    		<div style="display: flex; align-items: center; margin-right: 30px; margin-bottom: 30px;">
    			<img src="Silver.png" alt="실버" width="60px" height="60px" style="margin-right: 30px;">
    				<div>
        	<div style="font-size: 25px; font-weight: bold; margin-bottom: 5px;">Silver</div>
        	<div style="font-size: 20px; font-weight: bold; color: #888888;">5,000M 미만의 마일리지 적립 시 등급</div>
    				</div>
			</div>
    		<div style="display: flex; align-items: center; margin-right: 30px; margin-bottom: 30px;">
    			<img src="Gold.png" alt="골드" width="60px" height="60px" style="margin-right: 30px;">
    				<div>
        	<div style="font-size: 25px; font-weight: bold; margin-bottom: 5px;">Gold</div>
        	<div style="font-size: 20px; font-weight: bold; color: #888888;">20,000M 미만의 마일리지 적립 시 등급</div>
    				</div>
			</div>
    		<div style="display: flex; align-items: center; margin-right: 30px; margin-bottom: 30px;">
    			<img src="Platinum.png" alt="플레티넘" width="60px" height="60px" style="margin-right: 30px;">
    				<div>
        	<div style="font-size: 25px; font-weight: bold; margin-bottom: 5px;">Platinum</div>
        	<div style="font-size: 20px; font-weight: bold; color: #888888;">50,000M 미만의 마일리지 적립 시 등급</div>
    				</div>
			</div>
    		<div style="display: flex; align-items: center; margin-right: 30px; ">
    			<img src="Diamond.png" alt="다이아몬드" width="60px" height="60px" style="margin-right: 30px;">
    				<div>
        	<div style="font-size: 25px; font-weight: bold; margin-bottom: 5px;">Diamond</div>
        	<div style="font-size: 20px; font-weight: bold; color: #888888;">50,000M 미만의 마일리지 적립 시 등급</div>
    				</div>
			</div>
    	</div> <br>
    	<div class ="logout" style="text-align: center;">
    	<button type="button" id="logoutButton" style="background-color: transparent; border: none; font-size: 30px; color: #55C595;">
		    로그아웃
		</button>
		<script>
		    document.getElementById("logoutButton").addEventListener("click", function() {
		        <% 
		        session.invalidate(); 
		        %>
		        window.location.href = "ecomesticBin.jsp";
		    });
		</script>
		</div>
    </body>
</html>