//
//  ViewController.m
//  RFTestDemo
//
//  Created by linitial on 2018/3/28.
//  Copyright © 2018年 redfinge. All rights reserved.
//

#import "ViewController.h"
#import "NextViewController.h"
#import "TestViewController.h"
#import "HomeViewModel.h"
#import "HomeCell.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) HomeViewModel *viewModel;

@end

@implementation ViewController

#pragma mark - LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self _setup];
    [self _getData];
    [self _listenerTest];
}

#pragma mark - Private
- (void)_setup {
    self.navigationItem.title = self.viewModel.title.value;
    [self.view addSubview:self.tableView];
}

- (void)_getData {
    @weakify(self);
    [self.viewModel getDataSuccess:^(NSArray *data) {
        @strongify(self);
        [self.tableView reloadData];
    } failed:^(NSError *error) {
        NSLog(@"request failed");
    }];
}

- (void)_listenerTest {
    @weakify(self)
    [self.viewModel bindListener:^(id object) {
        @strongify(self);
        NSLog(@"data has changed");
        [self.tableView reloadData];
    }];

    [self.viewModel.title bindListener:^(id object) {
        @strongify(self);
        self.navigationItem.title = object;
    }];
}

- (void)_appendDataTest {
    [self.viewModel getDataSuccess:^(NSArray *data) {
        
    } failed:^(NSError *error) {
        NSLog(@"request failed");
    }];
}

- (void)_cashTest {
    //常见异常1---不存在方法引用
    
//        [self performSelector:@selector(thisMthodDoesNotExist) withObject:nil];
    
    //常见异常2---键值对引用nil
    
    //    [[NSMutableDictionary dictionary] setObject:nil forKey:@"nil"];
    
    //常见异常3---数组越界
    
//    [[NSArray array] objectAtIndex:1];
    
    //常见异常4---memory warning 级别3以上
    
    //    [self performSelector:@selector(killMemory) withObject:nil];
}

- (IBAction)pushNext:(UIButton *)sender {
    [self pushNext];
}

- (void)pushNext {
    NextViewController *vc = [[NextViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)pushTest {
    TestViewController *vc = [[TestViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HomeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[HomeCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    HomeCellViewModel *cViewModel = self.viewModel.dataSource[indexPath.row];
    [cell bindViewModel:cViewModel];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
//            [self pushTest];
            [self _appendDataTest];
            break;
        default:
//            [self pushNext];
            self.viewModel.title.value = [NSString stringWithFormat:@"the %@ row",@(indexPath.row)];
            break;
    }
}

#pragma mark - Getter | Setter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.rowHeight = 44.0;
        [_tableView registerNib:[UINib nibWithNibName:@"HomeCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    }
    return _tableView;
}

- (HomeViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[HomeViewModel alloc]init];
    }
    return _viewModel;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
