# Digital design: CORDIC

There's two main parts to doing this task
1. Understanding the algorithm
2. Understanding Verilog

## CORDIC

The goal with cordic is to find the sin and cos of an angle without multiplication
the trick is to precompute certain values for which we do know the tan inverse and
finding the closest approximation to the angle using these numbers.

### Mathematical Backing

Let $u(\theta)$ be the unit vector in the direction of $\theta$, then we have the rotation matrix

$$
R(\phi) = \begin{bmatrix}
\cos \phi  & -\sin \phi \\
\sin \phi & \cos \phi
\end{bmatrix}
$$

such that

$$
u(\theta + \phi) = \mathbf{R}(\phi) u(\theta)
$$

Now, suppose that $\theta$ could be written as the sum

$$
\theta = \sum_{i=0}^{n} \sigma_{i}\gamma_{i} 
$$

where $\sigma = \pm 1$ and $\gamma$ is a reducing sequence of angles, then we would have

$$
u(\theta) = \left( \prod_{i=0}^{n} R(\sigma_{i}\gamma_{i})  \right) u(0)
$$

now, factor out $\cos(\sigma_{i}\gamma_{i})$ from the matrix

$$
u(\theta) = \left( \prod_{i=0}^{n} T(\sigma _{i} \gamma _{i}) \right)\underbrace{ \left( \prod_{i=0}^{n} \cos(\gamma_{i}) \right) u(0) }_{ K_{n} }
$$

now notice that for a given $n$, the terms on the right are a constant vector, while

$$
\mathbf{T}_{i} = \mathbf{T}(\sigma_{i}\gamma _{i})  = \begin{bmatrix}
1 & -\sigma_{i} \tan \gamma_{i} \\
\sigma_{i}\tan \gamma_{i} & 1
\end{bmatrix}
$$

Now, if we let $\tan \gamma_{i} = 2^{-i} = 1<<i$ we can easily compute that in fixed point, thus, multiplying a vector by $T_{i}$ does not need multiplication, only bit shifting and addition/subtraction. 

So first we fix $n$, and calculate

$$
K_{n} = \left( \prod_{i=0}^{n} \cos(\gamma_{i}) \right) u(0) = \begin{bmatrix}
\prod_{i=0}^{n} \frac{1}{\sqrt{ 1 + 2^{-2i} }} \\
0
\end{bmatrix}
$$

So, to find $u(\theta)$ we need to
1. find $\sigma_{i}$ for $i = 0\dots n$ such that $\theta = \sum_{i=0}^{n} \sigma_{i}\gamma_{i}$
2. iteratively apply $T_{i}$ to $K_{n}$

While applying $T$, since we can not multiply by $\sigma$ we define

$$
\mathbf{T}_{i}^{(+)} = \begin{bmatrix}
1 & -2^{-i} \\
2^{-i} & 1
\end{bmatrix}
$$

and

$$
\mathbf{T}_{i}^{(-)} = \begin{bmatrix}
1 &  2^{-i} \\
-2^{-i} & 1
\end{bmatrix}
$$

### The algorithm

The basic algorithm is implemented in C in [this file](./ncordic.c), this implements 
8 bit input to 12 bit output CORDIC, which has gainful aaccuracy at
8 iterations. 

In this case the algorithm is
```python
input angle
constants K8, gamma[0-7]

output vector

initialise
vector = k8
for counter in 0..7:
    if ( angle > 0 ):
        angle -= gamma[i]
        vector = Tp( vector, i )
    else
        angle += gamma[i]
        vector = Tn( vector, i )

return vector
```

