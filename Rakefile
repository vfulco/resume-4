require 'erb'
require 'hashie'
require 'yaml'

task :default => :generate

desc "Generate resume in all defined formats"
task :generate do
  @resume = Hashie::Mash.new(YAML::load(File.read('resume.yml')))
  Dir.glob('templates/*').each do |format|
    file_ext = format.sub(/\.erb$/,'').sub('templates/','')
    @filename = @resume.particulars.name.join('.').downcase
    File.open("output/#{@filename}.#{file_ext}",'w') do |file|
      file.write ERB.new(File.read(format)).result(binding)
    end
    Rake::Task["hooks:#{file_ext}"].invoke rescue nil
  end
end

namespace :hooks do
  task :txt do
    `cp output/#{@filename}.txt output/#{@filename}.htm`
    `elinks -dump 1 -dump-width 40 output/#{@filename}.htm > output/#{@filename}.txt`
    `rm output/#{@filename}.htm`
  end
end