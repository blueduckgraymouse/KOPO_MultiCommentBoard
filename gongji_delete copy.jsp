<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page errorPage="./gongji_error.jsp" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>

<head>
  <%
    int id = Integer.parseInt(request.getParameter("id"));

    Class.forName("com.mysql.jdbc.Driver");
    Connection conn = DriverManager.getConnection("jdbc:mysql://localhost/kopoctc", "root", "abcd1234");	
    
    // 지워질 글의 아래 댓글을의 recnt - 1
    String query1 = "update gongji2, (select g.rootid, g.recnt from gongji2 as g, (select recnt from gongji2 where id=?) as r where g.recnt > r.recnt) as l set gongji2.recnt = gongji2.recnt - 1 where l.rootid = gongji2.rootid and l.recnt = gongji2.recnt;";
    PreparedStatement pstmt = conn.prepareStatement(query1);
    pstmt.setInt(1, id);
    pstmt.executeUpdate();

    // 게시글 삭제
    String query2 = "delete from gongji2 where id=?";
    pstmt = conn.prepareStatement(query2);
    pstmt.setInt(1, id);
    pstmt.executeUpdate();

    pstmt.close();
    conn.close();
  %>
  <script>
    alert("삭제 완료");
    window.location.href = "gongji_list.jsp";
  </script>
</head>

<body>
  
</body>

</html>