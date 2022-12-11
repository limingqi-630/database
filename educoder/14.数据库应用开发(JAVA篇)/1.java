import java.sql.*;

public class Client {
    static String JDBC_Driver="com.mysql.cj.jdbc.Driver";
    static String URL = "jdbc:mysql://127.0.0.1:3306/finance?useUnicode=true&characterEncoding=UTF8&useSSL=false&serverTimezone=UTC&useSSL=false";
    static String USER = "root";
    static String PASS = "123123";
    

    public static void main(String[] args) {
        Connection connection = null;
        Statement statement = null;
        ResultSet resultSet = null;

        try 
        {
            //注册JDBC驱动程序 用于与数据库通信
            Class.forName(JDBC_Driver);
            //数据库url配置
            connection = DriverManager.getConnection(URL, USER, PASS);
            statement=connection.createStatement();
            String sql_command="select c_name,c_mail,c_phone from finance.client where c_mail is not null";
            resultSet=statement.executeQuery(sql_command);
            System.out.println("姓名\t邮箱\t\t\t\t电话");
            while(resultSet.next())
            {
                System.out.println(resultSet.getString("c_name")+"\t"+resultSet.getString("c_mail")+"\t\t"+resultSet.getString("c_phone"));
            }
        } 
        catch (ClassNotFoundException e) 
        {
            System.out.println("Sorry,can`t find the JDBC Driver!"); 
            e.printStackTrace();
        } 
        catch (SQLException throwables) 
        {
            throwables.printStackTrace();
        } 
        finally 
        {
            try 
            {
                if (resultSet != null) 
                    resultSet.close();
                if (statement != null) 
                    statement.close();
                if (connection != null) 
                    connection.close();//关闭数据库连接
            } 
            catch (SQLException throwables) 
            {
                throwables.printStackTrace();
            }
        }
    }
}
