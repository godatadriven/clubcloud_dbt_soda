# Soda project

## This project contains
- All soda configurations under datasets. For each dataset folder there is
    - A <dataset>.yml configuration specifying the name of the dataset and the credentials of BigQuery and Soda Cloud
    - A tables folder containing all the specific yamls for the soda scans (one per table)
- A script `trigger_soda.py` that allows you to run multiple scans programatically. This trigger is single threaded, therefore the performance could be enhanced by multithreading several scans at the same time.