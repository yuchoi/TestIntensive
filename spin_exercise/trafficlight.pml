mtype = { RED, YELLOW, GREEN };
chan synch = [1] of {bit};
mtype SN_state = GREEN;
mtype EW_state = RED;

proctype TrafficLight_SN(){

  printf("Light %d = %d\n", _pid, SN_state);
  loop:
    atomic{
      synch?[eval(1)]; 
      synch?_;
    }
  if
  :: SN_state == GREEN -> SN_state = YELLOW;
  :: SN_state == YELLOW -> SN_state = RED;
  :: SN_state == RED -> SN_state = GREEN;
  fi;
  printf("Light %d = %d\n", _pid, SN_state);
    atomic{
      synch?[eval(0)]; 
      synch?_;
    }
  goto loop;
}

proctype TrafficLight_EW(){
  printf("Light %d = %d\n", _pid, EW_state);
  loop:
    atomic{
      synch?[eval(1)]; 
      synch?_;
    }
  if
  :: EW_state == GREEN -> EW_state = YELLOW;
  :: EW_state == YELLOW -> EW_state = RED;
  :: EW_state == RED -> EW_state = GREEN;
  fi;
  printf("Light %d = %d\n", _pid, EW_state);
    atomic{
      synch?[eval(0)]; 
      synch?_;
    }
  goto loop;
}

int pid1, pid2;

proctype synchronize(){

   do
   :: 1->
       synch!1;
       synch!1;
       empty(synch);
       synch!0;
       synch!0;
   od
}



init{
  SN_state = GREEN;
  EW_state = RED;
  pid1 = run TrafficLight_SN();
  pid2 = run TrafficLight_EW();
  run synchronize();
}

//ltl p0 {[] (SN_state != EW_state)}
ltl p1 {[] !((SN_state == GREEN) && (EW_state == GREEN))}
