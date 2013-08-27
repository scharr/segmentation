function changeFileExtension(Dir,OldExtension,NewExtension)

% author Laiso Taiwan
% edited by Alex Scharr
% extension ,such as '.txt'
% if no extension then appends the new one
% else remove old extension and appends the new one

% 'name' char
% 'date' char
% 'bytes' 1*1 double
% 'isdir' 1*1 logic
% 'datenum' 1*1 double

DirStruct = dir(Dir);

StructFields={'name'
 'date'
 'bytes'
 'isdir'
 'datenum'};

if(~isequal(fieldnames(DirStruct),StructFields))
    error('input is not a directory');
end

if ~(ischar(DirStruct(1).name)&&ischar(DirStruct(1).date)&&isa(DirStruct(1).bytes,'double')&&numel(DirStruct(1).bytes)==1&&isa(DirStruct(1).isdir,'logical')&&numel(DirStruct(1).isdir)==1&&isa(DirStruct(1).datenum,'double')&&numel(DirStruct(1).datenum)==1)
    error('input is not a directory');
end

for i=1:numel(DirStruct)
    Dot=find(DirStruct(i).name=='.',1,'last');
    if length(DirStruct(i).name) < 3
        continue
    else
        Extension = DirStruct(i).name(Dot:length(DirStruct(i).name));
        if isequal(Extension,OldExtension)
            movefile([Dir '/' DirStruct(i).name],[Dir '/' DirStruct(i).name(1:Dot-1) NewExtension]);
            %DirStruct(i).name
            %java.io.File(DirStruct(i).name).renameTo(java.io.File([DirStruct(i).name(1:Dot-1) NewExtension]));
        elseif isempty(Dot)
            movefile([Dir '/' DirStruct(i).name],[Dir '/' DirStruct(i).name NewExtension]);
            %java.io.File(DirStruct(i).name).renameTo(java.io.File([DirStruct(i).name NewExtension]));
        else
            continue
        end
    end
end

