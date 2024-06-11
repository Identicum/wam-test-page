<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Base64"%>
<%@page import="java.util.Collections"%>
<%@page import="java.util.Enumeration"%>
<%@page import="java.util.List"%>
<%
String responseType = request.getHeader("Accept");

List<String> headerNames = Collections.list(request.getHeaderNames());
Collections.sort(headerNames);

List<String> getParameters = new ArrayList<>();
if(request.getMethod().equals("GET")) {
	getParameters = Collections.list(request.getParameterNames());
	Collections.sort(getParameters);
}

List<String> postParameters = new ArrayList<>();
if(request.getMethod().equals("GET")) {
	postParameters = Collections.list(request.getParameterNames());
	Collections.sort(postParameters);
}

String authorizationHeader = request.getHeader("Authorization");

String[][] otherParameters =
			{ { "AUTH_TYPE", request.getAuthType() },
				{ "DOCUMENT_ROOT", getServletContext().getRealPath("/") },
				{ "PATH_INFO", request.getPathInfo() },
				{ "PATH_TRANSLATED", request.getPathTranslated() },
				{ "QUERY_STRING", request.getQueryString() },
				{ "REMOTE_ADDR", request.getRemoteAddr() },
				{ "REMOTE_HOST", request.getRemoteHost() },
				{ "REMOTE_USER", request.getRemoteUser() },
				{ "REQUEST_METHOD", request.getMethod() },
				{ "SCRIPT_NAME", request.getServletPath() },
				{ "SERVER_NAME", request.getServerName() },
				{ "SERVER_PORT", String.valueOf(request.getServerPort()) },
				{ "SERVER_PROTOCOL", request.getProtocol() },
				{ "SERVER_SOFTWARE", getServletContext().getServerInfo() } };

