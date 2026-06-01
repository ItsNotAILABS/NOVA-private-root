"""NOVA Orchestration SDK — Test Suite"""
import sys, os
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from nova_orchestration import (
    PHI, PHI_INV, TaskState, AgentRole, PipelineState, Priority,
    Task, TaskResult, TaskQueue,
    Agent, AgentPool,
    Pipeline, PipelineStage,
    Scheduler, Schedule,
)

def test_task_queue():
    q = TaskQueue()
    t = q.enqueue("task1", {"key": "val"})
    assert q.size == 1
    assert t.state == TaskState.PENDING

def test_task_dequeue():
    q = TaskQueue()
    q.enqueue("low", priority=Priority.LOW)
    q.enqueue("high", priority=Priority.HIGH)
    task = q.dequeue()
    assert task.name == "high"

def test_task_complete():
    q = TaskQueue()
    t = q.enqueue("task1")
    q.dequeue()
    result = q.complete(t.task_id, True, output="done")
    assert result.success

def test_agent_pool():
    pool = AgentPool()
    a = pool.register("worker-1", AgentRole.WORKER)
    assert pool.total_agents == 1
    assert a.available

def test_agent_assign():
    pool = AgentPool()
    a = pool.register("worker-1")
    q = TaskQueue()
    t = q.enqueue("task1")
    assigned = pool.assign(t)
    assert assigned is not None
    assert assigned.active_tasks == 1

def test_pipeline():
    p = Pipeline("test-pipe")
    p.add_stage("double", lambda x: x * 2)
    p.add_stage("add1", lambda x: x + 1)
    result = p.run(5)
    assert result["success"]
    assert result["output"] == 11

def test_pipeline_failure():
    p = Pipeline("fail-pipe")
    p.add_stage("error", lambda x: 1/0)
    result = p.run(1)
    assert not result["success"]

def test_scheduler():
    s = Scheduler()
    counter = [0]
    s.every("tick", 0, lambda: counter.__setitem__(0, counter[0]+1))
    ran = s.tick()
    assert "tick" in ran

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
