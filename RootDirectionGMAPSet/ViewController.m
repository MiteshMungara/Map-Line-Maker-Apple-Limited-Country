//
//  ViewController.m
//  RootDirectionGMAPSet
//
//  Created by iSquare2 on 7/15/16.
//  Copyright © 2016 MitsSoft. All rights reserved.
//

#import "ViewController.h"
#import <MapKit/MapKit.h>


@interface ViewController () <MKMapViewDelegate>
@property (nonatomic, weak) IBOutlet MKMapView *mapView;

@end

@implementation ViewController



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
    
    CLLocationCoordinate2D centerCoordinate = CLLocationCoordinate2DMake(37.083590, -95.687656);
    MKCoordinateSpan span = MKCoordinateSpanMake(0.906448, 0.878906);
    self.mapView.region = MKCoordinateRegionMake(centerCoordinate, span);
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    
    // ---- Start searching ----
//    
//    [SVProgressHUD showWithStatus:@"Searching..."
//                         maskType:SVProgressHUDMaskTypeGradient];
    
    // San Francisco Caltrain Station
    CLLocationCoordinate2D fromCoordinate = CLLocationCoordinate2DMake(37.115902,
                                                                       -95.862064);\
    // Mountain View Caltrain Station
    CLLocationCoordinate2D toCoordinate   = CLLocationCoordinate2DMake(37.022214,
                                                                       -95.517368);
    
    MKPlacemark *fromPlacemark = [[MKPlacemark alloc] initWithCoordinate:fromCoordinate
                                                       addressDictionary:nil];
    
    MKPlacemark *toPlacemark   = [[MKPlacemark alloc] initWithCoordinate:toCoordinate
                                                       addressDictionary:nil];
    
    MKMapItem *fromItem = [[MKMapItem alloc] initWithPlacemark:fromPlacemark];
    
    MKMapItem *toItem   = [[MKMapItem alloc] initWithPlacemark:toPlacemark];
    
    

    
    [self findDirectionsFrom:fromItem
                          to:toItem];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// =============================================================================
#pragma mark - Private

- (void)findDirectionsFrom:(MKMapItem *)source
                        to:(MKMapItem *)destination
{
    MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
    request.source = source;
    request.destination = destination;
    request.requestsAlternateRoutes = YES;
    
    MKDirections *directions = [[MKDirections alloc] initWithRequest:request];
    
    [directions calculateDirectionsWithCompletionHandler:
     ^(MKDirectionsResponse *response, NSError *error) {
         
        // [SVProgressHUD dismiss];
         
         if (error) {
             
             NSLog(@"error:%@", error);
         }
         else {
             
             MKRoute *route = response.routes[0];
             
             [self.mapView addOverlay:route.polyline];
         }
     }];
}


// =============================================================================
#pragma mark - MKMapViewDelegate

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView
            rendererForOverlay:(id<MKOverlay>)overlay
{
    MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
    renderer.lineWidth = 5.0;
    renderer.strokeColor = [UIColor purpleColor];
    return renderer;
}

@end