if (responseType != null && responseType.equals("application/json")) {
    response.setContentType("application/json");
    out.print("{");
    
    out.print("\"http_headers\": {");
    for (String headerName : headerNames) {
        out.print("\"" + headerName + "\": \"" + request.getHeader(headerName) + "\",");
    }
    out.print("},");
    
    out.print("\"get_parameters\": {");
    for (String getParameter : getParameters) {
        out.print("\"" + getParameter + "\": \"" + request.getParameter(getParameter) + "\",");
    }
    out.print("},");
    
    out.print("\"post_parameters\": {");
    for (String postParameter : postParameters) {
        out.print("\"" + postParameter + "\": \"" + request.getParameter(postParameter) + "\",");
    }
    out.print("},");
    
    out.print("\"authorization_header\": \"" + authorizationHeader + "\",");

    out.print("\"other_parameters\": {");
	for(int i=0; i<otherParameters.length; i++)
	{
		out.print(otherParameters[i][0]);
		out.print("=");
		out.print(otherParameters[i][1]);
		out.print(",");
	}
    out.print("},");

    out.print("}");
} else {
 %>
<!doctype html>
<html lang="en">
	<head>
		<!-- Required meta tags -->
		<meta charset="utf-8">
		<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
		<title> Identicum </title>
		<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css" />
		<style>
			 .code-content td {
					font-size: 0.9em;
			 }
			 .bold {
				font-weight: 600;
			 }
			 footer {
				bottom: 0;
				position: fixed;
				width: 100%;
				font-size: 14px;
			  line-height: 40px;
			  background-color: white;
			  opacity: 0.6;
			}

			footer a {
				color: #000;
			}
		</style>
	</head>

	<body>
		<nav class="navbar navbar-expand-lg navbar-light bg-light">
			<div class="container">
				<a class="navbar-brand" href="#">
					<img src="logo_identicum.png" height="40" alt="">
				</a>
				<ul class="nav navbar-nav navbar-logo mx-auto">
					<li class="nav-item">
						<a class="nav-link" href="#">WAM Test Page</a>
					</li>
				</ul>
			 </div>
		</nav>
		<div class="container" style="margin-top: 20px">
			<div class="row">
				<div class="col-3">
					<div class="nav flex-column nav-pills" id="v-pills-tab" role="tablist" aria-orientation="vertical">
						<a class="nav-link active" id="v-pills-page-context-tab" data-toggle="pill" href="#v-pills-page-context" role="tab" aria-controls="v-pills-page-context" aria-selected="true">Page Context</a>
						<a class="nav-link" id="v-pills-http-headers-tab" data-toggle="pill" href="#v-pills-http-headers" role="tab" aria-controls="v-pills-http-headers" aria-selected="true">Http Headers</a>
						<a class="nav-link" id="v-pills-basic-tab" data-toggle="pill" href="#v-pills-basic" role="tab" aria-controls="v-pills-basic" aria-selected="false">Auth Header</a>
						<a class="nav-link" id="v-pills-http-post-tab" data-toggle="pill" href="#v-pills-http-post" role="tab" aria-controls="v-pills-http-post" aria-selected="false">Post parameters</a>
						<a class="nav-link" id="v-pills-http-get-tab" data-toggle="pill" href="#v-pills-http-get" role="tab" aria-controls="v-pills-http-get" aria-selected="false">Get parameters</a>
					</div>
				</div>
				<div class="col-9">
					<div class="tab-content" id="v-pills-tabContent">
						<div class="tab-pane fade show active" id="v-pills-page-context" role="tabpanel" aria-labelledby="v-pills-page-context-tab">
							<table class="table table-striped code-content">
								<thead>
									<tr>
										<th style="min-width: 300px">Header</th>
										<th>Value</th>
									</tr>
								</thead>
								<tbody>
								<%
								for(int i=0; i<otherParameters.length; i++)
								{
									%>
									<tr>
										<td><%= otherParameters[i][0] %></td>
										<td class="bold"><%= otherParameters[i][1] %></td>
									</tr>
									<%
								}
								%>
								</tbody>
							</table>
						</div>
						<div class="tab-pane fade show" id="v-pills-http-headers" role="tabpanel" aria-labelledby="v-pills-http-headers-tab">
							<table class="table table-striped code-content">
								<thead>
									<tr>
										<th style="min-width: 300px">Header</th>
										<th>Value</th>
									</tr>
								</thead>
								<tbody>
								<%
									for(String headerName : headerNames)
									{
										%>
										<tr>
											<td><%= headerName.toUpperCase() %></td>
											<td class="bold" style="word-break: break-word;"><%= request.getHeader(headerName) %></td>
										</tr>
										<%
									}
									%>
								</tbody>
							</table>
						</div>
						<div class="tab-pane fade" id="v-pills-basic" role="tabpanel" aria-labelledby="v-pills-basic-tab">
							<%
							if (authorizationHeader == null)
							{
								%>
								<h5>No HTTP authorization header detected !</h5>
								<%
							}
							else
							{
								%>
									Header: <b><%= authorizationHeader %></b><br/>
								<%
								if (authorizationHeader.substring(0, 6).equals("Basic "))
								{
									String credentials = authorizationHeader.substring(6).trim();
									byte[] decodedBytes = Base64.getDecoder().decode(credentials);
									String decodedString = new String(decodedBytes);
									String chunks[] = decodedString.split(":");
									%>
									Type: <b>BASIC</b><br/>
									Username: <b><%= chunks[0] %></b><br/>
									Password: <b><%= chunks[1] %></b><br/>
									<%
								}
							}
							%>
						</div>
						<div class="tab-pane fade" id="v-pills-http-post" role="tabpanel" aria-labelledby="v-pills-http-post-tab">
						<%
						if(!postParameters.isEmpty())
						{
							%>
							<table class="table table-striped code-content">
									<thead>
										<tr>
											<th style="min-width: 300px">Parameter</th>
											<th>Value</th>
										</tr>
									</thead>
									<tbody>
										<%
										for(String postParameter:postParameters)
										{
											%>
											<tr>
												<td><%= postParameter %></td>
												<td class="bold"><%= request.getParameter(postParameter) %></td>
											</tr>
											<%
										}
										%>
									</tbody>
								</table>
							<%
						}
						else
						{
							%>
							<h5>No POST paramenters received!</h5>
							<%
						}
						%>
						</div>
						<div class="tab-pane fade" id="v-pills-http-get" role="tabpanel" aria-labelledby="v-pills-http-get-tab">
						<%
						if(!getParameters.isEmpty())
						{
							%>
							<table class="table table-striped code-content">
									<thead>
										<tr>
											<th style="min-width: 300px">Parameter</th>
											<th>Value</th>
										</tr>
									</thead>
									<tbody>
										<%
										for(String getParameter:getParameters)
										{
											%>
											<tr>
												<td><%= getParameter %></td>
												<td class="bold"><%= request.getParameter(getParameter) %></td>
											</tr>
											<%
										}
										%>
									</tbody>
								</table>
							<%
						}
						else
						{
							%>
							<h5>No GET paramenters received!</h5>
							<%
						}
						%>
						</div>
					</div>
				</div>
			</div>
		</div>
		<footer class="text-center">
			<a href="https://www.identicum.com">&copy; Identicum</a> |
			<a href="https://github.com/identicum/wam-test-page"><i class="fab fa-github"></i> Github</a>
		</footer>
		<script src="https://code.jquery.com/jquery-3.4.1.slim.min.js"></script>
		<script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.0/dist/umd/popper.min.js"></script>
		<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.min.js"></script>
	</body>
</html>
<%
}
%>
