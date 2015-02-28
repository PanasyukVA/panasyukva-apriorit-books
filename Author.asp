<!--#include virtual="/Books/Connection.asp" -->

<%
    AuthorID = 0

    If IsNumeric(Request("ID")) Then
        AuthorID = CInt(Request("ID"))
    ElseIf IsNumeric(Request.Form("AuthorID")) Then
        AuthorID = CInt(Request.Form("AuthorID"))
    End If

    AuthorName = ""
    If Request("Name") <> "" Then
        AuthorName = CStr(Request("Name"))
    ElseIf Request.Form("AuthorName") <> "" Then
        AuthorName = CStr(Request.Form("AuthorName"))
    End If

    If Request.Form("AuthorName") <> "" Then
        Dim  spAuthorEdit
                     
        Set spAuthorEdit = Server.CreateObject("ADODB.command")
        spAuthorEdit.ActiveConnection = connDB
        spAuthorEdit.CommandType = 4
        spAuthorEdit.CommandText = "spAuthorEdit"
        spAuthorEdit.Parameters.Append spAuthorEdit.CreateParameter("@ID", 3, 3, , AuthorID)
        spAuthorEdit.Parameters.Append spAuthorEdit.CreateParameter("@Name", 200, 1, 150, AuthorName)
        spAuthorEdit.Execute
        If IsNumeric(spAuthorEdit.Parameters("@ID").Value) Then 
            AuthorID = CInt(spAuthorEdit.Parameters("@ID").Value)
        End If
        Set spAuthorEdit = nothing 
    End If
 %>

<!DOCTYPE html>
<html>
<head>
	<title>Athor</title>
</head>
<body>
    <form method="post" action="Author.asp">
        <table style="background-color:#b0c4de;width:30%">
            <tr>
                <td style="width:20%">
                    <label for="AuthorName">Name: </label>
                </td>
                <td style="text-align:left;width:80%">
                    <input name="AuthorName" type="text" style="width:99%" value="<%=AuthorName%>" required/>
                    <input name="AuthorID" type="hidden" value="<%=AuthorID%>" />
                </td>
            </tr>
            <tr>
                <td style="width:20%">
                    <label for="AuthorBooks">Names of books: </label>
                </td>
                <td style="text-align:left;width:80%">
                    <input readonly style="width:100%"  value="<%
                        If AuthorID <> 0 Then
                            Dim  spBookGetList, rsBookGetList
                             
                            Set spBookGetList = Server.CreateObject("ADODB.command")
                            spBookGetList.ActiveConnection = connDB
                            spBookGetList.CommandType = 4
                            spBookGetList.CommandText = "spBookGetList"
                            spBookGetList.Parameters.Append spBookGetList.CreateParameter("@AuthorID", 3, 1, , AuthorID)    

                            Set rsBookGetList = spBookGetList.Execute

                            do until rsBookGetList.EOF
                                Response.Write rsBookGetList.Fields.Item("Name") & ", "
                                rsBookGetList.MoveNext
                            loop

                            Set spBookGetList = nothing 
                            Set rsBookGetList = nothing
                        End If
                        %>" />
                </td>
            </tr>
        </table>
        <br />
        <div>
            <input type="submit" value="Add/Edit" /><br />
            <a href="Books.asp">Books</a>
        </div>
    </form>
</body>
</html>