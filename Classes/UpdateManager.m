#import "UpdateManager.h"
#import "NSDictionary_JSONExtensions.h"
#import "ApplicationDataManager.h"
#import "HashTagsManager.h"
#import "StreamsManager.h"
#import "ApplicationSettings.h"
#import "RefreshManager.h"

#define AUTO_UPDATE_KEY @"AutoUpdate"
#define LAST_UPDATED_TIME_KEY @"LastUpdatedTime"
#define UPDATE_TIME_FORMAT @"d MMM yyyy h:mm a"
#define DATE_OF_LAST_UPDATE_CHECK_KEY @"DateOfLastUpdateCheck"

@implementation UpdateManager

@synthesize autoUpdate, delegate, lastUpdatedTime, asiHttpRequest;

- (id)init{
	if(self == [super init]){
        NSNumber *autoUpdateNumber = (NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:AUTO_UPDATE_KEY];
        if(autoUpdateNumber != nil){
            if([autoUpdateNumber intValue] == 1){
                autoUpdate = YES;
            }
            else{
                autoUpdate = NO;
            }
        }
        else{
            autoUpdate = YES;
        }
	}
	return self;
}

+ (UpdateManager *)shared
{
	static UpdateManager *sharedSingleton;
	@synchronized(self)
	{
		if (!sharedSingleton)
		{
			sharedSingleton = [[UpdateManager alloc] init];
		}
		return sharedSingleton;
	}
}

- (NSDate *)lastUpdatedTime{
    return (NSDate *)[[NSUserDefaults standardUserDefaults] objectForKey:LAST_UPDATED_TIME_KEY];
}

- (void)setLastUpdatedTime:(NSDate *)dateOfLastUpdate{
    [[NSUserDefaults standardUserDefaults] setObject:dateOfLastUpdate forKey:LAST_UPDATED_TIME_KEY];
}

- (NSString *)formattedLastUpdatedTime{
    NSDate *dateOfLastUpdate = [self lastUpdatedTime];
    if(!dateOfLastUpdate){
        return @"Never";
    }
    else{
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:UPDATE_TIME_FORMAT];
        NSString *formattedLastUpdateTime = [dateFormatter stringFromDate:dateOfLastUpdate];
        [dateFormatter release];
        return formattedLastUpdateTime;
    }
}

- (NSDate *)dateOfLastUpdateCheck{
    return (NSDate *)[[NSUserDefaults standardUserDefaults] objectForKey:DATE_OF_LAST_UPDATE_CHECK_KEY];
}

- (void)setDateOfLastUpdateCheck:(NSDate *)dateOfLastCheck{
    [[NSUserDefaults standardUserDefaults] setObject:dateOfLastCheck forKey:DATE_OF_LAST_UPDATE_CHECK_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)formattedDateOfLastUpdateCheck{
    NSDate *lastUpdateCheck = [self dateOfLastUpdateCheck];
    if(!lastUpdateCheck){
        return @"Never";
    }
    else{
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:UPDATE_TIME_FORMAT];
        NSString *formattedLastUpdateCheck = [dateFormatter stringFromDate:lastUpdateCheck];
        [dateFormatter release];
        return formattedLastUpdateCheck;
    }
}

- (void)setAutoUpdate:(BOOL)autoUpdateIsOn{
    autoUpdate = autoUpdateIsOn;
    int autoUpdateIntValue = 0;
    if(autoUpdateIsOn){
        autoUpdateIntValue = 1;
    }
    NSNumber *autoUpdateNumber = [NSNumber numberWithInt:autoUpdateIntValue];
    [[NSUserDefaults standardUserDefaults] setObject:autoUpdateNumber forKey:AUTO_UPDATE_KEY];
}

- (void)resetAllSettings{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:AUTO_UPDATE_KEY];
    autoUpdate = YES;
}

- (void)checkForUpdates{
    [self.asiHttpRequest cancel];
	self.asiHttpRequest = nil;
    
    NSURL *nsUrl = [NSURL URLWithString:APPLICATION_DATA_FILE_UPDATE_URL];
	self.asiHttpRequest = [ASIHTTPRequest requestWithURL:nsUrl];
	
	[self.asiHttpRequest setDelegate:self];
	[self.asiHttpRequest startAsynchronous];
}

- (void)checkForUpdatesSynchronously{
    [self.asiHttpRequest cancel];
	self.asiHttpRequest = nil;
    
    NSURL *nsUrl = [NSURL URLWithString:APPLICATION_DATA_FILE_UPDATE_URL];
	self.asiHttpRequest = [ASIHTTPRequest requestWithURL:nsUrl];
	
    [self.asiHttpRequest setDelegate:nil];
	[self.asiHttpRequest startSynchronous];
    
    NSError *error = [self.asiHttpRequest error];
    if(!error){
        [self processRequestThatsFinished:self.asiHttpRequest];
    }
    else{
        [self.delegate updateManagerDidFailToUpdateWithError:[error localizedDescription]];
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
	NSError *error = [request error];
	[self.delegate updateManagerDidFailToUpdateWithError:[error localizedDescription]];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    [self processRequestThatsFinished:request];
}

- (void)processRequestThatsFinished:(ASIHTTPRequest *)request{
    self.dateOfLastUpdateCheck = [NSDate date];
	NSString *responseString = [request responseString];
    if([request responseStatusCode] >= 400){
		[delegate updateManagerDidFailToUpdateWithError:@"Request failed. Please try again."];
		return;
	}
    
	NSError *error;
	NSDictionary *responseDictionary = (NSDictionary *)[NSDictionary dictionaryWithJSONString:responseString error:&error];
	if(!responseDictionary){
		[delegate updateManagerDidFailToUpdateWithError:[error localizedDescription]];
		return;
	}
    
    ApplicationDataManager *applicationDataManager = [ApplicationDataManager shared];
    id version_object = [responseDictionary objectForKey:@"version"];
    id streamcategories_object = [responseDictionary objectForKey:@"stream_categories"];
    id hashtagcategories_object = [responseDictionary objectForKey:@"hashtag_categories"];
    int version = [[responseDictionary objectForKey:@"version"] intValue];
    
    if(version_object != nil && streamcategories_object != nil && hashtagcategories_object != nil && version > [applicationDataManager currentVersion]){
        [applicationDataManager saveNewApplicationDataFile:[responseString dataUsingEncoding:NSUTF8StringEncoding]];
        self.lastUpdatedTime = [NSDate date];
        [[RefreshManager shared] setStreamsScreenNeedsRefreshing:YES];
        [[RefreshManager shared] setHashTagsScreenNeedsRefreshing:YES];
        [self.delegate updateManagerDidFinishUpdating];
    }
	else{
        [self.delegate updateManagerDidFinishWithNoNewUpdates];
    }
}

- (void)dealloc{
    asiHttpRequest.delegate = nil;
	[asiHttpRequest release];
    [lastUpdatedTime release];
    self.delegate = nil;
    [super dealloc];
}

@end
