

#define ledpin 21;

byte l1[3], l2[3]; // LED Tupel with l[0]=G, l[1]=R, l[2]=B
byte* tuppelarray[] = {l1, l2};



void setup() {
  byte l1_colors[] = {100,200,0}; //
  byte l2_colors[] = {200,0,100};
  set_led(l1, l1_colors);
  set_led(l2, l2_colors);
}

void loop() {
  //
  for(int i = 0; i < 6; i++){
      
  }
  
}


/** 
this function sets an LED's GRB Array to a given array's value
*/
void set_led(byte* s, byte* grb){
  for(int i = 0; i < 2; i++){
    *s = *grb;
    s++;
    grb++;
  }
}

void sk_high(){
  digitalWrite(ledpin, HIGH);
  delayMicroseconds();
}

void sk_low(){

}