<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>

<head>
	<meta charset="UTF-8">
	<title>게시물 상세 조회</title>
  <style>
    .container {
      max-width: 600px;
      margin:0 auto;
    }
    table {
      text-align: center;
    }
    td {
      border: 1px solid black;
    }
    .table-view {
      width: 600px;
      border-collapse: collapse;
    }
    .table-view td {
      height: 30px;
      border: 1px solid grey;
    }
    td.title {
      border-right: 3px double grey;
      background-color: lightgrey;
    }
    .align-left {
      text-align: right;
    }
    a {
      color: black;
      text-decoration: none;
    }
    a:hover {
      text-decoration: underline;
    }
    #content {
      height: 200px;
    }
    div.div-button {
      text-align: right;
    }
    textarea {
      width: 98%;
      height: 10em;
      border: none;
      resize: none;
    }
  </style>
  <%
    int id = Integer.parseInt(request.getParameter("id"));
	
    Class.forName("com.mysql.jdbc.Driver");
    Connection conn = DriverManager.getConnection("jdbc:mysql://localhost/kopoctc", "root", "abcd1234");	
    
    String query1 = "select * from gongji2 where id=?";
    PreparedStatement pstmt = conn.prepareStatement(query1);
    pstmt.setInt(1, id);
    ResultSet rset = pstmt.executeQuery();


    String query2 = "update gongji2 set viewcnt=viewcnt+1 where id=?";
    pstmt = conn.prepareStatement(query2);
    pstmt.setInt(1, id);
    pstmt.executeUpdate();

    rset.next();
  %>
</head>

<body>
  
  <div class="container">
    <jsp:include page="gongji_banner.jsp"/>

    <h1>공지사항</h1>

    <table class="table-view">
      <tr>
        <td colspan="2" class="title"><b>번호</b></td>
        <td colspan="3" width="450px">
          <%= rset.getString("id")%>
        </td>
      </tr>
      <tr>
        <td colspan="2" class="title"><b>제목</b></td>
        <td colspan="3">
          <%= rset.getString("title") %>
        </td>
      </tr>
      <tr>
        <td colspan="2" class="title"><b>등록일자</b></td>
        <td colspan="3"><%= rset.getDate("date")%></td>
      </tr>
      <tr>
        <td colspan="2" class="title"><b>조회수</b></td>
        <td colspan="3"><%= rset.getInt("viewcnt") + 1%></td>
      </tr>
      <tr>
        <td colspan="2" class="title"><b>내용</b></td>
        <td colspan="3" id="content"><textarea><%= rset.getString("content")%></textarea>
        </td>
      </tr>
      <tr>
        <td colspan="2" class="title"><b>원글</b></td>
        <td colspan="3"><%= rset.getString("rootid")%></td>
      </tr>
      <tr>
        <td colspan="2" class="title"><b>댓글 수준</b></td>
        <td><%= rset.getInt("relevel")%></td>
        <td class="title" width="150px"><b>댓글 내 순서</b></td>
        <td><%= rset.getString("recnt")%></td>
      </tr>
    </table>

    <br>
    
    <div class="div-button">
      <input type="button" value="목록" onclick="location.href='gongji_list.jsp'">
      <input type="button" value="수정" onclick="location.href='gongji_updateForm.jsp?id=<%= rset.getString("id")%>'">
      <input type="button" value="삭제" onclick="location.href='gongji_delete.jsp?id=<%= rset.getString("id")%>'">
      <input type="button" value="댓글" onclick="location.href='gongji_reinsertForm.jsp?id=<%= rset.getString("id")%>'">
    </div>
  </div>
  <%	
    rset.close();	
    pstmt.close();	
    conn.close();	
  %>
</body>

</html>