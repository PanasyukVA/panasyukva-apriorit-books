<!--#include file = "Constant.asp" -->

<%
    Set connDB = Server.CreateObject("ADODB.Connection")
    connDB.Provider = "SQLOLEDB"
    connDB.ConnectionString = connStr
    connDB.open
%>