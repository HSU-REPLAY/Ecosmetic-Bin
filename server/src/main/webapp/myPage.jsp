<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %> 
<%@ page import="java.text.NumberFormat" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>마이페이지</title>
    <style>
        body {
            background-color: #F5F5F5;
        }
        
        .level-info, .rest {
            background-color: white;
            padding: 20px;
            max-width: 500px;
        }
        .range-bar {
            width: 60%;
            height: 5px;
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
        	font-size: 10px;
        	top: 5px;
            position: absolute;
            transform: translateX(2px);
        }
    </style>
</head>
<body>
<%
    String loggedInUserId = (String) session.getAttribute("loggedInUser");

    // 데이터베이스 연결 정보
    String url = "jdbc:mysql://localhost:3306/ecosmeticbin";
    String username = "root";
    String password = "1234";

    // 사용자 정보를 담을 변수
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
        }
    } catch (SQLException e) {
        out.println("오류 발생: " + e.getMessage());
    } finally {
        // 연결 및 리소스 해제
        try { if (rs != null) rs.close(); } catch (SQLException e) { e.printStackTrace(); }
        try { if (pstmt != null) pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
        try { if (conn != null) conn.close(); } catch (SQLException e) { e.printStackTrace(); }
    }
    
    String currentLevel = levelname; // 사용자의 현재 등급 이름
    String currentLevelImage = ""; // 사용자의 현재 등급 이미지 URL
    String nextLevel = ""; // 사용자의 다음 등급 이름
    String nextLevelImage = ""; // 사용자의 다음 등급 이미지 URL
  
    int nextLevelMileageThreshold = 0;
    // 다음 등급 이미지와 다음 등급 이름을 결정하는 로직을 추가합니다.
    if (currentLevel.equals("Bronze")) {
        nextLevel = "Silver";
        nextLevelMileageThreshold = 5000;
        nextLevelImage = "Silver.png"; // 예시로 Silver.png를 사용합니다.
        currentLevelImage = "Bronze.png"; // Bronze 등급에 해당하는 이미지 URL
    } else if (currentLevel.equals("Silver")) {
        nextLevel = "Gold";
        nextLevelMileageThreshold = 20000;
        nextLevelImage = "Gold.png"; // 예시로 Gold.png를 사용합니다.
        currentLevelImage = "Silver.png"; // Silver 등급에 해당하는 이미지 URL
    } else if (currentLevel.equals("Gold")) {
        nextLevel = "Platinum";
        nextLevelMileageThreshold = 50000;
        nextLevelImage = "Platinum.png"; // 예시로 Platinum.png를 사용합니다.
        currentLevelImage = "Gold.png"; // Gold 등급에 해당하는 이미지 URL
    } else {
        nextLevel = "Diamond";
        nextLevelMileageThreshold = 50000;
        nextLevelImage = "Diamond.png"; // 예시로 Diamond.png를 사용합니다.
        currentLevelImage = "Platinum.png"; // Platinum 등급에 해당하는 이미지 URL
    }

 	// 다음 등급까지 필요한 마일리지 계산
    int requiredMileageForNextLevel = nextLevelMileageThreshold - totalmileage;

    // 남은 마일리지 계산
    int remainingMileage = requiredMileageForNextLevel > 0 ? requiredMileageForNextLevel : 0;
    String formattedRemainingMileage = String.format("%,d", remainingMileage);
    
 	// Range 바의 길이 계산
    double rangePercentage = (double) totalmileage / nextLevelMileageThreshold * 100;
    double rangePerUnit = 100.0 / nextLevelMileageThreshold;
    
    // 사용자의 정보와 계산된 값을 HTML 페이지로 전달합니다.
    request.setAttribute("currentLevelImage", currentLevelImage);
    request.setAttribute("nextLevelImage", nextLevelImage);
    request.setAttribute("nextLevelname", nextLevel);
    request.setAttribute("remainingMileage", remainingMileage);
%>
<div class="rest" style="display: flex; flex-direction: column;">
    <span style="font-size: 30px; text-align: center; margin-bottom: 20px;">마이 페이지</span>
    <div style="margin-top: 10px;">
    <img src="<%= currentLevelImage %>" style="width:50px; height:50px; display: inline-block;" alt="<%= currentLevel %>">
    	<div style="font-weight: bold; font-size: 20px; display: inline-block; margin-left: 10px; margin-bottom: 10px; vertical-align: top;">
        	<span style = "font-size: 25px; font-weight: bold;"><%= loggedInUserId %> 님 </span>
    	</div>
	</div>
<div style="margin-top: 10px; text-align: left; font-size: 20px;">
    <%= nextLevel %> 등급까지 마일리지 <br> <span style="color: #55C595; font-weight: bold;"><%= formattedRemainingMileage %>M </span>남음
    <div style="display: flex; align-items: center; margin-top: 10px; position: relative;">
        <div class="range-bar" style="flex-grow: 1; position: relative;">
            <div class="range-fill" style="width: <%= rangePercentage %>%;"></div>
            <div class="range-label" style="left: 0;"><%= (int) (totalmileage - totalmileage % nextLevelMileageThreshold) %>M</div>
            <div class="range-label" style="right: 0;"><%= nextLevelMileageThreshold %>M</div>
        </div>
        <img src="<%= nextLevelImage %>" alt="<%= nextLevel %>" style="width:30px; height:30px; margin-left: 10px;">
    </div>
</div>
</div>

<br>

    	<div class ="level-info">
    	<span style="font-weight: bold; font-size: 25px;">등급 안내</span>
    		<div style="display: flex; align-items: center; margin-top: 30px; margin-right: 30px; margin-bottom: 30px;">
    			<img src="Bronze.png" alt="브론즈" width="40px" height="40px" style="margin-right: 20px;">
    				<div>
        	<div style="font-size: 20px; font-weight: bold; margin-bottom: 5px;">Bronze</div>
        	<div style="font-size: 15px; font-weight: bold; color: #888888;">1,000M 미만의 마일리지 적립 시 등급</div>
    				</div>
			</div>
    		<div style="display: flex; align-items: center; margin-right: 30px; margin-bottom: 30px;">
    			<img src="Silver.png" alt="실버" width="40px" height="40px" style="margin-right: 20px;">
    				<div>
        	<div style="font-size: 20px; font-weight: bold; margin-bottom: 5px;">Silver</div>
        	<div style="font-size: 15px; font-weight: bold; color: #888888;">5,000M 미만의 마일리지 적립 시 등급</div>
    				</div>
			</div>
    		<div style="display: flex; align-items: center; margin-right: 30px; margin-bottom: 30px;">
    			<img src="Gold.png" alt="골드" width="40px" height="40px" style="margin-right: 20px;">
    				<div>
        	<div style="font-size: 20px; font-weight: bold; margin-bottom: 5px;">Gold</div>
        	<div style="font-size: 15px; font-weight: bold; color: #888888;">20,000M 미만의 마일리지 적립 시 등급</div>
    				</div>
			</div>
    		<div style="display: flex; align-items: center; margin-right: 30px; margin-bottom: 30px;">
    			<img src="Platinum.png" alt="플레티넘" width="40px" height="40px" style="margin-right: 20px;">
    				<div>
        	<div style="font-size: 20px; font-weight: bold; margin-bottom: 5px;">Platinum</div>
        	<div style="font-size: 15px; font-weight: bold; color: #888888;">50,000M 미만의 마일리지 적립 시 등급</div>
    				</div>
			</div>
    		<div style="display: flex; align-items: center; margin-right: 30px; ">
    			<img src="Diamond.png" alt="다이아몬드" width="40px" height="40px" style="margin-right: 20px;">
    				<div>
        	<div style="font-size: 20px; font-weight: bold; margin-bottom: 5px;">Diamond</div>
        	<div style="font-size: 15px; font-weight: bold; color: #888888;">50,000M 미만의 마일리지 적립 시 등급</div>
    				</div>
			</div>
    	</div>
    </body>
   </html>