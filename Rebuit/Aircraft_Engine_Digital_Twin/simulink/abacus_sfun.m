function abacus_sfun(block)
%ABACUS_SFUN Level-2 MATLAB S-function wrapping the SAME steady-state backend.
% Input port: [engineID, geometric altitude m, Mach, throttle]; dialog: DB path.
% Output: [jet thrust N, equivalent thrust N, shaft kW, fuel kg/s, TSFC, BSFC, eta_th, valid].
% No continuous/discrete engine dynamics or code generation is claimed.
block.NumDialogPrms=1; block.DialogPrmsTunable={'Nontunable'};
block.NumInputPorts=1; block.NumOutputPorts=1;
block.SetPreCompInpPortInfoToDynamic; block.SetPreCompOutPortInfoToDynamic;
block.InputPort(1).Dimensions=4; block.InputPort(1).DatatypeID=0;
block.InputPort(1).Complexity='Real'; block.InputPort(1).DirectFeedthrough=true;
block.OutputPort(1).Dimensions=8; block.OutputPort(1).DatatypeID=0;
block.OutputPort(1).Complexity='Real'; block.SampleTimes=[-1,0];
block.SimStateCompliance='DefaultSimState'; block.RegBlockMethod('Outputs',@abacus_outputs);
end
function abacus_outputs(block)
%ABACUS_OUTPUTS Evaluate an equilibrium point; invalid active outputs halt simulation.
u=block.InputPort(1).Data; dt=DT_Coordinator(block.DialogPrm(1).Data);
cleanup=onCleanup(@() delete(dt));
r=dt.run(u(1),flight_condition(u(2),u(3),u(4)),'L1',false);
if ~r.Valid, error('ABACUS:SimulinkPoint','%s',strjoin(r.Warnings,' | ')); end
block.OutputPort(1).Data=[r.Thrust_N;r.EquivalentThrust_N;r.ShaftPower_kW;r.FuelFlow_kgs;...
    r.TSFC_kgNs;r.BSFC_kgkWh;r.Eta_thermal;double(r.Valid)];
end
