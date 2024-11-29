function [f]= get_mean(type)
    % This function returns the true mu=E[U_J] values under the tested examples
    switch type
        case 'example3'
            f = 5.07321;
        case 'Sine'
            f = 0.612432;
    end
end

