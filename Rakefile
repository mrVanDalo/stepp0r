

require 'fileutils'

BUILD_DIR='./build'
version='0.65'
project_title='Stepp0r'
export_folder="#{project_title}-#{version}"
test_folder="test-#{version}"

def copy_task(src_glob, target_dir_suffix, task_symbol)
  target_dir = File.join(BUILD_DIR, target_dir_suffix)
  FileUtils.mkdir_p(target_dir, :verbose => false)
  FileList[src_glob].each do |f|
    target = File.join(target_dir, File.basename(f))
    file target => [f] do
      FileUtils.cp_r f, target
    end
    task task_symbol => target
  end
end

copy_task 'src/*'       , export_folder , :export_main
copy_task 'LICENSE.txt' , export_folder , :export_main

copy_task 'src/*'  , test_folder   , :test_main
copy_task 'test/*' , test_folder   , :test_main

desc 'build the project'
task :build => :export_main

desc 'package project to zip file'
task :package => :build do
    export="#{BUILD_DIR}/#{export_folder}"
    FileUtils.mkdir_p("pkg", :verbose => false)
    sh "cd #{export}; zip -r ../../pkg/#{export_folder}.xrnx *"
end

desc 'clean up project'
task :clean do
    sh 'rm -rf build'
    sh 'rm -rf pkg'
end


