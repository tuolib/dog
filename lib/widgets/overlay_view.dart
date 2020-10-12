
import 'package:flutter/material.dart';
import 'dart:io';
import '../index.dart';

class TestOverLay {
  static OverlayEntry _holder;

  static Widget view;

  double dragStartPosition;

  double dragEndPosition;

  static void remove() {
    if (_holder != null) {
      _holder.remove();
      _holder = null;
    }
  }

  static void show({@required BuildContext context, @required Widget view}) {
    TestOverLay.view = view;

    remove();
    //创建一个OverlayEntry对象
    OverlayEntry overlayEntry = new OverlayEntry(builder: (context) {
      return new Positioned(
          // top: MediaQuery.of(context).size.height * 0.1,
          top: 0,
          right: 0,
          child: _buildDraggable(context));
    });

    //往Overlay中插入插入OverlayEntry
    Overlay.of(context).insert(overlayEntry);

    _holder = overlayEntry;
  }

  static _buildDraggable(context) {
    return new Draggable(
      child: view,
      feedback: view,
      onDragStarted: () {
        print('onDragStarted:');
      },
      onDragEnd: (detail) {
        print('onDragEnd:${detail.offset}');
        if (detail.offset.dy.abs() > 100 || detail.offset.dx.abs() > 100) {
          callInfoSocket.updateFullScreen(false);
          callInfoSocket.updateSystemFull(false);
        }
        createDragTarget(offset: detail.offset, context: context);
      },
      childWhenDragging: Container(),
      // maxSimultaneousDrags: 0,
      ignoringFeedbackSemantics: false,
    );
  }

  static void refresh() {
    _holder.markNeedsBuild();
  }

  static void createDragTarget({Offset offset, BuildContext context}) {
    if (_holder != null) {
      _holder.remove();
    }

    _holder = new OverlayEntry(builder: (context) {
      bool isLeft = true;
      if (offset.dx + 100 > MediaQuery.of(context).size.width / 2) {
        isLeft = false;
      }

      double maxY = MediaQuery.of(context).size.height - 100;
      return Consumer<CallInfoModel>(
          builder: (BuildContext context,
              CallInfoModel callInfoModel, Widget child) {
            return  Positioned(
              // top: offset.dy < 50 ? 50 : offset.dy < maxY ? offset.dy : maxY,
                top: callInfoSocket.fullScreen
                    ? 0
                    : offset.dy < 50 ? 0 : offset.dy < maxY ? offset.dy : maxY,
                left: isLeft ? 0 : null,
                right: isLeft ? null : 0,
                // left: null,
                // right: null,
                child: DragTarget(
                  onWillAccept: (data) {
                    print('onWillAccept: $data');
                    return false;
                  },
                  onAccept: (data) {
                    print('onAccept: $data');
                    // refresh();
                  },
                  onLeave: (data) {
                    print('onLeave');
                  },
                  builder: (BuildContext context, List incoming, List rejected) {
                    return _buildDraggable(context);
                  },
                ));
          });
    });
    Overlay.of(context).insert(_holder);
  }
}
