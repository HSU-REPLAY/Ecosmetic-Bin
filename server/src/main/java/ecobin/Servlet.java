
package ecobin;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

@WebServlet("/data")
public class Servlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // 데이터베이스 연결 정보
    String url = "jdbc:mysql://localhost:3306/ecosmeticbin";
    String username = "root";
    String password = "1234";

    // 데이터베이스 연결 객체
    Connection connection = null;

    // 서블릿 초기화 메서드
    public void init() {
        try {
            // JDBC 드라이버 로드
            Class.forName("com.mysql.cj.jdbc.Driver");
            // 데이터베이스 연결
            connection = DriverManager.getConnection(url, username, password);
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 파라미터 추출
        String userId = request.getParameter("userId");
        String plasticCount = request.getParameter("plasticCount");
        String canCount = request.getParameter("canCount");
        String glassCount = request.getParameter("glassCount");

        // 데이터 처리 로직
        System.out.println("User ID: " + userId);
        System.out.println("Plastic Count: " + plasticCount);
        System.out.println("Glass Count: " + glassCount);
        System.out.println("Can Count: " + canCount);

        // 데이터베이스에 쿼리 실행 등의 작업 수행
        try {
            // 사용자 정보를 가져오는 쿼리 작성
            String query = "SELECT * FROM user WHERE id = ?";
            PreparedStatement statement = connection.prepareStatement(query);
            statement.setString(1, userId);
            ResultSet resultSet = statement.executeQuery();

            // 사용자 정보가 있다면 출력
            if (resultSet.next()) {
                System.out.println("User mileage: " + resultSet.getString("totalmileage"));
                System.out.println("User level: " + resultSet.getString("level"));
                // 여기서 추가적인 데이터 처리 작업 수행
            } else {
                System.out.println("User not found");
            }

            // 리소스 해제
            resultSet.close();
            statement.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }

        response.getWriter().append("OK");
    }

    // 서블릿 종료 시 호출되는 메서드
    public void destroy() {
        try {
            // 데이터베이스 연결 닫기
            if (connection != null) {
                connection.close();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}