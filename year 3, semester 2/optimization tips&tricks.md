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
one of the non-basic variables has a coefficient of 0 in the `z` row. this means we found the opt value, but we found another sol (the one we get by inserting the zero’d non-basic variable). there is a line / edge of the geometric shape of solutions (that we get by putting `zero'd out variable`= $\alpha$)

#### infeasibility
one of the constants (P) is negative even before doing the first pivot.
we are starting outside of the feasible region if we use the staring basis. badbadbad. we gotta use the two-phase method.

### two-phase method
What it means: The standard Simplex method assumes that setting all non-basic variables to 0 gives you a valid, legal starting point (the origin). If doing so makes s1​=−4, you are violating the rule that all variables must be ≥0. You are starting outside the feasible region. To fix this, you cannot use the standard Simplex method; you have to use a special setup technique called the Two-Phase Method or the Big-M Method to mathematically "walk" into the valid region before you can start maximizing.