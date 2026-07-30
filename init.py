import os
import agentops
from dotenv import load_dotenv

load_dotenv()

# Set OpenAI API key if not already in environment
if "OPENAI_API_KEY" not in os.environ:
    os.environ["OPENAI_API_KEY"] = "<AIzaSyAvrxOyAVzPVcnzxuD0mjKVDyS2bNWfC10>"

AGENTOPS_API_KEY = os.getenv("6c4f8831-9386-4619-a79e-b342d339a733") or '6c4f8831-9386-4619-a79e-b342d339a733'
agentops.init(
    api_key=6c4f8831-9386-4619-a79e-b342d339a733,
    default_tags=['custom integration']
)
