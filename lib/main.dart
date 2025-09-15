// main.dart
import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:sprite_07/components/player_sprite_sheet_component_animation.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: GameWidget(game: MyGame()),
      ),
    ),
  );
}

// Pastikan mixin HasKeyboardHandlerComponents ditambahkan
class MyGame extends FlameGame with HasKeyboardHandlerComponents {
  late PlayerSpriteSheetComponentAnimation player;

  @override
  Future<void> onLoad() async {
    super.onLoad();

    player = PlayerSpriteSheetComponentAnimation();
    await add(player);
  }

  @override
  Color backgroundColor() => const Color(0xFF000000); // hitam
}
