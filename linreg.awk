# linreg.awk: An awk script to compute linear regression
# Input columns x and y, outputs a=slope and b=intercept
# Usage: awk -f linreg.awk file
# credit to: http://people.sc.fsu.edu/~sshanbhag/awk-shell/linreg.awk

{ x[NR] = $1; y[NR] = $2;
    sx += x[NR]; sy += y[NR]; 
    sxx += x[NR]*x[NR];
    sxy += x[NR]*y[NR];
}

END{
    det = NR*sxx - sx*sx;
    a = (NR*sxy - sx*sy)/det;
    b = (-sx*sxy+sxx*sy)/det;
    print a, b;
    # for(i=1;i<=NR;i++) print x[i],a*x[i]+b;
}
