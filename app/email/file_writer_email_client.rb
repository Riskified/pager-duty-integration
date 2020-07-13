class FileWriterEmailClient
  def send_email(recipients, content, subject)
    File.write('report.html', content)
  end
end
