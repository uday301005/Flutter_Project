
import 'dart:io';

void main() {
  stdout.write('\nHell0, World! \n');
                                 //  VAR AND DYNAMIC
//   String n= "h" ;
//   n="ji";
//   var sub  = 0;
//   sub = "hi";  // no
// dynamic pk= 8;
// pk = false; // yes
//                        CLASS AND OBJECT
   // var ram  =  new Human();
   // new Human();
  //                        FUNCTIONS CALLING VIA CLASS
  var  c = MyClass();
  // c.printName();
  c.num(1,"\nkio234");

}
//            FUNCTION DEFINITION
  class  MyClass {
        //  default   function
    void printName(){
     stdout.write("kio");
  }
   // parameter function
   void num(var p, String g) {
     stdout.write('$p$g');
   }
  }

class Human {
   Human();
}
