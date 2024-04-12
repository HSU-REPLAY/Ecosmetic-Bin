<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %> 

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>대시보드</title>
    <style>
        body {
            background-color: #F5F5F5;
            font-family: Arial, sans-serif;
            color: #888888;
        }

        .btn-container {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 10px;
        }

        .btn-container button {
            background-color: #349C9D;
            color: white;
            border: none;
            border-radius: 5px;
            padding: 8px 12px;
            cursor: pointer;
        }

        .calendar-container {
            display: flex;
            flex-direction: column;
        }

        #user-info {
            margin-top: 50px;
            font-size: 25px;
            color: #333;
        }

        #user-level {
            font-size: 18px;
            color: #555;
        }
        
        #recycling-info {
        	font-size: 40px;
        	font-weight: bold;
        	color: black;
        	display: flex;
        	align-items: flex-start;
        	margin-top: 20px;
        	justify-content: flex-start;	
        }
        .show-mileage, .mileage-chart {
            background-color: white;
            border-radius: 30px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            width: 100%;
            max-width: 500px;
            display : flex;       
            align-items : center;
            margin: 5px;
        }
        
        .show-mileage {
            font-size: 20px;
        }
        
        .mileage-calendar-container {
            width: 100%;
            height: 450px;
            overflow-y: auto;
        }
        
        .mileage-calendar {
            background-color: white;
            border-radius: 30px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            width: 95%;
            max-width: 500px;
            display : flex;       
            margin: 5px;
            padding-left: 20px;
            font-size: 20px;
            height: 900px;
        }
        
        .mileage-calendar table {
            margin-top: 20px;
            width: 90%;
            table-layout: fixed;
        }

        .mileage-calendar table td {
		    width: 14.28%;
		    vertical-align: top;
		    cursor: pointer;
		    text-align: center;
		    padding: 10px 0;
		    position: relative;
		}
        
        .mileage-calendar table td.clicked::before {
		    position: absolute;
		    width: 20px;
		    height: 20px;
		    background-color: black;
		    border-radius: 50%;
		    font-size: 16px;
		    text-align: center;
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
            level = rs.getString("level");
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
    
 // 데이터베이스에서 플라스틱, 유리, 캔 개수를 가져오는 부분 수정
    String selectedDate = request.getParameter("selectedDate");
    Object plasticCountObj = request.getAttribute("plasticCount");
    Object glassCountObj = request.getAttribute("glassCount");
    Object canCountObj = request.getAttribute("canCount");

    //데이터가 null이 아닌지 확인 후, String으로 변환하여 사용
    String plasticCount = (plasticCountObj != null) ? plasticCountObj.toString() : "";
    String glassCount = (glassCountObj != null) ? glassCountObj.toString() : "";
    String canCount = (canCountObj != null) ? canCountObj.toString() : "";

    request.setAttribute("plasticCount", plasticCount);
    request.setAttribute("glassCount", glassCount);
    request.setAttribute("canCount", canCount);
    
%>
<div id="user-info" style="display: flex;">
    <div style="color:#55C595; font-weight: bold; margin-left: 20px;"><%= (userId != null ? userId + " 님" : "") %></div><div style="font-weight: bold;">&nbsp;안녕하세요!<br></div>
</div><br>


<div class="show-mileage">
    <img src="mileage-coin.png" alt="User Image" style="width: 100px; height: 100px; border-radius: 50%; margin-right: 20px;" />
    <div style="display: flex; flex-direction: column;">
        <div style="font-size: 20px; margin-bottom: 10px; ">총 마일리지</div>
        <div style="font-size: 30px; font-weight: bold; color: black;"><%= totalmileage %> M</div>
    </div>
</div><br>
<div class="mileage-calendar" style="position: relative;">
    <div id="calendar-container"></div>
    <div style="position: absolute; bottom: 40px; left: 50%; transform: translateX(-50%);">
        <img class="type-img" src="type.png" width="400px" height="230px" style="position: absolute; bottom: 20px; left: 50%; transform: translateX(-50%); margin-bottom: 30px;">
        <div id="recycling-info" style="position: absolute; bottom: 30px; left: 50%; transform: translateX(-50%);">
            <span id="plasticCount">0</span>
            <span id="glassCount" style="margin-left: 120px;">0</span>
            <span id="canCount" style="margin-left: 95px;">0</span>
        </div>
                <div style="text-align: center; font-size: 15px; font-weight: bold;">
    			<span id="totalResult"></span>
				</div>
    </div>
</div>
<button type="button" onclick="location.href='myPage.jsp'">마이 페이지로 이동</button>
<button type="button" onclick="location.href='ranking.jsp'">랭킹으로 이동</button>

<script>
	var currentDate = new Date(); 
	var currentYear = currentDate.getFullYear(); 
	var currentMonth = currentDate.getMonth() + 1;

    function getDaysInMonth(year, month) {
        return new Date(year, month, 0).getDate();
    }
	
    function getRecyclingCount(year, month, day) {
        var selectedDate = year + "-" + month + "-" + day;
        var xhr = new XMLHttpRequest();
        var count = 0; // 재활용 횟수를 저장할 변수 초기화

        xhr.open('GET', 'updateChartData.jsp?selectedDate=' + selectedDate, false);
        xhr.send();

        if (xhr.readyState === 4 && xhr.status === 200) {
            // JSON 형태로 반환된 데이터를 파싱하여 재활용 횟수를 가져옴
            var data = JSON.parse(xhr.responseText);
            count = data.recyclingCount;
        }

        return count;
    }
    
    function generateCalendar(year, month) {
        var daysInMonth = getDaysInMonth(year, month);
        var calendarHTML = '<table>'; 

        calendarHTML += '<tr><th colspan="7" style="position: relative;">';
        calendarHTML += '<span onclick="prevMonth()" style="position: absolute; left: 0; width: 18px; height: 18px; cursor: pointer; background-image: url(\'pre.png\');"></span>';
        calendarHTML += month + '월 ' + year + '년';
        calendarHTML += '<span onclick="nextMonth()" style="position: absolute; right: 0; width: 18px; height: 18px; cursor: pointer; background-image: url(\'next.png\');"></span>';
        calendarHTML += '</th></tr>';
        calendarHTML += '<tr style="height: 5px;"></tr>';
        calendarHTML += '<tr><th>일</th><th>월</th><th>화</th><th>수</th><th>목</th><th>금</th><th>토</th></tr>'; 
        
        var date = new Date(year, month - 1, 1);

        calendarHTML += '<tr>';
        for (var i = 0; i < date.getDay(); i++) {
            calendarHTML += '<td></td>';
        }

        for (var day = 1; day <= daysInMonth; day++) {
            var dayStr = day.toString(); 
            var backgroundColor = '#EBEDF0'; 

            var recyclingCount = getRecyclingCount(year, month, day);
            if (recyclingCount > 0 && recyclingCount <= 3) {
                backgroundColor = '#CFF4D2'; // 1~3회 재활용
            } else if (recyclingCount >= 4 && recyclingCount <= 6) {
                backgroundColor = '#7DE495'; // 4~6회 재활용
            } else if (recyclingCount >= 7 && recyclingCount <= 10) {
                backgroundColor = '#55C595'; // 7~10회 재활용
            } else if (recyclingCount > 10) {
                backgroundColor = '#339B9C'; // 10회 이상 재활용
            }

            calendarHTML += '<td style="text-align: center; position: relative;">' + dayStr + '<br>' + 
            '<div style="width: 20px; height: 20px; background-color: ' + backgroundColor + 
            '; display: inline-block; margin-top: 2px; border-radius: 5px;"></div>' + '</td>';
            if (date.getDay() === 6) {
                calendarHTML += '</tr><tr>';
            }
            date.setDate(date.getDate() + 1); 
        }

        while (date.getDay() > 0 && date.getDay() < 7) {
            calendarHTML += '<td></td>'; 
            date.setDate(date.getDate() + 1);
        }

        while (date.getDay() > 0 && date.getDay() < 7) {
            calendarHTML += '<td></td>'; 
            date.setDate(date.getDate() + 1);
        }
        calendarHTML += '</tr></table>';
        calendarHTML += '<img src="range.png" width="180px" height="15px" style="position: absolute; bottom: 400px; left: 70%; transform: translateX(-50%);">';
        
        return calendarHTML;
    }

    document.querySelector('.mileage-calendar #calendar-container').innerHTML = generateCalendar(currentYear, currentMonth);

    function prevMonth() {
        currentMonth--; 
        if (currentMonth < 1) {
            currentMonth = 12;
            currentYear--;
        }
        refreshCalendar();
    }

    // 다음 달로 이동하는 함수
    function nextMonth() {
        currentMonth++;
        if (currentMonth > 12) { 
            currentMonth = 1;
            currentYear++;
        }
        refreshCalendar();
    }
    
    function refreshCalendar() {
    	var calendarHTML = generateCalendar(currentYear, currentMonth);
        document.querySelector('.mileage-calendar #calendar-container').innerHTML = generateCalendar(currentYear, currentMonth); // 달력을 새로 고칩니다.
        document.getElementById("currentMonthYear").innerHTML = currentMonth + "월 " + currentYear + "년"; // 현재 연도와 월을 업데이트합니다.
    }

	var cells = document.querySelectorAll('.mileage-calendar table td');
	cells.forEach(function(cell) {
	    cell.addEventListener('click', function() {
	        document.querySelectorAll('.clicked').forEach(function(clickedCell) {
	            clickedCell.classList.remove('clicked');
	        });
	
	        this.classList.add('clicked');
	        
	        var selectedDate = currentYear + '-' + currentMonth + '-' + this.textContent;
	        
	        var xhr = new XMLHttpRequest();
	        xhr.open('GET', 'updateChartData.jsp?selectedDate=' + selectedDate, true); // 'selectedDate' 파라미터를 추가하여 날짜를 전달합니다.
	        xhr.onreadystatechange = function() {
	            if (xhr.readyState == 4 && xhr.status == 200) {
	                updateChart(xhr.responseText);
	            }
	        };
	        xhr.send();
	    });
	});

    function updateChart(responseData) {
        var data = JSON.parse(responseData);

        var plasticCount = data.plasticCount;
        var glassCount = data.glassCount;
        var canCount = data.canCount;

        var plasticCountElement = document.getElementById("plasticCount");
        if (plasticCountElement) {
            plasticCountElement.innerText = plasticCount;
        }

        var glassCountElement = document.getElementById("glassCount");
        if (glassCountElement) {
            glassCountElement.innerText = glassCount;
        }

        var canCountElement = document.getElementById("canCount");
        if (canCountElement) {
            canCountElement.innerText = canCount;
        }

        var totalResultElement = document.getElementById("totalResult");
        if (totalResultElement) {
            var totalResult = data.result;
            totalResultElement.innerHTML = "총 " + "<b style='color: black; font-size: 20px;'>" + totalResult + "  M</b> 적립했습니다";
        }
    }
</script>
<br>
<div class="mileage-chart" style="text-align: center; display: flex; flex-direction: column; justify-content: center; align-items: center;">
	<br> <br> <h3>월별 마일리지 내역</h3> <br>
	<jsp:include page="mileageChart.jsp" />
</div>
<br>
</body>
</html>