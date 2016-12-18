require 'spec_helper'
require 'csv'

describe EmailsFromCSV do
  let(:emails_from_csv) { EmailsFromCSV.new }

  it "can return a string of email text with certain inputs" do
    emails_from_csv.import_csv_template("spec/test_files/emailinformation.csv")
    expected_array = [["test@test.com", "Professor Richard Franks", "we really loved your work"],["rick@rick.com", "professor Rick Rick", "I didn\'t like that"]]
    expect(emails_from_csv.csv_array).to eq expected_array
  end

  it "can read a file containing an email into a string" do
    emails_from_csv.import_csv_template("spec/test_files/emailinformation.csv")
    expected_email_template = "Email: <EMAIL>

Dear <NAME>,

We really liked your work because <REASON>.

Many thanks and best wishes,
Michael
"
    expect(emails_from_csv.import_email_template("spec/test_files/email_template.txt")).to eq expected_email_template
  end

  it "can import a csv file" do
    header_from_csv = EmailsFromCSV.new
    header_from_csv.import_csv_template("spec/test_files/header_plus_contact_information.csv")
    emails_from_csv.import_csv_template("spec/test_files/emailinformation.csv")
    expected_array = [["test@test.com", "Professor Richard Franks", "we really loved your work"],["rick@rick.com", "professor Rick Rick", "I didn\'t like that"]]
    expect(emails_from_csv.csv_array).to eq expected_array
  end

  it("can create a separate header array") do
    header_from_csv = EmailsFromCSV.new
    header_from_csv.import_csv_template("spec/test_files/header_plus_contact_information.csv")

    expected_header_array = ["EMAIL", "NAME", "REASON"]
    expect(header_from_csv.header_array).to eq expected_header_array
  end

  it("can create a separate body array") do
    header_from_csv = EmailsFromCSV.new
    header_from_csv.import_csv_template("spec/test_files/header_plus_contact_information.csv")
    expected_body_array = [["test@test.com", "Professor Richard Franks", "we really loved your work"]]
    expect(header_from_csv.body_array).to eq expected_body_array
  end

  it "can replace the template markers with text from CSV" do
    header_from_csv = EmailsFromCSV.new
    header_from_csv.import_csv_template("spec/test_files/header_plus_contact_information.csv")
    expected_personalised_email = "Email: test@test.com

Dear Professor Richard Franks,

We really liked your work because we really loved your work.

Many thanks and best wishes,
Michael

___

"

    header_from_csv.import_email_template("spec/test_files/email_template.txt")
    expect(header_from_csv.return_personalised_emails).to eq expected_personalised_email
  end

  it "can handle multiple random headers" do
    header_from_csv = EmailsFromCSV.new
    header_from_csv.import_csv_template("spec/test_files/multiple_header.csv")

    expected_personalised_email = "Email: test@test.com

Dear Professor Richard Franks,
I hate Cheesey Chips.
We really liked your work because we really loved your work.
I love Macaroni Cheese
Many thanks and best wishes,
Michael

___

"

    header_from_csv.import_email_template("spec/test_files/multiple_header_template.txt")
    expect(header_from_csv.return_personalised_emails).to eq expected_personalised_email
  end

  it "can handle multiple contacts to generate multiple emails" do
    email_from_csv = EmailsFromCSV.new
    email_from_csv.import_csv_template("spec/test_files/header_multiple_contacts.csv")

    expected_personalised_email = "Email: test@test.com

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

"

    email_from_csv.import_email_template("spec/test_files/email_template.txt")
    expect(email_from_csv.return_personalised_emails).to eq expected_personalised_email
  end

  it("raises an error if there are missing csv columns") do
    email_from_csv = EmailsFromCSV.new
    email_from_csv.import_csv_template("spec/test_files/broken_data.csv")

    email_from_csv.import_email_template("spec/test_files/email_template.txt")
    expect { email_from_csv.return_personalised_emails }.to raise_error("Your CSV data seems to be corrupted at row 3")
  end

  it("can save the output to a file") do
    email_from_csv = EmailsFromCSV.new
    email_from_csv.import_csv_template("spec/test_files/header_multiple_contacts.csv")

    expected_personalised_email = "Email: test@test.com

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

"
    email_from_csv.import_email_template("spec/test_files/email_template.txt")
    email_from_csv.create_file_with_personalised_emails("emails_from_csv")
    expect(File.file?('./programme_output/emails_from_csv.txt')).to eq true
    expect(File.readlines('./programme_output/emails_from_csv.txt').join).to eq expected_personalised_email
    if File.file?('./programme_output/emails_from_csv.txt')
      File.delete('./programme_output/emails_from_csv.txt')
    end
  end

  it("doesn't care if a certain csv field isn't used") do
    header_from_csv = EmailsFromCSV.new
    header_from_csv.import_csv_template("spec/test_files/header_plus_contact_information.csv")
    expected_personalised_email = "Email: big@guy.com

Dear big guy,

We really liked your work because we really loved your work.

Many thanks and best wishes,
Michael

___

"

    header_from_csv.import_email_template("spec/test_files/email_template_REASON.txt")
    expect(header_from_csv.return_personalised_emails).to eq expected_personalised_email
  end



end
