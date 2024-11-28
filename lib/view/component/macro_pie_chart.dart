import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

class MacroPieChart extends PieChart {
  MacroPieChart(
    Color primaryContainerColor,
    Color secondaryContainerColor,
    Color tertiaryContainerColor,
    double cals,
    double protein,
    double carbs,
    double fats, {
    super.key,
    Map<String, double>? dataMap,
    List<Color>? colorList,
    ChartType? chartType,
    double? chartRadius,
    String? centerText,
    ChartValuesOptions? chartValuesOptions,
    LegendOptions? legendOptions,
    double? ringStrokeWidth,
  }) : super(
          dataMap: dataMap ??
              {
                'Protein': protein * 4,
                'Carbohydrates': carbs * 4,
                'Fats': fats * 9,
              },
          colorList: colorList ??
              [
                primaryContainerColor,
                secondaryContainerColor,
                tertiaryContainerColor,
              ],
          chartType: chartType ?? ChartType.ring,
          chartRadius: chartRadius ?? 200,
          ringStrokeWidth: ringStrokeWidth ?? 32,
          centerText: centerText ?? '${cals.toStringAsFixed(1)} Cals',
          chartValuesOptions: chartValuesOptions ??
              const ChartValuesOptions(
                showChartValues: true,
                showChartValueBackground: true,
                showChartValuesInPercentage: true,
                showChartValuesOutside: false,
                decimalPlaces: 1,
              ),
          legendOptions: legendOptions ??
              const LegendOptions(
                legendPosition: LegendPosition.top,
                legendShape: BoxShape.circle,
                showLegendsInRow: true,
              ),
        );
}
