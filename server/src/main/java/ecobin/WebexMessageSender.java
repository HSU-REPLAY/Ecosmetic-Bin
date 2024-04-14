package ecobin;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;

public class WebexMessageSender {

    public static void main(String[] args) {
        String userId = "tmddusyy1115@naver.com";
        int plasticCount = 10;
        int canCount = 5;
        int glassCount = 3;
        String accessToken = "OTZjNjBhOTctMGUwMy00ZjI0LTgxOTMtNmNlMTE2YjE1MmYwMDkzODcxZTEtMDQ3_P0A1_3110228f-f720-43ec-9b4d-e218298566dd";

        sendDataToWebex(userId, plasticCount, canCount, glassCount, accessToken);
    }

    // 방 찾기/생성 후 메시지 전송
    private static void sendDataToWebex(String userId, int plasticCount, int canCount, int glassCount, String accessToken) {
        String roomId = findOrCreateRoom("Ecostic Bin Recycling Room", accessToken);
        if (roomId != null) {
            String message = buildMessage(userId, plasticCount, canCount, glassCount);
            sendWebexMessage(roomId, message, accessToken);
        } else {
            System.out.println("Failed to find or create room.");
        }
    }

    // 메시지 생성
    private static String buildMessage(String userId, int plasticCount, int canCount, int glassCount) {
        return String.format(
                "🌍 Ecostic Bin\n" +
                        "--------------------------------\n" +
                        "사용자 %s님의 기록:\n" +
                        "플라스틱: %d개\n" +
                        "캔: %d개\n" +
                        "유리: %d개\n" +
                        "--------------------------------\n",
                userId, plasticCount, canCount, glassCount);
    }

    // Webex 메시지 전송
    private static void sendWebexMessage(String roomId, String message, String accessToken) {
        HttpURLConnection connection = null;
        try {
            URL url = new URL("https://webexapis.com/v1/messages");
            connection = (HttpURLConnection) url.openConnection();
            connection.setRequestMethod("POST");
            connection.setRequestProperty("Authorization", "Bearer " + accessToken);
            connection.setRequestProperty("Content-Type", "application/json");
            connection.setDoOutput(true);

            String jsonInputString = String.format("{\"roomId\": \"%s\", \"text\": \"%s\"}", roomId, message.replace("\n", "\\n").replace("\"", "\\\""));
            try (OutputStream os = connection.getOutputStream()) {
                os.write(jsonInputString.getBytes("UTF-8"));
            }

            int responseCode = connection.getResponseCode();
            if (responseCode == HttpURLConnection.HTTP_OK) {
                try (BufferedReader br = new BufferedReader(new InputStreamReader(connection.getInputStream(), "UTF-8"))) {
                    String line;
                    StringBuilder response = new StringBuilder();
                    while ((line = br.readLine()) != null) {
                        response.append(line.trim());
                    }
                    System.out.println("Message sent successfully: " + response);
                }
            } else {
                System.err.println("Failed to send message: HTTP error code: " + responseCode);
                readErrorResponse(connection);
            }
        } catch (Exception e) {
            System.err.println("Error sending message: " + e.getMessage());
            e.printStackTrace();
        } finally {
            if (connection != null) {
                connection.disconnect();
            }
        }
    }

    // 방 찾기 또는 생성
    private static String findOrCreateRoom(String roomTitle, String accessToken) {
        HttpURLConnection connection = null;
        try {
            URL url = new URL("https://webexapis.com/v1/rooms");
            connection = (HttpURLConnection) url.openConnection();
            connection.setRequestMethod("GET");
            connection.setRequestProperty("Authorization", "Bearer " + accessToken);
            connection.setRequestProperty("Content-Type", "application/json");

            try (BufferedReader in = new BufferedReader(new InputStreamReader(connection.getInputStream(), "UTF-8"))) {
                String line;
                StringBuilder response = new StringBuilder();
                while ((line = in.readLine()) != null) {
                    response.append(line.trim());
                }

                // 방 목록에서 특정 방 찾기
                String searchPattern = "\"title\":\"" + roomTitle + "\"";
                int titleIdx = response.indexOf(searchPattern);
                if (titleIdx != -1) {
                    int idStart = response.lastIndexOf("\"id\":\"", titleIdx) + 6;
                    int idEnd = response.indexOf("\"", idStart);
                    return response.substring(idStart, idEnd);
                }
            }

            // 방이 존재하지 않을 경우, 새로운 방 생성
            return createRoom(roomTitle, accessToken);

        } catch (Exception e) {
            System.err.println("Failed to find or create room: " + e.getMessage());
            e.printStackTrace();
            return null;
        } finally {
            if (connection != null) {
                connection.disconnect();
            }
        }
    }

    // 새로운 방 생성
    private static String createRoom(String roomTitle, String accessToken) {
        HttpURLConnection connection = null;
        try {
            URL url = new URL("https://webexapis.com/v1/rooms");
            connection = (HttpURLConnection) url.openConnection();
            connection.setRequestMethod("POST");
            connection.setRequestProperty("Authorization", "Bearer " + accessToken);
            connection.setRequestProperty("Content-Type", "application/json");
            connection.setDoOutput(true);

            String jsonBody = String.format("{\"title\": \"%s\"}", roomTitle);
            try (OutputStream os = connection.getOutputStream()) {
                os.write(jsonBody.getBytes("UTF-8"));
            }

            // 방 생성 응답 확인
            try (BufferedReader br = new BufferedReader(new InputStreamReader(connection.getInputStream(), "UTF-8"))) {
                String line;
                StringBuilder response = new StringBuilder();
                while ((line = br.readLine()) != null) {
                    response.append(line.trim());
                }

                int idStart = response.indexOf("\"id\":\"") + 6;
                int idEnd = response.indexOf("\"", idStart);
                return response.substring(idStart, idEnd);  // 새로 생성된 방의 ID 반환
            }

        } catch (Exception e) {
            System.err.println("Error creating room: " + e.getMessage());
            e.printStackTrace();
            return null;
        } finally {
            if (connection != null) {
                connection.disconnect();
            }
        }
    }

    // HTTP 에러 응답 읽기
    private static void readErrorResponse(HttpURLConnection connection) throws IOException {
        try (InputStream errorStream = connection.getErrorStream();
             BufferedReader br = new BufferedReader(new InputStreamReader(errorStream, "UTF-8"))) {
            String line;
            StringBuilder response = new StringBuilder();
            while ((line = br.readLine()) != null) {
                response.append(line.trim());
            }
            System.err.println("Error response from server: " + response);
        }
    }
}
