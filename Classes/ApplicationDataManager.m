#import "ApplicationDataManager.h"
#import "CJSONDeserializer.h"

#define APPLICATION_DATA_FILE_NAME @"application_data.txt"

@implementation ApplicationDataManager

@synthesize userFullNameLookup, applicationData;

- (void)initialize{
	NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *applicationDataFilePath = [documentsDirectory stringByAppendingPathComponent:APPLICATION_DATA_FILE_NAME];
    
	CJSONDeserializer *jsonDeserializer = [[CJSONDeserializer alloc] init];
	NSError *error;
	BOOL applicationDataWasSet = NO;
	if ([fileManager fileExistsAtPath:applicationDataFilePath]) {
		NSData *applicationDataFileData = [NSData dataWithContentsOfFile:applicationDataFilePath options:NSDataReadingUncached error:&error];
		if(!applicationDataFileData){
			NSLog(@"Failed to read application data with message '%@'.", [error localizedDescription]);
		}
		else{
			NSDictionary *deserializedApplicationData = [jsonDeserializer deserializeAsDictionary:applicationDataFileData error:&error];
			if(!deserializedApplicationData){
				NSLog(@"Failed to deserialize application data with message '%@'.", [error localizedDescription]);
			}
			else {
				self.applicationData = deserializedApplicationData;
				applicationDataWasSet = YES;
			}
		}
	}
    
	if(!applicationDataWasSet){
		NSString *defaultApplicationDataPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:APPLICATION_DATA_FILE_NAME];
		NSData *defaultApplicationDataFileData = [NSData dataWithContentsOfFile:defaultApplicationDataPath options:NSDataReadingUncached error:&error];
		if(!defaultApplicationDataFileData){
			NSAssert1(0, @"Failed to read default application data with message '%@'.", [error localizedDescription]);
		}
		else{
			NSDictionary *deserializedApplicationData = [jsonDeserializer deserializeAsDictionary:defaultApplicationDataFileData error:&error];
			if(!deserializedApplicationData){
				NSAssert1(0, @"Failed to deserialize default application data with message '%@'.", [error localizedDescription]);
			}
			else {
				self.applicationData = deserializedApplicationData;
			}
		}
	}
	
	[jsonDeserializer release];
}

- (void)saveNewApplicationDataFile:(NSData *)fileData{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *applicationDataFilePath = [documentsDirectory stringByAppendingPathComponent:APPLICATION_DATA_FILE_NAME];
    [fileManager createFileAtPath:applicationDataFilePath contents:fileData attributes:nil];
    [self initialize];
}

- (int)currentVersion{
    int version = [[self.applicationData objectForKey:@"version"] intValue];
    return version;
}

+ (ApplicationDataManager *)shared
{
	static ApplicationDataManager *sharedSingleton;
	@synchronized(self)
	{
		if (!sharedSingleton)
		{
			sharedSingleton = [[ApplicationDataManager alloc] init];
			[sharedSingleton initialize];
			[sharedSingleton retain];
		}
		return sharedSingleton;
	}
}

- (void)dealloc{
    [applicationData release];
    [userFullNameLookup release];
    [super dealloc];
}

@end

