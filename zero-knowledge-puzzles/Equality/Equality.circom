pragma circom 2.1.4;
include "../node_modules/circomlib/circuits/comparators.circom";

// Input 3 values using 'a'(array of length 3) and check if they all are equal.
// Return using signal 'c'.

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