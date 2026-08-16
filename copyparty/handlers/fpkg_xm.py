from typing import Any
import time

def main(kwargs: dict[str, Any]) -> dict[str, Any]:
    try:
        log = kwargs["log"]
        log(str(kwargs))

        import inspect
        cf = inspect.currentframe().f_back.f_back.f_back
        t = "hello from hook; I am able to peek into copyparty's memory like so:\n  function name: %s\n  variables:\n    %s\n"
        t2 = "\n    ".join([("%r: %r" % (k, v))[:99] for k, v in cf.f_locals.items()][:9])
        log(t % (cf.f_code, t2))
        # log(str(cf.f_locals["self"].rvol))
        import random
        time.sleep(random.random())
        if random.randint(0,1):
            raise Exception('random error')
        return {"rc": 100, 'stdout': 'sent'}
    except Exception as e:
        import traceback
        log(
            "FPKG extractor failed with an exception:\n" + traceback.format_exc()
        )
        return {"rc": 1, "stdout": repr(e) + "\nSee server log for details"}