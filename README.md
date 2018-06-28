# DMP_R: Data Management Plan in R

The goal of these R codes is to implement a data management by relying on very simple data sources (mainly CSV files).

In the related examples we suggest to manage the CSV files in collaborativer environments (such as google spreadsheets) to foster participation of collagues without having to deal with complicated tools (and ergonomics of related GUIs)


### Prerequisites

You need both datasets (CSV files) describing:
 - projects of your organization: described in a google spreadsheet [example here](https://docs.google.com/spreadsheets/d/1dQLucq5OAm1qBHPuJv_7mDEOWq9x0Cyknp6ecVtGtS4/edit#gid=0)
 - datasets produced by each project are described in a google spreadsheet (mainly Dublin Core metadata elements):[example here](https://docs.google.com/spreadsheets/d/1QViLsaw4FvjBDZX6bFzzUXjXca7eIRp43NB0Qv8zjc4/edit#gid=0)
 

Underlying R packages

Some samples to generate metadata from various sources
- OGC related: [geometa](https://github.com/eblondel/geometa), [geosapi](https://github.com/eblondel/geosapi), [geonapi](https://github.com/eblondel/geonapi) 
- Dataverse related: [dataverse]()

### Main steps of the workflow

The R codes do the following:
 - create a timeline of the projects [code here](https://docs.google.com/spreadsheets/d/1dQLucq5OAm1qBHPuJv_7mDEOWq9x0Cyknp6ecVtGtS4/edit#gid=0)
 - plot the number of datasets per project (by using online spreadhseets with Dublin Core metadata elements) :[code here](https://docs.google.com/spreadsheets/d/1QViLsaw4FvjBDZX6bFzzUXjXca7eIRp43NB0Qv8zjc4/edit#gid=0)
 - metadata can be transformed and published in OGC metadata and pushed in Geonetwork by using other R packages.



```
# Create a timeline

# Create a plot showing the number of metadata per project
```
 

## Authors

* **Julien Barde Thompson** 