encodegln(s,n)={
  my(v);
  v=[if(x==32,0,x-96)|x<-Vec(Vecsmall(s))];
  if(#v>n^2,warning("string truncated to length ",n^2));
  v = Vec(v,n^2);
  matrix(n,n,i,j,v[(i-1)*n+j]);
}

text = readvec("input.txt")[1];
mat = encodegln(text,12);

decodegln(mat,n)={
  tmp = [];
  for(i = 1,n,
    for(j = 1,n,
      tmp = concat(tmp, lift(mat[i,j]));
    );
  );
  tmp = Strchr([if(c==0,32,c+96) | c <- tmp]);
  return(tmp);
}

idempotence(mat)={
  i = 1;
  check = mat;
  tmp = mat;
  mat = tmp*mat;
  while(1-(check == mat),
    mat = mat*tmp;
    i++;
    );
  return(i);
}

mat = mat*Mod(1,27);
mat = mat^(lift(1/Mod(65537,idempotence(mat))));

print(decodegln(mat,12));
