%{
#include <stdio.h>
#include <string>
#include <cstring>
#include <stdlib.h>
#define DEBUG
#include "node.hh"
#include "util.hh"
#include "global.hh"
extern int yylex ();
extern void yyerror (const char *msg);
InputNode *root;
FILE *fp=NULL;
FILE *fpp=NULL;
FILE *fpc=NULL;
int debug=0;
%}

%union
{
    int  num;
    std::string *var;
    Node *node;
}

%token num_tok var_tok eol_tok err_tok
%token CREATE INTO TABLE INSERT DISPLAY CONSTRAIN 
%token DELETE UPDATE PRIMARY KEY FROM WHERE
%token <var> INT VARCHAR

%token <num> NUMBER
%token <var> IDENTIFIER EQ UE LE GE LT GT
%type <var> OP Type
%type <node> command Values Decl Val Dec
%type <node> input line 

%locations

%%
input : /* empty */     {   
							if(debug)
								debug ("input ::= empty\n"); 
                            root = new InputNode ();
                        }
      | input line      {   
							if(debug)							
								debug ("input ::= input line\n"); 
                            //if ($2!=NULL)   // ignore empty line
                                root->append ((LineNode*)$2);
                        }
      ;

line : eol_tok          {   
							if(debug)
								debug ("line ::= eol\n");
                            $$ = NULL;
                        }
     | command ';' eol_tok {   
							if(debug)							
								debug ("line ::= command eol\n");
                            $$ = new LineNode ((Node*)$1);
                        }
     ;

