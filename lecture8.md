---
title: "Chapter 6: Search part IV, and Constraint satisfaction problems, part II"
description: "DIT410/TIN174, Artificial Intelligence"
author: "Peter Ljunglöf"
when: "25 April, 2017"
logo: "img/logo-Chalmers-GU.png"
---

## Table of contents
{:.no_toc}

* TOC
{:toc}

----

# Repetition of search

## Classical search (R&N 3.1--3.6)

- Generic search algorithm, tree search, graph search, 
  depth-first search, breadth-first search, uniform cost search,
  iterative deepending, bidirectional search, 
  greedy best-first search, A* search, 
  heuristics, admissibility, consistency, dominating heuristics, ...

<div> </div>

## Non-classical search (R&N 4.1, 4.3--4.4)

- Hill climbing, random moves, random restarts, beam search,
  nondeterministic actions, contingency plan, and-or search trees,
  partial observations, belief states, sensor-less problems, ...

<div> </div>

## Adversarial search (R&N 5.1--5.3)

- Cooperative, competetive, zero-sum games, game trees, minimax, α-β pruning, ...

-----

# More games

## Imperfect decisions (R&N 5.4--5.4.2)
{:.no_toc}

## Stochastic games (R&N 5.5)
{:.no_toc}

-----

## Imperfect decisions (R&N 5.4--5.4.2)

*  
    * H-minimax algorithm
    * evaluation function, cutoff test
    * features, weighted linear function
    * quiescence search, horizon effect

-----

### Repetition: Minimax search for zero-sum games

* Given two players called MAX and MIN:
    * MAX wants to maximize the utility value,
    * MIN wants to minimize the same value.
* \\(\Rightarrow\\) MAX should choose the alternative that maximizes assuming that MIN minimizes.

<div> </div>

* **function** Minimax(*state*):
    * **if** TerminalTest(*state*) **then return** Utility(*state*)
    * *A* := Actions(*state*)
    * **if** *state* is a MAX node **then return** \\(\max\_{a\in A}\\) Minimax(Result(*state*, *a*))
    * **if** *state* is a MIN node **then return** \\(\min\_{a\in A}\\) Minimax(Result(*state*, *a*))
{:.pseudocode}

-----

### H-minimax algorithm

* The *Heuristic* Minimax algorithm is similar to normal Minimax
    * it replaces **TerminalTest** and **Utility** with **CutoffTest** and **Eval**

<div> </div>

* **function** H-Minimax(*state*, *depth*):
    * **if** CutoffTest(*state*, *depth*) **then return** Eval(*state*)
    * *A* := Actions(*state*)
    * **if** *state* is a MAX node **then return** \\(\max\_{a\in A}\\) H-Minimax(Result(*state*, *a*), *depth*+1)
    * **if** *state* is a MIN node **then return** \\(\min\_{a\in A}\\) H-Minimax(Result(*state*, *a*), *depth*+1)
{:.pseudocode}

-----

### Chess positions: how to evaluate

![](img/chess-evaluation.png){:height="500px" .noborder}

-----

### Weighted linear evaluation functions

* A very common evaluation function is to use a weighted sum of features:
  \\[ Eval(s) = w\_1 f\_1(s) + w\_2 f\_2(s) + \cdots + w\_n f\_n(s) = \sum\_{i=1}^{n} w\_i f\_i(s) \\]

* This relies on a strong assumption: all features are *independent of each other*
    * which is usually not true, so the best programs for chess  
      (and other games) also use nonlinear feature combinations
*  
* The weights can be calculated using machine learning algorithms,  
  but a human still has to come up with the features.
    * using recent advances in deep machine learning,  
      the computer can learn the features too


-----

### Evaluation functions

![](img/chess-evaluation3.png){:height="300px" .noborder}

A naive weighted sum of features will not see the difference between these two states.

-------

### Problems with cutoff tests

* Too simplistic cutoff tests and evaluation functions can be problematic:
    * e.g., if the cutoff is only based on the current depth 
    * then it might cut off the search in unfortunate positions  
      (such as (b) on the previous slide)
*  
* We want more sophisticated cutoff tests:
    * only cut off search in *quiescent* positions 
    * i.e., in positions that are "stable", unlikely to exhibit wild swings in value
    * non-quiescent positions should be expanded further
*  
* Another problem is the *horizon effect*:
    * if a bad position is unavoidable (e.g., loss of a piece), but the system can  
      delay it from happening, it might push the bad position "over the horizon"
    * in the end, the resulting delayed position might be even worse


