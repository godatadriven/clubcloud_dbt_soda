import argparse
from pathlib import Path
from sodasql.scan.scan_builder import ScanBuilder
from typing import List
from datetime import date

def run_soda_scan(dataset: str, table: str):
    scan_builder = ScanBuilder()
    scan_builder.warehouse_yml_file = f"./soda/datasets/{dataset}/{dataset}.yml"
    scan_builder.scan_yml_file = f"./soda/datasets/{dataset}/tables/{table}.yml"
    scan_builder.variables = {"date": date.today().strftime("%d-%m-%Y")}
    scan = scan_builder.build()
    scan_result = scan.execute()
    print(f"Finished scan of {dataset}.{table} with {scan_result.get_test_failures_count()} errors")

def run_partial_dataset_scan(dataset: str, tables: List[str]):
    print(f"Running a partial dataset scan on dataset {dataset}...")
    for table in tables:
        run_soda_scan(dataset, table)

def run_full_dataset_scan(dataset: str):
    print(f"Running a full dataset scan on dataset {dataset}...")
    path = Path(f"./soda/datasets/{dataset}/tables/")
    tables = [f.stem.split(',')[0] for f in path.glob("*.yml")]
    for table in tables:
        run_soda_scan(dataset, table)

def run_full_warehouse_scan():
    print("Running a full warehouse scan...")
    path = Path("./soda/datasets/")
    for p in path.iterdir():
        run_full_dataset_scan(p.name)

if __name__=='__main__':
    parser = argparse.ArgumentParser(description="Helper to run progrmatic soda scans")
    parser.add_argument("--dataset", type=str, help="Dataset containing the table(s) that you want to scan", required=False)
    parser.add_argument("--tables", type=str, help="Single table or several tables separated by ',' that you want scan", required=False)
    args = parser.parse_args()

    if args.dataset is None and args.tables is not None:
        raise ValueError("You have provided table(s) but have not provided a dataset")

    elif args.dataset is None and args.tables is None:
        run_full_warehouse_scan()

    elif args.dataset is not None and args.tables is None:
        run_full_dataset_scan(args.dataset)

    else:
        if ',' in args.tables:
            tables = args.tables.strip().split(',')
            run_partial_dataset_scan(args.dataset, tables)
        else:
            run_soda_scan(args.dataset, args.tables)