constraints are either:
- *equalities*: hyperplane (n-1 dimensions)
- *inequalities*: half-spaces (a hyperplane and everything on one side of it), (n dimensions)

our objective function is a set of hyperplanes !! $c^Tx = \beta$ is an hyperplane, and we move $\beta$ through the feasible solutions to get our family
however the coefficients of the objective function form a vector parallel to all the hyperplanes


remember that obj func value stays constant when going in a cycle (as it happens when $P_{\alpha} = 0$ for $l_{\alpha}$ leaving basic-variable, and the obj func increase is $\frac{P_{\alpha}}{q_{\alpha\beta}}$)

set of feasible sols to a LP in equational form is the intersection of an affine space with the gradient

## geometric intuition
in equational form, the equations (duh) define *affine subspaces*. in particular, using $k$ constraints in and $n$ dimensional space defines a feasible set of $n - k$ dimensions. however, this feasible set is not bounded ! affine subspaces are not bounded. the bounds come from the non-negativity constraints. these constraints chop off the affine subspace to get a $n-k$ polyhedron (in fact, polyhedrons are defined by the intersection of linear inequalities)

### optimal solutions
optimal solutions are not guaranteed to be on the edges or o