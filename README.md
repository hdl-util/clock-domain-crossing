# Clock Domain Crossing

SystemVerilog modules for [clock domain crossing](https://en.wikipedia.org/wiki/Clock_domain_crossing) on an FPGA.

[![Build Status](https://travis-ci.com/hdl-util/clock-domain-crossing.svg?branch=master)](https://travis-ci.com/hdl-util/clock-domain-crossing)

## First-in First-out Buffer (FIFO)

A [FIFO](https://en.wikipedia.org/wiki/FIFO_(computing_and_electronics)) is a technique especially for high data rate transfer, backed by dual-clock RAM.

### Why?

Intel's dc_fifo just wasn't working for me.

### Usage

1. Take files from `src/` and add them to your own project. If you use [hdlmake](https://hdlmake.readthedocs.io/en/master/), you can add this repository itself as a remote module.
1. Other helpful modules are also available in this GitHub organization.
1. Consult the testbench in `tets/fifo_tb.sv` for example usage.
1. Read through the parameter descriptions in `fifo.sv` and tailor any instantiations to your situation.
1. Please create an issue if you run into a problem or have any questions.

### Features

* Overflow and underflow protection behavior

## To-do List

* [ ] Confirm metastability handling is 100% correct
    * If you have experience with clock domain crossing, I would appreciate it if you took a look!
