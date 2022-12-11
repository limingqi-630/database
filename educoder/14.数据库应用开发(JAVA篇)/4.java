import java.sql.*;
import java.util.Scanner;

public class RemoveCard {
    static final String JDBC_DRIVER = "com.mysql.cj.jdbc.Driver";
    static final String DB_URL = "jdbc:mysql://127.0.0.1:3306/finance?allowPublicKeyRetrieval=true&useUnicode=true&characterEncoding=UTF8&useSSL=false&serverTimezone=UTC";
    static final String USER = "root";
    static final String PASS = "123123";
    /**
     * ɾ��bank_card��������
     *
     * @param connection ���ݿ����Ӷ���
     * @param b_c_id �ͻ����
     * @param c_number ���п���
     */
    public static int removeBankCard(Connection connection,
                                   int b_c_id, String b_number)
    {
        int ans=0;
        try
        {
            String sql="delete from bank_card where b_c_id=? and b_number=?";
            PreparedStatement preparedStatement = connection.prepareStatement(sql);
            preparedStatement.setInt(1, b_c_id); // ��SQL�е�һ���ʺŸ�����id��ֵ
            preparedStatement.setString(2, b_number); 
            ans=preparedStatement.executeUpdate();

        }
        catch (SQLException e) 
        {
			e.printStackTrace();
		} 
        return ans;    

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
            int id = Integer.parseInt(commands[0]);
            String carNumber = commands[1];
            
            int n = removeBankCard(connection, id, carNumber);
            if (n > 0) {
               System.out.println("����������" + n);
            } else {
               System.out.println("����ʧ�ܣ�����ͻ���Ż����п��ţ�" );
            }
        }
    }

}
