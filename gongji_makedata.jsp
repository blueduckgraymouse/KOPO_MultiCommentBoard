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
    
    String query1 = "drop table gongji;";
    PreparedStatement pstmt = conn.prepareStatement(query1);
    pstmt.executeUpdate();


    String query2 = "CREATE TABLE gongji(id int NOT NULL PRIMARY KEY AUTO_INCREMENT, title varchar(70), date date, content text) DEFAULT CHARSET UTF8;";
    pstmt = conn.prepareStatement(query2);
    pstmt.executeUpdate();
    

    String query3 = "insert into gongji(title, date, content) values(?, ?, ?);";
    pstmt = conn.prepareStatement(query3);

    for (int i = 1 ; i <= 119 ; i++) {
      pstmt.setString(1, "제목" + i);
      pstmt.setString(2, sdf.format(nowDate));
      pstmt.setString(3, "내용내용" + i);

      pstmt.executeUpdate();
    }

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