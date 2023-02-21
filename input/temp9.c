int main(){
  int step , array[5] ;
  array[0] = 9 ;
  array[1] = 4 ;
  array[2] = 7 ; 
  array[3] = 12 ;
  array[4] = 2 ;
  for(step = 0 ; step < 5; step++) {
    int key ,j ,l;
	key = array[step];
	j = step - 1;
	l = array[j] ;
    while (key < l && j >= 0) {
      array[j + 1] = array[j];
      j--;
    }
    array[j + 1] = key;
  }

  step = 0 ;
  for(step = 0 ; step < 5 ; step++) {
	int x ;
	x = array[step] ;
	println(x) ;
  }
}