#import <Foundation/Foundation.h>

@interface TwitterToken : NSObject <NSCoding> {
@private
	NSString * _token;
	NSString * _secret;
    NSString * _userName;
}

@property (nonatomic,retain) NSString * token;
@property (nonatomic,retain) NSString * secret;
@property (nonatomic,retain) NSString * userName;

- (id) initWithToken: (NSString *) token secret: (NSString *) secret userName: (NSString *) userName;

@end