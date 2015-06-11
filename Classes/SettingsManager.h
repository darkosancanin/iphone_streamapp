#import <Foundation/Foundation.h>

@interface SettingsManager : NSObject {
    int tweetListFontSize;
    int tweetFontSize;
    BOOL showRetweets;
}

@property (nonatomic) int tweetListFontSize;
@property (nonatomic) int tweetFontSize;
@property (nonatomic) BOOL showRetweets;

+ (SettingsManager *)shared;

- (void)resetAllSettings;

@end
