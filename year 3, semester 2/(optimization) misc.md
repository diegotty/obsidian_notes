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
optimal solutions are not guaranteed to be on edges !
if our *optimal set* (abuse of notation) is $k ≥2$-dimensional, then drawing a line through any 2 optimal solutions does not guarantee us that the line will eventually hit a bfs. it will eventually hit a $(k-1)$ dimensional boundary.
- (a bfs is  $0$-dimensional boundary, that is why with $1$-dimensinal optimal sets, the trick works)


every feasible solution can be mapped to a bfs without increasing its number of strictly postive components.
- we can use contraddiction to find a solution with m-1 positive components.

when in $k$ dimensions, we need to be touching exactly $
when in $K$ k$ dimensions, we need to=to be touching exactly $k$ walls to be locked into a corner
- to touch a wall, a variable must be 0
- therefore, at every corner, exactly $k$ variables must be *non-basic*
- the other variables represent the distance from the other walls 


soooo each variable represents which constraint is tight:
- $x_{i} = 0$ the $x_{i} \geq 0 $ is tight

## infinite opt sols in tableau
if in the final tableau of the simplex method, there is a variable $x_{i}$ that has coefficient 0 in the objective function row ($z=\dots$). it means that the $x_{i}$ has 0 *net impact* on the objective function (increasing $x_{i}$ will force to decrease some other variable $x_{j}$, but the gained/lost by doing so is 0) thus we can do whatever with it and still have an optimal solution. thus we found infinite optimal solutions by playing with $x_{i}$
- we are at one corner, and find a path to *another* corner where the profit gained *perfectly equals* the profit lost (obj value stays the same !)



remember that the interesection of any set of convex sets is convex !! this is why the feasible set of a LP is always convex


we use *complementary slackness* to:
- verify optimality of a solution
- find the opt solution of the dual, given the opt solution of the primal
- prove that a variable must have a certain value in the opt sol
we use *strong duality*:
- to bound the obj function of the primal
we use *weak duality*:
- check if the primal is unbounded/infeasible
- check the problem is feasible
dual LPs bound primal LPs like st-cuts bound flows ! the smallest obj function value for the dual LP is the upper bound for the primal LP

## self-duality
