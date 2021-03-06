encodegln(s,n)={
  my(v);
  v=[if(x==32,0,x-96)|x<-Vec(Vecsmall(s))];
  if(#v>n^2,warning("string truncated to length ",n^2));
  v = Vec(v,n^2);
  matrix(n,n,i,j,v[(i-1)*n+j]);
}
\\numerisation
text = readvec("input.txt")[1];
mat = encodegln(text,12);


\\encodage
decodegln(mat,n)={
  tmp = [];
  for(i = 1,n,
    for(j = 1,n,
      if(i==n && j==n,0,tmp = concat(tmp, lift(mat[i,j])));
    );
  );
  tmp = Strchr([if(c==0,32,c+96) | c <- tmp]);
  return(tmp);
}
\\ici on cherche l ordre de la matrice. c du brute force mais je me demande si on peut pas faire cela par palier de 18 et non de 1. explications en fin de code
idempotence(mat)={
  i = 1;
  check = mat;
  tmp = mat;
  mat = tmp*mat;
  while((1-(check == mat)),
    mat = mat*tmp;
    i++;
    );
  return(i);
}

\\main
mat = mat*Mod(1,27);
mat = mat^(lift(1/Mod(65537,idempotence(mat))));

print(decodegln(mat,12));


\\pour ce qui est des paliers de 18. Une premiere approche du probleme a ete de chercher a diagonaliser le chiffre. En effet, une fois le chiffre
\\diagonalise, l expo matricielle se fait sur la matrice diagonale, ce qui revient a faire du RSA sur les coeffs diagonaux. on cherche donc a inverser 65537 mod phi(27)
\\et ça ce n est rien d autre que 17 mod 18
\\le probleme est que le message initial ne devait pas etre diagonalisable. mais on peut neanmoins conserver cette info pour accelerer un peu la recherche de l indice
\\d idempotence
