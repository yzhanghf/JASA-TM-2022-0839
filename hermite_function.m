function [output]= hermite_function(degree,x)
    
    if (degree < 0 || degree > 10)
        error('Hermite function cannot handle this degree.\n');
    end
    
    coefficients = {
        [1],                                            
        [1, 0],                                         
        [1, 0, -1],                                     
        [1, 0, -3, 0],          
        [1, 0, -6, 0, 3],       
        [1, 0, -10, 0, 15, 0],  
        [1, 0, -15, 0, 45, 0, -15],                    
        [1, 0, -21, 0, 105, 0, -105, 0],               
        [1, 0, -28, 0, 210, 0, -420, 0, 105],          
        [1, 0, -36, 0, 378, 0, -1260, 0, 945, 0],      
        [1, 0, -45, 0, 630, 0, -3150, 0, 4725, 0, -945]
    };
    
    coeff = coefficients{degree + 1};
    
    output = coeff(1);
    for i = 2:length(coeff)
        output = output .* x + coeff(i);
    end

end

