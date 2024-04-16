
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

@WebServlet({ "/check", "/result" })
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

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // 파라미터 추출
        String userId = request.getParameter("userId");
        String requestURI = request.getRequestURI();

        if (requestURI.equals("/ecobin/check")) {
            boolean userExists = false;
            String webexId = "none";

            try {
                // 사용자 존재 여부 확인
                String sqlUserExists = "SELECT 1 FROM `user` WHERE id = ?";
                PreparedStatement statementUserExists = connection.prepareStatement(sqlUserExists);
                statementUserExists.setString(1, userId);
                ResultSet resultSetUserExists = statementUserExists.executeQuery();

                if (resultSetUserExists.next()) {
                    userExists = true;
                    System.out.println("User found");

                    // Webex ID 조회
                    String sqlWebexId = "SELECT webex_id FROM webex WHERE id = ?";
                    PreparedStatement statementWebexId = connection.prepareStatement(sqlWebexId);
                    statementWebexId.setString(1, userId);
                    ResultSet resultSetWebexId = statementWebexId.executeQuery();

                    if (resultSetWebexId.next()) {
                        webexId = resultSetWebexId.getString("webex_id");
                        System.out.println("Webex ID found: " + webexId);
                    } else {
                        System.out.println("Webex ID not found");
                    }

                    resultSetWebexId.close();
                    statementWebexId.close();
                } else {
                    System.out.println("User not found");
                }

                resultSetUserExists.close();
                statementUserExists.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }

            // 응답 설정
            response.setContentType("text/plain");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write("verified: " + userExists + ", webexId: " + webexId);
        } else if(requestURI.equals("/ecobin/result")){
        // String userId = request.getParameter("userId"); // userId 변수 정의

        String date = request.getParameter("date");
        int plasticCount = Integer.parseInt(request.getParameter("plasticCount"));
        int canCount = Integer.parseInt(request.getParameter("canCount"));
        int glassCount = Integer.parseInt(request.getParameter("glassCount"));

        try {
            // Insert query to add the recycling information
            String sql = "INSERT INTO history (id, date, recyclingcode, recyclingcount) VALUES (?, ?, ?, ?)";

            // Add plastic count
            PreparedStatement statement = connection.prepareStatement(sql);
            statement.setString(1, userId);
            statement.setString(2, date);
            statement.setString(3, "plastic");
            statement.setInt(4, plasticCount);

            int rowsInserted = statement.executeUpdate();
            if (rowsInserted > 0) {
                System.out.println("새로운 레코드가 성공적으로 삽입되었습니다!");
            } else {
                System.out.println("레코드 삽입에 실패했습니다!");
            }

            // Add can count
            statement = connection.prepareStatement(sql); // 새 PreparedStatement 객체 생성
            statement.setString(1, userId);
            statement.setString(2, date);
            statement.setString(3, "can");
            statement.setInt(4, canCount);

            rowsInserted = statement.executeUpdate();
            if (rowsInserted > 0) {
                System.out.println("새로운 레코드가 성공적으로 삽입되었습니다!");
            } else {
                System.out.println("레코드 삽입에 실패했습니다!");
            }

            // Add glass count
            statement = connection.prepareStatement(sql); // 새 PreparedStatement 객체 생성
            statement.setString(1, userId);
            statement.setString(2, date);
            statement.setString(3, "glass");
            statement.setInt(4, glassCount);

            rowsInserted = statement.executeUpdate();
            if (rowsInserted > 0) {
                System.out.println("새로운 레코드가 성공적으로 삽입되었습니다!");
            } else {
                System.out.println("레코드 삽입에 실패했습니다!");
            }

            // Release resources
            statement.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        // 응답 설정
        response.setContentType("text/plain");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write("200");
        }
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

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}