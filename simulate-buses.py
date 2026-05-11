"""
Sathyabama Bus Tracker — Location Simulator
Exact schemas from openapi.json:

  StartShiftRequest:  { bus_number: str, route: str }
  LocationUpdateRequest: { bus_number: str, latitude: float, longitude: float,
                           speed: float, heading: float=0, accuracy: float=10 }

Flow:
  1. POST /api/v1/auth/login
  2. POST /api/v1/driver/start-shift      (best-effort, non-fatal)
  3. POST /api/v1/driver/location/update  (loop every 5s)
  4. POST /api/v1/driver/end-shift        (on Ctrl+C)

Usage:
    pip install requests
    python simulate_buses.py
"""

import requests, threading, time, math, random, sys
from datetime import datetime

BASE_URL        = "https://sathyabama-bus-tracker.onrender.com/api/v1"
UPDATE_INTERVAL = 5   # seconds

# vehicle_no must match what was registered via add_all_routes.ps1 → TN01AAXX
BUSES = [
    {"route_no":"27",  "vehicle_no":"TN01AA27",  "label":"Bus 27  – TAMBARAM",        "phone":"+919800000056","password":"driver123",
     "waypoints":[(12.9249,80.1000),(12.9320,80.1120),(12.9450,80.1250),(12.9560,80.1350),(12.9620,80.1480),(12.9700,80.1600),(12.9800,80.1750),(12.9870,80.1980)]},
    {"route_no":"14A", "vehicle_no":"TN01AA14A", "label":"Bus 14A – T.NAGAR",          "phone":"+919800000029","password":"driver123",
     "waypoints":[(13.0418,80.2341),(13.0350,80.2450),(13.0260,80.2530),(13.0150,80.2480),(13.0050,80.2400),(12.9950,80.2300),(12.9900,80.2150),(12.9870,80.1980)]},
    {"route_no":"9B",  "vehicle_no":"TN01AA9B",  "label":"Bus 9B  – THIRUVANMIYUR",   "phone":"+919800000091","password":"driver123",
     "waypoints":[(12.9828,80.2572),(12.9820,80.2450),(12.9810,80.2300),(12.9800,80.2150),(12.9790,80.2050),(12.9810,80.2000),(12.9850,80.1990),(12.9870,80.1980)]},
    {"route_no":"6",   "vehicle_no":"TN01AA6",   "label":"Bus 6   – ENNORE",           "phone":"+919800000080","password":"driver123",
     "waypoints":[(13.2144,80.3196),(13.1800,80.3000),(13.1400,80.2800),(13.1000,80.2600),(13.0600,80.2400),(13.0200,80.2200),(13.0000,80.2100),(12.9870,80.1980)]},
    {"route_no":"8",   "vehicle_no":"TN01AA8",   "label":"Bus 8   – VALLUVAR KOTTAM", "phone":"+919800000087","password":"driver123",
     "waypoints":[(13.0545,80.2491),(13.0450,80.2400),(13.0350,80.2350),(13.0250,80.2280),(13.0150,80.2200),(13.0050,80.2100),(12.9950,80.2050),(12.9870,80.1980)]},
    {"route_no":"22",  "vehicle_no":"TN01AA22",  "label":"Bus 22  – NARAYANAPURAM",   "phone":"+919800000049","password":"driver123",
     "waypoints":[(12.9100,80.2300),(12.9200,80.2250),(12.9350,80.2150),(12.9480,80.2100),(12.9600,80.2050),(12.9700,80.2020),(12.9800,80.2000),(12.9870,80.1980)]},
    {"route_no":"3A",  "vehicle_no":"TN01AA3A",  "label":"Bus 3A  – GUDUVANCHERRY",   "phone":"+919800000072","password":"driver123",
     "waypoints":[(12.8485,80.0714),(12.8700,80.0900),(12.8900,80.1100),(12.9100,80.1300),(12.9300,80.1500),(12.9500,80.1700),(12.9700,80.1850),(12.9870,80.1980)]},
]

# ── helpers ──────────────────────────────────────────────────────────────────

