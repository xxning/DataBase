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
			System.out.println("��oracle���ݿ�����ʧ�ܣ�");
		else
			System.out.println("��oracle���ݿ����ӳɹ���");
		
		stmt=conn.createStatement();
		int Chose;
		System.out.println("����������֣�");
		String input;
		input=in.next();
		int Log=1;
		ps=conn.prepareStatement("select * from CUSTOMERS where custName=?");
		ps.setString(1, input);
		rs=ps.executeQuery();
		if(rs.next()){
			System.out.println("�ɹ���½");
		}
		else{
			System.out.println("��½ʧ��,�Ƿ�ע�᣿ 1.�� ��2��");
			Chose=in.nextInt();
			if(Chose==1){
				System.out.print("������ע������");
				input=in.next();
				ps=conn.prepareStatement("insert into CUSTOMERS values(?)");
				ps.setString(1, input);
				rs=ps.executeQuery();
				System.out.println("ע��ɹ���");
			}
			else{
				Log=0;
				in.close();
				System.out.println("�˳���");
				return;
			}
			
		}
		//����FLIGHTS��
		String flightNum,FromCity,ArivCity;
		int price,numSeats,numAvail;
		//����HOTELS��
		//int price,numAvail;
		String location;	
		int numRooms;
		//����CARS��
		//String location;
		//int price,numAvail;
		int numCars;
		//����CUSTOMERS��
		String Name;
		//����RESERVATIONS��
		int resvType;
		String resvKey;
		long RK;
		while(Log==1){
			System.out.println("ѡ���ܣ�1.���롣2.����  3.��ѯ 4.Ԥ�� 5.ȡ��Ԥ�� 6.�˳�");
			Chose=in.nextInt();
			switch(Chose){
				case 1:{
					System.out.println("��ѡ����Ҫ����Ķ���1.FLIGHTS 2.HOTELS 3.CARS 4.CUSTOMERS");
					Chose=in.nextInt();
					switch(Chose){
						case 1:{
							System.out.println("������Ԫ��:flightNum+price+numSeat+numAvail+FromCity+ArivCity");
							//�м��ÿո�ֿ����س�����
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
							System.out.println("����ɹ���");
							break;
						}
						case 2:{
							System.out.println("������Ԫ��:location+price+numRooms+numAvail");
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
							System.out.println("����ɹ���");
							break;
						}
						case 3:{
							System.out.println("������Ԫ��:location+price+numCars+numAvail");
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
							System.out.println("����ɹ���");
							break;
						}
						case 4:{
							System.out.print("����Ҫ��ӵ��û�����");
							Name=in.next();
							ps=conn.prepareStatement("insert into CUSTOMERS values(?)");
							ps.setString(1, Name);
							rs=ps.executeQuery();
							System.out.println("����ɹ���");
							break;
						}
						default:{
							System.out.println("��������ȷ��ѡ��");
							break;
						}
					}
					break;
				}
				case 2:{			
					System.out.println("��ѡ����Ҫ���µĶ���1.FLIGHTS 2.HOTELS 3.CARS ");
					Chose=in.nextInt();
					switch(Chose){
						case 1:{
							rs=stmt.executeQuery("select * from FLIGHTS");
							if(!rs.next()){
								System.out.println("�ñ�Ϊ�գ�");
								break;
							}
							System.out.println("flightNum+price+numSeat+numAvail+FromCity+ArivCity");
							System.out.println(rs.getString("flightNum")+" "+rs.getInt("price")+" "+rs.getInt("numSeats")+" "
									+" "+rs.getInt("numAvail")+" "+rs.getString("FromCity")+"��"+rs.getString("ArivCity"));
							while(rs.next()){
								System.out.println(rs.getString("flightNum")+" "+rs.getInt("price")+" "+rs.getInt("numSeats")+" "
										+" "+rs.getInt("numAvail")+" "+rs.getString("FromCity")+"��"+rs.getString("ArivCity"));
							}
							System.out.print("��������Ҫ�޸ĵ�flightNum");
							flightNum=in.next();
							//֮���ÿո����
							System.out.println("�������޸����ݣ�price+numSeats+numAvail+FromCity+ArivCity");
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
							System.out.println("���³ɹ���");
							break;
						}
						case 2:{
							rs=stmt.executeQuery("select * from HOTELS");
							if(!rs.next()){
								System.out.println("�ñ�Ϊ�գ�");
								break;
							}
							System.out.println("location+price+numRooms+numAvail");
							System.out.println(rs.getString("city")+" "+rs.getInt("price")+" "+rs.getInt("numRooms")+" "
									+" "+rs.getInt("numAvail"));
							while(rs.next()){
								System.out.println(rs.getString("city")+" "+rs.getInt("price")+" "+rs.getInt("numRooms")+" "
										+" "+rs.getInt("numAvail"));
							}
							System.out.print("��������Ҫ�޸ĵ�location");
							location=in.next();
							//֮���ÿո����
							System.out.println("�������޸����ݣ�price+numRooms+numAvail");
							price=in.nextInt();
							numRooms=in.nextInt();
							numAvail=in.nextInt();
							ps=conn.prepareStatement("update HOTELS set price=?,numRooms=?,numAvail=? where city=?");
							ps.setInt(1, price);
							ps.setInt(2, numRooms);
							ps.setInt(3,numAvail);
							ps.setString(4,location);
							rs=ps.executeQuery();
							System.out.println("���³ɹ���");
							break;
						}
						case 3:{
							rs=stmt.executeQuery("select * from CAR");
							if(!rs.next()){
								System.out.println("�ñ�Ϊ�գ�");
								break;
							}
							System.out.println("location+price+numCars+numAvail");
							System.out.println(rs.getString("city")+" "+rs.getInt("price")+" "+rs.getInt("numCars")+" "
									+" "+rs.getInt("numAvail"));
							while(rs.next()){
								System.out.println(rs.getString("city")+" "+rs.getInt("price")+" "+rs.getInt("numCars")+" "
										+" "+rs.getInt("numAvail"));
							}
							System.out.print("��������Ҫ�޸ĵ�location");
							location=in.next();
							//֮���ÿո����
							System.out.println("�������޸����ݣ�price+numCars+numAvail");
							price=in.nextInt();
							numCars=in.nextInt();
							numAvail=in.nextInt();
							ps=conn.prepareStatement("update CAR set price=?,numCars=?,numAvail=? where city=?");
							ps.setInt(1, price);
							ps.setInt(2, numCars);
							ps.setInt(3,numAvail);
							ps.setString(4,location);
							rs=ps.executeQuery();
							System.out.println("���³ɹ���");
							break;
						}
						default:{
							System.out.println("��������ȷ��ѡ��");
							break;
						}
					}
					break;
				}
				case 3:{
					System.out.println("��������Ҫ��ѯ�����ݣ�1.FLIGHTS 2.HOTELS 3.CARS 4.CUSTOMERS 5.RESERVATIONS");
					Chose=in.nextInt();
					switch(Chose){
						case 1:{
							System.out.print("����FromCity��ArivCity��");
							FromCity=in.next();
							ArivCity=in.next();
							ps=conn.prepareStatement("select * from FLIGHTS where FromCity=? AND ArivCity=?");
							ps.setString(1, FromCity);
							ps.setString(2, ArivCity);
							rs=ps.executeQuery();
							if(!rs.next()){
								System.out.println("�޽����");
								break;
							}
							else{
								System.out.println("flightNum+price+numSeats+numAvail+FromCity+ArivCity");
								System.out.println(rs.getString("flightNum")+" "+rs.getInt("price")+" "+rs.getInt("numSeats")+" "
										+" "+rs.getInt("numAvail")+" "+rs.getString("FromCity")+"��"+rs.getString("ArivCity"));
								while(rs.next()){
									System.out.println(rs.getString("flightNum")+" "+rs.getInt("price")+" "+rs.getInt("numSeats")+" "
											+" "+rs.getInt("numAvail")+" "+rs.getString("FromCity")+"��"+rs.getString("ArivCity"));
								}
							}
							break;
						}
						case 2:{
							System.out.print("����location��");							
							location=in.next();
							ps=conn.prepareStatement("select * from HOTELS where City=?");
							ps.setString(1, location);
							rs=ps.executeQuery();
							if(!rs.next()){
								System.out.println("�޽����");
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
							System.out.print("����location��");							
							location=in.next();
							ps=conn.prepareStatement("select * from CAR where City=?");
							ps.setString(1, location);
							rs=ps.executeQuery();
							if(!rs.next()){
								System.out.println("�޽����");
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
								System.out.println("�޽����");
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
								System.out.println("�޽����");
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
							System.out.println("��������ȷ��ѡ��");
							break;
						}
					}
					break;
				}
				case 4:{
					System.out.println("��ѡ����ҪԤ������Ŀ��1.FLIGHTS 2.HOTELS 3.CARS");
					Chose=in.nextInt();
					switch(Chose){
						case 1:{
							System.out.print("��ѡ����ҪԤ����flightNum��");
							flightNum=in.next();
							resvType=1;
							ps=conn.prepareStatement("select * from FLIGHTS where flightNum=?");
							ps.setString(1, flightNum);
							rs=ps.executeQuery();
							if(!rs.next()){
								System.out.println("�޴˺��࣬Ԥ��ʧ�ܣ�");
								break;
							}				
							if(rs.getInt("NumAvail")==0){
								System.out.println("��Ʊ���㣬Ԥ��ʧ�ܣ�");
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
							System.out.println("Ԥ���ɹ���");
							break;
						}
						case 2:{
							System.out.print("��ѡ����ҪԤ����location��");
							location=in.next();
							resvType=2;
							ps=conn.prepareStatement("select * from HOTELS where City=?");
							ps.setString(1,location);
							rs=ps.executeQuery();
							if(!rs.next()){
								System.out.println("�޴˳�����Ϣ��Ԥ��ʧ�ܣ�");
								break;
							}
							if(rs.getInt("NumAvail")==0){
								System.out.println("�޿շ��䣬Ԥ��ʧ�ܣ�");
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
							System.out.println("Ԥ���ɹ���");
							break;
						}
						case 3:{
							System.out.print("��ѡ����ҪԤ����location��");
							location=in.next();
							resvType=3;
							ps=conn.prepareStatement("select * from CAR where City=?");
							ps.setString(1,location);
							rs=ps.executeQuery();
							if(!rs.next()){
								System.out.println("�޴˳�����Ϣ��Ԥ��ʧ�ܣ�");
								break;
							}
							if(rs.getInt("NumAvail")==0){
								System.out.println("���ó�����Ԥ��ʧ�ܣ�");
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
							System.out.println("Ԥ���ɹ���");
							break;
						}
						default:{
							System.out.println("��������ȷ��ѡ��");
							break;
						}
					}
					break;
				}
				case 5:{
					System.out.println("��������Ҫȡ������������resvKey��");
					resvKey=in.next();
					ps=conn.prepareStatement("delete from RESERVATIONS where resvKey=?");
					ps.setString(1, resvKey);
					rs=ps.executeQuery();
					System.out.println("ȡ���ɹ���");
					break;
				}
				case 6:{
					System.out.println("��л����ʹ�ã�");
					in.close();
					return;
				}
				default:{
					System.out.println("��������ȷ��ѡ��");
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
