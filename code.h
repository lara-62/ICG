#pragma once
#include<bits/stdc++.h>
#include "1905062.h"
using namespace std;
ofstream codeout;
ofstream dataout;
int labelCount=0;
SymbolTable *table;

//code files
void create_code_files()
{
   codeout.open("code.asm",ios::out);
   dataout.open("Final.asm",ios::out);
}
//merging code files

void code_merge()
{
     if (dataout.is_open())
    {
        dataout.close();
    }
    if (codeout.is_open())
    {
        codeout.close();
    }
    ifstream codefile("code.asm");
    ofstream final("Final.asm", std::ios::app);
    string line;
    while (getline(codefile, line))
    {
        final<< line << endl;
    }

   
    codefile.close();
    final.close();
}

//printing functions
void print_function()
{
    codeout<<"print_output proc  ;print what is in ax\n"<<
    "\tpush ax\n"<<
    "\tpush bx\n"<<
    "\tpush cx\n"<<
    "\tpush dx\n"<<
    "\tpush si\n"<<
    "\tlea si,number\n"<<
    "\tmov bx,10\n"<<
    "\tadd si,4\n"<<
    "\tcmp ax,0\n"<<
    "\tjnge negate\n"<<
    "\tprint:\n"<<
    "\txor dx,dx\n"<<
    "\tdiv bx\n"<<
    "\tmov [si],dl\n"<<
    "\tadd [si],'0'\n"<<
    "\tdec si\n"<<
    "\tcmp ax,0\n"<<
    "\tjne print\n"<<
    "\tinc si\n"<<
    "\tlea dx,si\n"<<
    "\tmov ah,9\n"<<
    "\tint 21h\n"<<
    "\tpop si\n"<<
    "\tpop dx\n"<<
    "\tpop cx\n"<<
    "\tpop bx\n"<<
    "\tpop ax\n"<<
    "\tret\n"<<
    "\tnegate:\n"<<
    "\tpush ax\n"<<
    "\tmov ah,2\n"<<
    "\tmov dl,'-'\n"<<
    "\tint 21h\n"<<
    "\tpop ax\n"<<
    "\tneg ax\n"<<
    "\tjmp print\n"<<
  "print_output endp\n";
}
void print_newline()
{
      codeout<<"new_line proc\n"<<
    "\tpush ax\n"<<
    "\tpush dx\n"<<
    "\tmov ah,2\n"<<
    "\tmov dl,cr\n"<<
    "\tint 21h\n"<<
    "\tmov ah,2\n"<<
    "\tmov dl,lf\n"<<
    "\tint 21h\n"<<
    "\tpop dx\n"<<
    "\tpop ax\n"<<
    "\tret\n"<<
    "new_line endp\n";
}
//functions
void function_start(Symbolinfo *info)
{    
    codeout<<info->getName()<<" PROC\n";
    if(info->getName()=="main")
    {
      codeout<<"\tMOV AX, @DATA\n";
	  codeout<<"\tMOV DS, AX\n"; 
    }
    codeout<<"\tPUSH BP\n\tMOV BP, SP\n";
}
void function_end(Symbolinfo *info,int varcount)
{   
    Symbolinfo *temp=table->LookUp(info->getName());
    
    if(varcount)
      {
        
        codeout<<"\tADD SP, "<<varcount*2<<"\n";

      }
      codeout<<"\tPOP BP\n";
     
    if(info->getName()=="main"){
    codeout<<"\tMOV AX,4CH\n\tINT 21H\n";
      }
      else
      {
         if((*(temp->getParameterList())).size())
      {
        codeout<<"\tRET "<<(*(temp->getParameterList())).size()*2<<"\n";
      }
      else
      {
        codeout<<"\tRET\n";
      }
      }
      codeout<<temp->getName()<<" ENDP\n";
}


