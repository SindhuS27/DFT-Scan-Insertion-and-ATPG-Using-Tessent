module circuit_1075(
input A, B, C, D, E,
output reg Y);
reg G, H, I, J;
nand g1(G, A,B);
nand g2(F,B,C);
nand g3(H, F, D);
nand g4(I,D,E);
or g5(J,H,I);
and g6(Y,G,J);
endmodule