------

### Deterministic games in practice

* Chess: 

    * DeepBlue (IBM) beats world champion Garry Kasparov, 1997. 
    * Modern chess programs: Houdini, Critter, Stockfish. 
 
* Checkers/Othello/Reversi: 
 
    * Logistello beats the world champion in Othello/Reversi, 1997. 
    * Chinook plays checkers perfectly, 2007. It uses an endgame database  
      defining perfect play for all 8-piece positions on the board,  
      (a total of 443,748,401,247 positions).
 
* Go: 
 
    * AlphaGo (Google DeepMind) beats one of the world's best players,  
      Lee Sedol by 4--1, in April 2016.
    * Modern programs: MoGo, Zen, GNU Go, AlphaGo.

-----------

### Games of imperfect information* Imperfect information games    * e.g., card games, where the opponent’s initial cards are unknown

    * typically we can calculate a probability for each possible deal

    * seems just like having one big dice roll at the beginning of the game

    * main idea: compute the minimax value of each action in each deal,  
      then choose the action with highest expected value over all deals
----

## Stochastic games (R&N 5.5)

*  
    * chance nodes
    * expected value
    * expecti-minimax algorithm

-----

### Stochastic game example: Backgammon

![](img/backgammon-position.png){:height="400px" .noborder}

-----

### Stochastic games in general

* In stochastic games, chance is introduced by dice, card-shuffling, etc. 
    * We introduce *chance nodes* to the game tree.
    * We can't calculate a definite minimax value,  
      instead we calculate the *expected value* of a position.
    * The expected value is the average of all possible outcomes.
*  
* A very simple example with coin-flipping and arbitrary values:

![](img/expectiminimax-simple.png){:height="250px" .noborder}

-------

### Backgammon game tree

![](img/backgammon-tree.png){:height="400px" .noborder}

-----

### Algorithm for stochastic games

* The ExpectiMinimax algorithm gives perfect play;  
* it's just like Minimax, except we must also handle chance nodes:

<div> </div> 

* **function** ExpectiMinimax(*state*):
    * **if** TerminalTest(*state*) **then return** Utility(*state*)
    * *A* := Actions(*state*)
    * **if** *state* is a MAX node **then return** \\(\max\_{a\in A}\\) Minimax(*state*, *a*)
    * **if** *state* is a MAX node **then return** \\(\min\_{a\in A}\\) Minimax(*state*, *a*)
    * **if** *state* is a chance node **then return** \\(\sum\_{a\in A}P(a)\\) Minimax(*state*, *a*)
{:.pseudocode}

where \\(P(a)\\) is the probability that action *a* occurs.

-----

### Stochastic games in practice

* Dice rolls increase the branching factor *b*:
    * there are 21 possible rolls with 2 dice 
*  
* Backgammon has ≈20 legal moves:
    * depth \\(4\Rightarrow20\times(21\times20)^{3}\approx1.2\times10^{9}\\) nodes
*  
* As depth increases, the probability of reaching a given node shrinks:
    * value of lookahead is diminished
    * α-β pruning is much less effective
*  
* TDGammon (1995) used depth-2 search + very good Eval: 
    * the evaluation function was learned by self-play
    * world-champion level

-----

# Repetition of CSP

## Constraint satisfaction problems (R&N 6.1)

- Variables, domains, constraints (unary, binary, n-ary), constraint graph

<div> </div>

## CSP as a search problem (R&N 6.3–6.3.2)
{:.no_toc}

- Backtracking search, heuristics (minimum remaining values, degree, least constraining value),
  forward checking, maintaining arc-consistency (MAC)

<div> </div>

##  Constraint progagation (R&N 6.2–6.2.2)
{:.no_toc}

- Consistency (node, arc, path, *k*, ...), global constratints, the AC-3 algorithm


----


### CSP: Constraint satisfaction problems (R&N 6.1)

- CSP is a specific kind of search problem:
    - the *state* is defined by *variables* \\(X\_{i}\\), 
      each taking values from the domain \\(D\_{i}\\)
    - the *goal test* is a set of *constraints*:
        - each constraint specifies allowed values for a subset of variables
        - all constraints must be satisfied
-  
- Differences to general search problems:
    - the path to a goal isn't important, only the solution is.
    - there are no predefined starting state
    - often these problems are huge, with thousands of variables,  
      so systematically searching the space is infeasible

