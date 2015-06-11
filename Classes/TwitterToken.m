#import "TwitterToken.h"

@implementation TwitterToken

@synthesize
token = _token,
secret = _secret,
userName = _userName;

#pragma mark -

- (id) initWithToken: (NSString *) token secret: (NSString *) secret userName: (NSString *) userName
{
	if ((self = [super init]) != nil) {
		_token = [token retain];
		_secret = [secret retain];
        _userName = [userName retain];
	}
	return self;
}

- (void) dealloc
{
	[_token release];
	[_secret release];
    [_userName release];
	[super dealloc];
}

- (id) initWithCoder: (NSCoder*) coder
{
	if ((self = [super init]) != nil) {
		_token = [[coder decodeObjectForKey: @"token"] retain];
		_secret = [[coder decodeObjectForKey: @"secret"] retain];
        _userName = [[coder decodeObjectForKey: @"userName"] retain];
	}
	return self;
}

- (void) encodeWithCoder: (NSCoder*) coder
{
    [coder encodeObject: _token forKey: @"token"];
    [coder encodeObject: _secret forKey: @"secret"];
    [coder encodeObject: _userName forKey: @"userName"];
}

- (NSString*) description
{
	return [NSString stringWithFormat: @"<TwitterToken token=%@ secret=%@ userName=%@>", _token, _secret, _userName];
}

@end
