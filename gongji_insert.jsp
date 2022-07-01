<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page errorPage="./gongji_error.jsp" %>    
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>

<head>
  <%
    request.setCharacterEncoding("utf-8");

    String title = request.getParameter("title");
    String date = request.getParameter("date");
    String content = request.getParameter("content");
    
    Class.forName("com.mysql.jdbc.Driver");
    Connection conn = DriverManager.getConnection("jdbc:mysql://localhost/kopoctc", "root", "abcd1234");	

    String query1 = "insert into gongji2(title, date, content) values(?, ?, ?);";
    PreparedStatement pstmt = conn.prepareStatement(query1);
    pstmt.setString(1, title);
    pstmt.setString(2, date);
    pstmt.setString(3, content);
    pstmt.executeUpdate();


    String query2 = "select id from gongji2 order by id desc limit 1";
    pstmt = conn.prepareStatement(query2);
    ResultSet rset = pstmt.executeQuery();
    rset.next();
    int newId = rset.getInt(1);


    String query3 = "update gongji2 set rootid=? where id=?";
    pstmt = conn.prepareStatement(query3);
    pstmt.setInt(1, newId);
    pstmt.setInt(2, newId);
    pstmt.executeUpdate();

    rset.close();
    pstmt.close();
    conn.close();
  %>
  <script>
    alert("등록 완료");
    window.location.href = "gongji_view.jsp?id=<%= newId%>";
  </script>
</head>

<body>
  
</body>

</html>