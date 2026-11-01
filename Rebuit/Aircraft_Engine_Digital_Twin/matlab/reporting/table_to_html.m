function html = table_to_html(t)
%TABLE_TO_HTML Render a MATLAB table with escaped values and explicit unavailable cells.
% Input: table. Output: HTML string. Units remain in headers. No JavaScript is emitted.
if isempty(t), html='<p>No data generated for this section.</p>'; return; end
html='<table><thead><tr>';
for name=string(t.Properties.VariableNames), html=[html,'<th>',html_escape(name),'</th>']; end %#ok<AGROW>
html=[html,'</tr></thead><tbody>'];
for i=1:height(t)
    html=[html,'<tr>']; %#ok<AGROW>
    for j=1:width(t)
        value=t{i,j}; if iscell(value), value=value{1}; end
        if isnumeric(value), value=mat2str(value,7); end
        html=[html,'<td>',html_escape(value),'</td>']; %#ok<AGROW>
    end
    html=[html,'</tr>']; %#ok<AGROW>
end
html=[html,'</tbody></table>'];
end
