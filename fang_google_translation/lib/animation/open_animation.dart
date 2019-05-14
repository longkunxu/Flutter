import 'package:flutter/material.dart';
import '../pages/index_page.dart'; // 导入包

// 动态 widget 类
class OpenAnimation extends StatefulWidget {
  _OpenAnimationState createState() => _OpenAnimationState();
}

class _OpenAnimationState extends State<OpenAnimation>
    with SingleTickerProviderStateMixin {
  AnimationController _controller; // 控制器
  Animation _animation; // 动画

  // 初始化
  @override
  void initState() {
    super.initState();
    // 控制器的初始化
    _controller = AnimationController(
      duration: Duration(
        seconds: 1,
      ),
      vsync: this,
    );
    // 动画的初始化
    _animation = Tween(begin: 0, end: 1).animate(_controller);

    // 监听状态
    _animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => IndexPage()),
            (route) => route == null);
      }
    });

    // 动画播放
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    // 淡入浅出
    return FadeTransition(
      opacity: _controller,
      child: Image.asset(
        'images/Open_animation.png',
        fit: BoxFit.cover,
      ),
    );
  }
} 