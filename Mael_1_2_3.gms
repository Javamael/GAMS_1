Sets
i   production sites    /Valais, Thurgau, Aargau/
j   demand centers      /Basel, Zurich, Bern, Geneva/
t   periods (2)         /summer, winter/
;

parameters
a(i)  capacity of production i in tons per period
/ Valais    35
  Thurgau   40
  Aargau    20 /

b(j)  demand at market j in in tons per period
/ Basel     25
  Zurich    30
  Bern      15
  Geneva    20  /
  
c(t) production costs in the two periods
/ summer    1
  winter    1.1  /

;


Table d(i,j)  distance in km
            Basel   Zurich  Bern  Geneva
Valais      300     300     150   100
Thurgau     100     50      150   350
Aargau      50      50      100   250
;

Table e(i,j) transport constraint on route
            Basel   Zurich  Bern    Geneva
Valais      100      100      10      100
Thurgau     200     200     200     200
Aargau      1000    1000    2000    2000


Scalar
f   transport costs in CHF per 100km   /0.5/
*c   production costs in CHF per unit   /1/
*doesn't change anything
scost   storage costs in CHF per unit   /10/
*should avoid storage if production costs in the two periods are the same
;


Variables
X(i,j,t)  shipment quantities in tons per period
S(j,t)  storage at demand place j
Z       total transportation costs
;

Positive Variable
X

Equations
cost           objective function
supply(i,t)   observe supply limit at production site i and in period t
demand(j,t)   satisfy demand at market j
storage(j)    storage achieved in t=summer
maxtransport(i,j,t)  capacity constraint on each route
positivestorage(j,t)    storage must be positive in summer only
;

cost..        Z  =e=  sum((i,j,t), f/100*c(t)* d(i,j)*X(i,j,t)) ;

supply(i,t) .. sum(j, X(i,j,t)) =l= a(i) ;

demand(j,t) ..    sum(i, X(i,j,t)) - S(j,t)  =g=  b(j) ;

storage(j) ..   sum(t, S(j,t)) =g= 0;

maxtransport(i,j,t) ..      X(i,j,t) =l= e(i,j) ;

positivestorage(j,t) ..     S(j,'summer') =g= 0;
*can be relax (if we say that we can begin in winter)



Model transport /all/ ;


Solve transport using lp minimizing z ;
