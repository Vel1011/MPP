import 'package:flame/flame.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/services.dart';
import 'package:sprite_07/utils/create_animation_by_limit.dart';

class PlayerSpriteSheetComponentAnimation extends SpriteAnimationComponent
    with KeyboardHandler {
  // Ukuran layar
  late double screenWidth;
  late double screenHeight;
  late double centerX;
  late double centerY;

  // Ukuran sprite sheet
  final double spriteSheetWidth = 680;
  final double spriteSheetHeight = 472;

  // Animasi yang dipakai
  late SpriteAnimation walkAnimation;   // animasi jalan
  late SpriteAnimation idleAnimation;   // animasi diam
  late SpriteAnimation deadAnimation;   // animasi mati

  // Properti gerakan
  final double speed = 300;
  bool facingRight = true;

  // Kontrol gerakan
  bool moveLeft = false;
  bool moveRight = false;
  bool isDead = false; // status mati

  // simpan stepTime manual untuk animasi mati
  final double deathStepTime = 0.08;

  @override
  Future<void> onLoad() async {
    super.onLoad();

    // ambil ukuran layar dari game
    final gameSize = findGame()!.size;
    screenWidth = gameSize.x;
    screenHeight = gameSize.y;

    // hitung posisi awal (tengah layar)
    centerX = (screenWidth / 2) - (spriteSheetWidth / 2);
    centerY = (screenHeight / 2) - (spriteSheetHeight / 2);

    // load gambar sprite
    final spriteImage = await Flame.images.load('dinofull.png');

    final spriteSheet = SpriteSheet(
      image: spriteImage,
      srcSize: Vector2(spriteSheetWidth, spriteSheetHeight),
    );

    // atur posisi & ukuran karakter
    position = Vector2(centerX, centerY);
    size = Vector2(spriteSheetWidth, spriteSheetHeight);

    // buat animasi idle (diam)
    idleAnimation = spriteSheet.createAnimationByLimit(
      xInit: 1, yInit: 2, step: 10, sizex: 5, stepTime: .08,
    );

    // buat animasi jalan
    walkAnimation = spriteSheet.createAnimationByLimit(
      xInit: 6, yInit: 2, step: 10, sizex: 5, stepTime: .08,
    );

    // buat animasi mati (tidak loop)
    deadAnimation = spriteSheet.createAnimationByLimit(
      xInit: 0, yInit: 0, step: 8, sizex: 5, stepTime: deathStepTime,
      loop: false,
    );

    // animasi default = idle
    animation = idleAnimation;
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Jika sedang mati, biarkan animasi mati jalan
    if (isDead) {
      return;
    }

    // Gerakan kanan / kiri
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
    if (position.x + size.x > screenWidth) {
      position.x = screenWidth - size.x;
    }

    // Balik sprite jika menghadap kiri
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
    // cek input panah kiri/kanan
    moveLeft = keysPressed.contains(LogicalKeyboardKey.arrowLeft);
    moveRight = keysPressed.contains(LogicalKeyboardKey.arrowRight);

    // tekan SHIFT kiri -> animasi mati
    if (event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.shiftLeft) {
      isDead = true;
      animation = deadAnimation.clone(); // mainkan animasi mati
      return true;
    }

    // lepas SHIFT kiri -> balik idle lagi
    if (event is KeyUpEvent &&
        event.logicalKey == LogicalKeyboardKey.shiftLeft) {
      isDead = false;
      animation = idleAnimation; // langsung idle, tanpa reverse
      return true;
    }

    return true;
  }
}
