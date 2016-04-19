require 'fileutils'


#
# configurable parameters
#
BUILD_DIRECTORY = 'build'
VERSION = '0.71'
PROJECT_TITLE = 'Stepp0r'
FLAVORS_DIRECTORY = 'flavors'
SRC_DIRECTORY = 'src'
PACKAGE_DIRECTORY = 'pkg'

#
# src/Data/Color.lua => ['src', 'Data', 'Color.lua']
#
# tail-recursive
def path_to_array(path, rest = [])
  (root,file)=File.split(path)
  if root == file
    rest
  else
    path_to_array(root, [file] + rest )
  end
end

#
# all flavors available right now
#
flavors = Dir["#{FLAVORS_DIRECTORY}/*"].map do |flavor|
  File.join(path_to_array(flavor).drop(1))
end


#
# all files which are interesting
#

src_files = Dir.glob("#{SRC_DIRECTORY}/**/*").select {
    |file| File.file?(file)
}.map {
    |file| File.join(path_to_array(file).drop(1))
}


project_title="#{PROJECT_TITLE}-#{VERSION}"

desc 'build all flavors'
task :build

desc 'package all'
task :package

desc 'package all on windows'
task :package_windows



#
# ============================================================
# create all flavor tasks
# ============================================================
#
flavors.each do |flavor|

  # ------------------------------------------------------------
  # build the project
  # ------------------------------------------------------------

  full_project_title = "#{project_title}-#{flavor}"
  build_dir = File.join(BUILD_DIRECTORY, full_project_title )
  flavor_build_task = "build-#{flavor}"

  desc "build #{flavor}"
  task flavor_build_task

  task :build => flavor_build_task
  src_files.each do |src_file|

    target_file = File.join(build_dir, src_file)

    #
    # recipe how to create target_file
    #
    file target_file do
      flavor_file_override = File.join(FLAVORS_DIRECTORY, flavor, src_file)
      default_file= File.join(SRC_DIRECTORY, src_file)
      FileUtils.mkdir_p(File.dirname(target_file), :verbose => false)

      if File.exists?(flavor_file_override)
        puts "#{flavor} override #{flavor_file_override}"
        FileUtils.cp_r flavor_file_override, target_file
      else
        FileUtils.cp_r default_file, target_file
      end
    end

    #
    # flavor build depends on that targetfile
    #
    task flavor_build_task => target_file

  end



  # ------------------------------------------------------------
  # package the project
  # ------------------------------------------------------------
  package_task = "package-#{flavor}"
  desc "package #{flavor}"
  task package_task => flavor_build_task do
    FileUtils.mkdir_p(PACKAGE_DIRECTORY, :verbose => false)
    sh "cd #{build_dir}; zip -r ../../#{PACKAGE_DIRECTORY}/#{full_project_title}.xrnx *"
  end
  task :package => package_task

  package_windows_task = "package-#{flavor}-windows"
  desc "package #{flavor} on windows"
  task package_windows_task  => flavor_build_task do
    FileUtils.mkdir_p(PACKAGE_DIRECTORY, :verbose => false)
    Dir.chdir "#{build_dir}"
    system  "../../zip -vr ../../#{PACKAGE_DIRECTORY}/#{full_project_title}.xrnx *"
  end

  task :package_windows => package_windows_task

end




# ------------------------------------------------------------
# clean the project
# ------------------------------------------------------------

desc 'clean up project'
task :clean do
  sh "rm -rf #{BUILD_DIRECTORY}"
  sh "rm -rf #{PACKAGE_DIRECTORY}"
end

desc 'clean up project in windows'
task :clean_windows do
  system "rmdir /s /q #{BUILD_DIRECTORY}"
  system "rmdir /s /q #{PACKAGE_DIRECTORY}"
end


