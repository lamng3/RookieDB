# RookieDB — Build / Run / Test

Maven project. Compiler targets **Java 1.8**, so any JDK 8–17 works (Java 17 is
what's installed here). Run all commands from the repo root.

## Compile
```bash
mvn clean compile               # compile sources -> target/classes
mvn clean package -DskipTests   # build target/database-1.0-SNAPSHOT.jar
```

## Run the CLI (SQL command-line interface)
```bash
mvn clean compile   # if not already compiled
java -cp target/classes edu.berkeley.cs186.database.cli.CommandLineInterface
```
The CLI is interactive. Type a query ending in `;`, or `exit` to quit. Example:
```sql
CREATE TABLE t (x int);
INSERT INTO t VALUES (1), (2), (3);
SELECT * FROM t;
```
Note: `SELECT` requires a `FROM` clause (e.g. `SELECT 1;` alone errors).

## Test
```bash
mvn test                                   # run all tests
mvn test -Dtest=TestBPlusNode              # one test class
mvn test -Dtest=TestBPlusNode#testGetLeaf  # one test method
```

## Pin a JDK (optional)
```bash
export JAVA_HOME=$(/usr/libexec/java_home -v 17)   # or -v 11 if installed
```

## Proj1 — SQL practice (separate from RookieDB)
Self-study harness in `proj1/`. Edit views in `proj1/proj1.sql`, then test.
```bash
cd proj1
python3 test.py                              # grade proj1.sql -> PASS/FAIL per question
cat diffs/q0.txt                             # expected vs. your output for a failing query
```
Other handy commands:
```bash
sqlite3 lahman.db                            # open the DB (.tables, .schema People, .quit)
python3 test.py --sql reference/solution.sql # run the answer key (17/17)
python3 test.py --sql reference/solution.sql --write-expected  # regenerate expected_output/
```
Notes: data is Lahman 1871–2022 (course uses 1871–2017), so this is for learning the
SQL, not matching the official grader. `lahman.db` lives in `proj1/` and is git-ignored.
