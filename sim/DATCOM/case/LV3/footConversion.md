It's easy enough to just re-create the altitude schedule from scratch:

```R
seq(from=0, to= 33e3, length.out=5)
```
You can do the one-offs by hand.

Take the station locations in inches and turn them into feet:

```R
x <- c(0.0,1.094,4.654,8.214,11.77,15.33,18.89,22.45,26.01,29.57,33.0,131.0)
```

It's easiest to input stuff into DATCOM if you use the `format()` function:

```R
s <- c(0.0,0.34,2.92,6.61,10.89,15.48,20.15,24.68,28.83,32.23,34.21,34.21)
cat(format(s/144, scientific=T, digits=4), sep=",")
```
