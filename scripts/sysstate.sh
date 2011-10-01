#!/bin/bash

# Get system information state from syssctl.
# This works on OS X, not so much on Linux

CLOCK=`sysctl -n kern.clockrate`
