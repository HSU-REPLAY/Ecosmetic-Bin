package ecobin;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;

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

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

@WebServlet({"/check", "/result"})
public class Servlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // 데이터베이스 연결 정보
    String url = "jdbc:mysql://localhost:3306/ecosmeticbin";
    String username = "root";
    String password = "1234";

    // 데이터베이스 연결 객체
    Connection connection = null;

    String accessToken = "Y2RhY2JhMmItNWM2NC00YTIzLTlhNjUtMjlhN2VlZTc2YTVlZWNhZTIwYzItZmU4_P0A1_3110228f-f720-43ec-9b4d-e218298566dd";

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
        String requestURI = request.getRequestURI();
        
        if(requestURI.equals("/ecobin/check")) {
           boolean userExists = false;

            try {
                // 사용자 존재 여부를 확인하는 쿼리 실행
            	String sql = "SELECT webex_id FROM `webex` WHERE id = ?";

                System.out.println("sql 실행 전 userExists : " + userExists);
                
                PreparedStatement statement = connection.prepareStatement(sql);
                statement.setString(1, userId);
                ResultSet resultSet = statement.executeQuery();

                // 사용자 정보가 있다면 출력
                if (resultSet.next()) {
                    userExists = resultSet.getInt("userExists") == 1;
                    System.out.println("sql 실행 후 userExists : " + userExists);
                    // 추가적인 데이터 처리 작업 수행
                } else {
                    System.out.println("User not found");
                }

                // 리소스 해제
                resultSet.close();
                statement.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }

            // 응답 설정
            response.setContentType("text/plain");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write(userExists ? "true" : "false");
        }
        
        else if(requestURI.equals("/ecobin/result")) {
//            String userId = request.getParameter("userId"); // userId 변수 정의

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

                sendWebexNotification(userId, date, plasticCount, canCount, glassCount);
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

    private void sendWebexNotification(String userId, String date, int plasticCount, int canCount, int glassCount) throws IOException, SQLException {
        String findWebexIdSql = "SELECT webex_id FROM `user` WHERE id = ?";
        try (PreparedStatement findWebexIdStmt = connection.prepareStatement(findWebexIdSql)) {
            findWebexIdStmt.setString(1, userId);
            try (ResultSet webexIdResult = findWebexIdStmt.executeQuery()) {
                if (webexIdResult.next()) {
                    String webexId = webexIdResult.getString("webex_id");
                    String roomId = findOrCreateRoom("Ecostic Bin Recycling Room", webexId);
                    if (roomId != null) {
                        String message = String.format("🌍 Ecostic Bin\n--------------------------------\n사용자 %s: 날짜 %s, 플라스틱: %d, 캔: %d, 유리: %d", userId, date, plasticCount, canCount, glassCount);
                        sendMessageToRoom(roomId, message, webexId);
                    }
                }
            }
        }
    }

    private void sendMessageToRoom(String roomId, String message, String accessToken) {
        String url = "https://webexapis.com/v1/messages";
        try {
            URL urlObj = new URL(url);
            HttpURLConnection conn = (HttpURLConnection) urlObj.openConnection();
            conn.setRequestMethod("POST");
            conn.setRequestProperty("Authorization", "Bearer " + accessToken);
            conn.setRequestProperty("Content-Type", "application/json");
            conn.setDoOutput(true);

            ObjectMapper objectMapper = new ObjectMapper();
            JsonNode jsonParam = objectMapper.createObjectNode();
            ((com.fasterxml.jackson.databind.node.ObjectNode) jsonParam).put("roomId", roomId);
            ((com.fasterxml.jackson.databind.node.ObjectNode) jsonParam).put("text", message);

            OutputStream os = conn.getOutputStream();
            os.write(jsonParam.toString().getBytes("UTF-8"));
            os.close();

            int responseCode = conn.getResponseCode();
            if (responseCode == HttpURLConnection.HTTP_CREATED) {
                System.out.println("메시지가 성공적으로 전송되었습니다.");
            } else {
                System.out.println("메시지 전송에 실패했습니다. 응답 코드: " + responseCode);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }


	private String findOrCreateRoom(String roomTitle, String accessToken) {
        String url = "https://webexapis.com/v1/rooms";
        try {
            URL urlObj = new URL(url);
            HttpURLConnection conn = (HttpURLConnection) urlObj.openConnection();
            conn.setRequestMethod("GET");
            conn.setRequestProperty("Authorization", "Bearer " + accessToken);
            conn.setRequestProperty("Content-Type", "application/json");
    
            BufferedReader in = new BufferedReader(new InputStreamReader(conn.getInputStream()));
            String inputLine;
            StringBuffer response = new StringBuffer();
            while ((inputLine = in.readLine()) != null) {
                response.append(inputLine);
            }
            in.close();
            
            ObjectMapper objectMapper = new ObjectMapper();
            JsonNode jsonResponse = objectMapper.readTree(response.toString());
            JsonNode rooms = jsonResponse.get("items");
    
            for (JsonNode room : rooms) {
                if (room.get("title").asText().equals(roomTitle)) {
                    return room.get("id").asText();
                }
            }
            return createRoom(roomTitle, accessToken); // 이 함수는 아래에 정의되어야 합니다.
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    private String createRoom(String roomTitle, String accessToken) {
        String url = "https://webexapis.com/v1/rooms";
        try {
            URL urlObj = new URL(url);
            HttpURLConnection conn = (HttpURLConnection) urlObj.openConnection();
            conn.setRequestMethod("POST");
            conn.setRequestProperty("Authorization", "Bearer " + accessToken);
            conn.setRequestProperty("Content-Type", "application/json");
            conn.setDoOutput(true);
    
            ObjectMapper objectMapper = new ObjectMapper();
            JsonNode jsonParam = objectMapper.createObjectNode();
            ((com.fasterxml.jackson.databind.node.ObjectNode) jsonParam).put("title", roomTitle);
    
            OutputStream os = conn.getOutputStream();
            os.write(jsonParam.toString().getBytes("UTF-8"));
            os.close();
    
            BufferedReader in = new BufferedReader(new InputStreamReader(conn.getInputStream()));
            String inputLine;
            StringBuffer response = new StringBuffer();
            while ((inputLine = in.readLine()) != null) {
                response.append(inputLine);
            }
            in.close();
            
            ObjectMapper responseMapper = new ObjectMapper();
            JsonNode jsonResponse = responseMapper.readTree(response.toString());
            return jsonResponse.get("id").asText();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
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

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}
