#import <Foundation/Foundation.h>

@interface ApplicationDataManager : NSObject
{
    NSDictionary *applicationData;
    NSDictionary *userFullNameLookup;
}

@property (nonatomic, retain) NSDictionary *applicationData;
@property (nonatomic, retain) NSDictionary *userFullNameLookup;

- (NSDictionary *)applicationData;
- (NSDictionary *)userFullNameLookup;
- (void)setUserFullNameLookup:(NSDictionary *)newUserFullNameLookup;
- (void)initialize;
- (int)currentVersion;
- (void)saveNewApplicationDataFile:(NSData *)fileData;

+ (ApplicationDataManager *)shared;
@end
