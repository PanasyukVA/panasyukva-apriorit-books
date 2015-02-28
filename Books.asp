<!--#include virtual="/Books/Connection.asp" -->

<!DOCTYPE html>
<html>
<head>
	<title>Books</title>
</head>
<body>
    <div id="container">
        <header></header>
        
        <div role="main">
            <div id="Books">
                <%
                Dim spBookGetList, rsBookList

                Set spBookGetList = Server.CreateObject("ADODB.command")
                spBookGetList.ActiveConnection = connDB
                spBookGetList.CommandType = 4
                spBookGetList.CommandText = "spBookGetList"
                Set rsBookList = spBookGetList.Execute
                %>

                <table style="border-width:1px;width:100%">
                    <tr style="background-color:#b0c4de;">
                        <th>#</th>
                        <th>Book Name</th>
                        <th>Authors</th>
                    </tr>

                    <%do until rsBookList.EOF%>
                        <tr style="background-color:#f0f0f0;">
                            <td>
                                <% =rsBookList.Fields.Item("ID")%>
                            </td>
                            <td>
                                <a href="Book.asp?ID=<%=rsBookList.Fields.Item("ID")%>&Name=<%=rsBookList.Fields.Item("Name")%>"><% =rsBookList.Fields.Item("Name") %></a>
                            </td>
                            <td>
                                <%
                                Dim  spAuthorGetList, rsAuthorList 
                                Set spAuthorGetList = Server.CreateObject("ADODB.command")
                                spAuthorGetList.ActiveConnection = connDB
                                spAuthorGetList.CommandType = 4
                                spAuthorGetList.CommandText = "spAuthorGetList"
                                spAuthorGetList.Parameters.Append spAuthorGetList.CreateParameter("@BookID", 3, 1, ,rsBookList.Fields.Item("ID"))
                                Set rsAuthorList = spAuthorGetList.Execute

                                do until rsAuthorList.EOF
                                    If rsAuthorList.Fields.Item("WroteBook") = 1 Then
                                        Response.Write "<a href='Author.asp?ID=" & rsAuthorList.Fields.Item("ID") & "&Name=" & rsAuthorList.Fields.Item("Name") & "'>" & rsAuthorList.Fields.Item("Name") & "</a>, "
                                    End If

                                    rsAuthorList.MoveNext
                                loop

                                Set spAuthorGetList = nothing 
                                Set rsAuthorList = nothing
                                %>
                            </td>
                        </tr>
                        <%rsBookList.MoveNext%>
                    <%
                    loop
                        
                    rsBookList.close
                    set spBookGetList = nothing
                    set rsBookList = nothing
		            %>
                </table>
                
                <a href="Book.asp">Add book</a>
                <a href="Author.asp">Add Author</a>
            </div>
        </div>
    </div>
</body>
</html>