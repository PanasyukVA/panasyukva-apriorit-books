<!--#include file="Connection.asp" -->

<%
    Dim AuthorID, AuthorName

    If Len(Request("Name")) <> 0 Then
        AuthorID = CInt(Request("ID"))
        AuthorName = CStr(Request("Name"))
    ElseIf Len(Request.Form("AuthorName")) <> 0 Then
        If Len(Request.Form("AuthorID")) <> 0 Then
            AuthorID = CInt(Request.Form("AuthorID"))
        End If
        AuthorName = CStr(Request.Form("AuthorName"))
    End If

    If Len(Request.Form("AuthorName")) <> 0 Then
        Set spAuthorEdit = Server.CreateObject("ADODB.command")
        spAuthorEdit.ActiveConnection = connDB
        spAuthorEdit.CommandType = adCmdStoredProc
        spAuthorEdit.CommandText = "spAuthorEdit"
        spAuthorEdit.Parameters.Append spAuthorEdit.CreateParameter("@ID", adInteger, adParamInputOutput, , AuthorID)
        spAuthorEdit.Parameters.Append spAuthorEdit.CreateParameter("@Name", adVarChar, adParamInput, 150, AuthorName)
        spAuthorEdit.Execute
        
        AuthorID = CInt(spAuthorEdit.Parameters("@ID").Value)
        Set spAuthorEdit = nothing 
    End If
 %>

<!DOCTYPE html>
<html>
<head>
	<title>Athor</title>
    <link href="Style/Books.css" rel="stylesheet" />
</head>
<body>
    <form method="post" action="Author.asp">
        <table class="AuthorTable">
            <tr>
                <td>
                    <label for="AuthorName">Name: </label>
                </td>
                <td>
                    <input name="AuthorName" type="text" value="<%=AuthorName%>" required placeholder="Please, enter the author's name" />
                    <input name="AuthorID" type="hidden" value="<%=AuthorID%>" />
                </td>
            </tr>
            <tr>
                <td>
                    <label for="AuthorBooks">Names of books: </label>
                </td>
                <td>
                    <input readonly="readonly" placeholder="This author didn't write books" value="<%
                        If Not IsEmpty(AuthorID) Then
                            Dim  spBookGetList, rsBookGetList
                             
                            Set spBookGetList = Server.CreateObject("ADODB.command")
                            spBookGetList.ActiveConnection = connDB
                            spBookGetList.CommandType = adCmdStoredProc
                            spBookGetList.CommandText = "spBookGetList"
                            spBookGetList.Parameters.Append spBookGetList.CreateParameter("@AuthorID", adInteger, adParamInput, , AuthorID)    

                            Set rsBookGetList = spBookGetList.Execute

                            do until rsBookGetList.EOF
                                Response.Write rsBookGetList.Fields.Item("Name") & ", "
                                rsBookGetList.MoveNext
                            loop

                            Set spBookGetList = nothing 
                            Set rsBookGetList = nothing
                            Set connDB = nothing
                        End If
                        %>" />
                </td>
            </tr>
        </table>
        <br />
        <div>
            <button title="Click to edit/add the author" type="submit">Add/Edit</button><br />
            <a href="Books.asp" title="Click to return to the Books page">Books</a>
        </div>
    </form>
</body>
</html>