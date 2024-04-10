<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.text.SimpleDateFormat" %>

<%
// 세션에서 사용자 ID 가져오기
String loggedInUserId = (String) session.getAttribute("loggedInUser");

// 데이터베이스 연결 정보
String dbUrl = "jdbc:mysql://localhost:3306/ecosmeticbin";
String dbUsername = "root";
String dbPassword = "1234";

// 현재 날짜 가져오기
java.util.Date currentDate = new java.util.Date();
SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM");
String currentMonth = dateFormat.format(currentDate);

// 선택된 월
String selectedMonth = request.getParameter("selectedMonth");
if (selectedMonth == null || selectedMonth.isEmpty()) {
    selectedMonth = currentMonth;
}

ArrayList<String> recyclingCodes = new ArrayList<String>();
ArrayList<Integer> recyclingCounts = new ArrayList<Integer>();
int totalMileage = 0; // 전체 마일리지를 저장할 변수

Connection connection = null;
PreparedStatement statement = null;
ResultSet resultSet = null;

int totalRecyclingCount = 0;

try {
    // 데이터베이스 연결
    Class.forName("com.mysql.jdbc.Driver");
    connection = DriverManager.getConnection(dbUrl, dbUsername, dbPassword);

    // 쿼리 작성
    String sql = "SELECT recyclingcode, SUM(recyclingcount) AS total_count FROM history WHERE id = ? AND DATE_FORMAT(date, '%Y-%m') = ? GROUP BY recyclingcode";

    // PreparedStatement 설정
    statement = connection.prepareStatement(sql);
    statement.setString(1, loggedInUserId);
    statement.setString(2, selectedMonth);

    // 쿼리 실행
    resultSet = statement.executeQuery();

    // 결과 확인
    if (!resultSet.next()) {
        // 결과가 없는 경우에 대한 처리
        // 임의의 데이터를 추가하여 차트를 생성하도록 합니다.
        recyclingCodes.add("No Data");
        recyclingCounts.add(0);
    } else {
        // 결과가 있는 경우에는 조회된 데이터를 배열에 추가합니다.
        do {
            recyclingCodes.add(resultSet.getString("recyclingcode"));
            recyclingCounts.add(resultSet.getInt("total_count"));
            totalRecyclingCount += resultSet.getInt("total_count"); // 재활용 횟수의 총합 계산
        } while (resultSet.next());
    }

    // 전체 마일리지 가져오기
    sql = "SELECT SUM(result) AS total_mileage FROM history WHERE id = ? AND DATE_FORMAT(date, '%Y-%m') = ?";
    statement = connection.prepareStatement(sql);
    statement.setString(1, loggedInUserId);
    statement.setString(2, selectedMonth);
    resultSet = statement.executeQuery();

    if (resultSet.next()) {
        totalMileage = resultSet.getInt("total_mileage");
    }

} catch (ClassNotFoundException e) {
    out.println("오류 발생: " + e.getMessage());
} catch (SQLException e) {
    out.println("오류 발생: " + e.getMessage());
} finally {
    // 연결 및 리소스 해제
    try { if (resultSet != null) resultSet.close(); } catch (SQLException e) { e.printStackTrace(); }
    try { if (statement != null) statement.close(); } catch (SQLException e) { e.printStackTrace(); }
    try { if (connection != null) connection.close(); } catch (SQLException e) { e.printStackTrace(); }
}
%>

<script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.9.3/Chart.min.js"></script>
<div style="position: relative; width: 400px; height: 400px; color: #666666">
    <canvas id="myDonutChart"></canvas>
    <div id="chartLegend" style="position: absolute; bottom: 10px; left: 50%; transform: translateX(-50%);">
        <%-- 범례를 표시할 위치 설정 --%>
        <div style="display: flex; flex-direction: column; align-items: center;">
            <%
                // 각 재활용 코드의 백분율 계산 및 표시
                for (int i = 0; i < recyclingCodes.size(); i++) {
                    int percentage = totalRecyclingCount == 0 ? 0 : Math.round((float) recyclingCounts.get(i) / totalRecyclingCount * 100);
                    String color = i == 0 ? "#349C9D" : (i == 1 ? "#55C595" : "#7CE494");
            %>
        <div style="display: flex; align-items: center; text-align: left;">
    		<span style="width:30px; margin-right: 20px; font-weight: bold; color: <%= color %>;"><%= percentage %>%</span>
    		<span style="width:40px; margin-right: 20px;"><%= recyclingCodes.get(i) %></span>
    		<div style="width: 200px; height: 5px; background-color: #E8E8E8; position: relative; border-radius: 5px; margin-left: 10px;">
        		<div style="width: <%= percentage %>% ; height: 100%; background-color: <%= color %>; position: absolute; left: 0; border-radius: 5px;"></div>
    		</div>
    		<span style="width: 30px; margin-left: 10px;"><%= recyclingCounts.get(i) %>개</span>
		</div>

            <% } %>
        </div>
    </div>
</div>


<script>
    // 도넛 차트 생성 함수
    function createDonutChart() {
        var ctx = document.getElementById('myDonutChart').getContext('2d');
        var myDonutChart = new Chart(ctx, {
            type: 'doughnut',
            data: {
                labels: [<%
                    for (int i = 0; i < recyclingCodes.size(); i++) {
                        out.println("'" + recyclingCodes.get(i) + "'");
                     		if (i < recyclingCodes.size() - 1) out.println(", ");
                    }
                %>],
                datasets: [{
                    label: 'Recycling Counts',
                    data: [<%
                        for (int i = 0; i < recyclingCounts.size(); i++) {
                            out.println(recyclingCounts.get(i));
                            if (i < recyclingCounts.size() - 1) out.println(", ");
                        }
                    %>],
                    backgroundColor: [
                        '#349C9D',
                        '#55C595',
                        '#7CE494'
                    ],
                    borderColor: [
                        '#349C9D',
                        '#55C595',
                        '#7CE494'
                    ],
                    borderWidth: 1
                }]
            },
            options: {
                cutoutPercentage: 75,
                elements: {
                    arc: {
                        borderWidth: 0.5 // 외곽선 두께 조절
                    }
                },
                animation: false // 애니메이션 비활성화
            }
        });
        
        

        // 월별 마일리지 표시
        var text = "<%= selectedMonth.substring(5) %>월 마일리지 <%= totalMileage %>M";
        var textX = myDonutChart.canvas.clientWidth / 2;
        var textY = myDonutChart.canvas.clientHeight / 2;
        var ctx = myDonutChart.ctx;
        ctx.textAlign = 'center';
        ctx.textBaseline = 'middle';
        ctx.font = 'bold 20px Arial';
        ctx.fillStyle = '#000'; // 텍스트 색상
        ctx.fillText(text, textX, textY);
    }

    // 도넛 차트 생성 함수 호출
    createDonutChart();
</script>
