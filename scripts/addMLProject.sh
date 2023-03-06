#!/bin/zsh bash
SHELL_FOLDER=$(cd "$(dirname "$0")";pwd)
RUBY_SCIRPT_FILE_NAME="$(basename "$0" ".sh")"
RUBY_SCIRPT_PATH="${SHELL_FOLDER}/${RUBY_SCIRPT_FILE_NAME}.rb"

MAIN_PROJ_NAME="$1"
MLMODELS_PATH=$2

INTER_MODULE_NAME='helpMLmodels'
MLMODEL_FILE_EXT='mlmodel'

#执行 ruby脚本 根据给定的mlmodel文件的路径给主工程添加.mlmodel引用
ruby $RUBY_SCIRPT_PATH "$MAIN_PROJ_NAME" "$MLMODELS_PATH" "$INTER_MODULE_NAME"

inter_module_path="${PROJECT_TEMP_DIR}/${CONFIGURATION}${EFFECTIVE_PLATFORM_NAME}/${INTER_MODULE_NAME}.build"

#遍历mlmodel文件夹路径，分别对.mlmodel文件进行编译
for model_path in "${MLMODELS_PATH}/*"
do
    model_name="$(basename $model_path)"
    model_ext="$(echo $model_name | sed 's/^.*\.//')"
    
    if [ -f $model_path -a $model_ext=$MLMODEL_FILE_EXT ]; then
      #generate_path 与 podspec 中设置的headersearch相似，不同的是headersearch是通过通配符访问上一级目录的
      generate_path="${inter_module_path}/DerivedSources/CoreMLGenerated/${model_name}"
      
      # $DEVELOPER_BIN_DIR、$CONFIGURATION 这种上下文缺失的参数请参考Xcode build环境变量。
      $DEVELOPER_BIN_DIR/coremlc generate $model_path $generate_path --output-partial-info-plist $inter_module_path/$model_name-CoreMLPartialInfo.plist --language Objective-C
    fi
done