------

### Example: Map colouring (binary CSP)

![](img/australia-solution.png){:height="250px" .noborder}
![](img/australia-csp.png){:height="250px" style="margin-left:50px" .noborder}

| **Variables**:   | *WA*, *NT*, *Q*, *NSW*, *V*, *SA*, *T*
| **Domains**:     | \\(D_i\\) = {red, green, blue}
| **Constraints**: | *SA≠WA, SA≠NT, SA≠Q, SA≠NSW, SA≠V,* <br/> *WA≠NT, NT≠Q, Q≠NSW, NSW≠V*
| **Constraint graph**: | Every variable is a node, every binary constraint is an arc.

-----

### Example: Cryptarithmetic puzzle (higher-order CSP)

![](img/cryptarithmetic.png){:.noborder}

| **Variables**:   | *F, T, U, W, R, O,* \\(X\_1, X\_2, X\_3\\)
| **Domains**:     | \\(D_i\\) = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9}
| **Constraints**: | *Alldiff*(*F,T,U,W,R,O*),  *O+O*=*R*+10·\\(X\_1\\),   etc.
| **Constraint graph**: | This is not a binary CSP! <br/> The graph is a *constraint hypergraph*.

-----

## CSP as a search problem (R&N 6.3–6.3.2)

-  
    - backtracking search
    - select variable: minimum remaining values, degree heuristic
    - order domain values: least constraining value
    - inference: forward checking and arc consistency

-----

### Algorithm for backtracking search

- At each depth level, decide on one single variable to assign:
    - this gives branching factor \\(b=d\\), so there are \\(d^{n}\\) leaves
- Depth-first search with single-variable assignments is called *backtracking search*:

<div> </div>

- **function** BacktrackingSearch(*csp*):
  - **return** Backtrack(*csp*, { })
-  
- **function** Backtrack(*csp*, *assignment*):
  - **if** *assignment* is complete **then** **return** *assignment*
  - *var* := SelectUnassignedVariable(*csp*, *assignment*)
  - **for each** *value* **in** OrderDomainValues(*csp*, *var*, *assignment*):
    - **if** *value* is consistent with *assignment*:
      - *inferences* := Inference(*csp*, *var*, *value*)
      - **if** *inferences* ≠ failure:
        - *result* := Backtrack(*csp*, *assignment* \\(\cup\\) {*var*=*value*} \\(\cup\\) *inferences*)
        - **if** *result* ≠ failure **then** **return** *result*
  - **return** failure
{:.pseudocode}

-----

### Improving backtracking efficiency

- The general-purpose algorithm gives rise to several questions:

    - {:.fragment} Which variable should be assigned next? 
        - {:.pseudocode} SelectUnassignedVariable(*csp*, *assignment*)

    - {:.fragment} In what order should its values be tried? 
        - {:.pseudocode} OrderDomainValues(*csp*, *var*, *assignment*)

    - {:.fragment} What inferences should be performed at each step? 
        - {:.pseudocode} Inference(*csp*, *var*, *value*)

    - {:.fragment} Can the search avoid repeating failures? 
        - Conflict-directed backjumping, constraint learning, no-good sets  
          (R&N 6.3.3, not covered in this course)

------

### Selecting unassigned variables

- Heuristics for selecting the next unassigned variable:

    - {:.fragment} Minimum remaining values (MRV):  
      \\(\Longrightarrow\\) choose the variable with the fewest legal values  
      ![](img/australia-most-constrained-variable.png){:.fragment width="700px" .noborder}

    - {:.fragment} Degree heuristic (if there are several MRV variables):  
      \\(\Longrightarrow\\) choose the variable with most constraints on remaining variables  
      ![](img/australia-most-constraining-variable.png){:.fragment width="700px" .noborder}

-------

### Ordering domain values

- Heuristics for ordering the values of a selected variable:

    - {:.fragment} Least constraining value:  
      \\(\Longrightarrow\\) prefer the value that rules out the fewest choices   
      for the neighboring variables in the constraint graph  
      ![](img/australia-least-constraining-value.png){:.fragment .noborder}

-----

##  Constraint progagation (R&N 6.2–6.2.2)

-  
    - consistency (node, arc, path, *k*, ...)
    - global constratints
    - the AC-3 algorithm
    - maintaining arc consistency

----

### Inference: Forward checking and arc consistency

