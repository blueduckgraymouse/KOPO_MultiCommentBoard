<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>

<head>
  <%
    request.setCharacterEncoding("utf-8");

    String id = request.getParameter("id");
    String title = request.getParameter("title");
    String date = request.getParameter("date");
    String content = request.getParameter("content");
    String rootid = request.getParameter("rootid");
    String relevel = request.getParameter("relevel"); // 입력 폼에서 표시를 위해서 이미 증가된 relevel
    
    int recnt = 0;

    Class.forName("com.mysql.jdbc.Driver");
    Connection conn = DriverManager.getConnection("jdbc:mysql://localhost/kopoctc", "root", "abcd1234");	
    
    // rootid 기준으로 댓글의 총 개수 계산
    String query1 = "select count(*) from gongji2 where rootid=?";
    PreparedStatement pstmt = conn.prepareStatement(query1);
    pstmt.setInt(1, Integer.parseInt(rootid));
    ResultSet rset = pstmt.executeQuery();
    rset.next();
    int count = rset.getInt(1);

    // 계산을 위해 댓글의 정보가 저장될 배열
    int[][] record = new int[count][3];

    // 배열에 계산에 필요한 정보 담기, rootid 기준으로 모든 댓글의 id와 rootid, relevel, recnt
    String query2 = "select * from gongji2 where rootid=? order by recnt";
    pstmt = conn.prepareStatement(query2);
    pstmt.setInt(1, Integer.parseInt(rootid));
    rset = pstmt.executeQuery();
    int i = 0;
    while (rset.next()) {
      record[i][0] = rset.getInt("id");
      record[i][1] = rset.getInt("relevel");
      record[i][2] = rset.getInt("recnt");
      i++;
    }

    // 댓글을 단 글의 아래로 순차적으로 접근, relevel이 같거나 크면 cnt저장, 작아지면 break
    for (int j = 0 ; j < count ; j++) {
      if (record[j][0] == Integer.parseInt(id)) { // 댓글을 단 글의
        int level = record[j][1] + 1;
        recnt = record[j][2];
        for (int k = j + 1 ; k < count ; k++) {   //   아래로 순차적으로 접근
          if (level <= record[k][1]) {            //      relevel이 같거나 크면 cnt저장
            recnt = record[k][2];
          } else {                                //      작아지면 break
            break; 
          }
        }
      }
    }

    // 이렇게 구한 recnt는 댓글 달고자 하는 글의 이전, 혹은 하위 댓글들 중 마지막 recnt번호, 그 다음에 추가할 것이므로 +1
    recnt = recnt + 1;

    // 추가할 recnt 밑으로 있는 글의 recnt +1 증가
    String query3 = "update gongji2 set recnt = recnt + 1 where rootid=? and recnt >= ?;";
    pstmt = conn.prepareStatement(query3);
    pstmt.setString(1, rootid);
    pstmt.setInt(2, recnt);
    pstmt.executeUpdate();
    

    // 폼에서 전달받은 데이터와 계산된 recnt DB에 저장
    String query4 = "insert into gongji2(title, date, content, rootid, relevel, recnt) values(?, ?, ?, ?, ?, ?);";
    pstmt = conn.prepareStatement(query4);
    pstmt.setString(1, title);
    pstmt.setString(2, date);
    pstmt.setString(3, content);
    pstmt.setString(4, rootid);
    pstmt.setString(5, relevel);
    pstmt.setInt(6, recnt);
    pstmt.executeUpdate();

    // 저장하며 자동부여된 ID 조회해오기
    String query6 = "select id from gongji2 order by id desc limit 1";
    pstmt = conn.prepareStatement(query6);
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