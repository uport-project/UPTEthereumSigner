#import "NSString+Encoding.h"

@implementation NSString (Encoding)

- (Base64EncodedString *)urlToBase64Encoding
{
    return [[[self stringByReplacingOccurrencesOfString:@"+" withString:@"-"] stringByReplacingOccurrencesOfString:@"/" withString:@"_"] stringByReplacingOccurrencesOfString:@"=" withString:@""];
}
- (URLEncodedString *)base64ToURLEncoding
{
    NSMutableString *characterConverted = [[[self stringByReplacingOccurrencesOfString:@"-" withString:@"+"] stringByReplacingOccurrencesOfString:@"_" withString:@"/"] mutableCopy];
    if ( characterConverted.length % 4 != 0 ) {
        NSUInteger numEquals = 4 - characterConverted.length % 4;
        NSString *equalsPadding = [@"" stringByPaddingToLength:numEquals withString: @"=" startingAtIndex:0];
        [characterConverted appendString:equalsPadding];
    }

    return characterConverted;
}

@end