- *Forward checking* is a simple form of inference:
    - Keep track of remaining legal values for unassigned variables  
    - When a new variable is assigned, recalculate the legal values for its neighbors
    ![](img/forward-checking-progress1c.pdf){:width="500px" .noborder .fragment data-fragment-index="1" .nospace-fragment .fade-out}
    ![](img/forward-checking-progress2c.png){:width="500px" .noborder .fragment data-fragment-index="1" .nospace-fragment .current-visible}
    ![](img/forward-checking-progress3c.png){:width="500px" .noborder .fragment data-fragment-index="2" .nospace-fragment .current-visible}
    ![](img/forward-checking-progress4c.png){:width="500px" .noborder .fragment data-fragment-index="3" .nospace-fragment}

- {:.fragment} *Arc consistency*: \\(X\rightarrow Y\\) is ac iff for every \\(x\\) in \\(X\\), there is some allowed \\(y\\) in \\(Y\\) 
    - since NT and SA cannot both be blue, the problem becomes  
      arc inconsistent before forward checking notices
    - arc consistency detects failure earlier than forward checking


-----

### Arc consistency algorithm, AC-3

- Keep a set of arcs to be considered: pick one arc \\((X,Y)\\) at the time and 
  make it consistent (i.e., make \\(X\\) arc consistent to \\(Y\\)).
    - Start with the set of all arcs \\(\\{(X,Y),(Y,X),(X,Z),(Z,X),\ldots\\}\\).
-  
- When an arc has been made arc consistent, does it ever need to be checked again? 
    - An arc \\((X,Y)\\) needs to be revisited if the domain of \\(Y\\) is revised. 

<div> </div>

- **function** AC-3(**inout** *csp*):
  - initialise *queue* to all arcs in *csp*
  - **while** *queue* is not empty:
    - (*X*, *Y*) := RemoveOne(*queue*)
    - **if** Revise(*csp*, *X*, *Y*):
      - **if**   \\(D\_X=\emptyset\\)   **then** **return** failure
      - **for each**  *Z* **in** *X*.neighbors--{*Y*}  **do** add (*Z*, *X*) to *queue*
-  
- **function** Revise(**inout** *csp*, *X*, *Y*):
  - delete every *x* from \\(D_X\\) such that
    there is no value *y* in \\(D\_Y\\) satisfying the constraint \\(C\_{XY}\\)
{:.pseudocode .fragment}

-----

### AC-3 example

![](img/abccsp.png){:width="600px" .noborder}

| remove | \\(D_A\\) | \\(D_B\\) | \\(D_C\\) | add | queue
|:------------:|:-----:|:-----:|:------:|:------:|:--------------
|              | **1234**  | **1234**  | **1234**   |           | *A<B, B<C, C>B, B>A*{:.fragment}
| *A<B*{:.fragment} | ***123***{:.fragment} | **1234**{:.fragment} | **1234**{:.fragment}  |           | *B<C, C>B, B>A*{:.fragment}
| *B<C*{:.fragment} | **123**{:.fragment}  | ***123***{:.fragment} | **1234**{:.fragment}  | *A<B*{:.fragment} | *C>B, B>A, **A<B***{:.fragment}
| *C>B*{:.fragment} | **123**{:.fragment}  | **123**{:.fragment}   | ***234***{:.fragment} |           | *B>A, A<B*{:.fragment}
| *B>A*{:.fragment} | **123**{:.fragment}  | ***23***{:.fragment}  | **234**{:.fragment}   | *C>B*{:.fragment} | *A<B, **C>B***{:.fragment}
| *A<B*{:.fragment} | ***12***{:.fragment} | **23**{:.fragment}    | **234**{:.fragment}   |           | *C>B*{:.fragment}
| *C>B*{:.fragment} | **12**{:.fragment}   | **23**{:.fragment}    | ***34***{:.fragment}  |           | *\\(\emptyset\\)*{:.fragment}
| | |

--------------

### Combining backtracking with AC-3

- What if some domains have more than one element after AC?

- {:.fragment} We can resort to backtracking search:

    - Select a variable and a value using some heuristics  
      (e.g., minimum-remaining-values, degree-heuristic, least-constraining-value)
    - Make the graph arc-consistent again
    - Backtrack and try new values/variables, if AC fails
    - Select a new variable/value, perform arc-consistency, etc.

