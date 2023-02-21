
int main()
{   
    int i,j;
    i=0;
    j=10;

    for (;i<5;i++)
    {  if(j>0)
        {
            if(j==10)
              { 
                for(;j<12;j++){
                println(i);
                }
                j=10;
              }
            else
            {
              println(j);  
            }
        }
    }
    
    return 0;
}