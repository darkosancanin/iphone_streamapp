#import <Foundation/Foundation.h>
#import "UpdateManagerDelegate.h"
#import "ASIHTTPRequest.h"

@interface UpdateManager : NSObject<ASIHTTPRequestDelegate> {
    BOOL autoUpdate;
    NSDate *dateOfLastUpdateCheck;
    NSDate *lastUpdatedTime;
    id<UpdateManagerDelegate> delegate;
    ASIHTTPRequest *asiHttpRequest;
}

@property (nonatomic) BOOL autoUpdate;
@property (nonatomic, retain) NSDate *lastUpdatedTime;
@property (nonatomic, retain) NSDate *dateOfLastUpdateCheck;
@property (nonatomic, assign) id<UpdateManagerDelegate> delegate;
@property (nonatomic, retain) ASIHTTPRequest *asiHttpRequest;

+ (UpdateManager *)shared;

- (void)resetAllSettings;
- (void)checkForUpdates;
- (void)checkForUpdatesSynchronously;
- (NSString *)formattedDateOfLastUpdateCheck;
- (NSString *)formattedLastUpdatedTime;
- (void)processRequestThatsFinished:(ASIHTTPRequest *)request;

@end
