import java.sql.*;
import java.util.Scanner;

public class Transfer {
    static final String JDBC_DRIVER = "com.mysql.cj.jdbc.Driver";
    static final String DB_URL = "jdbc:mysql://127.0.0.1:3306/finance?allowPublicKeyRetrieval=true&useUnicode=true&characterEncoding=UTF8&useSSL=false&serverTimezone=UTC";
    static final String USER = "root";
    static final String PASS = "123123";
    /**
     * ת�˲���
     *
     * @param connection ���ݿ����Ӷ���
     * @param sourceCard ת���˺�
     * @param destCard ת���˺�
     * @param amount  ת�˽��
     * @return boolean
     *   true  - ת�˳ɹ�
     *   false - ת��ʧ��
     */
    public static boolean transferBalance(Connection connection,
                             String sourceCard,
                             String destCard, 
                             double amount)
    {
         PreparedStatement preparedStatement=null;
         ResultSet resultSet = null;
         String sql;
         
         try
         {
            //�ı�ȱʡ���� �����Զ��ύ
            connection.setAutoCommit(false);
            //��ѯ
            int flag=0;
            //��ѯת���˺�
            sql = "select * from bank_card where  b_number = '" + destCard + "';";
            preparedStatement = connection.prepareStatement(sql);
            resultSet=preparedStatement.executeQuery(sql);
            //ת���˺Ų�����
            if(!resultSet.next())
                return false;
            //ת���˺�Ϊ���ÿ�
            if(resultSet.getString("b_type").equals("���ÿ�"))
                flag=1;
            //��ѯת���˺�
            sql = "select * from bank_card where  b_number = '" + sourceCard + "';";
            preparedStatement = connection.prepareStatement(sql);
            resultSet=preparedStatement.executeQuery(sql);
            //ת���˺Ų�����
            if(!resultSet.next())
                return false;
            //ת���˺������ÿ�
            if(resultSet.getString("b_type").equals("���ÿ�"))
            {
              return false;
            }
            //ת���˺�����
            if(resultSet.getDouble("b_balance")<amount)
                return false;
            //ת��
            sql="update bank_card set b_balance=b_balance-? where b_number=?;";
            preparedStatement = connection.prepareStatement(sql);
            preparedStatement.setDouble(1, amount); 
            preparedStatement.setString(2, sourceCard); 
            preparedStatement.executeUpdate();
            //ת��
            //ת��Ϊ���ÿ�
            if(flag==1)
                sql="update bank_card set b_balance=b_balance-? where b_number=?";
            else
                sql="update bank_card set b_balance=b_balance+? where b_number=?";
            preparedStatement = connection.prepareStatement(sql);
            preparedStatement.setDouble(1, amount);
            preparedStatement.setString(2, destCard); 
            preparedStatement.executeUpdate();
            connection.commit();
            return true; 
         }
        catch (SQLException e) 
        {
		    e.printStackTrace();
		} 
        return true;


    }
    // ��Ҫ�޸�main() 
    public static void main(String[] args) throws Exception 
    {

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
            String payerCard = commands[0];
            String  payeeCard = commands[1];
            double  amount = Double.parseDouble(commands[2]);
            if (transferBalance(connection, payerCard, payeeCard, amount)) {
              System.out.println("ת�˳ɹ���" );
            } else {
              System.out.println("ת��ʧ��,��˶Կ��ţ������ͼ������!");
            }
        }
    }

}
