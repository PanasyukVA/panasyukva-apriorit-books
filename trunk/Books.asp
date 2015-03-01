<!--#include file="Connection.asp" -->

<!DOCTYPE html>
<html>
<head>
	<title>Books</title>
    <link href="Style/Books.css" rel="stylesheet" />
</head>
<body>
    <div id="container">
        <div role="main">
            <div id="Books">
                <%
                    Dim spBookGetList, rsBookList

                    Set spBookGetList = Server.CreateObject("ADODB.command")
                    spBookGetList.ActiveConnection = connDB
                    spBookGetList.CommandType = adCmdStoredProc
                    spBookGetList.CommandText = "spBookGetList"
                    Set rsBookList = spBookGetList.Execute
                %>

                <table class="BooksTable">
                    <tr>
                        <th>#</th>
                        <th>Book Name</th>
                        <th>Authors</th>
                    </tr>

                    <%do until rsBookList.EOF%>
                        <tr>
                            <td>
                                <%=rsBookList.Fields.Item("ID")%>
                            </td>
                            <td>
                                <a title="Click to edit the book" href="Book.asp?ID=<%=rsBookList.Fields.Item("ID")%>&Name=<%=rsBookList.Fields.Item("Name")%>"><% =rsBookList.Fields.Item("Name") %></a>
                            </td>
                            <td>
                                <%
                                    Dim  spAuthorGetList, rsAuthorList 
                                    Set spAuthorGetList = Server.CreateObject("ADODB.command")
                                    spAuthorGetList.ActiveConnection = connDB
                                    spAuthorGetList.CommandType = adCmdStoredProc
                                    spAuthorGetList.CommandText = "spAuthorGetList"
                                    spAuthorGetList.Parameters.Append spAuthorGetList.CreateParameter("@BookID", adInteger, adParamInput, ,CInt(rsBookList.Fields.Item("ID")))
                                    Set rsAuthorList = spAuthorGetList.Execute

                                    do until rsAuthorList.EOF
                                        If Cint(rsAuthorList.Fields.Item("WroteBook")) = 1 Then
                                            Response.Write "<a title='Click to edit the author' href='Author.asp?ID=" & rsAuthorList.Fields.Item("ID") & "&Name=" & rsAuthorList.Fields.Item("Name") & "'>" & rsAuthorList.Fields.Item("Name") & "</a>, "
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
                
                <a title="Click to add a book" href="Book.asp">Add book</a>
                <a title="Click to add an author" href="Author.asp">Add Author</a>
            </div>
        </div>
    </div>
</body>
</html>