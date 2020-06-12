package ex;

import java.io.FileReader;
import java.io.IOException;
import java.util.Properties;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/index.do")
public class HomeController extends HttpServlet {
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		// SNS client 관련 properties 읽기
		try{
			Properties prop = new Properties();
			String path = this.getClass().getResource("oauth.properties").getPath();
			prop.load(new FileReader(path));//파일 로딩
			
			request.setAttribute("naverClientId", prop.getProperty("naver.client_id"));
			request.setAttribute("googleClientId",prop.getProperty("google.client_id"));
			request.setAttribute("kakaoClientId", prop.getProperty("kakao.client_id"));
			
		} catch(Exception e){
			e.printStackTrace(); 
		}
		
		request.getRequestDispatcher("/index.jsp").forward(request, response);
	}
}
