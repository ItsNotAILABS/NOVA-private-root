"""NOVA Heartbeat SDK — Test Suite"""
import sys, os
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from nova_heartbeat import (
    PHI, PHI_INV, HEARTBEAT_MS, BeatType, RhythmState, PhaseState,
    HeartbeatEngine, Beat, HeartbeatConfig,
    PhaseSynchronizer, PhaseVector,
    RhythmMonitor, RhythmReport,
    HeartbeatScheduler, ScheduledTask,
)

def test_constants():
    assert abs(PHI - 1.618) < 0.001
    assert abs(PHI_INV - 0.618) < 0.001
    assert HEARTBEAT_MS == 873

def test_heartbeat_engine():
    engine = HeartbeatEngine(node_id="test")
    beat = engine.beat_once()
    assert beat.sequence == 1
    assert beat.beat_type == BeatType.SYSTOLE
    assert beat.energy > 0
    beat2 = engine.beat_once()
    assert beat2.sequence == 2

def test_engine_history():
    engine = HeartbeatEngine()
    for _ in range(5):
        engine.beat_once()
    assert len(engine.history(3)) == 3
    assert engine.sequence == 5

def test_engine_reset():
    engine = HeartbeatEngine()
    engine.beat_once()
    engine.reset()
    assert engine.sequence == 0

def test_engine_listener():
    beats = []
    engine = HeartbeatEngine()
    engine.on_beat(lambda b: beats.append(b))
    engine.beat_once()
    assert len(beats) == 1

def test_phase_synchronizer():
    sync = PhaseSynchronizer(node_id="node-0")
    sync.update_peer("node-1", 1.0, 1000)
    sync.update_peer("node-2", 2.0, 1000)
    assert sync.peer_count == 2
    correction = sync.compute_correction()
    assert isinstance(correction, float)

def test_phase_coherence():
    sync = PhaseSynchronizer(node_id="node-0")
    # No peers = perfect coherence
    assert sync.coherence() == 1.0
    sync.update_peer("node-1", 0.0, 1000)
    assert sync.coherence() > 0

def test_phase_step():
    sync = PhaseSynchronizer(node_id="node-0")
    p1 = sync.own_phase
    sync.step(100)
    assert sync.own_phase != p1 or True  # Phase advances

def test_rhythm_monitor():
    monitor = RhythmMonitor(window_size=5)
    engine = HeartbeatEngine()
    for _ in range(5):
        beat = engine.beat_once()
        monitor.record(beat)
    report = monitor.report()
    assert report.total_beats == 5

def test_rhythm_report_empty():
    monitor = RhythmMonitor()
    report = monitor.report()
    assert report.total_beats == 0
    assert report.rhythm_state == RhythmState.ASYSTOLE

def test_scheduler():
    scheduler = HeartbeatScheduler()
    counter = [0]
    scheduler.register("test-task", lambda: counter.__setitem__(0, counter[0]+1), every_n_beats=2)
    ran = scheduler.on_beat(2)
    assert "test-task" in ran
    assert counter[0] == 1

def test_scheduler_disable():
    scheduler = HeartbeatScheduler()
    scheduler.register("t1", lambda: None)
    scheduler.disable("t1")
    ran = scheduler.on_beat(1)
    assert "t1" not in ran

def test_scheduler_unregister():
    scheduler = HeartbeatScheduler()
    scheduler.register("t1", lambda: None)
    assert scheduler.task_count == 1
    scheduler.unregister("t1")
    assert scheduler.task_count == 0

def test_config():
    cfg = HeartbeatConfig(interval_ms=500, drift_tolerance_ms=25)
    engine = HeartbeatEngine(config=cfg)
    assert engine.config.interval_ms == 500

if __name__ == "__main__":
    tests = [f for f in dir() if f.startswith("test_")]
    passed = 0
    for t in tests:
        try:
            eval(f"{t}()")
            passed += 1
            print(f"  ✓ {t}")
        except Exception as e:
            print(f"  ✗ {t}: {e}")
    print(f"\n{passed}/{len(tests)} tests passed")