def interpolate(waypoints, steps=120):
    pts, segs = [], len(waypoints) - 1
    sps = max(1, steps // segs)
    for i in range(segs):
        la1,lo1 = waypoints[i]; la2,lo2 = waypoints[i+1]
        for s in range(sps):
            t = s/sps
            pts.append((la1+(la2-la1)*t+random.uniform(-0.0002,0.0002),
                        lo1+(lo2-lo1)*t+random.uniform(-0.0002,0.0002)))
    pts.append(waypoints[-1])
    return pts

def calc_heading(la1,lo1,la2,lo2):
    d=math.radians(lo2-lo1); r1,r2=math.radians(la1),math.radians(la2)
    x=math.sin(d)*math.cos(r2)
    y=math.cos(r1)*math.sin(r2)-math.sin(r1)*math.cos(r2)*math.cos(d)
    return (math.degrees(math.atan2(x,y))+360)%360

def api(method, path, payload=None, token=None, timeout=15):
    headers = {"Authorization": f"Bearer {token}"} if token else {}
    try:
        fn = requests.post if method=="POST" else requests.get
        r = fn(f"{BASE_URL}{path}", json=payload, headers=headers, timeout=timeout)
        try: body = r.json()
        except: body = r.text
        return r.status_code, body
    except Exception as e:
        return None, str(e)

# ── per-bus thread ────────────────────────────────────────────────────────────

def run_bus(bus, stop_event):
    label      = bus["label"]
    vehicle_no = bus["vehicle_no"]
    route_no   = bus["route_no"]

    # 1. Login
    code, data = api("POST", "/auth/login", {"phone": bus["phone"], "password": bus["password"]})
    if code != 200:
        print(f"[{label}] ❌ Login failed ({code}): {data}"); return
    token = data["access_token"]
    print(f"[{label}] ✅ Logged in")

    # 2. Start shift (best-effort)
    # StartShiftRequest: { bus_number: str, route: str }
    code, data = api("POST", "/driver/start-shift",
                     {"bus_number": vehicle_no, "route": route_no}, token=token)
    if code == 200:
        print(f"[{label}] 🚌 Shift started")
    else:
        print(f"[{label}] ⚠️  start-shift ({code}) — continuing without shift")

    # 3. Stream location
    # LocationUpdateRequest: { bus_number, latitude, longitude, speed, heading, accuracy }
    pts = interpolate(bus["waypoints"])
    idx, direction = 0, 1

    while not stop_event.is_set():
        lat, lon = pts[idx]
        ni = idx + direction
        hdg = calc_heading(lat, lon, *pts[ni]) if 0 <= ni < len(pts) else 0.0
        spd = round(random.uniform(15, 45), 1)

        code, resp = api("POST", "/driver/location/update",
                         {"bus_number": vehicle_no,
                          "latitude":   lat,
                          "longitude":  lon,
                          "speed":      spd,
                          "heading":    hdg,
                          "accuracy":   round(random.uniform(3, 8), 1)},
                         token=token, timeout=10)

        ts  = datetime.now().strftime("%H:%M:%S")
        sym = "✓" if code == 200 else f"✗{code}"
        print(f"[{ts}] {label:30s} ({lat:.4f},{lon:.4f}) {spd:5.1f}km/h {sym}")

        idx += direction
        if idx >= len(pts):   idx, direction = len(pts)-2, -1
        elif idx < 0:         idx, direction = 1, 1

        stop_event.wait(timeout=UPDATE_INTERVAL)

    # 4. End shift
    api("POST", "/driver/end-shift", {}, token=token)
    print(f"[{label}] 🛑 Shift ended")

# ── main ─────────────────────────────────────────────────────────────────────

def main():
    print("="*60)
    print(f"  Sathyabama Bus Simulator — {len(BUSES)} buses, {UPDATE_INTERVAL}s interval")
    print("  Ctrl+C to stop")
    print("="*60)

    stop_event = threading.Event()
    threads = [threading.Thread(target=run_bus, args=(b, stop_event), daemon=True) for b in BUSES]
    for t in threads:
        t.start(); time.sleep(0.6)

    try:
        while True: time.sleep(1)
    except KeyboardInterrupt:
        print("\n⏹  Stopping..."); stop_event.set()
        for t in threads: t.join(timeout=10)
        print("✅ Done."); sys.exit(0)

if __name__ == "__main__":
    main()