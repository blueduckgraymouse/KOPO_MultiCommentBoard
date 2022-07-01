<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>

<head>
  <%
    /**
        - 로직 -
        1. 댓글 달고자하는 글의 rootid가 같고 recnt가 큰 게시물 조회
        2. rset의 첫번재에 접근해서 본글의 relevel과 recnt을 변수에 저장, 댓글의 relevel을 기준으로 들어갈 위치(recnt)를 찾을 것이므로 relevel+1
        3. 1에서 조회한 rset을 2번째 record부터 순차적으로 확인하면 relevel같거나 높으면 해당 recnt로 갱신, 낮으면 확인 루프 종료(break)
        4. 이렇게 확인한 recnt 아래로 입력한 댓글이 들어가야하므로 recnt++ (update)
        5. 중간에 댓글이 들어가는 것이므로 rootid가 같고 recnt가 큰 이미 존재하는 다른 댓글의 recnt를 +1식 증가(update)
        6. DB에 새로 입력된 게시물 입력(insert)
    */

    request.setCharacterEncoding("utf-8");

    String id = request.getParameter("id");
    String title = request.getParameter("title");
    String date = request.getParameter("date");
    String content = request.getParameter("content");
    String rootid = request.getParameter("rootid");

    Class.forName("com.mysql.jdbc.Driver");
    Connection conn = DriverManager.getConnection("jdbc:mysql://localhost/kopoctc", "root", "abcd1234");	
    

    // 입력하고자하는 글의 아래 모든 글 조회 (같은 rootid에 한해)
    String query1 = "select g.* from gongji2 as g, (select recnt from gongji2 where id=?) as r where rootid=? and r.recnt <=g.recnt order by g.recnt;";
    PreparedStatement pstmt = conn.prepareStatement(query1);
    pstmt.setInt(1, Integer.parseInt(id));
    pstmt.setInt(2, Integer.parseInt(rootid));
    ResultSet rset = pstmt.executeQuery();


    // 첫번째 record는 댓글달고자하는 글
    rset.next();
    int relevel = rset.getInt("relevel") + 1;   // 댓글이므로 relevel + 1
    int recnt = rset.getInt("recnt");           // 해당 글의 recnt

    while (rset.next()) {                       // 아래 record를 접근하며 relevel이 같거나 높으면 recnt 갱신, 낮으면 break
      if (rset.getInt("relevel") >= relevel) {
        recnt = rset.getInt("recnt");
      } else {
        break;
      }
    }
    recnt++;                                    // 그 다음에 와야하므로 +1


    // 추가할 댓글 아래 위치할 댓글들의 recnt +1 증가
    String query2 = "update gongji2 set recnt = recnt + 1 where rootid=? and recnt >= ?;";
    pstmt = conn.prepareStatement(query2);
    pstmt.setString(1, rootid);
    pstmt.setInt(2, recnt);
    pstmt.executeUpdate();


    // DB에 저장
    String query3 = "insert into gongji2(title, date, content, rootid, relevel, recnt) values(?, ?, ?, ?, ?, ?);";
    pstmt = conn.prepareStatement(query3);
    pstmt.setString(1, title);
    pstmt.setString(2, date);
    pstmt.setString(3, content);
    pstmt.setString(4, rootid);
    pstmt.setInt(5, relevel);
    pstmt.setInt(6, recnt);
    pstmt.executeUpdate();


    // 자동부여된 ID 조회
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