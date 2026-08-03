module circuit_1075(
input a,b,bin,
output reg dout, bout);
wire c,d,e,f,g,h,i;
nand g1(c,a,b);
nand g2(d,a,c);
nand g3(e,c,b);
nand g4(f,d,e);
nand g5(g,bin,f);
nand g6(h,f,g);
nand g7(i,bin,g);
nand g8(dout,h,i);
nand g9(bout,i,e);
endmodule
