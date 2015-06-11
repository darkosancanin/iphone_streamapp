#import "WebViewController.h"

@implementation WebViewController

@synthesize urlRequest, webView;

- (id)initWithUrlRequest:(NSURLRequest *)request{
    if(self ==[super init]){
        self.urlRequest = request;
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, 367)];
    [self.view addSubview:webView];
    [webView setScalesPageToFit:YES];
    webView.delegate = self;
    [webView loadRequest:self.urlRequest];
    messageView = [[MessageView alloc] init];
    [self.view addSubview:messageView];
    [messageView showLoadingMessage];
    [self setUpRefreshButton];
}

- (void)setUpRefreshButton{
	UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshButtonClicked)];
    self.navigationItem.rightBarButtonItem = refreshButton;
    [refreshButton release];
}

- (void)refreshButtonClicked{
    [webView loadRequest:self.urlRequest];
    [messageView showLoadingMessage];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [messageView hide];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [messageView hide];
    UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
	[alert show];
}

- (void)dealloc
{
    webView.delegate = nil;
    [webView release];
    [urlRequest release];
    [messageView release];
    [super dealloc];
}

@end
