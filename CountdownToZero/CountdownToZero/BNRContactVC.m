//
//  BNRContactVC.m
//  CountdownToZero
//
//  Created by Christian Keur on 5/2/13.
//  Copyright (c) 2013 Christian Keur. All rights reserved.
//

#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

#import "BNRContactVC.h"

@interface BNRContactVC ()

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

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

//    33.766784
//    -84.354877
    
    CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(33.766784, -84.354877);
    [_mapView setCenterCoordinate:coord animated:NO];

    MKCoordinateRegion region = MKCoordinateRegionMake(coord, MKCoordinateSpanMake(0.005, 0.005));
    [_mapView setRegion:region animated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
