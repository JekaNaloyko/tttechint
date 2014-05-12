//
//  AuthorizationViewController.m
//  ParseStarterProject
//
//  Created by Ievgen Naloiko on 5/9/14.
//
//

#import "NLKAuthorizationViewController.h"
#import <Parus/Parus.h>
#import "NLKNewTimeEntryViewController.h"
#import "NLKTimeEntriesViewController.h"

@interface NLKAuthorizationViewController ()  <UITextFieldDelegate>

@property (strong) UITextField* usernameTextField;
@property (strong) UITextField* emailTextField;
@property (strong) UITextField* passwordTextField;

@end

@implementation NLKAuthorizationViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.view.backgroundColor = [UIColor lightGrayColor];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self buildView];
}

- (void) buildView
{
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    UITextField*(^makeTextField)(NSNumber*, NSNumber*) = ^(NSNumber *keyboardType, NSNumber* secure) {
        UITextField *tf = [UITextField new];
        {
            tf.delegate = self;
            tf.translatesAutoresizingMaskIntoConstraints  = NO;
            tf.keyboardType = keyboardType.integerValue;
            tf.backgroundColor = [UIColor whiteColor];
            tf.secureTextEntry = secure.boolValue;
        }
        return tf;
    };
    
    UILabel*(^makeLabel)(NSString*) = ^(NSString* title) {
        UILabel *label = [UILabel new];
        {
           label.translatesAutoresizingMaskIntoConstraints = NO;
            label.backgroundColor = [UIColor clearColor];
            label.text = title;
        }
        return label;
    };
    
    UIButton*(^makeButton)(NSString*) = ^(NSString* title) {
        UIButton *button = [UIButton new];
        {
            button.translatesAutoresizingMaskIntoConstraints = NO;
            button.backgroundColor = [UIColor grayColor];
            [button setTitle:title forState:UIControlStateNormal];
        }
        return button;
    };
    
    UILabel *emailLabel = makeLabel(@"Email:");
    {
        [self.view addSubview:emailLabel];
    }
    
    UITextField *emailTextField = makeTextField(@(UIKeyboardTypeEmailAddress), @NO);
    {
        self.emailTextField = emailTextField;
        [self.view addSubview:emailTextField];
    }
    
    UILabel *usernameLabel = makeLabel(@"Username:");
    {
        [self.view addSubview:usernameLabel];
    }
    
    UITextField *usernameTextField = makeTextField(@(UIKeyboardTypeDefault), @NO);
    {
        self.usernameTextField = usernameTextField;
        [self.view addSubview:usernameTextField];
    }
    
    UILabel *passwordLabel = makeLabel(@"Password:");
    {
        [self.view addSubview:passwordLabel];
    }
    
    UITextField *passwordTextField = makeTextField(@(UIKeyboardTypeDefault), @YES);
    {
        self.passwordTextField = passwordTextField;
        [self.view addSubview:passwordTextField];
    }
    
    UIButton *createAccount = makeButton(@"Create account");
    {
        [createAccount addTarget:self action:@selector(createAccount) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:createAccount];
    }
    
    UIButton *logIn = makeButton(@"Log in");
    {
        [logIn addTarget:self action:@selector(logIn) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:logIn];
    }
    
    [self.view addConstraints:PVGroup(@[
                                        
                                        PVVFL(@"H:|-20-[emailTextField]-20-|"),
                                        PVVFL(@"H:|-20-[usernameTextField]-20-|"),
                                        PVVFL(@"H:|-20-[passwordTextField]-20-|"),
                                        PVVFL(@"H:|-20-[emailLabel]"),
                                        PVVFL(@"H:|-20-[usernameLabel]"),
                                        PVVFL(@"H:|-20-[passwordLabel]"),
                                        PVVFL(@"H:|-20-[createAccount]-6-[logIn]-20-|"),
                                        PVVFL(@"V:[emailLabel(15)]-3-[emailTextField(40)]-20-[usernameLabel(15)]-3-[usernameTextField(40)]-20-[passwordLabel(15)]-3-[passwordTextField(40)]-20-[createAccount(40)]"),
                                        PVHeightOf(logIn).equalTo.heightOf(createAccount),
                                        PVTopOf(logIn).equalTo.topOf(createAccount),
                                        PVWidthOf(logIn).equalTo.widthOf(createAccount),
                                        PVCenterYOf(passwordTextField).equalTo.centerYOf(passwordTextField.superview),
                                        ]).withViews(NSDictionaryOfVariableBindings(emailTextField, usernameTextField, passwordTextField, emailLabel, usernameLabel, passwordLabel, createAccount, logIn)).asArray];
    
}


- (void)viewWillAppear:(BOOL)animated
{
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)createAccount
{
    [self.parseInteractor createAccountWithEmail:self.emailTextField.text password:self.passwordTextField.text userName:self.usernameTextField.text];
}

- (void)logIn
{
    [self.parseInteractor logInWithUsername:self.usernameTextField.text password:self.passwordTextField.text];
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}

#pragma mark NLKAPIDelegate

- (void) userHasAuthenticated
{
    UITabBarController *tabBarController = [UITabBarController new];
    {
        tabBarController.viewControllers = @[[NLKTimeEntriesViewController new], [NLKNewTimeEntryViewController new]];

        [self presentViewController:tabBarController animated:NO completion:^{
            
        }];
    }
    
}

@end
//[self.parseInteractor createAccountWithEmail:@"i@gmail.com" password:@"8characterS" userName:@"Jeka"]
//[self.parseInteractor createAccountWithEmail:@"i1@gmail.com" password:@"8characterS" userName:@"Jeka1"]
