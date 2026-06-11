hopefully a little prep helps me out …..

## solve simplex method
we go with *dantzig’s rule* (biggest bite first)
and use *bland’s rule* only in case of a tie
remember we increase the function by $r_{\beta}\left( \frac{p_{\alpha}}{-q_{\alpha \beta}} \right)$
### edge cases
#### unboundedness
no negative coefficients when finding leaving basic variable. nothing gets smaller, you can shoot the entering variable to infinity. the functions is unbounded
- what about a feasible solution ? pg30
#### degenerancy
two or more equations give the exact smallest ratio when doing the ratio test. in this case, you *need* to use bland’s rule
	
What it means: Two basic variables hit 0 at the exact same time. You pick one to be the leaving variable. In your next dictionary, the other one will have a constant term of exactly 0 (e.g., s2​=0−2x2​+…).

The danger: A constant of 0 means in your next pivot, the minimum ratio will be 0. You will do a full pivot, but your Z value won't increase at all. 

#### multiple optimal solutions
if in the final tableau of the simplex method, there is a variable $x_{i}$ that has coefficient 0 in the objective function row ($z=\dots$). it means that the $x_{i}$ has 0 *net impact* on the objective function (increasing $x_{i}$ will force to decrease some other variable $x_{j}$, but the gained/lost by doing so is 0) thus we can do whatever with it and still have an optimal solution. thus we found infinite optimal solutions by playing with $x_{i}$
- we are at one corner, and find a path to *another* corner where the profit gained *perfectly equals* the profit lost (obj value stays the same !)
#### infeasible starting basis
one of the constants (P) is negative even before doing the first pivot.
we are starting outside of the feasible region if we use the staring basis. badbadbad. we gotta use the two-phase method.
### two-phase method
the standard simplex method assumes that setting all non-basic variables to 0 gives you a valid, legal starting point (the origin). 
If doing so makes s1​=−4, you are violating the rule that all variables must be ≥0. 
we are starting outside the feasible region.