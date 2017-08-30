function selection = selector(str)
% Display a list of string and return item(s) selected in the GUI
[id, ok] = listdlg('PromptString','Select participant(s):',...
    'SelectionMode','multiple',...
    'ListString',str);

if ~ok
    error('please, select something [bmch warning].')
else
    selection = str(id);
end
