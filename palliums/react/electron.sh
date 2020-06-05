# 参考资源
# http://electronjs.org/

# Clone the Quick Start repository  克隆项目到本地
git clone https://github.com/electron/electron-quick-start

# Go into the repository 进入项目根目录
cd electron-quick-start

# Install the dependencies and run 安装依赖并运行
npm install && npm start

# 安装打包工具 
npm install --save-dev electron-packager 

# 安装windows平台工具
sudo apt-get install wine
# 打包当前平台
electron-packager .

# 打包支持的所有平台
electron-packager . --all


