%% ans : NO
if false && (true || true)
    disp('Yes');
else
    disp('NO');
end


%% ans : Yes
if false && true || true
    disp('Yes');
else
    disp('NO');
end