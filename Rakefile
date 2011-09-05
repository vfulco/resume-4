require 'erb'
require 'hashie'
require './helpers.rb'
require 'yaml'

task :default => :generate

desc "Generate resume in all defined formats"
task :generate do
  load_resume
  Dir.glob('templates/*').each do |format|
    file_ext = format.sub(/\.erb$/,'').sub('templates/','')
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

task :publish do
  publish_branch = 'gh-pages'
  working_branch = 'master'
  Rake::Task[:generate].invoke
  `git checkout #{publish_branch} && cp output/#{@filename}.* . && cp #{@filename}.html index.html &&  git add . && git commit -m "Publish resume #{Time.now}" && git push origin #{publish_branch} && git checkout #{working_branch}`
end

namespace :hooks do
  namespace :tex do
    task :before do
      wget "https://github.com/philtr/resume/raw/gh-pages/rpi/res.cls", "./output/res.cls"
    end
    task :after do
      `cd ./output && pdflatex #{@filename}.tex`
      `rm ./output/res.cls`
      `rm ./output/#{@filename}.log`
    end
  end
  namespace :txt do
    task :after do
      `cp output/#{@filename}.txt output/#{@filename}.htm`
      `elinks -dump 1 -dump-width 80 output/#{@filename}.htm > output/#{@filename}.txt`
      `rm output/#{@filename}.htm`
    end
  end
end