- {:.fragment} Do we need to restart AC from scratch? 

    - no, only some arcs risk becoming inconsistent after a new assignment
    - restart AC with the queue \\(\\{(Y\_i,X) \| X\rightarrow Y\_i\\}\\),  
      i.e., only the arcs \\((Y\_i,X)\\) where \\(Y\_i\\) are the neighbors of \\(X\\)
    - this algorithm is called *Maintaining Arc Consistency* (MAC)

----------

### Consistency properties

- There are several kinds of consistency properties and algorithms:

    - *Node consistency*: single variable, unary constraints (straightforward)

    - *Arc consistency*: pairs of variables, binary constraints (AC-3 algorithm)

    - *Path consistency*: triples of variables, binary constraints (PC-2 algorithm)

    - *\\(k\\)-consistency*: \\(k\\) variables, \\(k\\)-ary constraints (\\(O(k)\\) algorithms)

    - Consistency for global constraints: 
        - special-purpose algorithms for different constraints, e.g.:
        - *Alldiff(\\(X\_1,\ldots,X\_m\\))* is inconsistent if \\(m > \|D\_1\cup\cdots\cup D\_m\|\\) 
        - *Atmost(\\(n,X\_1,\ldots,X\_m\\))* is inconsistent if \\(n < \sum_i \min(D\_i)\\)


----------

# More about CSP

## Local search for CSPs (R&N 6.4)
{:.no_toc}

## Problem structure (R&N 6.5)
{:.no_toc}

----

## Local search for CSPs (R&N 6.4)

- Given an assignment of a value to each variable:
  - A conflict is an unsatisfied constraint. 
  - The goal is an assignment with zero conflicts. 
-  
- Local search / Greedy descent algorithm: 
  - Start with a complete assignment.
  - Repeat until a satisfying assignment is found: 
    - select a variable to change 
    - select a new value for that variable 

-----

### Min conflicts algorithm

- Heuristic function to be minimized: the number of conflicts. 
    - this is the *min-conflicts* heuristics
- *Note*: this does not always work! 
    - it can get stuck in a *local minimum*

<div> </div>

* **function** MinConflicts(*csp*, *max_steps*)
    * *current* := an initial complete assignment for *csp*
    * **repeat** *max_steps* times:
        * **if** *current* is a solution for csp **then return** *current*
        * *var* := a randomly chosen conflicted variable from *csp*
        * *value* := the value *v* for *var* that minimises Conflicts(*var, v, current, csp*)
        * *current*[*var*] = *value*
    * **return** failure
{:.pseudocode}


----

### Example: \\(n\\)-queens (revisited)

- Do you remember this example?

    - Put \\(n\\) queens on an \\(n\times n\\) board, in separate columns
    - {:.fragment} Conflicts = unsatisfied constraints = n:o of threatened queens
    - {:.fragment} Move a queen to reduce the number of conflicts
        - repeat until we cannot move any queen anymore
        - then we are at a local maximum --- hopefully it is global too

![](img/4queens-iterative.png){:.fragment width="600px"}

-----

### Easy and hard problems

- Two-step solution using min-conflicts for an 8-queens problem:

![](img/8queens-min-conflicts.png){:width="600px"}

- {:.fragment} The runtime of min-conflicts on the *n-queens problem* is *independent of problem size*!
    - it solves even the *million*-queens problem ≈50 steps

- {:.fragment} Why is *n*-queens easy for local search?
    - {:.fragment} because solutions are *densely distributed* throughout the state space!

-----

### Variants of greedy descent 

- To choose a variable to change and a new value for it: 

  - Find a variable-value pair that minimizes the number of conflicts.
  - Select a variable that participates in the most conflicts.  
    Select a value that minimizes the number of conflicts. 
  - Select a variable that appears in any conflict.  
    Select a value that minimizes the number of conflicts. 
  - Select a variable at random.  
    Select a value that minimizes the number of conflicts. 
  - Select a variable and value at random;  
    accept this change if it doesn't increase the number of conflicts. 

- All local search techniques from section 4.1 can be applied to CSPs, e.g.:

    - random walk, random restarts, simulated annealing, beam search, ...

-------

## Problem structure (R&N 6.5)

-  
    - independent subproblems, connected components
    - tree-structured CSP, topological sort
    - converting to tree-structured CSP, cycle cutset, tree decomposition

----

### Independent subproblems

- ![](img/australia-csp.png){:width="350px" style="float:right" .noborder}

- Tasmania is an *independent subproblem*: 
  - there are efficient algorithms for finding *connected components* in a graph

