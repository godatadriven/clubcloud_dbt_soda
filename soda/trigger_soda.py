import subprocess

def run_soda_scan(dataset: str, table: str):
    subprocess.run(['soda', 'scan', f'datasets/{dataset}/{dataset}.yml', f'datasets/{dataset}/tables/{table}.yml'])
    print(f"Finished scan of {dataset}.{table}")

if __name__=='__main__':
    pass
