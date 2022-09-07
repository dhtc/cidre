function Icorrected_out = cdr_correct(model,options)
% Using the model learned in cdr_cidreModel, this function corrects the
% source images and saves the corrected images to the destination folder
% provided in the options structure.
% 
% Usage:          cdr_objective(model)
%
% Input: MODEL    The illumination correction model learned from
%                 cdr_CidreModel
%
%        OPTIONS  a data structure containing the various parameters values
%                 required by CIDRE. The correction mode option has 3
%                 possible values:
%                 0 = 'zero-light perserved' (default), 
%                 1 = 'dynamic range corrected', or 
%                 2 = 'direct'
%
% Output:         Stores corrected images to the destination folder
%                 specified in options.
%
% See also: cidre, cidreGui, cdr_cidreModel


% if the destination folder doesn't exist, make it

if isempty(options.correction_mode)
    options.correction_mode = 0;
end

% loop through all the source images, correct them, and write them to the 
% destination folder
switch options.correction_mode
    case 0
        str = 'zero-light perserved';
    case 1
        str = 'dynamic range corrected';
    case 2
        str = 'direct';
end

t1 = tic;
for z = 1:options.num_images_provided
    if mod(z,100) == 0; fprintf('.'); end  % progress to the command line
    
    I = options.raw_images(:, :, z);
    imageClass = class(I);
    I = double(I);
    
    % check which type of correction we want to do
    switch options.correction_mode
        case 0  %'intensity range _preserving'
            Icorrected = ((I - model.z)./model.v) * mean(model.v(:))  + mean(model.z(:));
                    
        case 1 % 'zero-light_preserving'
            Icorrected = ((I - model.z)./model.v) * mean(model.v(:));
        
        case 2 %'direct'    
            Icorrected = ((I - model.z)./model.v);
            
        otherwise
            error('CIDRE:correction', 'Unrecognized correction mode: %s', lower(options.correction_mode));
    end
    
    
    Icorrected = cast(Icorrected, imageClass);
    Icorrected_out{z} = Icorrected;
end

fprintf(' finished in %1.2fs.\n', toc(t1));




