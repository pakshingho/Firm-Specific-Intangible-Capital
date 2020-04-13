%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Collect IRFs values and plot them from DYNARE outputs. %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

struct2table(oo_.irfs)

fieldnames(oo_.irfs)

struct2cell(oo_.irfs)


S = oo_.irfs;
fNames = fieldnames(S);
for n = 1:length(fNames)
    disp(S.(fNames{n}))
end