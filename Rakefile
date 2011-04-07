require 'erb'
require 'hashie'
require './helpers.rb'
require 'yaml'

task :default => :generate

desc "Generate resume in all defined formats"
task :generate do
  @resume = Hashie::Mash.new(YAML::load(ERB.new(File.read('resume.yml')).result(binding)))
  Dir.glob('templates/*').each do |format|
    file_ext = format.sub(/\.erb$/,'').sub('templates/','')
    @filename = @resume.particulars.name.join('.').downcase
    Rake::Task["hooks:#{file_ext}:before"].invoke rescue nil
    File.open("output/#{@filename}.#{file_ext}",'w') do |file|
      file.write ERB.new(File.read(format)).result(binding)
    end
    Rake::Task["hooks:#{file_ext}:after"].invoke rescue nil
  end
end

task :clean do
  `rm output/*.*`
end

task :publish, :branch do |t, args|
  `cp output/*.* .`
  `mv #{@filename}.html index.html`
  `git checkout #{args.branch}`
  `git commit -m "Publish resume #{Time.now}"`
  `git checkout $(current_branch)`
end

namespace :hooks do
  namespace :tex do
    task :before do
      wget "https://github.com/philtr/resume/raw/gh-pages/rpi/helvetica.sty", "./output/helvetica.sty"
      wget "https://github.com/philtr/resume/raw/gh-pages/rpi/res.cls", "./output/res.cls"
    end
    task :after do
      `cd ./output && pdflatex #{@filename}.tex`
      `rm ./output/helvetica.sty`
      `rm ./output/res.cls`
      `rm ./output/#{@filename}.log`
    end
  end
  namespace :txt do
    task :after do
      `cp output/#{@filename}.txt output/#{@filename}.htm`
      `elinks -dump 1 -dump-width 40 output/#{@filename}.htm > output/#{@filename}.txt`
      `rm output/#{@filename}.htm`
    end
  end
end
