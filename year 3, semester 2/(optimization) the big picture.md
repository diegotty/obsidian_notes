## flows in graphs
we started by covering *flows in graphs*.
we defined *networks* and *flows* (which are functions on edges, with certain properties)
we proved the *conservation of flow* property and defined the *value of a flow*
we defined *realgorithm sidual graphs* and used them to define a *flow-augmenting path* given by a residual graph, and used it to make a new function which is a *flow*. (in practice, defined how to add to a graph)

we studied the *ford-fulkerson algorithm*  (*FF*) and showed that it always terminates if the capacities are integers
to certify the optimality of the ford-fulkerson algorithm, we introduced *st-cuts*. they give an upper bound to the optimal flow of a graph.
- furthermore, we can find a st-cut that matches the max flow value given by the FF algorihtm, certifying its optimality

as the FF algorithm runs in exponential time, we introduce the *Elmands + Karp algorithm* (*EK*), that terminates in polinomial time even with real-valued capacities.
- the EK algorithm is just like the FF algorithm, but it takes the shortest $s \to t$ path in the residual graph (finds it using a BFS)
we proved EK algorithms’s upper bound on steps ($n\cdot m$)

## linear programs
we introduced the structure of *linear programs*
we studied that a linear program has either:
1) a unique optimal solution
2) infinitely many optimal solutions
3) no feasible solutions
4) a feasible solution but no optimal solution (unbounded)

we studied *convex* feasible sets
- we proved that all linear programs have a convex feasible set
- we proved that if there exist two distinct optimal solutions, there exist infinite optimal solutions
we observed that every LP can be written in standard form
### simplex method
we introduced the simplex method by defining its starting assumptions, and we understood the geometric definition of a feasible set (*affine subspace !*). we introduced *basic feasible solutions* (*bfs*).
we proved that:
$$ \text{given $x$ feasible solution, $x$ is a bfs} \iff B'=\{i|x_{i}>0\} \text{ has } A_{B'} \text{ w/ l.i. columns}

$$
we also proved the *fundamental theorem of linear programming*
furthermore, we defined *convex combinations* and proved the equality of its two definitions
we defined *polyhedrons* and *polytopes*
we proved that 
$$
\text{$v$ is a vertex} \iff \text{$v$ is a bfs to the problem}
$$
we defined the simplex tableau and proved the ending step 
we touched on some of the edge cases
we defined *degenerate bfs* 

we introduced *pivot rules*.
we proved that the all feasibles bases for a cycle give the same bfs, and that all the fickle variables in that bfs are equal to 0
we introduced *bland’s rule* and proved that it doesn’t cycle (skipped proof ….)
### runtime of simplex method
we studied simplex method’s complexity by introducing *klee-minty’s polyhedron*
### dual problem
to find an upper bound to a given LP, we introduce its *dual* problem (the original LP being called the *primal*). by solving the dual, we find the upper bound for the primal. 
we defined the *weak duality theorem* and the *strong duality theorem*
- we proved *theorem 2*, which implies the strong duality theorem

[little digression of feasibility solving (cool logic)]: finding any solution is computationally equivalent to finding the opt solution !

we studied *the farkas lemma*, which gives us a *certificate of infeasibility* by XOR on 2 statements
- could be very useful ngl
we introduced the *complementary slackness*, which allows us to make assumptions on the solution
- do proof
### geometry
we first noticed that the objective function can be re-written as a scalar product, and its gradient (the coefficients) point to the directions of steepest increase
## integer problems
