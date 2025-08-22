import 'package:flutter/material.dart';
import 'package:sprite_07/components/player_sprite_sheet_component.dart';
import 'package:flame/game.dart';

void main() async{
  runApp(GameWidget(game: MyGame()));
}

class MyGame extends FlameGame {
  @override
  Future<void> onLoad() async {
    super.onLoad();
    add(PlayerSpriteSheetComponentAnimation());
  }

  @override
  Color backgroundColor() => Colors.black;
}