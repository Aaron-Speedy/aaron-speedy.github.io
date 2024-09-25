#include <stdio.h>
#include <stdlib.h>

#define PPM_IMPL
#include "ppm.h"

void fastcircle(unsigned char *img, int w, int h, int r) {
  int x = r, y = 0;
  int d = 0, dy = 0, dx = 2 * r;

  const int c = (w * h + w)/2;

  while (y <= x) {
    img[c + x + y*w] = 255;
    img[c + y + x*w] = 255;
    img[c - y + x*w] = 255;
    img[c - x + y*w] = 255;
    img[c - x - y*w] = 255;
    img[c - y - x*w] = 255;
    img[c + y - x*w] = 255;
    img[c + x - y*w] = 255;

    dy += 2;
    d += dy;
    if (d > x) {
      x -= 1;
      dx -= 2;
      d -= dx;
    }
    y += 1;
  }
}

int main() {
  int w = 500, h = 500;
  unsigned char *img = malloc(w * h * sizeof(unsigned char));
  fastcircle(img, w, h, 100);
  write_p2("fastcircle.ppm", img, w, h);
}
