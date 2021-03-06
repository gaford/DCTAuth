//
//  AuthTestViewController.m
//  DCTAuth
//
//  Created by Daniel Tull on 25.08.2012.
//  Copyright (c) 2012 Daniel Tull. All rights reserved.
//

@import DCTAuth;
#import "AuthTestViewController.h"

@interface AuthTestViewController ()
@property (weak, nonatomic) IBOutlet UITextField *consumerKeyTextField;
@property (weak, nonatomic) IBOutlet UITextField *consumerSecretTextField;
@property (weak, nonatomic) IBOutlet UITextField *requestTokenURLTextField;
@property (weak, nonatomic) IBOutlet UITextField *accessTokenURLTextField;
@property (weak, nonatomic) IBOutlet UITextField *authorizeURLTextField;
@property (weak, nonatomic) IBOutlet UITextView *resultTextView;
@end

@implementation AuthTestViewController

- (instancetype)initWithNibName:(NSString *)nibName bundle:(NSBundle *)nibBundle {
	
	self = [super initWithNibName:nibName bundle:nibBundle];
	if (!self) return nil;
	
	self.title = @"DCTAuth";
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Go" style:UIBarButtonItemStyleDone target:self action:@selector(go:)];
	
	UIBarButtonItem *load = [[UIBarButtonItem alloc] initWithTitle:@"Load" style:UIBarButtonItemStylePlain target:self action:@selector(go:)];
	UIBarButtonItem *save = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(go:)];
	self.navigationItem.leftBarButtonItems = @[load, save];

	self.edgesForExtendedLayout = UIRectEdgeNone;

	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	self.consumerKeyTextField.text = @"key";
	self.consumerSecretTextField.text = @"secret";
	
	self.requestTokenURLTextField.text = @"http://echo.lab.madgex.com/request-token.ashx";
	self.accessTokenURLTextField.text = @"http://echo.lab.madgex.com/access-token.ashx";
}

- (IBAction)go:(id)sender {
	
	UITextField *consumerKeyTextField = self.consumerKeyTextField;
	UITextField *consumerSecretTextField = self.consumerSecretTextField;
	UITextField *requestTokenURLTextField = self.requestTokenURLTextField;
	UITextField *accessTokenURLTextField = self.accessTokenURLTextField;
	UITextField *authorizeURLTextField = self.authorizeURLTextField;

	[self.view endEditing:YES];
	self.resultTextView.text = nil;
	
	NSString *consumerKey = consumerKeyTextField.text;
	NSString *consumerSecret = consumerSecretTextField.text;
	
	NSURL *requestTokenURL = [NSURL URLWithString:requestTokenURLTextField.text];
	NSURL *accessTokenURL = [NSURL URLWithString:accessTokenURLTextField.text];
	
	NSURL *authorizeURL = nil;
	NSString *authorizeURLString = authorizeURLTextField.text;
	if ([authorizeURLString length] > 0) authorizeURL = [NSURL URLWithString:authorizeURLString];
	
	DCTOAuth1Account *account = [[DCTOAuth1Account alloc] initWithType:@"echo.lab.madgex"
													   requestTokenURL:requestTokenURL
														  authorizeURL:authorizeURL
														accessTokenURL:accessTokenURL
														   consumerKey:consumerKey
														consumerSecret:consumerSecret];
	account.shouldSendCallbackURL = NO;
	[account authenticateWithHandler:^(NSArray *responses, NSError *error) {

		[[DCTAuthAccountStore defaultAccountStore] saveAccount:account];

		NSMutableArray *textArray = [NSMutableArray new];
		[responses enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
			[textArray addObject:[NSString stringWithFormat:@"%@\n", obj]];
		}];
		self.resultTextView.text = [textArray componentsJoinedByString:@"\n"];
		NSLog(@"%@:%@ %@", self, NSStringFromSelector(_cmd), account);
	}];
}


@end
