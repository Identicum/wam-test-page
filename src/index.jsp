<%@ page language="java" session="true" isThreadSafe="true" contentType="text/html; charset=utf-8" %>

<%@ page import="sun.misc.BASE64Decoder"%>

<%
String authorization = null;
String credentials   = null;
String username      = null;
String password      = null;
String userpass      = null;
try
{
authorization = request.getHeader("Authorization");
//out.println("authorization: " + authorization + "<br/>");
if (authorization != null)
{
credentials = authorization.substring(6).trim();
}
//out.println("credentials: " + credentials + "<br/>");
BASE64Decoder decoder = new BASE64Decoder();
if (credentials != null)
{
userpass = new String(decoder.decodeBuffer(credentials));
}
//out.println("userpass: " + userpass + "<br/>");
int i = userpass.indexOf(":");
if (i > 0)
{
username = userpass.substring(0, i);
password = userpass.substring(i + 1);
}
String originIP = null;
String forwardedIP = null;
originIP = request.getRemoteAddr();
forwardedIP = request.getHeader("X-Forwarded-For");

}catch(Exception e)
{
username="(NULL)";
password="(NULL)";
}

 String headerParameteres = "";
 java.util.Enumeration names = request.getHeaderNames();

 while (names.hasMoreElements())
 {
	String name = (String)names.nextElement();
	headerParameteres += name.toUpperCase() + " = <B>" + request.getHeader(name) + "</B><BR/>";
  }

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

 String parameteres = "";
 java.util.Enumeration parametersNames = request.getParameterNames();
 while (parametersNames.hasMoreElements())
 {
	String name = (String)parametersNames.nextElement();
	parameteres += name.toUpperCase() + " = <B>" + request.getParameter(name) + "</B><BR/>";
  }

 %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<head>
	<title> Identicum </title>
	<link href="identicum.css" rel="stylesheet" type="text/css"/>
</head>

<body style="margin: 0px">
	<table cellpadding="0" cellspacing="0" width="100%" height="100%">
		<tr>
			<td class="bggris01"><img src="pix.gif"/></td>
			<td width="4"><img src="pix.gif" width="4"/></td>
			<td width="745" class="bggris02" valign="bottom">
				<table cellpadding="4" cellspacing="0" width="100%" class="templateFntSubmenu2">
					<tr class="templateFntSubmenu2">
						<td height="48" width="220" align="left" valign="center">
							<img src="logo.gif" border="0" />
						</td>
					</tr>
				</table>
			</td>
			<td width="4"><img src="pix.gif" width="4"/></td>
			<td class="bggris01"><img src="pix.gif"/></td>
		</tr>
		<tr height="4">
			<td colspan="5"><img src="pix.gif"/></td>
		</tr>
		<tr>
			<td class="bggris02"><img src="pix.gif"/></td>
			<td><img src="pix.gif"/></td>
			<td>
				<TABLE width="100%" height="100%" align="center" border="0" bordercolor="red">
					<TR class="globalFntBoxTitle color03">
						<TD align="center"><br>Web Access Management Test Page - JSP</br></TD>
					</TR>
					<TR>
						<TD align="left">
							<TABLE border="0" bordercolor="green">
								<TR class="globalFntBoxTitle color03">
									<TD>HTTP Header</TD>
								</TR>
								<TR>
									<TD class="templateFntSubmenu2">
									<%
									   out.println(headerParameteres);
									   for(int i=0; i<otherParameters.length; i++) {
									      String name = otherParameters[i][0];
									      String value = otherParameters[i][1];
									      if (value == null)
										        value = "<I>Not specified</I>";

									      out.println(name + " = <B>" + value + "</B><BR/>");
										}
									%>
									</TD>
								</TR>
								<TR class="globalFntBoxTitle color03">
									<TD>HTTP Header Auth (BASIC)</TD>
								</TR>
								<TR>
									<TD class="templateFntSubmenu2">Username:<B><%=username %></B></TD>
								</TR>
								<TR>
									<TD class="templateFntSubmenu2">Password: <B><%=password %></B></TD>
								</TR>
								<TR>
									<TD height="5">&nbsp;</TD>
								</TR>
								<TR>
									<TD align="left">
										<TABLE border="0" bordercolor="green">
											<TR class="globalFntBoxTitle color03">
												<TD>HTML Form (POST)</TD>
											</TR>
											<TR>
												<TD class="templateFntSubmenu2">Parameters: <BR/>
													<B>
														<%
															if(request.getMethod().equals("POST")) out.println(parameteres);
														%>
													</B>
												</TD>
											</TR>
										</TABLE>
									</TD>
								</TR>
								<TR>
									<TD height="5">&nbsp;</TD>
								</TR>
								<TR>
									<TD align="left">
										<TABLE border="0" bordercolor="green">
											<TR class="globalFntBoxTitle color03">
												<TD>HTML Form (GET)</TD>
											</TR>
											<TR>
												<TD class="templateFntSubmenu2">Parameters: <BR/>
													<B>
													<%
														if(request.getMethod().equals("GET")) out.println(parameteres);
													%>
													</B>
												</TD>
											</TR>
										</TABLE>
									</TD>
								</TR>
							</TABLE>
						</TD>
					</TR>
				</TABLE>
			</td>
			<td><img src="pix.gif"/></td>
			<td class="bggris02"><img src="pix.gif"/></td>
		</tr>
		<tr height="4">
			<td><img src="pix.gif"/></td>
			<td><img src="pix.gif"/></td>
			<td><img src="pix.gif"/></td>
			<td><img src="pix.gif"/></td>
			<td><img src="pix.gif"/></td>
		</tr>
		<tr>
			<td class="bggris01"><img src="pix.gif"/></td>
			<td width="4"><img src="pix.gif" width="4"/></td>
			<td width="745" class="bggris02" valign="bottom"></td>
			<td width="4"><img src="pix.gif" width="4"/></td>
			<td class="bggris01"><img src="pix.gif"/></td>
		</tr>
	</table>
</body>
</html>
