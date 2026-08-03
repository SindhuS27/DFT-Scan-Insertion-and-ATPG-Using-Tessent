module circuit2_1075(
input A, B, C, D, E, F, G,
output Y);
reg H, I, J, K;
nand g1(H, A,B,C);
or g2(I, D, E);
and g3(J, F,G);
or g4(K, I, J);
and g5(Y, H,K);
endmodule
