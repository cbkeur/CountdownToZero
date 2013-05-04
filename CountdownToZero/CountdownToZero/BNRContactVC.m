//
//  BNRContactVC.m
//  CountdownToZero
//
//  Created by Christian Keur on 5/2/13.
//  Copyright (c) 2013 Christian Keur. All rights reserved.
//

#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MessageUI/MessageUI.h>
#import <QuartzCore/QuartzCore.h>

#import "BNRContactVC.h"

// Controllers
#import "BNRMapVC.h"

@interface BNRContactVC () <MKMapViewDelegate, MFMailComposeViewControllerDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIButton *phone1Btn;
@property (weak, nonatomic) IBOutlet UIButton *phone2Btn;
@property (weak, nonatomic) IBOutlet UIButton *emailBtn;

@property (strong, nonatomic) NSString *numberToCall;

@end

@implementation BNRContactVC

#pragma mark - Initializers

- (id)init
{
    self = [super initWithNibName:nil bundle:nil];
    
    if(self)
    {
        [self.navigationItem setTitle:@"Contact"];
    }
    
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    return [self init];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    CLLocationCoordinate2D coord = [[BNRCarterCenter theCenter] coordinate];
    [_mapView setCenterCoordinate:coord animated:NO];
    MKCoordinateRegion region = MKCoordinateRegionMake(coord, MKCoordinateSpanMake(0.005, 0.005));
    [_mapView setRegion:region animated:NO];
    [_mapView addAnnotation:[BNRCarterCenter theCenter]];
    [_mapView.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    [_mapView.layer setBorderWidth:8];
    
    if(![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tel://"]])
    {
        [_phone1Btn setEnabled:NO];
        [_phone2Btn setEnabled:NO];
    }
    
    if(![MFMailComposeViewController canSendMail])
        [_emailBtn setEnabled:NO];
}

#pragma mark - Actions

- (IBAction)viewMap:(id)sender
{
    BNRMapVC *mapVC = [[BNRMapVC alloc] init];
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:mapVC];
    [self.tabBarController presentViewController:nc animated:YES completion:nil];
}

- (IBAction)call:(id)sender
{
    NSString *message;
    if([sender isEqual:_phone1Btn])
    {
        message = @"Call (404)420-5100?";
        _numberToCall = @"tel://4044205100";
    }
    else
    {
        message = @"Call (800)550-3560?";
        _numberToCall = @"tel://8005503560";
    }
    
    [[[UIAlertView alloc] initWithTitle:nil message:message delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil] show];
}

- (IBAction)email:(id)sender
{
    MFMailComposeViewController *mailComposer = [[MFMailComposeViewController alloc] init];
    [mailComposer setMailComposeDelegate:self];
    [mailComposer setToRecipients:@[@"carterweb@emory.edu"]];
    
    [self presentViewController:mailComposer animated:YES completion:nil];
}

#pragma mark - Alert view

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == [alertView cancelButtonIndex])
    {
        _numberToCall = nil;
        return;
    }
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_numberToCall]];
}

#pragma mark - Mail composer delegate methods

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Map delegate methods

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKAnnotationView *annotView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"AnnotView"];
    if(!annotView)
    {
        annotView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"AnnotView"];
        [annotView setImage:[UIImage imageNamed:@"annot_view"]];
    }
    
    return annotView;
}

@end
