<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>대시보드</title>
    <style>
        body {
            background-color: #F5F5F5;
            font-family: Arial, sans-serif;
        }


        #user-info {
            margin-top: 50px;
            font-size: 32px;
            color: #333;
        }

        #user-level {
            font-size: 18px;
            color: #555;
        }
		
		.show-mileage, .mileage-calendar, .mileage-chart {
            background-color: white;
            border-radius: 30px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            width: 100%;
            max-width: 500px;
            display : flex;       
            align-items : center;
		}
		
		.show-mileage {
			font-size: 20px;
		}
		
		.mileage-calendar {
			text-align: center;
			justify-content : center;
			font-size: 30px;
			word-spacing:5px;
		}

        @media only screen and (max-width: 600px) {
            input[type="text"],
            input[type="button"] {
                width: 100%;
                max-width: 300px;
            }
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
    String level = "";
    String levelname = "";
    int totalmileage =0;

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        // 데이터베이스 연결
        conn = DriverManager.getConnection(url, username, password);

        String sql = "SELECT u.id, u.level, u.totalmileage, l.levelname " +
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
            level = rs.getString("level");
            levelname = rs.getString("levelname");
            totalmileage = rs.getInt("totalmileage");
        }
    } catch (SQLException e) {
        out.println("오류 발생: " + e.getMessage());
    } finally {
        // 연결 및 리소스 해제
        try { if (rs != null) rs.close(); } catch (SQLException e) { e.printStackTrace(); }
        try { if (pstmt != null) pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
        try { if (conn != null) conn.close(); } catch (SQLException e) { e.printStackTrace(); }
    }
%>

<div id="user-info" style="display: flex;">
    <strong><%= userId %> 님, 안녕하세요!<br></strong>
    <%-- Lv <%= level %> <%= levelname %>--%>
</div><br>

<div class="show-mileage">
	<img src="mileage-coin.png" alt="User Image" style="width: 100px; height: 100px; border-radius: 50%; margin-right: 20px;" />
		총 마일리지
		<strong><%= totalmileage %> M </strong>
</div> <br>

<div class="mileage-calendar">
	<button onclick="prevMonth()">이전</button>
    <button onclick="nextMonth()">다음</button>
	<script>
    var currentDate = new Date();

    var currentYear = currentDate.getFullYear();
    var currentMonth = currentDate.getMonth() + 1;

    function getDaysInMonth(year, month) {
        return new Date(year, month, 0).getDate();
    }

    function generateCalendar(year, month) {
        var daysInMonth = getDaysInMonth(year, month);
        var calendarHTML = '<table>';

        calendarHTML += '<tr><th colspan="7">' + month + '월 ' + year + '년</th></tr>';
        calendarHTML += '<tr><th>일</th><th>월</th><th>화</th><th>수</th><th>목</th><th>금</th><th>토</th></tr>';

        var date = new Date(year, month - 1, 1);

        calendarHTML += '<tr>';
        for (var i = 0; i < date.getDay(); i++) {
            calendarHTML += '<td></td>';
        }

        for (var day = 1; day <= daysInMonth; day++) {
            var dayStr = day.toString(); // Convert day to string
            calendarHTML += '<td style="position: relative;">' + dayStr + '</td>';
            if (date.getDay() === 6) { //토요일일시 일요일은 다음 행부터
                calendarHTML += '</tr><tr>';
            }
            date.setDate(date.getDate() + 1); // 다음날짜로
        }

        while (date.getDay() > 0 && date.getDay() < 7) {
            calendarHTML += '<td></td>';
            date.setDate(date.getDate() + 1);
        }

        calendarHTML += '</tr></table>';
        return calendarHTML;
    }

    document.querySelector('.mileage-calendar').innerHTML = generateCalendar(currentYear, currentMonth);

    function prevMonth() {
        currentMonth--;
        if (currentMonth < 1) {
            currentMonth = 12;
            currentYear--;
        }
        refreshCalendar();
    }

    function nextMonth() {
        currentMonth++;
        if (currentMonth > 12) {
            currentMonth = 1;
            currentYear++;
        }
        refreshCalendar();
    }
    
    function refreshCalendar() {
        document.querySelector('.mileage-calendar').innerHTML = generateCalendar(currentYear, currentMonth);
    }
    
    var smallSquareHTML = '<div style="width: 20px; height: 20px; background-color: lightgray; display: inline-block; margin-top: 2px;"></div>';

    var tdElements = document.querySelectorAll('.mileage-calendar table td');
    tdElements.forEach(function(td) {
        if (td.innerHTML !== "") { 
            td.innerHTML += '<br>' + smallSquareHTML;
        }
    });
</script>

</div>
<br>
<div class="mileage-chart">
		차트들어갈곳
</div>
<br>
</body>
</html>
