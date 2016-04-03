// T E L L M E E V E R Y T H I N G
import java.util.Map;
int[][] _t = {{0, 2}, {1, 7}};
int[][] _e = {{0, 2}, {0, 6}, {3, 5}, {6, 8}};
int[][] _l = {{0, 6}, {6, 8}};
int[][] _m = {{0, 6}, {0, 2}, {1, 7}, {2, 8}};
int[][] _v = {{0, 7}, {7, 2}};
int[][] _r = {{0, 6}, {0, 2}, {2, 5}, {3, 5}, {3, 8}};
int[][] _y = {{0, 4}, {4, 2}, {4, 7}};
int[][] _h = {{0, 6}, {2, 8}, {3, 5}};
int[][] _i = {{0, 2}, {1, 7}, {6, 8}};
int[][] _n = {{0, 6}, {0, 8}, {2, 8}};
int[][] _g = {{0, 2}, {0, 6}, {6, 8}, {5, 8}, {4, 5}};
int[][] _ = {};
float temp;
class Letter {
  int[][] segments;
  int segment_length, mode;
  float x, y, scale, shift, last_shift_x, last_shift_y, shift_x, shift_y, original_x, original_y, move_x, move_y;
  float[] start, end;
  Letter(String letter, float _x, float _y, float _scale, float _shift) {
    segments = set_segments(letter);
    segment_length = segments.length;
    scale = _scale;
    shift = _shift;
    original_x = _x;
    original_y = _y;
    x = _x;
    y = _y;
    move_x = _x;
    move_y = _y;
    last_shift_x = 0;
    last_shift_y = 0;
    start = new float[2];
    end = new float[2];
  }
  void draw_letter(float amount, int _mode, float _move_x, float _move_y, int shift_mode) {
    mode = _mode;
    if (shift_mode == 1) {
      move_x = _move_x;
      move_y = _move_y;
    } else if (shift_mode == 0) {
      move_x = original_x + _move_x;
      move_y = original_y + _move_y;
    }
    x = lerp(x, move_x, 0.05);
    y = lerp(y, move_y, 0.05);
    for (int i = 0; i < segment_length; i++) {
      get_node(segments[i][0], start);
      get_node(segments[i][1], end);
      draw_segment(amount);
    }
  }
  void draw_segment(float amount) {
    temp = amount*shift;
    start[0] += temp;
    end[0] += temp;
    switch(mode) {
    case 0: 
      shift_x = 20;
      shift_y = -20;
      break;
    case 1: 
      shift_x = 0;
      shift_y = -26.5;
      break;
    case 2: 
      shift_x = 23;
      shift_y = -36;
      break;
    case 3: 
      shift_x = 0;
      shift_y = -40;
      break;
    case 4: 
      shift_x = 25.6;
      shift_y = -105.5;
      break;
    }
    last_shift_y = lerp(last_shift_y, shift_y, 0.05);
    last_shift_x = lerp(last_shift_x, shift_x, 0.05);
    start[0] -= last_shift_x;
    start[1] -= last_shift_x;
    end[0] += last_shift_y;
    end[1] += last_shift_y;

    line(start[0], start[1], end[0], end[1]);
  }
  int[][] set_segments(String letter) {
    switch(letter) {
    case "t":
      return _t;
    case "e":
      return _e;
    case "l":
      return _l;
    case "m":
      return _m;
    case "v":
      return _v;
    case "r":
      return _r;
    case "y":
      return _y;
    case "h":
      return _h;
    case "i":
      return _i;
    case "n":
      return _n;
    case "g":
      return _g;
    case " ":
      return _;
    }
    return _g;
  }
  float[] get_node(int node_number, float[] point) {
    switch(node_number) {
    case 0: 
      point[0] = x;
      point[1] = y;
      return point;
    case 1: 
      point[0] = x + scale/2;
      point[1] = y;
      return point;
    case 2: 
      point[0] = x + scale;
      point[1] = y;
      return point;
    case 3: 
      point[0] = x;
      point[1] = y + scale;
      return point;
    case 4: 
      point[0] = x + scale/2;
      point[1] = y + scale;
      return point;
    case 5: 
      point[0] = x + scale;
      point[1] = y + scale;
      return point;
    case 6: 
      point[0] = x;
      point[1] = y + scale*2;
      return point;
    case 7: 
      point[0] = x + scale/2;
      point[1] =  y + scale*2;
      return point;
    case 8: 
      point[0] = x + scale;
      point[1] = y + scale*2;
      return point;
    }
    return point;
  }
}

class Word {
  Letter[] letters1 = new Letter[10];
  Letter[] letters2 = new Letter[10];
  Letter[] letters3 = new Letter[10];
  String[] split_word;
  int shift_mode = -1;
  float new_x, new_y, x, y;
  Word(String word, float _x, float _y, float _scale) {
    x = _x;
    y = _y;
    split_word = word.split("");
    for (int i = 0; i < split_word.length; i++) {
      letters1[i] = new Letter(split_word[i], _x + (i*scale)*1.5, _y, _scale, 0.5);
      letters2[i] = new Letter(split_word[i], _x + (i*scale)*1.5, _y, _scale, 0.05 );
      letters3[i] = new Letter(split_word[i], _x + (i*scale)*1.5, _y, _scale, -0.5);
    }
  }
  void update(float amount, int mode, int shifting, float _x, float _y) {
    if (shifting == 0) {
      shift_mode = 0; // go to original shape    
      new_x = (x - _x > 0 ? x - _x :  _x - x);
      new_y = (y - _y > 0 ? y - _y :  _y - y);
      x = _x;
      y = _y;
    } 
    for (int i = 0; i < split_word.length; i++) {
      if (shifting == 1) {
        new_x = random(0, width);
        new_y = random(0, height);
        shift_mode = 1; // go to random points
      } else if (shifting != 0) {
        shift_mode = -1; // maintain position
      }
      stroke(255, 0, 0);
      letters1[i].draw_letter(amount, mode, new_x, new_y, shift_mode);
      stroke(0, 255, 0);
      letters2[i].draw_letter(amount, mode, new_x, new_y, shift_mode);
      stroke(0, 0, 255);
      letters3[i].draw_letter(amount, mode, new_x, new_y, shift_mode);
    }
  }
}
