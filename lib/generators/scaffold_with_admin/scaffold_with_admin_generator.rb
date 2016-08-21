require "rubygems/specification"
require "rails/generators/named_base"
require "rails/generators/resource_helpers"

class ScaffoldWithAdminGenerator < Rails::Generators::NamedBase
  include Rails::Generators::ResourceHelpers

  source_root File.expand_path("../templates", __FILE__)

  attr_accessor :model, :params, :prefix

  def initialize(args, *options) #:nodoc:
    super
    model, *params = args
    self.model = model
    self.params = params
    self.prefix = "admins"
  end

  def create_scaffold
    generate "scaffold", model, params
  end

  def create_admin_controller
    create_file admin_controller_file_path, admin_controller_text
  end

  def create_admin_views
    copy_view_files
  end

  def create_admin_controller_tests
    test = test_type
    if test.nil?
      puts "Test is not detected, Test framework is not" \
           "supported or there is no one. Skip it."
      return
    end

    create_file admin_controller_test_file_path, admin_controller_test_text
  end

  hook_for :assets, in: :rails do |assets|
    invoke assets, [prefixed_class_name]
  end

  hook_for :resource_route, in: :rails do |resource_route|
    invoke resource_route, [prefixed_class_name]
  end

  hook_for :helper, in: :rails do |helper|
    invoke helper, [prefixed_controller_class_name]
  end

  protected

  def test_type
    return "test" unless Dir[File.join("test", "**")].empty?
    return "spec" unless Dir[File.join("spec", "**")].empty?
    nil
  end

  def available_views
    %w(index edit show new _form) + ["_#{singular_table_name}"]
  end

  def copy_view_files
    filenames = Dir[File.join("app/views", controller_file_path, "**")].select do |filename|
      filename.split("/").last.start_with?(*available_views)
    end.each do |filename|
      new_filename = filename.gsub("/#{controller_file_path}/", "/#{prefix}/#{controller_file_path}/")
      file_text = File.open(filename).read

      create_file new_filename, admin_view_text(file_text)
    end
  end

  def admin_view_text(file_text)
    file_text.
      gsub("form_for(#{singular_table_name})", "form_for([:#{prefix}, #{singular_table_name}])").
      gsub("link_to 'Show', @#{singular_table_name}", "link_to 'Show', #{prefixed_show_helper}_path(@#{singular_table_name})").
      gsub("link_to 'Show', #{singular_table_name}", "link_to 'Show', #{prefixed_show_helper}_path(#{singular_table_name})").
      gsub("link_to 'Destroy', #{singular_table_name}", "link_to 'Destroy', #{prefixed_show_helper}_path(#{singular_table_name})").
      gsub(" #{controller_file_name}_path", " #{prefix}_#{controller_file_name}_path").
      gsub(" edit_#{singular_table_name}_path", " edit_#{prefix}_#{singular_table_name}_path").
      gsub(" new_#{singular_table_name}_path", " new_#{prefix}_#{singular_table_name}_path").
      gsub(" #{singular_table_name}_url", " #{prefix}_#{singular_table_name}_url").
      gsub("#{controller_file_name}/#{singular_table_name}", "#{prefix}/#{controller_file_name}/#{singular_table_name}")

  end

  def prefixed_class_name
    "#{prefix.capitalize}::#{class_name}"
  end

  def prefixed_controller_class_name
    "#{prefix.capitalize}::#{controller_class_name}"
  end

  def origin_controller_file_path
    File.join("app/controllers", class_path, "#{controller_file_name}_controller.rb")
  end

  def admin_controller_file_path
    File.join("app/controllers", prefix, class_path, "#{controller_file_name}_controller.rb")
  end

  def origin_controller_file_text
    File.open(origin_controller_file_path).read
  end

  def admin_controller_test_file_path
    File.join(test_type, "controllers", prefix, class_path, "#{controller_file_name}_controller_#{test_type}.rb")
  end

  def origin_controller_test_file_path
    File.join(test_type, "controllers", class_path, "#{controller_file_name}_controller_#{test_type}.rb")
  end

  def origin_controller_test_text
    File.open(origin_controller_test_file_path).read
  end

  def prefixed_index_helper
    "#{prefix}_#{index_helper}"
  end

  def prefixed_show_helper
    "#{prefix}_#{singular_table_name}"
  end

  def prefixed_edit_helper
    "edit_#{prefix}_#{singular_table_name}"
  end

  def admin_controller_text
    origin_controller_file_text.
      gsub(/\n(?=.+)/, "\n  ").
      gsub(/(location: |redirect_to )@(\w+)/,
           "\\1#{prefixed_show_helper}_path(@\\2)").
      gsub(" #{index_helper}_url", " #{prefixed_index_helper}_url").
      gsub("class #{controller_class_name}Controller",
           "module Admins\n  class #{controller_class_name}Controller") +
      "end\n"
  end

  def admin_controller_test_text
    origin_controller_test_text.
      gsub(/\n(?=.+)/, "\n  ").
      gsub(" #{singular_table_name}_url", " #{prefixed_show_helper}_url").
      gsub(" edit_#{singular_table_name}_url", " #{prefixed_edit_helper}_url").
      gsub(" #{index_helper}_url", " #{prefixed_index_helper}_url").
      gsub("  class #{controller_class_name}Controller",
           "module Admins\n  class #{controller_class_name}Controller") +
      "end\n"
  end
end
