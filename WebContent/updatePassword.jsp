<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>


<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Update Password</title>
<script type="text/javascript">
	function $e(id) {
		var element = document.getElementById(id);
		return element;
	}
	
	function XHRequest(method, jsonString) {
		var xhttp = new XMLHttpRequest();
		xhttp.open("POST", "api/" + method + ".jsp", true);
		xhttp.setRequestHeader("Content-Type", "application/json");
		xhttp.send(jsonString);
	
		xhttp.onreadystatechange = function() {
			if (this.readyState === 4) {
				switch (this.status) {
					case 200:
						var r = JSON.parse(this.responseText);
						
						if (r["ok"] === true) {
							// ?
						} else {
							if ("message" in r) {
								$e("span-message").innerHTML = r["message"];
							} else {
								$e("span-message").innerHTML = "Error " + r["error_code"] + ": " + r["description"];
							}
						}
						
						break;
					case 404:
						alert("Requested server file not found. Error code: " + this.status);
						break;
					default:
						alert("Request failed. " + this.statusText + "Error Code: " + this.status);
				}
			}
		}
	}
	
	function updatePassword() {
		var d = {};
		d["npassword"] = $e("input-npassword").value;
		d["cpassword"] = $e("input-cpassword").value;
		
		if (d["npassword"] != "") {
			if (d["cpassword"] != "") {
				XHRequest("updatePassword", JSON.stringify(d));
			} else {
				$e("span-message").innerHTML = "Please confirm password.";
				setTimeout(clearMessage, 5000);
			}
		} else {
			$e("span-message").innerHTML = "Please enter new password.";
			setTimeout(clearMessage, 5000);
		}
	}
	
	function clearMessage() {
		$e("span-message").innerHTML = null;
	}
</script>
<style type="text/css">
body {
	font-family: verdana;
	font-size: 16px;
}

div.welcome-text {
	margin: 30px;
}

span.welcome-name {
	font-weight: bold;
}

div.container {
	border: 2px solid;
	border-radius: 10px;
	margin: 50px auto 0px;
	padding: 10px;
	width: 400px;
}

div.title {
	margin: 10px 0px;
	padding: 10px;
	text-align: center;
}

span.title {
	font-size: 30px;
}

div.message {
	margin: 10px 0px;
	height: 20px;
 	text-align: center;
}

span.message {
	color: red;
}

div.form {
	margin: 10px 0px;
	padding: 10px;
	height: 200px;
	position: relative;
}

div.form-field {
	margin: 10px 0px;
}

label.form-field {
	width: 160px;
	text-align: right;
	display: inline-block;
}

input[type=text], [type=password] {
	width: 150px;
	font-family: verdana;
	font-size: 16px;
}

input[type=text]:hover, [type=password]:hover {
	outline: 1px solid;
}

div.show-password {
	background-image: url("img/hide-password.png");
	background-size: cover;
	margin-right: 20px;
	height: 23px;
	width: 23px;
	display: none;
	float: right;
	cursor: pointer;
}

div.show-password:active {
	background-image: url("img/show-password.png");
}

div.button {
	margin: 10px 0px;
	text-align: center;
	display: block;
	position: absolute;
	left: 0px;
	right: 0px;
	bottom: 0px;
}

button {
	border-radius: 5px;
	font-family: verdana;
	font-size: 16px;
	box-shadow: 1px 1px 1px 0px;
	cursor: pointer;
}

button:hover {
	box-shadow: 0px 0px 1px 0px;
}
</style>
</head>
<body>
	<div class="welcome-text">
		Welcome, <span class="welcome-name" id="span-welcome-name">Guest</span> !
	</div>
	<hr>
	<div class="container">
		<div class="title">
			<span class="title">Update Password</span>
		</div>
		<div class="message">
			<span class="message" id="span-message"></span>
		</div>
		<div class="form">
			<form>
				<div class="form-field" onmouseover="$e('icon-npassword').style.display = 'block';" onmouseleave="$e('icon-npassword').style.display = 'none';">
					<label class="form-field" for="input-npassword">New Password:</label>
					<input type="password" id="input-npassword" name="password">
					<div class="show-password" id="icon-npassword" onmousedown="$e('input-npassword').type = 'text';" onmouseup="$e('input-npassword').type = 'password';"></div>
				</div>
				<div class="form-field" onmouseover="$e('icon-cpassword').style.display = 'block';" onmouseleave="$e('icon-cpassword').style.display = 'none';">
					<label class="form-field" for="input-cpassword">Confirm Password:</label>
					<input type="password" id="input-cpassword" name="cpassword">
					<div class="show-password" id="icon-cpassword" onmousedown="$e('input-cpassword').type = 'text';" onmouseup="$e('input-cpassword').type = 'password';"></div>
				</div>
			</form>
			<div class="button">
				<button onclick="updatePassword();">Submit</button>
				<button onclick="">Skip</button>
			</div>
		</div>
	</div>
</body>
</html>