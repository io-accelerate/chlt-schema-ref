# chlt-schema-ref

The JSON Schema for coding challenges hosted on the https://accelerate.io platform.

## The Schema

This schema defines the structure for coding challenges, ensuring consistency and clarity in their design. 
Each challenge has a unique identifier, a name, and consists of multiple rounds. 
Each round includes a description, methods to implement, and test cases to validate the implementation. 

The latest schema can be retrieved from:
https://get.accelerate.io/challenge-toolkit/schema/version/0.2.3/schema.yaml

### Root Document
- `$schema` is always written by the Java writer using `https://get.accelerate.io/challenge-toolkit/schema/version/0.2.3/schema.yaml`. Authors should not override it.
- `id` must be uppercase and unique. It is also used to build the on-disk path when exporting a challenge.
- `version` is mandatory for the library, even though the JSON Schema does not declare it. Writers include it when generating `.../<id>/v<version>/definition.yaml`, so omit it only if you intend to manage the file manually.
- `name` is the human-readable challenge title shown in tooling.
- `rounds` is an ordered list; order is preserved when the library presents the challenge.

### Round Blocks
Each entry in `rounds` must contain an `id`, `description`, `methods`, and `tests`. 
The writer strips trailing spaces on every line of `description`, so avoid relying on whitespace-sensitive formatting.

#### Method Definitions
- `methods` is a list of method descriptions. The library keeps the declared order.
- Every method item needs `name`, `params`, and `returns`.
- `params` are positional. They must be declared in call order; test invocations are matched positionally.
- `returns` describes the output type and documentation for the method result.

##### Supported Type Strings
`type` values are stored as strings but deserialised into richer type definitions. Only the following canonical forms are recognised:
- Primitives: `string`, `integer`, `boolean`.
- Lists: `list(<primitive>)` where `<primitive>` is one of the primitives above. Nested lists are not supported.
- Maps: `map(<primitive>)`; keys are strings, and values must be primitive.
- Objects: `object({field=primitive,...})`. Every field type must be one of the primitive names, and all declared fields are required at runtime.
  If an unsupported type string is used, the loader fails during deserialisation, even though the JSON Schema only checks that the value is a string.

#### Test Cases
- `tests` is a list of cases executed against the defined methods. Test `id`s follow the `CHALLENGEID_R#_##` pattern described in the JSON Schema, but the library treats them purely as identifiers.
- `call.method` must match a method declared in the same round. The helper collection raises `Method <name> not found` if the name cannot be resolved.
- `call.args` supplies positional arguments. The library does not perform deep type validation here, so it is the author's responsibility to keep them consistent with the declared parameter types.

#### Assertions (`expect`)
Only a single assertion is read per test; the deserialiser takes the first key/value pair in the `expect` map. Acceptable keys and their expectations are:
- `equals`: value must match the method's declared return type. `null` is allowed for nullable results.
- `isNull`: value is typically `true`; only the presence of the key is significant and the runtime will assert that the method returns `null`.
- `containsString`: value must be a string. The target method must return a string containing this value.
- `containsStringIgnoringCase`: as above, but case-insensitive.
- `multilineStringEquals`: string comparison performed using multi-line semantics.
  If multiple keys are provided in `expect`, only the first one survives deserialisation; the rest are ignored. Ensure you supply exactly one assertion per test.

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