# Mass Personalised Email Creator

##Introduction & Problem Solved

I wanted a foolproof way to create an email template to send to many recipients, but personalise it. I didn't want to use Mailchimp as it can get blocked by certain domains.

Initially I used copy paste, but there was too much room for error and it was too laborious. There had to be a better way!

So I TDD'd this approach where you can provide a CSV file of columns of any information you want (eg NAME, EMAIL) and import an email template with tags (`<NAME>`, `<EMAIL>`). The programme will replace the tags with the correct information and generate one file with the emails in it. It is operated in irb/pry.

## Getting Started / Installation

1 Clone this repository and `cd` into it

2 Create two new folders: `mkdir programme_inputs programme_output`

3 Add your .csv file to the programme_inputs folder
  * Your CSV file should have a single header row

4 Add your email template .txt file to the programme_inputs folder
  * The format of the tags in the email template should be the same as your header row, but with <> either side. See Use Case Example for more details.

5 In terminal, open irb or pry

6 `email_generator = EmailsFromCSV.new`

7 `email_generator.import_csv_template("./programme_inputs/my_csv_file.csv")`

8 `email_generator.import_email_template("./programme_inputs/my_email_template.csv")`

9 `email_generator.create_file_with_personalised_emails("my_personalised_emails")` This will create a .txt file in programme_outputs called my_personalised_emails.txt which contains a list of your email_template, personalised to every row in your CSV file.

NB If your CSV data is corrupted - eg a cell is empty where it shouldn't be - the programme will throw an error pointing you towards the possible corrupted row - (`Your CSV data seems to be corrupted at row 22`). Fix the data and try to re-run.

## Use case example
I have the following email template:

```
Email: <EMAIL>

Dear <NAME>,

We really liked your work because <REASON>.

Many thanks and best wishes,
Michael
```

I need to send it to 3 recipients so I create the following CSV file:
```
EMAIL,NAME,REASON
test@test.com,Professor Richard Franks,we really loved your work
rick@rick.com,professor Rick Rick,I didn't like that
simon@simon.com,Professor Simons,fantastic heuristics
```

The programme maps the header row to the data held in each row. It then iterates over the email template replacing the tags (`<NAME>`) with what is in the `NAME` column.

The output would be:
```
Email: test@test.com

Dear Professor Richard Franks,

We really liked your work because we really loved your work.

Many thanks and best wishes,
Michael

___

Email: rick@rick.com

Dear professor Rick Rick,

We really liked your work because I didn't like that.

Many thanks and best wishes,
Michael

___

Email: simon@simon.com

Dear Professor Simons,

We really liked your work because fantastic heuristics.

Many thanks and best wishes,
Michael

___
```

## Running the tests

I developed this programme using a TDD approach.

You can see the tests in the spec folder.

To run the tests, enter `rspec` into the terminal from the root directory.

```
email_creator: $ rspec

EmailsFromCSV
  can return a string of email text with certain inputs
  can read a file containing an email into a string
  can import a csv file
  can create a separate header array
  can create a separate body array
  can replace the template markers with text from CSV
  can handle multiple random headers
  can handle multiple contacts to generate multiple emails
  raises an error if there are missing csv columns
  can save the output to a file
  doesn't care if a certain csv field isn't used

Finished in 0.00916 seconds (files took 0.17577 seconds to load)
11 examples, 0 failures
```

## Authors

B-raw

## License

Whatevs. Use it if you want.

This project is licensed under the [MIT License](http://choosealicense.com/licenses/mit/)
