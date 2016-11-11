#include <cctype>
#include <cstdio>
#include <cstdlib>
#include <cstdarg>
#include <map>
#include <string>
#include <vector>
#include <sstream>
#include "node.hh"
#include "dumpdot.hh"

//===----------------------------------------------------------------------===//
// Utilities in Dump DOT
//===----------------------------------------------------------------------===//

// There are two ways to create a dot node:
// 1. newNode(num, str1, str2, ...)
//    num corresponds to the number of strings
//    Each string will appear in the generated image as a port
//    All strings are char*
// 2. newNode(vec)
//    All elements of the vector are std::string
// newNode returns an integer, which is the number of the corresponding
// node in DOT file.

int DumpDOT::newNode(int num, ...) {
    va_list list;
    va_start(list, num);
    fprintf(fp, "    %d [label = \"", count);
    bool first = true;
    for (int i=0; i<num; i++) {
        char* st = va_arg(list, char*);
        if (!first)
            fprintf(fp, "|");
        first = false;
        if (st[0]=='<')
            fprintf(fp, "<%d> \\<", i);
        else
            fprintf(fp, "<%d> %s", i, st);
    }
    va_end(list);
    fprintf(fp, "\"];\n");
    return count++;
}

int DumpDOT::newNode(std::vector<std::string> list) {
    fprintf(fp, "    %d [label = \"", count);
    bool first = true;
    for (int i=0; i<list.size(); i++) {
        std::string st = list[i];
        if (!first)
            fprintf(fp, "|");
        first = false;
        fprintf(fp, "<%d> %s", i, st.c_str());
    }
    fprintf(fp, "\"];\n");
    return count++;
}

// Draw a line from nSrc node's pSrc port to nDst node.
// If you want it start from the whole node, let pSrc = -1

void DumpDOT::drawLine(int nSrc, int pSrc, int nDst) {
    fprintf(fp, "    %d", nSrc);
    if (pSrc>=0)
        fprintf(fp, ":%d", pSrc);
    fprintf(fp, " -> %d;\n", nDst);
}

//===----------------------------------------------------------------------===//
// Dump AST to DOT
//===----------------------------------------------------------------------===//

// The following functions convert AST to DOT using DumpDOT.
// Each dumpdot returns an integer, which is corresponding number in DOT file.
// 53+29*71 will become:
// digraph {
// node [shape = record];
//     0 [label = "<0> |<1> +|<2> "];
//     1 [label = "<0> 53"];
//     2 [label = "<0> |<1> *|<2> "];
//     3 [label = "<0> 29"];
//     4 [label = "<0> 71"];
//     0:0 -> 1;
//     0:2 -> 2;
//     2:0 -> 3;
//     2:2 -> 4;
// }

int LineNode::dumpdot(DumpDOT *dumper) {

    int nThis = dumper->newNode(1, "Line");
    int nAsgn = line->dumpdot(dumper);
    dumper->drawLine(nThis, 0, nAsgn);
    return nThis;
}

int InputNode::dumpdot(DumpDOT *dumper) {

    std::ostringstream strs;
    strs << lines.size() << " lines";
    int nThis = dumper->newNode(1, strs.str().c_str());
    for (LineNode* line : lines) {
		if(line==NULL)
			continue;
        int nLine = line->dumpdot(dumper);
        dumper->drawLine(nThis, 0, nLine);
    }
    return nThis;
}
/*
int NumNode::dumpdot(DumpDOT *dumper) {
    std::ostringstream strs;
    strs << val;
    int nThis = dumper->newNode(1, strs.str().c_str());
    return nThis;
}

int VarNode::dumpdot(DumpDOT *dumper) {
    int nThis = dumper->newNode(1, name->c_str());
    return nThis;
}
*/
int ValNode::dumpdot(DumpDOT *dumper) {
	
	int nThis;
	if(type==1){
		nThis=dumper->newNode(1,name->c_str());
	}
	else if(type==2){
		std::ostringstream str;
    	str << val;
		nThis=dumper->newNode(1,str.str().c_str());
	}
	return nThis;
} 

int ValuesListNode::dumpdot(DumpDOT *dumper) {
	
	return 0;
}
int DecNode::dumpdot(DumpDOT *dumper){

	int nThis=dumper->newNode(2,name->c_str(),type->c_str());
	return nThis;
}

int DeclistNode::dumpdot(DumpDOT *dumper) {

	int nThis=dumper->newNode(1,"declist");
	for(DecNode *Dec : Dec_nodes){
		int nDecNode=Dec->dumpdot(dumper);
		dumper->drawLine(nThis,0,nDecNode);
	}
	return nThis;
}

int CretableNode::dumpdot(DumpDOT *dumper) {
	
	int nThis=dumper->newNode(4,"create",name->c_str(),"declist",pkey->c_str());	
	int nDeclist=declist->dumpdot(dumper);
	dumper->drawLine(nThis,2,nDeclist);
	return nThis;
}

int InsertNode::dumpdot(DumpDOT *dumper){
	
	int nThis=dumper->newNode(3,"insert",name->c_str(),"vallist");
	int nVallist=vallist->dumpdot(dumper);
	dumper->drawLine(nThis,2,nVallist);
	return nThis;
}

int ConstrainNode::dumpdot(DumpDOT *dumper){
	
	std::ostringstream str;
    str << val;
	int nThis=dumper->newNode(5,"constrain",tname->c_str(),cname->c_str(),op->c_str(),str.str().c_str());
	return nThis;
}

int DisplayNode ::dumpdot(DumpDOT *dumper){
	
	int nThis=dumper->newNode(2,"display",name->c_str());
	return nThis;
}

