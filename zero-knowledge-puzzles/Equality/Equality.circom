pragma circom 2.1.4;

// Input 3 values using 'a'(array of length 3) and check if they all are equal.
// Return using signal 'c'.

template IsZero() {
   signal input in;
   signal output out;

   signal inv;

   inv <-- in!=0 ? 1/in : 0;

   out <== -in*inv +1;
   in*out === 0;
}


template IsEqual() {
   signal input in[2];
   signal output out;

   component isz = IsZero();

   in[1] - in[0] ==> isz.in;

   isz.out ==> out;
}

template Equality() {
   // Your Code Here..
   signal input a[3];
   signal output c;

   component eq1 = IsEqual();
   component eq2 = IsEqual();

   // Check if a[0] == a[1]
   eq1.in[0] <== a[0];
   eq1.in[1] <== a[1];

   // Check if a[1] == a[2]
   eq2.in[0] <== a[1];
   eq2.in[1] <== a[2];

   // Output true (1) only if both checks are true (1)
   c <== eq1.out * eq2.out;

}


component main = Equality();