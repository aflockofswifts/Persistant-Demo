# @dynamicMemeberLookup storage example

This example project shows how to use `@dynamicMemeberLookup` to create a wrapper that side effects access to its wrappedValue's members to write to an abstracted storage service.  

Multiple conforming storage services are provide to demonstrate how different implmentations can be swapped out for the same protocol without touching any of the code except the line that injects the dependency.  

Forked from: https://github.com/codger/Persistant-Demo

