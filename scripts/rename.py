

import os
import sys
import hashlib
from pathlib import Path

for line in sys.stdin:
    line = line.rstrip("\n")
    if line.endswith(".pdf"):
        if os.path.exists(line):
            # Compute MD5
            md5 = hashlib.md5()
            with open(line, "rb") as pf:
                for chunk in iter(lambda: pf.read(8192), b""):
                    md5.update(chunk)
            hash_hex = md5.hexdigest()
            # we do not remove the dirnames yet.
            line = os.path.join(os.path.dirname(line), f"{hash_hex}.pdf")

    if line.startswith("styles/official/"):
        # remove dirnames when they are official style files.
        line = line[len("styles/official/"):]

    # move all files in the root, while keeping the original location interpretable
    if "/" in line:
        line = line.replace("/","+")

    print(line)
