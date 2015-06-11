#import <Foundation/Foundation.h>

@interface StreamSection : NSObject {
	NSString *name;
	NSArray *streams;
}

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSArray *streams;

- (id)initWithName:()sectionName andStreams:(NSArray *)theStreams;
- (BOOL)hasVisibleName;

@end
