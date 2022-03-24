# Identify-Irregular-Respondents-Through-Response-Time

Identifying and controlling for poor respondents in online surveys is a difficult and non-trivial task in study design and data collection. The goal of this project is to analyze response time data in a network study and explore ways to identify problematic responses to inform future data collection.

## Repository Structure
 ```
.
├── data
│   ├── raw_data
│   ├── processed_data
│   ├── time_data
│   ├── answer_data
│   └── network_data
├── codes
│   ├── algorithms
│   └── data_process
├── results
│   └── cluster
├── README.md
├── report.pdf
└── id_summary.txt
 ```
 * Note: "q1" means the data includes the first five blocks of questions and q1 in the friendship block(6th)
 
 * Note2: "filled" means that we replace NA, negative values, outliers in time_data with mean
