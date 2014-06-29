
BUILD_DIR='./build'
version='0.1'
project_title="stepsequencer"
export_folder="#{project_title}-#{version}"

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

copyTask 'src/*.lua'         ,export_folder            ,:lua_main
copyTask 'src/Module/*.lua'  ,"#export_folder}/Module" ,:lua_modules
copyTask 'conf/manifest.xml' ,export_folder            ,:manifest
copyTask 'conf/icon.png'     ,export_folder            ,:icon

desc 'build the project'
task :build => :lua_main
task :build => :lua_modules
task :build => :manifest
task :build => :icon

