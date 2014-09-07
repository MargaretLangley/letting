# http://myronmars.to/n/dev-blog/2014/09/rspec-3-1-has-been-released

begin
  require 'rspec/core/rake_task'

  desc "Run all but the slow and feature specs"
  RSpec::Core::RakeTask.new('spec:feature') do |t|
    t.pattern = "spec/features/**/*_spec.rb"
  end

  task 'feature' => 'db:test:prepare'
rescue LoadError => e
  desc 'Run all fast tests'
  task 'spec:feature' do
    abort 'spec:feature rake task is not available.'
  end
end
