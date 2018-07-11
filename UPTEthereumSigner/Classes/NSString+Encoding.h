@import Foundation;

typedef NSString URLEncodedString;
typedef NSString Base64EncodedString;

@interface NSString (Encoding)

- (Base64EncodedString *)urlToBase64Encoding;
- (URLEncodedString *)base64ToURLEncoding;

@end
