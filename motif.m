function [f]= motif(item,type)
    checksize = size(item);
    if (checksize(2)==1)
        item = item';
    end

    x = item(:,1);
    y = item(:,2);
    z = item(:,3);
    switch type
        case 'example3'

            f = exp((x+y+z));
        case 'example5'

            f = exp(5*(x+y+z-2.1));
        case 'abs_value'
            f = abs(x.*y.*z);
        case 'kong_example1'
            f = sign(2*x - y- z) + sign(2*y-x-z) +sign(2*z - x - y);
        case 'degenerate'
            f = x.*y.*z;
        case 'degenerate2'
            f = 27 *(3 *x.^2 - 2* x).*(3* y.^2 - 2* y).*(3* z.^2 - 2* z);
        case 'degenerate_sin'
            f = (3*sin(2*x)-3*sin(1)^2).*(3*sin(2*y)-3*sin(1)^2).*(3*sin(2*z)-3*sin(1)^2);
        case 'new_exp'
            f = exp(5*x.*y.*z);
        case 'Sine'
            x = -1.0 + 2*sqrt(item(:,1));
	        y = -1.0 + 2*sqrt(item(:,2));
	        z = -1.0 + 2*sqrt(item(:,3));
            f = sin((x+y+z));
    end
end

