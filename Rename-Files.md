### 一次性替换文件名
从网上下载了一些资料，文件名都带“【xxx.com】-更多xxxxx”类似的前缀，文件名太长影响查找，一个一个手动改太麻烦了，写个脚本替换【**当前目录**】下所有的文件名。

使用方式：
```shell
node renameFiles.js 被替换字符串 替换字符串
```
实现代码：
```js
const fs = require('fs');
const path = require('path');

// 获取当前目录
const currentDirectory = process.cwd();

// 获取要替换的字符和替换字符作为命令行参数
const charToReplace = process.argv[2];
const replacementChar = process.argv[3] || '';

if (!charToReplace) {
  console.log('缺少被替换字符');
  process.exit(1);
}

// 遍历目录下的文件
function traverseDirectory(directory) {
  const files = fs.readdirSync(directory);

  files.forEach((file) => {
    const filePath = path.join(directory, file);
    const stat = fs.statSync(filePath);

    if (stat.isDirectory()) {
      // 如果是文件夹，则递归遍历
      traverseDirectory(filePath);
    } else {
      // 如果是文件，则处理文件名中包含字符为replacementChar的文件
      if (file.includes(charToReplace)) {
        const newFileName = file.replace(new RegExp(charToReplace, 'g'), replacementChar); // 替换指定字符
        const newFilePath = path.join(directory, newFileName);

        // 重命名文件
        fs.renameSync(filePath, newFilePath);
        console.log(`File renamed: ${file} -> ${newFileName}`);
      }
    }
  });
}

// 调用遍历函数
traverseDirectory(currentDirectory);
```