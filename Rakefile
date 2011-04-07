require 'erb'
require 'yaml'

task :default => :generate

desc "Generate resume in all defined formats"
task :generate do
  resume = YAML::load(File.read('resume.yml'))
  Dir.glob('templates/*').each do |format|
    file_ext = format.sub(/\.erb$/,'').sub('templates/','')
    filename = resume['particulars']['name'].to_a.collect{|n|n[1]}.join('.').downcase + "." + file_ext
    File.open("output/#{filename}",'w') do |file|
      file.write ERB.new(File.read(format)).result(binding)
    end
  end
end