# 学习react native项目资源
# https://reactnative.cn/docs/getting-started.html

npm install -g yarn react-native-cli

yarn config set registry https://registry.npm.taobao.org --global
yarn config set disturl https://npm.taobao.org/dist --global

react-native init AwesomeProject
react-native run-android

#错误1：unable to load script from assets ‘index.android bundle’ ,make sure your bundle is packaged correctly or youu’re runing a packager server
mkdir android/app/src/main/assets

react-native bundle --platform android --dev false --entry-file index.js --bundle-output android/app/src/main/assets/index.android.bundle --assets-dest android/app/src/main/res/
#错误参考地址：
#https://blog.csdn.net/jasonzds/article/details/78747524 

# 部署到手机上运行正常
