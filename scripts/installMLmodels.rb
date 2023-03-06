project_obj       = Xcodeproj::Project.open(project_path)
mlmodels_proup    = project_obj[group_name]
if !project_obj.main_group.children.include? mlmodels_proup
	mlmodels_proup = project_obj.new_group(group_name)
end
project_obj.native_targets.each do |target|
	if target.name == target_name
		if File.directory? mlmodels_path
			Dir.foreach(mlmodels_path) do |file|
				if File.extname(file) == ".mlmodel"
					mlFileExist = false
					project_obj.files.each do |file|
						if  Pathname.new(file_path).basename.to_s == file.display_name
							file.path = file_path
			            	mlFileExist = true
			            	break
						end
	           		end
    				if mlFileExist == false
        				addfile(group_obj, target_obj, file_path)
    				end
            	end
        	end
		end
	end
end
project_obj.save
