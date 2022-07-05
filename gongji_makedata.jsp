<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page errorPage="./gongji_error.jsp" %>    
<%@ page import="java.sql.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<!DOCTYPE html>
<html>

<head>
  <%
    Date nowDate = new Date();
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

    Class.forName("com.mysql.jdbc.Driver");
    Connection conn = DriverManager.getConnection("jdbc:mysql://localhost/kopoctc", "root", "abcd1234");	

    
    String query = "CALL `setGongji2`;";
    PreparedStatement pstmt = conn.prepareStatement(query);
    pstmt.executeUpdate();
    
    pstmt.close();
    conn.close();
  %>
  <script>
    alert("초기화 완료");
    window.location.href = "gongji_list.jsp";
  </script>
</head>

<body>
  
</body>

</html>