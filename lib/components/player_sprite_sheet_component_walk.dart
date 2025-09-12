// player_sprite_sheet_component.dart
import 'package:flame/flame.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/services.dart';
import 'package:sprite_07/utils/create_animation_by_limit.dart';

class PlayerSpriteSheetComponentAnimation extends SpriteAnimationComponent
    with KeyboardHandler {
  late double screenWidth;
  late double screenHeight;
  late double centerX;
  late double centerY;

  final double spriteSheetWidth = 680;
  final double spriteSheetHeight = 472;

  late SpriteAnimation walkAnimation;
  late SpriteAnimation idleAnimation;

  final double speed = 300;
  bool facingRight = true;

  bool moveLeft = false;
  bool moveRight = false;

  @override
  Future<void> onLoad() async {
    super.onLoad();

    final gameSize = findGame()!.size; // ambil ukuran layar dari game
    screenWidth = gameSize.x;
    screenHeight = gameSize.y;

    centerX = (screenWidth / 2) - (spriteSheetWidth / 2);
    centerY = (screenHeight / 2) - (spriteSheetHeight / 2);

    final spriteImage = await Flame.images.load('dinofull.png');

    final spriteSheet = SpriteSheet(
      image: spriteImage,
      srcSize: Vector2(spriteSheetWidth, spriteSheetHeight),
    );

    position = Vector2(centerX, centerY);
    size = Vector2(spriteSheetWidth, spriteSheetHeight);

    idleAnimation = spriteSheet.createAnimationByLimit(
      xInit: 1, yInit: 2, step: 10, sizex: 5, stepTime: .08,
    );

    walkAnimation = spriteSheet.createAnimationByLimit(
      xInit: 6, yInit: 2, step: 10, sizex: 5, stepTime: .08,
    );

    animation = idleAnimation;
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (moveRight) {
      position.x += speed * dt;
      facingRight = true;
      animation = walkAnimation;
    } else if (moveLeft) {
      position.x -= speed * dt;
      facingRight = false;
      animation = walkAnimation;
    } else {
      animation = idleAnimation;
    }

    // Batasi agar tetap di layar
    if (position.x < 0) position.x = 0;
    if (position.x + size.x > screenWidth) position.x = screenWidth - size.x;

    // Flip sprite horizontal sesuai arah
    if (facingRight) {
      scale.x = 1;
      anchor = Anchor.topLeft;
    } else {
      scale.x = -1;
      anchor = Anchor.topRight;
    }
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    moveLeft = keysPressed.contains(LogicalKeyboardKey.arrowLeft);
    moveRight = keysPressed.contains(LogicalKeyboardKey.arrowRight);
    return true;
  }
}
