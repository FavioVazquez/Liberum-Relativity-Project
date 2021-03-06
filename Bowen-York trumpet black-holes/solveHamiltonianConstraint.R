solveHamiltonianConstraint <- function(a,b,c,d,n,m,TOL,N,M){
        
#Try with solveHamiltonianConstraint(0,1,0,1,5,6,0.1,100,10)        
        
# This is a 2D solver of the Hamiltonian constraint for boosted Bowen-York trumpet
#black holes.
        
# (a,b) = x boundaries
# (c,d) = y boundaries
# n = size of the x grid
# m = size of the y grid
# TOL = Error tolerance for convergence
# N = Max. Number of iterations
# M = Mass parameter (not the actual BH mass)
        
#RHS Function f(x,y) 
        
#######################################################################
# f(x,y) = ((81*(M^4)*(3*M/2)^(7/2))/(64*(x[i]^2+y[j]^2)^(5/4)))
#          + (((sqrt((3*M)/(2*(x[i]^2+y[j]^2)^(1/2))))*(x[i]^2+y[j]^2)^(1/2))
#          * ((99*(x[i]^2+y[j]^2)^(4))-26*(x[i]^2+y[j]^2)^(2) + 3))
#          / 4*((x[i]^2+y[j]^2)^(1/2)+3)^3
#          - ((4*(x[i]^2+y[j]^2)*(3-5*((x[i]^2+y[j]^2)^(2)))))
#          / ((x[i]^2+y[j]^2)^(2)+1)^3
########################################################################
        
        #Definitions
        
        x <- array(0)
        y <- array(0)
        w <- matrix(0,n,m)
        
        
        #Step 1
        
        h <- (b-a)/n                     #Step for x
        k <- (d-c)/m                     #Step for y
        
        #Step 2
        
        for (i in 2:n-1){
                x[i] <- a + i*h         #Generates x grid
        }
        
        #Step 3
        
        for (i in 2:m-1){
                y[i] <- c + i*k         #Generates y grid
        }
        
        #Step 4
        
        for (i in 1:n){
                for (j in 2:m){
                        w[i,j] <- 0     #Put O's to w[i,j]
                }
        }
        
        #Step 5
        
        lambda <- h^2/k^2             #Basics needed to the
        mu <- 2*(1+lambda)            #Gauss-Seidel Algoritgm
        l= 1                          # Initialize l
        
        #Step 6 #(Gauss-Seidel iterations 7-19)
        
        while (l <= N){
                

                #Step 7
                z <- ((-h^2)*(((81*(M^4)*(3*M/2)^(7/2))/(64*(x[1]^2+y[m-1]^2)^(5/4)))
                              + (((sqrt((3*M)/(2*(x[1]^2+y[m-1]^2)^(1/2))))*(x[1]^2+y[m-1]^2)^(1/2))
                                 * ((99*(x[1]^2+y[m-1]^2)^(4))-26*(x[1]^2+y[m-1]^2)^(2) + 3))
                              / 4*((x[1]^2+y[m-1]^2)^(1/2)+3)^3
                              - ((4*(x[1]^2+y[m-1]^2)*(3-5*((x[1]^2+y[m-1]^2)^(2)))))
                              / ((x[1]^2+y[m-1]^2)^(2)+1)^3)
                      +sqrt((3*M)/(2*y[m-1]))
                      +lambda*sqrt((3*M)/(2*(x[1]^2+1)^(1/2)))+(lambda*w[1,m-2])+
                              w[2,m-1])/mu
                NORM <- abs(z - w[1,m-1])
                w[1,m-1] <- z
                
                #Step 8
                for (i in 4:n-2){
                        z <- ((-h^2)*(((81*(M^4)*(3*M/2)^(7/2))/(64*(x[i]^2+y[m-1]^2)^(5/4)))
                                      + (((sqrt((3*M)/(2*(x[i]^2+y[m-1]^2)^(1/2))))*(x[i]^2+y[m-1]^2)^(1/2))
                                         * ((99*(x[i]^2+y[m-1]^2)^(4))-26*(x[i]^2+y[m-1]^2)^(2) + 3))
                                      / 4*((x[i]^2+y[m-1]^2)^(1/2)+3)^3
                                      - ((4*(x[i]^2+y[m-1]^2)*(3-5*((x[i]^2+y[m-1]^2)^(2)))))
                                      / ((x[i]^2+y[m-1]^2)^(2)+1)^3)
                                      +lambda*sqrt((3*M)/(2*(x[i]^2+1)^(1/2)))+w[i-1,m-1]+
                                      w[i+1,m-2]
                                      +(lambda*w[2,m-1]))/mu                        
                        if (abs(w[i,m-1] - z) > NORM){
                                NORM <- abs(w[i,m-1] - z)
                        }
                        w[i,m-1] <- z
                }
                #Step 9
                z <- ((-h^2)*(((81*(M^4)*(3*M/2)^(7/2))/(64*(x[n-1]^2+y[m-1]^2)^(5/4)))
                              + (((sqrt((3*M)/(2*(x[n-1]^2+y[m-1]^2)^(1/2))))*(x[n-1]^2+y[m-1]^2)^(1/2))
                                 * ((99*(x[n-1]^2+y[m-1]^2)^(4))-26*(x[n-1]^2+y[m-1]^2)^(2) + 3))
                              / 4*((x[n-1]^2+y[m-1]^2)^(1/2)+3)^3
                              - ((4*(x[i]^2+y[m-1]^2)*(3-5*((x[i]^2+y[m-1]^2)^(2)))))
                              / ((x[i]^2+y[m-1]^2)^(2)+1)^3)
                              +(sqrt((3*M)/(2*(y[m-1]^2+1)^(1/2))))
                              +(lambda*sqrt((3*M)/(2*(x[i]^2+1)^(1/2))))
                              +w[n-2,m-1]+(lambda*w[n-1,m-2]))/mu
                if (abs(w[n-1,m-1]-z)>NORM){
                        NORM <- (abs(w[n-1,m-1] - z))
                }
                w[n-1,m-1] <- z
                
                #Step 10
                for (j in m-2:4){    # m-2 to the result of m -2. Ex: m=5 -> j in m-2:3
                        #Step 11
                        z <- (((-h^2)*(((81*(M^4)*(3*M/2)^(7/2))/(64*(x[1]^2+y[j]^2)^(5/4)))
                                       + (((sqrt((3*M)/(2*(x[1]^2+y[j]^2)^(1/2))))*(x[1]^2+y[j]^2)^(1/2))
                                          * ((99*(x[1]^2+y[j]^2)^(4))-26*(x[1]^2+y[j]^2)^(2) + 3))
                                       / 4*((x[1]^2+y[j]^2)^(1/2)+3)^3
                                       - ((4*(x[1]^2+y[j]^2)*(3-5*((x[1]^2+y[j]^2)^(2)))))
                                       / ((x[1]^2+y[j]^2)^(2)+1)^3)
                                      +sqrt((3*M)/(2*y[j])) 
                                      +(lambda*w[1,j+1])
                                      +(lambda*w[1,j-1])
                                      +w[2,j]))/mu
                        if (abs(w[1,j]-z) > NORM){
                                NORM <- (abs(w[1,j]-z))
                        }
                        w[1,j] <- z
                        
                        #Step 12
                        for (i in 4:n-2){
                                z <- ((-h^2)*(((81*(M^4)*(3*M/2)^(7/2))/(64*(x[i]^2+y[j]^2)^(5/4)))
                                              + (((sqrt((3*M)/(2*(x[i]^2+y[j]^2)^(1/2))))*(x[i]^2+y[j]^2)^(1/2))
                                                 * ((99*(x[i]^2+y[j]^2)^(4))-26*(x[i]^2+y[j]^2)^(2) + 3))
                                              / 4*((x[i]^2+y[j]^2)^(1/2)+3)^3
                                              - ((4*(x[i]^2+y[j]^2)*(3-5*((x[i]^2+y[j]^2)^(2)))))
                                              / ((x[i]^2+y[j]^2)^(2)+1)^3)+
                                              w[i-1,j]+
                                              (lambda*w[i,j+1])+
                                              w[i+1,j]+
                                              (lambda*w[i,j-1]))/mu
                                if (abs(w[i,j]-z) > NORM){
                                        NORM <- (abs(w[i,j]-z))
                                }
                                w[i,j] <- z
                        }
                        
                        #Step 13
                        z <- (((-h^2)*(((81*(M^4)*(3*M/2)^(7/2))/(64*(x[n-1]^2+y[j]^2)^(5/4)))
                                       + (((sqrt((3*M)/(2*(x[n-1]^2+y[j]^2)^(1/2))))*(x[n-1]^2+y[j]^2)^(1/2))
                                          * ((99*(x[n-1]^2+y[j]^2)^(4))-26*(x[n-1]^2+y[j]^2)^(2) + 3))
                                       / 4*((x[n-1]^2+y[j]^2)^(1/2)+3)^3
                                       - ((4*(x[n-1]^2+y[j]^2)*(3-5*((x[n-1]^2+y[j]^2)^(2)))))
                                       / ((x[n-1]^2+y[j]^2)^(2)+1)^3))
                                       + sqrt((3*M)/(2*(1+y[j]^2)^(1/2)))
                                      +w[n-1,j]
                                      +(lambda*w[n-1,j+1])+(lambda*w[n-1,j-1]))/mu
                        if (abs(w[n-1,j]-z)>NORM){
                                NORM <- abs(w[n-1,j]-z)
                        }
                        w[n-1,j] <- z        
                }
                
                #Step 14
                z <- (((-h^2)*(((81*(M^4)*(3*M/2)^(7/2))/(64*(x[1]^2+y[1]^2)^(5/4)))
                               + (((sqrt((3*M)/(2*(x[1]^2+y[1]^2)^(1/2))))*(x[1]^2+y[1]^2)^(1/2))
                                  * ((99*(x[1]^2+y[1]^2)^(4))-26*(x[1]^2+y[1]^2)^(2) + 3))
                               / 4*((x[1]^2+y[1]^2)^(1/2)+3)^3
                               - ((4*(x[1]^2+y[1]^2)*(3-5*((x[1]^2+y[1]^2)^(2)))))
                               / ((x[1]^2+y[1]^2)^(2)+1)^3))
                               + sqrt((3*M)/(2+y[1]))
                              +(lambda*sqrt((3*M)/(2+y[1]))
                              +(lambda*w[1,2])+w[2,1]))/mu
                if (abs(w[1,1]-z > NORM)){
                        NORM <- abs(w[1,1] - z)
                }
                w[1,1] <- z
                #Step 15
                for (i in 4:n-2){
                        z <- (((-h^2)*(((81*(M^4)*(3*M/2)^(7/2))/(64*(x[i]^2+y[1]^2)^(5/4)))
                                       + (((sqrt((3*M)/(2*(x[i]^2+y[1]^2)^(1/2))))*(x[i]^2+y[1]^2)^(1/2))
                                          * ((99*(x[i]^2+y[1]^2)^(4))-26*(x[i]^2+y[1]^2)^(2) + 3))
                                       / 4*((x[i]^2+y[1]^2)^(1/2)+3)^3
                                       - ((4*(x[i]^2+y[1]^2)*(3-5*((x[i]^2+y[1]^2)^(2)))))
                                       / ((x[i]^2+y[1]^2)^(2)+1)^3))+
                                      (lambda*sqrt((3*M)/(2*x[i])))+
                                      (w[i-1,1])+
                                      (lambda*w[i,2])
                              +w[i+1,1])/mu
                        if (abs(w[i,1]-z) > NORM){
                                NORM <- abs(w[i,1] - z)
                        }
                        w[i,1] <- z
                }
                #Step 16
                z <- (((-h^2)*(((81*(M^4)*(3*M/2)^(7/2))/(64*(x[n-1]^2+y[1]^2)^(5/4)))
                               + (((sqrt((3*M)/(2*(x[n-1]^2+y[1]^2)^(1/2))))*(x[n-1]^2+y[1]^2)^(1/2))
                                  * ((99*(x[n-1]^2+y[1]^2)^(4))-26*(x[n-1]^2+y[1]^2)^(2) + 3))
                               / 4*((x[n-1]^2+y[1]^2)^(1/2)+3)^3
                               - ((4*(x[n-1]^2+y[1]^2)*(3-5*((x[n-1]^2+y[1]^2)^(2)))))
                               / ((x[n-1]^2+y[1]^2)^(2)+1)^3))
                              +sqrt((3*M)/(2*(1+y[1]^2)^(1/2)))
                              +(lambda*sqrt((3*M)/(2*x[n-1])))
                              +w[n-2,1]
                              +(lambda*w[n-1,2]))/mu
                if (abs(w[n-1,1]-z) > NORM){
                        NORM <- abs(w[n-1,1] - z)
                }
                w[n-1,1] <- z
                
                #Step 17
                
                if(NORM <= TOL){                        
                        return(list(l,x,y,-w/10e7))
                }
                
                write.table(round(-w[-n,-m]/10e7, digits = 3),"solution.csv", row.names = F, col.names = F, sep = "\t")
                
                l <- l+1
                        
        }
}
