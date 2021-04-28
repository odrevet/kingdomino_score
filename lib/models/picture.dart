import 'package:image/image.dart';

List<int> averageRGB(Image image, int fromX, int fromY, int toX, int toY) {
  List<int> rgb = [0, 0, 0];

  int nbPixel = 0;

  for (int x = fromX; x < toX; x++) {
    for (int y = fromY; y < toY; y++) {
      int? pixel32 = image.getPixelSafe(x, y);
      rgb[0] += (pixel32 >> 0) & 0xFF;
      rgb[1] += (pixel32 >> 8) & 0xFF;
      rgb[2] += (pixel32 >> 16) & 0xFF;
      nbPixel++;
    }
  }

  rgb[0] = (rgb[0] ~/ nbPixel);
  rgb[1] = (rgb[1] ~/ nbPixel);
  rgb[2] = (rgb[2] ~/ nbPixel);

  return rgb;
}

bool compareRGB(List<int> a, List<int> b, {tolerance = 25}) {
  return (a[0] >= b[0] - tolerance && a[0] <= b[0] + tolerance) &&
      (a[1] >= b[1] - tolerance && a[1] <= b[1] + tolerance) &&
      (a[2] >= b[2] - tolerance && a[2] <= b[2] + tolerance);
}
