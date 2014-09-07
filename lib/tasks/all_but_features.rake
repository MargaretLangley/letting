# http://myronmars.to/n/dev-blog/2014/09/rspec-3-1-has-been-released

require 'rspec/core/rake_task'

desc "Run all but the acceptance specs"
RSpec::Core::RakeTask.new(:all_but_features) do |t|
  t.exclude_pattern = "spec/features/**/*_spec.rb"
end
