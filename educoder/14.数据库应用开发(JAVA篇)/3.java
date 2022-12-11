import java.sql.*;
import java.util.Scanner;

public class AddClient {
    static final String JDBC_DRIVER = "com.mysql.cj.jdbc.Driver";
    static final String DB_URL = "jdbc:mysql://127.0.0.1:3306/finance?allowPublicKeyRetrieval=true&useUnicode=true&characterEncoding=UTF8&useSSL=false&serverTimezone=UTC";
    static final String USER = "root";
    static final String PASS = "123123";

    public static void insertClient(Connection connection,
                                   int c_id, String c_name, String c_mail,
                                   String c_id_card, String c_phone, 
                                   String c_password)
    {
        PreparedStatement preparedStatement=null;
        try
        {
            String sql="insert into client values(?,?,?,?,?,?)";
            preparedStatement = connection.prepareStatement(sql);
            preparedStatement.setInt(1, c_id); // 给SQL中第一个问号赋变量id的值
            preparedStatement.setString(2, c_name); 
            preparedStatement.setString(3, c_mail); 
            preparedStatement.setString(4, c_id_card); 
            preparedStatement.setString(5, c_phone); 
            preparedStatement.setString(6, c_password);
            preparedStatement.execute();
        }
        catch (SQLException e) 
        {
			e.printStackTrace();
		} 
    }

    // 不要修改main() 
    public static void main(String[] args) throws Exception {

        Scanner sc = new Scanner(System.in);
        Class.forName(JDBC_DRIVER);

        Connection connection = DriverManager.getConnection(DB_URL, USER, PASS);

        while(sc.hasNext())
        {
            String input = sc.nextLine();
            if(input.equals(""))
                break;

            String[]commands = input.split(" ");
            if(commands.length ==0)
                break;
            int id = Integer.parseInt(commands[0]);
            String name = commands[1];
            String mail = commands[2];
            String idCard = commands[3];
            String phone = commands[4];
            String password = commands[5];

            insertClient(connection, id, name, mail, idCard, phone, password);
        }
    }

}
