// player_sprite_sheet_component.dart

import 'package:flame/flame.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/services.dart';
import 'package:sprite_07/utils/create_animation_by_limit.dart';

// Kelas untuk mengontrol player menggunakan sprite sheet dengan animasi berjalan dan diam
class PlayerSpriteSheetComponentAnimation extends SpriteAnimationComponent
    with KeyboardHandler {

  // Variabel untuk menyimpan ukuran layar
  late double screenWidth;
  late double screenHeight;

  // Variabel untuk posisi tengah layar
  late double centerX;
  late double centerY;

  // Ukuran sprite sheet
  final double spriteSheetWidth = 680;
  final double spriteSheetHeight = 472;

  // Animasi sprite untuk berjalan dan diam
  late SpriteAnimation walkAnimation;
  late SpriteAnimation idleAnimation;

  // Kecepatan gerak player (pixel per detik)
  final double speed = 300;

  // Status arah hadap player (true = kanan, false = kiri)
  bool facingRight = true;

  // Status tombol arah yang ditekan
  bool moveLeft = false;
  bool moveRight = false;

  // Fungsi ini dipanggil saat komponen di-load
  @override
  Future<void> onLoad() async {
    super.onLoad();

    // Ambil ukuran layar dari game
    final gameSize = findGame()!.size;
    screenWidth = gameSize.x;
    screenHeight = gameSize.y;

    // Hitung posisi tengah layar agar player muncul di tengah
    centerX = (screenWidth / 2) - (spriteSheetWidth / 2);
    centerY = (screenHeight / 2) - (spriteSheetHeight / 2);

    // Load gambar sprite sheet
    final spriteImage = await Flame.images.load('dinofull.png');

    // Buat objek SpriteSheet dari gambar
    final spriteSheet = SpriteSheet(
      image: spriteImage,
      srcSize: Vector2(spriteSheetWidth, spriteSheetHeight),
    );

    // Set posisi dan ukuran player
    position = Vector2(centerX, centerY);
    size = Vector2(spriteSheetWidth, spriteSheetHeight);

    // Buat animasi idle (diam) dari sprite sheet
    idleAnimation = spriteSheet.createAnimationByLimit(
      xInit: 1, yInit: 2, step: 10, sizex: 5, stepTime: .08,
    );

    // Buat animasi berjalan dari sprite sheet
    walkAnimation = spriteSheet.createAnimationByLimit(
      xInit: 6, yInit: 2, step: 10, sizex: 5, stepTime: .08,
    );

    // Set animasi awal menjadi idle
    animation = idleAnimation;
  }

  // Fungsi ini dipanggil setiap frame
  @override
  void update(double dt) {
    super.update(dt);

    // Gerakkan player ke kanan jika tombol kanan ditekan
    if (moveRight) {
      position.x += speed * dt;
      facingRight = true;
      animation = walkAnimation;
    } 
    // Gerakkan player ke kiri jika tombol kiri ditekan
    else if (moveLeft) {
      position.x -= speed * dt;
      facingRight = false;
      animation = walkAnimation;
    } 
    // Jika tidak ada tombol ditekan, gunakan animasi idle
    else {
      animation = idleAnimation;
    }

    // Batasi posisi player agar tetap di dalam layar
    if (position.x < 0) position.x = 0;
    if (position.x + size.x > screenWidth) position.x = screenWidth - size.x;

    // Flip sprite secara horizontal sesuai arah hadap
    if (facingRight) {
      scale.x = 1; // arah normal
      anchor = Anchor.topLeft;
    } else {
      scale.x = -1; // balik horizontal
      anchor = Anchor.topRight;
    }
  }

  // Fungsi untuk menangani input keyboard
  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    // Cek apakah tombol arah kiri atau kanan ditekan
    moveLeft = keysPressed.contains(LogicalKeyboardKey.arrowLeft);
    moveRight = keysPressed.contains(LogicalKeyboardKey.arrowRight);
    return true;
  }
}