command : CREATE TABLE IDENTIFIER '{' Decl '}' PRIMARY KEY IDENTIFIER
		{
			if(debug)
				debug ("command :: create table identifier {} primary key id\n");
			$$=new CretableNode($3,(DeclistNode*)$5,$9);
	
			string path="./table/define/";
			
			//path.append(*$3);printf("yes4\n");
			//path.append(".txt");printf("yes5\n");
			char pt[64];
			int i=0;
			
			while(path[i]!='\0'){
				pt[i]=path[i];
				i++;
			}
			pt[i]='\0';
			strcat(pt,$3->c_str());
			strcat(pt,".txt");
			fpp=fopen(pt,"r");
			if(fpp!=NULL)
				warning("table:%s has alread exist.\n",$3->c_str());
			else{
				//检查primary 是否存在
				int res,index=0,match=0;
				for(DecNode *Dec : ((DeclistNode*)$5)->Dec_nodes){
						index++;
						res=strcmp((Dec->name)->c_str(),$9->c_str());
						if(res==0){
							match=1;
							break;
						}
				}
				if(match==0){
					warning("error:the primary key is not exist.\n");
				}
				else{			
				//fclose(fpp);printf("yes1\n");
					fp=fopen(pt,"w");
					if(fp==NULL)
						warning("error!\n");
					else{
						//printf("aaa\n");
						fprintf(fp,"%s\n",$3->c_str());
						fprintf(fp,"%s %d\n",$9->c_str(),index);
						fprintf(fp,"%d\n",0);
						for(DecNode *Dec : ((DeclistNode*)$5)->Dec_nodes){
							fprintf(fp,"%s %s\n",(Dec->name)->c_str(),(Dec->type)->c_str());			
						}
					/*
					for(std::vector<DecNode*>::iterator iter=(((DeclistNode*)$5)->Dec_nodes).begin();iter!=(((DeclistNode*)$5)->Dec_nodes).end();iter++)
						fprintf(fp,"%s %s\n",(iter->name)->c_str(),(iter->type)->c_str());	*/	
						fclose(fp);
					}
				}
			}
		}
	| CREATE TABLE IDENTIFIER '{' Decl '}' PRIMARY KEY IDENTIFIER FOREIGN KEY IDENTIFIER REFERENCE IDENTIFIER
		{
			if(debug)
				debug ("command :: create table identifier {} primary key id foreign key id reference id\n");
			$$=new CretableNode($3,(DeclistNode*)$5,$9);
	
			string path="./table/define/";
			
			//path.append(*$3);printf("yes4\n");
			//path.append(".txt");printf("yes5\n");
			char pt[64];
			int i=0;
			
			while(path[i]!='\0'){
				pt[i]=path[i];
				i++;
			}
			pt[i]='\0';
			strcat(pt,$3->c_str());
			strcat(pt,".txt");
			fpp=fopen(pt,"r");
			if(fpp!=NULL)
				warning("table:%s has alread exist.\n",$3->c_str());
			else{
				//检查primary 是否存在
				int res,index=0,match=0;
				for(DecNode *Dec : ((DeclistNode*)$5)->Dec_nodes){
						index++;
						res=strcmp((Dec->name)->c_str(),$9->c_str());
						if(res==0){
							match=1;
							break;
						}
				}
				if(match==0){
					warning("error:the primary key is not exist.\n");
				}
				else{			
				//fclose(fpp);printf("yes1\n");
					path.append($14->c_str());
					fp=fopen(path,"r");
					if(fp==NULL){
						warning("error:the reference table is not exist.\n");
					}
					else{
						char a[32];
						fscanf(fp,"%s",a);
						fscanf(fp,"%s",a);
						int res;
						res=strcmp(a,$12->c_str());
						if(res!=0){
							warning("error:foreign key is illegal.\n");
						}
						else{
							fp=fopen(pt,"w");
							if(fp==NULL)
								warning("error!\n");
							else{
								//printf("aaa\n");
						
								fprintf(fp,"%s\n",$3->c_str());
								fprintf(fp,"%s %d\n",$9->c_str(),index);
								fprintf(fp,"%d\n",1);
								fprintf(fp,"%s\n",$14->c_str());
								for(DecNode *Dec : ((DeclistNode*)$5)->Dec_nodes){
									fprintf(fp,"%s %s\n",(Dec->name)->c_str(),(Dec->type)->c_str());			
								}		
							}
						}
					
					/*
					for(std::vector<DecNode*>::iterator iter=(((DeclistNode*)$5)->Dec_nodes).begin();iter!=(((DeclistNode*)$5)->Dec_nodes).end();iter++)
						fprintf(fp,"%s %s\n",(iter->name)->c_str(),(iter->type)->c_str());	*/	
						
					}
				}
			}
			if(fp!=NULL)
				fclose(fp);
		}
	| INSERT INTO IDENTIFIER '(' Values ')' 
		{   
			if(debug)	
				debug("command :: insert into indentifier ()\n");
			$$=new InsertNode($3,(ValuesListNode*)$5);
			string path="./table/define/";
			string path1="./table/content/";
			string path2="./table/constrain/";
			char pt[64],pt1[64],pt2[64];
			int i=0;
			while(path[i]!='\0'){
				pt[i]=path[i];
				i++;
			}
			pt[i]='\0';
			strcat(pt,$3->c_str());
			strcat(pt,".txt");
			i=0;
			while(path1[i]!='\0'){
				pt1[i]=path1[i];
				i++;	
			}
			pt1[i]='\0';
			strcat(pt1,$3->c_str());
			strcat(pt1,".txt");
			i=0;
			while(path2[i]!='\0'){
				pt2[i]=path2[i];
				i++;	
			}
			pt2[i]='\0';
			strcat(pt2,$3->c_str());
			strcat(pt2,".txt");
			fpp=fopen(pt,"r");
			fpc=fopen(pt2,"r");
			if(fpp==NULL){
				warning("error:table is not exist.\n");
			}
			else{
				char s[32],fk[32];
				int flag=0;
				fscanf(fpp,"%s",s);
				fscanf(fpp,"%s",s);
				fscanf(fpp,"%s",s);
				int m=-1;
				fscanf(fpp,"%d",&m);
				if(m==1){
					fscanf(fpp,"%s",fk);
				}
				for(ValNode *Val : ((ValuesListNode*)$5)->Val_nodes){
					fscanf(fpp,"%s",s);
					fscanf(fpp,"%s",s);
					if((s[0]=='i'&&Val->type==2)||(s[0]=='v'&&Val->type==1))
						continue;
					else {
						flag=1;
						break;
					}
				}
				if(flag==1){
					warning("error:unmatched arguments\n");
				}
				else{
					if(fpc==NULL){
						//fp=fopen(pt1,"a+");
						int k=0,index,type=-1,val,check=1;
						char ck[32],str[32];
						str[0]='\0';
						rewind(fpp);
						fscanf(fpp,"%s",ck);
						fscanf(fpp,"%s",ck);
						fscanf(fpp,"%d",&index);
						for(ValNode *Val : ((ValuesListNode*)$5)->Val_nodes){
							k++;//printf("index:%d\n",index);
							if(k==index){							
								if(Val->type==1){
									strcpy(str,(Val->name)->c_str());
									//printf(":::%s\n",str);
									type=1;					
								}
								else if(Val->type==2){
									val=Val->val;
									type=2;
								}
							}
						}
						fp=fopen(pt1,"r");
						if(fp==NULL){
							//output
							check=1;
						}
						else{
							char c=0;
							int i=1,res=-1,val1;
							char str1[32];
							fscanf(fp,"%c",&c);
							//printf("%d\n",index);
							while(c!=0){
								if(c==' ')
									i++;
								if(c=='\n')
									i=1;
								if(i==index){
									if(type==1){
										fscanf(fp,"%s",str1);
										//printf("%s\n",str);
										res=strcmp(str1,str);
										if(res==0){
											check=0;
											break;
										}
									}
									else if(type==2){
										fscanf(fp,"%d",&val1);
										if(val==val1){
											check=0;
											break;
										}
									}
								}
								c=0;
								fscanf(fp,"%c",&c);
							}
						}
						if(check==0){
							warning("redundance:can't be inserted.\n");
						}
						else{	
							//printf("yes\n");
							if(m==1){
								//外键完整************************************
								string pfk="./table/defin/";
								pfk.append(fk);
								char ans[32],ind,res;
								fpc=fopen(pfk,"r");
								fscanf(fpc,"%s",ans);
								fscanf(fpc,"%s",ans);
								fscanf(fpc,"%d",&ind);
								string pfkk="./table/content/";
								pfkk.append(fk);
								fclose(fpc);
								fpc=fopen(pfkk,"r");	
								if(fpc==NULL){
									warning("error:can't be insert due to foreign key.\n");
								}
								else{
									int find=0,i=1;
									char f;
									int num;
									char id[32];
									fscanf(fp,"%c",&f);
									while(f!=0){
										if(f==' ')
											i++;
										if(f=='\n'){
											i=1;
										}
										if(i==ind){
											
											if(type==1){
												fscanf(fp,"%s",id);
												res=strcmp(id,str);
												if(res==0){
													find=1;
													break;
												}
											}
											else if(type==2){
												fscanf(fp,"%d",&num);
												if(val==num){
													find=1;
													break;
												}
											}
										}
										c=0;
										fscanf(fp,"%c",&f);
									}
									if(find==0){
										warning("error:can't be insert due to foreign key.\n");
									}
									else{
										fp=fopen(pt1,"a+");	
								
										for(ValNode *Val : ((ValuesListNode*)$5)->Val_nodes){
											if(Val->type==1){
												fprintf(fp,"%s ",(Val->name)->c_str());
											}
											else if(Val->type==2){
												fprintf(fp,"%d ",Val->val);
											}
										}
										fprintf(fp,"\n");//printf("yes\n");
									}
								}
							}
							else{
								fp=fopen(pt1,"a+");	
								
								for(ValNode *Val : ((ValuesListNode*)$5)->Val_nodes){
									if(Val->type==1){
										fprintf(fp,"%s ",(Val->name)->c_str());
									}
									else if(Val->type==2){
										fprintf(fp,"%d ",Val->val);
									}
								}
								fprintf(fp,"\n");//printf("yes\n");
							}
						}				
					}
					else{
						char att[32],op[3];
						int cons,index,i,value;
						int pass=1;
						fscanf(fpc,"%s %s %d %d",att,op,&cons,&index);
						while(att[0]!='\0'){
							i=0;
							for(ValNode *Val : ((ValuesListNode*)$5)->Val_nodes){
								i++;
								if(i==index){
									value=Val->val;
									break;
								}
							}
							switch(op[0]){
								case '=':{
									if(value!=cons)
										pass=0;
									break;
									}
								case '!':{
									if(value==cons)
										pass=0;
									break;
									}
								case '>':{
									if(op[1]=='='){
										if(value<cons)
											pass=0;
										break;
									}
									else{
										if(value<=cons)
											pass=0;
										break;
									}
								}
								case '<':{
									if(op[1]=='='){
										if(value>cons)
											pass=0;
										break;
									}
									else{
										if(value>=cons)
											pass=0;
										break;
									}
								}
								default:{
									printf("Unknown op.\n");
									break;
								}
							}
							if(pass==0)
								break;
							att[0]='\0';
							fscanf(fpc,"%s %s %d %d",att,op,&cons,&index);
						}
						if(pass==1){
							int k=0,index,type=-1,val,check=1;
							char ck[32],str[32];
							str[0]='\0';
							rewind(fpp);
							fscanf(fpp,"%s",ck);
							fscanf(fpp,"%s",ck);
							fscanf(fpp,"%d",&index);
							for(ValNode *Val : ((ValuesListNode*)$5)->Val_nodes){
								k++;//printf("index:%d\n",index);
								if(k==index){							
									if(Val->type==1){
										strcpy(str,(Val->name)->c_str());
										//printf(":::%s\n",str);
										type=1;					
									}
									else if(Val->type==2){
										val=Val->val;
										type=2;
									}
								}
							}
							fp=fopen(pt1,"r");
							if(fp==NULL){
								//output
								check=1;
							}
							else{
								char c=0;
								int i=1,res=-1,val1;
								char str1[32];
								fscanf(fp,"%c",&c);
								//printf("%d\n",index);
								while(c!=0){
									if(c==' ')
										i++;
									if(c=='\n')
										i=1;
									if(i==index){
										if(type==1){
											fscanf(fp,"%s",str1);
											//printf("%s\n",str);
											res=strcmp(str1,str);
											if(res==0){
												check=0;
												break;
											}
										}
										else if(type==2){
											fscanf(fp,"%d",&val1);
											if(val==val1){
												check=0;
												break;
											}
										}
									}
									c=0;
									fscanf(fp,"%c",&c);
								}
							}
							if(check==0){
								warning("redundance:can't be inserted.\n");
							}
							else{	
								//printf("yes\n");
								if(m==1){
									//外键完整************************************
									string pfk="./table/defin/";
									pfk.append(fk);
									char ans[32],ind,res;
									fpc=fopen(pfk,"r");
									fscanf(fpc,"%s",ans);
									fscanf(fpc,"%s",ans);
									fscanf(fpc,"%d",&ind);
									string pfkk="./table/content/";
									pfkk.append(fk);
									fclose(fpc);
									fpc=fopen(pfkk,"r");	
									if(fpc==NULL){
										warning("error:can't be insert due to foreign key.\n");
									}
									else{
										int find=0,i=1;
										char f;
										int num;
										char id[32];
										fscanf(fp,"%c",&f);
										while(f!=0){
											if(f==' ')
												i++;
											if(f=='\n'){
												i=1;
											}
											if(i==ind){
											
												if(type==1){
													fscanf(fp,"%s",id);
													res=strcmp(id,str);
													if(res==0){
														find=1;
														break;
													}
												}
												else if(type==2){
													fscanf(fp,"%d",&num);
													if(val==num){
														find=1;
														break;
													}
												}
											}
											c=0;
											fscanf(fp,"%c",&f);
										}
										if(find==0){
											warning("error:can't be insert due to foreign key.\n");
										}
										else{
											fp=fopen(pt1,"a+");	
								
											for(ValNode *Val : ((ValuesListNode*)$5)->Val_nodes){
												if(Val->type==1){
													fprintf(fp,"%s ",(Val->name)->c_str());
												}
												else if(Val->type==2){
													fprintf(fp,"%d ",Val->val);
												}
											}
											fprintf(fp,"\n");//printf("yes\n");
										}
									}
								}
								else{
									fp=fopen(pt1,"a+");	
								
									for(ValNode *Val : ((ValuesListNode*)$5)->Val_nodes){
										if(Val->type==1){
											fprintf(fp,"%s ",(Val->name)->c_str());
										}
										else if(Val->type==2){
											fprintf(fp,"%d ",Val->val);
										}
									}
									fprintf(fp,"\n");//printf("yes\n");
								}
							}
						}
						else{
							warning("can't insert:dissatisfy constrains!\n");
						}
						//检查约束限制
					}	
				}					
			}
			if(fpc!=NULL)		
				fclose(fpc);
			if(fp!=NULL)
				fclose(fp);
			if(fpp!=NULL)
				fclose(fpp);
		}
	| CONSTRAIN IDENTIFIER IDENTIFIER OP NUMBER 
		{
			if(debug)			
				debug("command :: constrain identifier id op num\n");
			$$=new ConstrainNode($2,$3,$4,$5);
			string path="./table/constrain/";
			string path1="./table/define/";
			char pt[64],pt1[64];
			int i=0;
			while(path[i]!='\0'){
				pt[i]=path[i];
				i++;
			}
			pt[i]='\0';
			strcat(pt,$2->c_str());
			strcat(pt,".txt");
			i=0;
			while(path1[i]!='\0'){
				pt1[i]=path1[i];
				i++;	
			}
			pt1[i]='\0';
			strcat(pt1,$2->c_str());
			strcat(pt1,".txt");
			fpp=fopen(pt,"a+");
			fp=fopen(pt1,"r");
			char a[32];
			fscanf(fp,"%s",a);
			fscanf(fp,"%s",a);
			fscanf(fp,"%s",a);
			int m=-1;
			fscanf(fpp,"%d",&m);
			if(m==1){
				fscanf(fpp,"%s",s);
			}
			fscanf(fp,"%s",a);
			int match=0;
			int res,index=0;
			while(a[0]!='\0'){
				//字符串比较	
				index++;
				res=strcmp(a,$3->c_str());
				if(res==0){
					fscanf(fp,"%s",a);
					if(a[0]=='i'){
						match=1;
						break;
					}
					else{
						fscanf(fp,"%s",a);
						continue;
					}
				}
				fscanf(fp,"%s",a);
				fscanf(fp,"%s",a);
			}
			if(match==1)
				fprintf(fpp,"%s %s %d %d\n",$3->c_str(),$4->c_str(),$5,index);
			if(fp!=NULL)
				fclose(fp);
			if(fpp!=NULL)
				fclose(fpp);
		}
	| DELETE FROM IDENTIFIER WHERE IDENTIFIER EQ Val
		{
			if(debug)
				debug("command :: delete from id where id = type\n");
			string pfk="./table/define";
			string path="./table/content/";
			string path1="./table/define/";
			pfk.append($3->c_str());	
			char pt[64],pt1[64];
			int i=0;
			while(path[i]!='\0'){
				pt[i]=path[i];
				i++;
			}
			pt[i]='\0';
			strcat(pt,$3->c_str());
			strcat(pt,".txt");
			i=0;
			while(path1[i]!='\0'){
				pt1[i]=path1[i];
				i++;	
			}
			pt1[i]='\0';
			strcat(pt1,$3->c_str());
			strcat(pt1,".txt");
			fpp=fopen(pt1,"r");
			if(fpp==NULL){
				warning("error:the table is not defined\n");
			}
			else{	
				char a[32],ck[32];
				int res=-1,val;
				fscanf(fpp,"%s",a);
				fscanf(fpp,"%s",a);
				res=strcmp(a,$5->c_str());
				if(res!=0){
					printf("error:%s is not a primary key of this table.\n",$5->c_str());
				}
				else{
					fp=fopen(pt,"r");
					if(fp==NULL){
						warning("error:the table is empty.\n");
					}
					else{
						int index,i,lineno=1,tag=0;
						char c=0;
						fscanf(fpp,"%d",&index);//printf("%d\n",index);
						i=1;
						fscanf(fp,"%c",&c);
						while(c!=0){
							if(c==' ')
								i++;
							if(c=='\n'){
								i=1;
								lineno++;
							}
							if(i==index){
								if(((ValNode*)$7)->type==1){
									fscanf(fp,"%s",ck);
									res=strcmp(ck,(((ValNode*)$7)->name)->c_str());
									if(res==0){
										tag=1;
										break;
									}
								}
								else if(((ValNode*)$7)->type==2){
									fscanf(fp,"%d",&val);
									if(val==((ValNode*)$7)->val){
										tag=1;
										break;
									}
								}
							}
							c=0;
							fscanf(fp,"%c",&c);
						}
						if(tag==0){
							warning("error:no such record.\n");
						}
						else{
							fpc=fopen(pfk,"r");
							fscanf(fpc,"%s",a);
							fscanf(fpc,"%s",a);
							fscanf(fpc,"%s",a);
							int m=-1;
							fscanf(fpc,"%d",&m);
							if(m==1){
								warning("error:can't be deleted due to foreign key.\n");
							}
							else{
								int length;
								fseek(fp,0,2);
								length=ftell(fp);
								char *buff;
								buff=(char*)malloc(sizeof(char)*length);
								char line[128];
								line[0]='\0';
								rewind(fp);
								i=1;
								//printf("%d\n",lineno);
								while(ftell(fp)<length-1){
									fgets(line,128,fp);
									if(lineno==i){
										i++;
										continue;
									}
									strcat(buff,line);
									i++;
								}
								fclose(fp);
								fp=fopen(pt,"w");
								fputs(buff,fp);
							}
						}
					}
				}
			}
			if(fpp!=NULL)
				fclose(fpp);
			if(fp!=NULL)
				fclose(fp);		
		////////////////////////////////////////		
			//fpp=fopen(pt,"a+");
			
			//fp=fopen(pt1,"r");
		}
	| UPDATE IDENTIFIER '(' Values ')' WHERE IDENTIFIER EQ Val
		{
			if(debug)
				debug("command :: update id () where id = type\n");
			string path="./table/content/";
			string path1="./table/define/";
			string path2="./table/constrain/";
			char pt[64],pt1[64],pt2[64];
			int i=0,correct=0;
			while(path[i]!='\0'){
				pt[i]=path[i];
				i++;
			}
			pt[i]='\0';
			strcat(pt,$2->c_str());
			strcat(pt,".txt");
			i=0;
			while(path1[i]!='\0'){
				pt1[i]=path1[i];
				i++;	
			}
			pt1[i]='\0';
			strcat(pt1,$2->c_str());
			strcat(pt1,".txt");
			i=0;
			while(path2[i]!='\0'){
				pt2[i]=path2[i];
				i++;	
			}
			pt2[i]='\0';
			strcat(pt2,$2->c_str());
			strcat(pt2,".txt");
			fpp=fopen(pt1,"r");
			if(fpp==NULL){
				warning("error:the table is not defined\n");
			}
			else{
				char a[32],ck[32];
				int res=-1,val;
				fscanf(fpp,"%s",a);
				fscanf(fpp,"%s",a);
				res=strcmp(a,$7->c_str());
				if(res!=0){
					printf("error:%s is not a primary key of this table.\n",$7->c_str());
				}
				else{
					fp=fopen(pt,"r");
					if(fp==NULL){
						warning("error:the table is empty.\n");
					}
					else{
						int index,i,lineno=1,tag=0;
						char c=0;
						fscanf(fpp,"%d",&index);//printf("%d\n",index);
						i=1;
						fscanf(fp,"%c",&c);
						while(c!=0){
							if(c==' ')
								i++;
							if(c=='\n'){
								i=1;
								lineno++;
							}
							if(i==index){
								if(((ValNode*)$9)->type==1){
									fscanf(fp,"%s",ck);
									res=strcmp(ck,(((ValNode*)$9)->name)->c_str());
									if(res==0){
										tag=1;
										break;
									}
								}
								else if(((ValNode*)$9)->type==2){
									fscanf(fp,"%d",&val);
									if(val==((ValNode*)$9)->val){
										tag=1;
										break;
									}
								}
							}
							c=0;
							fscanf(fp,"%c",&c);
						}
						if(tag==0){
							warning("error:no such record.\n");
						}
						else{
							//存在该记录..
							//验证插入值的合法性
						    char s[32],fk[32];
							int flag=0;
							fpp=fopen(pt1,"r");
							fscanf(fpp,"%s",s);
							fscanf(fpp,"%s",s);
							fscanf(fpp,"%s",s);
							int m=-1;
							fscanf(fpp,"%d",&m);
							if(m==1){
								fscanf(fpp,"%s",fk);
							}
							for(ValNode *Val : ((ValuesListNode*)$4)->Val_nodes){
								fscanf(fpp,"%s",s);
								fscanf(fpp,"%s",s);
								if((s[0]=='i'&&Val->type==2)||(s[0]=='v'&&Val->type==1))
									continue;
								else {
									flag=1;
									break;
								}
							}
							if(flag==1){
								warning("error:unmatched arguments\n");
							}
							else{
								fpc=fopen(pt2,"r");
								if(fpc==NULL){
									int k=0,index,type=-1,val,check=1;
									char ck[32],str[32];
									str[0]='\0';
									rewind(fpp);
									fscanf(fpp,"%s",ck);
									fscanf(fpp,"%s",ck);
									fscanf(fpp,"%d",&index);	
									for(ValNode *Val : ((ValuesListNode*)$4)->Val_nodes){
										k++;//printf("index:%d\n",index);
										if(k==index){							
											if(Val->type==1){
												strcpy(str,(Val->name)->c_str());
												//printf(":::%s\n",str);
												type=1;					
											}
											else if(Val->type==2){
												val=Val->val;
												type=2;
											}
										}
									}
									fp=fopen(pt,"r");
									if(fp==NULL){
										check=1;
									}
									else{
										char c=0;
										int i=1,res=-1,val1;
										char str1[32];
										fscanf(fp,"%c",&c);
										
										//printf("%d\n",index);
										while(c!=0){
											if(c==' ')
												i++;
											if(c=='\n')
												i=1;
											if(i==index){
												if(type==1){
													fscanf(fp,"%s",str1);
													//printf("%s\n",str);
													res=strcmp(str1,str);
													if(res==0){
														res=strcmp(str,(((ValNode*)$9)->name)->c_str());
														if(res!=0){
															check=0;
															break;
														}
													}
												}
												else if(type==2){
													fscanf(fp,"%d",&val1);
													if(val==val1){
														if(val!=((ValNode*)$9)->val){
															check=0;
															break;
														}
													}
												}
											}
											c=0;
											fscanf(fp,"%c",&c);
										}
									}
									if(check==0){
										warning("redundance:can't be inserted.\n");
									}
									else{	
										//printf("yes\n");
										if(m==1){
											//外键完整************************************
											string pfk="./table/defin/";
											pfk.append(fk);
											char ans[32],ind,res;
											fpc=fopen(pfk,"r");
											fscanf(fpc,"%s",ans);
											fscanf(fpc,"%s",ans);
											fscanf(fpc,"%d",&ind);
											string pfkk="./table/content/";
											pfkk.append(fk);
											fclose(fpc);
											fpc=fopen(pfkk,"r");	
											if(fpc==NULL){
												warning("error:can't be insert due to foreign key.\n");
											}
											else{
												int find=0,i=1;
												char f;
												int num;
												char id[32];
												fscanf(fp,"%c",&f);
												while(f!=0){
													if(f==' ')
														i++;
													if(f=='\n'){
														i=1;
													}
													if(i==ind){
											
														if(type==1){
															fscanf(fp,"%s",id);
															res=strcmp(id,str);
															if(res==0){
																find=1;
																break;
															}
														}
														else if(type==2){
															fscanf(fp,"%d",&num);
															if(val==num){
																find=1;
																break;
															}
														}
													}
													c=0;
													fscanf(fp,"%c",&f);
												}
												if(find==0){
													warning("error:can't be insert due to foreign key.\n");
												}
												else{
													correct=1;
												}
											}
										}
										else{
											correct=1;
										}
						
									}
								}
								else{	
									char att[32],op[3];
									int cons,index,i,value;
									int pass=1;
									fscanf(fpc,"%s %s %d %d",att,op,&cons,&index);
									while(att[0]!='\0'){
										i=0;
										for(ValNode *Val : ((ValuesListNode*)$4)->Val_nodes){
											i++;
											if(i==index){
												value=Val->val;
												break;
											}
										}
										switch(op[0]){
											case '=':{
												if(value!=cons)
													pass=0;
												break;
												}
											case '!':{
												if(value==cons)
													pass=0;
												break;
												}
											case '>':{
												if(op[1]=='='){
													if(value<cons)
														pass=0;
													break;
												}
												else{
													if(value<=cons)
														pass=0;
													break;
												}
											}
											case '<':{
												if(op[1]=='='){
													if(value>cons)
														pass=0;
													break;
												}
												else{
													if(value>=cons)
														pass=0;
													break;
												}
											}
											default:{
												printf("Unknown op.\n");
												break;
											}
										}
										if(pass==0)
											break;
										att[0]='\0';
										fscanf(fpc,"%s %s %d %d",att,op,&cons,&index);
									}
									if(pass==1){
										int k=0,index,type=-1,val,check=1;
										char ck[32],str[32];
										str[0]='\0';
										fpp=fopen(pt1,"r");
										fscanf(fpp,"%s",ck);
										fscanf(fpp,"%s",ck);
										fscanf(fpp,"%d",&index);
										for(ValNode *Val : ((ValuesListNode*)$4)->Val_nodes){
											k++;//printf("index:%d\n",index);
											if(k==index){							
												if(Val->type==1){
													strcpy(str,(Val->name)->c_str());
													//printf(":::%s\n",str);
													type=1;					
												}
												else if(Val->type==2){
													val=Val->val;
													type=2;
												}
											}
										}
										fp=fopen(pt,"r");
										if(fp==NULL){
											//output
											check=1;
										}
										else{
											char c=0;
											int i=1,res=-1,val1;
											char str1[32];
											fscanf(fp,"%c",&c);
											//printf("%d\n",index);
											while(c!=0){
												if(c==' ')
													i++;
												if(c=='\n')
													i=1;
												if(i==index){
													if(type==1){
														fscanf(fp,"%s",str1);
														//printf("%s\n",str);
														res=strcmp(str1,str);
														if(res==0){
															res=strcmp(str,(((ValNode*)$9)->name)->c_str());
															if(res!=0){
																check=0;
																break;
															}
														}
													}
													else if(type==2){
														fscanf(fp,"%d",&val1);
														if(val==val1){
															if(val!=((ValNode*)$9)->val){
																check=0;
																break;
															}
														}
													}
												}
												c=0;
												fscanf(fp,"%c",&c);
											}
										}
										if(check==0){
											warning("redundance:can't be inserted.\n");
										}
										else{	
											correct=1;
										}
									}
									else{
										warning("can't insert:dissatisfy constrains!\n");
									}
								}
								if(correct==1){
													
									/////////////////////
									int length;
									fp=fopen(pt,"r");
									fseek(fp,0,2);
									length=ftell(fp);
									char *buff;
									buff=(char*)malloc(sizeof(char)*length);
									char line[128];
									line[0]='\0';
									rewind(fp);
									i=1;
									//printf("%d\n",lineno);
									while(ftell(fp)<length-1){
										fgets(line,128,fp);
										if(lineno==i){
											i++;
											continue;
										}
										strcat(buff,line);
										i++;
									}
									fclose(fp);
									fp=fopen(pt,"w");
									fputs(buff,fp);
									fclose(fp);
									fp=fopen(pt,"a+");
									for(ValNode *Val : ((ValuesListNode*)$4)->Val_nodes){
										if(Val->type==1){
											fprintf(fp,"%s ",(Val->name)->c_str());
										}
										else if(Val->type==2){
											fprintf(fp,"%d ",Val->val);
										}
									}
									fprintf(fp,"\n");//printf("yes\n");
									///////////////////////
								}
							}
						}
					}
				}
			}
			if(fpp!=NULL)
				fclose(fpp);
			if(fp!=NULL)
				fclose(fp);	
		}
	| DISPLAY TABLE IDENTIFIER 
		{
			if(debug)
				debug("command :: display table id\n");
			$$=new DisplayNode($3);
			string path="./table/content/";
			string path1="./table/define/";
			char pt[64],pt1[64];
			int i=0;
			while(path[i]!='\0'){
				pt[i]=path[i];
				i++;
			}
			pt[i]='\0';
			strcat(pt,$3->c_str());
			strcat(pt,".txt");
			i=0;
			while(path1[i]!='\0'){
				pt1[i]=path1[i];
				i++;	
			}
			pt1[i]='\0';
			strcat(pt1,$3->c_str());
			strcat(pt1,".txt");
			fpp=fopen(pt,"r");
			fp=fopen(pt1,"r");
			if(fp==NULL){
				warning("error:table is not exist.\n");
			}
			else{
				printf("tablename:%s	",$3->c_str());
				char c;
				char s[32];
				fscanf(fp,"%s",s);
				fscanf(fp,"%s",s);
				printf("PRIMARY KEY:%s ",s);
				fscanf(fp,"%s",s);
				printf("%s\n",s);
				int m=-1;
				fscanf(fpp,"%d",&m);
				if(m==1){
					fscanf(fpp,"%s",s);
					printf("reference table:%s\n",s);
				}
				fscanf(fp,"%s",s);
				while(s[0]!='\0'){			
					printf("%s ",s);
					fscanf(fp,"%s",s);
					printf("%s | ",s);
					s[0]='\0';
					fscanf(fp,"%s",s);
				}
				if(fpp==NULL)
					warning("this table is impty.\n");
				else{
					c=0;
					fscanf(fpp,"%c",&c);
					printf("\n");
					while(c!=0){
						printf("%c",c);
						c=0;
						fscanf(fpp,"%c",&c);
					}
				}
			}
			if(fp!=NULL)
				fclose(fp);
			if(fpp!=NULL)
				fclose(fpp);
		}
	;

