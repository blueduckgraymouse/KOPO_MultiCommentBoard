<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>

<head>
	<meta charset="UTF-8">
	<title>댓글 등록</title>
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
    .table-input {
      width: 600px;
      border-collapse: collapse;
    }
    .table-input td {
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
    textarea {
      width: 450px; 
      height: 250px;
    }
    div.div-button {
      text-align: right;
    }
    </style>
    <%
      Date nowDate = new Date();
      SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");


      int id = Integer.parseInt(request.getParameter("id"));
	
      Class.forName("com.mysql.jdbc.Driver");
      Connection conn = DriverManager.getConnection("jdbc:mysql://localhost/kopoctc", "root", "abcd1234");	
      
      String query1 = "select * from gongji2 where id=?";
      PreparedStatement pstmt = conn.prepareStatement(query1);
      pstmt.setInt(1, id);
      ResultSet rset = pstmt.executeQuery();
      rset.next();
      int rootid = rset.getInt("rootid");
      int relevel = rset.getInt("relevel") + 1;
      int recnt = rset.getInt("recnt");
    %>
</head>

<body>
  <div class="container">
    <jsp:include page="gongji_banner.jsp"/>

    <h1>댓글 등록</h1>

    <form method="post" action="gongji_reinsert.jsp">
      <table class="table-input">
        <tr>
          <td class="title"><b>번호</b></td>
          <td width="450px" colspan="3">
            신규
          </td>
        </tr>
        <tr>
          <td class="title"><b>제목</b></td>
          <td colspan="3">
            <input type="text" name="title" size="70" maxlength="70">
          </td>
        </tr>
        <tr>
          <td class="title"><b>일자</b></td>
          <td colspan="3">
            <%= sdf.format(nowDate)%>
            <input type="hidden" name="date" value="<%= sdf.format(nowDate)%>">
          </td>
        </tr>
        <tr>
          <td class="title"><b>내용</b></td>
          <td colspan="3">
            <textarea name="content" cols="70" row="600"></textarea>
          </td>
        </tr>
        <tr>
          <td class="title"><b>원글</b></td>
          <td colspan="3">
            <input type="number" name="rootid" value="<%= rootid %>" readonly>
            <input type="hidden" name="id" value="<%= id %>">
          </td>
        </tr>
        <tr>
          <td class="title"><b>댓글 수준</b></td>
          <td>
            <input type="number" name="relevel" value="<%= relevel %>" readonly>
          </td>
          <td class="title" width="150px"><b>댓글 순서</b></td>
          <td>
            <input type="text" value="저장시 부여" readonly>
            <input type="hidden" name="recnt" value="<%= recnt %>" >
          </td>
        </tr>
      </table>

      <br>

      <div class="div-button">
        <input type="submit" value="등록">
        <input type="button" value="취소" onclick="location.href='gongji_list.jsp'">
      </div>
    </div>
  </form>

  <%	
    rset.close();	
    pstmt.close();	
    conn.close();	
  %>
</body>

</html>