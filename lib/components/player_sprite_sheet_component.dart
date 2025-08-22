import 'package:flame/sprite.dart';
import 'package:flame/flame.dart';
import 'package:flame/components.dart';
import 'package:sprite_07/utils/create_animation_by_limit.dart';

class PlayerSpriteSheetComponentAnimation extends SpriteAnimationComponent with HasGameReference{
  late double screenWidth;
  late double screenHeight;

  late double centerX;
  late double centerY;

  final double spriteSheetWidth = 680;
  final double spriteSheetHeight = 472;

  late SpriteAnimation dinoAnimation;



@override
void onLoad() async {
  super.onLoad();

  screenWidth = game.size.x;
  screenHeight = game.size.y;

  centerX = (screenWidth / 2) - (spriteSheetWidth / 2);
  centerY = (screenHeight / 2) - (spriteSheetHeight / 2);

  var spriteImage = await Flame.images.load('dyno_walk.png');
  
  final spriteSheet = SpriteSheet(
    image: spriteImage,
    srcSize: Vector2(spriteSheetWidth, spriteSheetHeight));

  position = Vector2(centerX, centerY); // Position of the sprite sheet in the image
  size = Vector2(spriteSheetWidth, spriteSheetHeight); // Size of the sprite sheet

  dinoAnimation = spriteSheet.createAnimationByLimit(xInit: 6, yInit: 2, step: 10, sizex: 5, stepTime: .08);

  animation = dinoAnimation;
  }
}