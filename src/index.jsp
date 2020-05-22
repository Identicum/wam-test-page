<%@page import="java.util.Base64"%>
<%@page import="java.util.Collections"%>
<%@page import="java.util.Enumeration"%>
<%@page import="java.util.List"%>
<%
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
						<a class="nav-link" id="v-pills-basic-tab" data-toggle="pill" href="#v-pills-basic" role="tab" aria-controls="v-pills-basic" aria-selected="false">Basic Auth</a>
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
									List<String> headerNames = Collections.list(request.getHeaderNames());
									Collections.sort(headerNames);
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
							String authorization = request.getHeader("Authorization");
							if (authorization == null)
							{
								%>
								<h5>No basic authentication header detected !</h5>
								<%
							}
							else
							{
								String credentials = authorization.substring(6).trim();
								byte[] decodedBytes = Base64.getDecoder().decode(credentials);
								String decodedString = new String(decodedBytes);
								String chunks[] = decodedString.split(":");
								%>
								<table class="table table-striped code-content">
									<thead>
										<tr>
											<th style="min-width: 300px">Header</th>
											<th>Value</th>
										</tr>
									</thead>
									<tbody>
										<tr>
											<td>Username</td>
											<td class="bold"><%= chunks[0] %></td>
										</tr>
										<tr>
											<td>Password</td>
											<td class="bold"><%= chunks[1] %></td>
										</tr>
									</tbody>
								</table>
								<%
							}
							%>
						</div>
						<%
							List<String> parameterNames = Collections.list(request.getParameterNames());
							Collections.sort(parameterNames);
						%>
						<div class="tab-pane fade" id="v-pills-http-post" role="tabpanel" aria-labelledby="v-pills-http-post-tab">
						<%
						if(request.getMethod().equals("POST") && !parameterNames.isEmpty())
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
										for(String parameterName:parameterNames)
										{
											%>
											<tr>
												<td><%= parameterName %></td>
												<td class="bold"><%= request.getParameter(parameterName) %></td>
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
							<h5>No post paramenters detected !</h5>
							<%
						}
						%>
						</div>
						<div class="tab-pane fade" id="v-pills-http-get" role="tabpanel" aria-labelledby="v-pills-http-get-tab">
						<%
						if(request.getMethod().equals("GET") && !parameterNames.isEmpty())
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
										for(String parameterName:parameterNames)
										{
											%>
											<tr>
												<td><%= parameterName %></td>
												<td class="bold"><%= request.getParameter(parameterName) %></td>
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
							<h5>No post paramenters detected !</h5>
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