//variables
void variable_declare_code(Symbolinfo *info,string comment)
{
    if(info->getisglobal())
    {    if(info->getisArray())
           {
             dataout<<"\t"<<info->getName()<<" DW "<<info->getarraysize()<<" DUP (0000H)\t;"<<comment<<"\n";
           }else{
        dataout<<"\t"<<info->getName()<<" DW 1 DUP (0000H)\t;"<<comment<<"\n";
           }
    }
    else
    {  
         if(info->getisArray())
         {
           codeout<<"\tSUB SP, "<<stoi(info->getarraysize())*2<<"\t;"<<comment<<"\n";
         }
         else{
        codeout<<"\tSUB SP, 2\t;"<<comment<<"\n";
         }
    }

}
// void variable_declare_assign(Symbolinfo *info)
// {   
//     if(!info->getisglobal())
//     {
//     codeout<<"\tPUSH BP"<<"\n"<<"\tMOV BP, SP\n";
//     }
// }
void variable_code(Symbolinfo *info,int index=-1)
{
    Symbolinfo *symbol=table->LookUp(info->getName());
    if(symbol->getisglobal())
    {
        codeout<<"\tMOV AX, "<<symbol->getName()<<"\t; storing global variable "<<symbol->getName()<<" to AX\n";
        codeout<<"\tPUSH AX\n";
    }
    else
    {  
      if(symbol->get_is_parameter())
      {
       if(symbol->getisArray()){
      codeout<<"\tMOV AX, [BP+"<<symbol->getoffset()+(index*2)<<"]\t; storing local array variable "<<symbol->getName()<<" to AX\n";
        codeout<<"\tPUSH AX\n";  
    }
    else
    {
        codeout<<"\tMOV AX, [BP+"<<symbol->getoffset()<<"]\t; storing local variable "<<symbol->getName()<<" to AX\n";
        codeout<<"\tPUSH AX\n";  
    }
      }
      else
      {
           if(symbol->getisArray()){
      codeout<<"\tMOV AX, [BP-"<<symbol->getoffset()+(index*2)<<"]\t; storing local array variable "<<symbol->getName()<<" to AX\n";
        codeout<<"\tPUSH AX\n";  
    }
    else
    {
        codeout<<"\tMOV AX, [BP-"<<symbol->getoffset()<<"]\t; storing local variable "<<symbol->getName()<<" to AX\n";
        codeout<<"\tPUSH AX\n";  
    }
      }
      
    }
}
void assigntovariable(Symbolinfo *info,int arrayindex=-1)
{
     Symbolinfo *symbol=table->LookUp(info->getName());
    if(symbol->getisglobal())
    {
       codeout<<"\tMOV "<<symbol->getName()<<",AX\n";
    }
    else
    {  
      if(symbol->get_is_parameter())
      {
           if(symbol->getisArray()){
                   
		codeout<<"\tMOV "<<"[BP+"<<((symbol->getoffset()+(arrayindex*2)))<<"]"<<",AX\n";
         
    }
    else
    {
        
		codeout<<"\tMOV "<<"[BP+"<<(symbol->getoffset())<<"]"<<",AX\n";
    }
      }
      else{
      if(symbol->getisArray()){
                   
		codeout<<"\tMOV "<<"[BP-"<<((symbol->getoffset()+(arrayindex*2)))<<"]"<<",AX\n";
         
    }
    else
    {
        
		codeout<<"\tMOV "<<"[BP-"<<(symbol->getoffset())<<"]"<<",AX\n";
    }
      }
    } 
			  
}

void MULOP_code(Symbolinfo *info)
{    codeout<<"\tPOP BX\n";
     codeout<<"\tPOP AX\n";
     codeout<<"\tCWD\n";
    if(info->getName()=="*")
    {
        codeout<<"\tMUL BX\n";
         codeout<<"\tPUSH AX\n";
    }
    if(info->getName()=="/")
    {
         codeout<<"\tDIV BX\n";
        codeout<<"\tPUSH AX\n";
    }
    if(info->getName()=="%")
    {
         codeout<<"\tDIV BX\n";
        codeout<<"\tPUSH DX\n";
    }

}
void ADDOP_code(Symbolinfo *info)
{
    codeout<<"\tPOP BX\n";
     codeout<<"\tPOP AX\n";
    
    if(info->getName()=="+")
    {
        codeout<<"\tADD AX, BX\n";
         codeout<<"\tPUSH AX\n";
    }
    if(info->getName()=="-")
    {
         codeout<<"\tSUB AX, BX\n";
        codeout<<"\tPUSH AX\n";
    }
  
}
string get_relop(Symbolinfo *info)
{
    if(info->getName()=="<=")
    {
        return "JLE";
    }
    else if(info->getName()==">=")
    {
        return "JGE";
    }
      else if(info->getName()==">")
    {
        return "JG";
    }
      else if(info->getName()=="<")
    {
        return "JL";
    }
      else if(info->getName()=="==")
    {
        return "JE";
    }
       else if(info->getName()=="!=")
    {
        return "JNE";
    }
       
}