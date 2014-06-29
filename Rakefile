
BUILD_DIR='./build'
version='0.1'
project_title="stepsequencer"

def copyTask srcGlob, targetDirSuffix, taskSymbol
    targetDir = File.join BUILD_DIR, targetDirSuffix
    mkdir_p targetDir, :verbose => false
    FileList[srcGlob].each do |f|
        target = File.join targetDir, File.basename(f)
        file target => [f] do |t|
            cp f, target
        end
        task taskSymbol => target
    end
end

copyTask 'src/*.lua',         "#{project_title}-#{version}",        :lua_main
copyTask 'src/Module/*.lua',  "#{project_title}-#{version}/Module", :lua_modules
copyTask 'conf/manifest.xml', "#{project_title}-#{version}",        :manifest
copyTask 'conf/icon.png',      "#{project_title}-#{version}",        :icon

desc 'build the project'
task :build => :lua_main
task :build => :lua_modules
task :build => :manifest
task :build => :icon

