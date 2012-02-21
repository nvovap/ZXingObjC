#import "EAN8Reader.h"

@implementation EAN8Reader

- (id) init {
  if (self = [super init]) {
    decodeMiddleCounters[0] = 0;
    decodeMiddleCounters[1] = 0;
    decodeMiddleCounters[2] = 0;
    decodeMiddleCounters[3] = 0;
  }
  return self;
}

- (int) decodeMiddle:(BitArray *)row startRange:(NSArray *)startRange result:(NSMutableString *)result {
  int counters[4] = {0, 0, 0, 0};
  int end = [row size];
  int rowOffset = [[startRange objectAtIndex:1] intValue];

  for (int x = 0; x < 4 && rowOffset < end; x++) {
    int bestMatch = [UPCEANReader decodeDigit:row counters:counters rowOffset:rowOffset patterns:(int**)L_PATTERNS];
    [result appendFormat:@"%C", (unichar)('0' + bestMatch)];
    for (int i = 0; i < sizeof(counters) / sizeof(int); i++) {
      rowOffset += counters[i];
    }
  }

  NSArray * middleRange = [UPCEANReader findGuardPattern:row rowOffset:rowOffset whiteFirst:YES pattern:(int*)MIDDLE_PATTERN];
  rowOffset = [[middleRange objectAtIndex:1] intValue];

  for (int x = 0; x < 4 && rowOffset < end; x++) {
    int bestMatch = [UPCEANReader decodeDigit:row counters:counters rowOffset:rowOffset patterns:(int**)L_PATTERNS];
    [result appendFormat:@"%C", (unichar)('0' + bestMatch)];
    for (int i = 0; i < sizeof(counters) / sizeof(int); i++) {
      rowOffset += counters[i];
    }
  }

  return rowOffset;
}

- (BarcodeFormat) barcodeFormat {
  return kBarcodeFormatEan8;
}

@end
