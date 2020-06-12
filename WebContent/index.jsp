<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>index</title>
<style type="text/css">
	li{padding: 10px 2px;}
	.header,body{padding-bottom:20px}
	.header,.jumbotron{border-bottom:1px solid #e5e5e5}
	body{padding-top:20px}
	.footer,.header,.marketing{padding-right:15px;padding-left:15px}
	.header h3{margin-top:0;margin-bottom:0;line-height:40px}
	@media (min-width:768px){.container{max-width:730px}}.container-narrow>hr{margin:30px 0}.jumbotron{text-align:center}.jumbotron .btn{padding:14px 24px;font-size:21px}.marketing{margin:40px 0}.marketing p+h4{margin-top:28px}@media screen and (min-width:768px){.footer,.header,.marketing{padding-right:0;padding-left:0}.header{margin-bottom:30px}.jumbotron{border-bottom:0}}
</style>
<!-- Bootstrap -->
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u" crossorigin="anonymous">
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap-theme.min.css" integrity="sha384-rHyoN1iRsVXV4nD0JutlnGaslCJuC7uwjduW9SVrLvRYooPp2bWYgmgJQIXwl/Sp"  crossorigin="anonymous">
<!-- Naver SDK -->
<script src="https://code.jquery.com/jquery-1.12.1.min.js"></script>
<script type="text/javascript" src="https://static.nid.naver.com/js/naveridlogin_js_sdk_2.0.0.js" charset="utf-8"></script>
<!-- Google SDK -->
<script src="//ajax.googleapis.com/ajax/libs/jquery/1.8.2/jquery.min.js"></script>
<script src="https://apis.google.com/js/platform.js" async defer></script>
<script src="https://apis.google.com/js/platform.js?onload=init" async defer></script>
<!-- kakao SDK -->
<script src="js/kakao_1.39.0.js"></script>
<script type="text/javascript">
$(document).ready(function(){
	// Naver 초기화
	window.naverLogin = new naver.LoginWithNaverId({
			clientId: '${naverClientId}',
			callbackUrl: 'http://127.0.0.1:8000/index.jsp',
			isPopup: false,
		}
	);
	naverLogin.init();
	
	// SNS 로그아웃
	$("#gnbLogin").click(function () {
		if($(this).text() == "Login" ){
			alert('SNS Login버튼을 클릭해주세요');
		}else{
			console.log('로그아웃!!');
			// TODO
 			if(naverLogin.user){
				naverLogin.logout();// Naver
				console.log('naver logout!!');
			}
			if( gauth.isSignedIn.get() ){
				gauth.signOut();// Google
				console.log('google logout!!');
			}
			if(Kakao.Auth.getAccessToken()){
				Kakao.Auth.logout();// Kakao
				console.log('kakao logout!!');
			}
			
			// css 변경
			getLoginChangeCss(false);
			$(".container p").remove();
		}
	});
}); // ready
	
	/* ********** Kakao Login ********** */
	
	// kakao 로그인
	Kakao.init('${kakaoClientId}');
	
	// kakao SDK 초기화 유무
	//console.log('kakao 초기화 유무 ::: '+ Kakao.isInitialized());

	// kakao 로그인 호출
	function checkLoginKakao() {
		Kakao.Auth.login({
			success : function(authObj) {
				getKakaoUserProfile();
			},
			fail : function(err) {
				console.log("kakaoOauth fail");
			}
		});
	}

	// kakao 사용자 정보
	function getKakaoUserProfile() {
		Kakao.API.request({
			url : '/v2/user/me',
			success : function(res) {
				//alert(JSON.stringify(res));
				var kakaoName = res.properties.nickname;
				if (typeof kakaoName == 'undefined') {
					kakaoName = "";
				}
				$("#userName").append('<li style="color:blue;">' + kakaoName + '님 반갑습니다.</li>');
				getLoginChangeCss(true);
			},
			fail : function(error) {
				alert("인증실패: " + JSON.stringify(error));
				getLoginChangeCss(false);
			}
		});
	}
	/* ********** Naver Login ********** */
	
	// Naver 로그인 호출
	function checkLoginNaver(){
		naverLogin();
	}
		
	// Naver 현재 로그인 상태를 확인
	window.addEventListener('load', function () {
		naverLogin.getLoginStatus(function (status) {
			getNaverUserProfile(status);
		});
	});

	// Naver 사용자 정보 출력
	function getNaverUserProfile(status) {
		if(status){
			//console.log('naverLogin.user :: '+naverLogin.user);
			var name = naverLogin.user.name;
			$("#userName").append('<li style="color:blue;">' + name + '님 반갑습니다.</li>');
			getLoginChangeCss(true);
		}else{
			getLoginChangeCss(false);
		}
	}
	
	/* ********** Google Login ********** */
	
	// Google 초기화
	function init() {
		gapi.load('auth2', function() {
	    	window.gauth = gapi.auth2.init({
	    		client_id: '${googleClientId}'
	    	});
	    console.log('gauth.then :: ' + gauth.isSignedIn.get() );
	   	gauth.then(function(){
		    		getGoogleUserProfile();
	    			}
				,function(){
					console.log('googleOauth fail');
		    	}
			);
		});
	}
	
	// Google 로그인
	function checkLoginGoogle() {
		gauth.signIn().then(function() {
			console.log('gauth.signIn()');
			getGoogleUserProfile();
		});
	}
	
	// 사용자 정보 출력
 	function getGoogleUserProfile(){
    	if(gauth.isSignedIn.get()){
    		var profile = gauth.currentUser.get().getBasicProfile();
			$("#userName").append('<li style="color:blue;">' + profile.getName() + '님 반갑습니다.</li>');
			getLoginChangeCss(true);
    	}else{
    		getLoginChangeCss(false);
    	}
	}
	
	// 로그인 상태에 따른 css
	function getLoginChangeCss(status){
		if(status){
			$("#gnbLogin").text("Logout");
			$(".jumbotron").css("display","none");
			$(".container").append("<p>SNS 로그인 성공</p>");
		}else{
    		$("#userName li:last").remove();
    		$("#gnbLogin").text("Login");
    		$(".jumbotron").css("display","block");
		} 
	}
</script>
</head>
<body>
	<div class="header clearfix">
		<h3 class="text-muted">SNS Login</h3>
		<nav>
			<ul class="nav nav-pills pull-left">
				<li><a href="#">Home</a></li>
				<li><a id="gnbLogin" href="#">Login</a></li>
				<li id="userName"></li>
			</ul>
		</nav>
	</div>

	<div class="container">
		<div class="jumbotron _Login">
			<p>
				<h2>clientID</h2><br/>
				네이버: ${naverClientId} <br/>
				구굴: ${googleClientId} <br/>
				카카오: ${kakaoClientId} <br/>
				
				<h2>개발자 등록 참고</h2><br/>
				naver: http://127.0.0.1:8000 <br/>
				google:http://localhost:8000 <br/>
				kakao: http://localhost:8000 <br/>
			</p>
			<!-- Naver -->
			<div id="naverIdLogin"><a href="javascript:checkLoginNaver();" id="naverIdLogin_loginButton" role="button"><img src="/img/btn_login_naver.png" width="277px" height="60px"></a></div><br/>
			<!-- Google -->
			<div id="googleIdLogin"><a href="javascript:checkLoginGoogle();" id="googleLoginBtn" role="button"><img src="/img/btn_login_google.png" width="277px" height="60px"></a></div><br/>
			<!-- kakao -->
			<div id="kakaoIdLogin"><a href="javascript:checkLoginKakao();" id="kakaoLoginBtn" role="button"><img src="/img/btn_login_kakao.png" width="277px" height="60px"></a></div><br/>
			
		</div>
	</div>
</body>
</html>