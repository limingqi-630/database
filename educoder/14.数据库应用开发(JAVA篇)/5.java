import java.sql.*;
import java.util.Scanner;

public class ChangePass {
    static final String JDBC_DRIVER = "com.mysql.cj.jdbc.Driver";
    static final String DB_URL = "jdbc:mysql://127.0.0.1:3306/finance?allowPublicKeyRetrieval=true&useUnicode=true&characterEncoding=UTF8&useSSL=false&serverTimezone=UTC";
    static final String USER = "root";
    static final String PASS = "123123";


    /**
     * �޸Ŀͻ�����
     *
     * @param connection ���ݿ����Ӷ���
     * @param mail �ͻ�����,Ҳ�ǵ�¼��
     * @param password �ͻ���¼����
     * @param newPass  ������
     * @return
     *   1 - �����޸ĳɹ�
     *   2 - �û�������
     *   3 - ���벻��ȷ
     *  -1 - �����쳣(��û�����ӵ����ݿ�ȣ�
     */
    public static int passwd(Connection connection,
                             String mail,
                             String password, 
                             String newPass)
    {
        ResultSet resultSet = null;
        PreparedStatement preparedStatement=null;
        Statement statement=null;
        try
        {
            //��¼
            statement=connection.createStatement();
            String sql = "select c_password from client where c_mail = '" + mail + "';";
            resultSet=statement.executeQuery(sql);
            // String sql="select c_password from client where c_mail = ?";
            // preparedStatement = connection.prepareStatement(sql);
            // preparedStatement.setString(1, mail); 
            // resultSet=preparedStatement.executeQuery(sql);
            //�鲻��
            if(!resultSet.next())
                return 2;
            //�鵽�ľ���������벻һ��
            if(password.compareTo(resultSet.getString("c_password"))!=0 || resultSet.getString("c_password")==null)
                return 3;
            //��ȷ��¼
            sql="update client set c_password=? where c_mail=?;";
            preparedStatement = connection.prepareStatement(sql);
            preparedStatement.setString(1, newPass); 
            preparedStatement.setString(2, mail); 
            preparedStatement.executeUpdate();
            return 1;
        }
        catch (SQLException e) 
        {
			e.printStackTrace();
		} 
        return 0;
    }

    // ��Ҫ�޸�main() 
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
            String email = commands[0];
            String pass = commands[1];
            String pwd1 = commands[2];
            String pwd2 = commands[3];
            if (pwd1.equals(pwd2)) {
              int n = passwd(connection, email, pass, pwd1);  
              System.out.println("return: " + n);
            } else {
              System.out.println("������������벻һ��!");
            }
        }
    }

}
