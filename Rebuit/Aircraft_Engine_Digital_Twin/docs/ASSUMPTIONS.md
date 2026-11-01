# Physical assumptions and equation ledger

## Atmosphere

ISA is evaluated on geopotential altitude h from 0 to 32000 m. GUI altitude H is geometric. Convert h=Re*H/(Re+H), Re=6356766 m. Constants: T0=288.15 K, P0=101325 Pa, g0=9.80665 m/s2, R=287.058 J/(kg K), gamma=1.4. Lapse layers are -0.0065 K/m through 11 km, isothermal through 20 km, and +0.001 K/m through 32 km. Each layer's base pressure is propagated from the previous layer. Density=P/(R*T), sound speed=sqrt(gamma*R*T); total conditions use isentropic Mach relations. Gravity and Sutherland viscosity are included. No extrapolation or weather departure is automatic.

## Gas turbine stations

Turbojet stations are 0,2,3,4,5,8. Turbofans add fan exit 2.5 and bypass nozzle 18. Turboprops add free power-turbine exit 7. All tabulated station temperatures/pressures are total quantities. Fuel increases core gas mass through the combustor. A non-ideal convergent nozzle returns exit Mach, static pressure, area, velocity, choking state and pressure thrust; expanded-equivalent velocity is used only for the energy bookkeeping stated in code.

Compression: T_out=T_in*[1+(PR^((gamma-1)/gamma)-1)/eta_c]. Specific compressor work is cp_air*(T_out-T_in). Burner fuel-air ratio follows (cp_gas*T4-cp_air*T3)/(eta_b*LHV-cp_gas*T4), with positive denominator and temperature-rise checks. The gas-generator turbine supplies compressor plus fan demand through mechanical efficiency; turbine pressure follows the efficiency-consistent temperature relation. Net thrust sums exit momentum and pressure thrust and subtracts incoming air momentum. Fuel momentum at inlet is not added because onboard fuel has no separate incoming freestream flux.

cp is derived from each gas R and gamma; cp_air and cp_gas therefore need not equal the PDF's rounded independent constants. Cold gas: gamma=1.4, R=287.058. Hot gas: gamma=1.33, R=287.4. LHV for the core gas-turbine model is 43.2 MJ/kg.

## Off-design conditions

Throttle theta linearly reduces OPR toward 1 and fan PR toward 1. TIT is T3+theta*(design TIT-T3). Corrected inlet mass flow scales with total pressure/sqrt(total temperature), multiplied by 0.35+0.65*theta. Supersonic ram recovery uses 1-0.075*(Mach-1)^1.35, multiplied by the stored inlet recovery. These laws are labelled assumptions. The design mass-flow values do not supply compressor maps or a physically complete spool match. Low throttle below 0.5 is warned. Exactly zero throttle returns an engine-off result with zero output/fuel, no windmilling model and no fabricated fuel-specific consumption.

## Turbofan

The total inlet airflow divides into core=total/(1+BPR) and bypass=total-core. The fan acts on both streams. OPR denotes total fan-times-core compression, so core PR=OPR/fan PR. Turbine work per unit core air is compressor work+(1+BPR)*fan work. Separate core and bypass nozzles can choke independently. No mixer, afterburner or multi-spool map is supplied.

## Turboprop and propeller

After gas-generator work balance, a free power turbine expands to an assumed total pressure 1.05 times ambient. Its flow includes fuel mass. Shaft power passes through a stored gearbox efficiency. ShaftPower_kW is the delivered propeller-shaft power. Residual jet thrust is calculated from the actual remaining total pressure/temperature. Equivalent thrust equals propeller thrust plus residual jet net thrust. BSFC uses delivered shaft power.

At rest, ideal actuator-disc thrust scales as (2*rho*A)^(1/3)*(eta_prop*P)^(2/3). A smooth blend reaches eta_prop*P/V at Mach 0.05, using an algebraically finite expression at V=0. The propeller model is an academic static/cruise bridge, not a blade-element or measured propeller map. Diameter and RPM are explicit assumptions; tip Mach is diagnostic. ESHP=(P_prop+F_jet*V/eta_prop)/745.6998716, with powers in W.

## Optional piston model

Naturally aspirated airflow is rho*displacement*RPM/(30*strokes)*volumetric_efficiency*throttle. A four-stroke engine therefore has one intake per two revolutions. Fuel=air/AFR, brake power=fuel*LHV*brake_thermal_efficiency, torque=power/angular_speed. Compression ratio defines an ideal Otto efficiency bound; the supplied brake efficiency must remain lower. No manifold pressure map, supercharging, friction decomposition, transient combustion or manufacturer calibration is claimed. Both catalogue records and their parameters are opt-in Assumed/Low academic entries.

## Envelope and grid policy

Engine envelopes follow the PDF Table 18.5 academic domains. They are not aircraft operating approvals. Turboprop altitude is 9000 m despite the conflicting PW127G note of 7620 m. Turbojets and low-BPR fans use 21x9x6=1134 grid points; high-BPR fans and turboprops use 21x8x6=1008. High-BPR altitude knots include 10668 and 11000 m. Supersonic grid entries outside an engine's limit are retained as invalid and excluded from ML. Grid cardinality is a configured evaluation count, not a claim that all points are physically valid.

## Reference interpretation

Internal balance checks establish consistency of the implemented equations. Track A compares at matching source conditions, respecting dry/afterburner distinction and source-review status. Track B measures surrogate approximation to generated physics. Passing one track does not prove the other. Assumed mass flows and efficiencies may produce substantial errors against secondary ratings, especially in turboprop power; the implementation does not hide those errors by scaling outputs to ratings.
