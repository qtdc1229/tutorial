  #省略掉了不必要的字段只保留了关键部分
  s.ios.deployment_target = '11.0'

  s.source_files = "#{s.name}/classes/**/*"

  temp_module_name='helpMLModels' # 定义的虚拟文件夹名称
  script_file_name = 'installMLmodels' # 脚本名称
  main_proj_name = 'testMLProj' # 主工程名称
  
  s.xcconfig = { 'USER_HEADER_SEARCH_PATHS' => "\"${PROJECT_TEMP_DIR}/${CONFIGURATION}${EFFECTIVE_PLATFORM_NAME}/#{temp_module_name}.build/DerivedSources/CoreMLGenerated/**\"" }
  s.resource_bundles = {
      s.name => ["#{s.name}/Assets/**/*"]
    }
  #add script_phase to #{s.name} BuildPhase before compile source
  script_file_path  = Pathname.new(__FILE__).realpath.dirname.to_s.force_encoding('UTF-8')
  script_command = "bash #{script_file_path}/#{s.name}/scripts/#{script_file_name}.sh #{main_proj_name}  #{script_file_path}/#{s.name}/models  \n echo \"#{s.name} build #{temp_module_name} finish\""
  s.script_phase = { :name => 'install mlmodel files', :shell_path => '/bin/bash', :script => script_command , :execution_position => :before_compile }
