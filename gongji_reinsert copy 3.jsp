<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>

<head>
  <%
    request.setCharacterEncoding("utf-8");

    String title = request.getParameter("title");
    String date = request.getParameter("date");
    String content = request.getParameter("content");
    String rootid = request.getParameter("rootid");
    String relevel = request.getParameter("relevel"); // 증가된 relevel
    String oldRecnt = request.getParameter("recent"); // 댓글 대상 글의 recnt
    
    int recnt = 0;

    Class.forName("com.mysql.jdbc.Driver");
    Connection conn = DriverManager.getConnection("jdbc:mysql://localhost/kopoctc", "root", "abcd1234");	
    
    String query1 = "select *, IFNULL(lead(recnt) OVER (ORDER BY recnt), '') as nxt from gongji2 where rootid=? and relevel=?;";
    PreparedStatement pstmt = conn.prepareStatement(query1);
    pstmt.setString(1, rootid);
    pstmt.setInt(2, Integer.parseInt(relevel) - 1);
    ResultSet rset = pstmt.executeQuery();
    while(rset.next()) {
      if (rset.getInt("recnt") == Integer.parseInt(oldRecnt)) {
        recnt = rset.getInt("nxt") - 1;
      }
    }

    String query2 = "update gongji2 set recnt = recnt + 1 where rootid=? and recnt >= ?;";
    pstmt = conn.prepareStatement(query2);
    pstmt.setString(1, rootid);
    pstmt.setInt(2, recnt);
    pstmt.executeUpdate();

    String query3 = "insert into gongji2(title, date, content, rootid, relevel, recnt) values(?, ?, ?, ?, ?, ?);";
    pstmt = conn.prepareStatement(query3);
    pstmt.setString(1, title);
    pstmt.setString(2, date);
    pstmt.setString(3, content);
    pstmt.setString(4, rootid);
    pstmt.setString(5, relevel);
    pstmt.setInt(6, recnt + 1);
    pstmt.executeUpdate();

    String query4 = "select id from gongji2 order by id desc limit 1";
    pstmt = conn.prepareStatement(query4);
    rset = pstmt.executeQuery();
    rset.next();
    int newId = rset.getInt(1);

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