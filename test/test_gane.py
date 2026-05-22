import arc_agi
import random
from arcengine import GameAction

class lmlm:
  
# Default: looks for games in "environment_files" directory
arc = arc_agi.Arcade()
env = arc.make("ab12-v1", seed=0, render_mode="terminal")

# Or specify a custom directory
arc = arc_agi.Arcade(environments_dir="./my_games")
env = arc.make("ab12-v1", seed=0, render_mode="terminal")

# Perform clicks (ACTION6 with x, y coordinates)
env.step(GameAction.ACTION6, data={"x": 32, "y": 32})

class Brain:

    def decide(self, state, memory):

        # 🧠 RULE 1: survival priority
        if state["danger"]:
            return GameAction.ACTION6, {"x": 5, "y": 5}

        # 🧠 RULE 2: goal chasing
        if state["goal_visible"]:
            return GameAction.ACTION2, {}

        # 🧠 RULE 3: memory influence
        if len(memory.recent()) > 5:
            return GameAction.ACTION3, {}

        # 🧠 fallback exploration
        return random.choice([
            (GameAction.ACTION1, {}),
            (GameAction.ACTION4, {}),
            (GameAction.ACTION5, {}),
        ])
