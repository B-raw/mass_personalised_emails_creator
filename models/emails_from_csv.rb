class EmailsFromCSV
  attr_reader :csv_array, :header_array, :body_array

  def import_csv_template(csv_file)
    @csv_array = CSV.read(csv_file)
    @header_array = @csv_array[0]
    @body_array = @csv_array.drop(1)
  end

  def import_email_template(email_template)
    @email_template = (File.readlines(email_template)).join
  end

  def return_personalised_emails
    @full_email_string = ""
    @body_array.each_with_index do |contact, row|
      @email_to_copy = @email_template
      @header_array.each_with_index do |header, index|
        raise "Your CSV data seems to be corrupted at row #{row+1}" if contact[index].nil?
        @email_to_copy = @email_to_copy.gsub(/<#{header}>/, contact[index])
      end
    @full_email_string += @email_to_copy + "\n___\n\n"
    @email_to_copy = @email_template
    end
  @full_email_string
  end

  def create_file_with_personalised_emails(filename)
    filename = "programme_output/" + filename + ".txt"
    File.open(filename, "w") do |f|
      f.write(return_personalised_emails)
    end
  end

end

# CSV.foreach("emailinformation.csv") do |row|
#   row.each {|x| puts x}
# end
=begin
for each csv array, you want to
- match header to template
- use header index to get contact[i], and replace template
=end
