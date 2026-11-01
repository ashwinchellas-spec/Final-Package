function write_text(filename, text)
%WRITE_TEXT Save UTF-8 text, creating its parent folder when necessary.
% Inputs: filename and text. Output: file on disk. Units: text; throws on I/O errors.
folder = fileparts(filename);
if ~isempty(folder) && ~isfolder(folder), mkdir(folder); end
[fid,message] = fopen(filename,'w','n','UTF-8');
if fid < 0, error('ABACUS:FileIO','Cannot write %s: %s',filename,message); end
cleanup = onCleanup(@() fclose(fid));
fprintf(fid,'%s',char(text));
end
