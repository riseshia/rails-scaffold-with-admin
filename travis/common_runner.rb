# frozen_string_literal: true
require "json"
require "open-uri"
require "English"

# CommonRunner
class CommonRunner
  private

  def run(command)
    output = `#{command}`
    cs = $CHILD_STATUS

    unless cs.success?
      puts "Command '#{command}' exited with status code #{cs.exitstatus}"
      exit cs.exitstatus
    end

    output.strip
  end

  def sysrun(command)
    puts command

    return if system(command)

    cs = $CHILD_STATUS
    puts "Command '#{command}' exited with status code #{cs.exitstatus}"
    exit cs.exitstatus
  end

  def rvm_sysrun(command)
    sysrun("/bin/bash --login -c \"rvm use default && #{command}\"")
  end
end