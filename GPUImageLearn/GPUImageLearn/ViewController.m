//
//  ViewController.m
//  GPUImageLearn
//
//  Created by Arokenda on 2022/1/11.
//

#import "ViewController.h"

@interface MyCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;


@end

@implementation MyCell

@end

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *exampleList;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

//    self.navigationController.navigationBarHidden = NO;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.exampleList = [NSMutableArray arrayWithObjects:@"CubeCamera", @"ImageFlitter",@"Text",nil];
    [self.tableView reloadData];
}

#pragma mark - DataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.exampleList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
//    MyCell *cell = [[MyCell alloc] init];
    NSString *title = [self.exampleList objectAtIndex:indexPath.row];
    cell.titleLabel.text = title;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *title = [self.exampleList objectAtIndex:indexPath.row];
    Class cls = NSClassFromString([title stringByAppendingString:@"ViewController"]);
    UIViewController *vc = [[cls alloc] init];
//    [self.view addSubview:vc.view];
//    [self addChildViewController:vc];
//    vc.view.frame = self.view.bounds;
    [self.navigationController pushViewController:vc animated:YES];
}


@end
