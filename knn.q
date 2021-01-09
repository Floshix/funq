\c 20 100
\l funq.q
\l pendigits.q

-1"referencing pendigits data from global namespace";
`X`Xt`y`yt set' pendigits`X`Xt`y`yt;
k:4
df:`.ml.edist2
-1"checking accuracy of using ",string[k], " nearest neighbors and df=", string df;
-1"and uniform weight the points";
-1"using .ml.f2nd to peach across the 2nd dimension of Xt to build distance matrix";
avg yt=p:.ml.knn[0n<;k;y] D:.ml.f2nd[df X] Xt
-1"alternatively, we can peach the combination of knn+distance calculation";
avg yt=p:.ml.f2nd[.ml.knn[0n<;k;y] df[X]@] Xt
-1"we can also change the weighting function to be 1/distance";
avg yt=p:.ml.f2nd[.ml.knn[sqrt 1f%;k;y] df[X]@] Xt
-1"using pairwise distance (squared) function uses matrix algebra for performance";
avg yt=p:.ml.knn[sqrt 1f%;k;y] D:.ml.pedist2[X;Xt]


-1"computing the accuracy of each digit";
show avg each (p=yt)[i] group yt i:iasc yt
-1"viewing the confusion matrix, we can see 7 is often confused with 1";
show .ut.totals[`TOTAL] .ml.cm[yt;p]

ks:1+til 10
-1"compare different choices of k: ", -3!ks;
t:([]k:ks)
t:update mdist:avg yt=.ml.knn[1f%;k;y] .ml.f2nd[.ml.mdist X] Xt from t
t:update edist:avg yt=.ml.knn[1f%;k;y] .ml.f2nd[.ml.edist X] Xt from t
show t;

n:5
-1"cross validate with ", string[n], " buckets";
I:.ut.part[n#1;0N?] til count X 0
ff:.ml.fknn[sqrt 1f%;.ml.pedist2]
pf:.ml.pknn
e:y[I]=p:.ml.cv[ff ks;pf;(y;X)] .ml.kfold I

-1"find k with maximum accuracy";
k:0N!ks .ml.imax avg avg each e

-1"confirm accuracy against test dataset";
avg yt=p:pf[;Xt] ff[k;y;X]
