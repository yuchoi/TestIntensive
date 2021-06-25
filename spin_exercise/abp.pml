mtype {MSG, ACK};

chan toS = [2] of {mtype, bit};
chan toR = [2] of {mtype, bit};

proctype Sender(chan in, out){
   bit sendbit, recvbit;
   
   do
   :: out ! MSG, sendbit ->
         in ? ACK, recvbit;
         assert(recvbit == sendbit);
         if
         :: recvbit == sendbit ->
            sendbit = 1-sendbit;
         :: else ->  assert(0);
         fi;
   od
}

proctype Receiver(chan in, out){
  bit recvbit;
  do
  :: in ? MSG(recvbit) -> out ! ACK(recvbit);
                         assert(recvbit == 1);
  od
}

init{
   run Sender(toS, toR);
   run Receiver(toR, toS);
}

