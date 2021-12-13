# dbt project

This is just a standard dbt project with a stucture that resembles GoDataDriven's preferred way of organizing a data warehouse. This is by creating different representations for:
- Sources --> represented in the `source.yml` file.
- Staging models --> models under the `staging` folder. Staging models resemble source models in structure and only light cleaning is done:
    - Deduplication using primary keys.
    - Renaming of columns.
    - Testing of primary keys (unique, not null).
- Intermediate --> models under the `intermediate` folder. Intermediate models are aimed to be used as a possible step in between your staging models and your data marts to avoid pushing a lot of complexity into the data mart transformations. These are not always necessary.
- Marts --> models under the `marts` folder. We categorize them in two different types:
    - Core: this can be the core facts and dimensions of your data model.
    - Analytics: this can contain specific tables and views containing metrics for reporting. This models can also be placed in a separate layer if you consider that this separation of concerns is better.

In this project, there's a `schema.yml` file aimed at containing the schemas from all the models. However, **we believe it is better practice to have a specific file per folder!**

## Profile
There's a profiles.yml file in this repository that will be referenced by the CI/CD pipeline that runs dbt. Check the user guide if you want to understand how this happens under the hood. <br> 
Important to notice that this profiles file has a specific **location** and **project** defined. You should adjust this values to meet your criteria.
