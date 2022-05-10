<%@ page language="java" contentType="application/json; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.HashMap"%>
<%@ page import="java.io.BufferedReader"%>
<%@ page import="com.google.gson.Gson"%>
<%@ page import="com.google.gson.reflect.TypeToken"%>
<%@ page import="com.google.gson.JsonSyntaxException"%>
<%@ page import="com.project.backend.*"%>


<%
// create gson object (for JSON)
Gson gson = new Gson();

// create a Dictionary of data ($d)
HashMap<String, Object> d = new HashMap<String, Object>();

// create a Dictionary of response content ($rc)
HashMap<String, Object> rc = new HashMap<String, Object>();
rc.put("ok", false);

// define logic control variables
boolean validate = false;
boolean execute = false;


// check whether request method is 'POST'
if (request.getMethod().equals("POST")) {
	
	// check existence of Content-Type header
	if (request.getContentType() != null) {
		
		// check whether Content-Type is 'application/json'
		if (request.getContentType().equals("application/json")) {
			
			// read raw data from the request body
			BufferedReader br = request.getReader();
			String reqBody = br.readLine();
			br.close();
			
			// check whether request body is not null 
			if (reqBody != null) {
				boolean JSONError;
				
				// try JSON parsing request body and convert into Dictionary $d 
				try {
					d = gson.fromJson(reqBody, new TypeToken<HashMap<String, Object>>() {}.getType());
					JSONError = false;
				} catch (JsonSyntaxException e) {
					JSONError = true;
				}
				
				// check whether there are no error in JSON parsing
				if (!JSONError) {
					// perform parameter validation
					validate = true;
				} else {
					rc.put("error_code", 400);
					rc.put("description", "Bad Request: Bad POST Request: Can't parse JSON object");
				}
			} else {
				rc.put("error_code", 400);
				rc.put("description", "Bad Request: Bad POST Request: Content is empty");
			}
		} else {
			rc.put("error_code", 400);
			rc.put("description", "Bad Request: Bad POST Request: Unsupported content-type");
		}
	} else {
		rc.put("error_code", 400);
		rc.put("description", "Bad Request: Bad POST Request: Undefined content-type");
	}
} else {
	rc.put("error_code", 405);
	rc.put("description", "Method Not Allowed: No POST request was received");
}


//parameter validation
if (validate) {
	
	// check session for admin
	if (session.getAttribute("user_id") != null && session.getAttribute("user_type").equals("admin")) {
		
		// validate parameter 'old_student_id'
		if (d.containsKey("old_student_id")) {
			if (!d.get("old_student_id").equals("")) {
				if (((String) d.get("old_student_id")).length() <= 8) {
					
					// validate parameter 'student_id'
					if (d.containsKey("student_id")) {
						if (!d.get("student_id").equals("")) {
							if (((String) d.get("student_id")).length() <= 8) {
								
								// validate parameter 'student_name'
								if (d.containsKey("student_name")) {
									if (!d.get("student_name").equals("")) {
										if (((String) d.get("student_name")).length() <= 50) {
											// permit execution
											execute = true;
										} else {
											rc.put("error_code", 400);
											rc.put("description", "Bad Request: 'student_name' length can't be more than 50");
										}
									} else {
										rc.put("error_code", 400);
										rc.put("description", "Bad Request: 'student_name' can't be empty");
									}
								} else {
									rc.put("error_code", 400);
									rc.put("description", "Bad Request: Parameter 'student_name' is required");
								}
							} else {
								rc.put("error_code", 400);
								rc.put("description", "Bad Request: 'student_id' length can't be more than 8");
							}
						} else {
							rc.put("error_code", 400);
							rc.put("description", "Bad Request: 'student_id' can't be empty");
						}
					} else {
						rc.put("error_code", 400);
						rc.put("description", "Bad Request: Parameter 'student_id' is required");
					}
				} else {
					rc.put("error_code", 400);
					rc.put("description", "Bad Request: 'old_student_id' length can't be more than 8");
				}
			} else {
				rc.put("error_code", 400);
				rc.put("description", "Bad Request: 'old_student_id' can't be empty");
			}
		} else {
			rc.put("error_code", 400);
			rc.put("description", "Bad Request: Parameter 'old_student_id' is required");
		}
	} else {
		rc.put("redirect", "index.jsp");
		rc.put("error_code", 401);
		rc.put("description", "Unauthorized: Session not found or invalid session");
	}
}


// execution
if (execute) {
	Admin adminUser = new Admin();
	Student student = adminUser.getStudent((String) d.get("old_student_id"));
	
	if (student != null) {
		boolean ok = adminUser.updateStudent((String) d.get("old_student_id"), ((String) d.get("student_id")).toUpperCase(),
				(String) d.get("student_name"), ((String) d.get("student_id")).toLowerCase() + "@siswa.uthm.edu.my",
				Integer.parseUnsignedInt((String) session.getAttribute("user_id")));
		
		if (ok) {
			rc.put("ok", true);
		} else {
			rc.put("error_code", 500);
			rc.put("description", "Internal Server Error: Database Error");
		}
	} else {
		rc.put("error_code", 400);
		rc.put("message", "The student doesn't exist.");
		rc.put("description", "Bad Request: The student doesn't exist");
	}
}


// check unknown error
if ((boolean) rc.get("ok") == false && rc.get("description") == null) {
	rc.put("error_code", 500);
	rc.put("description", "Internal Server Error: Unknown error found");
}


// echo JSON string of response content ($rc) 
out.println(gson.toJson(rc));
%>