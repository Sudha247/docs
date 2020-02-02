# Bounding Data Races in Space and time

1. Introduction

Mainstream languages like C++ and Java have adopted complicated memory models to leverage aggressive compiler optimizations, making them difficult to program against directly.

**Data Race Freedom:** (DRF) All concurrent access variables need to be marked atomic giving the program sequential semantics. Program semantics are expected to be compositional.

2. Global DRF to local DRF

DRF programs have sequential semantics &rarr; All DRF parts of programs have sequential semantics.

  * **Bounding Data Races in Space:** data race in one variable should not affect acces to other variables.
  * **Bounding Data Races in Time:** Future data race can affect the past.
