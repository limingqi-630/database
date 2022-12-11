import java.sql.*;
import java.util.Scanner;

public class Login {
    public static void main(String[] args) {
        Connection connection = null;
        Statement statement=null;
        ResultSet resultSet = null;

        Scanner input = new Scanner(System.in);

        System.out.print("�������û�����");
        String loginName = input.nextLine();
        System.out.print("���������룺");
        String loginPass = input.nextLine();

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");

            String userName = "root";
            String passWord = "123123";
            String url = "jdbc:mysql://127.0.0.1:3306/finance?useUnicode=true&characterEncoding=UTF8&useSSL=false&serverTimezone=UTC";
            connection = DriverManager.getConnection(url, userName, passWord);
            // ����ʵ�ִ���:
            statement=connection.createStatement();
            String sql = "select c_password from client where c_mail = '" + loginName + "';";
            resultSet=statement.executeQuery(sql);
            if(resultSet.next())
            {
                if(loginPass.compareTo(resultSet.getString("c_password"))!=0 || resultSet.getString("c_password")==null)
                    System.out.print("�û������������\n");
                else
                    System.out.print("��¼�ɹ���\n");
            }
            else
                System.out.print("�û������������\n");
        
         } catch (ClassNotFoundException e) {
            e.printStackTrace();
        } catch (SQLException throwables) {
            throwables.printStackTrace();
        } finally {
            try {
                if (resultSet != null) {
                    resultSet.close();
                }
                if (statement != null) {
                    statement.close();
                }

                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException throwables) {
                throwables.printStackTrace();
            }
        }
    }
}
