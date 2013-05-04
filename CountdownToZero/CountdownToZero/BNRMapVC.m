//
//  BNRMapVC.m
//  CountdownToZero
//
//  Created by Christian Keur on 5/3/13.
//  Copyright (c) 2013 Christian Keur. All rights reserved.
//

#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

#import "BNRMapVC.h"

@interface BNRMapVC () <UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation BNRMapVC

#pragma mark - Initializers

- (id)init
{
    self = [super initWithNibName:nil bundle:nil];
    
    if(self)
    {
        UIBarButtonItem *closeBtn = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStyleBordered target:self action:@selector(close:)];
        [self.navigationItem setLeftBarButtonItem:closeBtn];
        
        UIBarButtonItem *mapsBtn = [[UIBarButtonItem alloc] initWithTitle:@"Open in Maps" style:UIBarButtonItemStyleBordered target:self action:@selector(openInMaps:)];
        [self.navigationItem setRightBarButtonItem:mapsBtn];
        
        [self.navigationItem setTitle:@"Map"];
    }
    
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    CLLocationCoordinate2D coord = [[BNRCarterCenter theCenter] coordinate];
    [_mapView setCenterCoordinate:coord animated:NO];
    MKCoordinateRegion region = MKCoordinateRegionMake(coord, MKCoordinateSpanMake(0.005, 0.005));
    [_mapView setRegion:region animated:NO];
    [_mapView addAnnotation:[BNRCarterCenter theCenter]];
}

#pragma mark - Actions

- (void)close:(id)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)openInMaps:(id)sender
{
    if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"comgooglemaps://"]])
        [self showMapPicker];
    else
        [self launchAppleMaps];
}

- (void)showMapPicker
{
    UIActionSheet *mapPicker = [[UIActionSheet alloc] initWithTitle:@"Open in" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Apple Maps", @"Google Maps", nil];
    [mapPicker showInView:self.view];
}

- (void)launchAppleMaps
{
    CLLocationCoordinate2D coord = [[BNRCarterCenter theCenter] coordinate];
    
    MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:coord addressDictionary:nil];
    MKMapItem *item = [[MKMapItem alloc] initWithPlacemark:placemark];
    [item setName:@"The Carter Center"];
    [item setPhoneNumber:@"4044205100"];
    [item setUrl:[NSURL URLWithString:@"http://www.cartercenter.org"]];
    
    [MKMapItem openMapsWithItems:@[item] launchOptions:nil];
}

- (void)launchGoogleMaps
{
    CLLocationCoordinate2D coord = [[BNRCarterCenter theCenter] coordinate];
    
    NSString *urlStr = [NSString stringWithFormat:@"comgooglemaps://?q=Carter%%20Center&center=%f,%f", coord.latitude, coord.longitude];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
}

#pragma mark - Action sheet delegate methods

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == [actionSheet cancelButtonIndex])
        return;
    
    if(buttonIndex == 0)
        [self launchAppleMaps];
    else if(buttonIndex == 1)
        [self launchGoogleMaps];
}

#pragma mark - Map kit delegate methods

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
