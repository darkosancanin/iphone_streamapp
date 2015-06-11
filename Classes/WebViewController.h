#import <UIKit/UIKit.h>
#import "MessageView.h"

@interface WebViewController : UIViewController<UIWebViewDelegate> {
    NSURLRequest *urlRequest;
    UIWebView *webView;
    MessageView *messageView;
}

@property (nonatomic, retain) NSURLRequest *urlRequest;
@property (nonatomic, retain) UIWebView *webView;

- (id)initWithUrlRequest:(NSURLRequest *)request;
- (void)setUpRefreshButton;

@end
