#!/bin/bash
#
#
# Clean the database to make a new import
psql -U postgres -c "DROP DATABASE osm;"