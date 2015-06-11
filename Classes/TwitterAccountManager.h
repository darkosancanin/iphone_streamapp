#import <Foundation/Foundation.h>
#import "TwitterAccountManagerDelegate.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "TwitterToken.h"
#import "User.h"

@interface TwitterAccountManager : NSObject<ASIHTTPRequestDelegate> {
    id<TwitterAccountManagerDelegate> delegate;
    ASIFormDataRequest *asiHttpRequest;
    TwitterToken *twitterToken;
}

@property (nonatomic, assign) id<TwitterAccountManagerDelegate> delegate;
@property (nonatomic, retain) ASIFormDataRequest *asiHttpRequest;
@property (nonatomic, retain) TwitterToken *twitterToken;

+ (TwitterAccountManager *)shared;

- (void)signInWithUserName:(NSString *)theUserName andPassword:(NSString *)thePassword;
- (void)signOut;
- (BOOL) isAuthenticated;
- (NSString*) _formDecodeString: (NSString*) string;
- (User *)authenticatedUser;
- (void)resetAllSettings;

@end
