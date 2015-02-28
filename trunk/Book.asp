<!--#include virtual="/Books/Connection.asp" -->

<%
    BookID = Request("ID")

    If Request.Form("BookName") <> "" Then
        Dim  spBookEdit
                     
        Set spBookEdit = Server.CreateObject("ADODB.command")
        spBookEdit.ActiveConnection = connDB
        spBookEdit.CommandType = 4
        spBookEdit.CommandText = "spBookEdit"
        If Request.Form("BookID") <> "" Then
            spBookEdit.Parameters.Append spBookEdit.CreateParameter("@ID", 3, 3, , Request.Form("BookID"))
        Else
            spBookEdit.Parameters.Append spBookEdit.CreateParameter("@ID", 3, 3, , nothing)
        End If
        spBookEdit.Parameters.Append spBookEdit.CreateParameter("@Name", 200, 1, 150, Request.Form("BookName"))
        spBookEdit.Parameters.Append spBookEdit.CreateParameter("@Authors", 200, 1, 1024, Request.Form("BookAuthors") & ",")
        spBookEdit.Execute

        BookID = spBookEdit.Parameters("@ID").Value
        Set spBookEdit = nothing 
    End If
 %>

<!DOCTYPE html>
<html>
<head>
	<title>Book</title>
</head>
<body>
    <form method="post" action="Book.asp">
        <table style="background-color:#b0c4de;width:30%">
            <tr>
                <td style="width:10%">
                    <label for="BookName">Name: </label>
                </td>
                <td style="text-align:left;width:90%">
                    <input name="BookName" type="text" style="width:99%" value="<%
                        Response.Write Request("Name") 
                        Response.Write Request.Form("BookName")
                        %>" required />
                    <input name="BookID" type="hidden" value="<%=BookID%>" />
                </td>
            </tr>
            <tr>
                <td style="width:10%">
                    <label for="BookAuthors">Authors: </label>
                </td>
                <td style="text-align:left;width:90%">
                    <select name="BookAuthors" style="width:100%;" multiple required>
                        <%
                        Dim  spAuthorGetList, rsAuthorList
                     
                        Set spAuthorGetList = Server.CreateObject("ADODB.command")
                        spAuthorGetList.ActiveConnection = connDB
                        spAuthorGetList.CommandType = 4
                        spAuthorGetList.CommandText = "spAuthorGetList"
                        spAuthorGetList.Parameters.Append spAuthorGetList.CreateParameter("@BookID", 3, 1, ,BookID)    

                        Set rsAuthorList = spAuthorGetList.Execute

                        do until rsAuthorList.EOF
                            If rsAuthorList.Fields.Item("WroteBook") = 1 Then
                                Response.Write "<option id='" & rsAuthorList.Fields.Item("ID") & "' selected>" & rsAuthorList.Fields.Item("Name") & "</option>, "
                            Else
                                Response.Write "<option id='" & rsAuthorList.Fields.Item("ID") & "'>" & rsAuthorList.Fields.Item("Name") & "</option>, "
                            End If
                            
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
            <input type="submit" value="Add/Edit" /><br />
            <a href="Books.asp">Books</a>
        </div>
    </form>
</body>
</html>