#import <Foundation/Foundation.h>

@interface Stream : NSObject {
	NSString *name;
	NSString *shortName;
	NSArray *users;
}

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *shortName;
@property (nonatomic, retain) NSArray *users;

- (id)initWithStreamName:(NSString *)streamName andShortName:(NSString *)streamShortName andUsers:(NSArray *)streamUsers;

@end
