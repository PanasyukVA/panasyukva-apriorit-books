<!--#include file="Connection.asp" -->

<%
    Dim BookID, BookName, Authors

    If Len(Request("Name")) <> 0 Then
        BookID = CInt(Request("ID"))
        BookName = CStr(Request("Name"))
    ElseIf Len(Request.Form("BookName")) <> 0 Then
        If Len(Request.Form("BookID")) <> 0 Then
            BookID = CInt(Request.Form("BookID"))
        End If
        BookName = CStr(Request.Form("BookName"))
        Authors = CStr(Request.Form("BookAuthors")) & ","
    End If
    
    If Len(Request.Form("BookName")) <> 0 Then
        Set spBookEdit = Server.CreateObject("ADODB.command")
        spBookEdit.ActiveConnection = connDB
        spBookEdit.CommandType = adCmdStoredProc
        spBookEdit.CommandText = "spBookEdit"
        spBookEdit.Parameters.Append spBookEdit.CreateParameter("@ID", adInteger, adParamInputOutput, , BookID)
        spBookEdit.Parameters.Append spBookEdit.CreateParameter("@Name", adVarChar, adParamInput, 150, BookName)
        spBookEdit.Parameters.Append spBookEdit.CreateParameter("@Authors", adVarChar, adParamInput, 1024, Authors)
        spBookEdit.Execute

        BookID = CInt(spBookEdit.Parameters("@ID").Value)
        Set spBookEdit = nothing 
    End If
 %>

<!DOCTYPE html>
<html>
<head>
	<title>Book</title>
    <link href="Style/Books.css" rel="stylesheet" />
</head>
<body>
    <form method="post" action="Book.asp">
        <table class="BookTable">
            <tr>
                <td>
                    <label for="BookName">Name: </label>
                </td>
                <td>
                    <input name="BookName" type="text" value="<%=BookName%>" required placeholder="Please, enter the book's name" />
                    <input name="BookID" type="hidden" value="<%=BookID%>" />
                </td>
            </tr>
            <tr>
                <td>
                    <label for="BookAuthors">Authors: </label>
                </td>
                <td>
                    <select name="BookAuthors" multiple required title="Choose authors of the book">
                        <%
                        Dim  spAuthorGetList, rsAuthorList
                     
                        Set spAuthorGetList = Server.CreateObject("ADODB.command")
                        spAuthorGetList.ActiveConnection = connDB
                        spAuthorGetList.CommandType = adCmdStoredProc
                        spAuthorGetList.CommandText = "spAuthorGetList"
                        spAuthorGetList.Parameters.Append spAuthorGetList.CreateParameter("@BookID", adInteger, adParamInput, ,BookID)    

                        Set rsAuthorList = spAuthorGetList.Execute
                        do until rsAuthorList.EOF
                            Response.Write "<option"
                            If rsAuthorList.Fields.Item("WroteBook") = 1 Then
                                Response.Write " selected" 
                            End If
                            Response.Write ">" & rsAuthorList.Fields.Item("Name") & "</option>"
                            
                            rsAuthorList.MoveNext
                        loop

                        Set spAuthorGetList = nothing 
                        Set rsAuthorList = nothing
                        %>
                    </select>
                </td>
            </tr>
        </table>
        <br />
        <div>
            <button title="Click to edit/add the book" type="submit">Add/Edit</button><br />
            <a href="Books.asp" title="Click to return to the Books page">Books</a>
        </div>
    </form>
</body>
</html>