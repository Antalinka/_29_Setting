//
//  GRTableViewController.m
//  _29_Settings
//
//  Created by Exo-terminal on 6/11/14.
//  Copyright (c) 2014 Evgenia. All rights reserved.
//

#import "GRTableViewController.h"

@interface GRTableViewController ()

@end

static const int localNumberMaxLenght = 7;
static const int areaCodeMaxLenght = 3;
static const int coutryCodeMaxLenght = 3;

static NSString* kSettingsLogin           = @"login";
static NSString* kSettingsPassword        = @"password";
static NSString* kSettingsPhone           = @"phone";
static NSString* kSettingsEmail           = @"email";
static NSString* kSettingsEnablePassword  = @"enablePassword";
static NSString* kSettingsFirstName       = @"firstName";
static NSString* kSettingsLastName        = @"lastName";
static NSString* kSettingsAge             = @"age";

@implementation GRTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loadSettings];
 
}


#pragma mark - Save and Load

-(void) saveSetting{
 
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    
    UITextField* login = [self.collectionField objectAtIndex:0];
    UITextField* password = [self.collectionField objectAtIndex:1];
    UITextField* phone = [self.collectionField objectAtIndex:2];
    UITextField* email = [self.collectionField objectAtIndex:3];
    UITextField* firstName = [self.collectionField objectAtIndex:4];
    UITextField* lastName = [self.collectionField objectAtIndex:5];
   
    
    [userDefaults setObject:login.text forKey:kSettingsLogin];
    [userDefaults setObject:password.text forKey:kSettingsPassword];
    [userDefaults setObject:phone.text forKey:kSettingsPhone];
    [userDefaults setObject:email.text forKey:kSettingsEmail];
    [userDefaults setObject:firstName.text forKey:kSettingsFirstName];
    [userDefaults setObject:lastName.text forKey:kSettingsLastName];
    
    [userDefaults setBool:self.pasSwitch.isOn forKey:kSettingsEnablePassword];
    [userDefaults setInteger:self.ageSlider.value forKey:kSettingsAge];
    
    
    [userDefaults synchronize];
 
}
-(void) loadSettings{
    
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    
    UITextField* login = [self.collectionField objectAtIndex:0];
    UITextField* password = [self.collectionField objectAtIndex:1];
    UITextField* phone = [self.collectionField objectAtIndex:2];
    UITextField* email = [self.collectionField objectAtIndex:3];
    UITextField* firstName = [self.collectionField objectAtIndex:4];
    UITextField* lastName = [self.collectionField objectAtIndex:5];
    
    login.text = [userDefaults objectForKey:kSettingsLogin];
    password.text = [userDefaults objectForKey:kSettingsPassword];
    phone.text = [userDefaults objectForKey:kSettingsPhone];
    email.text = [userDefaults objectForKey:kSettingsEmail];
    firstName.text = [userDefaults objectForKey:kSettingsFirstName];
    lastName.text = [userDefaults objectForKey:kSettingsLastName];
    
    self.pasSwitch.on = [userDefaults boolForKey:kSettingsEnablePassword];
    self.ageSlider.value = [userDefaults integerForKey:kSettingsAge];
    
    
    int age =self.ageSlider.value;
    self.ageLabel.text = [NSString stringWithFormat:@"%d",age];
    [self enablePassword:[self.collectionField objectAtIndex:1]];
    
}
#pragma mark - Edit -

- (BOOL) editPhone:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSCharacterSet* validationSet = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    NSArray* componets = [string componentsSeparatedByCharactersInSet:validationSet];
    
    if ([componets count] > 1) {
        return NO;
    }
    
    NSString* newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    NSArray* validComponents = [newString componentsSeparatedByCharactersInSet:validationSet];
    newString = [validComponents componentsJoinedByString:@""];
    
    if ([newString length] > localNumberMaxLenght + areaCodeMaxLenght + coutryCodeMaxLenght) {
        return NO;
    }
    
    NSMutableString* resultString = [NSMutableString string];
    
    NSInteger localNumberLenght = MIN([newString length], localNumberMaxLenght);
    
    if (localNumberLenght > 0) {
        NSString* number = [newString substringFromIndex:(int)[newString length] - localNumberLenght];
        [resultString appendString:number];
        
        if ([resultString length] > 3) {
            [resultString insertString:@"-" atIndex:3];
        }
    }
    
    if ([newString length] > localNumberMaxLenght) {
        
        NSInteger areaCodeLenght = MIN((int)[newString length] - localNumberMaxLenght, areaCodeMaxLenght);
        NSRange areaRange = NSMakeRange((int)[newString length] - localNumberMaxLenght - areaCodeLenght, areaCodeLenght);
        NSString* area = [newString substringWithRange:areaRange];
        
        area = [NSString stringWithFormat:@"(%@) ", area];
        [resultString insertString:area atIndex:0];
    }
    if ([newString length] > localNumberMaxLenght + coutryCodeMaxLenght) {
        
        NSInteger coutryCodeLenght = MIN((int)[newString length] - localNumberMaxLenght - coutryCodeMaxLenght, coutryCodeMaxLenght);
        NSRange countryCodeRange = NSMakeRange(0,coutryCodeLenght);
        NSString* countryCode = [newString substringWithRange:countryCodeRange];
        
        countryCode = [NSString stringWithFormat:@"+%@ ", countryCode];
        [resultString insertString:countryCode atIndex:0];
    }
    
    textField.text = resultString;
    
    return YES;
}

-(BOOL)editMail:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSString* newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSArray* errorSymbol = [NSArray arrayWithObjects:@"~",@" ",@"/",@"(",@"[",@"^",@"<",@">",@")",@"(",@")",@",",@";",@"]",@"+",@"=",@"\\",
                            @"|",@"'",@"{",@"}",@"%",@"*",@"#",@"$",@"!",@"&",@"*", nil];
    
    for (NSString* errorString in errorSymbol) {
        
        if ([string isEqualToString:errorString]) {
            return NO;
        }
    }
    
    NSCharacterSet* newSet = [NSCharacterSet characterSetWithCharactersInString:@"@"];
    NSArray* separatedArray = [newString componentsSeparatedByCharactersInSet:newSet];
    
    if ([separatedArray count] > 2) {
        return NO;
    }
    
    return [newString length] < 30;
}

- (void)enablePassword:(UITextField *)sender {
    
    if (self.pasSwitch.isOn) {
        sender.secureTextEntry = NO;
        
    }else{
        sender.secureTextEntry = YES;
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    
    for (int i = 0; i < ([self.collectionField count]-1) ; i++) {
        
        if (!([textField isEqual:[self.collectionField objectAtIndex:i]]))  {
            
            [textField resignFirstResponder];
            
        }else{
            
            [[self.collectionField objectAtIndex:i+1] becomeFirstResponder];
            
        }
    }
        
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if ([textField isEqual:[self.collectionField objectAtIndex:2]]) {
        
        return  [self editPhone:textField shouldChangeCharactersInRange:range replacementString:string];
        
    }else if([textField isEqual:[self.collectionField objectAtIndex:3]]){
        
        return [self editMail:textField shouldChangeCharactersInRange:range replacementString:string];
        
    }else{
        return YES;
        
    }
}

#pragma mark - Actions

- (IBAction)actionSwitch:(UISwitch *)sender {
    
    [self enablePassword:[self.collectionField objectAtIndex:1]];
}

- (IBAction)actionAgeSlider:(UISlider *)sender {
    
    int age = sender.value;
    self.ageLabel.text = [NSString stringWithFormat:@"%d",age];
}

- (IBAction)actionChange:(id)sender {
   [self saveSetting];
}


@end
