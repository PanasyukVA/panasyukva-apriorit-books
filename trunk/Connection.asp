<!--#include virtual = "/Books/Constant.asp" -->

<%
dim connDB
set connDB = Server.CreateObject("ADODB.Connection")
connDB.Provider = "SQLOLEDB"
connDB.ConnectionString = connStr
connDB.open
%>