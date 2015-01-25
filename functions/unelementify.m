function out = unelementify(in, varargin)
% Separates an m by n matrix in.data into n column vectors according to the
% n names in cell array in.elements. The input variable 'in' can be either
% a struct or a string containing the name of a saved struct.

% If the input is a string, fetch the struct that the string refers to
if ischar(in)
    name=in;
    if exist([name '.mat'],'file')
        eval(['load ' name])
    else
        error('data file does not exist')
    end
    eval(['in=' name ';'])
end

% If the input data is not a struct, return error
if ~isstruct(in)
    error('requires struct input.')
end

% Deterimine if individual fields should be kept
if nargin==2
    if all(varargin{1}=='keep') || all(varargin{1}=='k')
        keep=1;
    end
else
    keep=0;
end



% If elements exists
if isfield(in,'elements')
    if isa(in.(in.elements{1}),'numeric')
        % Create .data matrix
        in.data=NaN(length(in.(in.elements{1})),length(in.elements));
        for i=1:length(in.elements)
            if isfield(in,in.elements{i})
                % Fill .data matrix with the variables listed in .elements
                in.data(:,i)=in.(in.elements{i});
                % Remove unneeded fields
                if ~keep
                    in=rmfield(in, in.elements{i});
                end
            else
                sprintf('Missing field "%s"',in.elements{i})
            end

        end
    elseif isa(in.(in.elements{1}),'cell')
        % Create .data cell array
        in.data=cell(length(in.(in.elements{1})),length(in.elements));
        for i=1:length(in.elements)
            if isfield(in,in.elements{i})
                % Fill .data matrix with the variables listed in .elements
                in.data(:,i)=in.(in.elements{i});
                % Remove unneeded fields
                if ~keep
                    in=rmfield(in, in.elements{i});
                end
            else
                sprintf('Missing field "%s"',in.elements{i})
            end
        end
    else
        error('invalid data type')
    end
    
    
    % Save the results
    if exist('name','var')
        eval([name '=in;'])
        eval(['save ' name '.mat ' name])
    else
        out=in;
    end
else
    error('input does not contain .elements field')
end



end

