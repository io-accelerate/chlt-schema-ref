# chlt-schema-ref

The JSON Schema for coding challenges hosted on the https://accelerate.io platform.

## The Schema

This schema defines the structure for coding challenges, ensuring consistency and clarity in their design. 
Each challenge has a unique identifier, a name, and consists of multiple rounds. 
Each round includes a description, methods to implement, and test cases to validate the implementation. 

The latest schema can be retrieved from:
https://get.accelerate.io/challenge-toolkit/schema/version/0.1.4/schema.yaml

## Challenge Design Guidelines

### 1. The challenge should be split into 5 incremental rounds

The reporting is optimised for displaying 5 rounds.

In order to minimise the complexity of the setup, we tend to break all challenges into 5 different rounds.

### 2. The entry point is a single method with a simple type as the input: strings, numbers or lists

Examples:
```
sum(Integer, Integer): Integer
hello(String): String
fizz_buzz(Integer): String
array_sum(List(Integer)): Integer
```

### 3. A challenge round should have a text description

Each round should describe one or multiple requirements that need to be implemented.

The description could be vague or specific, the user always has the option to deploy the solution in order to receive some feedback in the form of server side test failures.

### 4. A challenge round has a list of server side tests

The test should assert against the entry point using "equal_to"
```
sum.call(0, 1).eq(1),
sum.call(5, 6).eq(11)
```

Provide extensive coverage of the challenge requirements in order to prevent people from gaming the system by hardcoding the result to a server side test.
```
example.of(i -> i+"", 1, 2, 11, 31, 52, 811, 997),
example.of("fizz", 3, 9, 51, 111, 369, 3636),
example.of("buzz", 5, 10, 100, 500, 1400),
example.of("fizz buzz", 15, 30, 105, 1005)
```

The order of the tests is not guaranteed, the tests should be independent.