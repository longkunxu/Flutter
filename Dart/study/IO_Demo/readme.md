本文转自：https://blog.csdn.net/s1120080286/article/details/83239453

#  #1.针对目录，主要有以下几个操作：

创建指定目录
重命名目录
删除目录
创建临时文件夹
获取父目录
列出目录的内容
    import 'dart:io';
    import 'dart:async';
     
    void main() {
      handleDir();
    }
     
    handleDir() async {
      //可以用Platform.pathSeparator代替路径中的分隔符"/"
      //效果和"dir/subdir"一样
      //如果有子文件夹，需要设置recursive: true
      var directory = await new Directory("dir${Platform.pathSeparator}one").create(recursive: true);
     
      assert(await directory.exists() == true);
      //输出绝对路径
      print("Path: ${directory.absolute.path}");
     
      //重命名文件夹
      directory = await directory.rename("dir/subdir");
      print("Path: ${directory.absolute.path}\n");
     
      //创建临时文件夹
      //参数是文件夹的前缀，后面会自动添加随机字符串
      //参数可以是空参数
      var tempDir = await Directory.systemTemp.createTemp('temp_dir');
      assert(await tempDir.exists() == true);
      print("Temp Path: ${tempDir.path}");
     
      //返回上一级文件夹
      var parentDir = tempDir.parent;
      print("Parent Path: ${parentDir.path}");
     
      //列出所有文件，不包括链接和子文件夹
      Stream<FileSystemEntity> entityList = parentDir .list(recursive: false, followLinks: false);
      await for(FileSystemEntity entity in entityList) {
     
    //文件、目录和链接都继承自FileSystemEntity
    //FileSystemEntity.type静态函数返回值为FileSystemEntityType
    //FileSystemEntityType有三个常量：
    //Directory、FILE、LINK、NOT_FOUND
    //FileSystemEntity.isFile .isLink .isDerectory可用于判断类型
    print(entity.path);
      }
     
      //删除目录
      await tempDir.delete();
      assert(await tempDir.exists() == false);
    }

运行结果：

Path: E:\DartProject\Note16\dir\one
Path: E:\DartProject\Note16\dir/subdir
 
Temp Path: C:\Users\King\AppData\Local\Temp\temp_dir7aa9c6f5-106b-11e6-a55f-ac220b7553ea
Parent Path: C:\Users\King\AppData\Local\Temp
C:\Users\King\AppData\Local\Temp\%@DH19{R%DFDKB85J)D~UR6.png
C:\Users\King\AppData\Local\Temp\0RCT3Y_IOUNT2`)27FJ9U`R.xml
C:\Users\King\AppData\Local\Temp\360newstmp.dat
……


#  #2.针对文件，主要有以下几个操作：

创建文件
将string写入文件
读取文件到String
以行为单位读取文件到List<String>
将bytes写入文件
读取文件到bytes
数据流Stream写入文件
数据流Stream读取文件
删除文件
    import 'dart:io';
    import 'dart:convert';
    import 'dart:async';
     
    void main() {
      //文件操作演示
      handleFile();
    }
     
    handleFile() async {
      //提示：pub中有ini库可以方便的对ini文件进行解析
      File file = new File("default.ini");
     
      //如果文件存在，删除
      if(!await file.exists()) {
    //创建文件
    file = await file.create();
      }
     
      print(file);
     
      //直接调用File的writeAs函数时
      //默认文件打开方式为WRITE:如果文件存在，会将原来的内容覆盖
      //如果不存在，则创建文件
     
      //写入String，默认将字符串以UTF8进行编码
      file = await file.writeAsString("[General]\nCode=UTF8");
      //readAsString读取文件，并返回字符串
      //默认返回的String编码为UTF8
      //相关的编解码器在dart:convert包中
      //包括以下编解码器：ASCII、LANTI1、BASE64、UTF8、SYSTEM_ENCODING
      //SYSTEM_ENCODING可以自动检测并返回当前系统编码
      print("\nRead Strings:\n${await file.readAsString()}");
     
      //以行为单位读取文件到List<String>，默认为UTF8编码
      print("\nRead Lines:");
      List<String> lines = await file.readAsLines();
      lines.forEach(
      (String line) => print(line)
      );
     
      //如果是以字节方式写入文件
      //建议设置好编码，避免汉字、特殊符号等字符出现乱码、或无法读取
      //将字符串编码为Utf8格式，然后写入字节
  	  //file = await file.writeAsBytes(UTF8.encode("编码=UTF8"));  //编译报错
  	  file = await file.writeAsBytes(Utf8Encoder().convert("编码=UTF8"));
      //读取字节，并用Utf8解码
      print("\nRead Bytes:");
	  //print(UTF8.decode(await file.readAsBytes()));
	  print('utf8.decode  ${utf8.decode(await file.readAsBytes())}');
	  print(Utf8Decoder().convert(await file.readAsBytes()));
     
    //  //删除文件
    //  await file.delete();
    }
运行结果：

File: 'default.ini'
 
Read Strings:
[General]
Code=UTF8
 
Read Lines:
[General]
Code=UTF8
 
Read Bytes:
编码=UTF8
读写文件的话，常用的函数就是readAs和writeAs
但是如果我们要对某个字符进行处理，或读写某个区域等操作时
就需要用到open函数

open类型的函数有3个：
open({FileMode mode: FileMode.READ}) → Future<RandomAccessFile>
openRead([int start, int end]) → Stream<List<int>>
openWrite({FileMode mode: FileMode.WRITE, Encoding encoding: UTF8}) → IOSink

open和openSync一样，不过一个是异步、一个同步
可以返回RandomAccessFile类
openRead用于打开数据流
openWrite用于打开数据缓冲池
详细的内容可以查看API


