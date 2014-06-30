JSON-Dump
=========

NSJSONSerialization category to dump JSON objects as they are parsed, useful for testing.

##How to use:##

1. Import the file in "Class Categories" into your project.
2. #import the header.
3. Call [NSJSONSerialization activate];

Now anytime you parse JSON, it will be written to disk in your apps "documents" directory in a sub folder called "JSON DUMP"

These can be useful for stubing out network calls for unit tests, or just general debugging.
