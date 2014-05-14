$LOAD_PATH << "#{Dir.pwd}/lib"

task :test do
  FileList['test/*_test.rb'].each {|f| ruby f}
end