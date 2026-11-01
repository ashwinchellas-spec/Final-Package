function fingerprint = model_fingerprint(e)
%MODEL_FINGERPRINT SHA-256 over model source, parameters and provenance.
% Input: engine struct. Output: hex text. Units: none; requires MATLAB JVM.
% Invalidates old validation/ML artifacts after a source or parameter change.
p = project_paths();
folders = {'engines','atmosphere','validation','utilities','setup'};
files = [];
for i = 1:numel(folders)
    files = [files; dir(fullfile(p.matlab,folders{i},'**','*.m'))]; %#ok<AGROW>
end
[~,index] = sort(string({files.name})); files = files(index);
md = java.security.MessageDigest.getInstance('SHA-256');
for i = 1:numel(files)
    content = fileread(fullfile(files(i).folder,files(i).name));
    md.update(unicode2native([files(i).name,content],'UTF-8'));
end
md.update(unicode2native(jsonencode(e.Params),'UTF-8'));
md.update(unicode2native(jsonencode(e.Provenance),'UTF-8'));
fingerprint = lower(reshape(dec2hex(typecast(md.digest(),'uint8'),2).',1,[]));
end
