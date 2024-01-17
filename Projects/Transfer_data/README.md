# The transfer of large datasets.

## Description:
The code aims to take a 'json' file, split it into smaller files with an exact number of lines, and then send the information to pgAdmin in parallel.

## Architecture 
<img src="arhitecture.jpeg">

## Technology Used
- Programming Language - Python

## Libraries Used
- psycopg2 - for connecting to pgAdmin, dropping and creating tables
- os - for working with metadata
- multiprocessing - for parallel data transmission
