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
    		width: 100%; /* 부모 요소의 너비에 따라 조정할 수 있도록 설정 */
    		max-width: 460px; /* 최대 너비 설정 */
    		height: 450px; /* 달력의 높이를 고정 */
    		overflow-y: auto; /* 세로 스크롤이 필요할 경우 스크롤바 표시 */
		}
		
		.mileage-calendar {
			background-color: white;
            border-radius: 30px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            width: 100%;
            max-width: 460px;
            display : flex;       
            margin: 5px;
            padding-left: 20px;
            padding-right: 20px;
			font-size: 20px;
			word-spacing:3px;
			height: 800px;
			position: relative;
		}
		
		.mileage-calendar table {
			margin-top: 20px;
        	width: 100%;
        	table-layout: fixed;
    	}

    	.mileage-calendar table td {
        	width: 14.28%;
        	vertical-align: top;
            cursor: pointer; /* 클릭 가능하도록 커서 스타일 설정 */
            text-align: center; /* 텍스트 가운데 정렬 */
            padding: 10px 0; /* 셀 안의 요소들이 수직 가운데 정렬되도록 패딩 설정 */
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
    <div style="color:green; font-weight: bold;"><%= userId %></div><div style="font-weight: bold;">&nbsp;님, 안녕하세요!<br></div>
    
    <%-- Lv <%= level %> <%= levelname %>--%>
</div><br>

<div class="show-mileage">
    <img src="mileage-coin.png" alt="User Image" style="width: 100px; height: 100px; border-radius: 50%; margin-right: 20px;" />
    <div style="display: flex; flex-direction: column;">
        <div style="font-size: 20px; margin-bottom: 10px; ">총 마일리지</div>
        <div style="font-size: 30px; font-weight: bold; color: black;"><%= totalmileage %> M</div>
    </div>
</div><br>

<div class="mileage-calendar">
	<div id="calendar-container"></div>
	<img class="type-img" src="type.png" width="400px" height="250px" style="position: absolute; bottom: 10px; left: 50%; transform: translateX(-50%);">
	<div style="text-align: center; display: flex; flex-direction: column; justify-content: center; align-items: center;"> 총 __M 적립했습니다</div>

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

            calendarHTML += '<td style="text-align: center; position: relative;">' + dayStr + '<br>' + 
            '<div style="width: 20px; height: 20px; background-color: ' + backgroundColor + 
            '; display: inline-block; margin-top: 2px;"></div>' + '</td>'; // 날짜를 표시하고 배경색을 설정합니다.
            if (date.getDay() === 6) { // 토요일일 경우 다음 행으로 이동합니다.
                calendarHTML += '</tr><tr>';
            }
            date.setDate(date.getDate() + 1); // 다음 날짜로 이동합니다.
        }

        while (date.getDay() > 0 && date.getDay() < 7) {
            calendarHTML += '<td></td>'; // 다음 달의 날짜를 비워둡니다.
            date.setDate(date.getDate() + 1);
        }

        calendarHTML += '</tr></table>';

        // 이미지 요소 추가
        calendarHTML += '<img src="range.png" width="250px" height="25px" style="position: absolute; bottom: 300px; left: 70%; transform: translateX(-50%);">';

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
        xhr.open('GET', 'updateChartData.jsp?date=' + selectedDate, true);
        xhr.onreadystatechange = function() {
            if (xhr.readyState == 4 && xhr.status == 200) {
                // 차트 업데이트 함수 호출
                updateChart(xhr.responseText);
            }
        };
        xhr.send();
    });
});
		function updateChart(responseData) {
			// JSON 형식의 응답 데이터를 JavaScript 객체로 파싱합니다.
		    var data = JSON.parse(responseData);

		    // 차트 데이터를 업데이트합니다.
		    myChart.data.labels = data.labels; // 차트의 라벨 업데이트
		    myChart.data.datasets.forEach((dataset, index) => {
		        dataset.data = data.datasets[index].data; // 각 데이터셋의 데이터 업데이트
		    });

		    // 차트를 다시 그립니다.
		    myChart.update();
		}
</script>
<br>
<div class="mileage-chart" style="text-align: center; display: flex; flex-direction: column; justify-content: center; align-items: center;">
    <h3>__월 요약</h3>
		<%@ include file="mileageChart.jsp" %>
    <%-- 이 부분은 해당 월에 대한 차트를 보여주는 부분인데, 여기에 해당 월의 차트를 표시하는 코드를 추가하셔야 합니다. --%>
</div>
<br>
</body>
</html>
