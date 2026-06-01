- [ ] *prove or disprove*: if all capacities are distinct, then the max flow is unique
- [ ] assume every vertex has fixed preference order on the outgoing edges, and perform FF always using DFS to find the path in the residual graph to augment. prove that there exist examples which take exponentially many steps to termine
- [ ] given LP and its feasible set P, prove or disprove:
	- P bounded $\implies$ LP bounded
	- LP bounded $\implies$ P is bounded
- [ ] given P non-empy + bounded,
- [ ] show:
- $\exists\, c \text{ s.t.} \max c^Tx, x\in P \text{ has a ! opt sol.}$
- $\exists\, c_{1} \text{ s.t.} \max c_{1}^Tx, x\in P \text{ has } \infty \text{ many opt sol.}$

- [ ]  given $P_{1}, P_{2}$ convex sets, prove or disprove:
	- $P_{1} \cap P_{2}$ is convex
	- $P_{1} \cup P_{2}$ is convex

- [ ] simplex:
$$
	\begin{equation}
	\begin{split}
	\max 2x_{1}+x_{2}-x_{3} \\
	x_{1}+2x_{2}+x_{3} \leq 8 \\
	-x_{1} + x_{2}-2x_{3} \leq 4 \\
	x \geq 0
\end{split}
\end{equation}
$$
- [ ] give an example of a *standard form* LP $s.t.$ it is infeasible, but if we delete the last constraint it becomes feasible + bounded. prove the original dual is feasible
- [ ] for what values of $\alpha, \beta$ is $(2,1)$ an optimal solution ?
$$
\begin{equation}
\begin{split}
\max x_{1} + \beta x_{2} \\
2x_{1} + x_{2} \leq 5 \\
x_{1} + 3x_{2} \leq \alpha \\
x \geq 0
\end{split}
\end{equation}
$$
- [ ] given $P$ polytope and $I$ convex hull of integer points in $P$, is it *true or false* that if every vertex of $I$ is also a vertex of $P$ $\implies$ $I = P$