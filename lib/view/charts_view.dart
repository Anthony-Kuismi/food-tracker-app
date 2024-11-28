import 'package:flutter/material.dart';
import 'package:food_tracker_app/view/settings_view.dart';
import 'package:food_tracker_app/viewmodel/charts_viewmodel.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

import '../model/charts.dart';
import 'component/navbar.dart';

class ChartsView extends StatelessWidget {
  ChartsViewModel chartsViewModel;

  ChartsView({required this.chartsViewModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          automaticallyImplyLeading: false,
          title: const Text(
            'Nutrition Data Over Time',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          actions: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: Theme.of(context).colorScheme.primary,
              ),
              child: CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                child: Padding(
                  padding: EdgeInsets.only(right: 10.0),
                  child: IconButton(
                    icon:
                        const Icon(Icons.person, color: Colors.white, size: 25),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SettingsView(
                                    username: '',
                                  )));
                    },
                    iconSize: 30,
                  ),
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar:
            const NavBar(key: Key('navBar'), currentPage: 'ChartsView'),
        body: Container(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: ChartsTabView(
              viewModel: chartsViewModel,
            ),
          ),
        ));
  }
}

class ChartsTabView extends StatefulWidget {
  ChartsViewModel viewModel;

  ChartsTabView({required this.viewModel});

  Widget buildSparkLineChart(BuildContext context, List<DataPoint> data) {
    return SfSparkLineChart.custom(
      dataCount: data.length,
      xValueMapper: (int index) =>
          DateFormat('MM dd yy').format(data[index].timestamp),
      yValueMapper: (int index) => data[index].value,
      plotBand: SparkChartPlotBand(
        start: 14,
        end: 28,
        color: Colors.red.withOpacity(0.2),
        borderColor: Colors.green,
        borderWidth: 2,
      ),
      labelDisplayMode: SparkChartLabelDisplayMode.none,
      trackball: SparkChartTrackball(
        activationMode: SparkChartActivationMode.tap,
        tooltipFormatter: (TooltipFormatterDetails details) =>
            '${details.x}\n${details.y}',
      ),
      color: Theme.of(context).colorScheme.secondary,
    );
  }

  @override
  State<StatefulWidget> createState() =>
      _ChartsTabViewState(viewModel: viewModel);
}

