import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/data")
public class DataServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

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

        response.getWriter().append("OK");
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}
