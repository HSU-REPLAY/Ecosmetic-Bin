<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.text.SimpleDateFormat" %>

<%
// 데이터베이스 연결 정보
String dbUrl = "jdbc:mysql://localhost:3306/ecosmeticbin";
String dbUsername = "root";
String dbPassword = "1234";

// 오늘 날짜를 가져오기
java.util.Date currentDate = new java.util.Date();
SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
String selectedDate = dateFormat.format(currentDate);

// 데이터베이스 연결 및 조회
ArrayList<String> recyclingCodes = new ArrayList<String>();
ArrayList<Integer> recyclingCounts = new ArrayList<Integer>();

Connection connection = null;
PreparedStatement statement = null;
ResultSet resultSet = null;

try {
    // 데이터베이스 연결
    connection = DriverManager.getConnection(dbUrl, dbUsername, dbPassword);

    // 쿼리 작성
    String sql = "SELECT recyclingcode, SUM(recyclingcount) AS total_count FROM history WHERE date = ? GROUP BY recyclingcode";

    // PreparedStatement 설정
    statement = connection.prepareStatement(sql);
    statement.setString(1, selectedDate);

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
        } while (resultSet.next());
    }
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
<canvas id="myDonutChart"></canvas>

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
                        'rgba(255, 99, 132, 0.5)',
                        'rgba(54, 162, 235, 0.5)',
                        'rgba(255, 206, 86, 0.5)',
                        'rgba(75, 192, 192, 0.5)',
                        'rgba(153, 102, 255, 0.5)',
                    ],
                    borderColor: [
                        'rgba(255, 99, 132, 1)',
                        'rgba(54, 162, 235, 1)',
                        'rgba(255, 206, 86, 1)',
                        'rgba(75, 192, 192, 1)',
                        'rgba(153, 102, 255, 1)',
                    ],
                    borderWidth: 1
                }]
            },
            options: {
                responsive: true
            }
        });
    }

    // 도넛 차트 생성 함수 호출
    createDonutChart();
</script>