**🏎️ Quasi-Static Lap Time Simulator (LTS)**

A physics-based quasi-static lap time simulator for estimating race car performance on real-world circuits using grip, power, braking, and aerodynamic constraints.

This tool predicts:

Speed profile around a track

Time spent in each segment

Total lap time

Designed for fast performance evaluation, setup comparison, and motorsport engineering studies.

**📌 Project Overview**

This simulator models a vehicle driving around a discretized race track.
At each track segment, vehicle speed is limited by:

Cornering Grip – Tire friction vs curvature

Acceleration Capability – Engine power vs traction

Braking Capability – Tire friction under deceleration

A forward/backward constraint propagation approach ensures the speed profile is globally feasible.

Lap time is computed by integrating:

<img width="198" height="94" alt="image" src="https://github.com/user-attachments/assets/35229e7a-ff87-449a-a4dc-711b63b3073b" />

	​

**🧠 Methodology
1️⃣ Track Processing**

Track centerlines are imported (e.g., from GeoJSON) and converted into:

Arc length s

Curvature κ(s)

The track is resampled to uniform spacing for numerical stability.

**2️⃣ Cornering Speed Limit**

For each segment, the maximum speed allowed by lateral grip is computed:
<img width="256" height="69" alt="image" src="https://github.com/user-attachments/assets/4a4507ab-0507-43fb-a65d-a3178499890e" />
​
where vertical load includes aerodynamic downforce.

**3️⃣ Forward Pass (Acceleration-Limited)**

Speed is propagated forward using:
<img width="251" height="58" alt="image" src="https://github.com/user-attachments/assets/f57ee42a-43ae-44c2-9093-727653cbe073" />


Acceleration is limited by:

Engine power

Tire friction (traction circle / ellipse)

Aerodynamic drag

**4️⃣ Backward Pass (Braking-Limited)**

A reverse pass ensures the car can decelerate in time for upcoming corners by applying braking force limits.

**5️⃣ Final Speed Profile**

The physically feasible speed at each segment is:
<img width="411" height="56" alt="image" src="https://github.com/user-attachments/assets/806ba3db-9fd6-4789-988c-f437045ef2da" />

**📊 Outputs**

Speed vs distance

Time-per-segment distribution

Total lap time

Performance hotspots (braking zones, traction limits)

**🛠️ Tech Stack**
Tool	Purpose
MATLAB	Core physics solver
Python	Track preprocessing & parameter sweeps
GeoJSON	Real circuit geometry input

<img width="485" height="483" alt="image" src="https://github.com/user-attachments/assets/25561daf-79ad-4963-bb34-f08d18b9afab" />


**▶️ How to Run**
MATLAB
cd matlab
main


This will:

Load track and vehicle parameters

Run the lap time solver

Output lap time and speed plots

Python (Optional)

Used for:

Converting track data

Running parameter sweeps

Automating studies

**📈 Example Result**

Tested on the Baku F1 Circuit:

Metric	Value
Track Length	~7.9 km
Predicted Lap Time	~1:49
Real F1 Benchmark	~1:41–1:44

Given the quasi-static model (no transient tire/ERS effects), this is within realistic bounds.

**🚀 Future Improvements**

GG diagram with combined slip limits

Racing line optimization

Gear ratio & powertrain modeling

Energy recovery system modeling

Setup parameter sweeps

Sim-to-real telemetry correlation

**🎯 Purpose**

This project demonstrates:

Motorsport performance modeling

Physics-based simulation

Numerical solver design

Data-driven performance analysis
