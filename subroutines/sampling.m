function [x] = sampling(n,type)
    switch type
        case 'example3'

            x = rand(n,1);
%             x = -1+2.*rand(n,1);
        case 'example5'

            x = rand(n,1);
        case 'abs_value'
            x = randn(n,1)+1;
        case 'kong_example1'
            x = randn(n,1);
        case 'degenerate'
            x =-1+2* rand(n,1);
        case 'degenerate2'
            x = rand(n,1);
        case 'degenerate_sin'
            x = rand(n,1);
        case 'new_exp'
            x = rand(n,1);
        case 'Sine'
            x = rand(n,1);
    end
end

