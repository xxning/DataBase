#ifndef _NODE_HH_
#define _NODE_HH_

#include <stdio.h>
#include <string>
#include <vector>
#include "dumpdot.hh"
using namespace std;

typedef enum {
    NUM,
    VAR,
    INPUT,
    LINE,
    ASGN,
    EXP,
    BINARYEXP,
    UNARYEXP
} NodeType;

typedef struct {
    int first_line;
    int first_column;
    int last_line;
    int last_column;
} Loc;

class Node {
public:
    NodeType type;
    Loc* loc;
    Node() {loc = (Loc*)malloc(sizeof(Loc));}
    void setLoc(Loc* loc);
    virtual int dumpdot(DumpDOT *dumper) = 0;
	//virtual Value *Codegen() = 0;
    
};
/*
class NumNode : public ExpNode {
public:
    int val;
    NumNode(int val) : val(val) { type = EXP; };
    int dumpdot(DumpDOT *dumper);
	//virtual Value *Codegen() ;
};

class VarNode : public ExpNode {
public:
    std::string *name;
    VarNode(std::string* name) : name(name) { type = VAR; };
    int dumpdot(DumpDOT *dumper);
	//virtual Value *Codegen() ;
};
*/
class LineNode : public Node {
public:
    Node *line;
    LineNode(Node *line) : line(line) { type = LINE; };
    int dumpdot(DumpDOT *dumper);
	//virtual Value *Codegen() ;
};

class InputNode : public Node {
public:
    std::vector<LineNode*> lines;
    InputNode() { type = INPUT; };
    int dumpdot(DumpDOT *dumper);
    void append(LineNode *line){lines.push_back(line);};
	//virtual Value *Codegen() ;
};
////////////////////////////////////
//////////////////////////////////////
class ValNode : public Node {
public:
	int type;
	std::string *name;
	int val;
	ValNode(int type,std::string *name,int val)
		: type(type),name(name),val(val){};
	int dumpdot(DumpDOT *dumper);
};

class ValuesListNode : public Node {
public:
	std::vector<ValNode*> Val_nodes;
	void append(ValNode* Val){Val_nodes.push_back(Val);}
	int dumpdot(DumpDOT *dumper);
};

class DecNode : public Node {
public:
	std::string *name;
	std::string *type;
	DecNode(std::string *name,std::string *type)
		: name(name),type(type) {};
	int dumpdot(DumpDOT *dumper);
};

class DeclistNode : public Node {
public:
	std::vector<DecNode*> Dec_nodes;
	void append(DecNode* Dec){Dec_nodes.push_back(Dec);}
	int dumpdot(DumpDOT *dumper);
};

class CretableNode : public Node {
public:
	std::string *name;
	DeclistNode* declist;
	std::string *pkey;
	CretableNode(std::string *name,DeclistNode* declist,std::string *pkey)
		: name(name),declist(declist),pkey(pkey) {};
	int dumpdot(DumpDOT *dumper);
};

class InsertNode : public Node {
public:	
	std::string *name;
	ValuesListNode* vallist;
	InsertNode(std::string *name,ValuesListNode* vallist)
		: name(name),vallist(vallist) {};
	int dumpdot(DumpDOT *dumper);
};

class ConstrainNode : public Node {
public:
	std::string *tname;
	std::string *cname;
	std::string *op;
	int val;
	ConstrainNode(std::string *tname,std::string *cname,std::string *op,int val)
		: tname(tname),cname(cname),op(op),val(val) {};
	int dumpdot(DumpDOT *dumper);
};

class DisplayNode : public Node {
public:
	std::string *name;
	DisplayNode(std::string *name) : name(name) {};
	int dumpdot(DumpDOT *dumper);
};

#endif
