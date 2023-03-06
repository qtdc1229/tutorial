#!/bin/sh

MIN_VAR_NUM=1

echo "开始执行图标裁剪脚本"

if [ $# -lt $MIN_VAR_NUM ]; then 
  echo "参数个数不能少于$MIN_VAR_NUM个！" 
fi

SOURCE_IMG_PATH=$1
if [ -f "$SOURCE_IMG_PATH" ]; then
  echo "源图片为 $SOURCE_IMG_PATH"
else
  echo "图片不存在，请重新输入"
  exit
fi

#sips 如果不存在需要安装
if [! $(command -v sips) ]; then 
  echo "sips 没有安装请安装后重试"
  exit
fi


iPhoneIcon() {
  echo "开始裁剪iPhone icons"
  iosDir=./AppIcon
  iconName=appicon-
  #AppIcon 目录不存在就新建
  if [ ! -d "$iosDir" ]; then mkdir $iosDir; echo "创建 $iosDir"; fi

  icons=(180 167 152 120 87 80 60 58 40)
  
  for ((i=0;i<${#icons[@]};++i)) ; do
    size=${icons[i]}
    outputPath=$iosDir/$iconName$size.png
    sips -Z $size $SOURCE_IMG_PATH --out $outputPath > /dev/null 2>&1
    [ $? -eq 0 ] && echo -e "info:\tresize ${size} successfully." || echo -e "info:\tresize ${size} failed."
  done

   # 转换1024图片为jpg，防止有透明区域导致上传 App Store 失败
  icon_1024_jpg_path="${iosDir}/${iconName}1024.jpg"
  sips -s format jpeg $SOURCE_IMG_PATH --out ${icon_1024_jpg_path} > /dev/null 2>&1
  [ $? -eq 0 ] && echo -e "info:\tresize 1024 to jpg successfully." || echo -e "info:\tresize 1024 to jpg  failed."
  # # iphone notification 20pt
  # sips -z 40 40 $SOURCE_IMG --out ./AppIcon/20@2x.png
  # sips -z 60 60 $SOURCE_IMG --out ./AppIcon/20@3x.png
  # # iphone settings 29pt
  # sips -z 58 58 $SOURCE_IMG --out ./AppIcon/29@2x.png
  # sips -z 87 87 $SOURCE_IMG --out ./AppIcon/29@3x.png
  # #iphone spotlight 40pt
  # sips -z 80 80 $SOURCE_IMG --out ./AppIcon/40@2x.png
  # sips -z 120 120 $SOURCE_IMG --out ./AppIcon/40@3x.png
  # #iphone app 60pt
  # sips -z 120 120 $SOURCE_IMG --out ./AppIcon/60@2x.png
  # sips -z 180 180 $SOURCE_IMG --out ./AppIcon/60@3x.png
  # #iphone store 1024pt
  # sips -z 1024 1024 $SOURCE_IMG --out ./AppIcon/1024.png

  echo '{
    "images" : [
      {
          "size" : "20x20",
          "idiom" : "iphone",
          "filename" : "appicon-40.png",
          "scale" : "2x"
      },
      {
          "size" : "20x20",
          "idiom" : "iphone",
          "filename" : "appicon-60.png",
          "scale" : "3x"
      },
      {
          "size" : "29x29",
          "idiom" : "iphone",
          "filename" : "appicon-58.png",
          "scale" : "2x"
      },
      {
          "size" : "29x29",
          "idiom" : "iphone",
          "filename" : "appicon-87.png",
          "scale" : "3x"
      },
      {
          "size" : "40x40",
          "idiom" : "iphone",
          "filename" : "appicon-80.png",
          "scale" : "2x"
      },
      {
          "size" : "40x40",
          "idiom" : "iphone",
          "filename" : "appicon-120.png",
          "scale" : "3x"
      },
      {
          "size" : "60x60",
          "idiom" : "iphone",
          "filename" : "appicon-120.png",
          "scale" : "2x"
      },
      {
          "size" : "60x60",
          "idiom" : "iphone",
          "filename" : "appicon-180.png",
          "scale" : "3x"
      },
      {
          "idiom" : "ipad",
          "size" : "20x20",
          "scale" : "1x"
      },
      {
          "size" : "20x20",
          "idiom" : "ipad",
          "filename" : "appicon-40.png",
          "scale" : "2x"
      },
      {
          "idiom" : "ipad",
          "size" : "29x29",
          "scale" : "1x"
      },
      {
          "size" : "29x29",
          "idiom" : "ipad",
          "filename" : "appicon-58.png",
          "scale" : "2x"
      },
      {
          "idiom" : "ipad",
          "size" : "40x40",
          "scale" : "1x"
      },
      {
          "size" : "40x40",
          "idiom" : "ipad",
          "filename" : "appicon-80.png",
          "scale" : "2x"
      },
      {
          "idiom" : "ipad",
          "size" : "76x76",
          "scale" : "1x"
      },
      {
          "size" : "76x76",
          "idiom" : "ipad",
          "filename" : "appicon-152.png",
          "scale" : "2x"
      },
      {
          "size" : "83.5x83.5",
          "idiom" : "ipad",
          "filename" : "appicon-167.png",
          "scale" : "2x"
      },
      {
          "size" : "1024x1024",
          "idiom" : "ios-marketing",
          "filename" : "appicon-1024.jpg",
          "scale" : "1x"
      }
    ],
    "info" : {
      "author" : "xcode",
      "version" : 1
    }
  }' > $iosDir/Contents.json

  echo -e "iPhone icons 裁剪完成"
}

iPhoneIcon

AndroidIcon() {
  echo "开始裁剪Android icons"
  androidDir=./AndroidIcon
  if [ ! -d "$androidDir" ]; then mkdir $androidDir; fi

  paths_array=("mipmap-hdpi" "mipmap-mdpi" "mipmap-xhdpi" "mipmap-xxhdpi" "mipmap-xxxxhdpi")
  size_array=("72" "48" "96" "144" "192")

  for ((i=0;i<${#size_array[@]};++i)) ; do
    name=${paths_array[i]}
    size=${size_array[i]}
    outputPath=$androidDir/$name
    if [ ! -d "$outputPath" ]; then mkdir $outputPath; fi
    sips -Z ${size} $SOURCE_IMG_PATH --out $outputPath/ic_launcher.png > /dev/null 2>&1
    [ $? -eq 0 ] && echo -e "info:\tresize ${size} ${name} successfully." || echo -e "info:\tresize ${name} failed."
    sips -Z ${size} $SOURCE_IMG_PATH --out $outputPath/ic_launcher_round.png > /dev/null 2>&1
    [ $? -eq 0 ] && echo -e "info:\tresize ${size} ${name} round successfully." || echo -e "info:\tresize ${name} round failed."
  done
  echo "Android icons裁剪完成"
}

AndroidIcon

echo "图标裁剪完成，谢谢惠顾"
