<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
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
            font-size: 32px;
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
            width: auto;
            max-width: 480px;
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
    String result = "";

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
    <div style="color:green; font-weight: bold;"><%= userId %></div><div style="font-weight: bold;">&nbsp;님, 안녕하세요!<br></div>
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
        <img class="type-img" src="type.png" width="400px" height="230px" style="position: absolute; bottom: 60px; left: 50%; transform: translateX(-50%); margin-bottom: 30px;">
        <div id="recycling-info" style="position: absolute; bottom: 80px; left: 50%; transform: translateX(-50%);">
            <span id="plasticCount">0</span>
            <span id="glassCount" style="margin-left: 120px;">0</span>
            <span id="canCount" style="margin-left: 110px;">0</span>
        </div>
                <div style="text-align: center;"> 총 <%= result %>M 적립했습니다 </div>
    </div>
</div>


<script>
	var currentDate = new Date(); // 현재 날짜를 가져옵니다.
	var currentYear = currentDate.getFullYear(); // 현재 연도를 가져옵니다.
	var currentMonth = currentDate.getMonth() + 1; // 현재 월을 가져옵니다. (월은 0부터 시작하므로 1을 더합니다.)

    function getDaysInMonth(year, month) {
        return new Date(year, month, 0).getDate(); // 해당 연도와 월의 일 수를 반환합니다.
    }

    function generateCalendar(year, month) {
        var daysInMonth = getDaysInMonth(year, month); // 해당 연도와 월의 일 수를 가져옵니다.
        var calendarHTML = '<table>'; // 달력을 만들기 위한 HTML 문자열을 초기화합니다.

        calendarHTML += '<tr><th colspan="7" style="position: relative;">';
        calendarHTML += '<span onclick="prevMonth()" style="position: absolute; left: 0; width: 18px; height: 18px; cursor: pointer; background-image: url(\'pre.png\');"></span>';
        calendarHTML += month + '월 ' + year + '년';
        calendarHTML += '<span onclick="nextMonth()" style="position: absolute; right: 0; width: 18px; height: 18px; cursor: pointer; background-image: url(\'next.png\');"></span>';
        calendarHTML += '</th></tr>';
        calendarHTML += '<tr style="height: 10px;"></tr>';
        <%--calendarHTML += '<tr><td colspan="7" style="border-bottom: 1px solid #888888;"></td></tr>'; --%>
        calendarHTML += '<tr><th>일</th><th>월</th><th>화</th><th>수</th><th>목</th><th>금</th><th>토</th></tr>'; 
        
        var date = new Date(year, month - 1, 1); // 현재 달의 첫째 날의 Date 객체를 생성합니다.

        calendarHTML += '<tr>';
        for (var i = 0; i < date.getDay(); i++) {
            calendarHTML += '<td></td>'; // 이전 달의 날짜를 비워둡니다.
        }

        for (var day = 1; day <= daysInMonth; day++) {
            var dayStr = day.toString(); // 일자를 문자열로 변환합니다.
            var backgroundColor = 'lightgray'; // 기본 배경색을 설정합니다.

            // 특정 날짜의 재활용 횟수를 확인하여 배경색을 설정합니다.
            // 만약 해당 날짜의 재활용 횟수가 1 이상이면 초록색으로 표시합니다.
            if (checkRecyclingCount(year, month, day)) {
                backgroundColor = '#349C9D';
            }

         // 현재 날짜인 경우 동그라미를 추가합니다.
            if (year === currentDate.getFullYear() && month === currentDate.getMonth() + 1 && day === currentDate.getDate()) {
    dayStr = '<div style="position: relative; display: inline-block; width: 20px; height: 20px; background-color: black; border-radius: 50%; text-align: center; line-height: 0px;">' + 
             '<div style="position: absolute; top: 50%; left: 50%; transform: translate(-50%, -50%); color: white; font-size: 16px;">' + dayStr + '</div>' +
             '</div>';
}

            calendarHTML += '<td style="text-align: center; position: relative;">' + dayStr + '<br>' + 
            '<div style="width: 20px; height: 20px; background-color: ' + backgroundColor + 
            '; display: inline-block; margin-top: 2px; border-radius: 5px;"></div>' + '</td>'; // 날짜를 표시하고 배경색을 설정합니다.
            if (date.getDay() === 6) { // 토요일일 경우 다음 행으로 이동합니다.
                calendarHTML += '</tr><tr>';
            }
            date.setDate(date.getDate() + 1); // 다음 날짜로 이동합니다.
        }

        while (date.getDay() > 0 && date.getDay() < 7) {
            calendarHTML += '<td></td>'; // 다음 달의 날짜를 비워둡니다.
            date.setDate(date.getDate() + 1);
        }

        while (date.getDay() > 0 && date.getDay() < 7) {
            calendarHTML += '<td></td>'; // 다음 달의 날짜를 비워둡니다.
            date.setDate(date.getDate() + 1);
        }

        calendarHTML += '</tr></table>';

        // 이미지 요소 추가
        calendarHTML += '<img src="range.png" width="250px" height="25px" style="position: absolute; bottom: 400px; left: 70%; transform: translateX(-50%);">';
        
        
        return calendarHTML;
    }

    // 데이터베이스에서 특정 날짜의 재활용 횟수를 확인하는 함수입니다.
    function checkRecyclingCount(year, month, day) {
        // 여기에 실제 데이터베이스 쿼리를 사용하여 특정 날짜의 재활용 횟수를 확인하는 코드를 구현해야 합니다.
        // 해당 날짜의 재활용 횟수가 1 이상이면 true를 반환하고, 그렇지 않으면 false를 반환합니다.
        // 이 예제에서는 간단히 날짜가 홀수인 경우 true를 반환하고 짝수인 경우 false를 반환합니다.
        return day % 2 !== 0; // 예제 로직입니다. 실제 데이터베이스 쿼리로 대체되어야 합니다.
    }

    document.querySelector('.mileage-calendar #calendar-container').innerHTML = generateCalendar(currentYear, currentMonth);

    function prevMonth() {
        currentMonth--; // 이전 달로 이동합니다.
        if (currentMonth < 1) { // 만약 현재 월이 1월인 경우 이전 해의 12월로 이동합니다.
            currentMonth = 12;
            currentYear--;
        }
        refreshCalendar(); // 달력을 새로고칩니다.
    }

    // 다음 달로 이동하는 함수
    function nextMonth() {
        currentMonth++; // 다음 달로 이동합니다.
        if (currentMonth > 12) { // 만약 현재 월이 12월인 경우 다음 해의 1월로 이동합니다.
            currentMonth = 1;
            currentYear++;
        }
        refreshCalendar(); // 달력을 새로고칩니다.
    }
    
    function refreshCalendar() {
        document.querySelector('.mileage-calendar #calendar-container').innerHTML = generateCalendar(currentYear, currentMonth); // 달력을 새로 고칩니다.
        document.getElementById("currentMonthYear").innerHTML = currentMonth + "월 " + currentYear + "년"; // 현재 연도와 월을 업데이트합니다.
    }

 // 날짜 클릭 이벤트 설정
    var cells = document.querySelectorAll('.mileage-calendar table td');
    cells.forEach(function(cell) {
        cell.addEventListener('click', function() {
            var selectedDate = currentYear + '-' + currentMonth + '-' + this.textContent;
            
            // Ajax 요청 보내기
            var xhr = new XMLHttpRequest();
            xhr.open('GET', 'updateChartData.jsp?selectedDate=' + selectedDate, true); // 'selectedDate' 파라미터를 추가하여 날짜를 전달합니다.
            xhr.onreadystatechange = function() {
                if (xhr.readyState == 4 && xhr.status == 200) {
                    // 차트 업데이트 함수 호출
                    updateChart(xhr.responseText);
                }
            };
            xhr.send();
        });
    });


 // 예시: 받아온 JSON 데이터를 이용하여 차트를 업데이트하는 함수
    function updateChart(responseData) {
        var data = JSON.parse(responseData);

        // 받아온 데이터를 이용하여 차트 업데이트 등의 작업을 수행합니다.
        // 예를 들어, 차트의 데이터를 업데이트하거나, 웹 페이지의 다른 요소에 데이터를 표시할 수 있습니다.

        // 예시: 받아온 데이터를 이용하여 플라스틱, 유리, 캔 개수를 표시하는 예제
    var plasticCount = data.plasticCount;
    var glassCount = data.glassCount;
    var canCount = data.canCount;
        
        // 받아온 데이터를 이용하여 HTML 요소 업데이트 등의 작업을 수행합니다.
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
    }
</script>
<br>
<div class="mileage-chart" style="text-align: center; display: flex; flex-direction: column; justify-content: center; align-items: center;">
    <h3>4월 요약</h3>
        <%--<%@ include file="mileageChart.jsp" %>--%>
    <%-- 이 부분은 해당 월에 대한 차트를 보여주는 부분인데, 여기에 해당 월의 차트를 표시하는 코드를 추가하셔야 합니다. --%>
</div>
<br>
</body>
</html>