# DBT + SodaSQL: how to manage your data at scale
Repository for Club Cloud workshop on dbt + SodaSQL. If you want to checkout the session, here's the youtube recording: [link](https://www.youtube.com/watch?v=_ITRXeYN9o4&list=PLC3RVtNPazW9tJfJjz20sNa3B8uzKAsAq&index=70)

## Runbook
This runbook will guide you through the setup required to make this repo run in your own environments.

### GCP setup
1. Create a GCP project (if you don't have one already)
2. Enable the BigQuery API
3. Create a Service Account with at least the following two roles:
    - BigQuery Data Editor
    - BigQery User
4. Download the `json` key file for later

Additionally, if you want to try this repository out using the exact same data, you can:
1. Enable the BigQuery Transfer Service
2. Create a destination dataset for your BigQuery Public Dataset (keep the same name if possible)
3. Then run the following command
```bash
bq mk --transfer_config --project_id=your-project-id --data_source=cross_region_copy --target_dataset=your-target-dataset --display_name='description' --params='{"source_dataset_id":"your-source-dataset","source_project_id":"your-project-id","overwrite_destination_table":"true"}'
```
4. Optionally you can use the UI for this copy job, but it did not work for me. Link [here](https://cloud.google.com/bigquery/docs/copying-datasets)

### dbt setup
1. Install dbt in your python environment (you can use conda or venv to manage this). If you want to follow the same specs used in this demo, then just run the following:
```bash
pip install -r requirements.txt
```
2. If you copied this repo, there's already a `profiles.yml` file that will work on the CI/CD pipeline under `.github/workflows/ad_hoc.yml`
3. Locally, you can add a new profile to your dbt default `profiles.yml`, which is usually located in the `.dbt` folder. Mine is located in `/Users/guillermosanchez/.dbt`. The profile should be the same as the one [here](./dbt/profiles.yml), but changing the keyfile path to your local `keyfile.json` path.
4. If you run `dbt debug` you can confirm that the setup is working.

### Soda-sql setup
1. Installation should already be ok if you run the first command of the previous block of this README
2. Authentication is provided in every `warehouse.yml` file (in our case this is `<name_of_dataset>.yml`). At the time me and my colleague Jovan made this demo, the only stable way we found was to provide Environment variables with the `API_KEY_ID` and `API_KEY_SECRET`, which you can get from the same `keyfile.json` used in the dbt setup.
3. You can generate basic scan files out of each `<name_of_dataset>.yml` by running:
```bash
soda analyze <name_of_dataset>.yml
```
&emsp;&emsp;&ensp; This files have already been generated with the current datasets created by the dbt project in this repository.<br>

4. If you have already created a dataset, and transfer some data (maybe even `dbt run` the dbt project), then you can test running a scan:
```bash
soda scan path/to/warehouse.yml path/to/scan.yml
```
&emsp;&emsp;&ensp; or
```bash
python soda/trigger_soda.py --dataset <name_of_dataset> --tables <table_names_separated_by_comma>
```

### Soda-cloud setup
1. Open a trial account at https://cloud.soda.io/
2. Go to Profile>API Keys and click on the `+` button to add a new API key.
3. You can set these API keys locally as environment variables if you want to run soda locally and collect the results in the cloud!
```bash
export API_KEY_ID=<soda_key_id>
export API_KEY_SECRET=<soda_key_secret>
```

### CI/CD pipeline
If you want to run the end to end set-up, you can do so from the `.github/workflows/ad_hoc.yml` pipeline. For this, you need to make sure to setup the following Github Secrets: 
- BIGQUERY_SERVICE_ACCOUNT: which contains the full content of the `keyfile.json`
- API_KEY_ID: your soda cloud API Key
- API_KEY_SECRET: your soda cloud API secret

