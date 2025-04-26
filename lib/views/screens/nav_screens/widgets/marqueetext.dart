import 'package:flutter/material.dart';
import 'dart:async';

class MarqueeText extends StatefulWidget {
  final String text;
  final TextStyle textStyle;
  final double speed;
  final double pauseAfterRound;

  const MarqueeText({
    super.key,
    required this.text,
    required this.textStyle,
    this.speed = 50.0,
    this.pauseAfterRound = 1.5,
  });

  @override
  State<MarqueeText> createState() => _MarqueeTextState();
}

class _MarqueeTextState extends State<MarqueeText> {
  late ScrollController _scrollController;
  late Timer _timer;
  double _offset = 0;
  final GlobalKey _textKey = GlobalKey();
  double _textWidth = 0;
  double _containerWidth = 0;
  bool _hasCalculatedWidth = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    
    // We need to wait for the layout to be rendered before we can get the width
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _calculateWidths();
      _startMarquee();
    });
  }

  void _calculateWidths() {
    final RenderBox? textBox = _textKey.currentContext?.findRenderObject() as RenderBox?;
    final RenderBox? containerBox = context.findRenderObject() as RenderBox?;
    
    if (textBox != null && containerBox != null) {
      _textWidth = textBox.size.width;
      _containerWidth = containerBox.size.width;
      
      setState(() {
        _hasCalculatedWidth = true;
      });
    }
  }

  void _startMarquee() {
    _timer = Timer.periodic(const Duration(milliseconds: 16), (timer) {
      if (!_hasCalculatedWidth) {
        _calculateWidths();
        return;
      }
      
      if (_textWidth <= _containerWidth) {
        // If text fits in container, no need to scroll
        return;
      }
      
      _offset += widget.speed / 60; // Adjust speed based on 60fps
      
      if (_offset > _textWidth) {
        // Reset position with a pause
        _offset = -_containerWidth;
        timer.cancel();
        Future.delayed(Duration(seconds: widget.pauseAfterRound.toInt()), () {
          if (mounted) {
            _startMarquee();
          }
        });
      } else {
        if (mounted) {
          setState(() {});
        }
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: OverflowBox(
        alignment: Alignment.centerLeft,
        maxWidth: double.infinity,
        child: Transform.translate(
          offset: Offset(-_offset, 0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Add some space before the text starts
              const SizedBox(width: 20),
              Text(
                widget.text,
                key: _textKey,
                style: widget.textStyle,
              ),
              // Add space between repeated text
              const SizedBox(width: 50),
              // Repeat the text to create a continuous effect
              Text(
                widget.text,
                style: widget.textStyle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}