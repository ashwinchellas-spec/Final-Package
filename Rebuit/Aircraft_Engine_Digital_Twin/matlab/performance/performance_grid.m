function g = performance_grid(e)
%PERFORMANCE_GRID ABACUS Table 20.1 candidate grid, before per-engine validity filter.
% Input: loaded engine. Output: H [m geopotential], Mach, throttle arrays and count.
% HBP/TP use 21x8x6; TJ/LBP use 21x9x6. No invalid point becomes training data.
switch e.Type
    case 'Turbojet'
        h=0:1000:20000; m=[0,.3,.6,.9,1.2,1.5,1.8,2.1,2.5];
    case 'Turbofan_HighBPR'
        h=linspace(0,13000,21); h(17)=10668; h(18)=11000; h=sort(h);
        m=[0,.15,.3,.5,.65,.78,.85,.92];
    case 'Turbofan_LowBPR'
        h=linspace(0,17000,21); m=[0,.3,.6,.9,1.2,1.5,1.8,2,2.5];
    case 'Turboprop'
        h=linspace(0,9000,21); m=0:.1:.7;
    case 'Piston'
        h=linspace(0,e.Params.MaxAltitude_m,21); m=linspace(0,e.Params.MaxMach,8);
    otherwise
        error('ABACUS:GridArchitecture','No grid for %s.',e.Type);
end
g=struct('Altitude_m',h,'Altitude_Convention','geopotential','Mach',m,...
    'Throttle',.5:.1:1,'CandidateCount',numel(h)*numel(m)*6);
end
