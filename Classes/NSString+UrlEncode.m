#import "NSString+UrlEncode.h"

@implementation NSString (UrlEncode)

- (NSString *) urlEncoded {
    return (NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)self, NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8 );
}

@end