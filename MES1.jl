using Plots

#Michał Wąsik
#MES - > zadanie 4.3 Odkształecenie sprężyste


funA = x ->  if x > 1
        5
    else
        3
end

funB = x -> 0
funC = x -> 0
funFX = x -> 0
   
c1 = 10
c2 = 0
N = 5

matrix = zeros(Float64,N,N)
matrixL = zeros(Float64,N)
dShift = zeros(Float64,N)
finalResults = zeros(Float64,N+1)
xAxis = zeros(Float64,N+1)

function integral(fun,a,b)
    k = 10000
    ab = ( (b - a) / k )
    calculatedValue = 0
    for i in 1:( k - 1 )
        calculatedValue = calculatedValue + fun(a + i * ab)
    end
    calculatedValue =(calculatedValue +((fun(a)- fun(b)/2)))* ab
    return calculatedValue 
end

function l_v(v, ah, bh)
    f = x -> v(x)*funFX(x)
    return integral(f,ah,bh) - (c1 * v(0)*funA(0))
end

function b_u_v(u, u_der, v, v_der, ah, bh)
    fp1 = x -> funA(x) * u_der(x) * v_der(x)
    return ((-1)*funA(0)*u(0)*v(0) + integral(fp1, ah, bh))
end


function e(i, n)
    z =  x -> if x < (i - 2)*(2/n)
            0
        elseif x < (i - 1)*(2/n)
            (x*n -2*i +4)/(2)
        elseif x < i*(2/n)
            (2*i - x*n)/(2)
        else 
            0
        end
end

function e_der(i, n)
    z =  x -> if x < (i - 2)*(2/n)
            0
        elseif x < (i - 1)*(2/n)
            n/2
        elseif x < i*(2/n)
            -n/2
        else 
            0
        end
end

function calculateB(n)
    for i in 1:n
        for j in 1:n
            if i != j && i != j+1 && i != j - 1
                matrix[i,j] = 0.0
            elseif i == j
                ah = max(0.0, 2*(i - 2) / n)
                bh = min(2, 2*(i) / n)
                matrix[i,j] = b_u_v(e(j, n),e_der(j, n),e(i, n), e_der(i, n),ah, bh)
            else
                ah = max(0.0, 2*min(i-1, j-1) / n)
                bh = min(2, 2*max(i-1, j-1) / n)
                matrix[i,j] = b_u_v(e(j, n),e_der(j, n),e(i, n), e_der(i, n),ah, bh)
            end
        end
    end
end

function calculateL(n)
    for i in 1:n
        matrixL[i] = l_v(e(i, n),max(0, (2*(i-2)/n)),min(2, ((i)/n)))
    end
end

function calculateResults(n)
    r = matrix\matrixL
    return r
end

function calculateUValue(r,x) 
    finalValue = 0
    for i in 1:N
        finalValue = finalValue + r[i]*(e(i, N)(x))
    end 
    return finalValue
end
    
function calculateU(r,n)
    for i in 0:N
        xAxis[i+1] = 2*i/N
        finalResults[i+1] = calculateUValue(r,xAxis[i+1])
    end
    
end

function drawPlot()
    x = xAxis
    y = finalResults
    plot(x,y)
end

  
function main()
    calculateB(N)
    calculateL(N)
    results = calculateResults(N)
    calculateU(results,N)
    #print(matrix)
    drawPlot()
end
main()