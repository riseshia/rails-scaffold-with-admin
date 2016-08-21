#!/usr/bin/env ruby
# frozen_string_literal: true
require_relative "common_runner"

# TestRunner
class TestRunner < CommonRunner
  def execute
    [
      "bundle",
      "rails new project",
      "cd project",
      "echo 'gem \"rails-scaffold-with-admin\", github: \"riseshia/rails-scaffold-with-admin\"' >> Gemfile",
      "bundle",
      "bin/rails generate scaffold_with_admin Model title:string content:text",
      "bin/rails db:migrate",
      "bin/rake"
    ].each do |command|
      sys_run command
    end
  end
end
