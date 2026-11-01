function text = html_escape(value)
%HTML_ESCAPE Encode arbitrary source/user text before embedding it into HTML.
% Input: text-like value. Output: safe HTML text. Units: none; no markup accepted.
text=char(string(value)); text=strrep(text,'&','&amp;'); text=strrep(text,'<','&lt;');
text=strrep(text,'>','&gt;'); text=strrep(text,'"','&quot;'); text=strrep(text,'''','&#39;');
end
