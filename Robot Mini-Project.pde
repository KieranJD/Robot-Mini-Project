#include <Arduino.h>;
#include <Wire.h>;
#include <SoftwareSerial.h>;
#include <MeAuriga.h>;

float Distance = 0;
float Direction = 0;
float Backwards = 0;
MeLineFollower linefollower_9(9);
MeUltrasonicSensor ultrasonic_10(10);
MeEncoderOnBoard Encoder_1(SLOT1);
MeEncoderOnBoard Encoder_2(SLOT2);
void isr_process_encoder1(void)
{
      if(digitalRead(Encoder_1.getPortB()) == 0){
            Encoder_1.pulsePosMinus();
      }else{
            Encoder_1.pulsePosPlus();
      }
}
void isr_process_encoder2(void)
{
      if(digitalRead(Encoder_2.getPortB()) == 0){
            Encoder_2.pulsePosMinus();
      }else{
            Encoder_2.pulsePosPlus();
      }
}
void move(int direction, int speed)
{
      int leftSpeed = 0;
      int rightSpeed = 0;
      if(direction == 1){
            leftSpeed = -speed;
            rightSpeed = speed;
      }else if(direction == 2){
            leftSpeed = speed;
            rightSpeed = -speed;
      }else if(direction == 3){
            leftSpeed = -speed;
            rightSpeed = -speed;
      }else if(direction == 4){
            leftSpeed = speed;
            rightSpeed = speed;
      }
      Encoder_1.setTarPWM(leftSpeed);
      Encoder_2.setTarPWM(rightSpeed);
}
MeSerial se;
MeBuzzer buzzer;
void Run(){
    while(!(!(true&&(!linefollower_9.readSensors()&3)))){
        if(ultrasonic_10.distanceCm() > 25){
            move(1,100/100.0*255);
            _delay(0.1);
            move(1,0);

        }else{
            if(Direction == 0.000000){
                Left();

            }else{
                Right();

            }

        }

    }
    _delay(1);
    buzzer.tone(600, 2>0?2*1000:0);
    Check();

}
MeRGBLed rgbled_0(0, 12);
void Backward(){
    _delay(0.5);
    for(int count=0;count<5;count++){
        rgbled_0.setColor(0,#ff0000);
        rgbled_0.show();
        _delay(0.1);
        rgbled_0.setColor(0,0,0,0);
        rgbled_0.show();
        buzzer.tone(700, 0.1>0?0.1*1000:0);
        move(2,100/100.0*255);
        _delay(0.1);
        move(2,0);
    }
    if(Direction == 0.000000){
        Left();

    }else{
        Right();

    }

}
void Left(){
    _delay(0.5);
    move(3,100/100.0*255);
    _delay(0.5);
    move(3,0);
    _delay(0.5);
    if(ultrasonic_10.distanceCm() < 25){
        move(4,100/100.0*255);
        _delay(0.5);
        move(4,0);
        _delay(0.5);
        Backwards += 1;
        if(Backwards == 2.000000){
            Backward();

        }else{
            Right();

        }

    }else{
        Direction = 1;
        Backwards = 0;
        Run();

    }

}
void Right(){
    _delay(0.5);
    move(4,100/100.0*255);
    _delay(0.4);
    move(4,0);
    _delay(0.5);
    if(ultrasonic_10.distanceCm() < 25){
        move(3,100/100.0*255);
        _delay(0.5);
        move(3,0);
        _delay(0.5);
        Backwards += 1;
        if(Backwards == 2.000000){
            Backward();

        }else{
            Left();

        }

    }else{
        Direction = 0;
        Backwards = 0;
        Run();

    }

}
void Letter(){
    move(1,100/100.0*255);
    _delay(0.6);
    move(1,0);
    for(int count2=0;count2<7;count2++){
        move(3,100/100.0*255);
        _delay(0.1);
        move(3,0);
        move(1,100/100.0*255);
        _delay(0.1);
        move(1,0);
    }
    move(1,100/100.0*255);
    _delay(0.2);
    move(1,0);
    for(int count3=0;count3<7;count3++){
        move(4,100/100.0*255);
        _delay(0.1);
        move(4,0);
        move(1,100/100.0*255);
        _delay(0.1);
        move(1,0);
    }
    move(1,100/100.0*255);
    _delay(0.5);
    move(1,0);

}
MeLightSensor lightsensor_12(12);
void Check(){
    while(!(lightsensor_12.read() < 10)){}
    Letter();

}


void _loop(){
    Encoder_1.loop();
    Encoder_2.loop();
}
void _delay(float seconds){
	long endTime = millis() + seconds * 1000;
	while(millis() < endTime)_loop();
}
void setup(){
    TCCR1A = _BV(WGM10);
    TCCR1B = _BV(CS11) | _BV(WGM12);
    TCCR2A = _BV(WGM21) | _BV(WGM20);
    TCCR2B = _BV(CS21);
    attachInterrupt(Encoder_1.getIntNum(), isr_process_encoder1, RISING);
    attachInterrupt(Encoder_2.getIntNum(), isr_process_encoder2, RISING);
    buzzer.setpin(45);
    rgbled_0.setpin(44);
    Run();

    Direction = 0;

    Backwards = 0;







}
void loop(){
    _loop();

}
