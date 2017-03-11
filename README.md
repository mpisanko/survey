# Survey
Your task is to build a CLI application to parse and display survey data from CSV files, and display the results.

## Data Format

### Survey Data
Included in the folder example-data are three sample data files defining surveys:
* test/fixtures/survey-1.csv
* test/fixtures/survey-2.csv
* test/fixtures/survey-3.csv

Each row represents a question in that survey with headers defining what question data is in each column.

### Response Data
And three sample files containing responses to the corresponding survey:
* test/fixtures/survey-1-responses.csv
* test/fixtures/survey-2-responses.csv
* test/fixtures/survey-3-responses.csv

Response columns are always in the following order:
* Email
* Employee Id
* Submitted At Timestamp (if there is no submitted at timestamp, you can assume the user did not submit a survey) 
* Each column from the fourth onwards are responses to survey questions.
* Answers to Rating Questions are always an integer between (and including) 1 and 5. 
* Blank answers represent not answered. 
* Answers to Single Select Questions can be any string.

## The Application

Your coding challenge is to build an application that allows the user to specify a survey file and a file for it's results. It should read them in and present a summary of the survey results. A command line application that takes a data file as input is sufficient.

The output should include: 

1. The participation percentage and total participant counts of the survey.
- Any response with a 'submitted_at' date has submitted and is said to have participated in the survey.
2. The average for each rating question
- Results from unsubmitted surveys should not be considered in the output. 

## Other information
As this is a command line utility it is not an OTP application.
The application logic is structured into data providers (`Survey.Providers...`) and calculators (`Survey.Calculators...`) - which provide extensibility points. I decided to leave presentation logic in `Survey` module (instead of creating `Survey.Presenters...` modules) as the `Survey` module is just used for CLI. Errors should be handled gracefully - by reporting them either at the entry point or when printing results. There is not much data validation (in particular I don't check that submitted_at matches a date pattern - just that it's not empty).

## Installation
To build and install the command line application run: `make compile && make install`

## Running
After installing you can run `bin/survey` passing it path to survey file (the one with questions) using --survey flag and response file path using --response flag.
Example: `bin/survey --survey test/fixtures/survey-1.csv --respons test/fixtures/survey-1-responses.csv`
You will be alerted about errors if you missed one of the flags or the path is incorrect / file does not exist.

## Testing
Run `mix test`
