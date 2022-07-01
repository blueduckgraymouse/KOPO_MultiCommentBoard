<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page errorPage="./gongji_error.jsp" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>

<head>
  <%
    /**
        - 로직 -
        1. 삭제하고자하는 게시글의 같은 rootid이고 recnt가 큰 게시물 조회 -> 첫번째 record는 삭제하고자하는 본글
        2. rset의 첫번재에 접근해서 본글의 relevel을 변수에 저장
        3. 1에서 조회한 rset을 2번째 record부터 순차적으로 확인하면 relevel이 낮으면 삭제(delete) 하면서 개수 카운트, 같거나 높으면 확인 루프 종료(break) (삭제하고자하는 글의 댓글이므로.)
        4. 1.을 다시 조회한 record들의 recnt를 카운트한 개수+1 만큼 감소(update), 1은 아직 삭제하지 않은 삭제하고자한 글.
        5. 지금까지는 삭제하고자하는 글의 댓글을 삭제한 것, 삭제하고자한 게시물을 삭제(delete)
    */

    int id = Integer.parseInt(request.getParameter("id"));

    Class.forName("com.mysql.jdbc.Driver");
    Connection conn = DriverManager.getConnection("jdbc:mysql://localhost/kopoctc", "root", "abcd1234");	
    

    // 삭제하고자하는 글의 아래 모든 글 조회 (같은 rootid에 한해)
    String query1 = "select g.rootid, g.id, g.relevel, g.recnt from gongji2 as g, (select rootid, recnt from gongji2 where id=?) as r where g.recnt >= r.recnt and g.rootid = r.rootid ORDER BY g.recnt;";
    PreparedStatement pstmt = conn.prepareStatement(query1);
    pstmt.setInt(1, id);
    ResultSet rset = pstmt.executeQuery();

    rset.next();
    int relevel = rset.getInt("relevel");       // 삭제하고자하는 글의 relevel 저장


    // 하위 댓글들 삭제
    int count = 0;
    while (rset.next()) {                       // 아래로 순차적으로 접근, 삭제하고자하는 글보다 relevel이 낮으면 해당 글의 하위 댓글이라고 판단. 삭제
      if (rset.getInt("relevel") > relevel) {
        String query2 = "delete from gongji2 where id=?";
        pstmt = conn.prepareStatement(query2);
        pstmt.setInt(1, rset.getInt("id"));
        pstmt.executeUpdate();
        count++;
      } else {                                  // relevel이 같거나 크면 해당 댓글과 무관한 글이므로 break
        break;
      }
    }


    // 지워질 글의 아래 댓글을의 recnt를 삭제한 글의 개수만큼 감소
    String query3 = "update gongji2, (select g.rootid, g.recnt from gongji2 as g, (select rootid, recnt from gongji2 where id=?) as r where g.recnt > r.recnt and r.rootid=g.rootid) as l set gongji2.recnt = gongji2.recnt - ? where l.rootid = gongji2.rootid and l.recnt = gongji2.recnt;";
    pstmt = conn.prepareStatement(query3);
    pstmt.setInt(1, id);
    pstmt.setInt(2, count + 1);                 // 아래 삭제될 본글도 개수에 포함
    pstmt.executeUpdate();


    // 글 삭제
    String query4 = "delete from gongji2 where id=?";
    pstmt = conn.prepareStatement(query4);
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