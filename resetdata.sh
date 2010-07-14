#!/bin/bash

rm data.dat
cat basedata/schema.sql | sqlite3 data.dat
cat basedata/case1.sql | sqlite3 data.dat
