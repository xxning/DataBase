package myDB;

import java.sql.*;
import java.util.*;

public class myDB {
	//private static String url="jdbc:oracle:thin:@localhost:1521:LAB";
	//private static String user="xiaoning";
	//private static String password="xiaoning";
	//public static Connection conn;
	//public static PreparedStatement ps;
	//public static ResultSet rs;
	//public static Statement st;
	/*
	public void getConnection(){
		try{
			Class.forName("oracle.jdbc.driver.OracleDriver");
			conn=DriverManager.getConnection(url,user,password);
		} catch(Exception e){
			e.printStackTrace();
		}
	}
	*/
	public static void main(String[] args) throws SQLException {
		// TODO Auto-generated method stub
		//myDB basedao=new myDB();
		//basedao.getConnection();
		Scanner in = new Scanner(System.in);  
		Connection conn=null;
		ResultSet rs=null;
		Statement stmt=null;
		PreparedStatement ps=null;
		try{
			Class.forName("oracle.jdbc.driver.OracleDriver");			
			String url="jdbc:oracle:thin:@localhost:1521:LAB";
			String user="xiaoning";
			String password="xiaoning";
			conn=DriverManager.getConnection(url,user,password);

		} catch(Exception e){
			e.printStackTrace();
		}
		
		if(conn==null)	
			System.out.println("与oracle数据库连接失败！");
		else
			System.out.println("与oracle数据库连接成功！");
		
		stmt=conn.createStatement();
		int Chose;
		System.out.println("输入你的名字：");
		String input;
		input=in.next();
		int Log=1;
		ps=conn.prepareStatement("select * from CUSTOMERS where custName=?");
		ps.setString(1, input);
		rs=ps.executeQuery();
		if(rs.next()){
			System.out.println("成功登陆");
		}
		else{
			System.out.println("登陆失败,是否注册？ 1.是 ，2否");
			Chose=in.nextInt();
			if(Chose==1){
				System.out.print("输入你注册名：");
				input=in.next();
				ps=conn.prepareStatement("insert into CUSTOMERS values(?)");
				ps.setString(1, input);
				rs=ps.executeQuery();
				System.out.println("注册成功！");
			}
			else{
				Log=0;
				in.close();
				System.out.println("退出！");
				return;
			}
			
		}
		//用于FLIGHTS表
		String flightNum,FromCity,ArivCity;
		int price,numSeats,numAvail;
		//用于HOTELS表
		//int price,numAvail;
		String location;	
		int numRooms;
		//用于CARS表
		//String location;
		//int price,numAvail;
		int numCars;
		//用于CUSTOMERS表
		String Name;
		//用于RESERVATIONS表
		int resvType;
		String resvKey;
		long RK;
		while(Log==1){
			System.out.println("选择功能：1.插入。2.更新  3.查询 4.预定 5.取消预定 6.退出");
			Chose=in.nextInt();
			switch(Chose){
				case 1:{
					System.out.println("请选择你要插入的对象：1.FLIGHTS 2.HOTELS 3.CARS 4.CUSTOMERS");
					Chose=in.nextInt();
					switch(Chose){
						case 1:{
							System.out.println("输入六元组:flightNum+price+numSeat+numAvail+FromCity+ArivCity");
							//中间用空格分开，回车结束
							flightNum=in.next();
							price=in.nextInt();
							numSeats=in.nextInt();
							numAvail=in.nextInt();
							FromCity=in.next();
							ArivCity=in.next();
							ps=conn.prepareStatement("insert into FLIGHTS values(?,?,?,?,?,?)");
							ps.setString(1, flightNum);
							ps.setInt(2, price);
							ps.setInt(3, numSeats);
							ps.setInt(4,numAvail);
							ps.setString(5,FromCity);
							ps.setString(6,ArivCity);
							rs=ps.executeQuery();
							System.out.println("插入成功！");
							break;
						}
						case 2:{
							System.out.println("输入四元组:location+price+numRooms+numAvail");
							location=in.next();
							price=in.nextInt();
							numRooms=in.nextInt();
							numAvail=in.nextInt();
							ps=conn.prepareStatement("insert into HOTELS values(?,?,?,?)");
							ps.setString(1, location);
							ps.setInt(2, price);
							ps.setInt(3, numRooms);
							ps.setInt(4, numAvail);
							rs=ps.executeQuery();
							System.out.println("插入成功！");
							break;
						}
						case 3:{
							System.out.println("输入四元组:location+price+numCars+numAvail");
							location=in.next();
							price=in.nextInt();
							numCars=in.nextInt();
							numAvail=in.nextInt();
							ps=conn.prepareStatement("insert into CAR values(?,?,?,?)");
							ps.setString(1, location);
							ps.setInt(2, price);
							ps.setInt(3, numCars);
							ps.setInt(4, numAvail);
							rs=ps.executeQuery();
							System.out.println("插入成功！");
							break;
						}
						case 4:{
							System.out.print("输入要添加的用户名：");
							Name=in.next();
							ps=conn.prepareStatement("insert into CUSTOMERS values(?)");
							ps.setString(1, Name);
							rs=ps.executeQuery();
							System.out.println("插入成功！");
							break;
						}
						default:{
							System.out.println("请输入正确的选择！");
							break;
						}
					}
					break;
				}
				case 2:{			
					System.out.println("请选择你要更新的对象：1.FLIGHTS 2.HOTELS 3.CARS ");
					Chose=in.nextInt();
					switch(Chose){
						case 1:{
							rs=stmt.executeQuery("select * from FLIGHTS");
							if(!rs.next()){
								System.out.println("该表为空！");
								break;
							}
							System.out.println("flightNum+price+numSeat+numAvail+FromCity+ArivCity");
							System.out.println(rs.getString("flightNum")+" "+rs.getInt("price")+" "+rs.getInt("numSeats")+" "
									+" "+rs.getInt("numAvail")+" "+rs.getString("FromCity")+"　"+rs.getString("ArivCity"));
							while(rs.next()){
								System.out.println(rs.getString("flightNum")+" "+rs.getInt("price")+" "+rs.getInt("numSeats")+" "
										+" "+rs.getInt("numAvail")+" "+rs.getString("FromCity")+"　"+rs.getString("ArivCity"));
							}
							System.out.print("请输入你要修改的flightNum");
							flightNum=in.next();
							//之间用空格隔开
							System.out.println("请输入修改内容：price+numSeats+numAvail+FromCity+ArivCity");
							price=in.nextInt();
							numSeats=in.nextInt();
							numAvail=in.nextInt();
							FromCity=in.next();
							ArivCity=in.next();
							ps=conn.prepareStatement("update FLIGHTS set price=?,numSeats=?,numAvail=?,FromCity=?,ArivCity=? where flightNum=?");
							ps.setInt(1, price);
							ps.setInt(2, numSeats);
							ps.setInt(3,numAvail);
							ps.setString(4,FromCity);
							ps.setString(5,ArivCity);
							ps.setString(6, flightNum);
							rs=ps.executeQuery();
							System.out.println("更新成功！");
							break;
						}
						case 2:{
							rs=stmt.executeQuery("select * from HOTELS");
							if(!rs.next()){
								System.out.println("该表为空！");
								break;
							}
							System.out.println("location+price+numRooms+numAvail");
							System.out.println(rs.getString("city")+" "+rs.getInt("price")+" "+rs.getInt("numRooms")+" "
									+" "+rs.getInt("numAvail"));
							while(rs.next()){
								System.out.println(rs.getString("city")+" "+rs.getInt("price")+" "+rs.getInt("numRooms")+" "
										+" "+rs.getInt("numAvail"));
							}
							System.out.print("请输入你要修改的location");
							location=in.next();
							//之间用空格隔开
							System.out.println("请输入修改内容：price+numRooms+numAvail");
							price=in.nextInt();
							numRooms=in.nextInt();
							numAvail=in.nextInt();
							ps=conn.prepareStatement("update HOTELS set price=?,numRooms=?,numAvail=? where city=?");
							ps.setInt(1, price);
							ps.setInt(2, numRooms);
							ps.setInt(3,numAvail);
							ps.setString(4,location);
							rs=ps.executeQuery();
							System.out.println("更新成功！");
							break;
						}
						case 3:{
							rs=stmt.executeQuery("select * from CAR");
							if(!rs.next()){
								System.out.println("该表为空！");
								break;
							}
							System.out.println("location+price+numCars+numAvail");
							System.out.println(rs.getString("city")+" "+rs.getInt("price")+" "+rs.getInt("numCars")+" "
									+" "+rs.getInt("numAvail"));
							while(rs.next()){
								System.out.println(rs.getString("city")+" "+rs.getInt("price")+" "+rs.getInt("numCars")+" "
										+" "+rs.getInt("numAvail"));
							}
							System.out.print("请输入你要修改的location");
							location=in.next();
							//之间用空格隔开
							System.out.println("请输入修改内容：price+numCars+numAvail");
							price=in.nextInt();
							numCars=in.nextInt();
							numAvail=in.nextInt();
							ps=conn.prepareStatement("update CAR set price=?,numCars=?,numAvail=? where city=?");
							ps.setInt(1, price);
							ps.setInt(2, numCars);
							ps.setInt(3,numAvail);
							ps.setString(4,location);
							rs=ps.executeQuery();
							System.out.println("更新成功！");
							break;
						}
						default:{
							System.out.println("请输入正确的选择！");
							break;
						}
					}
					break;
				}
				case 3:{
					System.out.println("请输入你要查询的内容：1.FLIGHTS 2.HOTELS 3.CARS 4.CUSTOMERS 5.RESERVATIONS");
					Chose=in.nextInt();
					switch(Chose){
						case 1:{
							System.out.print("输入FromCity和ArivCity：");
							FromCity=in.next();
							ArivCity=in.next();
							ps=conn.prepareStatement("select * from FLIGHTS where FromCity=? AND ArivCity=?");
							ps.setString(1, FromCity);
							ps.setString(2, ArivCity);
							rs=ps.executeQuery();
							if(!rs.next()){
								System.out.println("无结果！");
								break;
							}
							else{
								System.out.println("flightNum+price+numSeats+numAvail+FromCity+ArivCity");
								System.out.println(rs.getString("flightNum")+" "+rs.getInt("price")+" "+rs.getInt("numSeats")+" "
										+" "+rs.getInt("numAvail")+" "+rs.getString("FromCity")+"　"+rs.getString("ArivCity"));
								while(rs.next()){
									System.out.println(rs.getString("flightNum")+" "+rs.getInt("price")+" "+rs.getInt("numSeats")+" "
											+" "+rs.getInt("numAvail")+" "+rs.getString("FromCity")+"　"+rs.getString("ArivCity"));
								}
							}
							break;
						}
						case 2:{
							System.out.print("输入location：");							
							location=in.next();
							ps=conn.prepareStatement("select * from HOTELS where City=?");
							ps.setString(1, location);
							rs=ps.executeQuery();
							if(!rs.next()){
								System.out.println("无结果！");
								break;
							}
							else{
								System.out.println("location+price+numRooms+numAvail");
								System.out.println(rs.getString("city")+" "+rs.getInt("price")+" "+rs.getInt("numRooms")+" "
										+" "+rs.getInt("numAvail"));
								while(rs.next()){
									System.out.println(rs.getString("city")+" "+rs.getInt("price")+" "+rs.getInt("numRooms")+" "
											+" "+rs.getInt("numAvail"));
								}
							}
							break;						
						}
						case 3:{
							System.out.print("输入location：");							
							location=in.next();
							ps=conn.prepareStatement("select * from CAR where City=?");
							ps.setString(1, location);
							rs=ps.executeQuery();
							if(!rs.next()){
								System.out.println("无结果！");
								break;
							}
							else{
								System.out.println("location+price+numCars+numAvail");
								System.out.println(rs.getString("city")+" "+rs.getInt("price")+" "+rs.getInt("numCars")+" "
										+" "+rs.getInt("numAvail"));
								while(rs.next()){
									System.out.println(rs.getString("city")+" "+rs.getInt("price")+" "+rs.getInt("numCars")+" "
											+" "+rs.getInt("numAvail"));
								}
							}
							break;
						}
						case 4:{
							rs=stmt.executeQuery("select * from CUSTOMERS");
							if(!rs.next()){
								System.out.println("无结果！");
								break;
							}				
							else{
								System.out.println("custName");
								System.out.println(rs.getString("custName"));
								while(rs.next()){
									System.out.println(rs.getString("custName"));
								}
							}
							break;
						}
						case 5:{
							ps=conn.prepareStatement("select * from RESERVATIONS where custName=?");
							ps.setString(1, input);
							rs=ps.executeQuery();
							if(!rs.next()){
								System.out.println("无结果！");
								break;
							}
							else{
								System.out.println("custName+resvType+resvKey");
								System.out.println(rs.getString("custName")+" "+rs.getInt("resvType")+" "+rs.getString("resvKey"));
								while(rs.next()){
									System.out.println(rs.getString("custName")+" "+rs.getInt("resvType")+" "+rs.getString("resvKey"));
								}
							}
							break;
							
						}
						default:{
							System.out.println("请输入正确的选择！");
							break;
						}
					}
					break;
				}
				case 4:{
					System.out.println("请选择你要预定的项目：1.FLIGHTS 2.HOTELS 3.CARS");
					Chose=in.nextInt();
					switch(Chose){
						case 1:{
							System.out.print("请选择你要预定的flightNum：");
							flightNum=in.next();
							resvType=1;
							ps=conn.prepareStatement("select * from FLIGHTS where flightNum=?");
							ps.setString(1, flightNum);
							rs=ps.executeQuery();
							if(!rs.next()){
								System.out.println("无此航班，预定失败！");
								break;
							}				
							if(rs.getInt("NumAvail")==0){
								System.out.println("余票不足，预定失败！");
								break;
							}
							ps=conn.prepareStatement("update FLIGHTS set NumAvail=NumAvail-1 where flightNum=?");
							ps.setString(1, flightNum);
							rs=ps.executeQuery();
							RK=System.currentTimeMillis();
							resvKey="RK"+RK+"_"+flightNum;
							ps=conn.prepareStatement("insert into RESERVATIONS values(?,?,?)");
							ps.setString(1, input);
							ps.setInt(2, resvType);
							ps.setString(3, resvKey);
							rs=ps.executeQuery();
							System.out.println("预定成功！");
							break;
						}
						case 2:{
							System.out.print("请选择你要预定的location：");
							location=in.next();
							resvType=2;
							ps=conn.prepareStatement("select * from HOTELS where City=?");
							ps.setString(1,location);
							rs=ps.executeQuery();
							if(!rs.next()){
								System.out.println("无此城市信息，预定失败！");
								break;
							}
							if(rs.getInt("NumAvail")==0){
								System.out.println("无空房间，预定失败！");
								break;
							}
							ps=conn.prepareStatement("update HOTELS set NumAvail=NumAvail-1 where City=?");
							ps.setString(1, location);
							rs=ps.executeQuery();
							RK=System.currentTimeMillis();
							resvKey="RK"+RK+"_"+location;
							ps=conn.prepareStatement("insert into RESERVATIONS values(?,?,?)");
							ps.setString(1, input);
							ps.setInt(2, resvType);
							ps.setString(3, resvKey);
							rs=ps.executeQuery();
							System.out.println("预定成功！");
							break;
						}
						case 3:{
							System.out.print("请选择你要预定的location：");
							location=in.next();
							resvType=3;
							ps=conn.prepareStatement("select * from CAR where City=?");
							ps.setString(1,location);
							rs=ps.executeQuery();
							if(!rs.next()){
								System.out.println("无此城市信息，预定失败！");
								break;
							}
							if(rs.getInt("NumAvail")==0){
								System.out.println("可用车辆，预定失败！");
								break;
							}
							ps=conn.prepareStatement("update CAR set NumAvail=NumAvail-1 where City=?");
							ps.setString(1, location);
							rs=ps.executeQuery();
							RK=System.currentTimeMillis();
							resvKey="RK"+RK+"_"+location;
							ps=conn.prepareStatement("insert into RESERVATIONS values(?,?,?)");
							ps.setString(1, input);
							ps.setInt(2, resvType);
							ps.setString(3, resvKey);
							rs=ps.executeQuery();
							System.out.println("预定成功！");
							break;
						}
						default:{
							System.out.println("请输入正确的选择！");
							break;
						}
					}
					break;
				}
				case 5:{
					System.out.println("请输入你要取消订单的完整resvKey！");
					resvKey=in.next();
					ps=conn.prepareStatement("delete from RESERVATIONS where resvKey=?");
					ps.setString(1, resvKey);
					rs=ps.executeQuery();
					System.out.println("取消成功！");
					break;
				}
				case 6:{
					System.out.println("感谢您的使用！");
					in.close();
					return;
				}
				default:{
					System.out.println("请输入正确的选择！");
					break;
				}
			}
			
		}
		//rs=stmt.executeQuery("select * from sumofcalo");
		//while(rs.next()){
		//	System.out.println(rs.getString("food")+" "+rs.getString("sumofca"));
		//}
	}
}