- Suppose that each subproblem has \\(c\\) variables out of \\(n\\) total.
  The cost of the worst-case solution  
  is \\(n/c\cdot d^{c}\\), which is linear in \\(n\\). 

- {:.fragment} E.g., \\(n=80, d=2, c=20\\):
  - \\(2^{80}\\) = 4 billion years at 10 million nodes/sec

- {:.fragment} If we divide it into 4 equal-size subproblems:
  - \\(4\cdot2^{20}\\) =0.4 seconds at 10 million nodes/sec

-  
- {:.fragment} Note: this only has a real effect if the subproblems are (roughly) equal size!

----

### Tree-structured CSP

- A constraint graph is a tree when any two variables are connected by only one path.
    - then any variable can act as root in the tree
    - tree-structured CSP can be solved in *linear time*, in the number of variables!
-  
- {:.fragment} CSP is directed arc-consistent if:
    - there is an orderning of variables \\(X\_1,X\_2,\ldots,X\_n\\) such that
    - every \\(X\_i\\) is arc-consistent with each \\(X\_j\\) for all \\(j>i\\)
-  
- {:.fragment} To solve a tree-structured CSP:
    - first pick a variable to be the root of the tree
    - then find a *topological sort* of the variables (with the root first)
    - finally, make each arc consistent, in reverse topological order

![](img/tree-csp.png){:width="250px" style="margin-top:-20px" .fragment .noborder}
![](img/tree-csp-sorted.png){:width="300px" style="margin-left:100px" .fragment .noborder}

----

### Solving tree-structured CSP

- **function** TreeCSPSolver(*csp*)
    - *n* := number of variables in *csp*
    - *root* := any variable in *csp*
    - \\(X_1\ldots X_n\\) := TopologicalSort(*csp*, *root*)
    - **for** *j* := *n*, *n--1*, ..., 2:
        - MakeArcConsistent(Parent(\\(X_j\\)), \\(X_j\\))
        - **if** it could not be made consistent **then return** failure
    - *assignment* := an empty assignment
    - **for** *i* := 1, 2, ..., *n*:
        - *assignment*[\\(X_i\\)] := any consistent value from \\(D_i\\)
    - **return** *assignment*
{:.pseudocode}

-  
- {:.fragment} What is the runtime?
    - to make an arc consistent, we must compare up to \\(d^2\\) domain value pairs
    - there are \\(n{-}1\\) arcs, so the total runtime is \\(O(nd^2)\\)

----

### Converting to tree-structured CSP

- Most CSPs are *not* tree-structured, but sometimes we can reduce a problem to a tree
    - one approach is to assign values to some variables,  
      so that the remaining variables form a tree

![](img/australia-csp.png){:height="200px" .noborder .fragment}
![](img/australia-tree.png){:height="200px" .noborder .fragment style="margin-left:100px"}

- {:.fragment} If we assign a colour to South Australia, then the remaining variables form a tree
    - a (worse) alternative is to assign values to {*NT,Q,V*}

- {:.fragment} Why is {*NT,Q,V*} a worse alternative?
    - because then we have to try 3×3×3 different assignments,  
      and for each of them solve the remaining tree-CSP

----

### Solving almost-tree-structured CSP

- **function** SolveByReducingToTreeCSP(*csp*):
    - *S* := a cycle cutset of variables, such that *csp--S* becomes a tree
    - **for each** assignment for *S* that satisfies all constraints on *S*:
        - remove any inconsistent values from neighboring variables of *S*
        - solve the remaining tree-CSP (i.e., *csp--S*)
        - **if** there is a solution **then return** it together with the assignment for *S*
    - **return** failure
{:.pseudocode}

-  
- {:.fragment} The set of variables that we have to assign is called a *cycle cutset*
    - for Australia, {*SA*} is a cycle cutset and {*NT,Q,V*} is also a cycle cutset
    - finding the smallest cycle cutset is NP-hard,  
      but there are efficient approximation algorithms

----

### Tree decomposition

- Another approach for reducing to a tree-CSP is *tree decomposition*:
    - divide the original CSP into a set of connected subproblems,  
      such that the connections form a *tree-structured graph*
    - solve each subproblem independently
    - since the decomposition is a tree, we can solve the main problem  
      using directed arc consistency (the TreeCSPSolver algorithm)

![](img/australia-decomposition.png){:height="300px" .noborder .fragment}
