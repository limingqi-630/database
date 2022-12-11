import java.sql.*;
import java.util.Scanner;

public class Transfer {
    static final String JDBC_DRIVER = "com.mysql.cj.jdbc.Driver";
    static final String DB_URL = "jdbc:mysql://127.0.0.1:3306/finance?allowPublicKeyRetrieval=true&useUnicode=true&characterEncoding=UTF8&useSSL=false&serverTimezone=UTC";
    static final String USER = "root";
    static final String PASS = "123123";
    /**
     * 转账操作
     *
     * @param connection 数据库连接对象
     * @param sourceCard 转出账号
     * @param destCard 转入账号
     * @param amount  转账金额
     * @return boolean
     *   true  - 转账成功
     *   false - 转账失败
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
            //改变缺省设置 不再自动提交
            connection.setAutoCommit(false);
            //查询
            int flag=0;
            //查询转入账号
            sql = "select * from bank_card where  b_number = '" + destCard + "';";
            preparedStatement = connection.prepareStatement(sql);
            resultSet=preparedStatement.executeQuery(sql);
            //转入账号不存在
            if(!resultSet.next())
                return false;
            //转入账号为信用卡
            if(resultSet.getString("b_type").equals("信用卡"))
                flag=1;
            //查询转出账号
            sql = "select * from bank_card where  b_number = '" + sourceCard + "';";
            preparedStatement = connection.prepareStatement(sql);
            resultSet=preparedStatement.executeQuery(sql);
            //转出账号不存在
            if(!resultSet.next())
                return false;
            //转出账号是信用卡
            if(resultSet.getString("b_type").equals("信用卡"))
            {
              return false;
            }
            //转出账号余额不足
            if(resultSet.getDouble("b_balance")<amount)
                return false;
            //转出
            sql="update bank_card set b_balance=b_balance-? where b_number=?;";
            preparedStatement = connection.prepareStatement(sql);
            preparedStatement.setDouble(1, amount); 
            preparedStatement.setString(2, sourceCard); 
            preparedStatement.executeUpdate();
            //转入
            //转入为信用卡
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
    // 不要修改main() 
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
              System.out.println("转账成功。" );
            } else {
              System.out.println("转账失败,请核对卡号，卡类型及卡余额!");
            }
        }
    }

}
