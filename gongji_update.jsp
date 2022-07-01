<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page errorPage="./gongji_error.jsp" %>    
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>

<head>
  <%
    request.setCharacterEncoding("utf-8");

    int id = Integer.parseInt(request.getParameter("id"));
    String title = request.getParameter("title");
    String content = request.getParameter("content");
    
    Class.forName("com.mysql.jdbc.Driver");
    Connection conn = DriverManager.getConnection("jdbc:mysql://localhost/kopoctc", "root", "abcd1234");	
    
    String query = "update gongji2 set title=?, content=? where id=?";

    PreparedStatement pstmt = conn.prepareStatement(query);

    pstmt.setString(1, title);
    pstmt.setString(2, content);
    pstmt.setInt(3, id);

    pstmt.executeUpdate();

    pstmt.close();
    conn.close();
  %>
  <script>
    alert("수정 완료");
    window.location.href = "gongji_view.jsp?id=<%= id%>";
  </script>
</head>

<body>
  
</body>

</html>