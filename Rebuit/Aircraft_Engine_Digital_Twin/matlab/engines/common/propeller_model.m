function prop = propeller_model(power_W,eta,rho,diameter,V,a,rpm)
%PROPELLER_MODEL Static actuator-disc thrust with C1 blending into cruise thrust.
% Inputs: shaft W, efficiency [-], density kg/m3, diameter m, V/a m/s, rpm rev/min.
% Outputs: thrust N, shaft torque N m, advance ratio, useful power W.
% Ref: ABACUS 17.4.3. eta at static is an effective disc-power factor, not FV/P.
if power_W<0 || eta<=0 || eta>1 || rho<=0 || diameter<=0 || V<0 || a<=0 || rpm<=0
    error('ABACUS:Propeller','Invalid propeller input.');
end
A = pi*diameter^2/4; useful = eta*power_W;
static = (2*rho*A*useful^2)^(1/3); transition = .05*a;
if V >= transition
    thrust = useful/V;
else
    x = V/transition; weight = x^2*(3-2*x);
    % Algebraically evaluate weight/V without division at V=0.
    thrust = (1-weight)*static+useful*(3*x-2*x^2)/transition;
end
prop = struct('Thrust_N',thrust,'StaticThrust_N',static,...
    'ShaftTorque_Nm',power_W/(rpm*2*pi/60),'AdvanceRatio',V/(rpm/60*diameter),...
    'UsefulPower_W',thrust*V,'DiscArea_m2',A);
end
