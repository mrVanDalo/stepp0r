
BUILD_DIR='./build'
version='0.2'
project_title="stepsequencer"
export_folder="#{project_title}-#{version}"

def copyTask srcGlob, targetDirSuffix, taskSymbol
    targetDir = File.join BUILD_DIR, targetDirSuffix
    mkdir_p targetDir, :verbose => false
    FileList[srcGlob].each do |f|
        target = File.join targetDir, File.basename(f)
        file target => [f] do |t|
            cp_r f, target
        end
        task taskSymbol => target
    end
end

copyTask 'src/*'         ,export_folder             ,:export_main

desc 'build the project'
task :build => :export_main

desc "package project to zip file"
task :package => :build do
    export="#{BUILD_DIR}/#{export_folder}"
    mkdir_p "pkg", :verbose => false
    sh "cd #{export}; zip -r ../../pkg/#{export_folder}.xrnx *"
end

desc 'clean up project'
task :clean do
    sh 'rm -rf build'
    sh 'rm -rf pkg'
end
