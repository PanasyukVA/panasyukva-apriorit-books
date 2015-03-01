<!--#include file="adovbs.inc"-->

<%
dim connStr, objNetwork
Set objNetwork = CreateObject("WScript.Network") 

If objNetwork.computername = "PANASYUKVA-PC" Then
    connStr = "Data source=PANASYUKVA-PC;initial catalog=SelfEducation;integrated security=SSPI"
Else
    connStr = "Data Source=CMS_SQLSRV2012\DEV;Initial Catalog=SelfEducation;User ID=aGSAlogin2011;Password=Agemni_18"
End If

Set objNetwork = nothing
%>