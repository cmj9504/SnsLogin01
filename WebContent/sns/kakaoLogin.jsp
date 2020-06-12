<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8"/>
<!-- kakao SDK -->
<script src="https://code.jquery.com/jquery-1.12.1.min.js"></script>
<script src="js/kakao_1.39.0.js"></script>
<script type="text/javascript">
	$(document).ready(function(){
		Kakao.init('');// client_id
		
		$("#kakaoLoginBtn").click(function(){
		});
		
		// 카카오 로그인 버튼을 생성합니다.
		Kakao.Auth.createLoginButton({
			container : '#kakao-login-btn',

			success : function(authObj) {

				// 로그인 성공시, 사용자 정보 출력
				Kakao.API.request({
					url : '/v2/user/me',
					success : function(res) {
						//alert(JSON.stringify(res));
						var userID = res.id; //유저의 카카오톡 고유 id
						var userNickName = res.properties.nickname; //유저가 등록한 별명
						console.log(userID);
						console.log(userNickName);
						
						$("#result").append("<p>"+userNickName+"님 환영합니다.</p>");
					},
					fail : function(error) {
						alert(JSON.stringify(error));
					}
				});
			},
			fail : function(err) {
				alert(JSON.stringify(err));
			}
		});
		
	})
</script>
</head>
<body>
	<a id="kakao-login-btn"></a>
	<div id="kakaoIdLogin"><a  href="#"  id="kakaoLoginBtn" role="button"><img src="/img/btn_login_kakao.png" width="277px" height="60px"></a></div>
	
	<div id="result"></div>
</body>
</html>