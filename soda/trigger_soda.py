import argparse
from sodasql.scan.scan_builder import ScanBuilder
from typing import List

def run_soda_scan(dataset: str, table: str):
    scan_builder = ScanBuilder()
    scan_builder.warehouse_yml_file = "./datasets/{dataset}/{dataset}.yml"
    scan_builder.scan_yml_file = "./datasets/{dataset}/tables/{table}.yml"
    scan = scan_builder.build()
    scan_result = scan.execute()
    print(f"Finished scan of {dataset}.{table} with {scan_result.get_test_failures_count()} errors")

def run_partial_dataset_scan(dataset: str, tables: List[str]):
    pass

def run_full_dataset_scan(dataset: str):
    pass

def run_full_warehouse_scan():
    pass

if __name__=='__main__':
    parser = argparse.ArgumentParser(description="Helper to run progrmatic soda scans")
    parser.add_argument("--dataset", type=str, help="Dataset containing the table that you want to scan")
