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
