#import <Foundation/Foundation.h>

@protocol TwitterAccountManagerDelegate <NSObject>

@required
- (void)twitterAccountManagerDidSuccessfullySignIn;
- (void)twitterAccountManagerDidSuccessfullySignOut;
- (void)twitterAccountManagerDidFailWithError:(NSString *)errorMessage;

@end