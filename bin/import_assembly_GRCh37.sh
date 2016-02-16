#!/bin/bash
set -ex

mutalyzer-admin assemblies add /data/mutalyzer/extras/assemblies/GRCh37.json
mutalyzer-admin assemblies list
