<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="checkSessionStudent.jsp"%>


<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Task Submission</title>
<script type="text/javascript">
	function $e(id) {
		var element = document.getElementById(id);
		return element;
	}
	
	function XHRequest(APIMethod, jsonString, {async = true, callback = null, nextCall = null} = {}) {
		var xhttp = new XMLHttpRequest();
		xhttp.open("POST", "api/" + APIMethod + ".jsp", async);
		xhttp.setRequestHeader("Content-Type", "application/json");
	
		xhttp.onreadystatechange = function() {
			if (this.readyState === 4) {
				switch (this.status) {
					case 200:
						var rc = JSON.parse(this.responseText);
						
						if (rc["ok"] === true) {
							if (callback != null) window[callback](rc);
						} else {
							if ("redirect" in rc) {
								location.href = rc["redirect"];
							} else if ("message" in rc) {
								$e("span-message").innerHTML = rc["message"];
							} else {
								$e("span-message").innerHTML = "Error " + rc["error_code"] + ": " + rc["description"];
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
			
			if (nextCall != null) window[nextCall]();
		}
		
		xhttp.send(jsonString);
	}
	
	function logout() {
		XHRequest("logout", JSON.stringify({}), {async: false});
		location.href = "index.jsp";
	}
	
	function loadUserInfo(rc = null) {
		if (rc == null) {
			XHRequest("getUserInfo", JSON.stringify({}), {callback: "loadUserInfo"});
		} else {
			$e("span-welcome-name").innerHTML = rc["name"];
		}
	}
	
	function getSubmission(rc = null) {
		if (rc == null) {
			var d = {};
			d["subject_id"] = "<% out.print(request.getParameter("subject_id")); %>";
			d["task_id"] = "<% out.print(request.getParameter("task_id")); %>";
			
			XHRequest("getSubmission", JSON.stringify(d), {callback: "getSubmission"});
		} else {
			$e("span-file").innerHTML = rc["file_name"];
		}
	}
	
	function add(files) {
		if (taskName != "") {
			if (files.length > 0) {
				var formData = new FormData();
				formData.append("subject_id", "<% out.print(request.getParameter("subject_id")); %>");
				formData.append("task_id", "<% out.print(request.getParameter("task_id")); %>");
				formData.append("file", files[0], files[0].name);
				
				XHRFormData("addSubmission", formData);
				loadTable();
			} else {
				$e("span-message").innerHTML = "Please select a file.";
				clearMessage();
			}
		} else {
			$e("span-message").innerHTML = "Please enter task name.";
			clearMessage();
		}
	}
	
	function clearTable() {
		var tBody = $e("list").tBodies[0];
		
		for (var i = tBody.rows.length; i > 0; i--) {
			tBody.deleteRow(0);
		}
	}
	
	var t;
	
	function clearMessage() {
		clearTimeout(t);
		t = setTimeout(function () {
			$e("span-message").innerHTML = null;
		}, 5000);
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

div.menu {
	margin: 10px 30px;
	padding: 10px;
}

div.container {
	border: 2px solid;
	border-radius: 10px;
	margin: 0px 30px;
	padding: 10px;
	min-height: 500px;
}

div.title {
	margin: 10px 0px;
	padding: 10px;
}

span.title {
	font-size: 20px;
}

div.info {
	margin: 10px 0px;
	padding: 10px;
}

div.message {
	margin: 10px 0px;
	padding: 10px;
	height: 20px;
}

span.message {
	color: red;
}

div.upload-area {
	margin: 10px 0px;
	padding: 10px;
}

label.upload-field {
	width: 240px;
	text-align: right;
	display: inline-block;
}

input[type=file] {
	border-radius: 5px;
	font-family: verdana;
	font-size: 16px;
	box-shadow: 0px 0px 2px 0px;
	cursor: pointer;
}

input[type=file]:hover {
	box-shadow: 0px 0px 0px 1px;
}

div.content {
	margin: 10px 0px;
	padding: 10px;
}

table {
	border: 1px solid #bfbfbf;
	border-collapse: collapse;
}

table tr {
	height: 25px;
}

table th {
	background-color: #efefef;
	text-align: left;
}

table th, table td {
	border: 1px solid #bfbfbf;
	padding: 5px 10px;
	max-width: 400px;
}

input[type=text], [type=password] {
	width: 150px;
	font-family: verdana;
	font-size: 16px;
}

input[type=text]:hover, [type=password]:hover {
	outline: 1px solid;
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
<body onload="loadUserInfo(); getSubmission();">
	<div class="welcome-text">
		Welcome, <span class="welcome-name" id="span-welcome-name">Guest</span> !
	</div>
	<hr>
	<div class="menu">
		<a href="student.jsp"><button>Home</button></a>
		<a href="registerSubject.jsp"><button>Register Subjects</button></a>
		<a href="subject.jsp"><button>View Subjects</button></a>
		<button onclick="logout();">Log Out</button>
	</div>
	<div class="container">
		<div class="title">
			<span class="title">Task Submission</span>
		</div>
		<div class="info">
			Subject ID: <span id="span-subject-id"></span>
			<br>
			Subject Name: <span id="span-subject-name"></span>
			<br>
			Assignment / Tutorial / Lab: <span id="span-task-name"></span>
			<br><br>
			File: <span id="span-file"></span> 
		</div>
		<div class="message">
			<span class="message" id="span-message"></span>
		</div>
		<div class="upload-area">
			<label class="upload-field" for="input-upload-file">Document:</label>
			<input type="file" id="input-upload-file">
			<button onclick="add($e('input-upload-file').files);">Upload</button>
		</div>
	</div>
</body>
</html>