#import "NSData+Keccak.h"

#import "keccak.h"

@implementation NSData (Keccak)

- (NSData *)keccak256
{
    char *outputBytes = malloc(32);
    sha3_256((uint8_t *)outputBytes, 32, (uint8_t *)[self bytes], (size_t)[self length]);
    return [NSData dataWithBytesNoCopy:outputBytes length:32 freeWhenDone:YES];
}

@end