Decl	: Dec 
			{
				if(debug)
					debug("Decl :: Dec\n");
				$$=new DeclistNode();
				((DeclistNode*)$$)->append((DecNode*)$1);
			}
	| Decl ',' Dec
		{
			if(debug)
				debug("Decl :: Decl , Dec\n");
			((DeclistNode*)$$)->append((DecNode*)$3);
		}
	;
	
Dec     : IDENTIFIER Type
			{
				if(debug)
					debug("Dec :: ID Type\n");
				$$=new DecNode($1,$2);
			}
	;

Type	: INT {
				if(debug)
					debug("type :: int\n");
				$$=$1;
			  }
	| VARCHAR {
				if(debug)
					debug("type :: varchar\n");
				$$=$1;
			  }
	;

Values  : Val 
			{
				if(debug)
					debug("Values :: Val\n");
				$$=new ValuesListNode();
				((ValuesListNode*)$$)->append((ValNode*)$1);
			}
	| Values ',' Val
		{
			if(debug)
				debug("Values :: Values , Val\n");
			((ValuesListNode*)$$)->append((ValNode*)$3);
		}
	;

Val	: IDENTIFIER
	  {
		if(debug)
			debug("Val :: ID\n");
		$$=new ValNode(1,$1,0);
	  }
	| NUMBER 
		{
			if(debug)
				debug("Val::Num\n");
			$$=new ValNode(2,NULL,$1);
		}
		
	;

OP	: EQ {
			if(debug)
				debug("op :: EQ\n");
			$$=$1;
		  }
	| UE {
			if(debug)
				debug("op :: UE\n");
			$$=$1;
		  }
	| LT {
			if(debug)
				debug("op :: LT\n");
			$$=$1;
		  }
	| GT {
			if(debug)
				debug("op :: GT\n");
			$$=$1;
		  }
	| LE {
			if(debug)
				debug("op :: LE\n");
			$$=$1;
		  }
	| GE {
			if(debug)
				debug("op :: GE\n");
			$$=$1;
		  }
	;

%%

void yyerror (const char *msg)
{
    error ("%s", msg);
}