#  #3.针对链接，主要有以下几个操作：

创建链接
获取链接文件的路径
获取链接指向的目标
重命名链接
删除链接
    import 'dart:io';
    import 'dart:async';
     
    void main() {
      handleLink();
    }
     
    handleLink() async {
      //创建文件夹
      var dir = await new Directory("linkDir").create();
      //创建链接
      //Link的参数为该链接的Path，create的参数为链接的目标文件夹
      var link = await new Link("shortcut").create("linkDir");
     
      //输出链接文件的路径
      print(link.path);
      //输出链接目标的路径
      print(await link.target());
     
      //重命名链接
      link = await link.rename("link");
      print(link.path);
     
      //删除链接
      //link.delete();
    }
运行结果：

shortcut
E:\DartProject\Note16\linkDir
link
需要说明的是，Dart中的Link
链接的是文件夹，而不能链接文件
并且，Dart中的链接和通常意义的快捷方式不同：

首先，这里的链接只能指向文件夹
快捷方式可以指向文件夹或文件
链接不能剪切移动
快捷方式可以剪切移动
在命令行中，链接可以作为普通文件夹进行 cd、dir(ls)等操作
快捷方式在命令行中可以看到，只是一个lnk文件，运行然后打开目标资源
打开链接的时候，资源管理器的地址栏显示的是链接名
而快捷方式打开的时候，资源管理器显示的是目标文件夹名

 

#  #4.针对数据流，主要有以下几个操作：

原本是准备在文件操作一节中提一下就完事的
但是测试了解下来，有点复杂，于是单独列一节

Stream是dart:async库中的类，并非dart:io
从它的位置可以看出，Stream是一个异步数据事件的提供者
它提供了一种接收事件序列（数据或错误信息）的方式

因此，我们可以通过listen来监听并开始产生事件
当我们开始监听Stream的时候，会接收到一个StreamSubscription对象
通过该对象可以控制Stream进行暂停、取消等操作

数据流Stream有两种类型：

Single-subscription单一订阅数据流
broadcast广播数据流
Stream默认关闭广播数据流，可以通过isBroadcast测试
如果要打开，需在Stream子类中重写 isBroadcast返回true
或调用asBroadcastStream

Single-subscription对象不能监听2次
即使第1次的数据流已经被取消

同时，为了保证系统资源被释放
在使用数据流的时候
必须等待读取完数据，或取消

关于数据流Stream，虽然抽象，但也不是不能理解
问题在于很多人不知道【Dart中】数据流的好处，何时该用
我所理解的是一般用于处理较大的连续数据，如文件IO操作

下面的实例是用数据流来复制文件，只能算是抛砖引玉吧！
File.copy常用来复制文件到某路径，但是看不到复制的过程、进度
这里用Stream来实现复制文件的功能，并添加进度显示的功能

    import 'dart:io';
    import 'dart:convert';
    import 'dart:async';
     
    void main() {
      //复制文件演示
      copyFileByStream();
    }
     
    copyFileByStream() async {
      //电子书文件大小：10.9 MB (11,431,697 字节)
      File file = new File(r"E:\全职高手.txt");
      assert(await file.exists() == true);
      print("源文件：${file.path}");
     
      //以只读方式打开源文件数据流
      Stream<List<int>> inputStream = file.openRead();
      //数据流监听事件，这里onData是null
      //会在后面通过StreamSubscription来修改监听函数
      StreamSubscription subscription = inputStream.listen(null);
     
      File target = new File(r"E:\全职高手.back.txt");
      print("目标文件：${target.path}");
      //以WRITE方式打开文件，创建缓存IOSink
      IOSink sink = target.openWrite();
     
      //常用两种复制文件的方法，就速度来说，File.copy最高效
    //  //经测试，用时21毫秒
    //  await file.copy(target.path);
    //  //输入流连接缓存，用时79毫秒，比想象中高很多
    //  //也许是数据流存IOSink缓存中之后，再转存到文件中的原因吧！
    //  await sink.addStream(inputStream);
     
      //手动处理输入流
      //接收数据流的时候，涉及一些简单的计算
      //如：当前进度、当前时间、构造字符串
      //但是最后测试下来，仅用时68毫秒，有些不可思议
     
      //文件大小
      int fileLength = await file.length();
      //已读取文件大小
      int count = 0;
      //模拟进度条
      String progress = "*";
     
      //当输入流传来数据时，设置当前时间、进度条，输出信息等
      subscription.onData((List<int> list) {
    count = count + list.length;
    //进度百分比
    double num = (count*100)/fileLength;
    DateTime time = new DateTime.now();
     
    //输出样式：[1:19:197]**********[20.06%]
    //进度每传输2%，多一个"*"
    //复制结束进度为100%，共50个"*"
    print("[${time.hour}:${time.second}:${time.millisecond}]${progress*(num ~/ 2)}[${num.toStringAsFixed(2)}%]");
     
    //将数据添加到缓存池
    sink.add(list);
      });
     
      //数据流传输结束时，触发onDone事件
      subscription.onDone(() {
    print("复制文件结束！");
    //关闭缓存释放系统资源
    sink.close();
      });
    }
运行结果：

源文件：E:\全职高手.txt
目标文件：E:\全职高手.back.txt
[1:19:177][0.57%]
[1:19:185][1.15%]
[1:19:186][1.72%]
[1:19:187]*[2.29%]
[1:19:187]*[2.87%]
……
[1:19:245]*************************************************[99.75%]
[1:19:245]**************************************************[100.00%]
复制文件结束！
 

 

本文图片资料来源出自“Dart语言中文社区”，允许转载，转载时请务必以超链接形式标明文章原始出处 。 