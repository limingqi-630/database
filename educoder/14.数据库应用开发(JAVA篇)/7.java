import java.sql.*;

public class Transform {
    static final String JDBC_DRIVER = "com.mysql.cj.jdbc.Driver";
    static final String DB_URL = "jdbc:mysql://127.0.0.1:3306/sparsedb?allowPublicKeyRetrieval=true&useUnicode=true&characterEncoding=UTF8&useSSL=false&serverTimezone=UTC";
    static final String USER = "root";
    static final String PASS = "123123";
    public static void insertSC(Connection connection,int sno,String subject,int score)
    {
        try
        {
            PreparedStatement preparedStatement=null;
            String sql="insert into sc values(?,?,?)";
            preparedStatement = connection.prepareStatement(sql);
            preparedStatement.setInt(1, sno); 
            preparedStatement.setString(2, subject);
            preparedStatement.setInt(3, score); 
            preparedStatement.executeUpdate();
        }
        catch (SQLException e) 
        {
		    e.printStackTrace();
		} 
    }
    public static void main(String[] args) throws Exception
    {
        
        //加载数据库驱动
        Class.forName(JDBC_DRIVER);
        //连接数据库
        Connection connection = DriverManager.getConnection(DB_URL, USER, PASS);
        PreparedStatement preparedStatement_for_row=null;
        String[] subject={"chinese","math","english","physics","chemistry","biology","history","geography","politics"};
        //遍历行
        String sql="select * from entrance_exam";
        preparedStatement_for_row = connection.prepareStatement(sql);
        ResultSet resultSet_for_row=preparedStatement_for_row.executeQuery(sql);
        while(resultSet_for_row.next())
        {
            int sno=resultSet_for_row.getInt("sno");
            
            for(int i=0;i<9;i++)
            {
                int score=resultSet_for_row.getInt(subject[i]);
                if(!resultSet_for_row.wasNull())
                    insertSC(connection,sno,subject[i],score);
            }
        }
    
    }
}