class _ChartsTabViewState extends State<ChartsTabView>
    with TickerProviderStateMixin {
  ChartsViewModel viewModel;
  late TabController tabController;
  late TabController dateController;
  late TabBarView charts;

  _ChartsTabViewState({required this.viewModel});

  get weightChart {
    if (viewModel.isLoading) {
      return Text('Loading!');
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4),
        child: Column(
          children: [
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              child: Padding(
                padding: const EdgeInsets.all(0),
                child: SizedBox(
                  height: 250,
                  child: SfCartesianChart(
                    primaryXAxis: DateTimeAxis(),
                    series: <CartesianSeries>[
                      LineSeries<DataPoint, dynamic>(
                          dataSource: viewModel.weight,
                          xValueMapper: (DataPoint item, _) => item.timestamp,
                          yValueMapper: (DataPoint item, idx) {
                            return item.value;
                          },
                          color: Theme.of(context).colorScheme.primaryContainer)
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

  get caloriesChart {
    if (viewModel.isLoading) {
      return Text('Loading!');
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4),
        child: Column(
          children: [
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              child: Padding(
                padding: const EdgeInsets.all(0),
                child: SizedBox(
                  height: 250,
                  child: SfCartesianChart(
                    primaryXAxis: DateTimeAxis(),
                    series: <CartesianSeries>[
                      LineSeries<DataPoint, dynamic>(
                          dataSource: viewModel.calories,
                          xValueMapper: (DataPoint item, _) => item.timestamp,
                          yValueMapper: (DataPoint item, idx) {
                            return item.value;
                          },
                          color: Theme.of(context).colorScheme.primaryContainer)
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

  get proteinTotalGChart {
    if (viewModel.isLoading) {
      return Text('Loading!');
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
        child: Column(
          children: [
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              child: Padding(
                padding: const EdgeInsets.all(0.0),
                child: SizedBox(
                  height: 250,
                  child: SfCartesianChart(
                    primaryXAxis: DateTimeAxis(),
                    series: <CartesianSeries>[
                      LineSeries<DataPoint, dynamic>(
                          dataSource: viewModel.proteinTotalG,
                          xValueMapper: (DataPoint item, _) => item.timestamp,
                          yValueMapper: (DataPoint item, _) => item.value,
                          color: Theme.of(context).colorScheme.primaryContainer)
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

  get carbohydratesTotalGChart {
    if (viewModel.isLoading) {
      return Text('Loading!');
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
        child: Column(
          children: [
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              child: Padding(
                padding: const EdgeInsets.all(0.0),
                child: SizedBox(
                  height: 250,
                  child: SfCartesianChart(
                    primaryXAxis: DateTimeAxis(),
                    series: <CartesianSeries>[
                      LineSeries<DataPoint, dynamic>(
                          dataSource: viewModel.carbohydratesTotalG,
                          xValueMapper: (DataPoint item, _) => item.timestamp,
                          yValueMapper: (DataPoint item, _) => item.value,
                          color: Theme.of(context).colorScheme.primaryContainer)
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

  get fatsTotalGChart {
    if (viewModel.isLoading) {
      return Text('Loading!');
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
        child: Column(
          children: [
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              child: Padding(
                padding: const EdgeInsets.all(0.0),
                child: SizedBox(
                  height: 250,
                  child: SfCartesianChart(
                    primaryXAxis: DateTimeAxis(),
                    series: <CartesianSeries>[
                      LineSeries<DataPoint, dynamic>(
                          dataSource: viewModel.fatTotalG,
                          xValueMapper: (DataPoint item, _) => item.timestamp,
                          yValueMapper: (DataPoint item, _) => item.value,
                          color: Theme.of(context).colorScheme.primaryContainer)
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

  DateTime startDate = DateTime.now().subtract(Duration(days: 7));
  DateTime endDate = DateTime.now();

  Future<void> _pickStartDate(BuildContext context, ChartsViewModel viewModel,
      String selectedOption, int dateModifier) async {
    switch (selectedOption) {
      case '1w':
        await viewModel.updateStart(DateTime.now().subtract(
            Duration(days: (7 * (viewModel.dateModifier + 1)) as int)));
        break;
      case '4w':
        await viewModel.updateStart(DateTime.now().subtract(
            Duration(days: (28 * (viewModel.dateModifier + 1)) as int)));
        break;
      case '3m':
        await viewModel.updateStart(DateTime.now().subtract(
            Duration(days: (90 * (viewModel.dateModifier + 1)) as int)));
        break;
      case '1y':
        await viewModel.updateStart(DateTime.now().subtract(
            Duration(days: (365 * (viewModel.dateModifier + 1)) as int)));
        break;
    }
    print('Start Date: ${viewModel.start}');
    setState(() {});
  }

  Future<void> _pickEndDate(BuildContext context, ChartsViewModel viewModel,
      String selectedOption, int modifier) async {
    await viewModel.updateEnd(DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day));
    print('End Date: ${viewModel.end}');
  }

  late String selectedOption = viewModel.periods[viewModel.currentDateTabIndex];
  late int modifier = viewModel.dateModifier;

  @override
  void initState() {
    super.initState();
    tabController = TabController(
        length: viewModel.labels.length,
        vsync: this,
        initialIndex: viewModel.currentTabIndex);
    dateController = TabController(
        length: viewModel.periods.length,
        vsync: this,
        initialIndex: viewModel.currentDateTabIndex);

    dateController.addListener(() {
      if (!dateController.indexIsChanging) {
        viewModel.currentDateTabIndex = dateController.index;
        int selectedIndex = dateController.index;
        selectedOption = viewModel.periods[selectedIndex];
        _pickStartDate(context, viewModel, selectedOption, modifier);
      } else {
        viewModel.dateModifier = 0;
      }
    });
    tabController.addListener(() {
      if (tabController.indexIsChanging) {
        viewModel.currentTabIndex = tabController.index;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    updateCharts();
    return FutureProvider(
      create: (BuildContext context) {
        return viewModel.initializeChartsModel();
      },
      initialData: null,
      child: Column(
        children: [
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 2 / 3,
              decoration: BoxDecoration(
                color: Colors.black45,
                borderRadius: BorderRadius.circular(10),
              ),
              child: TabBar(
                controller: dateController,
                isScrollable: false,
                indicator: UnderlineTabIndicator(borderSide: BorderSide.none),
                dividerColor: Colors.transparent,
                labelColor: Theme.of(context).colorScheme.primary,
                unselectedLabelColor: Colors.grey,
                tabs: viewModel.periods
                    .map<Tab>((periods) => Tab(text: periods))
                    .toList(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                child: IconButton(
                  icon: Icon(Icons.arrow_left, color: Colors.white),
                  onPressed: () {
                    viewModel.dateModifier++;
                    _pickStartDate(context, viewModel, selectedOption,
                        viewModel.dateModifier);
                    _pickEndDate(context, viewModel, selectedOption,
                        viewModel.dateModifier);
                  },
                ),
              ),
              Text(
                '${viewModel.start.month}/${viewModel.start.day}/${viewModel.start.year} - ${viewModel.end.month}/${viewModel.end.day}/${viewModel.end.year}',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                child: IconButton(
                  icon: Icon(Icons.arrow_right, color: Colors.white),
                  onPressed: () {
                    if (viewModel.dateModifier > 0) {
                      viewModel.dateModifier--;
                    }
                    _pickStartDate(context, viewModel, selectedOption,
                        viewModel.dateModifier);
                  },
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
          ),
          Container(
            child: charts,
            height: 270,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
          ),
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.black45,
                borderRadius: BorderRadius.circular(10),
              ),
              child: TabBar(
                controller: tabController,
                isScrollable: false,
                indicator: UnderlineTabIndicator(borderSide: BorderSide.none),
                dividerColor: Colors.transparent,
                labelColor: Theme.of(context).colorScheme.primary,
                labelStyle:
                    TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                unselectedLabelColor: Colors.grey,
                tabs: viewModel.labels
                    .map<Tab>((labels) => Tab(
                          text: labels,
                        ))
                    .toList(),
                tabAlignment: TabAlignment.fill,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    tabController.dispose();
    dateController.dispose();
    super.dispose();
  }

  void updateCharts() {
    setState(() {
      charts = TabBarView(controller: tabController, children: [
        weightChart,
        caloriesChart,
        proteinTotalGChart,
        carbohydratesTotalGChart,
        fatsTotalGChart,
      ]);
    });
  }
}
