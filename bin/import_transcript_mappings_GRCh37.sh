#!/bin/bash
set -ex

wget ftp://ftp.ncbi.nlm.nih.gov/genomes/MapView/Homo_sapiens/sequence/ANNOTATION_RELEASE.105/initial_release/seq_gene.md.gz
zcat seq_gene.md.gz | sort -t'	' -k 11,11 -k 2,2 > seq_gene.sorted.md
mutalyzer-admin assemblies import-mapview seq_gene.sorted.md 'GRCh37.p13-Primary Assembly'
