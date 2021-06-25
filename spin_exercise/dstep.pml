byte n =0;

proctype P() {
  byte temp;

  temp = n+1;
  n = temp
 
  printf("process P, n = %d\n", n);
}

proctype Q() {
  byte temp; 

  temp = n +1;
  n = temp;

 
  printf("Process Q, n = %d\n", n)
}

init{

  run P();
  run Q();

  //assert(n == 2);
}

ltl p0 {[] (n <=2)}

