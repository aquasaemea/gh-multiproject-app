package com.tomtom;

import java.text.CharacterIterator;
import java.text.StringCharacterIterator;

// https://stackoverflow.com/questions/3758606/how-can-i-convert-byte-size-into-a-human-readable-format-in-java/3758880#3758880

public class StackOverflowSnippets {

  private StackOverflowSnippets() {
    throw new IllegalStateException("Utility class");
  }

  public static String humanReadableByteCountSI(long bytes) {
    if (-1000 < bytes && bytes < 1000) {
      return bytes + " B";
    }
    CharacterIterator ci = new StringCharacterIterator("kMGTPE");
    while (bytes <= -999_950 || bytes >= 999_950) {
      bytes /= 1000;
      ci.next();
    }
    return String.format("%.1f %cB", bytes / 1000.0, ci.current());
  }
}
