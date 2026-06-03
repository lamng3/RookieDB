#!/usr/bin/env python3
"""
CS186 Project 1 practice test harness (reconstructed for self-study).

Usage:
    python3 test.py                       # grade proj1.sql against expected_output/
    python3 test.py --sql reference/solution.sql --write-expected
                                          # (re)generate expected_output/ from a solution

For each question it runs `SELECT * FROM <view>` and compares the rows to
expected_output/<q>.txt. Mismatches are written to diffs/<q>.txt.

Note: this is a learning aid, NOT the official autograder. Expected output is
generated from reference/solution.sql, and the data is the 1871-2022 Lahman set
(the course uses 1871-2017), so results won't match the real grader exactly.
"""
import argparse
import os
import sqlite3
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
DB = os.path.join(HERE, "lahman.db")
EXPECTED_DIR = os.path.join(HERE, "expected_output")
DIFFS_DIR = os.path.join(HERE, "diffs")

# Logical questions, in order.
QUESTIONS = [
    "q0",
    "q1i", "q1ii", "q1iii", "q1iv",
    "q2i", "q2ii", "q2iii",
    "q3i", "q3ii", "q3iii",
    "q4i", "q4ii", "q4iii", "q4iv", "q4v",
]

# q4ii is reported in two checks, mirroring the official harness:
# bins 0-8 (left-inclusive ranges) and bin 9 (right-inclusive top bin).
def select_for(view):
    if view == "q4ii":
        return {
            "q4ii_bins_0_to_8": "SELECT * FROM q4ii WHERE binid < 9 ORDER BY binid",
            "q4ii_bin_9":       "SELECT * FROM q4ii WHERE binid = 9 ORDER BY binid",
        }
    return {view: "SELECT * FROM %s" % view}


def fmt(rows):
    """Render rows as '|'-joined lines; NULL -> 'NULL'. Deterministic for diffing."""
    out = []
    for row in rows:
        out.append("|".join("NULL" if v is None else str(v) for v in row))
    return "\n".join(out) + ("\n" if out else "")


def load_views(con, sql_path):
    with open(sql_path) as f:
        script = f.read()
    # Drop any persisted views first so re-runs don't hit "view already exists".
    for q in QUESTIONS:
        con.execute("DROP VIEW IF EXISTS %s" % q)
    con.executescript(script)


def run_checks(con):
    """Return {check_name: rendered_output_or_ERROR}."""
    results = {}
    for view in QUESTIONS:
        for name, query in select_for(view).items():
            try:
                rows = con.execute(query).fetchall()
                results[name] = fmt(rows)
            except Exception as e:  # noqa: BLE001
                results[name] = "ERROR: %s\n" % e
    return results


def check_names():
    names = []
    for view in QUESTIONS:
        names.extend(select_for(view).keys())
    return names


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--sql", default=os.path.join(HERE, "proj1.sql"),
                    help="SQL file with the CREATE VIEW statements to test")
    ap.add_argument("--write-expected", action="store_true",
                    help="write results to expected_output/ instead of grading")
    args = ap.parse_args()

    if not os.path.exists(DB):
        sys.exit("Cannot find lahman.db at %s" % DB)
    if not os.path.exists(args.sql):
        sys.exit("Cannot find SQL file: %s" % args.sql)

    con = sqlite3.connect(DB)
    try:
        load_views(con, args.sql)
        results = run_checks(con)
    finally:
        # Don't leave practice views persisted in the shared db file.
        for q in QUESTIONS:
            con.execute("DROP VIEW IF EXISTS %s" % q)
        con.commit()
        con.close()

    os.makedirs(EXPECTED_DIR, exist_ok=True)
    os.makedirs(DIFFS_DIR, exist_ok=True)

    if args.write_expected:
        for name in check_names():
            with open(os.path.join(EXPECTED_DIR, name + ".txt"), "w") as f:
                f.write(results[name])
        print("Wrote %d expected files to %s" % (len(check_names()), EXPECTED_DIR))
        return

    failures = 0
    for name in check_names():
        exp_path = os.path.join(EXPECTED_DIR, name + ".txt")
        diff_path = os.path.join(DIFFS_DIR, name + ".txt")
        if not os.path.exists(exp_path):
            print("SKIP %s (no expected file)" % name)
            continue
        with open(exp_path) as f:
            expected = f.read()
        got = results[name]
        if got == expected:
            print("PASS %s" % name)
            if os.path.exists(diff_path):
                os.remove(diff_path)
        else:
            failures += 1
            print("FAIL %s see diffs/%s.txt" % (name, name))
            with open(diff_path, "w") as f:
                exp_lines = expected.splitlines()
                got_lines = got.splitlines()
                f.write("--- expected (%d rows) ---\n" % len(exp_lines))
                f.write(expected if expected else "(empty)\n")
                f.write("\n--- your output (%d rows) ---\n" % len(got_lines))
                f.write(got if got else "(empty)\n")

    print()
    total = len(check_names())
    print("%d/%d checks passed" % (total - failures, total))
    sys.exit(1 if failures else 0)


if __name__ == "__main__":
    main()
